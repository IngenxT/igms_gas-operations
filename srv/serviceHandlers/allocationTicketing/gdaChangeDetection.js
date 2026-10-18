// ── Allocation & Ticketing — GDA reading-change detection ────────────────────
// Single responsibility: detect whether the live SCADA/GDA meter reading has
// drifted from what the cache was built with, and invalidate the cache when it
// has — allocation math must never run against a stale reading. Exposed as the
// checkGdaReadingChanges action (SCADA/Scheduled Items refresh-button check).
const cds = require('@sap/cds');
const allocationUtils = require('../../utils/allocationUtils');
const nomCache = require('./nomCache');

// Live-vs-cached reading comparison behind the Refresh Scada button
// (checkGdaReadingChanges). Takes the connected service explicitly (no closure) so a
// caller with its own connection instance can reuse it.
async function _detectGdaChanges(YGMS_GAS_ALLOCATION_SRV, entry, Gasday, locSet) {
    const gasdayParam = String(Gasday).substring(0, 10) + 'T00:00:00';
    const gdaRows = await YGMS_GAS_ALLOCATION_SRV.run(
      SELECT.from('YGMS_ALLOCATION_GAS_DATASet').where({
        YydateGas: gasdayParam
      })
    );

    const freshOwnMap = new Map();
    const freshTpMeterMap = new Map();
    const freshTpGcvMap = new Map();
    // Partner__Location -> dedicated-meter qty (SM3) — same aggregation
    // scheduledNomItems.js's own hybridSecondaryMeterMap build uses, kept in lockstep
    // so this guard can catch exactly the drift that build is itself vulnerable to.
    const freshHybridSecondaryMeterMap = new Map();
    // THIRDPARTY CV rows (YygcvNgail>0) and Alloc rows (YyallocQtyNongail>0) are separate
    // rows for the same Location — see the identical comment in scheduledNomItems.js.
    // Resolve the convertToSM3 fallback in a second pass, once freshTpGcvMap is complete.
    const freshTpPendingConv = [];

    // A location can carry more than one OWN meter reading for the same Gasday (a
    // periodically-updated live SCADA feed) — freshOwnLatestTime keeps freshOwnMap
    // pinned to the reading with the latest YytimeCm, same convention gdaTransform.js's
    // _srvDedupOwn (frontend SCADA panel) and scheduledNomItems.js's own ownGcvNcvMap
    // build already use. Without this, whichever OWN row lands last in gdaRows'
    // iteration order — not necessarily the newest — silently wins, which would let a
    // genuine drift go undetected (or a non-drift misreport as one) here.
    const freshOwnLatestTime = new Map(); // loc → latest YytimeCm seen so far
    for (const r of gdaRows) {
      const loc = r.YybusLocation;
      if (!loc) continue;
      if (r.Yy_Indicator === 'OWN') {
        const prevTime = freshOwnLatestTime.get(loc);
        if (prevTime !== undefined && r.YytimeCm <= prevTime) continue;
        freshOwnLatestTime.set(loc, r.YytimeCm);
        freshOwnMap.set(loc, {
          totalMR: parseFloat(r.YycumVolCm || 0),
          gcv: parseFloat(r.YyavgGcvCm || 0),
          ncv: parseFloat(r.YyavgNcvCm || 0)
        });
      } else if (r.Yy_Indicator === 'HYBRID') {
        const customer = r.Yycustomer || '';
        if (!customer) continue;
        const qty = parseFloat(r.YyvolSm3Case2 || 0);
        const hKey = `${customer}__${loc}`;
        freshHybridSecondaryMeterMap.set(hKey, (freshHybridSecondaryMeterMap.get(hKey) || 0) + qty);
      } else if (r.Yy_Indicator === 'THIRDPARTY') {
        const gcv = parseFloat(r.YygcvNgail || 0);
        const ncv = parseFloat(r.YyncvNgail || 0);
        const rawQty = parseFloat(r.YyallocQtyNongail || 0);
        const rawUom = String(r.YyallocUomNongail || '').trim().toUpperCase();
        const scmQty = parseFloat(r.YyallocQtyNongailscm || 0);
        if (gcv > 0 && !freshTpGcvMap.has(loc))
          freshTpGcvMap.set(loc, {
            gcv,
            ncv
          });
        if (scmQty > 0) freshTpMeterMap.set(loc, (freshTpMeterMap.get(loc) || 0) + scmQty);
        else if (rawQty > 0 && rawUom) freshTpPendingConv.push({ loc, rawQty, rawUom });
      }
    }

    for (const item of freshTpPendingConv) {
      const qual = freshTpGcvMap.get(item.loc);
      if (!qual) continue;
      let qty;
      try {
        qty = allocationUtils.convertToSM3(item.rawQty, item.rawUom, qual.gcv, qual.ncv);
      } catch {
        continue;
      }
      if (qty > 0) freshTpMeterMap.set(item.loc, (freshTpMeterMap.get(item.loc) || 0) + qty);
    }

    const freshGdaAgg = new Map();
    for (const [loc, d] of freshOwnMap)
      freshGdaAgg.set(loc, {
        indicator: 'OWN',
        totalMR: d.totalMR,
        gcv: d.gcv,
        ncv: d.ncv
      });
    for (const [loc, qty] of freshTpMeterMap) {
      if (freshGdaAgg.has(loc)) continue;
      const tp = freshTpGcvMap.get(loc) || {
        gcv: 0,
        ncv: 0
      };
      freshGdaAgg.set(loc, {
        indicator: 'THIRDPARTY',
        totalMR: qty,
        gcv: tp.gcv,
        ncv: tp.ncv
      });
    }

    // Locations actually covered by the cache — getScheduledNomItemsWithSCADA now
    // merges per-Location fetches into entry (see nomCache.js) rather than always
    // holding the whole day, so a Location that was simply never Go-pressed must
    // not read as "changed" (entry.scadaAgg.get(loc) is undefined there for a
    // reason unrelated to a genuine reading drift) and trigger a full cache wipe.
    const cachedLocSet = new Set(entry.scadaAgg.keys());

    const gdaChanges = [];
    for (const [loc, freshA] of freshGdaAgg) {
      if (locSet && !locSet.has(loc)) continue;
      if (!cachedLocSet.has(loc)) continue;
      const oldA = entry.scadaAgg.get(loc);
      const newMR = parseFloat(freshA.totalMR.toFixed(3));
      const newGCV = parseFloat(freshA.gcv.toFixed(3));
      const newNCV = parseFloat(freshA.ncv.toFixed(3));
      const oldMR = oldA ? parseFloat(oldA.totalMR.toFixed(3)) : 0;
      const oldGCV = oldA ? parseFloat(oldA.gcv.toFixed(3)) : 0;
      const oldNCV = oldA ? parseFloat(oldA.ncv.toFixed(3)) : 0;
      if (!oldA || oldMR !== newMR || oldGCV !== newGCV || oldNCV !== newNCV) {
        gdaChanges.push({
          BusinessLocation: loc,
          Indicator: freshA.indicator,
          OldMeterReading: oldMR,
          NewMeterReading: newMR,
          OldGCV: oldGCV,
          NewGCV: newGCV,
          OldNCV: oldNCV,
          NewNCV: newNCV
        });
      }
    }

    // HYBRID dedicated-meter (Partner__Location) readings — same staleness risk as
    // OWN/THIRDPARTY above (the SCADA Measurements panel's own independent
    // getGasAllocationData fetch can show a newer bifurcation qty than this cache was
    // built with), but previously had no coverage here at all: a HYBRID Customer's
    // reading could arrive or change after Go with nothing to invalidate the cache,
    // so _computeAllocation would silently run Phase 2b against a stale (possibly
    // zero) entry.hybridSecondaryMeterMap value instead of being rejected. Scoped to
    // cachedLocSet the same way OWN/THIRDPARTY are — a pair whose Location was never
    // Go-pressed at all is not a drift, just uncovered.
    const cachedHybridMap = entry.hybridSecondaryMeterMap || new Map();
    for (const [hKey, freshQty] of freshHybridSecondaryMeterMap) {
      const sep = hKey.indexOf('__');
      const loc = sep >= 0 ? hKey.slice(sep + 2) : hKey;
      if (locSet && !locSet.has(loc)) continue;
      if (!cachedLocSet.has(loc)) continue;
      const oldQty = parseFloat((cachedHybridMap.get(hKey) || 0).toFixed(3));
      const newQty = parseFloat(freshQty.toFixed(3));
      if (oldQty !== newQty) {
        gdaChanges.push({
          BusinessLocation: loc,
          Indicator: 'HYBRID',
          OldMeterReading: oldQty,
          NewMeterReading: newQty,
          OldGCV: 0,
          NewGCV: 0,
          OldNCV: 0,
          NewNCV: 0
        });
      }
    }

    if (gdaChanges.length > 0) nomCache.cache.delete(Gasday);
    return gdaChanges;
}

module.exports = async (srv) => {
  const YGMS_GAS_ALLOCATION_SRV = await cds.connect.to('YGMS_GAS_ALLOCATION_SRV');

  // ── checkGdaReadingChanges — refresh-button check for SCADA Reading / Scheduled
  // Items tables ─────────────────────────────────────────────────────────────────
  // Compares the live GDA meter reading against what the cache was built from. When
  // it changed, the cache is invalidated (see _detectGdaChanges) so the frontend can
  // re-fetch getScheduledNomItemsWithSCADA and prompt the user to re-run Allocation
  // rather than silently leaving Scheduled Items showing AllocatedQty computed from a
  // now-stale reading.
  srv.on('checkGdaReadingChanges', async req => {
    const log = cds.log('checkGdaReadingChanges');
    const {
      Gasday,
      LocationFilter
    } = req.data;
    if (!Gasday) return req.reject(400, 'Gasday is required');

    const entry = nomCache.cache.get(Gasday);
    if (!entry) return []; // nothing cached yet — first fetch, not a "change"

    const locSet = LocationFilter ?
      new Set(LocationFilter.split(',').filter(Boolean)) :
      null;

    const gdaChanges = await _detectGdaChanges(YGMS_GAS_ALLOCATION_SRV, entry, Gasday, locSet);
    if (gdaChanges.length)
      log.warn(`[checkGdaReadingChanges] Gasday=${Gasday} changed=${gdaChanges.length} location(s) — cache invalidated`);
    return gdaChanges;
  });
};

module.exports.detectGdaChanges = _detectGdaChanges;
