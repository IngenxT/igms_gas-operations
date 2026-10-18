const cds = require('@sap/cds');
const crypto = require('crypto');
const nomCache = require('./nomCache');
const allocationUtils = require('../../utils/allocationUtils');
const { resolveLocationsByTS } = require('../../utils/locationResolver');
const { chunk, runChunked, buildLocFilter, buildBusLocFilter, normDoc } = require('../../utils/nomSourceFetch');
const { fetchARI006Rules, evaluateRowARI006, dateKey } = require('../../utils/ari006Rules');

const _r3 = v => Math.round(Number(v || 0) * 1000) / 1000;
const _r4 = v => Math.round(Number(v || 0) * 10000) / 10000;

// In-memory job tracker — read by getProcessTicketingJobStatus; requires instances: 1
const _ticketJobs = new Map();
const JOB_TTL_MS = 2 * 60 * 60 * 1000; // 2 hours

const _evictOldJobs = () => {
  const now = Date.now();
  for (const [id, job] of _ticketJobs) {
    if (job.completedAt && (now - job.completedAt.getTime()) > JOB_TTL_MS) {
      _ticketJobs.delete(id);
    }
  }
};

const _setJobStatus = (jobId, patch) => {
  const job = _ticketJobs.get(jobId);
  if (job) Object.assign(job, patch);
};

module.exports = async (srv) => {
  const GMSCONFIRMNOM_SRV = await cds.connect.to('GMSCONFIRMNOM_SRV');
  const YGMS_GAS_ALLOCATION_SRV = await cds.connect.to('YGMS_GAS_ALLOCATION_SRV');
  const GMSTICKET_API_SRV = await cds.connect.to('GMSTICKET_API_SRV');
  const GMSVALUEHELP_SRV = await cds.connect.to('GMSVALUEHELP_SRV');
  const igmsConfigMetaData = await cds.connect.to('igmsConfigMetaData');

  // Status Poll Handler
  // A job is visible only to the user who submitted it — S/4 logs every execution under
  // the technical destination user, so this is the only record of who ran what.
  srv.on('getProcessTicketingJobStatus', req => {
    const { jobId } = req.data || {};
    const job = jobId && _ticketJobs.get(jobId);
    if (!job || job.user !== req.user?.id) return { jobId: jobId || '', status: 'NOT_FOUND' };
    return {
      jobId: job.jobId,
      status: job.status,
      error: job.error,
      gasday: job.gasday,
      startedAt: job.startedAt,
      completedAt: job.completedAt,
      processedItems: job.processedItems
    };
  });

  srv.on('processTicketing', async (req) => {
    const log = cds.log('processTicketing');
    const { Gasday, SelectionFilter, SegmentFilter } = req.data;

    if (!Gasday) return req.reject(400, 'Gasday is required');

    // 1. Retrieve Warm Cache (Auto-warm if cold)
    let cacheEntry = nomCache.cache.get(Gasday);
    if (!cacheEntry || !cacheEntry.data?.length) {
      try {
        await srv.send('getScheduledNomItemsWithSCADA', {
          Gasday,
          LocationFilter: SelectionFilter?.RedeliveryPoints?.join(',') || SelectionFilter?.DeliveryPoints?.join(',') || '',
          TransportSystem: SelectionFilter?.TransportSystem?.join(',') || ''
        });
        cacheEntry = nomCache.cache.get(Gasday);
      } catch (err) {
        log.error(`[processTicketing] Auto-warm failed for Gasday ${Gasday}`, err);
        return req.reject(500, `Failed to retrieve nomination data from backend for Gasday ${Gasday}.`);
      }
    }

    if (!cacheEntry || !cacheEntry.data || cacheEntry.data.length === 0) {
      return {
        Gasday,
        Mode: 'TICKETING',
        JobId: null,
        Status: 'EMPTY',
        EligibleLocationsForTicketing: [],
        EligibleThirdPartyPairsForTicketing: [],
        SkippedDueToMissingMeters: [],
        SkippedDueToBusinessRule: [],
        SkippedDueToNominationDrift: [],
        SkippedDueToQualityDrift: [],
        SkippedDueToBalanceMismatch: [],
        BlockedByRank: []
      };
    }

    const {
      data: cachedNominations,
      ownGcvNcvMap,
      tpCustomerMeterMap,
      tpGcvNcvMap,
      tpCustomerUploadedQtyMap,
      epQtyByLocation,
      epGcvNcvMap
    } = cacheEntry;

    const zeroQtyPairs = cacheEntry?.tpZeroQtyPairs || new Set();

    // 2. Parse Execution Scope
    const targetScope = await _parseExecutionScope({
      SelectionFilter,
      SegmentFilter,
      GMSVALUEHELP_SRV,
      log
    });

    const {
      activeSegments,
      scopedDeliveryLocs,
      scopedRedeliveryLocs,
      scopedTpPairs,
      scopedOwnHybridLocs
    } = targetScope;

    const skippedDueToMissingMeters = [];
    const skippedDueToBusinessRule = [];
    const skippedDueToNominationDrift = [];
    const skippedDueToQualityDrift = [];
    const skippedDueToBalanceMismatch = [];
    const blockedByRank = [];

    // ═════════════════════════════════════════════════════════════════════════
    // PHASE 1A: PRE-FLIGHT (Meters, Rank, Ticket Purpose/Status)
    // ═════════════════════════════════════════════════════════════════════════
    const missingMeterLocations = new Set();
    const missingTpPairs = new Set();
    const nominatedDeliveryLocsInScope = new Set();
    const nominatedRedeliveryLocsInScope = new Set();
    const nominatedTpPairsInScope = new Set();

    for (const nom of cachedNominations) {
      const loc = nom.Location;
      if (!loc) continue;

      const custKind = nom.CustomerKind || 'OWN';

      if (nom.LocationType === 'DELIVERY') {
        if (!activeSegments.has('ENTRYPOINT')) continue;
        if (scopedDeliveryLocs && !scopedDeliveryLocs.has(loc)) continue;
        nominatedDeliveryLocsInScope.add(loc);
      } else if (nom.LocationType === 'REDELIVERY') {
        if (!_isKindInActiveSegments(custKind, loc, activeSegments, scopedOwnHybridLocs)) continue;
        if (scopedRedeliveryLocs && !scopedRedeliveryLocs.has(loc)) continue;

        if (custKind === 'THIRD-PARTY') {
          if (nom.Partner) {
            const pairKey = `${nom.Partner}__${loc}`;
            if (!scopedTpPairs || scopedTpPairs.has(pairKey)) {
              nominatedTpPairsInScope.add(pairKey);
            }
          }
        } else {
          nominatedRedeliveryLocsInScope.add(loc);
        }
      }
    }

    // Check Meter Integrity: Entry Point (Delivery)
    if (activeSegments.has('ENTRYPOINT')) {
      for (const loc of nominatedDeliveryLocsInScope) {
        const totalMR = epQtyByLocation.get(loc) || ownGcvNcvMap.get(loc)?.totalMR || 0;
        const qual = epGcvNcvMap.get(loc) || ownGcvNcvMap.get(loc);
        const hasQual = !!qual && qual.gcv > 0 && qual.ncv > 0;

        if (!(totalMR > 0) || !hasQual) {
          missingMeterLocations.add(`DELIVERY__${loc}`);
          skippedDueToMissingMeters.push({
            Location: loc,
            Segment: 'ENTRYPOINT',
            Reason: !(totalMR > 0) ? 'CM Meter Qty is missing' : 'GCV/NCV reading is missing'
          });
        }
      }
    }

    // Check Meter Integrity: Own & Hybrid (Redelivery)
    if (activeSegments.has('OWN') || activeSegments.has('HYBRID')) {
      for (const loc of nominatedRedeliveryLocsInScope) {
        const ownData = ownGcvNcvMap.get(loc);
        const hasOwnMeter = !!ownData && (ownData.totalMR > 0);
        const hasOwnQual = !!ownData && (ownData.gcv > 0 && ownData.ncv > 0);

        if (!hasOwnMeter || !hasOwnQual) {
          missingMeterLocations.add(`REDELIVERY__${loc}`);
          skippedDueToMissingMeters.push({
            Location: loc,
            Segment: 'OWN/HYBRID',
            Reason: !hasOwnMeter ? 'Meter reading is missing or zero' : 'GCV/NCV is missing'
          });
        }
      }
    }

    // Check Meter Integrity: Third Party (Redelivery)
    if (activeSegments.has('THIRDPARTY')) {
      for (const pairKey of nominatedTpPairsInScope) {
        const [cust, loc] = pairKey.split('__');
        const qty = tpCustomerMeterMap.get(pairKey) || 0;
        const qual = tpGcvNcvMap.get(loc);
        const rawUpload = tpCustomerUploadedQtyMap.get(pairKey) || 0;
        const hasQual = !!qual && qual.gcv > 0 && qual.ncv > 0;
        const isZeroUploadAllowed = zeroQtyPairs.has(pairKey) && hasQual;

        if (!((qty > 0 && hasQual) || isZeroUploadAllowed)) {
          missingTpPairs.add(pairKey);
          skippedDueToMissingMeters.push({
            Location: loc,
            Partner: cust,
            Segment: 'THIRDPARTY',
            Reason: !hasQual ? 'GCV/NCV missing' : 'Meter reading is missing or zero'
          });
        }
      }
    }

    // Check Rank (Whole-Location Lock: missing/0 rank blocks the entire location)
    const blockedLocationsSet = new Set();
    const rankBlockedTpPairs = new Set();
    const rankBlockInfoByLoc = new Map();
    // Ticket Purpose/Status (allocationUtils.getItemTicketGate) is applied per line item in
    // _collectProcessedItems — a blocked item is left out of ActualizeTicket, the rest of
    // its location is still ticketed.

    for (const row of cachedNominations) {
      const loc = row.Location;
      if (!loc) continue;

      const custKind = row.CustomerKind || 'OWN';

      if (row.LocationType === 'DELIVERY') {
        if (!activeSegments.has('ENTRYPOINT')) continue;
        if (scopedDeliveryLocs && !scopedDeliveryLocs.has(loc)) continue;
      } else if (row.LocationType === 'REDELIVERY') {
        if (!_isKindInActiveSegments(custKind, loc, activeSegments, scopedOwnHybridLocs)) continue;
        if (scopedRedeliveryLocs && !scopedRedeliveryLocs.has(loc)) continue;
        const tpPairKey = `${row.Partner}__${loc}`;
        if (custKind === 'THIRD-PARTY' && scopedTpPairs && !scopedTpPairs.has(tpPairKey)) continue;
      } else {
        continue;
      }

      // A ticket-blocked item is not re-ticketed, so its own Rank is irrelevant
      if (allocationUtils.getItemTicketGate(row).ticketingBlocked) continue;

      // THIRD-PARTY Redelivery is Location+Customer grain: one partner's rank gap blocks
      // only that partner, never other partners at the same connection point
      if (allocationUtils.isUnrankedValue(row.Rank)) {
        const bTpPairGrain = custKind === 'THIRD-PARTY' && row.LocationType === 'REDELIVERY';
        const rankKey = bTpPairGrain ? `${row.Partner}__${loc}` : loc;
        if (bTpPairGrain) rankBlockedTpPairs.add(rankKey);
        else blockedLocationsSet.add(loc);
        if (!rankBlockInfoByLoc.has(rankKey)) {
          rankBlockInfoByLoc.set(rankKey, {
            loc,
            partner: bTpPairGrain ? row.Partner : '',
            contract: row.Contract,
            nomKey: row.NominationKey,
            nomItem: row.NominationItem
          });
        }
      }
    }

    for (const info of rankBlockInfoByLoc.values()) {
      blockedByRank.push({
        Location: info.loc,
        Partner: info.partner,
        Reason: info.partner
          ? `Ticketing blocked for this Location & Partner due to missing or 0 Rank on Contract ${info.contract} (${info.nomKey}/${info.nomItem})`
          : `Ticketing blocked for entire Location due to missing or 0 Rank on Contract ${info.contract} (${info.nomKey}/${info.nomItem})`
      });
    }

    // ═════════════════════════════════════════════════════════════════════════
    // PHASE 1B: DYNAMIC BUSINESS RULE ENGINE (ARI006 - TICKETING BLOCK)
    // ═════════════════════════════════════════════════════════════════════════
    const ruleBlockedLocations = new Set();
    const ruleBlockedTpPairs = new Set();

    let ari006Rules = [];
    try {
      ari006Rules = await fetchARI006Rules(igmsConfigMetaData, log);
    } catch (err) {
      log.error('[processTicketing] Failed to fetch ARI006 Business Rules', err);
    }

    const todayStr = dateKey(new Date().toISOString());

    if (ari006Rules.length > 0) {
      for (const row of cachedNominations) {
        const loc = row.Location;
        if (!loc) continue;

        const custKind = row.CustomerKind || 'OWN';

        if (row.LocationType === 'DELIVERY') {
          if (!activeSegments.has('ENTRYPOINT')) continue;
          if (scopedDeliveryLocs && !scopedDeliveryLocs.has(loc)) continue;
        } else if (row.LocationType === 'REDELIVERY') {
          if (!_isKindInActiveSegments(custKind, loc, activeSegments, scopedOwnHybridLocs)) continue;
          if (scopedRedeliveryLocs && !scopedRedeliveryLocs.has(loc)) continue;
          const tpPairKey = `${row.Partner}__${loc}`;
          if (custKind === 'THIRD-PARTY' && scopedTpPairs && !scopedTpPairs.has(tpPairKey)) continue;
        } else {
          continue;
        }

        const isTP = custKind === 'THIRD-PARTY';
        const tpPairKey = `${row.Partner}__${loc}`;
        const ruleEval = evaluateRowARI006(row, ari006Rules, todayStr);

        if (ruleEval && ruleEval.blocked) {
          if (isTP) {
            ruleBlockedTpPairs.add(tpPairKey);
            if (!skippedDueToBusinessRule.some(r => r.Location === loc && r.Partner === row.Partner)) {
              skippedDueToBusinessRule.push({
                Location: loc,
                Partner: row.Partner,
                RuleID: ruleEval.ruleID,
                Reason: ruleEval.message
              });
            }
          } else {
            ruleBlockedLocations.add(loc);
            if (!skippedDueToBusinessRule.some(r => r.Location === loc && !r.Partner)) {
              skippedDueToBusinessRule.push({
                Location: loc,
                RuleID: ruleEval.ruleID,
                Reason: ruleEval.message
              });
            }
          }
        }
      }
    }

    // Determine Candidates for Drift Checks
    let candidateDeliveryLocs = new Set();
    let candidateRedeliveryLocs = new Set();
    let candidateTpPairs = new Set();

    for (const loc of nominatedDeliveryLocsInScope) {
      if (
        !missingMeterLocations.has(`DELIVERY__${loc}`) &&
        !blockedLocationsSet.has(loc) &&
        !ruleBlockedLocations.has(loc)
      ) {
        candidateDeliveryLocs.add(loc);
      }
    }

    for (const loc of nominatedRedeliveryLocsInScope) {
      if (
        !missingMeterLocations.has(`REDELIVERY__${loc}`) &&
        !blockedLocationsSet.has(loc) &&
        !ruleBlockedLocations.has(loc)
      ) {
        candidateRedeliveryLocs.add(loc);
      }
    }

    for (const pairKey of nominatedTpPairsInScope) {
      const loc = pairKey.split('__')[1];
      const hasMeter = (tpCustomerMeterMap.get(pairKey) > 0) || zeroQtyPairs.has(pairKey);

      if (
        hasMeter &&
        !missingTpPairs.has(pairKey) &&
        !rankBlockedTpPairs.has(pairKey) &&
        !ruleBlockedTpPairs.has(pairKey)
      ) {
        candidateTpPairs.add(pairKey);
      }
    }

    // ═════════════════════════════════════════════════════════════════════════
    // PHASE 2: LIVE S/4 NOMINATION DRIFT CHECK
    // ═════════════════════════════════════════════════════════════════════════
    const allCandidateLocs = new Set([
      ...candidateDeliveryLocs,
      ...candidateRedeliveryLocs,
      ...Array.from(candidateTpPairs).map(p => p.split('__')[1])
    ]);

    const aCandLocs = Array.from(allCandidateLocs);
    let liveNomRows = [];

    if (aCandLocs.length > 0) {
      const liveQueries = chunk(aCandLocs, 50).map(batch =>
        SELECT.from('xGMSxNOMSOURCE')
          .columns('Gasday', 'NominationKey', 'NominationItem', 'DeliveryPoint', 'RedeliveryPoint', 'ContractNo', 'CustomerKind', 'Partner')
          .where`Gasday = ${Gasday} and isConfirmRequired = ${false}`
          .where(buildLocFilter(batch, batch))
      );
      liveNomRows = await runChunked(GMSCONFIRMNOM_SRV, liveQueries);
    }

    // Drift is compared at each candidate's own grain: Delivery rows per Location,
    // non-THIRD-PARTY Redelivery rows per Location, THIRD-PARTY Redelivery rows per
    // Location+Partner — one partner's changed nominations never block another partner.
    const liveKeysByGrain = new Map();
    const cachedKeysByGrain = new Map();
    const _addKey = (oMap, sGrain, r) => {
      if (!oMap.has(sGrain)) oMap.set(sGrain, new Set());
      oMap.get(sGrain).add(`${normDoc(r.NominationKey)}__${normDoc(r.NominationItem)}`);
    };
    const _redeliveryGrain = (loc, custKind, partner) => custKind === 'THIRD-PARTY'
      ? `REDELIVERY__${loc}__${String(partner || '').trim()}`
      : `REDELIVERY__${loc}`;

    for (const r of liveNomRows) {
      if (r.DeliveryPoint) _addKey(liveKeysByGrain, `DELIVERY__${r.DeliveryPoint}`, r);
      if (r.RedeliveryPoint) _addKey(liveKeysByGrain, _redeliveryGrain(r.RedeliveryPoint, r.CustomerKind, r.Partner), r);
    }
    for (const r of cachedNominations) {
      if (!r.Location) continue;
      const sGrain = r.LocationType === 'DELIVERY'
        ? `DELIVERY__${r.Location}`
        : _redeliveryGrain(r.Location, r.CustomerKind, r.Partner);
      _addKey(cachedKeysByGrain, sGrain, r);
    }

    const _isDrifted = sGrain => {
      const liveSet = liveKeysByGrain.get(sGrain) || new Set();
      const cachedSet = cachedKeysByGrain.get(sGrain) || new Set();
      if (liveSet.size !== cachedSet.size) return true;
      for (const itemKey of cachedSet) if (!liveSet.has(itemKey)) return true;
      return false;
    };
    const _reportDrift = (loc, partner) => {
      if (!skippedDueToNominationDrift.some(d => d.Location === loc && (d.Partner || '') === (partner || ''))) {
        skippedDueToNominationDrift.push({
          Location: loc,
          Partner: partner || '',
          Reason: 'Nomination data changed in S/4. Please refresh.'
        });
      }
    };

    for (const loc of [...candidateDeliveryLocs]) {
      if (_isDrifted(`DELIVERY__${loc}`)) { candidateDeliveryLocs.delete(loc); _reportDrift(loc); }
    }
    for (const loc of [...candidateRedeliveryLocs]) {
      if (_isDrifted(`REDELIVERY__${loc}`)) { candidateRedeliveryLocs.delete(loc); _reportDrift(loc); }
    }
    for (const pairKey of [...candidateTpPairs]) {
      const [partner, loc] = pairKey.split('__');
      if (_isDrifted(_redeliveryGrain(loc, 'THIRD-PARTY', partner))) { candidateTpPairs.delete(pairKey); _reportDrift(loc, partner); }
    }

    // ═════════════════════════════════════════════════════════════════════════
    // PHASE 3: LIVE GDA QUALITY (GCV/NCV) DRIFT CHECK
    // ═════════════════════════════════════════════════════════════════════════
    const remainingCandidateLocs = new Set([
      ...candidateDeliveryLocs,
      ...candidateRedeliveryLocs,
      ...Array.from(candidateTpPairs).map(p => p.split('__')[1])
    ]);

    const gasdayParam = String(Gasday).substring(0, 10) + 'T00:00:00';
    let liveGdaRows = [];

    if (remainingCandidateLocs.size > 0) {
      const aGdaLocs = Array.from(remainingCandidateLocs);
      const liveGdaQueries = chunk(aGdaLocs, 12).map(batch =>
        SELECT.from('YGMS_ALLOCATION_GAS_DATASet')
          .where({ YydateGas: gasdayParam })
          .where(buildBusLocFilter(batch))
      );
      liveGdaRows = await runChunked(YGMS_GAS_ALLOCATION_SRV, liveGdaQueries);
    }

    const qualityDriftLocs = new Set();

    for (const loc of remainingCandidateLocs) {
      const locGdaRows = liveGdaRows.filter(r => r.YybusLocation === loc);
      const isTP = cachedNominations.some(r => r.Location === loc && r.CustomerKind === 'THIRD-PARTY');

      let liveGcv = 0, liveNcv = 0;

      if (isTP) {
        const cvRow = locGdaRows.find(r => r.Yy_Indicator === 'THIRDPARTY' && parseFloat(r.YygcvNgail || 0) > 0);
        if (cvRow) {
          liveGcv = parseFloat(cvRow.YygcvNgail || 0);
          liveNcv = parseFloat(cvRow.YyncvNgail || 0);
        }
      } else {
        const ownRow = locGdaRows.find(r => r.Yy_Indicator === 'OWN');
        if (ownRow) {
          liveGcv = parseFloat(ownRow.YyavgGcvCm || 0);
          liveNcv = parseFloat(ownRow.YyavgNcvCm || 0);
        }
      }

      const cachedQual = isTP ? tpGcvNcvMap.get(loc) : (ownGcvNcvMap.get(loc) || epGcvNcvMap.get(loc));
      const cachedGcv = cachedQual?.gcv || 0;
      const cachedNcv = cachedQual?.ncv || 0;

      const gcvDiff = Math.abs(_r4(liveGcv) - _r4(cachedGcv));
      const ncvDiff = Math.abs(_r4(liveNcv) - _r4(cachedNcv));

      if (gcvDiff > 0.0001 || ncvDiff > 0.0001) {
        qualityDriftLocs.add(loc);
        skippedDueToQualityDrift.push({
          Location: loc,
          Reason: `Live GCV/NCV shifted since allocation. Cached: (${cachedGcv}/${cachedNcv}), Live: (${liveGcv}/${liveNcv})`
        });
      }
    }

    for (const loc of qualityDriftLocs) {
      candidateDeliveryLocs.delete(loc);
      candidateRedeliveryLocs.delete(loc);
    }
    candidateTpPairs = new Set([...candidateTpPairs].filter(p => !qualityDriftLocs.has(p.split('__')[1])));

    // ═════════════════════════════════════════════════════════════════════════
    // PHASE 4: BALANCE INVARIANT CHECK (QtyToAllocate = Sum(AllocatedQty + OverDrawl))
    // ═════════════════════════════════════════════════════════════════════════
    const finalEligibleLocations = new Set();
    const finalEligibleTpPairs = new Set();
    const finalEligibleDeliveryLocs = new Set();
    const finalEligibleRedeliveryLocs = new Set();

    // 1. ENTRY-POINT: Unified Delivery Location CM Meter (totalMR)
    for (const loc of candidateDeliveryLocs) {
      const targetMR = _r3(epQtyByLocation.get(loc) || ownGcvNcvMap.get(loc)?.totalMR || 0);
      const locItems = cachedNominations.filter(r => r.Location === loc && r.LocationType === 'DELIVERY');

      if (locItems.length === 0) {
        skippedDueToBalanceMismatch.push({
          Location: loc,
          Segment: 'ENTRYPOINT',
          Reason: 'Meter reading uploaded, but no nomination found for the location.'
        });
        continue;
      }

      const sumAlloc = locItems.reduce((acc, r) => acc + (parseFloat(r.AllocatedQty || 0) + parseFloat(r.OverDrawlGSA || 0)), 0);
      const balancedSum = _r3(sumAlloc);

      if (Math.abs(targetMR - balancedSum) > 0.005) {
        const sReason = balancedSum === 0
          ? `Meter (${targetMR}) != Total Allocated (0). Nominations exist but not allocated.`
          : `Meter reading (${targetMR}) does not match Total Allocated (${balancedSum}).`;

        skippedDueToBalanceMismatch.push({
          Location: loc,
          Segment: 'ENTRYPOINT',
          Reason: sReason
        });
      } else {
        finalEligibleLocations.add(loc);
        finalEligibleDeliveryLocs.add(loc);
      }
    }

    // 2. OWN & HYBRID: Entire Physical Location Meter Reading (totalMR)
    for (const loc of candidateRedeliveryLocs) {
      const physicalMeter = ownGcvNcvMap.get(loc);
      const locMeterQty = _r3(physicalMeter?.totalMR || 0);
      const locItems = cachedNominations.filter(
        r => r.Location === loc && r.LocationType === 'REDELIVERY' && r.CustomerKind !== 'THIRD-PARTY'
      );

      if (locItems.length === 0) {
        skippedDueToBalanceMismatch.push({
          Location: loc,
          Segment: 'OWN/HYBRID',
          Reason: 'Meter reading uploaded, but no nomination found for the location.'
        });
        continue;
      }

      const sumAlloc = locItems.reduce((acc, r) => acc + (parseFloat(r.AllocatedQty || 0) + parseFloat(r.OverDrawlGSA || 0)), 0);
      const balancedSum = _r3(sumAlloc);

      if (Math.abs(locMeterQty - balancedSum) > 0.005) {
        const sReason = balancedSum === 0
          ? `Location Meter (${locMeterQty}) != Total Allocated (0). Nominations exist but not allocated.`
          : `Meter reading (${locMeterQty}) does not match Total Allocated (${balancedSum}).`;

        skippedDueToBalanceMismatch.push({
          Location: loc,
          Segment: 'OWN/HYBRID',
          Reason: sReason
        });
      } else {
        finalEligibleLocations.add(loc);
        finalEligibleRedeliveryLocs.add(loc);
      }
    }

    // 3. THIRD-PARTY: Granular Customer + Location Meter Reading
    for (const pairKey of candidateTpPairs) {
      const [cust, loc] = pairKey.split('__');
      const poolQty = _r3(tpCustomerMeterMap.get(pairKey) || 0);
      const pairItems = cachedNominations.filter(
        r => r.Location === loc && r.Partner === cust && r.LocationType === 'REDELIVERY' && r.CustomerKind === 'THIRD-PARTY'
      );

      if (pairItems.length === 0) {
        skippedDueToBalanceMismatch.push({
          Location: loc,
          Partner: cust,
          Segment: 'THIRDPARTY',
          Reason: 'Customer allocation uploaded but no nomination found for location and Customer.'
        });
        continue;
      }

      const sumAlloc = pairItems.reduce((acc, r) => acc + (parseFloat(r.AllocatedQty || 0) + parseFloat(r.OverDrawlGSA || 0)), 0);
      const balancedSum = _r3(sumAlloc);

      if (Math.abs(poolQty - balancedSum) > 0.005) {
        const sReason = balancedSum === 0
          ? `Partner allocation (${poolQty}) != Total Allocated (0). Nominations exist but not allocated.`
          : `Meter reading (${poolQty}) does not match Total Allocated (${balancedSum}).`;

        skippedDueToBalanceMismatch.push({
          Location: loc,
          Partner: cust,
          Segment: 'THIRDPARTY',
          Reason: sReason
        });
      } else {
        finalEligibleTpPairs.add(pairKey);
      }
    }

    // ── Properly Scoped Arrays for Submission & Manifest Output ───────────────
    const aEligibleLocs = Array.from(finalEligibleLocations);
    const aEligibleTpPairs = Array.from(finalEligibleTpPairs).map(p => ({
      Partner: p.split('__')[0],
      Location: p.split('__')[1]
    }));

    // Nomination items this run submits — the Ticketing Results page shows only these
    const { items: aProcessedItems, ticketBlockedRows } = _collectProcessedItems(
      cachedNominations, finalEligibleDeliveryLocs, finalEligibleRedeliveryLocs, finalEligibleTpPairs
    );
    const skippedDueToTicketStatus = ticketBlockedRows.map(r => ({
      Location: r.Location,
      Partner: r.CustomerKind === 'THIRD-PARTY' ? (r.Partner || '') : '',
      NominationKey: r.NominationKey,
      NominationItem: r.NominationItem,
      Reason: `Ticket ${String(r.TicketKey).trim()} is ${allocationUtils.describeTicketState(r.TicketPurpose, r.TicketStatus)}`
    }));
    if (skippedDueToTicketStatus.length) {
      log.info(`[processTicketing] Skipped by Ticket Purpose/Status — ${skippedDueToTicketStatus.map(i => `${i.NominationKey}/${i.NominationItem}`).join(', ')}`);
    }

    // ═════════════════════════════════════════════════════════════════════════
    // PHASE 5: ASYNCHRONOUS CDS.SPAWN FOR S/4 ACTUALIZETICKET
    // ═════════════════════════════════════════════════════════════════════════
    let jobId = null;
    let jobStatus = 'NOT_SUBMITTED';

    if (aProcessedItems.length > 0) {
      _evictOldJobs();
      jobId = crypto.randomUUID();
      jobStatus = 'SUBMITTED';

      const ticketPayload = _buildActualizeTicketPayload(Gasday, aProcessedItems);

      _ticketJobs.set(jobId, {
        jobId,
        user: req.user?.id,
        gasday: String(Gasday).substring(0, 10),
        status: 'SUBMITTED',
        totalInputs: ticketPayload.Inputs.length,
        processedItems: aProcessedItems,
        succeeded: false,
        error: null,
        response: null,
        startedAt: new Date(),
        completedAt: null
      });

      // Spawn background worker immediately
      cds.spawn({
        tenant: req.tenant,
        user: req.user
      }, async () => {
        _setJobStatus(jobId, { status: 'RUNNING' });
        try {
          log.info(`[processTicketing:spawn] Submitting ${ticketPayload.Inputs.length} item(s) to S/4 for Gasday ${Gasday} (JobId: ${jobId})...`);

          const s4Response = await GMSTICKET_API_SRV.send({
            method: 'POST',
            path: '/ActualizeTicket',
            headers: {
              'Content-Type': 'application/json'
            },
            data: ticketPayload
          });

          log.info(`[processTicketing:spawn] S/4 ActualizeTicket succeeded for JobId: ${jobId}`);
          _setJobStatus(jobId, {
            status: 'COMPLETED',
            succeeded: true,
            response: s4Response,
            completedAt: new Date()
          });
        } catch (err) {
          log.error(`[processTicketing:spawn] S/4 ActualizeTicket failed for JobId: ${jobId}`, err);
          _setJobStatus(jobId, {
            status: 'FAILED',
            succeeded: false,
            error: err.message || 'S/4 ActualizeTicket failed',
            completedAt: new Date()
          });
        }
      });
    }

    // ═════════════════════════════════════════════════════════════════════════
    // IMMEDIATE RESPONSE TO CLIENT
    // ═════════════════════════════════════════════════════════════════════════
    return {
      Gasday,
      Mode: activeSegments.has('ENTRYPOINT') && activeSegments.size === 1 ? 'ENTRY-POINT (DELIVERY)' : 'STANDARD / MIXED',
      JobId: jobId,
      Status: jobStatus,
      EligibleLocationsForTicketing: aEligibleLocs,
      EligibleThirdPartyPairsForTicketing: aEligibleTpPairs,
      SkippedDueToMissingMeters: skippedDueToMissingMeters,
      SkippedDueToBusinessRule: skippedDueToBusinessRule,
      SkippedDueToNominationDrift: skippedDueToNominationDrift,
      SkippedDueToQualityDrift: skippedDueToQualityDrift,
      SkippedDueToBalanceMismatch: skippedDueToBalanceMismatch,
      SkippedDueToTicketStatus: skippedDueToTicketStatus,
      BlockedByRank: blockedByRank
    };
  });
};

/** Distinct NominationKey+NominationItem pairs (leading zeros stripped) covered by this run;
 *  Redelivery THIRD-PARTY items also carry their Partner, sent as ActualizeTicket Conpat.
 *  A line item the Ticket Purpose/Status matrix blocks is left out on its own — if either
 *  leg sharing its NominationKey+NominationItem is blocked, the pair is not submitted. */
function _collectProcessedItems(nominations, deliveryLocs, redeliveryLocs, tpPairs) {
  const items = new Map();
  const blockedKeys = new Set();
  const ticketBlockedRows = [];
  for (const r of nominations) {
    const loc = r.Location;
    if (!loc || !r.NominationKey) continue;
    const bCovered = r.LocationType === 'DELIVERY'
      ? deliveryLocs.has(loc)
      : r.LocationType === 'REDELIVERY' && (r.CustomerKind === 'THIRD-PARTY'
        ? tpPairs.has(`${r.Partner}__${loc}`)
        : redeliveryLocs.has(loc));
    if (!bCovered) continue;
    const NominationKey = normDoc(r.NominationKey);
    const NominationItem = normDoc(r.NominationItem);
    if (allocationUtils.getItemTicketGate(r).ticketingBlocked) {
      blockedKeys.add(`${NominationKey}|${NominationItem}`);
      ticketBlockedRows.push(r);
      continue;
    }
    // Conpat only for the THIRD-PARTY segment (Redelivery); Entry Point rows stay blank
    const Partner = r.LocationType === 'REDELIVERY' && r.CustomerKind === 'THIRD-PARTY'
      ? String(r.Partner || '').trim() : '';
    items.set(`${NominationKey}|${NominationItem}`, { NominationKey, NominationItem, Partner });
  }
  for (const k of blockedKeys) items.delete(k);
  return { items: [...items.values()], ticketBlockedRows };
}

/**
 * ActualizeTicket FOREGROUND payload: one Gas Day, one row per exact NOMTK/NOMIT this run
 * cleared. S/4 rejects a FOREGROUND row without NOMTK and NOMIT, and every row needs its own
 * ProcessIndicator (the root one does not substitute). THIRD-PARTY segment rows add Conpat = the item's
 * own Partner; Locid/Matnr stay blank — a filled optional field must match the item exactly,
 * or S/4 silently selects nothing.
 */
function _buildActualizeTicketPayload(gasday, processedItems) {
  const gasdayISO = String(gasday).substring(0, 10) + 'T00:00:00';
  return {
    Actualize: true,
    ActualizeIC: false,
    ProcessIndicator: 'FOREGROUND',
    Scenario: '',
    Inputs: processedItems.map(item => ({
      Gasday: gasdayISO,
      Tsyst: '',
      Locid: '',
      Nomtk: String(item.NominationKey),
      Nomit: String(item.NominationItem),
      Conpat: item.Partner || '',
      Matnr: '',
      ProcessIndicator: 'FOREGROUND',
      Scenario: ''
    }))
  };
}

/**
 * OWN, PRIMARY and HYBRID items share one physical Redelivery location, and the UI buckets a
 * location into OWN or HYBRID only by whether it has shifted to Hybrid — so either segment
 * activates every non-Third-Party kind there. THIRD-PARTY stays partner-scoped.
 * scopedOwnHybridLocs (null = no per-location restriction) keeps a location ticked only
 * under THIRDPARTY from also ticketing the OWN/HYBRID items there.
 */
function _isKindInActiveSegments(custKind, loc, activeSegments, scopedOwnHybridLocs) {
  if (custKind === 'THIRD-PARTY') return activeSegments.has('THIRDPARTY');
  if (!activeSegments.has('OWN') && !activeSegments.has('HYBRID')) return false;
  return !scopedOwnHybridLocs || scopedOwnHybridLocs.has(loc);
}

async function _parseExecutionScope({ SelectionFilter, SegmentFilter, GMSVALUEHELP_SRV, log }) {
  const activeSegments = new Set();
  let scopedDeliveryLocs = null;
  let scopedRedeliveryLocs = null;
  let scopedTpPairs = null;
  let scopedOwnHybridLocs = null;

  const hasSegment = SegmentFilter && (
    SegmentFilter.OWN?.length ||
    SegmentFilter.HYBRID?.length ||
    SegmentFilter.THIRDPARTY?.length ||
    SegmentFilter.ENTRYPOINT?.length
  );

  const hasSelection = SelectionFilter && (
    SelectionFilter.TransportSystem?.length ||
    SelectionFilter.DeliveryPoints?.length ||
    SelectionFilter.RedeliveryPoints?.length
  );

  if (hasSegment) {
    if (SegmentFilter.ENTRYPOINT?.length) {
      activeSegments.add('ENTRYPOINT');
      scopedDeliveryLocs = new Set();
      SegmentFilter.ENTRYPOINT.forEach(i => scopedDeliveryLocs.add(i.Location));
    }

    if (SegmentFilter.OWN?.length) {
      activeSegments.add('OWN');
      if (!scopedRedeliveryLocs) scopedRedeliveryLocs = new Set();
      if (!scopedOwnHybridLocs) scopedOwnHybridLocs = new Set();
      SegmentFilter.OWN.forEach(i => {
        scopedRedeliveryLocs.add(i.Location);
        scopedOwnHybridLocs.add(i.Location);
      });
    }

    if (SegmentFilter.HYBRID?.length) {
      activeSegments.add('HYBRID');
      if (!scopedRedeliveryLocs) scopedRedeliveryLocs = new Set();
      if (!scopedOwnHybridLocs) scopedOwnHybridLocs = new Set();
      SegmentFilter.HYBRID.forEach(i => {
        scopedRedeliveryLocs.add(i.Location);
        scopedOwnHybridLocs.add(i.Location);
      });
    }

    if (SegmentFilter.THIRDPARTY?.length) {
      activeSegments.add('THIRDPARTY');
      if (!scopedRedeliveryLocs) scopedRedeliveryLocs = new Set();
      scopedTpPairs = new Set();
      SegmentFilter.THIRDPARTY.forEach(i => {
        scopedRedeliveryLocs.add(i.Location);
        if (i.Customer) scopedTpPairs.add(`${i.Customer}__${i.Location}`);
      });
    }
  } else if (hasSelection) {
    if (SelectionFilter.DeliveryPoints?.length) {
      activeSegments.add('ENTRYPOINT');
      scopedDeliveryLocs = new Set(SelectionFilter.DeliveryPoints);
    }

    if (SelectionFilter.RedeliveryPoints?.length) {
      activeSegments.add('OWN').add('HYBRID').add('THIRDPARTY');
      scopedRedeliveryLocs = new Set(SelectionFilter.RedeliveryPoints);
    }

    if (SelectionFilter.TransportSystem?.length && !SelectionFilter.DeliveryPoints?.length && !SelectionFilter.RedeliveryPoints?.length) {
      activeSegments.add('OWN').add('HYBRID').add('THIRDPARTY').add('ENTRYPOINT');
      try {
        const { deliveryLocids, redeliveryLocids } = await resolveLocationsByTS(
          GMSVALUEHELP_SRV,
          SelectionFilter.TransportSystem
        );
        scopedDeliveryLocs = new Set(deliveryLocids);
        scopedRedeliveryLocs = new Set(redeliveryLocids);
      } catch (err) {
        log.error('[processTicketing] Failed TS point resolution', err);
      }
    }
  } else {
    activeSegments.add('OWN').add('HYBRID').add('THIRDPARTY').add('ENTRYPOINT');
  }

  return {
    activeSegments,
    scopedDeliveryLocs,
    scopedRedeliveryLocs,
    scopedTpPairs,
    scopedOwnHybridLocs
  };
}