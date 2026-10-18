// ── Allocation & Ticketing — Scheduled Nomination Items ──────────────────────
const cds = require('@sap/cds');
const allocationUtils = require('../../utils/allocationUtils');
const nomCache = require('./nomCache');
const { resolveCorrespondingDocs } = require('../balancingScheduling-service');
const {
  chunk, runChunked, buildLocFilter, buildBusLocFilter, buildVbelnFilter,
  rowKey, splitArr, dedupeLatestVersion, dedupeByNomKey, normDoc
} = require('../../utils/nomSourceFetch');
const { resolveLocationsByTS } = require('../../utils/locationResolver');

const LOC_CHUNK = 50;
const GDA_LOC_CHUNK = 12;
const CONV_CHUNK = 500;

const NOMSOURCE_COLUMNS = [
  'Gasday', 'ContractNo', 'Item', 'Versn', 'NominationItem', 'NominationKey',
  'CustomerKind', 'DeliveryPoint', 'DeliveryPointName', 'RedeliveryPoint',
  'RedeliveryPointName', 'CorrespondingDocNo', 'ContractType', 'ContractTypeName',
  'MasterContractNo', 'Partner', 'PartnerName', 'TransportSystem',
  'TransportSystemName', 'Material', 'MaterialName', 'Rank', 'DeliveryDCQ',
  'RedeliveryDCQ', 'ApprovedDNQ', 'UOM', 'SavedAllocatedQty', 'SavedAllocatedQty2',
  'SavedAllocatedUOM', 'TicketKey', 'TicketItem', 'ServiceType', 'Source',
  'TicketVersion', 'TicketPurpose', 'TicketStatus', 'TicketItemSubStatus',
  'isConfirmRequired', 'yyoij_od_qty', 'yyoij_un_qty', 'yyoij_aod_qty',
  'yyoij_unaod_qty', 'yyoij_ovr_qty', 'yyoij_aovr_qty', 'yyoij_unaovr_qty',
  'yyoij_dimb_qty', 'yyoij_cnom_qty', 'yyoij_cnom_uom', 'yyoij_status',
  'yyoij_dpimb_qty', 'yyoij_dnimb_qty', 'yyoij_cumimb_qty', 'yyoij_crgimb_qty',
  'yyoij_pos_cumimb', 'yyoij_neg_cumimb', 'yyoij_ld_a_qty', 'yyoij_ld_d_qty',
  'yyoij_sop_a_qty', 'yyoij_sop_d_qty', 'yyoij_ssf_a_qty', 'yyoij_ssf_d_qty',
  'yyoij_top_a_qty', 'yyoij_top_d_qty', 'yyoij_gta_adjust', 'yyoij_gsa_adjust',
  'yyoij_gujdnq', 'yyoij_gujdnq_uom', 'yyoij_dds_qty'
];

module.exports = async (srv) => {
  const GMSCONFIRMNOM_SRV = await cds.connect.to('GMSCONFIRMNOM_SRV');
  const YGMS_GAS_ALLOCATION_SRV = await cds.connect.to('YGMS_GAS_ALLOCATION_SRV');
  const GMSVALUEHELP_SRV = await cds.connect.to('GMSVALUEHELP_SRV');

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTION: getScheduledNomItemsWithSCADA
  // ═══════════════════════════════════════════════════════════════════════════
  srv.on('getScheduledNomItemsWithSCADA', async req => {
    const log = cds.log('ConfirmNomNAlloc');
    const { Gasday, LocationFilter, TransportSystem } = req.data;
    if (!Gasday) return req.reject(400, 'Gasday is required');

    // ── FORCE FRESH RE-WARM: Evict previous cache entry for this Gasday ──────
    nomCache.cache.delete(Gasday);
    log.info(`[getScheduledNomItemsWithSCADA] Cache evicted for Gasday ${Gasday}. Initiating clean re-warm...`);

    const tHandlerStart = Date.now();
    const tMark = (label, since) => log.info(`[getScheduledNomItemsWithSCADA][perf] Gasday=${Gasday} ${label}=${Date.now() - since}ms`);

    // ── 1. Fetch Nominations from Remote S/4 ──────────────────────────────────
    const tNomFetchStart = Date.now();
    const oFetchParams = { Gasday, LocationFilter, TransportSystem };
    let { aScheduled, attemptedLocs, attemptedAll, sEffectiveLocationFilter } =
      await _fetchBaseNominations(GMSCONFIRMNOM_SRV, GMSVALUEHELP_SRV, oFetchParams, log);
    // Snapshot of the nominations this load was built from — checkNominationChanges
    // re-runs the same fetch and diffs against it before Ticketing.
    const baseNomKeys = _nomChangeIndex(aScheduled);
    tMark('nomsourceFetch', tNomFetchStart);

    if (!aScheduled.length) {
      return [_buildEmptyResultPayload()];
    }

    // ── 2. Linked Contracts (CorrespondingDocNo) Resolution ───────────────────
    const unconfirmedByCorrespondingDoc = new Map();
    const tCorrDocStart = Date.now();
    try {
      const s1 = await resolveCorrespondingDocs(GMSCONFIRMNOM_SRV, aScheduled);
      const aConfirmedLinked = [];
      for (const r of s1.aLinked) {
        if (String(r.NominationKey || '') !== '' && r.isConfirmRequired === false) {
          aConfirmedLinked.push(r);
        } else {
          const corrDoc = normDoc(r.CorrespondingDocNo);
          if (corrDoc) {
            unconfirmedByCorrespondingDoc.set(corrDoc, {
              Location: r.DeliveryPoint || r.RedeliveryPoint || '',
              LocationDesc: r.DeliveryPointName || r.RedeliveryPointName || '',
              NominationKey: r.NominationKey || '',
              ContractNo: normDoc(r.ContractNo)
            });
          }
        }
      }
      if (aConfirmedLinked.length) aScheduled = [...aScheduled, ...aConfirmedLinked];
    } catch (err) {
      log.error('[getScheduledNomItemsWithSCADA] linked-contract merge failed', err);
    }
    tMark('resolveCorrespondingDocs', tCorrDocStart);

    // Tag Delivery-leg counterparts and deduplicate
    _tagPassthroughCounterparts(aScheduled);
    aScheduled = dedupeByNomKey(aScheduled);

    // Normalize CustomerKind: S/4 literal 'OWN' converted to empty string
    for (const r of aScheduled) {
      if (String(r.CustomerKind || '').trim().toUpperCase() === 'OWN') r.CustomerKind = '';
    }

    // ── 3. Fetch GDA (Gas Allocation Data) in Parallel ────────────────────────
    const touchedLocs = new Set();
    const deliveryCorrespondingDocs = new Set();
    for (const r of aScheduled) {
      if (r.DeliveryPoint) {
        touchedLocs.add(r.DeliveryPoint);
        const doc = normDoc(r.CorrespondingDocNo);
        if (doc) deliveryCorrespondingDocs.add(doc);
      }
      if (r.RedeliveryPoint) touchedLocs.add(r.RedeliveryPoint);
    }

    const aTouchedLocs = [...touchedLocs];
    const aDeliveryCorrespondingDocs = [...deliveryCorrespondingDocs];
    const gasdayParam = String(Gasday).substring(0, 10) + 'T00:00:00';

    const tGdaFetchStart = Date.now();
    const [gdaRowsByLocation, gdaRowsByVbeln] = await Promise.all([
      _fetchGdaByLocation(YGMS_GAS_ALLOCATION_SRV, aTouchedLocs, gasdayParam, touchedLocs, log),
      _fetchGdaByVbeln(YGMS_GAS_ALLOCATION_SRV, aDeliveryCorrespondingDocs, gasdayParam, deliveryCorrespondingDocs, log)
    ]);
    tMark('gdaFetch', tGdaFetchStart);

    const gdaRowKey = r => `${r.Yytimestamp}__${r.YydateGas}__${r.YybusLocation || ''}__${r.YvbelnEp || ''}__${r.Yycustomer || ''}__${r.Yy_Indicator || ''}`;
    const gdaRows = [...new Map([...gdaRowsByLocation, ...gdaRowsByVbeln].map(r => [gdaRowKey(r), r])).values()];

    // ── 4. Build Segment-Wise Meter Dictionaries ─────────────────────────────
    const gdaMaps = _processGdaRecords(gdaRows);
    const {
      ownGcvNcvMap, tpGcvNcvMap, tpMeterMap, tpUploadedQtyMap,
      tpCustomerUploadedQtyMap, hybridSecondaryMeterMap, hybridByLoc,
      tpCustomerMeterMap, hybridPartnerToOwnLoc, tpRawLocs, tpCustomerRawSeen,
      tpZeroQtyLocs, tpZeroQtyPairs
    } = gdaMaps;

    // Build residual pool for PRIMARY contracts
    const hybridPrimaryQtyMap = new Map();
    for (const [loc, ownData] of ownGcvNcvMap) {
      const secTotal = hybridByLoc.get(loc) || 0;
      hybridPrimaryQtyMap.set(loc, parseFloat(Math.max(0, ownData.totalMR - secTotal).toFixed(3)));
    }

    const gdaAgg = _buildGdaAgg(ownGcvNcvMap, tpMeterMap, tpGcvNcvMap, gasdayParam);

    // Track incomplete readings
    const { tpIncompleteLocs, tpIncompletePairs, ownIncompleteLocs } = _detectIncompleteMeters({
      aScheduled, gdaAgg, tpRawLocs, tpCustomerRawSeen, tpMeterMap,
      tpCustomerMeterMap, tpGcvNcvMap, tpZeroQtyLocs, tpZeroQtyPairs, ownGcvNcvMap
    });

    // ── 5. Bulk UOM Conversion (ApprovedDNQ -> SM3) ───────────────────────────
    const contractToLoc = new Map();
    for (const r of aScheduled) {
      const rdp = r.RedeliveryPoint || '';
      const dp = r.DeliveryPoint || '';
      if (r.ContractNo) contractToLoc.set(String(r.ContractNo), gdaAgg.has(rdp) ? rdp : gdaAgg.has(dp) ? dp : rdp || dp);
    }

    const resolveQual = (r, loc) => _resolveRowQuality(r, loc, tpGcvNcvMap, ownGcvNcvMap, hybridPartnerToOwnLoc, contractToLoc);

    const { convItems, convItemLoc } = _prepareConversionItems(aScheduled, gdaAgg, resolveQual);
    const { convMap, conversionFailures } = await _executeChunkedConversion(GMSCONFIRMNOM_SRV, convItems, convItemLoc, tMark);

    // ── 6. Enrich Scheduled Results & Entry Point Resolution ─────────────────
    const { scheduledResult, locNomQty, locMeta, partnerNameMap } = _enrichScheduledItems(
      aScheduled, gdaAgg, convMap, resolveQual
    );

    const epResults = await _resolveEntryPoints({
      gdaRows, aScheduled, scheduledResult, ownGcvNcvMap,
      unconfirmedByCorrespondingDoc, GMSCONFIRMNOM_SRV, conversionFailures, tMark
    });
    const { epQtyByDeliveryContract, epQtyByLocation, epGcvNcvMap, epVbelnToLocation, unconfirmedEntryPointLinks } = epResults;

    // Runs after _resolveEntryPoints so the re-quoted GCV/NCV are the ones used
    await _convertAllocatedToMbg(GMSCONFIRMNOM_SRV, scheduledResult, tMark, log);

    // ── 7. Data Quality Issues & Pre-Flight Validations ───────────────────────
    const missingLocSet = sEffectiveLocationFilter ? new Set(sEffectiveLocationFilter.split(',').filter(Boolean)) : null;
    const inMissingScope = _createScopeChecker(missingLocSet, scheduledResult, contractToLoc);

    const { missing, alreadyTicketed, orphanReading } = _runDataIntegrityChecks({
      scheduledResult, locMeta, inMissingScope, tpRawLocs, tpIncompletePairs,
      tpIncompleteLocs, ownGcvNcvMap, ownIncompleteLocs, tpCustomerMeterMap,
      tpGcvNcvMap, tpCustomerUploadedQtyMap, tpMeterMap, tpUploadedQtyMap,
      partnerNameMap, hybridSecondaryMeterMap, epQtyByLocation, epGcvNcvMap,
      tpCustomerRawSeen
    });

    const missingRank = _detectMissingRanks(scheduledResult, inMissingScope);

    // ── 8. Pre-Stitch Pairing & Form Final Nominations Array ─────────────────
    let nomItemsCache = _mapToNomItemsCache(scheduledResult);
    _applyOwnPrimaryConnectedLabels(nomItemsCache);
    _inheritDeliveryCustomerKind(nomItemsCache);
    nomItemsCache = _enforceUniqueODataKey(nomItemsCache);

    // Sort order: CustomerKind -> ServiceType -> LocationDesc -> Rank
    nomItemsCache.sort(_nominationComparator);

    // Interleave Redelivery followed immediately by its Delivery counterpart
    const arrangedNominations = _stitchDeliveryCounterparts(nomItemsCache);

    // ── 9. Fast Hash Index Dictionaries ──────────────────────────────────────
    const nomIndex = new Map(
      arrangedNominations.map((r, i) => [`${r.Location}__${r.NominationKey}__${r.NominationItem}`, i])
    );
    const contractIndex = new Map();
    const linkedByDoc = new Map();
    arrangedNominations.forEach((r, i) => {
      const con = String(r.Contract || '').trim();
      if (con) {
        if (!contractIndex.has(con)) contractIndex.set(con, []);
        contractIndex.get(con).push(i);
      }
      const doc = String(r.CorrespondingDocNo || '').trim();
      if (doc) {
        if (!linkedByDoc.has(doc)) linkedByDoc.set(doc, []);
        linkedByDoc.get(doc).push(i);
      }
    });

    // ── 10. Persist Fresh State to Cache ─────────────────────────────────────
    const meterReadingMap = new Map([
      ['OWN', new Map([...ownGcvNcvMap].map(([loc, v]) => [loc, v.totalMR]))],
      ['HYBRID', hybridSecondaryMeterMap],
      ['HYBRID_PRIMARY', hybridPrimaryQtyMap],
      ['THIRDPARTY', tpCustomerMeterMap],
      ['ENTRYPOINT', epQtyByLocation]
    ]);

    // Set fresh cache with no legacy merge
    nomCache.cache.set(Gasday, {
      ts: Date.now(),
      data: arrangedNominations,
      scadaAgg: gdaAgg,
      attemptedLocs: new Set(attemptedLocs || []),
      attemptedAll: !!attemptedAll,
      fetchParams: oFetchParams,
      baseNomKeys,
      meterReadingMap,
      nomIndex,
      contractIndex,
      linkedByDoc,
      nomCount: arrangedNominations.length,
      conflictedLocs: new Set(),
      tpLocations: new Set(tpMeterMap.keys()),
      tpIncompleteLocs,
      tpIncompletePairs,
      ownIncompleteLocs,
      ownGcvNcvMap,
      hybridBifurcationConflictLocs: new Set(),
      hybridPrimaryQtyMap,
      hybridSecondaryMeterMap,
      tpCustomerMeterMap,
      tpMeterMap,
      tpGcvNcvMap,
      tpCustomerUploadedQtyMap,
      tpZeroQtyPairs,
      epQtyByDeliveryContract,
      epQtyByLocation,
      epGcvNcvMap,
      epVbelnToLocation,
      orphanOwnLocs: new Set(),
      orphanHybridPairs: new Set(),
      orphanTpPairs: new Set(),
      alreadyTicketedLocs: new Map(),
      alreadyTicketedTpPairs: new Map(),
      alreadyTicketedHybridPairs: new Map()
    });

    const nomSummary = nomCache.computeSummary(nomCache.cache.get(Gasday), sEffectiveLocationFilter);

    tMark('TOTAL_REWARMED', tHandlerStart);

    return [{
      SCADAData: [],
      NomSummary: nomSummary,
      AllBusinessLocations: [...locMeta.entries()].map(([loc, meta]) => ({
        Location: loc,
        LocationDesc: meta.desc || ''
      })),
      MissingSCADAReading: missing,
      ConversionFailures: conversionFailures,
      MissingRank: missingRank,
      AlreadyTicketedLocations: alreadyTicketed,
      OrphanReadingLocations: orphanReading,
      UnconfirmedEntryPointLinks: unconfirmedEntryPointLinks
    }];
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTION: checkNominationChanges — pre-Ticketing check
  // ═══════════════════════════════════════════════════════════════════════════
  // Re-runs the same S/4 nomination fetch the cached load was built from and
  // reports nominations deleted (or added) since. Ticketing must not run on a
  // stale list — the saved allocation was split across the old nominations — so
  // on any change the cache is invalidated and the frontend asks the user to
  // re-run Allocation on the reloaded Scheduled Items.
  srv.on('checkNominationChanges', async req => {
    const log = cds.log('checkNominationChanges');
    const { Gasday } = req.data;
    if (!Gasday) return req.reject(400, 'Gasday is required');

    const entry = nomCache.cache.get(Gasday);
    if (!entry?.baseNomKeys || !entry.fetchParams) return []; // nothing loaded — not a "change"

    const { aScheduled } = await _fetchBaseNominations(GMSCONFIRMNOM_SRV, GMSVALUEHELP_SRV, entry.fetchParams, log);
    const mFresh = _nomChangeIndex(aScheduled);
    const changes = [];
    for (const [k, r] of entry.baseNomKeys) if (!mFresh.has(k)) changes.push({ ChangeType: 'DELETED', ...r });
    for (const [k, r] of mFresh) if (!entry.baseNomKeys.has(k)) changes.push({ ChangeType: 'ADDED', ...r });

    if (changes.length) {
      nomCache.cache.delete(Gasday);
      log.warn(`[checkNominationChanges] Gasday=${Gasday} changed=${changes.length} nomination(s) — cache invalidated`);
    }
    return changes;
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // READ: ScheduledNomItems (Preserves Redelivery -> Delivery Pairing in UI)
  // ═══════════════════════════════════════════════════════════════════════════
  srv.on('READ', 'ScheduledNomItems', async req => {
    const log = cds.log('ScheduledNomItems');
    const filters = _extractSimpleFilters(req.query.SELECT?.where || []);
    // One or more Gas Days (Gas Day range on Allocation & Ticketing) — each day is its
    // own cache entry, stitched on its own, then concatenated in date order.
    const gasdays = [...new Set((filters.Gasday || []).map(d => String(d).substring(0, 10)))].sort();
    if (!gasdays.length) return req.reject(400, 'Gasday filter is required');

    // TransportSystem Resolution (day-independent, resolved once)
    const tsysts = filters.TransportSystem || [];
    let resolvedLocs = null;
    if (tsysts.length) {
      resolvedLocs = new Set();
      try {
        const { deliveryLocids, redeliveryLocids } = await resolveLocationsByTS(GMSVALUEHELP_SRV, tsysts);
        resolvedLocs = new Set([...deliveryLocids, ...redeliveryLocids]);
      } catch (err) {
        log.error(`[ScheduledNomItems] locid resolution failed tsysts=[${tsysts}]`, err);
      }
    }

    const where = req.query.SELECT?.where || [];
    const skipFields = tsysts.length ? new Set(['TransportSystem']) : null;
    const orderBy = req.query.SELECT?.orderBy;

    const arranged = [];
    for (const Gasday of gasdays) {
      const entry = nomCache.cache.get(Gasday);
      if (entry) arranged.push(..._arrangeDay(entry, resolvedLocs, where, skipFields, orderBy));
    }

    // Re-number SortSeq consecutively
    for (let idx = 0; idx < arranged.length; idx++) {
      arranged[idx].SortSeq = idx + 1;
    }

    // Server-Side Paging ($skip / $top)
    const limit = req.query.SELECT.limit;
    const top = Number(limit?.rows?.val ?? limit?.rows ?? arranged.length);
    const skip = Number(limit?.offset?.val ?? limit?.offset ?? 0);
    const total = arranged.length;

    const page = arranged.slice(skip, top > 0 ? skip + top : undefined);
    if (req.query.SELECT.count) page.$count = total;

    log.info(`[ScheduledNomItems] Gasday=${gasdays.join(',')} total=${total} top=${top} skip=${skip} returned=${page.length}`);
    return page;
  });

  // One Gas Day's rows for the ScheduledNomItems READ (Preserves Redelivery -> Delivery
  // Pairing in UI). Pairing must stay within a single day — the same Delivery contract
  // recurs on every day of a range, so a cross-day lookup would pair the wrong day's leg.
  function _arrangeDay(entry, resolvedLocs, where, skipFields, orderBy) {
    // 1. Start from the full master pool
    let data = entry.data;

    // 2. TransportSystem Resolution
    if (resolvedLocs) {
      data = data.filter(row => resolvedLocs.has(row.Location));
    }

    // 3. Evaluate CQL WHERE filters
    if (where.length) {
      data = data.filter(row => _evalCQLWhere(where, row, skipFields));
    }

    // 4. Build lookup maps for ALL Delivery contracts from the FULL cached set
    // (Must use entry.data so Delivery legs outside the filter are still reachable)
    const deliveriesByContract = new Map();
    const deliveriesByNomKey = new Map();
    for (let i = 0; i < entry.data.length; i++) {
      const item = entry.data[i];
      if (item.LocationType === 'DELIVERY') {
        const con = normDoc(item.Contract);
        if (con) deliveriesByContract.set(con, item);

        if (!deliveriesByNomKey.has(item.NominationKey)) {
          deliveriesByNomKey.set(item.NominationKey, []);
        }
        deliveriesByNomKey.get(item.NominationKey).push(item);
      }
    }

    // 5. Separate Redeliveries
    let redeliveries = data.filter(item => item.LocationType === 'REDELIVERY');

    // 6. Apply UI Sort to REDELIVERIES ONLY
    // This ensures sorting orders the groups without scrambling the paired Delivery row below it!
    if (orderBy?.length) {
      redeliveries.sort((a, b) => _applyDynamicSort(a, b, orderBy));
    } else {
      redeliveries.sort(_nominationComparator);
    }

    // 7. STITCH: Redelivery followed IMMEDIATELY by its Delivery counterpart
    const arranged = [];
    const pairedDeliveryContracts = new Set();

    for (let i = 0; i < redeliveries.length; i++) {
      const redel = redeliveries[i];
      arranged.push(redel);

      let matchingDelivery = null;
      const corrDoc = normDoc(redel.CorrespondingDocNo);

      // Match by CorrespondingDocNo pointing to Delivery leg's ContractNo
      if (corrDoc && deliveriesByContract.has(corrDoc)) {
        matchingDelivery = deliveriesByContract.get(corrDoc);
      }
      // Fallback match: shared NominationKey
      else if (deliveriesByNomKey.has(redel.NominationKey)) {
        const candidates = deliveriesByNomKey.get(redel.NominationKey);
        matchingDelivery = candidates.find(d => !pairedDeliveryContracts.has(normDoc(d.Contract)));
      }

      if (matchingDelivery) {
        const delKey = normDoc(matchingDelivery.Contract);
        if (!pairedDeliveryContracts.has(delKey)) {
          arranged.push(matchingDelivery);
          pairedDeliveryContracts.add(delKey);
        }
      }
    }

    // 8. Append remaining Standalone/Orphan deliveries from the filtered dataset
    for (let i = 0; i < data.length; i++) {
      const item = data[i];
      if (item.LocationType === 'DELIVERY') {
        const delKey = normDoc(item.Contract);
        if (!pairedDeliveryContracts.has(delKey)) {
          arranged.push(item);
        }
      }
    }
    return arranged;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UPDATE: ScheduledNomItems (Manual AllocatedQty In-Memory Override)
  // ═══════════════════════════════════════════════════════════════════════════
  srv.on('UPDATE', 'ScheduledNomItems', async req => {
    const keys = req.params?.[0] ?? {};
    const { Location, NominationKey, NominationItem } = keys;
    const indexKey = `${Location}__${NominationKey}__${NominationItem}`;

    for (const [, entry] of nomCache.cache) {
      const idx = entry.nomIndex?.get(indexKey);
      if (idx === undefined) continue;
      const item = entry.data[idx];
      if (!item) continue;

      if (req.data.AllocatedQty !== undefined) {
        item.AllocatedQty = parseFloat(req.data.AllocatedQty) || 0;
      }
      if (req.data.AllocUOM !== undefined) {
        item.AllocUOM = req.data.AllocUOM;
      }
      return req.data;
    }
    return req.reject(404, `Item ${NominationKey}/${NominationItem} not found in allocation cache`);
  });
};

// ═════════════════════════════════════════════════════════════════════════════
// PURE UTILITY & LOGICAL HELPER FUNCTIONS
// ═════════════════════════════════════════════════════════════════════════════

// Confirmed nominations for the Gasday — by LocationFilter (DP or RDP), else by the
// Transport System's resolved Delivery/Redelivery locations, else all.
async function _fetchBaseNominations(GMSCONFIRMNOM_SRV, GMSVALUEHELP_SRV, { Gasday, LocationFilter, TransportSystem }, log) {
  const locids = splitArr(LocationFilter);
  const tsysts = !locids.length ? splitArr(TransportSystem) : [];
  let attemptedLocs = null;
  let attemptedAll = false;
  let sEffectiveLocationFilter = LocationFilter || '';
  let aScheduled = [];

  if (locids.length) {
    aScheduled = await GMSCONFIRMNOM_SRV.run(
      SELECT.from('xGMSxNOMSOURCE').columns(...NOMSOURCE_COLUMNS)
        .where`Gasday = ${Gasday} and isConfirmRequired = ${false}`.where(buildLocFilter(locids, locids))
    );
    attemptedLocs = new Set(locids);
  } else if (tsysts.length) {
    let deliveryLocids = [], redeliveryLocids = [];
    try {
      ({ deliveryLocids, redeliveryLocids } = await resolveLocationsByTS(GMSVALUEHELP_SRV, tsysts));
    } catch (err) {
      log.error(`[getScheduledNomItemsWithSCADA] locid resolution failed tsysts=[${tsysts}]`, err);
    }
    attemptedLocs = new Set([...deliveryLocids, ...redeliveryLocids]);
    sEffectiveLocationFilter = [...attemptedLocs].join(',');

    if (deliveryLocids.length || redeliveryLocids.length) {
      const aDpQueries = chunk(deliveryLocids, LOC_CHUNK).map(c =>
        SELECT.from('xGMSxNOMSOURCE').columns(...NOMSOURCE_COLUMNS)
          .where`Gasday = ${Gasday} and isConfirmRequired = ${false}`.where(buildLocFilter(c, []))
      );
      const aRdpQueries = chunk(redeliveryLocids, LOC_CHUNK).map(c =>
        SELECT.from('xGMSxNOMSOURCE').columns(...NOMSOURCE_COLUMNS)
          .where`Gasday = ${Gasday} and isConfirmRequired = ${false}`.where(buildLocFilter([], c))
      );
      const [aDpFetched, aRdpFetched] = await Promise.all([
        runChunked(GMSCONFIRMNOM_SRV, aDpQueries),
        runChunked(GMSCONFIRMNOM_SRV, aRdpQueries)
      ]);
      aScheduled = [...new Map([...aDpFetched, ...aRdpFetched].map(r => [rowKey(r), r])).values()];
    }
  } else {
    aScheduled = await GMSCONFIRMNOM_SRV.run(
      SELECT.from('xGMSxNOMSOURCE').columns(...NOMSOURCE_COLUMNS)
        .where`Gasday = ${Gasday} and isConfirmRequired = ${false}`
    );
    attemptedAll = true;
  }
  return { aScheduled, attemptedLocs, attemptedAll, sEffectiveLocationFilter };
}

// Nomination identity for checkNominationChanges — Versn left out so a re-version
// of the same nomination item isn't reported as deleted + added.
function _nomChangeIndex(aRows) {
  const m = new Map();
  for (const r of aRows) {
    if (String(r.NominationKey || '').trim() === '') continue;
    const k = `${r.NominationKey}|${r.NominationItem}|${normDoc(r.ContractNo)}|${r.Item}`;
    if (!m.has(k)) {
      m.set(k, {
        NominationKey: String(r.NominationKey),
        NominationItem: String(r.NominationItem ?? ''),
        ContractNo: normDoc(r.ContractNo),
        Location: r.RedeliveryPoint || r.DeliveryPoint || ''
      });
    }
  }
  return m;
}

function _buildEmptyResultPayload() {
  return {
    SCADAData: [],
    NomSummary: {
      TotalCount: 0,
      AggrApprovedQty: 0,
      AggrUOM: '',
      AggrApprovedQtyDP: 0,
      AggrUOMDP: '',
      AggrApprovedQtyRDP: 0,
      AggrUOMRDP: '',
      AggrMeteredQty: 0,
      MeteredUOM: '',
      AggrMeteredQtyDP: 0,
      MeteredUOMDP: '',
      AggrMeteredQtyRDP: 0,
      MeteredUOMRDP: ''
    },
    MissingSCADAReading: [],
    ConversionFailures: [],
    MissingRank: [],
    AllBusinessLocations: [],
    AlreadyTicketedLocations: [],
    OrphanReadingLocations: [],
    UnconfirmedEntryPointLinks: []
  };
}

function _tagPassthroughCounterparts(aScheduled) {
  const contractToRow = new Map();
  for (const r of aScheduled) {
    const key = normDoc(r.ContractNo);
    if (key && !contractToRow.has(key)) contractToRow.set(key, r);
  }
  for (const r of aScheduled) {
    const doc = normDoc(r.CorrespondingDocNo);
    if (!doc) continue;
    const childRow = contractToRow.get(doc);
    if (!childRow || childRow === r) continue;
    childRow._passthroughCounterpart = true;
    childRow._counterpartRdpLocation = r.DeliveryPoint || r.RedeliveryPoint || '';
  }
}

async function _fetchGdaByLocation(srv, aTouchedLocs, gasdayParam, touchedLocs, log) {
  try {
    return aTouchedLocs.length
      ? await runChunked(srv, chunk(aTouchedLocs, GDA_LOC_CHUNK).map(batch =>
        SELECT.from('YGMS_ALLOCATION_GAS_DATASet').where({ YydateGas: gasdayParam }).where(buildBusLocFilter(batch))
      ))
      : [];
  } catch (err) {
    log.warn('[getScheduledNomItemsWithSCADA] fallback to whole-day fetch for YybusLocation', err);
    const aAll = await srv.run(SELECT.from('YGMS_ALLOCATION_GAS_DATASet').where({ YydateGas: gasdayParam }));
    return aAll.filter(r => touchedLocs.has(r.YybusLocation));
  }
}

async function _fetchGdaByVbeln(srv, aDocs, gasdayParam, deliveryCorrespondingDocs, log) {
  try {
    return aDocs.length
      ? await runChunked(srv, chunk(aDocs, GDA_LOC_CHUNK).map(batch =>
        SELECT.from('YGMS_ALLOCATION_GAS_DATASet').where({ YydateGas: gasdayParam }).where(buildVbelnFilter(batch))
      ))
      : [];
  } catch (err) {
    log.warn('[getScheduledNomItemsWithSCADA] fallback to whole-day fetch for YvbelnEp', err);
    const aAll = await srv.run(SELECT.from('YGMS_ALLOCATION_GAS_DATASet').where({ YydateGas: gasdayParam }));
    return aAll.filter(r => deliveryCorrespondingDocs.has(normDoc(r.YvbelnEp)));
  }
}

function _processGdaRecords(gdaRows) {
  const ownGcvNcvMap = new Map();
  const tpGcvNcvMap = new Map();
  const tpMeterMap = new Map();
  const tpUploadedQtyMap = new Map();
  const tpCustomerUploadedQtyMap = new Map();
  const hybridSecondaryMeterMap = new Map();
  const hybridByLoc = new Map();
  const tpCustomerMeterMap = new Map();
  const hybridPartnerToOwnLoc = new Map();
  const tpRawLocs = new Set();
  const tpCustomerRawSeen = new Set();
  const tpZeroQtyLocs = new Set();
  const tpZeroQtyPairs = new Set();
  const tpPendingConv = [];
  const ownLatestTime = new Map();

  for (const r of gdaRows) {
    const loc = r.YybusLocation;
    if (!loc) continue;

    if (r.Yy_Indicator === 'OWN') {
      const prevTime = ownLatestTime.get(loc);
      if (prevTime !== undefined && r.YytimeCm <= prevTime) continue;
      ownLatestTime.set(loc, r.YytimeCm);
      ownGcvNcvMap.set(loc, {
        gcv: parseFloat(r.YyavgGcvCm || 0),
        ncv: parseFloat(r.YyavgNcvCm || 0),
        totalMR: parseFloat(r.YycumVolCm || 0)
      });
    } else if (r.Yy_Indicator === 'HYBRID') {
      const customer = r.Yycustomer || '';
      const qty = parseFloat(r.YyvolSm3Case2 || 0);
      if (customer) {
        const hKey = `${customer}__${loc}`;
        hybridSecondaryMeterMap.set(hKey, (hybridSecondaryMeterMap.get(hKey) || 0) + qty);
        hybridPartnerToOwnLoc.set(customer, loc);
      }
      hybridByLoc.set(loc, (hybridByLoc.get(loc) || 0) + qty);
    } else if (r.Yy_Indicator === 'THIRDPARTY') {
      tpRawLocs.add(loc);
      const customer = r.Yycustomer || '';
      const gcv = parseFloat(r.YygcvNgail || 0);
      const ncv = parseFloat(r.YyncvNgail || 0);
      const rawQty = parseFloat(r.YyallocQtyNongail || 0);
      const rawUom = String(r.YyallocUomNongail || '').trim().toUpperCase();
      const scmQty = rawQty > 0 ? parseFloat(r.YyallocQtyNongailscm || 0) : 0;

      if (!(gcv > 0) && rawQty === 0) {
        tpZeroQtyLocs.add(loc);
        if (customer) tpZeroQtyPairs.add(`${customer}__${loc}`);
      }
      if (rawQty > 0) {
        tpUploadedQtyMap.set(loc, (tpUploadedQtyMap.get(loc) || 0) + rawQty);
        if (customer) {
          const custKey = `${customer}__${loc}`;
          tpCustomerUploadedQtyMap.set(custKey, (tpCustomerUploadedQtyMap.get(custKey) || 0) + rawQty);
        }
      }
      if (gcv > 0 && !tpGcvNcvMap.has(loc)) {
        tpGcvNcvMap.set(loc, { gcv, ncv });
      }
      if (customer) tpCustomerRawSeen.add(`${customer}__${loc}`);

      if (scmQty > 0) {
        tpMeterMap.set(loc, (tpMeterMap.get(loc) || 0) + scmQty);
        if (customer) {
          const tpKey = `${customer}__${loc}`;
          tpCustomerMeterMap.set(tpKey, (tpCustomerMeterMap.get(tpKey) || 0) + scmQty);
        }
      } else if (rawQty > 0 && rawUom) {
        tpPendingConv.push({ loc, customer, rawQty, rawUom });
      }
    }
  }

  // Second pass: Thirdparty convertToSM3 fallback
  for (const item of tpPendingConv) {
    const qual = tpGcvNcvMap.get(item.loc);
    if (!qual) continue;
    let qty;
    try {
      qty = allocationUtils.convertToSM3(item.rawQty, item.rawUom, qual.gcv, qual.ncv);
    } catch {
      continue;
    }
    if (!(qty > 0)) continue;
    tpMeterMap.set(item.loc, (tpMeterMap.get(item.loc) || 0) + qty);
    if (item.customer) {
      const tpKey = `${item.customer}__${item.loc}`;
      tpCustomerMeterMap.set(tpKey, (tpCustomerMeterMap.get(tpKey) || 0) + qty);
    }
  }

  return {
    ownGcvNcvMap, tpGcvNcvMap, tpMeterMap, tpUploadedQtyMap,
    tpCustomerUploadedQtyMap, hybridSecondaryMeterMap, hybridByLoc,
    tpCustomerMeterMap, hybridPartnerToOwnLoc, tpRawLocs, tpCustomerRawSeen,
    tpZeroQtyLocs, tpZeroQtyPairs
  };
}

function _buildGdaAgg(ownGcvNcvMap, tpMeterMap, tpGcvNcvMap, gasdayParam) {
  const gdaAgg = new Map();
  for (const [loc, d] of ownGcvNcvMap) {
    gdaAgg.set(loc, {
      totalMR: d.totalMR,
      gcv: d.gcv,
      ncv: d.ncv,
      unit: 'SM3',
      gasday: gasdayParam,
      wtGcvN: d.gcv * d.totalMR,
      wtNcvN: d.ncv * d.totalMR,
      netMR: d.totalMR
    });
  }
  for (const [loc, qty] of tpMeterMap) {
    if (gdaAgg.has(loc)) continue;
    const tp = tpGcvNcvMap.get(loc) || { gcv: 0, ncv: 0 };
    gdaAgg.set(loc, {
      totalMR: qty,
      gcv: tp.gcv,
      ncv: tp.ncv,
      unit: 'SM3',
      gasday: gasdayParam,
      wtGcvN: tp.gcv * qty,
      wtNcvN: tp.ncv * qty,
      netMR: qty
    });
  }
  return gdaAgg;
}

function _detectIncompleteMeters(ctx) {
  const {
    aScheduled, gdaAgg, tpRawLocs, tpCustomerRawSeen, tpMeterMap,
    tpCustomerMeterMap, tpGcvNcvMap, tpZeroQtyLocs, tpZeroQtyPairs, ownGcvNcvMap
  } = ctx;

  for (const r of aScheduled) {
    if (r.CustomerKind !== 'THIRD-PARTY') continue;
    const rdp = r.RedeliveryPoint || '';
    const dp = r.DeliveryPoint || '';
    const loc = gdaAgg.has(rdp) ? rdp : gdaAgg.has(dp) ? dp : rdp || dp;
    if (!loc || (loc === dp && allocationUtils.isZgt1Contract(r.ContractType))) continue;
    tpRawLocs.add(loc);
    if (r.Partner) tpCustomerRawSeen.add(`${r.Partner}__${loc}`);
  }

  const tpIncompleteLocs = new Set();
  for (const loc of tpRawLocs) {
    const qty = tpMeterMap.get(loc) || 0;
    const qual = tpGcvNcvMap.get(loc);
    const bQualOk = !!qual && qual.gcv > 0 && qual.ncv > 0;
    if (tpZeroQtyLocs.has(loc) && bQualOk) continue;
    if (qty <= 0 || !bQualOk) tpIncompleteLocs.add(loc);
  }

  const tpIncompletePairs = new Set();
  for (const tpKey of tpCustomerRawSeen) {
    const dunder = tpKey.indexOf('__');
    const loc = dunder >= 0 ? tpKey.slice(dunder + 2) : tpKey;
    const qty = tpCustomerMeterMap.get(tpKey) || 0;
    const qual = tpGcvNcvMap.get(loc);
    const bQualOk = !!qual && qual.gcv > 0 && qual.ncv > 0;
    if (tpZeroQtyPairs.has(tpKey) && bQualOk) continue;
    if (qty <= 0 || !bQualOk) tpIncompletePairs.add(tpKey);
  }

  const ownIncompleteLocs = new Set();
  for (const [loc, d] of ownGcvNcvMap) {
    if (!(d.totalMR > 0) || !(d.gcv > 0) || !(d.ncv > 0)) ownIncompleteLocs.add(loc);
  }

  return { tpIncompleteLocs, tpIncompletePairs, ownIncompleteLocs };
}

function _resolveRowQuality(r, loc, tpGcvNcvMap, ownGcvNcvMap, hybridPartnerToOwnLoc, contractToLoc) {
  const ownQual = (l) => {
    const direct = ownGcvNcvMap.get(l);
    if (direct) return direct;
    const primaryLoc = hybridPartnerToOwnLoc.get(l);
    return primaryLoc ? (ownGcvNcvMap.get(primaryLoc) || { gcv: 0, ncv: 0 }) : { gcv: 0, ncv: 0 };
  };

  const isTP = r.CustomerKind === 'THIRD-PARTY';
  const direct = isTP ? (tpGcvNcvMap.get(loc) || { gcv: 0, ncv: 0 }) : ownQual(loc);
  if (direct.gcv > 0 && direct.ncv > 0) return direct;

  const doc = String(r.CorrespondingDocNo || '').trim();
  const linkedLoc = doc && contractToLoc.get(doc);
  if (!linkedLoc) return direct;

  const linkedOwn = ownQual(linkedLoc);
  if (linkedOwn.gcv > 0 && linkedOwn.ncv > 0) return linkedOwn;

  const linkedTp = tpGcvNcvMap.get(linkedLoc);
  return (linkedTp && linkedTp.gcv > 0 && linkedTp.ncv > 0) ? linkedTp : direct;
}

function _prepareConversionItems(aScheduled, gdaAgg, resolveQual) {
  const convItems = [];
  const convItemLoc = new Map();

  for (let i = 0; i < aScheduled.length; i++) {
    const r = aScheduled[i];
    if (String(r.UOM || '').toUpperCase() === 'SM3') continue;
    if (!(parseFloat(r.ApprovedDNQ) > 0)) continue;

    const rdp = r.RedeliveryPoint || '';
    const dp = r.DeliveryPoint || '';
    const loc = gdaAgg.has(rdp) ? rdp : gdaAgg.has(dp) ? dp : rdp || dp;
    const qual = resolveQual(r, loc);

    const key = `${r.NominationKey}__${r.NominationItem}`;
    convItemLoc.set(key, {
      loc,
      desc: loc === rdp ? r.RedeliveryPointName : r.DeliveryPointName
    });

    convItems.push({
      NominationKey: r.NominationKey,
      NominationItem: r.NominationItem,
      ScheduledQty: r.ApprovedDNQ,
      ScheduledUoM: r.UOM,
      TargetUoM: 'SM3',
      GCV: parseFloat(qual.gcv.toFixed(4)),
      NCV: parseFloat(qual.ncv.toFixed(4))
    });
  }

  return { convItems, convItemLoc };
}

async function _executeChunkedConversion(srv, convItems, convItemLoc, tMark) {
  const convMap = new Map();
  const conversionFailures = [];
  const tConvStart = Date.now();

  for (let ci = 0; ci < convItems.length; ci += CONV_CHUNK) {
    const bChunk = convItems.slice(ci, ci + CONV_CHUNK);
    const result = await srv.send({
      method: 'POST',
      path: '/ConversionRequest',
      data: {
        RequestId: `R${String(Math.floor(ci / CONV_CHUNK) + 1).padStart(3, '0')}`,
        ToItems: bChunk
      }
    });

    const returnedKeys = new Set();
    for (const c of (result?.ToItems || [])) {
      const key = `${c.NominationKey}__${c.NominationItem}`;
      returnedKeys.add(key);
      if (c.MsgType === 'S') {
        convMap.set(key, { qty: parseFloat(c.TargetQty) || 0, uom: c.TargetUoM || 'SM3' });
      } else {
        const meta = convItemLoc.get(key) || {};
        conversionFailures.push({
          BusinessLocation: meta.loc || '',
          BusinessLocationDesc: meta.desc || '',
          NominationKey: c.NominationKey,
          NominationItem: c.NominationItem,
          Message: c.Message || 'Conversion failed'
        });
      }
    }

    for (const it of bChunk) {
      const key = `${it.NominationKey}__${it.NominationItem}`;
      if (!returnedKeys.has(key)) {
        const meta = convItemLoc.get(key) || {};
        conversionFailures.push({
          BusinessLocation: meta.loc || '',
          BusinessLocationDesc: meta.desc || '',
          NominationKey: it.NominationKey,
          NominationItem: it.NominationItem,
          Message: 'No conversion response received'
        });
      }
    }
  }

  if (convItems.length) tMark(`conversionRequest(${Math.ceil(convItems.length / CONV_CHUNK)} chunk(s))`, tConvStart);
  return { convMap, conversionFailures };
}

// Alloc. Qty (Contract UoM), display only: MBG contracts get AllocatedQty (SM3) -> MBG via the
// same S/4 ConversionRequest; every other contract UoM (SM3) shows the Proposed DNQ as-is.
// A failed/missing conversion leaves AllocatedQtyMBG null instead of blocking Go.
async function _convertAllocatedToMbg(srv, scheduledResult, tMark, log) {
  const convItems = [];
  const idxByKey = new Map();

  for (let i = 0; i < scheduledResult.length; i++) {
    const r = scheduledResult[i];
    r.AllocatedQtyMBG = null;

    if (String(r.UOM || '').trim().toUpperCase() !== 'MBG') {
      const dnq = parseFloat(r.ApprovedDNQ);
      r.AllocatedQtyMBG = Number.isFinite(dnq) ? parseFloat(dnq.toFixed(3)) : null;
      continue;
    }

    const qty = parseFloat(r.AllocatedQty) || 0;
    if (!(qty > 0)) continue;

    const srcUom = String(r.ConversionUOM || 'SM3').toUpperCase();
    if (srcUom === 'MBG') {
      r.AllocatedQtyMBG = qty;
      continue;
    }
    if (!(r.AVG_WT_GCV > 0 && r.AVG_WT_NCV > 0)) continue;

    const key = `${r.NominationKey}__${r.NominationItem}`;
    if (!idxByKey.has(key)) {
      idxByKey.set(key, []);
      convItems.push({
        NominationKey: r.NominationKey,
        NominationItem: r.NominationItem,
        ScheduledQty: qty.toFixed(3),
        ScheduledUoM: srcUom,
        TargetUoM: 'MBG',
        GCV: r.AVG_WT_GCV,
        NCV: r.AVG_WT_NCV
      });
    }
    idxByKey.get(key).push(i);
  }

  if (!convItems.length) return;

  const tConvStart = Date.now();
  let failed = 0;
  for (let ci = 0; ci < convItems.length; ci += CONV_CHUNK) {
    const bChunk = convItems.slice(ci, ci + CONV_CHUNK);
    try {
      const result = await srv.send({
        method: 'POST',
        path: '/ConversionRequest',
        data: {
          RequestId: `M${String(Math.floor(ci / CONV_CHUNK) + 1).padStart(3, '0')}`,
          ToItems: bChunk
        }
      });
      for (const c of (result?.ToItems || [])) {
        const idxs = idxByKey.get(`${c.NominationKey}__${c.NominationItem}`);
        if (!idxs) continue;
        if (c.MsgType !== 'S') { failed++; continue; }
        const mbg = parseFloat(Number(c.TargetQty || 0).toFixed(3));
        for (const i of idxs) scheduledResult[i].AllocatedQtyMBG = mbg;
      }
    } catch (err) {
      failed += bChunk.length;
      log.error('[getScheduledNomItemsWithSCADA] AllocatedQty -> MBG conversion failed', err);
    }
  }
  if (failed) log.warn(`[getScheduledNomItemsWithSCADA] AllocatedQty -> MBG: ${failed} of ${convItems.length} item(s) not converted`);
  tMark(`mbgConversionRequest(${Math.ceil(convItems.length / CONV_CHUNK)} chunk(s))`, tConvStart);
}

function _enrichScheduledItems(aScheduled, gdaAgg, convMap, resolveQual) {
  const f3 = v => parseFloat(Number(v).toFixed(3));
  const f4 = v => parseFloat(Number(v).toFixed(4));
  const n = aScheduled.length;
  const scheduledResult = new Array(n);
  const locNomQty = new Map();
  const locMeta = new Map();
  const partnerNameMap = new Map();

  for (let i = 0; i < n; i++) {
    const r = aScheduled[i];
    const rdp = r.RedeliveryPoint || '';
    const dp = r.DeliveryPoint || '';
    const loc = gdaAgg.has(rdp) ? rdp : gdaAgg.has(dp) ? dp : rdp || dp;

    const cv = String(r.UOM || '').toUpperCase() === 'SM3'
      ? { qty: parseFloat(r.ApprovedDNQ) || 0, uom: 'SM3' }
      : (convMap.get(`${r.NominationKey}__${r.NominationItem}`) || { qty: 0, uom: 'SM3' });

    const qual = resolveQual(r, loc);

    scheduledResult[i] = {
      Gasday: r.Gasday,
      ContractNo: r.ContractNo,
      CorrespondingDocNo: r.CorrespondingDocNo || '',
      _passthroughCounterpart: r._passthroughCounterpart || false,
      _counterpartRdpLocation: r._counterpartRdpLocation || '',
      BusinessLocation: loc,
      BusinessLocationDesc: loc === rdp ? r.RedeliveryPointName : r.DeliveryPointName,
      TicketKey: r.TicketKey || '',
      TicketItem: r.TicketItem || '',
      TicketVersion: r.TicketVersion || '',
      TicketPurpose: r.TicketPurpose || '',
      TicketStatus: r.TicketStatus || '',
      TicketItemSubStatus: r.TicketItemSubStatus || '',
      NominationKey: r.NominationKey,
      NominationItem: r.NominationItem,
      ContractType: r.ContractType,
      ContractTypeName: r.ContractTypeName,
      ServiceType: r.ServiceType || '',
      Source: r.Source || '',
      MasterContractNo: r.MasterContractNo,
      Partner: r.Partner,
      PartnerName: r.PartnerName,
      TransportSystem: r.TransportSystem,
      TransportSystemName: r.TransportSystemName,
      DeliveryPoint: dp,
      DeliveryPointName: r.DeliveryPointName,
      RedeliveryPoint: rdp,
      RedeliveryPointName: r.RedeliveryPointName,
      Material: r.Material,
      MaterialName: r.MaterialName,
      Rank: r.Rank,
      DeliveryDCQ: r.DeliveryDCQ,
      RedeliveryDCQ: r.RedeliveryDCQ,
      ApprovedDNQ: r.ApprovedDNQ,
      UOM: r.UOM,
      ApprovedQtySM: f3(cv.qty),
      ConversionUOM: cv.uom,
      AVG_WT_GCV: f4(qual.gcv),
      AVG_WT_NCV: f4(qual.ncv),
      SavedAllocatedQty: r.SavedAllocatedQty,
      SavedAllocatedQty2: r.SavedAllocatedQty2,
      SavedAllocatedUOM: r.SavedAllocatedUOM,
      // Allocated Qty = full saved (metered) qty as S/4 holds it. OverDrawlGSA is a breakdown
      // of that qty, not netted off it — Σ AllocatedQty alone balances to the meter.
      AllocatedQty: f3(parseFloat(r.SavedAllocatedQty2 || 0) > 0 ? parseFloat(r.SavedAllocatedQty2) : parseFloat(r.SavedAllocatedQty || 0) > 0 ? parseFloat(r.SavedAllocatedQty) : 0),
      CustomerKind: r.CustomerKind || '',
      OverDrawlGSA: r.yyoij_od_qty || 0,
      UnderDrawlGSA: r.yyoij_un_qty || 0,
      AuthOverrunGTA: r.yyoij_aovr_qty || 0,
      UnauthOverrunGTA: r.yyoij_unaovr_qty || 0,
      UnauthOverDrawlGSA: r.yyoij_unaod_qty || 0,
      AuthOverDrawlGSA: r.yyoij_aod_qty || 0,
      OverrunGTA: r.yyoij_ovr_qty || 0,
      DImbQty: r.yyoij_dimb_qty || 0,
      CNomQty: r.yyoij_cnom_qty || 0,
      CNomUOM: r.yyoij_cnom_uom || '',
      OijStatus: r.yyoij_status || '',
      DPIQty: r.yyoij_dpimb_qty || 0,
      DNIQty: r.yyoij_dnimb_qty || 0,
      CumImbQty: r.yyoij_cumimb_qty || 0,
      ChrgImbQty: r.yyoij_crgimb_qty || 0,
      PosCumImbQty: r.yyoij_pos_cumimb || 0,
      NegCumImbQty: r.yyoij_neg_cumimb || 0,
      LiqAdjustQty: r.yyoij_ld_a_qty || 0,
      LiqDamDiscQty: r.yyoij_ld_d_qty || 0,
      SellOrPayAdjQty: r.yyoij_sop_a_qty || 0,
      SellOrPayDiscQty: r.yyoij_sop_d_qty || 0,
      SellersSFAdjQty: r.yyoij_ssf_a_qty || 0,
      SSFDiscQty: r.yyoij_ssf_d_qty || 0,
      TakeOrPayAdjQty: r.yyoij_top_a_qty || 0,
      TakeOrPayDiscQty: r.yyoij_top_d_qty || 0,
      GTAAdjust: !!r.yyoij_gta_adjust,
      GSAAdjust: !!r.yyoij_gsa_adjust,
      GujDNQQty: r.yyoij_gujdnq || 0,
      GujDNQUOM: r.yyoij_gujdnq_uom || '',
      DDSQty: r.yyoij_dds_qty || 0
    };

    if (loc) locNomQty.set(loc, (locNomQty.get(loc) || 0) + cv.qty);
    if (r.Partner && !partnerNameMap.has(r.Partner)) partnerNameMap.set(r.Partner, r.PartnerName || '');
    if (rdp && !locMeta.has(rdp)) locMeta.set(rdp, { ts: r.TransportSystem, tsn: r.TransportSystemName, desc: r.RedeliveryPointName });
    if (dp && !locMeta.has(dp)) locMeta.set(dp, { ts: r.TransportSystem, tsn: r.TransportSystemName, desc: r.DeliveryPointName });
  }

  return { scheduledResult, locNomQty, locMeta, partnerNameMap };
}

async function _resolveEntryPoints(ctx) {
  const {
    gdaRows, aScheduled, scheduledResult, ownGcvNcvMap,
    unconfirmedByCorrespondingDoc, GMSCONFIRMNOM_SRV, conversionFailures, tMark
  } = ctx;

  const f3 = v => parseFloat(Number(v).toFixed(3));
  const f4 = v => parseFloat(Number(v).toFixed(4));

  const epQtyByDeliveryContract = new Map();
  const epQtyByLocation = new Map();
  const epGcvNcvMap = new Map();
  const epVbelnToLocation = new Map();
  const unconfirmedEntryPointLinks = [];

  const epRawByVbeln = new Map();
  for (const r of gdaRows) {
    const vbeln = normDoc(r.YvbelnEp);
    if (!vbeln) continue;
    const entry = epRawByVbeln.get(vbeln) || { qty: 0, uom: '', gcv: 0, ncv: 0, alcsQty: 0, hasQty: false, hasAlcsQty: false };
    if (r.YdpalcqtyEp !== '' && r.YdpalcqtyEp != null) {
      entry.qty += parseFloat(r.YdpalcqtyEp) || 0;
      entry.hasQty = true;
    }
    if (r.YalcsqtyEp !== '' && r.YalcsqtyEp != null) {
      entry.alcsQty += parseFloat(r.YalcsqtyEp) || 0;
      entry.hasAlcsQty = true;
    }
    if (!entry.uom) entry.uom = String(r.YdpalcuomEp || '').trim().toUpperCase();
    if (!(entry.gcv > 0)) entry.gcv = parseFloat(r.YyavgGcvCm || 0);
    if (!(entry.ncv > 0)) entry.ncv = parseFloat(r.YyavgNcvCm || 0);
    epRawByVbeln.set(vbeln, entry);
  }

  const corrDocIndex = new Map();
  const contractNoToIndex = new Map();
  for (let i = 0; i < aScheduled.length; i++) {
    const r = aScheduled[i];
    const doc = normDoc(r.CorrespondingDocNo);
    if (doc && r.DeliveryPoint && !corrDocIndex.has(doc)) corrDocIndex.set(doc, r);
    const cn = normDoc(r.ContractNo);
    if (cn && !contractNoToIndex.has(cn)) contractNoToIndex.set(cn, i);
  }

  const epQualByLocCache = new Map();
  const getEpQuality = (deliveryPoint, raw) => {
    if (deliveryPoint && epQualByLocCache.has(deliveryPoint)) {
      const cached = epQualByLocCache.get(deliveryPoint);
      if (cached.gcv > 0 && cached.ncv > 0) return cached;
    }
    const ownReading = deliveryPoint && ownGcvNcvMap.get(deliveryPoint);
    if (ownReading && ownReading.gcv > 0 && ownReading.ncv > 0) {
      const q = { gcv: ownReading.gcv, ncv: ownReading.ncv };
      if (deliveryPoint) epQualByLocCache.set(deliveryPoint, q);
      return q;
    }
    return (raw.gcv > 0 && raw.ncv > 0) ? { gcv: raw.gcv, ncv: raw.ncv } : { gcv: 0, ncv: 0 };
  };

  const epResolved = [];
  for (const [vbeln, raw] of epRawByVbeln) {
    const matchedRow = corrDocIndex.get(vbeln);
    if (!matchedRow) continue;
    epResolved.push({
      vbeln,
      correspondingDoc: normDoc(matchedRow.ContractNo),
      deliveryPoint: matchedRow.DeliveryPoint,
      nomKey: matchedRow.NominationKey,
      nomItem: matchedRow.NominationItem,
      raw,
      qual: getEpQuality(matchedRow.DeliveryPoint, raw)
    });
  }

  const epConvItems = [];
  const epConvItemKey = new Map();
  for (const item of epResolved) {
    if (item.raw.uom === 'SM3' || !(item.raw.qty > 0) || !(item.qual.gcv > 0 && item.qual.ncv > 0)) continue;
    const key = `${item.nomKey}__${item.nomItem}`;
    epConvItemKey.set(item.vbeln, key);
    epConvItems.push({
      NominationKey: item.nomKey,
      NominationItem: item.nomItem,
      ScheduledQty: item.raw.qty.toFixed(3),
      ScheduledUoM: item.raw.uom,
      TargetUoM: 'SM3',
      GCV: parseFloat(item.qual.gcv.toFixed(4)),
      NCV: parseFloat(item.qual.ncv.toFixed(4))
    });
  }

  const epConvMap = new Map();
  if (epConvItems.length) {
    const tEpConvStart = Date.now();
    for (let ci = 0; ci < epConvItems.length; ci += CONV_CHUNK) {
      const batchItems = epConvItems.slice(ci, ci + CONV_CHUNK);
      const result = await GMSCONFIRMNOM_SRV.send({
        method: 'POST',
        path: '/ConversionRequest',
        data: {
          RequestId: `E${String(Math.floor(ci / CONV_CHUNK) + 1).padStart(3, '0')}`,
          ToItems: batchItems
        }
      });
      for (const c of (result?.ToItems || [])) {
        if (c.MsgType === 'S') epConvMap.set(`${c.NominationKey}__${c.NominationItem}`, parseFloat(c.TargetQty) || 0);
      }
    }
    tMark(`epConversionRequest(${Math.ceil(epConvItems.length / CONV_CHUNK)} chunk(s))`, tEpConvStart);
  }

  const requoteItems = [];
  for (const { vbeln, correspondingDoc, deliveryPoint, raw, qual } of epResolved) {
    const key = epConvItemKey.get(vbeln);
    const qty = (key && epConvMap.has(key)) ? epConvMap.get(key) :
      raw.uom === 'SM3' ? (raw.hasQty ? raw.qty : null) :
        (raw.hasAlcsQty ? raw.alcsQty : null);

    epQtyByDeliveryContract.set(correspondingDoc, qty);
    epVbelnToLocation.set(vbeln, { Location: deliveryPoint, Contract: correspondingDoc, ConvertedQty: qty });

    const ownReading = ownGcvNcvMap.get(deliveryPoint);
    if (ownReading) {
      epQtyByLocation.set(deliveryPoint, ownReading.totalMR);
      epGcvNcvMap.set(deliveryPoint, { gcv: ownReading.gcv, ncv: ownReading.ncv });
    } else if (qual.gcv > 0 && qual.ncv > 0) {
      epGcvNcvMap.set(deliveryPoint, { gcv: qual.gcv, ncv: qual.ncv });
    }

    if (qual.gcv > 0 && qual.ncv > 0) {
      const idx = contractNoToIndex.get(correspondingDoc);
      if (idx !== undefined) requoteItems.push({ idx, qual });
    }
  }

  if (requoteItems.length) {
    const requoteConvItems = [];
    const requoteConvItemKey = new Map();
    for (const { idx, qual } of requoteItems) {
      const row = scheduledResult[idx];
      scheduledResult[idx] = { ...row, AVG_WT_GCV: f4(qual.gcv), AVG_WT_NCV: f4(qual.ncv) };
      if (String(row.UOM || '').toUpperCase() === 'SM3' || !(parseFloat(row.ApprovedDNQ) > 0)) continue;
      const reqKey = `${row.NominationKey}__${row.NominationItem}`;
      requoteConvItemKey.set(idx, reqKey);
      requoteConvItems.push({
        NominationKey: row.NominationKey,
        NominationItem: row.NominationItem,
        ScheduledQty: row.ApprovedDNQ,
        ScheduledUoM: row.UOM,
        TargetUoM: 'SM3',
        GCV: f4(qual.gcv),
        NCV: f4(qual.ncv)
      });
    }

    if (requoteConvItems.length) {
      const requoteConvMap = new Map();
      for (let ci = 0; ci < requoteConvItems.length; ci += CONV_CHUNK) {
        const batchItems = requoteConvItems.slice(ci, ci + CONV_CHUNK);
        const result = await GMSCONFIRMNOM_SRV.send({
          method: 'POST',
          path: '/ConversionRequest',
          data: {
            RequestId: `Q${String(Math.floor(ci / CONV_CHUNK) + 1).padStart(3, '0')}`,
            ToItems: batchItems
          }
        });
        for (const c of (result?.ToItems || [])) {
          if (c.MsgType === 'S') requoteConvMap.set(`${c.NominationKey}__${c.NominationItem}`, parseFloat(c.TargetQty) || 0);
        }
      }
      for (const { idx } of requoteItems) {
        const reqKey = requoteConvItemKey.get(idx);
        if (reqKey && requoteConvMap.has(reqKey)) {
          scheduledResult[idx].ApprovedQtySM = f3(requoteConvMap.get(reqKey));
        }
      }
    }
  }

  for (const [vbeln] of epRawByVbeln) {
    if (corrDocIndex.has(vbeln)) continue;
    const unconfirmedInfo = unconfirmedByCorrespondingDoc.get(vbeln);
    if (!unconfirmedInfo) continue;
    if (unconfirmedInfo.Location) epVbelnToLocation.set(vbeln, unconfirmedInfo);
    unconfirmedEntryPointLinks.push({
      Vbeln: vbeln,
      DeliveryContract: unconfirmedInfo.ContractNo || '',
      BusinessLocation: unconfirmedInfo.Location,
      Message: 'Entry Point Delivery contract not yet confirmed — quantity excluded from allocation netting'
    });
  }

  return { epQtyByDeliveryContract, epQtyByLocation, epGcvNcvMap, epVbelnToLocation, unconfirmedEntryPointLinks };
}

function _createScopeChecker(missingLocSet, scheduledResult, contractToLoc) {
  const linkedInScopeLocs = new Set();
  if (missingLocSet && missingLocSet.size) {
    for (const r of scheduledResult) {
      if (missingLocSet.has(r.BusinessLocation)) continue;
      const doc = String(r.CorrespondingDocNo || '').trim();
      if (!doc) continue;
      const linkedLoc = contractToLoc.get(doc);
      if (linkedLoc && missingLocSet.has(linkedLoc)) linkedInScopeLocs.add(r.BusinessLocation);
    }
  }
  return (loc) => !missingLocSet || !missingLocSet.size || missingLocSet.has(loc) || linkedInScopeLocs.has(loc);
}

function _runDataIntegrityChecks(ctx) {
  const {
    scheduledResult, locMeta, inMissingScope, tpRawLocs, tpIncompletePairs,
    tpIncompleteLocs, ownGcvNcvMap, ownIncompleteLocs, tpCustomerMeterMap,
    tpGcvNcvMap, tpCustomerUploadedQtyMap, tpMeterMap, tpUploadedQtyMap,
    partnerNameMap, hybridSecondaryMeterMap, epQtyByLocation, epGcvNcvMap,
    tpCustomerRawSeen
  } = ctx;

  const entryPointOnlyLocs = new Set();
  const needsReading = new Set();
  const dpOnlyLocs = new Set();
  for (const r of scheduledResult) {
    const dp = r.DeliveryPoint || '';
    const rdp = r.RedeliveryPoint || '';
    const loc = r.BusinessLocation;
    if (!loc) continue;
    if (loc === rdp) needsReading.add(loc);
    else if (loc === dp) dpOnlyLocs.add(loc);
  }
  for (const loc of dpOnlyLocs) {
    if (!needsReading.has(loc)) entryPointOnlyLocs.add(loc);
  }

  const tpIncompletePairsByLoc = new Map();
  for (const tpKey of tpIncompletePairs) {
    const dunder = tpKey.indexOf('__');
    const loc = dunder >= 0 ? tpKey.slice(dunder + 2) : tpKey;
    if (!tpIncompletePairsByLoc.has(loc)) tpIncompletePairsByLoc.set(loc, []);
    tpIncompletePairsByLoc.get(loc).push(tpKey);
  }

  const missing = [];
  for (const [loc, meta] of locMeta) {
    if (!inMissingScope(loc) || entryPointOnlyLocs.has(loc)) continue;

    if (tpRawLocs.has(loc)) {
      const aPairs = tpIncompletePairsByLoc.get(loc) || [];
      for (const tpKey of aPairs) {
        const dunder = tpKey.indexOf('__');
        const customer = dunder >= 0 ? tpKey.slice(0, dunder) : '';
        missing.push({
          TransportSystem: meta.ts,
          TransportSystemName: meta.tsn,
          BusinessLocation: loc,
          BusinessLocationDesc: meta.desc,
          ReadingSource: 'THIRDPARTY',
          Partner: customer,
          PartnerName: partnerNameMap.get(customer) || '',
          Message: allocationUtils.tpMissingReasonMsgForPair(tpKey, tpCustomerMeterMap, tpGcvNcvMap, tpCustomerUploadedQtyMap)
        });
      }
      if (tpIncompleteLocs.has(loc) && !aPairs.length) {
        missing.push({
          TransportSystem: meta.ts,
          TransportSystemName: meta.tsn,
          BusinessLocation: loc,
          BusinessLocationDesc: meta.desc,
          ReadingSource: 'THIRDPARTY',
          Message: allocationUtils.tpMissingReasonMsg(loc, tpMeterMap, tpGcvNcvMap, tpUploadedQtyMap)
        });
      }
      continue;
    }

    let message = null;
    if (ownGcvNcvMap.has(loc)) {
      if (ownIncompleteLocs.has(loc)) {
        const own = ownGcvNcvMap.get(loc);
        message = allocationUtils.missingReasonMsg(own.totalMR, own, 'Meter Reading');
      }
    } else {
      message = 'Meter reading is missing';
    }

    if (message) {
      missing.push({
        TransportSystem: meta.ts,
        TransportSystemName: meta.tsn,
        BusinessLocation: loc,
        BusinessLocationDesc: meta.desc,
        ReadingSource: 'OWN',
        Message: message
      });
    }
  }

  // Entry Point Only Verification
  for (const loc of entryPointOnlyLocs) {
    if (!inMissingScope(loc)) continue;
    const epV = allocationUtils.validateAllocation('ENTRY-POINT', { Location: loc }, { epQtyByLocation, epGcvNcvMap });
    if (!epV.eligible) {
      const meta = locMeta.get(loc) || {};
      missing.push({
        TransportSystem: meta.ts || '',
        TransportSystemName: meta.tsn || '',
        BusinessLocation: loc,
        BusinessLocationDesc: meta.desc || '',
        ReadingSource: 'ENTRYPOINT',
        Message: epV.blockReason === 'EP_GCVNCV_MISSING' ? 'GCV/NCV missing' : 'CM Meter Qty missing'
      });
    }
  }

  // Check already-ticketed locations — THIRD-PARTY Redelivery at Location+Partner grain,
  // so one partner's ticket is never reported against other partners at the same point
  const alreadyTicketed = [];
  const alreadyTicketedKeys = new Set();
  for (const r of scheduledResult) {
    const loc = r.BusinessLocation;
    const ticketKey = String(r.TicketKey || '').trim();
    if (!loc || !ticketKey) continue;
    if (!allocationUtils.getTicketPurposeGate(r.TicketPurpose, r.TicketStatus).allocationBlocked) continue;

    const bTpPair = r.CustomerKind === 'THIRD-PARTY' && loc === r.RedeliveryPoint;
    const partner = bTpPair ? String(r.Partner || '').trim() : '';
    const grainKey = `${loc}__${partner}`;
    if (alreadyTicketedKeys.has(grainKey)) continue;
    alreadyTicketedKeys.add(grainKey);
    if (!inMissingScope(loc)) continue;

    const meta = locMeta.get(loc) || {};
    alreadyTicketed.push({
      TransportSystem: meta.ts || '',
      TransportSystemName: meta.tsn || '',
      BusinessLocation: loc,
      BusinessLocationDesc: meta.desc || '',
      ReadingSource: 'TICKETED',
      Partner: partner,
      PartnerName: bTpPair ? (r.PartnerName || '') : '',
      Message: `Already ticketed (Ticket Key ${ticketKey})`
    });
  }

  // Check orphan readings
  const nomLocSet = new Set(scheduledResult.map(r => r.BusinessLocation).filter(Boolean));
  const orphanReading = [];
  for (const [loc, d] of ownGcvNcvMap) {
    if ((d.totalMR || 0) > 0 && !nomLocSet.has(loc) && inMissingScope(loc)) {
      const meta = locMeta.get(loc) || {};
      orphanReading.push({
        TransportSystem: meta.ts || '',
        TransportSystemName: meta.tsn || '',
        BusinessLocation: loc,
        BusinessLocationDesc: meta.desc || '',
        ReadingSource: 'OWN',
        Message: 'Meter reading present — no Nomination found for this Business Location'
      });
    }
  }

  return { missing, alreadyTicketed, orphanReading };
}

function _detectMissingRanks(scheduledResult, inMissingScope) {
  const missingRank = [];
  for (const it of scheduledResult) {
    if (!inMissingScope(it.BusinessLocation)) continue;
    if (!allocationUtils.isUnrankedValue(it.Rank)) continue;
    missingRank.push({
      TransportSystem: it.TransportSystem,
      TransportSystemName: it.TransportSystemName,
      BusinessLocation: it.BusinessLocation,
      BusinessLocationDesc: it.BusinessLocationDesc,
      NominationKey: it.NominationKey,
      NominationItem: it.NominationItem,
      Contract: it.ContractNo,
      Partner: it.Partner,
      PartnerName: it.PartnerName,
      Message: (it.Rank == null || it.Rank === '') ? 'Rank not maintained' : 'Rank is 0'
    });
  }
  return missingRank;
}

function _mapToNomItemsCache(scheduledResult) {
  return scheduledResult.map(r => ({
    Location: r.BusinessLocation,
    LocationDesc: r.BusinessLocationDesc,
    DeliveryPoint: r.DeliveryPoint || '',
    DeliveryPointName: r.DeliveryPointName || '',
    RedeliveryPoint: r.RedeliveryPoint || '',
    RedeliveryPointName: r.RedeliveryPointName || '',
    LocationType: r.DeliveryPoint && r.BusinessLocation === r.DeliveryPoint ? 'DELIVERY' : 'REDELIVERY',
    _passthroughCounterpart: r._passthroughCounterpart || false,
    _counterpartRdpLocation: r._counterpartRdpLocation || '',
    TicketKey: r.TicketKey || '',
    // What the table's Ticket Key cell shows — blank unless 1/00 or 5/00
    TicketKeyDisplay: allocationUtils.isTicketKeyVisible(r.TicketKey, r.TicketPurpose, r.TicketStatus) ? r.TicketKey : '',
    TicketItem: r.TicketItem || '',
    TicketVersion: r.TicketVersion || '',
    TicketPurpose: r.TicketPurpose || '',
    TicketStatus: r.TicketStatus || '',
    TicketItemSubStatus: r.TicketItemSubStatus || '',
    NominationKey: r.NominationKey,
    NominationItem: r.NominationItem,
    Gasday: r.Gasday,
    Contract: r.ContractNo,
    CorrespondingDocNo: r.CorrespondingDocNo,
    ContractType: r.ContractType,
    ServiceType: r.ServiceType || '',
    Source: r.Source || '',
    TransportSystem: r.TransportSystem || '',
    TransportSystemName: r.TransportSystemName || '',
    Rank: (r.Rank != null && r.Rank !== '') ? Number(r.Rank) : null,
    Material: r.Material,
    MaterialName: r.MaterialName,
    ProposedDNQ: r.ApprovedDNQ,
    UOM: r.UOM,
    ConversionQty: r.ApprovedQtySM,
    ConversionUOM: r.ConversionUOM || 'SM3',
    SavedAllocatedQty: r.SavedAllocatedQty,
    SavedAllocatedUOM: r.SavedAllocatedUOM,
    AVG_WT_GCV: r.AVG_WT_GCV,
    AVG_WT_NCV: r.AVG_WT_NCV,
    AllocatedQty: r.AllocatedQty,
    AllocUOM: r.ConversionUOM || 'SM3',
    AllocatedQtyMBG: r.AllocatedQtyMBG ?? null,
    Partner: r.Partner || '',
    PartnerName: r.PartnerName || '',
    CustomerKind: r.CustomerKind || '',
    IsOwnPrimaryConnected: false,
    CustomerTypeDisplay: r.CustomerKind || 'OWN',
    CustomerTypeState: !r.CustomerKind ? 'Success' : r.CustomerKind === 'PRIMARY' ? 'Warning' : r.CustomerKind === 'HYBRID' ? 'Information' : 'Error',
    OverDrawlGSA: r.OverDrawlGSA || 0,
    UnderDrawlGSA: r.UnderDrawlGSA || 0,
    AuthOverrunGTA: r.AuthOverrunGTA || 0,
    UnauthOverrunGTA: r.UnauthOverrunGTA || 0,
    UnauthOverDrawlGSA: r.UnauthOverDrawlGSA || 0,
    AuthOverDrawlGSA: r.AuthOverDrawlGSA || 0,
    OverrunGTA: r.OverrunGTA || 0,
    DImbQty: r.DImbQty || 0,
    CNomQty: r.CNomQty || 0,
    CNomUOM: r.CNomUOM || '',
    OijStatus: r.OijStatus || '',
    DPIQty: r.DPIQty || 0,
    DNIQty: r.DNIQty || 0,
    CumImbQty: r.CumImbQty || 0,
    ChrgImbQty: r.ChrgImbQty || 0,
    PosCumImbQty: r.PosCumImbQty || 0,
    NegCumImbQty: r.NegCumImbQty || 0,
    LiqAdjustQty: r.LiqAdjustQty || 0,
    LiqDamDiscQty: r.LiqDamDiscQty || 0,
    SellOrPayAdjQty: r.SellOrPayAdjQty || 0,
    SellOrPayDiscQty: r.SellOrPayDiscQty || 0,
    SellersSFAdjQty: r.SellersSFAdjQty || 0,
    SSFDiscQty: r.SSFDiscQty || 0,
    TakeOrPayAdjQty: r.TakeOrPayAdjQty || 0,
    TakeOrPayDiscQty: r.TakeOrPayDiscQty || 0,
    GTAAdjust: !!r.GTAAdjust,
    GSAAdjust: !!r.GSAAdjust,
    GujDNQQty: r.GujDNQQty || 0,
    GujDNQUOM: r.GujDNQUOM || '',
    DDSQty: r.DDSQty || 0
  }));
}

function _applyOwnPrimaryConnectedLabels(nomItemsCache) {
  const ownRdpsSeen = new Set();
  const primaryOrHybridRdpsSeen = new Set();

  for (const it of nomItemsCache) {
    const cid = it.CustomerKind || '';
    const rdp = it.RedeliveryPoint;
    if (!rdp) continue;
    if (cid === '') ownRdpsSeen.add(rdp);
    else if (cid === 'PRIMARY' || cid === 'HYBRID') primaryOrHybridRdpsSeen.add(rdp);
  }

  const ownSlmcRdps = new Set([...ownRdpsSeen].filter(rdp => primaryOrHybridRdpsSeen.has(rdp)));
  if (ownSlmcRdps.size) {
    for (const it of nomItemsCache) {
      if ((it.CustomerKind || '') === '' && ownSlmcRdps.has(it.RedeliveryPoint)) {
        it.IsOwnPrimaryConnected = true;
        it.CustomerTypeDisplay = 'SLMC';
        it.CustomerTypeState = 'Warning';
      }
    }
  }
}

function _inheritDeliveryCustomerKind(nomItemsCache) {
  const custKindByContract = new Map();
  for (const it of nomItemsCache) {
    if (it.Contract && !custKindByContract.has(it.Contract) && it.CustomerKind) {
      custKindByContract.set(it.Contract, it.CustomerKind);
    }
  }
  for (const it of nomItemsCache) {
    if (it.LocationType !== 'DELIVERY' || it.CustomerKind || !it.CorrespondingDocNo) continue;
    const cType = custKindByContract.get(it.CorrespondingDocNo);
    if (!cType) continue;
    it.CustomerKind = cType;
    it.CustomerTypeDisplay = cType;
    it.CustomerTypeState = cType === 'PRIMARY' ? 'Warning' : cType === 'HYBRID' ? 'Information' : 'Error';
  }
}

function _enforceUniqueODataKey(nomItemsCache) {
  const seenKeys = new Map();
  const deduped = [];
  for (const it of nomItemsCache) {
    const key = `${it.Location}__${it.NominationKey}__${it.NominationItem}`;
    if (!seenKeys.has(key)) {
      seenKeys.set(key, it);
      deduped.push(it);
    }
  }
  return deduped;
}

function _nominationComparator(a, b) {
  const cidCmp = nomCache.custKindOrder(a.CustomerKind) - nomCache.custKindOrder(b.CustomerKind);
  if (cidCmp !== 0) return cidCmp;

  const stCmp = nomCache.stBucket(a.ServiceType) - nomCache.stBucket(b.ServiceType);
  if (stCmp !== 0) return stCmp;

  const locDescCmp = String(a.LocationDesc || '').localeCompare(String(b.LocationDesc || ''));
  if (locDescCmp !== 0) return locDescCmp;

  return nomCache.rankOrder(a) - nomCache.rankOrder(b);
}

function _stitchDeliveryCounterparts(nomItemsCache) {
  const deliveriesByContract = new Map();
  const deliveriesByNomKey = new Map();

  // 1. Index all DELIVERY legs by ContractNo and NominationKey
  for (let i = 0; i < nomItemsCache.length; i++) {
    const item = nomItemsCache[i];
    if (item.LocationType === 'DELIVERY') {
      const con = normDoc(item.Contract);
      if (con) deliveriesByContract.set(con, item);

      if (!deliveriesByNomKey.has(item.NominationKey)) {
        deliveriesByNomKey.set(item.NominationKey, []);
      }
      deliveriesByNomKey.get(item.NominationKey).push(item);
    }
  }

  // 2. Filter Redeliveries in their already pre-sorted order
  const redeliveries = nomItemsCache.filter(item => item.LocationType === 'REDELIVERY');
  const arranged = [];
  const pairedDeliveryContracts = new Set();

  // 3. Interleave: REDELIVERY row -> matched DELIVERY row directly beneath it
  for (let i = 0; i < redeliveries.length; i++) {
    const redel = redeliveries[i];
    arranged.push(redel);

    let matchingDelivery = null;
    const corrDoc = normDoc(redel.CorrespondingDocNo);

    // Primary match: via CorrespondingDocNo pointing to Delivery leg's ContractNo
    if (corrDoc && deliveriesByContract.has(corrDoc)) {
      matchingDelivery = deliveriesByContract.get(corrDoc);
    }
    // Fallback match: via shared NominationKey
    else if (deliveriesByNomKey.has(redel.NominationKey)) {
      const candidates = deliveriesByNomKey.get(redel.NominationKey);
      matchingDelivery = candidates.find(d => !pairedDeliveryContracts.has(normDoc(d.Contract)));
    }

    // If paired Delivery leg found, insert it immediately below
    if (matchingDelivery) {
      const delKey = normDoc(matchingDelivery.Contract);
      if (!pairedDeliveryContracts.has(delKey)) {
        arranged.push(matchingDelivery);
        pairedDeliveryContracts.add(delKey);
      }
    }
  }

  // 4. Append orphan/standalone deliveries that had no Redelivery counterpart
  for (let i = 0; i < nomItemsCache.length; i++) {
    const item = nomItemsCache[i];
    if (item.LocationType === 'DELIVERY') {
      const delKey = normDoc(item.Contract);
      if (!pairedDeliveryContracts.has(delKey)) {
        arranged.push(item);
      }
    }
  }

  // 5. Reassign continuous 1-based SortSeq for table ordering
  for (let idx = 0; idx < arranged.length; idx++) {
    arranged[idx].SortSeq = idx + 1;
  }

  return arranged;
}

function _extractSimpleFilters(where) {
  const result = {};
  function parse(arr) {
    for (let i = 0; i < arr.length; i++) {
      const token = arr[i];
      if (token?.ref) {
        const field = token.ref[0];
        if (arr[i + 1] === '=' && arr[i + 2]?.val !== undefined) {
          if (!result[field]) result[field] = [];
          result[field].push(arr[i + 2].val);
          i += 2;
        }
      }
      if (token?.xpr) parse(token.xpr);
    }
  }
  parse(where);
  return result;
}

function _evalCQLWhere(where, row, skipFields) {
  if (!where?.length) return true;

  // Nested xpr groups are evaluated as a unit by evalPrimary — never flatten them
  // into the parent, or `A and (B or C) and D` turns into `A and B or C and D`.
  function evalTokens(toks) {
    return evalOr(toks, { i: 0 });
  }

  // Always evaluate the right operand (no `||`/`&&` short-circuit) so ctx.i keeps
  // advancing past its tokens — skipping it left the cursor mid-expression.
  function evalOr(toks, ctx) {
    let result = evalAnd(toks, ctx);
    while (ctx.i < toks.length) {
      const op = (toks[ctx.i] || '').toString().toUpperCase();
      if (op !== 'OR') break;
      ctx.i++;
      const rhs = evalAnd(toks, ctx);
      result = result || rhs;
    }
    return result;
  }

  function evalAnd(toks, ctx) {
    let result = evalPrimary(toks, ctx);
    while (ctx.i < toks.length) {
      const op = (toks[ctx.i] || '').toString().toUpperCase();
      if (op !== 'AND') break;
      ctx.i++;
      const rhs = evalPrimary(toks, ctx);
      result = result && rhs;
    }
    return result;
  }

  function normVal(v) {
    if (v instanceof Date) return v.toISOString().slice(0, 10);
    return v == null ? '' : String(v);
  }

  function evalPrimary(toks, ctx) {
    const t = toks[ctx.i];
    if (t?.xpr) {
      ctx.i++;
      return evalTokens(t.xpr);
    }
    if (t?.func) {
      ctx.i++;
      const fn = (t.func || '').toLowerCase();
      const fieldRef = t.args?.[0]?.ref?.[0];
      const searchVal = t.args?.[1]?.val;
      if (fieldRef !== undefined && searchVal !== undefined) {
        const rowVal = normVal(row[fieldRef]).toLowerCase();
        const needle = normVal(searchVal).toLowerCase();
        if (fn === 'contains') return rowVal.includes(needle);
        if (fn === 'startswith') return rowVal.startsWith(needle);
        if (fn === 'endswith') return rowVal.endsWith(needle);
      }
      return true;
    }
    if (t?.ref && toks[ctx.i + 2]?.val !== undefined) {
      const field = t.ref[0];
      const op = toks[ctx.i + 1];
      const val = toks[ctx.i + 2].val;
      ctx.i += 3;
      if (skipFields?.has(field)) return true;
      const rv = normVal(row[field]);
      const cv = normVal(val);
      switch (op) {
        case '=': return rv === cv;
        case '!=': return rv !== cv;
        case '>=': return rv >= cv;
        case '<=': return rv <= cv;
        case '>': return rv > cv;
        case '<': return rv < cv;
        default: return true;
      }
    }
    ctx.i++;
    return true;
  }

  return evalTokens(where);
}

function _applyDynamicSort(a, b, orderBy) {
  for (const ord of orderBy) {
    const field = ord.ref?.[0];
    if (!field) continue;

    let cmp;
    if (field === 'CustomerKind') {
      cmp = nomCache.custKindOrder(a.CustomerKind) - nomCache.custKindOrder(b.CustomerKind);
    } else if (field === 'ServiceType') {
      cmp = nomCache.stBucket(a.ServiceType) - nomCache.stBucket(b.ServiceType);
    } else if (field === 'Rank') {
      cmp = nomCache.rankOrder(a) - nomCache.rankOrder(b);
    } else {
      const va = a[field] ?? '', vb = b[field] ?? '';
      const na = parseFloat(va), nb = parseFloat(vb);
      cmp = (!isNaN(na) && !isNaN(nb) && na !== nb)
        ? na - nb
        : nomCache.toIsoDate(va).localeCompare(nomCache.toIsoDate(vb));
    }
    if (cmp !== 0) return ord.sort === 'desc' ? -cmp : cmp;
  }
  return 0;
}