// ── Allocation & Ticketing — in-memory Scheduled-Nomination cache ────────────
// Single responsibility: own the request-lifetime cache of enriched Scheduled
// Nomination Items (keyed by Gasday) and the pure functions that read it —
// nothing here calls an external service.
//
// True singleton by construction — Node's require() cache means every module
// that requires this file (scheduledNomItems.js, nomSummary.js, runAllocationSave.js,
// processTicketing.js, gdaChangeDetection.js, gdaScada.js, and
// ConfirmNomNAlloc_service.js's Nomination Confirmation handlers, which invalidate it
// on confirm) shares the exact same Map instance. Requires `instances: 1` in
// production, same constraint as srv/utils/bnsCache.js.
//
// Populated by getScheduledNomItemsWithSCADA (explicit Go press).
// Cleared by createConfirmNom and CREATE SaveTicketData. RunAllocateSave updates
// SavedAllocatedQty in place for rows S/4 accepted.
// No TTL — cache lives between Go press and Save so user edits are never silently lost.
// Each entry is the UNION of every Location ever fetched for its Gasday, not just the
// most recent Go-press's own (possibly Location-filtered) fetch — getScheduledNomItemsWithSCADA
// purges/refreshes only the Locations it just touched (entry.rawNomSource/rawGda) and carries
// every other previously-fetched Location's raw rows forward before re-deriving every other
// field here. This is load-bearing: runAllocationSave/processTicketing/gdaChangeDetection all
// read entry.data (and the other derived Maps) assuming it covers every Location they need, not
// just whatever the last Go-press's LocationFilter happened to be.
const _nomCache = new Map();

// Shared rank comparator: 1 = highest priority, 0 and null/empty = last
const _rankOrder = r => {
  if (r.Rank == null || r.Rank === '' || isNaN(Number(r.Rank))) return Number.MAX_SAFE_INTEGER;
  const n = Number(r.Rank);
  return n <= 0 ? Number.MAX_SAFE_INTEGER - 1 : n;
};

// Sort order for CustomerKind: blank(OWN)=0, PRIMARY=1, HYBRID=2, other(TP)=3
const _custKindOrder = (kind) => !kind ? 0 : kind === 'PRIMARY' ? 1 : kind === 'HYBRID' ? 2 : 3;

// ServiceType sort bucket: FIRM=0, FALLBACK=1, anything else=2
const _stBucket = st => {
  const s = (st || '').trim().toUpperCase();
  return s === 'FIRM' ? 0 : s === 'FALLBACK' ? 1 : 2;
};

// Normalise a Gasday value to 'yyyy-MM-dd' for reliable lexicographic sort.
// CAP may return Edm.Date as a JS Date object; String(Date) is locale-dependent
// and does not sort chronologically, so we always convert to ISO slice.
const _toIsoDate = v => {
  if (!v) return '';
  if (v instanceof Date) return v.toISOString().slice(0, 10);
  return String(v).slice(0, 10); // already 'yyyy-MM-dd' from server
};

/**
 * Computes a NomSummary from a cache entry.
 * Filters to LocationFilter (comma-separated) when provided.
 * PartnerFilter (comma-separated "Partner__Location" pairs — same key shape as
 * allocationActions._getSelectedTpPairs) narrows further: any Location that appears
 * in one of these pairs is THIRD-PARTY partner-scoped, so only rows matching one of
 * its selected Partners are kept for that Location; a Location present in
 * LocationFilter but absent from PartnerFilter (OWN/HYBRID/ENTRYPOINT — always
 * Location-based, no Customer grain) is unaffected, same as today. Without this, a
 * THIRD-PARTY row selection (Location + Customer scope) counted every OTHER
 * partner's items at that same Business Location too.
 * Only SCADA locations that also have nomination items are included in MeteredQty.
 */
const _computeSummary = (entry, LocationFilter, PartnerFilter) => {
  let data = entry.data;
  const locSet = LocationFilter ?
    new Set(LocationFilter.split(',').filter(Boolean)) :
    null;

  if (locSet && locSet.size) data = data.filter(r => locSet.has(r.Location));

  if (PartnerFilter) {
    const pairSet = new Set(PartnerFilter.split(',').filter(Boolean)); // "Partner__Location"
    const partnerScopedLocs = new Set([...pairSet].map(k => k.slice(k.indexOf('__') + 2)));
    if (partnerScopedLocs.size)
      data = data.filter(r => !partnerScopedLocs.has(r.Location) || pairSet.has(`${r.Partner}__${r.Location}`));
  }

  const nomLocSet = new Set(data.map(r => r.Location).filter(Boolean));
  const total = data.length;
  const aggrQty = data.reduce((s, r) => s + parseFloat(r.ConversionQty || 0), 0);
  const aggrUom = (data.find(r => r.ConversionUOM) || {}).ConversionUOM || 'SM3';

  // DP/RDP split — same ConversionQty sum, scoped by LocationType so the toolbar
  // can show Delivery-Point vs Redelivery-Point DNQ separately instead of one blend.
  const dpRows = data.filter(r => r.LocationType === 'DELIVERY');
  const rdpRows = data.filter(r => r.LocationType === 'REDELIVERY');
  const aggrQtyDP = dpRows.reduce((s, r) => s + parseFloat(r.ConversionQty || 0), 0);
  const aggrQtyRDP = rdpRows.reduce((s, r) => s + parseFloat(r.ConversionQty || 0), 0);
  const aggrUomDP = (dpRows.find(r => r.ConversionUOM) || {}).ConversionUOM || aggrUom;
  const aggrUomRDP = (rdpRows.find(r => r.ConversionUOM) || {}).ConversionUOM || aggrUom;

  // A Business Location can carry Delivery and Redelivery rows at once (interconnect),
  // so its side is decided from all of its rows, not just the first one seen.
  const dpLocs = new Set(dpRows.map(r => r.Location).filter(Boolean));
  const rdpLocs = new Set(rdpRows.map(r => r.Location).filter(Boolean));

  // Metered reading. Redelivery side: the location's physical meter (entry.scadaAgg —
  // OWN/HYBRID meter or TP customer uploads). Delivery side: the Entry Point CM meter
  // (entry.epQtyByLocation), else the location's own meter — same precedence
  // RunAllocateSave uses. Never ConversionQty (DNQ) as a stand-in: that is not a reading.
  let aggrMetered = 0, aggrMeteredDP = 0, aggrMeteredRDP = 0;
  let meteredUom = '', meteredUomDP = '', meteredUomRDP = '';
  for (const loc of nomLocSet) {
    const scada = entry.scadaAgg.get(loc);
    const epQty = entry.epQtyByLocation?.get(loc) || 0;

    if (rdpLocs.has(loc) && scada) {
      aggrMeteredRDP += scada.totalMR;
      if (!meteredUomRDP) meteredUomRDP = scada.unit;
    }
    if (dpLocs.has(loc)) {
      const dpQty = epQty > 0 ? epQty : (scada?.totalMR || 0);
      if (dpQty > 0) {
        aggrMeteredDP += dpQty;
        if (!meteredUomDP) meteredUomDP = epQty > 0 ? 'SM3' : scada.unit;
      }
    }

    const locQty = scada ? scada.totalMR : epQty;
    if (locQty > 0) {
      aggrMetered += locQty;
      if (!meteredUom) meteredUom = scada ? scada.unit : 'SM3';
    }
  }

  // Allocated total = Σ (AllocatedQty + OverDrawlGSA), split DP/RDP like the DNQ totals.
  const _allocSum = rows => rows.reduce((s, r) => s + (parseFloat(r.AllocatedQty || 0) + parseFloat(r.OverDrawlGSA || 0)), 0);
  const _allocUom = rows => (rows.find(r => r.AllocUOM) || {}).AllocUOM || 'SM3';

  return {
    TotalCount: total,
    AggrApprovedQty: parseFloat(aggrQty.toFixed(3)),
    AggrUOM: aggrUom,
    AggrApprovedQtyDP: parseFloat(aggrQtyDP.toFixed(3)),
    AggrUOMDP: aggrUomDP,
    AggrApprovedQtyRDP: parseFloat(aggrQtyRDP.toFixed(3)),
    AggrUOMRDP: aggrUomRDP,
    AggrMeteredQtyDP: parseFloat(aggrMeteredDP.toFixed(3)),
    MeteredUOMDP: meteredUomDP,
    AggrMeteredQtyRDP: parseFloat(aggrMeteredRDP.toFixed(3)),
    MeteredUOMRDP: meteredUomRDP,
    AggrMeteredQty: parseFloat(aggrMetered.toFixed(3)),
    MeteredUOM: meteredUom,
    AggrAllocatedQty: parseFloat(_allocSum(data).toFixed(3)),
    AllocatedUOM: _allocUom(data),
    AggrAllocatedQtyDP: parseFloat(_allocSum(dpRows).toFixed(3)),
    AllocatedUOMDP: _allocUom(dpRows),
    AggrAllocatedQtyRDP: parseFloat(_allocSum(rdpRows).toFixed(3)),
    AllocatedUOMRDP: _allocUom(rdpRows)
  };
};

/**
 * Expands a Location Set (Simulate/Allocate & Save's own `Locations` filter) to
 * include every Business Location CorrespondingDocNo-linked to a Location already in
 * it — e.g. selecting a Redelivery Point (C10551) whose Redelivery contract's
 * CorrespondingDocNo points to a Delivery-leg contract at a different Business
 * Location pulls that Delivery Point's ENTIRE Business Location in too (every
 * contract/customer there, not just the one paired contract), so the run covers both
 * sides of the same commercial pairing instead of silently leaving the linked side
 * stale. Symmetric by construction — a Redelivery row's own CorrespondingDocNo points
 * at its Delivery counterpart's Contract and vice versa, so the same single pass
 * naturally works in either direction without special-casing which side was selected.
 * The linked-in rows are already present in entry.data regardless of which
 * LocationFilter was last Go-pressed — see getScheduledNomItemsWithSCADA step 1a's
 * unconditional resolveCorrespondingDocs merge — so this never needs its own S/4 fetch.
 * No new gating: linked-in items flow through every existing gate/resolution path
 * (Mode A pass-through, Mode B entryPointAllocation, normal RDP phase pooling)
 * exactly as an explicitly-selected Location's items would.
 * Ticketing's own Allocate & Save-equivalent run scope (ticketingActions.js's
 * locationsToTicket) does NOT use this — a CorrespondingDocNo-linked Location that
 * wasn't itself selected still isn't eligible for ticketing on its own.
 * @param {{data: object[]}} entry - nomCache cache entry
 * @param {Set<string>} locSet - explicitly-selected locations (not mutated)
 * @returns {Set<string>} a NEW Set — locSet plus every linked Location found
 */
const _expandLinkedLocations = (entry, locSet) => {
  if (!locSet || !locSet.size) return locSet; // no filter = every Location already
  const contractToLoc = new Map();
  for (const r of entry.data)
    if (r.Contract && !contractToLoc.has(String(r.Contract))) contractToLoc.set(String(r.Contract), r.Location);

  const expanded = new Set(locSet);
  for (const r of entry.data) {
    if (!locSet.has(r.Location)) continue;
    const doc = String(r.CorrespondingDocNo || '').trim();
    if (!doc) continue;
    const linkedLoc = contractToLoc.get(doc);
    if (linkedLoc) expanded.add(linkedLoc);
  }
  return expanded;
};

module.exports = {
  cache: _nomCache,
  computeSummary: _computeSummary,
  rankOrder: _rankOrder,
  custKindOrder: _custKindOrder,
  stBucket: _stBucket,
  toIsoDate: _toIsoDate,
  expandLinkedLocations: _expandLinkedLocations
};
