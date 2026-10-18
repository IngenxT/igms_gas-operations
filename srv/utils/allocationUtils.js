const cds = require('@sap/cds');

const GMSNOMINATIONS_SRV = cds.connect.to("GMSNOMINATIONS_SRV");

    async function getNominationSumAtDelNRedlv(nomItems) {
        if (!Array.isArray(nomItems) || nomItems.length === 0) return;
        // Prepare a filtered and padded vbeln list
        const vbelnList = nomItems
            .map(item => item.CorrespondingDocNo)
            .filter(docNo => docNo && docNo !== '')
            .map(docNo => docNo.padStart(10, '0'));
 
        if (vbelnList.length === 0) return;
 
        // Fetch data with a single query
        const result = await GMSNOMINATIONS_SRV.run(
            SELECT.from('xGMSxGTA_NOMDATA').where({
                ContractNo: {
                    in: vbelnList
                }
            })
        );
 
        // Map to keep only max Versn per vbeln
        const maxVersnMap = new Map();
        for (const row of result) {
            const current = maxVersnMap.get(row.ContractNo);
            if (!current || row.Versn > current.Versn) {
                maxVersnMap.set(row.ContractNo, row);
            }
        }
 
        // Sum the PDNQ values from filtered entries
        const sumOfPDNQ = Array.from(maxVersnMap.values()).reduce((sum, item) => {
            const val = parseFloat(item.ProposedDnq);
            return sum + (isNaN(val) ? 0 : val);
        }, 0);
 
        const roundedSum = parseFloat(sumOfPDNQ.toFixed(3));
 
        // console.log(roundedSum);
        return roundedSum;
    }
 

/**
 * Fetches service parameters into a Map
 */
async function getServiceParametersMap(igmsConfigMetaData) {
  const query = SELECT.from('serviceParametersItems', [
    'parameterID',
    'serviceParameter',
    'serviceParameterLabel'
  ]);
  const data = await igmsConfigMetaData.run(query);
  return new Map(data.map(item => [item.parameterID, item.serviceParameterLabel]));
}

/**
 * Fetch allocation rules by location and type
 */
async function getAllocationRuleByLocationAndType(igmsConfigMetaData, location, ruleType) {
  const query = SELECT.from('AllocationLocationRule').where({
    location,
    RuleMapWith: ruleType
  });
  return await igmsConfigMetaData.run(query);
}

/**
 * Fetch allocation profile
 */
async function getAllocationProfile(igmsConfigMetaData, profileName) {
  const query = SELECT.from('AllocationProfile').where({
    allocationProfileName: profileName
  });
  return await igmsConfigMetaData.run(query);
}

/**
 * Validate allocation rules against Gasday
 */
function checkValidityofDates(allocationRules, gasDay) {
  if (!gasDay) return null;

  const gasDate = new Date(gasDay);
  gasDate.setHours(0, 0, 0, 0);

  const result = allocationRules.find(rule => {
    const validFrom = new Date(rule.validFromAlloc);
    const validTo = new Date(rule.validToAlloc);

    validFrom.setHours(0, 0, 0, 0);
    validTo.setHours(0, 0, 0, 0);

    return gasDate >= validFrom && gasDate <= validTo;
  });

  return result || [];
}

/**
 * Formula-based allocation distribution
 */
async function formulaBasedDistribution(nomItems, sspMap, rule) {
  if (!Array.isArray(nomItems) || nomItems.length === 0) return;

  for (let i = 0; i < nomItems.length; i++) {
    const pdnq = parseFloat(nomItems[i].Pdnq);
    sspMap.set('SSP020', isNaN(pdnq) ? 0 : pdnq);

    const val1 = parseFloat(sspMap.get(rule.sp1) || 0);
    const val2 = parseFloat(sspMap.get(rule.sp2) || 0);
    const val3 = parseFloat(sspMap.get(rule.sp3) || 0);

    let result = 0;
    try {
      const expression = `${val1} ${rule.operator1} ${val2} ${rule.operator2} ${val3}`;
      result = eval(expression);
    } catch (err) {
      console.error(`Formula error for item ${i}:`, err);
      result = 0;
    }

    nomItems[i].allocatedDNQ = parseFloat(result.toFixed(3));
  }
  return nomItems;
}

/**
 * Pro Rata gas allocation
 */
function proRataGasAllocation(nomItems, aggrQty, availQty, demandKey) {
  if (!aggrQty || aggrQty <= 0) return nomItems;

  for (let i = 0; i < nomItems.length; i++) {
    let allotedQty = parseFloat(nomItems[i][demandKey]) / aggrQty * availQty;
    nomItems[i].allocatedDNQ = parseFloat(allotedQty.toFixed(3));
  }
  return nomItems;
}

/**
 * Fetch service parameter nodes for an allocation ID
 */
async function getServiceParameterNodes(igmsConfigMetaData, allocationID) {
  const query = SELECT.from('serviceParameterNode').where({ allocationID });
  return await igmsConfigMetaData.run(query);
}

/**
 * Fetch allocation formulas
 */
async function getAllocationFormula(igmsConfigMetaData) {
  const query = SELECT.from('allocationFormula');
  return await igmsConfigMetaData.run(query);
}

   async function checkValidityOfItems(dataArray, gasDay) {
    if (!gasDay || !Array.isArray(dataArray)) return [];

    const gasDate = new Date(gasDay);
    gasDate.setHours(0, 0, 0, 0); // Normalize to date only

    return dataArray.filter(entry => {
        // Detect validFrom and validTo keys (case-insensitive match)
        const fromKey = Object.keys(entry).find(k => k.toLowerCase().includes('validfrom'));
        const toKey = Object.keys(entry).find(k => k.toLowerCase().includes('validto'));

        if (!fromKey || !toKey) return false;

        const fromDate = new Date(entry[fromKey]);
        const toDate = new Date(entry[toKey]);

        fromDate.setHours(0, 0, 0, 0);
        toDate.setHours(0, 0, 0, 0);

        return gasDate >= fromDate && gasDate <= toDate;
    });

    
}

// ── Allocation helpers ────────────────────────────────────────────────────────

/** ZGT1 @ Delivery Point items are resolved directly from Entry Point data, never enter the rank engine. */
const isZgt1Contract = ct => String(ct || '').trim().toUpperCase() === 'ZGT1';

/** Rank=0 (or negative) is as unusable as a blank Rank — both must block the whole location. */
const isUnrankedValue = r => r == null || r === '' || isNaN(Number(r)) || Number(r) <= 0;

/**
 * Ticket Purpose/Status matrix — applies per nomination line item, only to rows whose
 * TicketKey is populated (see getItemTicketGate). Frontend mirror:
 * app/.../utils/ticketPurposeGate.js — keep both in sync.
 *   Purpose  Status        Allocation  Ticketing  Ticket Key shown
 *   1        00            BLOCK       BLOCK      Y   (Full Actualized)
 *   1        78            BLOCK       ALLOW      N   (Partially Actualized)
 *   1        other         BLOCK       ALLOW      N   (Not Completely Actualized)
 *   5        00            ALLOW       ALLOW      N   (Full Reversed)
 *   5        78            BLOCK       BLOCK      N   (Partially Reversed)
 *   5        other         BLOCK       BLOCK      N   (Not Completely Reversed)
 *   blank    blank         ALLOW       ALLOW      N
 *   any other combination BLOCK       ALLOW      N
 */
function getTicketPurposeGate(ticketPurpose, ticketStatus) {
  const purpose = String(ticketPurpose || '').trim();
  const status = String(ticketStatus || '').trim();
  if (!purpose && !status) return { allocationBlocked: false, ticketingBlocked: false };
  if (purpose === '1') return { allocationBlocked: true, ticketingBlocked: status === '00' };
  if (purpose === '5') {
    const bFullyReversed = status === '00';
    return { allocationBlocked: !bFullyReversed, ticketingBlocked: !bFullyReversed };
  }
  return { allocationBlocked: true, ticketingBlocked: false };
}

const _hasTicketKey = key => {
  const s = String(key || '').trim();
  return s !== '' && !/^0+$/.test(s);
};

/** Matrix above for one nomination row — a row without a TicketKey is never blocked. */
function getItemTicketGate(row) {
  if (!_hasTicketKey(row?.TicketKey)) return { allocationBlocked: false, ticketingBlocked: false };
  return getTicketPurposeGate(row.TicketPurpose, row.TicketStatus);
}

/** Human-readable ticket state for skip messages, e.g. "Full Actualized (Purpose 1, Status 00)". */
function describeTicketState(ticketPurpose, ticketStatus) {
  const purpose = String(ticketPurpose || '').trim();
  const status = String(ticketStatus || '').trim();
  const state = purpose === '1'
    ? (status === '00' ? 'Full Actualized' : status === '78' ? 'Partially Actualized' : 'Not Completely Actualized')
    : purpose === '5'
      ? (status === '00' ? 'Full Reversed' : status === '78' ? 'Partially Reversed' : 'Not Completely Reversed')
      : 'Unknown ticket state';
  return `${state} (Purpose ${purpose || 'NA'}, Status ${status || 'NA'})`;
}

/**
 * Quantity a ticket-blocked row keeps — its last saved allocation, same precedence the
 * cache uses when it loads AllocatedQty (scheduledNomItems.js _enrichScheduledItems).
 */
function savedAllocatedQty(row) {
  const q2 = parseFloat(row?.SavedAllocatedQty2 || 0);
  if (q2 > 0) return q2;
  const q1 = parseFloat(row?.SavedAllocatedQty || 0);
  return q1 > 0 ? q1 : 0;
}

/** Ticket Key is shown on the row in every state except Full Reversed (5/00). */
function isTicketKeyVisible(ticketKey, ticketPurpose, ticketStatus) {
  if (!_hasTicketKey(ticketKey)) return false;
  return !(String(ticketPurpose || '').trim() === '5' && String(ticketStatus || '').trim() === '00');
}

/** Names which piece (GCV/NCV and/or the caller's qty label) is actually missing — never a blanket "reading missing". */
function missingReasonMsg(qty, qual, sQtyLabel) {
  const bQualMissing = !qual || !(qual.gcv > 0) || !(qual.ncv > 0);
  const bQtyMissing = !(qty > 0);
  const parts = [];
  if (bQualMissing) parts.push('GCV/NCV');
  if (bQtyMissing) parts.push(sQtyLabel);
  return `${parts.join(' & ')} missing`;
}

/**
 * THIRDPARTY qty/GCV/NCV resolve from separate S/4 uploads — names only the actually-
 * missing piece for this location. `meterMap`'s qty is YyallocQtyNongailscm, S/4's own
 * SM3-converted reading — that can still be 0 even when the partner's raw upload
 * (YyallocQtyNongail, rawQtyMap) is genuinely present, if S/4 just hasn't finished
 * converting it yet. Blaming "Uploaded Qty missing" in that case is factually wrong —
 * the upload IS there, only the conversion is pending — so rawQtyMap (optional, for
 * backward compatibility with callers that haven't been updated) disambiguates the two.
 */
function tpMissingReasonMsg(loc, meterMap, qualMap, rawQtyMap) {
  const scmQty = meterMap.get(loc) || 0;
  const bScmMissing = !(scmQty > 0);
  const bRawUploaded = rawQtyMap ? (rawQtyMap.get(loc) || 0) > 0 : false;
  const qual = qualMap.get(loc);
  const bQualMissing = !qual || !(qual.gcv > 0) || !(qual.ncv > 0);

  if (bScmMissing && bRawUploaded) {
    // Deliberately never says "Missing Allocation Qty" — the frontend's category
    // detection (nominationTable._buildDataIssues) keys off that exact phrase to mean
    // "nothing was uploaded", the opposite of what's true here: the partner's quantity
    // IS there. When GCV/NCV is also missing, conversion isn't merely "pending" — it
    // is blocked outright until GCV/NCV is provided, so only the real blocker is named,
    // not a misleading "pending" note. "SM3 conversion pending" stands alone only when
    // quality is fine and S/4 genuinely just hasn't finished converting it yet.
    if (bQualMissing) return 'GCV/NCV reading is missing';
    return 'SM3 conversion pending (partner already provided a quantity)';
  }

  const parts = [];
  if (bScmMissing) parts.push('Missing Allocation Qty');
  if (bQualMissing) parts.push('GCV/NCV reading is missing');
  return parts.join(' & ');
}

/**
 * Same as tpMissingReasonMsg but at Partner+Location grain (pairKey = `customer__loc`) —
 * used wherever a shared connection point's partners must be judged independently
 * (runAllocation's Gate 7, validateMassTicket, and the Data Issues pre-flight report),
 * instead of one verdict for the whole Location.
 */
function tpMissingReasonMsgForPair(pairKey, custMeterMap, qualMap, custRawQtyMap) {
  const dunder = pairKey.indexOf('__');
  const loc = dunder >= 0 ? pairKey.slice(dunder + 2) : pairKey;
  const scmQty = custMeterMap.get(pairKey) || 0;
  const bScmMissing = !(scmQty > 0);
  const bRawUploaded = custRawQtyMap ? (custRawQtyMap.get(pairKey) || 0) > 0 : false;
  const qual = qualMap.get(loc);
  const bQualMissing = !qual || !(qual.gcv > 0) || !(qual.ncv > 0);

  if (bScmMissing && bRawUploaded) {
    // See tpMissingReasonMsg — deliberately never says "Missing Allocation Qty", and
    // never pairs "GCV/NCV reading is missing" with a misleading "pending" note when
    // conversion is actually blocked outright by the missing quality data.
    if (bQualMissing) return 'GCV/NCV reading is missing';
    return 'SM3 conversion pending (partner already provided a quantity)';
  }

  const parts = [];
  if (bScmMissing) parts.push('Missing Allocation Qty');
  if (bQualMissing) parts.push('GCV/NCV reading is missing');
  return parts.join(' & ');
}

const MKCAL_TO_MMBTU = 3.968254;

/**
 * Converts a THIRDPARTY SCADA qty to SM3 from GAIL's own GCV/NCV — used as a fallback
 * when S/4's own YyallocQtyNongailscm conversion isn't populated yet but the partner's
 * raw upload (YyallocQtyNongail/YyallocUomNongail) and quality are already available.
 */
function convertToSM3(qty, uom, gcv, ncv) {
    if (!uom || qty == null || qty === 0) {
        throw new Error("Mandatory parameter missing");
    }

    if ((uom === "MBG" || uom === "MBT" || uom === "MCG") && !gcv) {
        throw new Error("GCV is required for conversion to SM3");
    }

    if ((uom === "MBN" || uom === "MCN") && !ncv) {
        throw new Error("NCV is required for conversion to SM3");
    }

    switch (uom) {

        // Million British Thermal Unit - Gross. "MBT" carries no Gross/Net suffix —
        // GAIL custody-transfer convention treats an unsuffixed MBTU reading as
        // Gross, same formula/basis as MBG.
        case "MBT":
        case "MBG":
            return (qty / MKCAL_TO_MMBTU * 1_000_000) / gcv;

        // Million British Thermal Unit - Net
        case "MBN":
            return (qty / MKCAL_TO_MMBTU * 1_000_000) / ncv;

        // Million Kilo Calories - Gross
        case "MCG":
            return (qty * 1_000_000) / gcv;

        // Million Kilo Calories - Net
        case "MCN":
            return (qty * 1_000_000) / ncv;

        // Already SM3
        case "SM3":
            return qty;

        default:
            throw new Error(`Unsupported UOM for conversion to SM3: ${uom}`);
    }
}

const _r3 = v => Math.round(v * 1000) / 1000;

const _toRank = r => {
    if (r == null || r === '' || isNaN(Number(r))) return Number.MAX_SAFE_INTEGER;
    const n = Number(r);
    return n <= 0 ? Number.MAX_SAFE_INTEGER - 1 : n;
};

const _normSt = st => (st || '').trim().toUpperCase();

/**
 * Location-type priority: Redelivery Point items are Priority 0 — filled first, absolute
 * precedence over Delivery Point items (Priority 1), which receive only what Redelivery
 * leaves behind. ZGT1-at-Delivery-Point contracts are resolved directly from Entry Point
 * data upstream (runAllocation, via YalcsqtyEp/ConversionQty) and never reach this engine,
 * so ContractType plays no role here.
 */
const _toContractPriority = item => item.LocationType === 'DELIVERY' ? 1 : 0;

/**
 * Distributes totalQty among items pro-rata by ConversionQty, adding to `field`.
 * Applies rounding correction to largest-share item so sum is exact.
 */
function _proRataAdd(items, totalQty, field) {
    if (!items.length || totalQty <= 0) return;
    const totalDemand = items.reduce((s, it) => s + (parseFloat(it.ConversionQty) || 0), 0);
    let sumAdded = 0, maxVal = -1, maxIdx = 0;
    for (let j = 0; j < items.length; j++) {
        const demand = parseFloat(items[j].ConversionQty) || 0;
        const share = totalDemand > 0 ? _r3((demand / totalDemand) * totalQty) : _r3(totalQty / items.length);
        items[j][field] = _r3((parseFloat(items[j][field]) || 0) + share);
        sumAdded += share;
        if (share > maxVal) { maxVal = share; maxIdx = j; }
    }
    const diff = _r3(_r3(totalQty) - sumAdded);
    if (diff !== 0)
        items[maxIdx][field] = Math.max(0, _r3(items[maxIdx][field] + diff));
}

/**
 * Distributes totalQty among items pro-rata by ConversionQty.
 * Applies a rounding correction to the largest-share item so the sum is exact.
 * Mutates item.AllocatedQty.
 */
function _proRataDistribute(items, totalQty) {
    if (!items.length || totalQty <= 0) return;
    const totalDemand = items.reduce((s, it) => s + (parseFloat(it.ConversionQty) || 0), 0);

    let sumAlloc = 0, maxVal = -1, maxIdx = 0;
    for (let j = 0; j < items.length; j++) {
        const demand = parseFloat(items[j].ConversionQty) || 0;
        const share = totalDemand > 0 ? _r3((demand / totalDemand) * totalQty) : _r3(totalQty / items.length);
        items[j].AllocatedQty = share;
        sumAlloc += share;
        if (share > maxVal) { maxVal = share; maxIdx = j; }
    }
    // Correct any rounding residual on the largest-share item
    const diff = _r3(_r3(totalQty) - sumAlloc);
    if (diff !== 0)
        items[maxIdx].AllocatedQty = Math.max(0, _r3(items[maxIdx].AllocatedQty + diff));
}

/**
 * Fills items rank-by-rank from available qty. Returns the remaining qty after filling.
 * Groups are ordered first by location-type priority (_toContractPriority — Redelivery
 * Point contracts filled first, absolute precedence), then by Rank within each tier. Each
 * group is filled in full before the next; when available < group demand, the group is
 * pro-rated and all lower-priority groups receive 0. Mutates item.AllocatedQty.
 */
function _rankFill(items, available) {
    if (!items.length) return available;

    const sorted = [...items].sort((a, b) => {
        const cp = _toContractPriority(a) - _toContractPriority(b);
        return cp !== 0 ? cp : _toRank(a.Rank) - _toRank(b.Rank);
    });
    let remaining = available;
    let i = 0;
    const n = sorted.length;

    while (i < n) {
        if (remaining <= 0) { while (i < n) sorted[i++].AllocatedQty = 0; break; }

        const prioVal = _toContractPriority(sorted[i]);
        const rankVal = _toRank(sorted[i].Rank);
        const start = i;
        while (i < n && _toRank(sorted[i].Rank) === rankVal && _toContractPriority(sorted[i]) === prioVal) i++;
        const group = sorted.slice(start, i);

        // Round group demand in one shot to avoid per-item subtraction drift
        const groupDemand = _r3(group.reduce((s, it) => s + (parseFloat(it.ConversionQty) || 0), 0));

        if (remaining >= groupDemand) {
            for (const it of group) it.AllocatedQty = _r3(parseFloat(it.ConversionQty) || 0);
            remaining = _r3(remaining - groupDemand);
        } else {
            _proRataDistribute(group, remaining);
            while (i < n) sorted[i++].AllocatedQty = 0;
            remaining = 0;
            break;
        }
    }

    return remaining;
}

/**
 * Scenario A surplus rule — only FIRM contracts present at this Location (no FALLBACK
 * to absorb it, see _surplusAllocation's Scenario B). Decides how `qtyToAllocate` (the
 * leftover metered qty after every contract already received its own ConversionQty
 * demand) splits across `contracts` (the FIRM candidates within the lowest location-
 * type-priority tier present — Delivery Point items, since Redelivery has absolute
 * precedence; or the only tier present if one type is absent). Mutates each item's
 * AllocatedQty in place (adds the share on top of what it already holds).
 *
 * Absorber rule: the last-rank contract(s) absorb the surplus, ContractType plays no
 * role. Contracts tied on that last Rank split it pro-rata by ConversionQty (_proRataAdd).
 * @param {number} qtyToAllocate - surplus qty (SM3) still to distribute
 * @param {Array}  contracts     - candidate FIRM items eligible to receive it
 */
function distributeSurplusAmongContracts(qtyToAllocate, contracts) {
    if (!contracts.length) return;
    const maxRank = Math.max(...contracts.map(it => _toRank(it.Rank)));
    const candidates = contracts.filter(it => _toRank(it.Rank) === maxRank);
    _proRataAdd(candidates, qtyToAllocate, 'AllocatedQty');
}

/**
 * SURPLUS path — metered > totalDemand (both rounded to 3dp).
 *
 * Scenario A — Only FIRM contracts exist: distributeSurplusAmongContracts decides how
 *              the surplus splits across the FIRM candidates within the lowest
 *              location-type-priority tier present.
 * Scenario B — FIRM and FALLBACK both exist: FALLBACK absorbs the entire surplus,
 *              pro-rata by ConversionQty across all FALLBACK items (Rank ignored).
 */
function _surplusAllocation(locItems, metered) {
    const fallback = locItems.filter(it => _normSt(it.ServiceType) === 'FALLBACK');

    // Step 1: every contract gets its base DNQ demand
    for (const it of locItems) it.AllocatedQty = _r3(parseFloat(it.ConversionQty) || 0);
    const totalDemand = _r3(locItems.reduce((s, it) => s + (parseFloat(it.ConversionQty) || 0), 0));
    const surplus = _r3(metered - totalDemand);
    if (surplus <= 0) return;

    // Scenario B — FALLBACK absorbs all surplus (pro-rata), when FALLBACK contracts exist.
    if (fallback.length > 0) {
        _proRataAdd(fallback, surplus, 'AllocatedQty');
        return;
    }

    // Scenario A — Only FIRM: within the lowest-priority tier, distributeSurplusAmongContracts decides the split.
    const maxTier = Math.max(...locItems.map(_toContractPriority));
    const tierItems = locItems.filter(it => _toContractPriority(it) === maxTier);
    distributeSurplusAmongContracts(surplus, tierItems);
}

/**
 * DEFICIT path — metered < totalDemand (both rounded to 3dp).
 *
 * FIRM contracts have absolute priority over FALLBACK; Rank governs FIRM's own
 * fill order only — FALLBACK never considers Rank, in deficit any more than in
 * surplus (_surplusAllocation's Scenario B):
 *   1. FIRM contracts are filled rank-by-rank (_rankFill) first.
 *   2. FALLBACK contracts then split whatever FIRM leaves behind pro-rata by
 *      ConversionQty (_proRataDistribute) — same Rank-ignored rule
 *      distributeSurplusAmongContracts/_surplusAllocation already apply to
 *      FALLBACK on the surplus side, just against a deficit-sized remainder
 *      here. A single FALLBACK contract absorbs 100% of it. Location-level
 *      deficit (this function only runs when metered < totalDemand overall,
 *      and FIRM is always filled to its own full demand before FALLBACK sees
 *      anything) guarantees afterFirm never exceeds FALLBACK's own total
 *      demand, so this is always a real pro-rata split, never an overfill. If
 *      nothing is left, all FALLBACK contracts get 0 (_proRataDistribute is a
 *      no-op for a non-positive amount).
 */
function _deficitAllocation(locItems, metered) {
    const firmItems     = locItems.filter(it => _normSt(it.ServiceType) !== 'FALLBACK');
    const fallbackItems = locItems.filter(it => _normSt(it.ServiceType) === 'FALLBACK');

    // Step 1: fill FIRM rank-by-rank; capture remaining after FIRM
    const afterFirm = _rankFill(firmItems, metered);

    // Step 2: split whatever FIRM left behind across FALLBACK pro-rata, Rank ignored
    if (fallbackItems.length === 0) return;
    _proRataDistribute(fallbackItems, afterFirm);
}

/**
 * Segment-parameterized allocation Gate check — one nomination item at a time, same
 * grain and same Sets the classification loop in allocationEngine.js already checks
 * inline (Gates 2, 3, 4, 5, 9 — moved here verbatim, not re-derived). Gate 1/1b
 * (Location-wide conflict/orphan block) and Gate 6 (OWN+PRIMARY shared-pool routing)
 * are NOT covered here — they're cross-item/cross-segment pre-passes the caller
 * evaluates once per run before this per-item check (see allocationEngine.js's own
 * `blockedLocs`/`ownPrimaryLocs` construction). Gate 7 (THIRD-PARTY incomplete
 * reading) is also excluded — it's checked before CustomerKind/segment dispatch even
 * happens, since it applies purely by Partner__Location meter-key match, independent
 * of the item's own CustomerKind (see allocationEngine.js's own comment on this).
 *
 * @param {string} segment - 'OWN' | 'HYBRID' | 'THIRD-PARTY' | 'ENTRY-POINT'
 * @param {object} item    - one nomination item row (Location, Partner, Rank, CustomerKind)
 * @param {object} ctx     - gate-supporting Sets/Maps for this Gasday's run:
 *   unrankedOwnLocs, unrankedPriLocs, unrankedHybSecGrps (Gate 2, Location/Partner__Location);
 *   hybridMissingPartnerLocs (Gate 3); ownAtTpLocs (Gate 4);
 *   hybridBifurcationConflictLocs (Gate 5 — OWN too, so an "SLMC" item sharing a
 *   bifurcation-conflicted meter is blocked even when its PRIMARY sibling's own block
 *   left it out of Gate 6's ownPrimaryLocs merge); ownIncompleteLocs (Gate 9 — OWN/PRIMARY
 *   only; a dedicated-meter HYBRID item sources its own GCV/NCV independently, and a
 *   no-reading HYBRID item no longer draws from OWN's pool at all, so Gate 9 never
 *   applies to HYBRID); tpLocations (Gate 8, THIRD-PARTY only)
 * @returns {{ eligible: boolean, blockReason: string|null }}
 *   blockReason (when eligible is false): 'UNRANKED' | 'OWN_AT_TP' | 'OWN_INCOMPLETE' |
 *   'HYBRID_MISSING_PARTNER' | 'HYBRID_BIFURCATION' | 'TP_PARTNER_MISMATCH' |
 *   'EP_INCOMPLETE' | 'EP_GCVNCV_MISSING'
 */
function validateAllocation(segment, item, ctx) {
    const loc = item.Location;
    const grp = `${item.Partner || ''}__${loc}`;

    if (segment === 'OWN') {
        // Gate 2
        if (ctx.unrankedOwnLocs.has(loc)) return { eligible: false, blockReason: 'UNRANKED' };
        // Gate 4
        if (ctx.ownAtTpLocs.has(loc)) return { eligible: false, blockReason: 'OWN_AT_TP' };
        // Gate 5 — an OWN item (including an "SLMC"-labeled one, sharing this
        // Location's meter same as any PRIMARY/HYBRID item there) draws from the SAME
        // physical meter Gate 5 already found can't cover HYBRID's own declared demand.
        // Checked here too, not just for cid PRIMARY/HYBRID in allocationEngine.js's own
        // Gate 6 merge — a Location where PRIMARY itself got blocked by this same gate
        // never reaches Gate 6's ownPrimaryLocs merge, which otherwise left a co-located
        // OWN/SLMC item free to draw the raw, un-netted meter total instead of
        // being blocked with everyone else sharing that meter.
        if (ctx.hybridBifurcationConflictLocs.has(loc)) return { eligible: false, blockReason: 'HYBRID_BIFURCATION' };
        // Gate 9
        if (ctx.ownIncompleteLocs.has(loc)) return { eligible: false, blockReason: 'OWN_INCOMPLETE' };
        return { eligible: true, blockReason: null };
    }

    if (segment === 'HYBRID') {
        const cid = item.CustomerKind || '';
        if (cid === 'PRIMARY') {
            // Gate 2
            if (ctx.unrankedPriLocs.has(loc)) return { eligible: false, blockReason: 'UNRANKED' };
            // Gate 3
            if (ctx.hybridMissingPartnerLocs.has(loc)) return { eligible: false, blockReason: 'HYBRID_MISSING_PARTNER' };
            // Gate 5
            if (ctx.hybridBifurcationConflictLocs.has(loc)) return { eligible: false, blockReason: 'HYBRID_BIFURCATION' };
            // Gate 9 — PRIMARY's pool is netted from OWN's totalMR/GCV/NCV, so it applies here.
            if (ctx.ownIncompleteLocs.has(loc)) return { eligible: false, blockReason: 'OWN_INCOMPLETE' };
            return { eligible: true, blockReason: null };
        }
        // cid === 'HYBRID' (dedicated-meter or fallback secondary)
        // Gate 2
        if (ctx.unrankedHybSecGrps.has(grp)) return { eligible: false, blockReason: 'UNRANKED' };
        // Gate 3
        if (ctx.hybridMissingPartnerLocs.has(loc)) return { eligible: false, blockReason: 'HYBRID_MISSING_PARTNER' };
        // Gate 5
        if (ctx.hybridBifurcationConflictLocs.has(loc)) return { eligible: false, blockReason: 'HYBRID_BIFURCATION' };
        // Gate 9 does not apply here at all: a dedicated-meter HYBRID item sources its
        // own GCV/NCV independently of OWN's completeness, and an item with NO dedicated
        // meter no longer falls back to share OWN's residual pool (Gate 10, the caller's
        // own routing step, allocates it zero instead) — either way OWN's own Qty/GCV/NCV
        // completeness is irrelevant to this item.
        return { eligible: true, blockReason: null };
    }

    if (segment === 'THIRD-PARTY') {
        // Gate 8 — a usable reading exists at this Location, just not tagged to this
        // item's own Partner (a real reading exists elsewhere at the same Location).
        if (ctx.tpLocations.has(loc)) return { eligible: false, blockReason: 'TP_PARTNER_MISMATCH' };
        return { eligible: true, blockReason: null };
    }

    if (segment === 'ENTRY-POINT') {
        // Mode B completeness check (spec 3.3) — no CM Meter Qty reading at all blocks
        // the whole Location rather than falling back to ConversionQty. Checked directly
        // against epQtyByLocation (Entry Point's own resolved carve-out), never OWN's own
        // meter/GCV-NCV data — a pure Entry-Point-only Location (no OWN nomination at
        // all) has no entry in OWN's own maps and would otherwise always fail this check
        // even when its own CM Meter Qty genuinely exists. There is no confirmed-zero
        // signal for Entry Point (unlike THIRDPARTY's tpZeroQtyPairs) — exactly 0 means
        // reading missing/unresolved, same convention entryPointAllocation's own Phase 1
        // uses for its epQtyByDeliveryContract lookup.
        if (!((ctx.epQtyByLocation.get(loc) || 0) > 0))
            return { eligible: false, blockReason: 'EP_INCOMPLETE' };
        // GCV/NCV completeness — sourced from the SAME GDA row/batch that carries the
        // CM Meter Qty above (epGcvNcvMap resolved through the identical Vbeln→
        // CorrespondingDoc→DeliveryPoint chain, see scheduledNomItems.js). CM Meter Qty
        // is checked first: no meter reading at all is reported as EP_INCOMPLETE, not
        // a GCV/NCV issue, even though both would be blank in that case.
        const gcvNcv = ctx.epGcvNcvMap && ctx.epGcvNcvMap.get(loc);
        if (!gcvNcv || !(gcvNcv.gcv > 0) || !(gcvNcv.ncv > 0))
            return { eligible: false, blockReason: 'EP_GCVNCV_MISSING' };
        return { eligible: true, blockReason: null };
    }

    return { eligible: true, blockReason: null };
}

/**
 * Looks up the metered qty (QtyToAllocate) for one Location, or one Location+Customer,
 * from a single segment's Map out of entry.meterReadingMap (e.g.
 * entry.meterReadingMap.get('THIRDPARTY')) — pass `customer` to look up the
 * "Partner__Location" grain (HYBRID's own dedicated meter, THIRDPARTY); omit it for the
 * bare-Location grain (OWN, HYBRID_PRIMARY, ENTRYPOINT). Same key convention every
 * Partner__Location-keyed map in the cache entry already uses.
 * @param {Map}    meterMap - one segment's Map from entry.meterReadingMap
 * @param {string} location
 * @param {string} [customer]
 * @returns {number} QtyToAllocate — 0 when no reading is cached for this key
 */
function getQtyToAllocate(meterMap, location, customer) {
    const key = customer ? `${customer}__${location}` : location;
    return meterMap.get(key) || 0;
}

/**
 * Single shared allocation entry point for OWN_PRIMARY, PRIMARY, HYBRID (dedicated-
 * meter), and THIRD-PARTY — one call per group (Location, or Location+Customer for
 * HYBRID-dedicated/THIRD-PARTY; see allocationEngine.js's per-segment grouping before
 * this is called). ENTRY-POINT has its own separate algorithm (entryPointAllocation
 * below) — standalone Delivery Point contracts don't fit this Location/metered-qty
 * shape. Mutates each item's AllocatedQty/AllocUOM in place.
 *
 * Compares `qtyToAllocate` (this group's metered qty) against Σ ConversionQty and
 * dispatches: EQUAL → every item gets exactly ConversionQty. SURPLUS → every item
 * gets its ConversionQty first, then the leftover is layered on top per
 * the surplus rule in _surplusAllocation (FALLBACK, else last-Rank pro-rata). DEFICIT → FIRM filled rank-by-rank first (_rankFill), then
 * FALLBACK gets whatever remains.
 * @param {number} qtyToAllocate - metered qty (SM3) for this group
 * @param {Array}  contracts     - nomination item rows for this group
 */
function allocateContracts(qtyToAllocate, contracts) {
    for (const it of contracts) {
        it.AllocatedQty = 0;
        if (!it.AllocUOM) it.AllocUOM = it.ConversionUOM || 'SM3';
    }

    const metered     = _r3(qtyToAllocate || 0);
    const totalDemand = _r3(contracts.reduce((s, it) => s + (parseFloat(it.ConversionQty) || 0), 0));
    const surplus     = _r3(metered - totalDemand);

    if (surplus > 0) {
        _surplusAllocation(contracts, metered);
    } else if (surplus === 0) {
        for (const it of contracts) it.AllocatedQty = _r3(parseFloat(it.ConversionQty) || 0);
    } else {
        _deficitAllocation(contracts, metered);
    }
}

/**
 * Entry Point (Mode B) allocation — standalone Delivery Point contracts competing
 * for one Business Location's Entry Point carve-out. Mutates AllocatedQty.
 *
 * `remaining` is the pool available to these items — the existing Entry Point
 * carve-out (epQtyByLocation), NOT the raw CM meter reading, so OWN's own netted
 * pool at a shared-meter Location is never double-claimed by this engine.
 *
 * Phase 1 (Contract-wise) — CorrespondingDocNo match: for each item, look up its
 * OWN `Contract` directly in `epQtyByDeliveryContract` (the cached, server-resolved
 * Vbeln → CorrespondingDocNo → Delivery-Contract chain — scheduledNomItems.js) —
 * NOT a pre-tagged `_epMatchedQty` field on the row, which was picking up wrong
 * values. AllocatedQty = min(matched qty, remaining); remaining decreases. Once
 * remaining hits 0, later Phase 1 items get 0.
 *
 * PENDING: Phase 2+ (post-Phase-1 distribution across the unresolved items) is not
 * yet implemented here — `remaining`/`resolvedContracts` are left in place for that.
 *
 * @param {Array} items - Delivery Point contract rows for one Business Location, each
 *                        with: Contract, ContractType, Rank, ConversionQty, ConversionUOM
 * @param {number} remaining - Entry Point carve-out available to these items (SM3)
 * @param {Map} epQtyByDeliveryContract - Delivery Contract → resolved Entry Point qty
 *                           (SM3, plain number) — entry.epQtyByDeliveryContract from
 *                           nomCache (scheduledNomItems.js)
 */
function entryPointAllocation(items, remaining, epQtyByDeliveryContract) {
    for (const it of items) {
        it.AllocatedQty = 0;
        if (!it.AllocUOM) it.AllocUOM = it.ConversionUOM || 'SM3';
    }

    let rem = _r3(remaining || 0);

    // Phase 1 (Contract-wise) — CorrespondingDocNo match, looked up fresh against
    // epQtyByDeliveryContract every time instead of trusting a pre-tagged field.
    const resolvedContracts = new Set();
    for (const it of items) {
        const matched = parseFloat(epQtyByDeliveryContract?.get(it.Contract)) || 0;
        if (matched <= 0) continue;
        const take = rem > 0 ? _r3(Math.min(matched, rem)) : 0;
        it.AllocatedQty = take;
        rem = _r3(rem - take);
        resolvedContracts.add(it.Contract);
    }

    // Phase 2 grouping — everything Phase 1 didn't already resolve, split into a
    // ZGT1 group and a rest-of-ContractType group, each sorted Rank-ascending
    // (lowest Rank number = highest priority) ready for rank-wise fill.
    const unresolved = items.filter(it => !resolvedContracts.has(it.Contract));
    const zgt1Group = unresolved
        .filter(it => isZgt1Contract(it.ContractType))
        .sort((a, b) => _toRank(a.Rank) - _toRank(b.Rank));
    const otherGroup = unresolved
        .filter(it => !isZgt1Contract(it.ContractType))
        .sort((a, b) => _toRank(a.Rank) - _toRank(b.Rank));

    // Rank-wise fill — ZGT1 group first, then otherGroup with whatever ZGT1 left
    rem = _rankFill(zgt1Group, rem);
    rem = _rankFill(otherGroup, rem);

    // Surplus — rem still left after both rank-fills means every contract in both
    // groups already got its full ConversionQty demand; the leftover is absorbed by
    // the last-Rank contract(s), otherGroup preferred as absorber — only fall back to
    // zgt1Group's own last-Rank contract(s) when otherGroup has nothing. Ties within
    // the chosen group's last Rank split pro-rata by ConversionQty.
    if (rem > 0) {
        const absorberPool = otherGroup.length ? otherGroup : zgt1Group;
        if (absorberPool.length) {
            const maxRank = Math.max(...absorberPool.map(it => _toRank(it.Rank)));
            const lastRankItems = absorberPool.filter(it => _toRank(it.Rank) === maxRank);
            _proRataAdd(lastRankItems, rem, 'AllocatedQty');
        }
    }
}

module.exports = {
  getServiceParametersMap,
  getAllocationRuleByLocationAndType,
  getAllocationProfile,
  checkValidityofDates,
  formulaBasedDistribution,
  proRataGasAllocation,
  getServiceParameterNodes,
  getAllocationFormula,
  checkValidityOfItems,
  getNominationSumAtDelNRedlv,
  distributeSurplusAmongContracts,
  validateAllocation,
  getQtyToAllocate,
  allocateContracts,
  entryPointAllocation,
  isZgt1Contract,
  isUnrankedValue,
  getTicketPurposeGate,
  getItemTicketGate,
  describeTicketState,
  savedAllocatedQty,
  isTicketKeyVisible,
  missingReasonMsg,
  tpMissingReasonMsg,
  tpMissingReasonMsgForPair,
  convertToSM3
};