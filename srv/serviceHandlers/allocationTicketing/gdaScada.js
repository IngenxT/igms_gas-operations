// ── Allocation & Ticketing — GDA SCADA segments (Own/Hybrid/TP/Entry Point) ──
// Single responsibility: fetch the day's YGMS_ALLOCATION_GAS_DATASet and shape
// it into the four SCADA Measurement tabs the frontend renders. Backs the
// getGasAllocationData function; row-shaping logic itself lives in gdaTransform.js.
const cds = require('@sap/cds');
const gdaTransform = require('./gdaTransform');
const nomCache = require('./nomCache');
const { normDoc } = require('../../utils/nomSourceFetch');
// TransportSystem-only resolution — same utility BNS's before:READ hook and
// scheduledNomItems.js/nomSummary.js use.
const { resolveLocationsByTS } = require('../../utils/locationResolver');

module.exports = async (srv) => {
  const YGMS_GAS_ALLOCATION_SRV = await cds.connect.to('YGMS_GAS_ALLOCATION_SRV');
  const GMSVALUEHELP_SRV = await cds.connect.to('GMSVALUEHELP_SRV');

  srv.on('getGasAllocationData', async req => {
    const log = cds.log('getGasAllocationData');
    const {
      Gasday,
      Locations,
      TransportSystem
    } = req.data;
    const cacheEntry = nomCache.cache.get(Gasday);
    const EMPTY_RESULT = { ownRows: [], hybridRows: [], tpRows: [], epRows: [] };

    // Same Gasday/TransportSystem/DeliveryPoint/RedeliveryPoint routing as
    // getScheduledNomItemsWithSCADA/getNomSummary — TransportSystem only
    // resolved when Locations is empty, ignored otherwise. A TS that resolves
    // to zero locations must show zero readings here too (not fall through to
    // "no location filter = every cached location"), same as
    // getScheduledNomItemsWithSCADA returning an empty result outright.
    let sEffectiveLocations = Locations || '';
    if (!sEffectiveLocations && TransportSystem) {
      const tsysts = String(TransportSystem).split(',').map(s => s.trim()).filter(Boolean);
      if (tsysts.length) {
        try {
          const { deliveryLocids, redeliveryLocids } = await resolveLocationsByTS(GMSVALUEHELP_SRV, tsysts);
          const aTsLocids = [...new Set([...deliveryLocids, ...redeliveryLocids])];
          if (!aTsLocids.length) return EMPTY_RESULT;
          sEffectiveLocations = aTsLocids.join(',');
        } catch (err) {
          log.error(`[getGasAllocationData] locid resolution failed tsysts=[${tsysts}]`, err);
        }
      }
    }

    // Same CorrespondingDocNo-linked expansion runAllocation/saveAllocationByGasDay
    // apply (nomCache.expandLinkedLocations) — e.g. selecting only Redelivery Point
    // C10328 must also admit its linked ZGT1 Delivery-leg Business Location
    // (MANDAPETA) here, or that Delivery Point's Entry Point reading resolves a
    // real Location (epVbelnToLocation, below) that then gets filtered straight
    // back out by inScope() since it was never in the toolbar's own raw selection —
    // exactly why the Entry Point tab came back empty for a Redelivery-only filter
    // even though the reading itself was fetched and resolved correctly.
    const locSet = sEffectiveLocations && cacheEntry
      ? nomCache.expandLinkedLocations(cacheEntry, new Set(sEffectiveLocations.split(',').filter(Boolean)))
      : (sEffectiveLocations ? new Set(sEffectiveLocations.split(',').filter(Boolean)) : null);

    // Only locations actually present in this Gasday's scheduled nomination data
    // (a DeliveryPoint or RedeliveryPoint on some ScheduledNomItems row) may ever
    // show a reading in the SCADA Measurement table — a location with a real GDA
    // meter reading but no nomination for this Gasday is genuine upstream noise
    // (already tracked separately as an Orphan Reading Data Issue in
    // getScheduledNomItemsWithSCADA) and must never be shown here regardless of
    // the toolbar's own Location filter. Cache miss (Go not pressed yet for this
    // Gasday) means no scheduled data exists at all, so every segment below
    // correctly comes back empty rather than showing unfiltered SCADA noise.
    const scheduledLocs = new Set();
    for (const r of cacheEntry?.data || []) {
      if (r.DeliveryPoint) scheduledLocs.add(r.DeliveryPoint);
      if (r.RedeliveryPoint) scheduledLocs.add(r.RedeliveryPoint);
    }
    const inScope = loc => scheduledLocs.has(loc) && (!locSet || !locSet.size || locSet.has(loc));

    // Fetch all rows without $filter — the SAP backend rejects any $filter expression
    // because every field is @sap.filterable:'false'. Filter client-side instead.
    const toDateStr = v => v instanceof Date ?
      v.toISOString().substring(0, 10) :
      String(v ?? '').substring(0, 10);
    const targetDate = toDateStr(Gasday);
    const gasdayParam = targetDate + 'T00:00:00';

    // Always fetch fresh from S/4 — no caching of YGMS_ALLOCATION_GAS_DATASet rows.
    // A reading can be deleted directly in the S/4 table outside any of this app's own
    // save/confirm/ticket flows, which are the only things that used to invalidate a
    // cached copy; without a real invalidation hook for that case, a stale cached row
    // kept showing on the UI after the S/4 data was gone. Simplest correct fix: never
    // cache this fetch, so every getGasAllocationData call reflects current S/4 state.
    const allRows = await YGMS_GAS_ALLOCATION_SRV.run(
      SELECT.from('YGMS_ALLOCATION_GAS_DATASet').where({
        YydateGas: gasdayParam
      })
    );
    // Compute OWN/HYBRID/THIRDPARTY/EntryPoint from the FULL Gasday dataset — do not
    // pre-filter by Locations here. The Scheduled Items table independently expands
    // beyond the user's selected locations via CorrespondingDocNo-linked contracts
    // (resolveCorrespondingDocs/resolveLinkedContracts), so a blanket YybusLocation
    // filter at this stage silently drops SCADA readings for those linked rows.
    // Entry Point rows carry no location field at the raw GDA level — Location is
    // resolved below via epVbelnToLocation — so Entry Point can't be filtered here
    // either; Own/Hybrid/Third-Party/EntryPoint are ALL filtered, but only after
    // their own full-day computation (shadowing/bifurcation math needs the complete
    // picture, and EntryPoint's Location isn't even known until it's resolved), see below.
    const rows = (Array.isArray(allRows) ? allRows : (allRows?.value ?? []))
      .filter(r => toDateStr(r.YydateGas) === targetDate);

    const ownRaw = [],
      hybridRaw = [],
      tpCvRaw = [],
      tpAllocRaw = [],
      epRaw = [];
    for (const r of rows) {
      switch (r.Yy_Indicator) {
        case 'OWN':
          ownRaw.push(r);
          break;
        case 'HYBRID':
          hybridRaw.push(r);
          break;
        case 'THIRDPARTY':
          parseFloat(r.YygcvNgail) > 0 ? tpCvRaw.push(r) : tpAllocRaw.push(r);
          break;
      }
      // Entry Point allocation rows are identified independently of Yy_Indicator —
      // they carry a populated YvbelnEp (SD Document), keyed by Gasday+Vbeln+Customer.
      if (String(r.YvbelnEp || '').trim()) epRaw.push(r);
    }

    const ownDeduped = gdaTransform.dedupOwn(ownRaw);
    const hybridLocKeys = new Set(hybridRaw.map(r => r.YybusLocation));

    // Entry Point readings carry no location field of their own — resolve one via
    // the same Redelivery.Contract(==YvbelnEp) → CorrespondingDocNo → Delivery.Location
    // hop getScheduledNomItemsWithSCADA already computed and cached (epVbelnToLocation),
    // keyed by normDoc(YvbelnEp) there — normalize the raw row's YvbelnEp the same way
    // here or a zero-padding mismatch (see normDoc's own doc comment) silently misses
    // the lookup and leaves Location blank even though it was actually resolved.
    // Cache miss (Go not pressed yet for this Gasday) also just leaves Location blank.
    // Resolved (and the resulting epLocKeys below) BEFORE pureOwn so the OWN-row
    // exclusion a few lines down can see which locations Entry Point actually covers.
    const epVbelnToLocation = cacheEntry?.epVbelnToLocation;
    const epRowsResolved = gdaTransform.dedupEntryPoint(epRaw).map(r => {
      const locInfo = epVbelnToLocation?.get(normDoc(r.YvbelnEp));
      return {
        ...r,
        Location: locInfo?.Location || '',
        LocationDesc: locInfo?.LocationDesc || '',
        Contract: locInfo?.Contract || '',
        // getScheduledNomItemsWithSCADA's own ConversionRequest-based SM3 conversion of
        // YdpalcqtyEp (see scheduledNomItems.js's epResolved) — S/4's own YalcsqtyEp is
        // not reliably kept in sync with the CM meter's actual GCV/NCV, so it is
        // overridden here wherever that conversion actually ran; flattenEntryPoint's
        // own _allocQty/Balance math (gdaTransform.js) reads YalcsqtyEp, so this is the
        // one place that needs to change for both to reflect the converted figure.
        YalcsqtyEp: locInfo?.ConvertedQty != null ? locInfo.ConvertedQty : r.YalcsqtyEp
      };
    });
    // Locations where an Entry Point contract's own resolved Location matches an OWN
    // meter reading — flattenEntryPoint (gdaTransform.js) already groups exactly these
    // into its GROUP/ITEM/BALANCE breakdown; the OWN row for that same Location must
    // not ALSO keep showing plainly in the OWN tab, same "moved out, not duplicated"
    // treatment hybridLocKeys already gives a HYBRID-covered OWN row below.
    const ownLocSet = new Set(ownDeduped.map(r => r.YybusLocation));
    const epLocKeys = new Set(epRowsResolved.map(r => r.Location).filter(loc => loc && ownLocSet.has(loc)));

    // OWN rows whose location is covered by a HYBRID group are the primary meter, and
    // OWN rows whose location matches an Entry Point contract (epLocKeys) — neither
    // must appear in the OWN table; both are needed instead for HYBRID bifurcation /
    // Entry Point's own GROUP/ITEM/BALANCE breakdown respectively.
    let pureOwn = ownDeduped
      .filter(r => !hybridLocKeys.has(r.YybusLocation) && !epLocKeys.has(r.YybusLocation))
      .map(r => ({
        Yycustomer: r.Yycustomer || '',
        YybusLocation: r.YybusLocation || '',
        YydateGas: r.YydateGas || null,
        YycumVolCm: parseFloat(r.YycumVolCm || 0),
        YyavgGcvCm: parseFloat(r.YyavgGcvCm || 0),
        YyavgNcvCm: parseFloat(r.YyavgNcvCm || 0),
        YytimeCm: r.YytimeCm || '00:00:00',
        YycdateCm: r.YycdateCm || null
      }));

    let hybridRows = gdaTransform.flattenHybrid(hybridRaw, ownDeduped);
    let tpRows = gdaTransform.mergeThirdParty(tpAllocRaw, tpCvRaw);

    // Narrow to scheduled locations (mandatory) plus the toolbar's own Location
    // filter (optional, further narrows within that) — matches the
    // Delivery/Redelivery/Interconnect Point filters selected in the toolbar above.
    pureOwn = pureOwn.filter(r => inScope(r.YybusLocation));
    hybridRows = hybridRows.filter(r => inScope(r.YybusLocation));
    tpRows = tpRows.filter(r => inScope(r.YybusLocation));

    // Bifurcation against ownDeduped (full day, pre-Hybrid/EP-exclusion) — a location can
    // carry both a Hybrid split and Entry Point contracts against the same CM reading,
    // independently of each other, same as Hybrid's own Primary/Secondary split above.
    let epRows = gdaTransform.flattenEntryPoint(epRowsResolved, ownDeduped);

    // Narrow to scheduled + toolbar-selected locations, same as Own/Hybrid/Third-Party
    // above — safe since every row here (GROUP/ITEM/BALANCE, or the flat passthrough
    // for unresolved/no-CM rows) carries the resolved Location.
    epRows = epRows.filter(r => inScope(r.Location));

    return {
      ownRows: pureOwn,
      hybridRows,
      tpRows,
      epRows
    };
  });



};
