const cds = require('@sap/cds');
const allocationUtils = require('../../utils/allocationUtils');
const { normDoc } = require('../../utils/nomSourceFetch');

const _r3 = v => Math.round(Number(v || 0) * 1000) / 1000;

/**
 * Core Allocation Dispatcher
 *
 * Runs location-by-location for eligible targets, evaluates available metered
 * quantities, handles OWN vs HYBRID meter shifting and residuals, applies
 * pro-rata / surplus / deficit distribution, and auto-populates paired Delivery legs.
 *
 * @param {Object} params
 * @param {Array}   params.nominations             - Full nomination array from cache
 * @param {Map}     params.meterReadingMap         - Unified meter readings dictionary
 * @param {Set}     params.eligibleLocations       - Cleared locations (OWN, HYBRID, ENTRYPOINT)
 * @param {Set}     params.eligibleTpPairs         - Cleared Partner__Location keys (THIRDPARTY)
 * @param {boolean} params.isEntryPointMode        - Flag if executing ENTRY-POINT mode
 * @param {Map}     params.epQtyByDeliveryContract - Map of Delivery Contract -> Phase 1 matched qty
 * @returns {Object} { allocatedRows, passthroughDeliveryRows, summaryByGroup, ticketBlockedRows }
 *
 * Ticket Purpose/Status gate (allocationUtils.getItemTicketGate) is applied per line item:
 * a blocked row is left out of its group untouched, keeps its last saved allocation, and
 * that quantity is taken out of the group's pool first — the meter still covers it, so
 * the remaining items share only what is left and the location keeps balancing.
 */
function runCoreAllocation(params) {
  const {
    nominations,
    meterReadingMap,
    eligibleLocations,
    eligibleTpPairs,
    isEntryPointMode,
    epQtyByDeliveryContract
  } = params;

  const allocatedRows = [];
  const passthroughDeliveryRows = [];
  const summaryByGroup = [];
  const ticketBlockedRows = [];

  const isTicketBlocked = row => allocationUtils.getItemTicketGate(row).allocationBlocked;
  // Group key -> Σ saved qty of that group's ticket-blocked rows
  const frozenQtyByGroup = new Map();
  const _freeze = (groupKey, row) => {
    frozenQtyByGroup.set(groupKey, (frozenQtyByGroup.get(groupKey) || 0) + allocationUtils.savedAllocatedQty(row));
    ticketBlockedRows.push(row);
  };
  const _netPool = (groupKey, qty) => Math.max(0, _r3((parseFloat(qty) || 0) - (frozenQtyByGroup.get(groupKey) || 0)));

  // Index Delivery contracts by normalized ContractNo for O(1) passthrough pairing
  const deliveryByContract = new Map();
  for (const item of nominations) {
    if (item.LocationType === 'DELIVERY') {
      const conKey = normDoc(item.Contract);
      if (conKey) deliveryByContract.set(conKey, item);
    }
  }

  // ═════════════════════════════════════════════════════════════════════════
  // MODE 1: ENTRY-POINT (DELIVERY CONTRACTS)
  // ═════════════════════════════════════════════════════════════════════════
  if (isEntryPointMode) {
    const itemsByLocation = new Map();
    for (const item of nominations) {
      if (item.LocationType !== 'DELIVERY' || !eligibleLocations.has(item.Location)) continue;
      if (isTicketBlocked(item)) { _freeze(item.Location, item); continue; }
      if (!itemsByLocation.has(item.Location)) itemsByLocation.set(item.Location, []);
      itemsByLocation.get(item.Location).push(item);
    }

    const epMeters = meterReadingMap.get('ENTRYPOINT');

    for (const [location, locationItems] of itemsByLocation) {
      const poolQty = _netPool(location, epMeters?.get(location) || 0);

      // Run specialized Entry Point allocation
      allocationUtils.entryPointAllocation(locationItems, poolQty, epQtyByDeliveryContract);

      for (const row of locationItems) {
        allocatedRows.push(row);
      }

      const totalAllocated = locationItems.reduce((sum, r) => sum + (parseFloat(r.AllocatedQty) || 0), 0);
      summaryByGroup.push({
        GroupKey: location,
        Segment: 'ENTRYPOINT',
        MeteredQty: poolQty,
        AllocatedQty: Math.round(totalAllocated * 1000) / 1000,
        ItemCount: locationItems.length
      });
    }

    return { allocatedRows, passthroughDeliveryRows, summaryByGroup, ticketBlockedRows };
  }

  // ═════════════════════════════════════════════════════════════════════════
  // MODE 2: STANDARD ALLOCATION (REDELIVERY + DELIVERY PASSTHROUGH)
  // ═════════════════════════════════════════════════════════════════════════
  const ownPrimaryItemsByLoc = new Map();
  const hybridDedicatedItemsByPair = new Map();
  const thirdPartyItemsByPair = new Map();
  const unallocatedHybridItems = []; // HYBRID items whose dedicated upload is missing

  const hybridMeters = meterReadingMap.get('HYBRID');

  for (const item of nominations) {
    if (item.LocationType !== 'REDELIVERY') continue;

    const loc = item.Location;
    const custKind = item.CustomerKind || 'OWN';
    const pairKey = `${item.Partner}__${loc}`;

    if (custKind === 'THIRD-PARTY') {
      if (eligibleTpPairs.has(pairKey)) {
        if (isTicketBlocked(item)) { _freeze(`TP__${pairKey}`, item); continue; }
        if (!thirdPartyItemsByPair.has(pairKey)) thirdPartyItemsByPair.set(pairKey, []);
        thirdPartyItemsByPair.get(pairKey).push(item);
      }
    } else if (custKind === 'HYBRID') {
      if (eligibleLocations.has(loc)) {
        const hybridDedicatedMeter = hybridMeters?.get(pairKey);

        if (hybridDedicatedMeter !== undefined && hybridDedicatedMeter > 0) {
          // SHIFTED: Dedicated allocation quantity uploaded in HYBRID segment
          if (isTicketBlocked(item)) { _freeze(`HYB__${pairKey}`, item); continue; }
          if (!hybridDedicatedItemsByPair.has(pairKey)) hybridDedicatedItemsByPair.set(pairKey, []);
          hybridDedicatedItemsByPair.get(pairKey).push(item);
        } else {
          // UNSHIFTED: No dedicated customer upload in HYBRID segment.
          // Set AllocatedQty = 0. Do NOT pool with OWN/PRIMARY.
          if (isTicketBlocked(item)) { ticketBlockedRows.push(item); continue; }
          unallocatedHybridItems.push(item);
        }
      }
    } else {
      // PRIMARY, OWN, SLMC: Evaluated at physical location grain
      if (eligibleLocations.has(loc)) {
        if (isTicketBlocked(item)) { _freeze(`OWN__${loc}`, item); continue; }
        if (!ownPrimaryItemsByLoc.has(loc)) ownPrimaryItemsByLoc.set(loc, []);
        ownPrimaryItemsByLoc.get(loc).push(item);
      }
    }
  }

  // ── Dispatch 1: OWN & PRIMARY (Location-by-Location) ─────────────────────
  const ownMeters = meterReadingMap.get('OWN');
  const hybridPrimaryMeters = meterReadingMap.get('HYBRID_PRIMARY');

  for (const [location, items] of ownPrimaryItemsByLoc) {
    const physicalMR = ownMeters?.get(location)?.totalMR || ownMeters?.get(location) || 0;

    // Check if any dedicated HYBRID secondary meters exist for this location
    let dedicatedHybridSum = 0;
    if (hybridMeters) {
      for (const [pairKey, qty] of hybridMeters) {
        if (pairKey.endsWith(`__${location}`)) {
          dedicatedHybridSum += (parseFloat(qty) || 0);
        }
      }
    }

    // Resolve Pool:
    // Case A (Shifted): physicalMR - dedicatedHybridSum (e.g. 420,000 - 200,000 = 220,000)
    // Case B (Unshifted): full physical meter (e.g. 1,000,000)
    let poolQty = physicalMR;
    if (dedicatedHybridSum > 0) {
      poolQty = Math.max(0, physicalMR - dedicatedHybridSum);
    } else if (hybridPrimaryMeters?.has(location)) {
      poolQty = hybridPrimaryMeters.get(location);
    }
    poolQty = _netPool(`OWN__${location}`, poolQty);

    allocationUtils.allocateContracts(poolQty, items);

    for (const row of items) {
      allocatedRows.push(row);
      _applyDeliveryPassthrough(row, deliveryByContract, passthroughDeliveryRows, isTicketBlocked, ticketBlockedRows);
    }

    const totalAllocated = items.reduce((sum, r) => sum + (parseFloat(r.AllocatedQty) || 0), 0);
    summaryByGroup.push({
      GroupKey: location,
      Segment: dedicatedHybridSum > 0 ? 'HYBRID_PRIMARY' : 'OWN_PRIMARY',
      MeteredQty: poolQty,
      AllocatedQty: Math.round(totalAllocated * 1000) / 1000,
      ItemCount: items.length
    });
  }

  // ── Dispatch 2: HYBRID Dedicated Bifurcations (Pair-by-Pair) ──────────────
  for (const [pairKey, items] of hybridDedicatedItemsByPair) {
    const poolQty = _netPool(`HYB__${pairKey}`, hybridMeters?.get(pairKey) || 0); // e.g. 200,000 for Customer 10641

    allocationUtils.allocateContracts(poolQty, items);

    for (const row of items) {
      allocatedRows.push(row);
      _applyDeliveryPassthrough(row, deliveryByContract, passthroughDeliveryRows, isTicketBlocked, ticketBlockedRows);
    }

    const totalAllocated = items.reduce((sum, r) => sum + (parseFloat(r.AllocatedQty) || 0), 0);
    summaryByGroup.push({
      GroupKey: pairKey,
      Segment: 'HYBRID_DEDICATED',
      MeteredQty: poolQty,
      AllocatedQty: Math.round(totalAllocated * 1000) / 1000,
      ItemCount: items.length
    });
  }

  // ── Dispatch 3: HYBRID Items with Missing Customer Uploads (Set to 0) ─────
  for (const row of unallocatedHybridItems) {
    row.AllocatedQty = 0;
    row.AllocUOM = row.ConversionUOM || row.UOM || 'SM3';
    allocatedRows.push(row);
    _applyDeliveryPassthrough(row, deliveryByContract, passthroughDeliveryRows, isTicketBlocked, ticketBlockedRows);
  }

  // ── Dispatch 4: THIRD-PARTY (Partner + Location Pair-by-Pair) ─────────────
  const tpMeters = meterReadingMap.get('THIRDPARTY');

  for (const [pairKey, items] of thirdPartyItemsByPair) {
    const poolQty = _netPool(`TP__${pairKey}`, tpMeters?.get(pairKey) || 0);

    allocationUtils.allocateContracts(poolQty, items);

    for (const row of items) {
      allocatedRows.push(row);
      _applyDeliveryPassthrough(row, deliveryByContract, passthroughDeliveryRows, isTicketBlocked, ticketBlockedRows);
    }

    const totalAllocated = items.reduce((sum, r) => sum + (parseFloat(r.AllocatedQty) || 0), 0);
    summaryByGroup.push({
      GroupKey: pairKey,
      Segment: 'THIRDPARTY',
      MeteredQty: poolQty,
      AllocatedQty: Math.round(totalAllocated * 1000) / 1000,
      ItemCount: items.length
    });
  }

  return { allocatedRows, passthroughDeliveryRows, summaryByGroup, ticketBlockedRows };
}

/**
 * Counterpart Passthrough Helper:
 * If the allocated Redelivery leg carries a CorrespondingDocNo, find its paired
 * Delivery contract and unconditionally set AllocatedQty = ConversionQty.
 */
function _applyDeliveryPassthrough(redelRow, deliveryByContract, passthroughDeliveryRows, isTicketBlocked, ticketBlockedRows) {
  const corrDoc = normDoc(redelRow.CorrespondingDocNo);
  if (!corrDoc || !deliveryByContract.has(corrDoc)) return;

  const deliveryRow = deliveryByContract.get(corrDoc);
  // The Delivery leg carries its own ticket — a blocked leg keeps its saved allocation
  if (isTicketBlocked(deliveryRow)) {
    if (!ticketBlockedRows.includes(deliveryRow)) ticketBlockedRows.push(deliveryRow);
    return;
  }

  // Delivery passthrough rule: bypasses pro-rata engine completely
  deliveryRow.AllocatedQty = Number(deliveryRow.ConversionQty) || 0;
  deliveryRow.AllocUOM = deliveryRow.ConversionUOM || 'SM3';
  deliveryRow._passthroughCounterpart = true;
  deliveryRow._counterpartRdpLocation = redelRow.Location;

  passthroughDeliveryRows.push(deliveryRow);
}

module.exports = {
  runCoreAllocation
};