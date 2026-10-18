// ── Allocation & Ticketing — GDA (SCADA) row transformation ──────────────────
// Single responsibility: reshape raw YGMS_ALLOCATION_GAS_DATASet rows into the
// per-segment (Own/Hybrid/Third-Party/Entry-Point) display rows getGasAllocationData
// returns. Pure functions only — no external service calls, no cache access.
const allocationUtils = require('../../utils/allocationUtils');

// S/4 sends a blank string ('') for "no reading", indistinguishable from a genuine
// 0/0.000 reading once naively coerced via `parseFloat(v || 0)` (0 is falsy too,
// but so is '' — both collapsed to the same 0). Preserves the blank as null instead,
// so downstream formatters (fmtHHQty) can tell "no data" (null → "—") apart from
// "reading is genuinely zero" (0 → "0.000").
function _numOrNull(v) {
  if (v === null || v === undefined || v === '') return null;
  const n = parseFloat(v);
  return isNaN(n) ? null : n;
}

function _srvDedupOwn(rows) {
  const oMap = new Map();
  rows.forEach(r => {
    // Exclude YydateGas from key — it's a Timestamp and Date.toString() is timezone-dependent.
    // All rows are already pre-filtered to one gas day so loc+partner is sufficient.
    const k = `${r.Yycustomer}__${r.YybusLocation}`;
    const prev = oMap.get(k);
    if (!prev || r.YytimeCm > prev.YytimeCm) oMap.set(k, r);
  });
  const result = Array.from(oMap.values());
  result.sort((a, b) => String(a.YybusLocation).localeCompare(String(b.YybusLocation)));
  return result;
}

// Entry Point rows are keyed by Gasday+Vbeln+Customer — YydateGas is excluded from
// the key (Timestamp, timezone-dependent) since rows are already pre-filtered to one gas day.
function _srvDedupEntryPoint(rows) {
  const oMap = new Map();
  rows.forEach(r => {
    const k = `${r.YvbelnEp}__${r.Yycustomer}`;
    const prev = oMap.get(k);
    if (!prev || r.Yytimestamp > prev.Yytimestamp) oMap.set(k, r);
  });
  const result = Array.from(oMap.values()).map(r => ({
    Yycustomer: r.Yycustomer || '',
    YydateGas: r.YydateGas || null,
    YvbelnEp: r.YvbelnEp || '',
    YalcsqtyEp: _numOrNull(r.YalcsqtyEp),
    YqtyuomEp: r.YqtyuomEp || '',
    YdpalcqtyEp: _numOrNull(r.YdpalcqtyEp), // Delivery Point Alloc (MBG) — separate from YalcsqtyEp (SM3)
    // This reading's own quality figures — the only GCV/NCV available for a Location
    // with no CM/OWN meter of its own (_srvFlattenEntryPoint's passthrough branch
    // below shows these as-is; its GROUP/ITEM/BALANCE branch overrides with the CM
    // meter's own reading instead, same priority getScheduledNomItemsWithSCADA's own
    // _epQual uses). Dropped here previously, which is why a Vbeln with no OWN meter
    // at its resolved Location always showed a blank GCV/NCV in the Entry Point tab.
    YyavgGcvCm: parseFloat(r.YyavgGcvCm || 0),
    YyavgNcvCm: parseFloat(r.YyavgNcvCm || 0),
    // Upload Flag Segment — YsdqtyEp (Allocated Qty MBG) and YupdFlagEp ('X' when
    // uploaded/updated) both dropped here previously, same as GCV/NCV above.
    YsdqtyEp: _numOrNull(r.YsdqtyEp),
    YupdFlagEp: r.YupdFlagEp || ''
  }));
  result.sort((a, b) => String(a.YvbelnEp).localeCompare(String(b.YvbelnEp)));
  return result;
}

// Allocated Qty (SM3) for one Entry Point reading — YdpalcqtyEp (already SM3, S/4's
// own upload figure) when YupdFlagEp='X' marks this reading as uploaded/updated,
// else the usual YalcsqtyEp (S/4's system-computed SM3 alloc, itself possibly
// overridden upstream in gdaScada.js with this handler's own ConversionRequest
// result — see that file's comment on YalcsqtyEp).
function _epAllocQty(r) {
  // r.YdpalcqtyEp/r.YalcsqtyEp are already number|null at this point (normalized by
  // _numOrNull in _srvDedupEntryPoint) — read as-is, never re-collapse null to 0.
  return r.YupdFlagEp === 'X' ? r.YdpalcqtyEp : r.YalcsqtyEp;
}

function _srvFlattenHybrid(hybridRows, ownDeduped) {
  if (!hybridRows.length) return [];
  // Key by YybusLocation only — all rows are already pre-filtered to one gas day,
  // so including YydateGas (a Timestamp) risks key mismatches from Date.toString()
  // timezone differences between OWN and HYBRID rows returned by SAP.
  const ownMap = new Map();
  ownDeduped.forEach(r => ownMap.set(r.YybusLocation, r));

  const groups = new Map();
  hybridRows.forEach(r => {
    const k = r.YybusLocation;
    if (!groups.has(k)) groups.set(k, []);
    groups.get(k).push(r);
  });

  const flat = [];
  groups.forEach((rows, k) => {
    const own = ownMap.get(k) || {};
    const scadaVol = parseFloat(own.YycumVolCm || 0);
    const sumSec = rows.reduce((s, r) => s + parseFloat(r.YyvolSm3Case2 || 0), 0);
    const diff = scadaVol - sumSec;
    const balState = diff < 0 ? 'err' : 'ok';

    flat.push({
      _type: 'GROUP',
      Yycustomer: null,
      YybusLocation: rows[0].YybusLocation,
      YydateGas: rows[0].YydateGas,
      _scadaVol: scadaVol,
      _scadaMeter: null,
      _bifurQty: null,
      _allocQty: null,
      YyavgGcvCm: null,
      YyavgNcvCm: null,
      _balState: null,
      _balDiff: null,
      _showBalance: false
    });
    flat.push({
      _type: 'PRIMARY',
      Yycustomer: own.Yycustomer || '—',
      YybusLocation: rows[0].YybusLocation,
      YydateGas: rows[0].YydateGas,
      _scadaVol: null,
      _scadaMeter: scadaVol,
      _bifurQty: diff,
      _allocQty: diff,
      YyavgGcvCm: parseFloat(own.YyavgGcvCm || 0),
      YyavgNcvCm: parseFloat(own.YyavgNcvCm || 0),
      _balState: balState,
      _balDiff: diff,
      _showBalance: true
    });
    const primaryGcv = parseFloat(own.YyavgGcvCm || 0);
    const primaryNcv = parseFloat(own.YyavgNcvCm || 0);
    rows.forEach(r => flat.push({
      _type: 'SECONDARY',
      Yycustomer: r.Yycustomer,
      YybusLocation: r.YybusLocation,
      YydateGas: r.YydateGas,
      _scadaVol: null,
      _scadaMeter: scadaVol,
      _bifurQty: parseFloat(r.YyvolSm3Case2 || 0),
      _allocQty: parseFloat(r.YyvolSm3Case2 || 0),
      YyavgGcvCm: primaryGcv,
      YyavgNcvCm: primaryNcv,
      _balState: null,
      _balDiff: null,
      _showBalance: false
    }));
  });
  return flat;
}

// Groups Entry Point rows by their resolved Location (see epVbelnToLocation in
// getGasAllocationData) and, only where that Location also has a CM/OWN meter
// reading, flattens into GROUP/ITEM/BALANCE rows the same way _srvFlattenHybrid
// splits a CM reading across Hybrid's Primary/Secondary customers — BALANCE is
// this feature's equivalent of Hybrid's PRIMARY row, holding the CM meter's
// residual after the location's EP contracts are subtracted. EP rows whose
// Location is unresolved or has no CM reading pass through unchanged (flat,
// no _type) — never blocked, exactly as before this feature existed.
function _srvFlattenEntryPoint(epRows, ownDeduped) {
  if (!epRows.length) return [];
  const ownMap = new Map();
  ownDeduped.forEach(r => ownMap.set(r.YybusLocation, r));

  const groups = new Map();
  const flat = [];
  epRows.forEach(r => {
    const loc = r.Location;
    if (!loc || !ownMap.has(loc)) {
      // No _type — fmtHHQty et al. show these plainly, same as before this feature
      // existed, just carrying _allocQty so the Qty to Allocate column (now bound
      // to _allocQty like every other row) keeps showing the real value.
      flat.push({ ...r, _allocQty: _epAllocQty(r) });
      return;
    }
    if (!groups.has(loc)) groups.set(loc, []);
    groups.get(loc).push(r);
  });

  groups.forEach((rows, loc) => {
    const own = ownMap.get(loc) || {};
    const scadaVol = parseFloat(own.YycumVolCm || 0);
    const sumEp = rows.reduce((s, r) => s + _epAllocQty(r), 0);
    const diff = parseFloat((scadaVol - sumEp).toFixed(3));
    const balState = diff < 0 ? 'err' : 'ok';
    const locDesc = rows[0].LocationDesc || '';

    // GCV/NCV are the CM/OWN meter's own quality figures — moved onto Entry Point's
    // GROUP/ITEM/BALANCE rows only where this Location has a matching CM/OWN reading
    // (i.e. only inside this groups.forEach, never the unresolved/no-CM passthrough
    // branch above), same convention _srvFlattenHybrid already uses for Hybrid.
    const epGcv = parseFloat(own.YyavgGcvCm || 0);
    const epNcv = parseFloat(own.YyavgNcvCm || 0);

    flat.push({
      _type: 'GROUP',
      Yycustomer: null,
      Location: loc,
      LocationDesc: locDesc,
      Contract: '', // whole Business Location, not one Delivery contract
      YydateGas: rows[0].YydateGas,
      YvbelnEp: '',
      YalcsqtyEp: null,
      YdpalcqtyEp: null,
      YsdqtyEp: null,
      YupdFlagEp: null,
      YyavgGcvCm: null,
      YyavgNcvCm: null,
      _scadaVol: scadaVol,
      _scadaMeter: null,
      _allocQty: null,
      _balState: null,
      _balDiff: null,
      _showBalance: false
    });
    rows.forEach(r => flat.push({
      _type: 'ITEM',
      Yycustomer: r.Yycustomer,
      Location: loc,
      LocationDesc: locDesc,
      // The one Delivery contract behind this one Entry Point reading — lets row
      // selection filter the Scheduled Item table down to just that Delivery contract
      // (deliberately excluding its Redelivery counterpart) instead of the whole
      // Location's worth of Delivery contracts (see frontend gdaScada.js's
      // _buildGdaSelectionFilter).
      Contract: r.Contract || '',
      YydateGas: r.YydateGas,
      YvbelnEp: r.YvbelnEp,
      YalcsqtyEp: r.YalcsqtyEp,
      YdpalcqtyEp: r.YdpalcqtyEp,
      YsdqtyEp: r.YsdqtyEp,
      YupdFlagEp: r.YupdFlagEp || '',
      YyavgGcvCm: epGcv,
      YyavgNcvCm: epNcv,
      _scadaVol: null,
      _scadaMeter: scadaVol,
      _allocQty: _epAllocQty(r),
      _balState: null,
      _balDiff: null,
      _showBalance: false
    }));
    flat.push({
      _type: 'BALANCE',
      Yycustomer: 'Balance (CM − Σ EP)',
      Location: loc,
      LocationDesc: locDesc,
      Contract: '', // residual against the whole Location's meter, not one contract
      YydateGas: rows[0].YydateGas,
      YvbelnEp: '',
      YalcsqtyEp: diff,
      YdpalcqtyEp: null, // no MBG residual math — MBG is per-contract only, unlike the SM3 CM balance
      YsdqtyEp: null,
      YupdFlagEp: null,
      YyavgGcvCm: epGcv,
      YyavgNcvCm: epNcv,
      _scadaVol: null,
      _scadaMeter: scadaVol,
      _allocQty: diff,
      _balState: balState,
      _balDiff: diff,
      _showBalance: true
    });
  });

  return flat;
}

function _srvMergeThirdParty(tpAllocRows, tpCvRows) {
  const cvMap = new Map();
  tpCvRows.forEach(r => {
    const k = `${r.YybusLocation}__${r.YydateGas}`;
    const prev = cvMap.get(k);
    if (!prev || r.YytimeNgail > prev.YytimeNgail) cvMap.set(k, r);
  });
  return tpAllocRows.map(r => {
    const cv = cvMap.get(`${r.YybusLocation}__${r.YydateGas}`) || {};
    const rawQty = parseFloat(r.YyallocQtyNongail || 0);
    const rawUom = String(r.YyallocUomNongail || '').trim().toUpperCase();
    const gcv = parseFloat(cv.YygcvNgail || r.YygcvNgail || 0);
    const ncv = parseFloat(cv.YyncvNgail || r.YyncvNgail || 0);
    // S/4-provided SM3 equivalent — allocation math and the "Qty to Allocate
    // (SM3)" display both use this; YyallocQtyNongail above stays the raw
    // as-uploaded reading for the "Uploaded Qty" display. Fall back to our own
    // convertToSM3(YyallocQtyNongail, GCV/NCV) per Customer+BusinessLocation when
    // S/4 hasn't converted it yet but the partner's raw upload + quality already are —
    // same fallback getScheduledNomItemsWithSCADA applies, kept in lockstep.
    // Zero raw upload always forces scm to 0, even if S/4 sent a stale non-zero
    // YyallocQtyNongailscm — a partner that uploaded nothing has nothing to allocate.
    let scmQty = rawQty > 0 ? parseFloat(r.YyallocQtyNongailscm || 0) : 0;
    if (!(scmQty > 0) && rawQty > 0 && rawUom) {
      try {
        scmQty = allocationUtils.convertToSM3(rawQty, rawUom, gcv, ncv);
      } catch {
        scmQty = 0;
      }
    }
    return {
      Yycustomer: r.Yycustomer || '',
      YybusLocation: r.YybusLocation || '',
      YydateGas: r.YydateGas || null,
      YyallocQtyNongail: rawQty,
      YyallocUomNongail: r.YyallocUomNongail || '',
      YyallocQtyNongailscm: scmQty,
      YygcvNgail: gcv,
      YyncvNgail: ncv,
      YrnameNongail: r.YrnameNongail || '',
      YrnameNagal: cv.YrnameNagal || r.YrnameNagal || '',
      YydateNongail: r.YydateNongail || null
    };
  });
}

module.exports = {
  dedupOwn: _srvDedupOwn,
  dedupEntryPoint: _srvDedupEntryPoint,
  flattenHybrid: _srvFlattenHybrid,
  flattenEntryPoint: _srvFlattenEntryPoint,
  mergeThirdParty: _srvMergeThirdParty
};
