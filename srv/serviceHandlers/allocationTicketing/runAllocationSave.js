const cds = require('@sap/cds');
const nomCache = require('./nomCache');
const allocationUtils = require('../../utils/allocationUtils');
const { resolveLocationsByTS } = require('../../utils/locationResolver');
const { normDoc } = require('../../utils/nomSourceFetch');
const { runCoreAllocation } = require('./allocationRuleEngine');

module.exports = async (srv) => {
  const GMSVALUEHELP_SRV = await cds.connect.to('GMSVALUEHELP_SRV');
  const GMSTICKET_API_SRV = await cds.connect.to('GMSTICKET_API_SRV');

  srv.on('RunAllocateSave', async (req) => {
    const log = cds.log('RunAllocateSave');
    const { Gasday, SelectionFilter, SegmentFilter } = req.data;

    if (!Gasday) return req.reject(400, 'Gasday is required');

    // 1. Retrieve cached state (Auto-warm if cache is cold)
    let cacheEntry = nomCache.cache.get(Gasday);

    if (!cacheEntry || !cacheEntry.data?.length) {
      log.info(`[RunAllocateSave] Cache cold for Gasday ${Gasday} — auto-warming via getScheduledNomItemsWithSCADA...`);

      try {
        await srv.send('getScheduledNomItemsWithSCADA', {
          Gasday,
          LocationFilter: SelectionFilter?.RedeliveryPoints?.join(',') || SelectionFilter?.DeliveryPoints?.join(',') || '',
          TransportSystem: SelectionFilter?.TransportSystem?.join(',') || ''
        });
        cacheEntry = nomCache.cache.get(Gasday);
      } catch (err) {
        log.error(`[RunAllocateSave] Auto-warm failed for Gasday ${Gasday}`, err);
        return req.reject(500, `Failed to retrieve nomination data from backend for Gasday ${Gasday}.`);
      }
    }

    if (!cacheEntry || !cacheEntry.data || cacheEntry.data.length === 0) {
      return {
        Gasday,
        Mode: 'STANDARD (REDELIVERY + DELIVERY PASSTHROUGH)',
        AllocatedCount: 0,
        PassthroughDeliveryCount: 0,
        SavedToS4Count: 0,
        SaveSuccess: true,
        SaveErrors: [],
        EligibleLocations: [],
        EligibleThirdPartyPairs: [],
        SkippedDueToMissingMeters: [],
        OrphanMetersWithoutNominations: [],
        BlockedByTicketOrRank: [],
        Message: `No confirmed nomination records found for Gas Day ${Gasday}.`
      };
    }

    const {
      data: nominations,
      ownGcvNcvMap,
      hybridSecondaryMeterMap,
      tpCustomerMeterMap,
      tpGcvNcvMap,
      tpCustomerUploadedQtyMap,
      epQtyByLocation,
      epGcvNcvMap
    } = cacheEntry;

    const zeroQtyPairs = cacheEntry?.tpZeroQtyPairs || new Set();

    // 2. Parse Incoming Payload: SelectionFilter vs SegmentFilter
    const targetScope = await _parseExecutionScope({
      SelectionFilter,
      SegmentFilter,
      GMSVALUEHELP_SRV,
      log
    });

    const {
      isEntryPointMode,
      activeSegments,
      scopedLocations,
      scopedTpPairs,
      scopedHybridPairs,
      scopedOwnHybridLocs
    } = targetScope;
    const _inSegment = (custKind, loc) =>
      _isKindInActiveSegments(custKind, loc, activeSegments, scopedOwnHybridLocs);

    const skippedLocations = [];
    const orphanMeterWarnings = [];
    const blockedLocations = [];
    const eligibleLocations = new Set();
    const eligibleTpPairs = new Set();

    // ═════════════════════════════════════════════════════════════════════════
    // STEP 1: METER INTEGRITY & MISSING METER CHECKS
    // ═════════════════════════════════════════════════════════════════════════
    const missingMeterLocations = new Set();
    const missingTpPairs = new Set();

    const nominatedLocationsInScope = new Set();
    const nominatedTpPairsInScope = new Set();

    for (const nom of nominations) {
      const loc = nom.Location;
      if (!loc || (scopedLocations && !scopedLocations.has(loc))) continue;

      const custKind = nom.CustomerKind || 'OWN';

      if (!isEntryPointMode && !_inSegment(custKind, loc)) continue;

      if (isEntryPointMode) {
        if (nom.LocationType === 'DELIVERY') {
          nominatedLocationsInScope.add(loc);
        }
      } else {
        if (nom.LocationType === 'REDELIVERY') {
          if (custKind === 'THIRD-PARTY') {
            if (nom.Partner) {
              const pairKey = `${nom.Partner}__${loc}`;
              if (!scopedTpPairs || scopedTpPairs.has(pairKey)) {
                nominatedTpPairsInScope.add(pairKey);
              }
            }
          } else {
            nominatedLocationsInScope.add(loc);
          }
        }
      }
    }

    if (isEntryPointMode) {
      for (const loc of nominatedLocationsInScope) {
        const totalMR = epQtyByLocation.get(loc) || ownGcvNcvMap.get(loc)?.totalMR || 0;
        const qual = epGcvNcvMap.get(loc) || ownGcvNcvMap.get(loc);
        const hasQual = !!qual && qual.gcv > 0 && qual.ncv > 0;

        if (!(totalMR > 0) || !hasQual) {
          missingMeterLocations.add(loc);
          skippedLocations.push({
            Location: loc,
            Segment: 'ENTRYPOINT',
            Reason: !(totalMR > 0) ? 'CM Meter Qty is missing' : 'GCV/NCV reading is missing'
          });
        }
      }
    } else {
      if (activeSegments.has('OWN') || activeSegments.has('HYBRID')) {
        for (const loc of nominatedLocationsInScope) {
          const ownData = ownGcvNcvMap.get(loc);
          const hasOwnMeter = !!ownData && (ownData.totalMR > 0);
          const hasOwnQual = !!ownData && (ownData.gcv > 0 && ownData.ncv > 0);

          const hasOwnOrHybridNoms = nominations.some(
            r => r.Location === loc && r.LocationType === 'REDELIVERY' && r.CustomerKind !== 'THIRD-PARTY'
          );

          if (hasOwnOrHybridNoms && (!hasOwnMeter || !hasOwnQual)) {
            missingMeterLocations.add(loc);
            skippedLocations.push({
              Location: loc,
              Segment: 'OWN',
              Reason: !hasOwnMeter ? 'Meter reading is missing or zero' : 'GCV/NCV is missing'
            });
          }
        }
      }

      if (activeSegments.has('THIRDPARTY')) {
        for (const pairKey of nominatedTpPairsInScope) {
          const [cust, loc] = pairKey.split('__');
          const qty = tpCustomerMeterMap.get(pairKey) || 0;
          const qual = tpGcvNcvMap.get(loc);
          const rawUpload = tpCustomerUploadedQtyMap.get(pairKey) || 0;
          const hasQual = !!qual && qual.gcv > 0 && qual.ncv > 0;
          const isZeroUploadAllowed = zeroQtyPairs.has(pairKey) && hasQual;

          const isReadingValid = (qty > 0 && hasQual) || isZeroUploadAllowed;

          if (!isReadingValid) {
            missingTpPairs.add(pairKey);
            let reason = 'Meter reading is missing';
            if (rawUpload > 0 && !hasQual) {
              reason = 'Uploaded Qty present, but GCV/NCV is missing';
            } else if (hasQual && qty <= 0 && !isZeroUploadAllowed) {
              reason = 'GCV/NCV present, but Uploaded/Converted SM3 Qty is missing or zero';
            }

            skippedLocations.push({
              Location: loc,
              Partner: cust,
              Segment: 'THIRDPARTY',
              Reason: reason
            });
          }
        }
      }
    }

    // ═════════════════════════════════════════════════════════════════════════
    // STEP 2: ORPHAN METER READING CHECK
    // ═════════════════════════════════════════════════════════════════════════
    const nominatedLocations = new Set();
    const nominatedHybridPairs = new Set();
    const nominatedTpPairs = new Set();

    for (const nom of nominations) {
      if (!nom.Location) continue;
      nominatedLocations.add(nom.Location);
      if (nom.Partner) {
        const pair = `${nom.Partner}__${nom.Location}`;
        if (nom.CustomerKind === 'HYBRID') nominatedHybridPairs.add(pair);
        if (nom.CustomerKind === 'THIRD-PARTY') nominatedTpPairs.add(pair);
      }
    }

    if (activeSegments.has('OWN')) {
      for (const [loc, own] of ownGcvNcvMap) {
        if (scopedLocations && !scopedLocations.has(loc)) continue;
        if (own.totalMR > 0 && !nominatedLocations.has(loc)) {
          orphanMeterWarnings.push({
            Location: loc,
            Segment: 'OWN',
            Reason: 'Meter Reading found but no Nomination found for allocation'
          });
        }
      }
    }

    if (activeSegments.has('HYBRID')) {
      for (const [pairKey, qty] of hybridSecondaryMeterMap) {
        const loc = pairKey.split('__')[1] || pairKey;
        if (scopedLocations && !scopedLocations.has(loc)) continue;
        if (qty > 0 && !nominatedHybridPairs.has(pairKey)) {
          orphanMeterWarnings.push({
            Location: loc,
            Partner: pairKey.split('__')[0],
            Segment: 'HYBRID',
            Reason: 'Allocation Qty uploaded but no nomination data found for allocation'
          });
        }
      }
    }

    if (activeSegments.has('THIRDPARTY')) {
      for (const [pairKey, qty] of tpCustomerMeterMap) {
        const [cust, loc] = pairKey.split('__');
        if (scopedLocations && !scopedLocations.has(loc)) continue;
        if (scopedTpPairs && !scopedTpPairs.has(pairKey)) continue;
        if (qty > 0 && !nominatedTpPairs.has(pairKey)) {
          orphanMeterWarnings.push({
            Location: loc,
            Partner: cust,
            Segment: 'THIRDPARTY',
            Reason: 'Allocation Uploaded but no Nomination found for the Partner at the Business Location'
          });
        }
      }
    }

    // ═════════════════════════════════════════════════════════════════════════
    // STEP 3: TICKET TRUTH TABLE & RANK VALIDATION
    // ═════════════════════════════════════════════════════════════════════════
    // Both block at Location grain (THIRD-PARTY Redelivery: Location+Partner):
    //   1. Ticket Purpose/Status — any in-scope item whose ticket is not Full Reversed (5/00)
    //      or blank/blank (allocationUtils.getItemTicketGate) blocks the whole Location.
    //   2. Missing/0 Rank on any in-scope item.
    const blockedLocationsSet = new Set();
    const blockedTpPairsSet = new Set();
    const ticketBlockInfoByLoc = new Map();
    const rankBlockInfoByLoc = new Map();

    for (const row of nominations) {
      const loc = row.Location;
      if (!loc || (scopedLocations && !scopedLocations.has(loc))) continue;

      if (isEntryPointMode && row.LocationType !== 'DELIVERY') continue;
      if (!isEntryPointMode && row.LocationType !== 'REDELIVERY') continue;

      const custKind = row.CustomerKind || 'OWN';
      if (!isEntryPointMode && !_inSegment(custKind, loc)) continue;

      const tpPairKey = `${row.Partner}__${loc}`;
      const isTP = custKind === 'THIRD-PARTY';

      if (isTP && scopedTpPairs && !scopedTpPairs.has(tpPairKey)) continue;

      // THIRD-PARTY Redelivery is Location+Customer grain: one partner's ticket or rank gap
      // blocks only that partner, never other partners at the same connection point
      const bTpPairGrain = isTP && row.LocationType === 'REDELIVERY';
      const blockKey = bTpPairGrain ? tpPairKey : loc;

      // 1. Ticket Purpose/Status Check
      if (allocationUtils.getItemTicketGate(row).allocationBlocked) {
        if (bTpPairGrain) blockedTpPairsSet.add(tpPairKey);
        else blockedLocationsSet.add(loc);

        if (!ticketBlockInfoByLoc.has(blockKey)) {
          ticketBlockInfoByLoc.set(blockKey, {
            tpPair: bTpPairGrain,
            loc,
            partner: row.Partner || '',
            ticketKey: String(row.TicketKey).trim(),
            state: allocationUtils.describeTicketState(row.TicketPurpose, row.TicketStatus),
            nomKey: row.NominationKey,
            nomItem: row.NominationItem
          });
        }
        continue;
      }

      // 2. Missing or Zero Rank Check
      if (allocationUtils.isUnrankedValue(row.Rank)) {
        if (bTpPairGrain) blockedTpPairsSet.add(tpPairKey);
        else blockedLocationsSet.add(loc);

        if (!rankBlockInfoByLoc.has(blockKey)) {
          rankBlockInfoByLoc.set(blockKey, {
            tpPair: bTpPairGrain,
            loc,
            partner: row.Partner || '',
            contract: row.Contract,
            nomKey: row.NominationKey,
            nomItem: row.NominationItem
          });
        }
        continue;
      }
    }

    // Consolidate response for BlockedByTicketOrRank — one entry per blocked Location
    // (or Location+Partner); a ticket block is reported in preference to a rank block
    for (const info of ticketBlockInfoByLoc.values()) {
      blockedLocations.push({
        Location: info.loc,
        Partner: info.tpPair ? info.partner : '',
        Reason: info.tpPair
          ? `Allocation blocked for this Location & Partner — Ticket ${info.ticketKey} is ${info.state} (${info.nomKey}/${info.nomItem})`
          : `Allocation blocked for entire Location — Ticket ${info.ticketKey} is ${info.state} (${info.nomKey}/${info.nomItem})`
      });
    }

    for (const [blockKey, info] of rankBlockInfoByLoc) {
      if (ticketBlockInfoByLoc.has(blockKey)) continue;
      blockedLocations.push({
        Location: info.loc,
        Partner: info.tpPair ? info.partner : '',
        Reason: info.tpPair
          ? `Allocation blocked for this Location & Partner due to missing or 0 Rank on Contract ${info.contract} (${info.nomKey}/${info.nomItem})`
          : `Allocation blocked for entire Location due to missing or 0 Rank on Contract ${info.contract} (${info.nomKey}/${info.nomItem})`
      });
    }

    // ═════════════════════════════════════════════════════════════════════════
    // STEP 4: IDENTIFY ELIGIBLE ALLOCATION TARGETS
    // ═════════════════════════════════════════════════════════════════════════
    for (const row of nominations) {
      const loc = row.Location;
      if (!loc || (scopedLocations && !scopedLocations.has(loc))) continue;

      if (isEntryPointMode) {
        if (row.LocationType !== 'DELIVERY') continue;
        if (!missingMeterLocations.has(loc) && !blockedLocationsSet.has(loc)) {
          eligibleLocations.add(loc);
        }
      } else {
        if (row.LocationType !== 'REDELIVERY') continue;

        const custKind = row.CustomerKind || 'OWN';
        if (!_inSegment(custKind, loc)) continue;

        const tpPairKey = `${row.Partner}__${loc}`;

        if (custKind === 'THIRD-PARTY') {
          if (scopedTpPairs && !scopedTpPairs.has(tpPairKey)) continue;

          const hasMeter = (tpCustomerMeterMap.get(tpPairKey) > 0) || zeroQtyPairs.has(tpPairKey);

          if (
            hasMeter &&
            !missingTpPairs.has(tpPairKey) &&
            !blockedTpPairsSet.has(tpPairKey)
          ) {
            eligibleTpPairs.add(tpPairKey);
          }
        } else {
          if (!missingMeterLocations.has(loc) && !blockedLocationsSet.has(loc)) {
            eligibleLocations.add(loc);
          }
        }
      }
    }

    // ═════════════════════════════════════════════════════════════════════════
    // STEP 5: CORE ALLOCATION DISPATCH & PASSTHROUGH
    // ═════════════════════════════════════════════════════════════════════════
    const {
      allocatedRows,
      passthroughDeliveryRows,
      summaryByGroup,
      ticketBlockedRows
    } = runCoreAllocation({
      // Redelivery rows of only the selected segment(s) — keeps THIRD-PARTY items out of
      // an OWN/HYBRID-only run and OWN/HYBRID items out of a THIRDPARTY-only run
      nominations: isEntryPointMode
        ? nominations
        : nominations.filter(r => r.LocationType !== 'REDELIVERY'
            || _inSegment(r.CustomerKind || 'OWN', r.Location)),
      meterReadingMap: cacheEntry.meterReadingMap,
      eligibleLocations,
      eligibleTpPairs,
      isEntryPointMode,
      epQtyByDeliveryContract: cacheEntry.epQtyByDeliveryContract
    });

    for (const g of summaryByGroup) {
      log.info(`[RunAllocateSave] Pool ${g.Segment} ${g.GroupKey}: Metered=${g.MeteredQty} Allocated=${g.AllocatedQty} Items=${g.ItemCount}`);
    }

    // Redelivery locations with a blocking ticket never reach the engine (Step 3), so this
    // is only a paired Delivery leg whose own ticket blocks it — it keeps its saved qty
    if (ticketBlockedRows.length) {
      log.info(`[RunAllocateSave] Skipped by Ticket Purpose/Status — ${ticketBlockedRows.map(r => `${r.NominationKey}/${r.NominationItem} (${String(r.TicketPurpose || '').trim() || 'NA'}/${String(r.TicketStatus || '').trim() || 'NA'})`).join(', ')}`);
    }

    // ═════════════════════════════════════════════════════════════════════════
    // STEP 6: POST TO S/4 (/SaveTicket)
    // ═════════════════════════════════════════════════════════════════════════
    let saveResult = { success: true, totalPosted: 0, postedRows: [], errors: [] };

    if (allocatedRows.length > 0 || passthroughDeliveryRows.length > 0) {
      saveResult = await _postSaveTicket(
        GMSTICKET_API_SRV,
        allocatedRows,
        passthroughDeliveryRows,
        'ALLOCATION',
        log
      );

      // Sync only rows S/4 accepted — a later failed chunk must not hide earlier saved ones
      for (const postedRow of saveResult.postedRows) {
        const indexKey = `${postedRow.Location}__${postedRow.NominationKey}__${postedRow.NominationItem}`;
        const cacheIdx = cacheEntry.nomIndex?.get(indexKey);
        if (cacheIdx !== undefined && cacheEntry.data[cacheIdx]) {
          cacheEntry.data[cacheIdx].SavedAllocatedQty = String(postedRow.AllocatedQty);
          cacheEntry.data[cacheIdx].SavedAllocatedUOM = postedRow.AllocUOM || 'SM3';
        }
      }
    }

    log.info(`[RunAllocateSave] Gasday=${Gasday} Allocated=${allocatedRows.length} Passthrough=${passthroughDeliveryRows.length} TicketSkipped=${ticketBlockedRows.length} PostedToS4=${saveResult.totalPosted}`);

    return {
      Gasday,
      Mode: isEntryPointMode ? 'ENTRY-POINT (DELIVERY)' : 'STANDARD (REDELIVERY + DELIVERY PASSTHROUGH)',
      AllocatedCount: allocatedRows.length,
      PassthroughDeliveryCount: passthroughDeliveryRows.length,
      SavedToS4Count: saveResult.totalPosted,
      SaveSuccess: saveResult.success,
      SaveErrors: saveResult.errors,
      EligibleLocations: Array.from(eligibleLocations),
      EligibleThirdPartyPairs: isEntryPointMode
        ? []
        : Array.from(eligibleTpPairs).map(p => ({
            Partner: p.split('__')[0],
            Location: p.split('__')[1]
          })),
      SkippedDueToMissingMeters: skippedLocations,
      OrphanMetersWithoutNominations: orphanMeterWarnings,
      BlockedByTicketOrRank: blockedLocations
    };
  });
};

// ═════════════════════════════════════════════════════════════════════════════
// LOGICAL HELPER FUNCTIONS
// ═════════════════════════════════════════════════════════════════════════

async function _postSaveTicket(srvClient, allocatedRedels, passthroughDels, sProcess, log) {
  if (!allocatedRedels?.length && !passthroughDels?.length) {
    return { success: true, totalPosted: 0, postedRows: [], errors: [] };
  }

  const delsByContract = new Map();
  for (const del of passthroughDels) {
    const conKey = normDoc(del.Contract);
    if (conKey) delsByContract.set(conKey, del);
  }

  const units = [];
  const attachedDelContracts = new Set();

  for (const redel of allocatedRedels) {
    const unit = [redel];
    const corrDoc = normDoc(redel.CorrespondingDocNo);

    if (corrDoc && delsByContract.has(corrDoc)) {
      const del = delsByContract.get(corrDoc);
      unit.push(del);
      attachedDelContracts.add(normDoc(del.Contract));
    }
    units.push(unit);
  }

  for (const del of passthroughDels) {
    if (!attachedDelContracts.has(normDoc(del.Contract))) {
      units.push([del]);
    }
  }

  const TARGET_CHUNK_SIZE = 500;
  const chunks = [];
  let currentChunk = [];

  for (const unit of units) {
    if (currentChunk.length > 0 && (currentChunk.length + unit.length) > TARGET_CHUNK_SIZE) {
      chunks.push(currentChunk);
      currentChunk = [];
    }
    currentChunk.push(...unit);
  }

  if (currentChunk.length > 0) {
    chunks.push(currentChunk);
  }

  const errors = [];
  const postedRows = [];

  for (let idx = 0; idx < chunks.length; idx++) {
    const chunk = chunks[idx];

    const toTicketItems = chunk.map(r => ({
      Nomtk: String(r.NominationKey || ''),
      Nomit: String(r.NominationItem || ''),
      Menge: String(parseFloat(r.AllocatedQty || 0).toFixed(3)),
      Meins: String(r.AllocUOM || r.ConversionUOM || 'SM3')
    }));

    const toCVParams = chunk.map(r => ({
      Nomtk: String(r.NominationKey || ''),
      Nomit: String(r.NominationItem || ''),
      GCV: String(parseFloat(r.AVG_WT_GCV || 0).toFixed(4)),
      NCV: String(parseFloat(r.AVG_WT_NCV || 0).toFixed(4))
    }));

    try {
      log.info(`[_postSaveTicket] Posting chunk ${idx + 1}/${chunks.length} (${chunk.length} items)...`);
      
      const response = await srvClient.send({
        method: 'POST',
        path: '/SaveTicket',
        headers: {
          'Content-Type': 'application/json',
          process: 'SAV'
        },
        data: {
          Save: true,
          toTicketItems,
          toCVParams
        }
      });

      // V2 deep-insert responses may wrap navigation arrays in { results: [...] }
      const aReturn = Array.isArray(response?.toReturn) ? response.toReturn : (response?.toReturn?.results || []);
      const errorMsgs = aReturn.filter(m => m.Type === 'E' || m.Type === 'A');
      if (errorMsgs.length) {
        errors.push(...errorMsgs.map(m => m.Message));
      } else {
        postedRows.push(...chunk);
      }
    } catch (err) {
      log.error(`[_postSaveTicket] S/4 error on chunk ${idx + 1}:`, err);
      errors.push(err.message || 'Error communicating with S/4 /SaveTicket service');
      break;
    }
  }

  return {
    success: errors.length === 0,
    totalPosted: postedRows.length,
    postedRows,
    errors
  };
}

/**
 * The UI lists each Redelivery location under exactly one tab — HYBRID once it has shifted
 * (a PRIMARY/HYBRID upload exists), OWN otherwise — and OWN/SLMC/PRIMARY/HYBRID items there
 * are allocated together from that location's meter. So selecting a location under either
 * OWN or HYBRID picks up every non-Third-Party item at it; THIRD-PARTY stays partner-scoped.
 * scopedOwnHybridLocs (null = no per-location restriction) keeps a location ticked only
 * under THIRDPARTY from also re-allocating the OWN/HYBRID items there.
 */
function _isKindInActiveSegments(custKind, loc, activeSegments, scopedOwnHybridLocs) {
  if (custKind === 'THIRD-PARTY') return activeSegments.has('THIRDPARTY');
  if (!activeSegments.has('OWN') && !activeSegments.has('HYBRID')) return false;
  return !scopedOwnHybridLocs || scopedOwnHybridLocs.has(loc);
}

async function _parseExecutionScope({ SelectionFilter, SegmentFilter, GMSVALUEHELP_SRV, log }) {
  const activeSegments = new Set();
  let isEntryPointMode = false;
  let scopedLocations = null;
  let scopedTpPairs = null;
  let scopedHybridPairs = null;
  let scopedOwnHybridLocs = null;

  const hasSelection = SelectionFilter && (
    SelectionFilter.TransportSystem?.length ||
    SelectionFilter.DeliveryPoints?.length ||
    SelectionFilter.RedeliveryPoints?.length
  );

  const hasSegment = SegmentFilter && (
    SegmentFilter.OWN?.length ||
    SegmentFilter.HYBRID?.length ||
    SegmentFilter.THIRDPARTY?.length ||
    SegmentFilter.ENTRYPOINT?.length
  );

  if (hasSegment) {
    scopedLocations = new Set();

    if (SegmentFilter.ENTRYPOINT?.length) {
      isEntryPointMode = true;
      activeSegments.add('ENTRYPOINT');
      SegmentFilter.ENTRYPOINT.forEach(i => scopedLocations.add(i.Location));
    } else {
      scopedOwnHybridLocs = new Set();
      if (SegmentFilter.OWN?.length) {
        activeSegments.add('OWN');
        SegmentFilter.OWN.forEach(i => {
          scopedLocations.add(i.Location);
          scopedOwnHybridLocs.add(i.Location);
        });
      }
      if (SegmentFilter.HYBRID?.length) {
        activeSegments.add('HYBRID');
        scopedHybridPairs = new Set();
        SegmentFilter.HYBRID.forEach(i => {
          scopedLocations.add(i.Location);
          scopedOwnHybridLocs.add(i.Location);
          if (i.Customer) scopedHybridPairs.add(`${i.Customer}__${i.Location}`);
        });
      }
      if (SegmentFilter.THIRDPARTY?.length) {
        activeSegments.add('THIRDPARTY');
        scopedTpPairs = new Set();
        SegmentFilter.THIRDPARTY.forEach(i => {
          scopedLocations.add(i.Location);
          if (i.Customer) scopedTpPairs.add(`${i.Customer}__${i.Location}`);
        });
      }
    }
  } else if (hasSelection) {
    scopedLocations = new Set();
    activeSegments.add('OWN').add('HYBRID').add('THIRDPARTY');

    if (SelectionFilter.DeliveryPoints?.length) {
      isEntryPointMode = true;
      activeSegments.clear();
      activeSegments.add('ENTRYPOINT');
      SelectionFilter.DeliveryPoints.forEach(loc => scopedLocations.add(loc));
    } else if (SelectionFilter.RedeliveryPoints?.length) {
      SelectionFilter.RedeliveryPoints.forEach(loc => scopedLocations.add(loc));
    } else if (SelectionFilter.TransportSystem?.length) {
      try {
        const { deliveryLocids, redeliveryLocids } = await resolveLocationsByTS(
          GMSVALUEHELP_SRV,
          SelectionFilter.TransportSystem
        );
        [...deliveryLocids, ...redeliveryLocids].forEach(loc => scopedLocations.add(loc));
      } catch (err) {
        log.error('[RunAllocateSave] Failed TS point resolution', err);
      }
    }
  } else {
    activeSegments.add('OWN').add('HYBRID').add('THIRDPARTY');
  }

  return {
    isEntryPointMode,
    activeSegments,
    scopedLocations,
    scopedTpPairs,
    scopedHybridPairs,
    scopedOwnHybridLocs
  };
}
