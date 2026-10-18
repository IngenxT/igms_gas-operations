// srv/utils/ari004Rules.js
'use strict';

// ── ARI004 business-rule evaluation + Master Contract DCQ clubbing ──────────
// Single source of truth for capping/rejection logic — shared between the
// xGMSxNOMSOURCE READ (balancingScheduling-service.js, projects a "what would
// be approved" preview onto the CSN grid) and the Confirm Nomination action
// (ConfirmNomNAlloc_service.js, the only place a cap/reject actually takes
// effect). Extracted so the two call sites can never drift apart — a client-
// displayed projection must always match what the confirm action itself would
// compute, or the preview becomes misleading.

const { fetchAllPaged } = require('./nomSourceFetch');

// ── Service Parameter ID → xGMSxNOMSOURCE field name ─────────────────────────
// Mirrors SP_TO_FIELD previously duplicated client-side in the CSN controller
// (removed — this module is now the only evaluator, client or server).
const SP_TO_FIELD = {
  SSP001: 'DeliveryDCQ',
  SSP002: 'RedeliveryDCQ',
  SSP013: 'ApprovedDNQ',
  SSP017: 'ProposedDNQ',
  SSP038: 'MaxRedeliveryDCQ',
  SSP039: 'MinRedeliveryDCQ',
  SSP040: 'MaxDeliveryDCQ',
  SSP041: 'MinDeliveryDCQ',
  SSP045: 'ServiceType'
  // SSP046/047/048 (Primary/Hybrid/Third Party Pipeline) identified the CUSTOMER
  // condition's target field — resolved directly via CustomerKind, see the
  // CUSTOMER match in evaluateRowARI004 below.
};

const DELIVERY_DCQ_FIELDS = new Set(['MaxDeliveryDCQ', 'MinDeliveryDCQ']);
const REDELIVERY_DCQ_FIELDS = new Set(['MaxRedeliveryDCQ', 'MinRedeliveryDCQ']);

const applyOperator = (a, op, b) => {
  switch ((op || '').trim()) {
    case '>': return a > b;
    case '<': return a < b;
    case '>=': return a >= b;
    case '<=': return a <= b;
    case '=':
    case '==': return a === b;
    case '!=':
    case '<>': return a !== b;
    default: return false;
  }
};

const toDateTime = s => (!s ? null : String(s).includes('T') ? s : `${s}T00:00:00`);
const fmt3 = v => (v == null) ? '0.000' : parseFloat(v).toFixed(3);
// Date-only key (first 10 chars) — tolerates datetime-format differences between
// raw S/4 rows and built nav items. Used wherever a row/nav needs matching by Gasday.
const dateKey = v => String(v ?? '').slice(0, 10);

// xGMSxNOMSOURCE booleans (isConfirmRequired, IsPrimaryContract, …) come back
// from the remote OData V2 service as either a real JS boolean or the literal
// string "true"/"false" depending on the call path. Only matters where we
// evaluate the value ourselves in JS; server-side $filter clauses are unaffected
// since S4 evaluates those.
const isTrue = v => v === true || v === 'true';

/**
 * Fetches active ARI004 rules and returns a list of parsed rule descriptors.
 * Not cached — rules can change between requests (admin config updates), and
 * callers on the READ path already get amortization from the xGMSxNOMSOURCE
 * 30s snapshot cache this function's result lands inside of; a second, separate
 * rules cache would be premature. validFrom/validTo are carried on each
 * descriptor rather than filtered here, since a selected-rows confirm (or a
 * multi-day grid page) can span multiple Gasdays — validity must be checked
 * per-row at evaluation time against THAT row's own Gasday (see
 * evaluateRowARI004), not once against a single day here.
 */
const fetchARI004Rules = async (igmsConfigMetaData) => {
  const aRules = await igmsConfigMetaData.run(
    SELECT.from('BusinessRules')
      .where({ 'areaOfInterest_ruleAreaCode': 'ARI004', isActive: true, isActiveRule: true })
      .columns('ID', 'ruleID', 'ruleDescription', 'actionType', 'messageToShow',
        'validFrom', 'validTo',
        {
          ref: ['conditions'], expand: [
            'ID', 'conditionSequence', 'conditionType',
            'thenSourceParamId', 'thenTargetParamId',
            {
              ref: ['rows'], expand: [
                'ID', 'rowSequence',
                { ref: ['fields'], expand: ['fieldKey', 'fieldValue', 'serviceParameterId'] }
              ]
            }
          ]
        }
      )
  );

  const parsed = [];
  for (const rule of aRules) {
    for (const cond of (rule.conditions || [])) {
      for (const row of (cond?.rows || [])) {
        const fields = row.fields;
        if (!fields?.length) continue;

        const fVal = (k) => fields.find(f => f.fieldKey === k)?.fieldValue || '';
        const fSPId = (k) => fields.find(f => f.fieldKey === k)?.serviceParameterId || '';

        const sOperator = fVal('OPERATOR');
        const sCheckField = SP_TO_FIELD[fSPId('SERVICEPARAMETER')];
        const sCompareField = SP_TO_FIELD[cond.thenSourceParamId];
        if (!sOperator || !sCheckField || !sCompareField) continue;

        const oCustField = fields.find(f => f.fieldKey === 'CUSTOMER');
        parsed.push({
          ruleID: rule.ruleID,
          description: rule.ruleDescription,
          actionType: rule.actionType,
          message: rule.messageToShow,
          validFrom: rule.validFrom,
          validTo: rule.validTo,
          contractType: fVal('CONTRACT_TYPE'),
          serviceProfile: fVal('SERVICE_PROFILE'),
          customerSPId: oCustField?.serviceParameterId || '',
          customer: oCustField?.fieldValue || '',
          businessLocation: fVal('BUSINESS_LOCATION'),
          rank: fVal('RANK'),
          checkField: sCheckField,
          operator: sOperator,
          compareField: sCompareField,
          capField: SP_TO_FIELD[cond.thenTargetParamId]
        });
      }
    }
  }
  return parsed;
};

/**
 * Fetches every RDP-side xGMSxNOMSOURCE row for one Gasday sharing any of the
 * given MasterContractNo values — regardless of confirm status or whether the
 * peer is itself part of the caller's own row/selection set, since an
 * already-confirmed or unselected peer still consumes a share of the Primary
 * Contract's DCQ pool.
 * @param {import('@sap/cds').Service} GMSCONFIRMNOM_SRV
 * @param {string} gasday
 * @param {string[]} masterContractNos
 * @returns {Promise<object[]>}
 */
const fetchMasterContractDCQPeers = async (GMSCONFIRMNOM_SRV, gasday, masterContractNos) => {
  if (!masterContractNos.length) return [];
  const q = SELECT.from('xGMSxNOMSOURCE')
    .columns('ContractNo', 'Item', 'Versn', 'NominationItem', 'MasterContractNo',
      'IsPrimaryContract', 'MaxRedeliveryDCQ', 'MinRedeliveryDCQ', 'ProposedDNQ', 'RedeliveryPoint')
    .where`Gasday = ${gasday} and RedeliveryPoint != ${''}`;
  q.where({ MasterContractNo: { in: masterContractNos } });
  return fetchAllPaged(GMSCONFIRMNOM_SRV, q);
};

/**
 * Groups peer rows by MasterContractNo and computes each group's DCQ pool: the
 * Primary Contract's own Min/MaxRedeliveryDCQ, and the sum of ProposedDNQ
 * across every peer as the total nominated quantity. A group with no
 * IsPrimaryContract row present has no pool — the caller leaves those rows
 * alone (the "Special Condition": every contract under the Master Contract
 * already carries its own DCQ, so no clubbing applies).
 * @param {object[]} aPeerRows
 * @returns {Map<string,{primaryMaxRedeliveryDCQ:number, primaryMinRedeliveryDCQ:number, totalNominated:number, hasPrimary:boolean}>}
 *   keyed by MasterContractNo
 */
const computeMasterContractDCQPools = (aPeerRows) => {
  const mByMC = new Map();
  aPeerRows.forEach(r => {
    const mc = String(r.MasterContractNo ?? '');
    if (!mc) return;
    let a = mByMC.get(mc);
    if (!a) mByMC.set(mc, a = []);
    a.push(r);
  });

  const mPools = new Map();
  for (const [mc, aRows] of mByMC) {
    const oPrimary = aRows.find(r => isTrue(r.IsPrimaryContract));
    const totalNominated = aRows.reduce((s, r) => s + (parseFloat(r.ProposedDNQ) || 0), 0);
    mPools.set(mc, {
      primaryMaxRedeliveryDCQ: oPrimary ? (parseFloat(oPrimary.MaxRedeliveryDCQ) || 0) : 0,
      primaryMinRedeliveryDCQ: oPrimary ? (parseFloat(oPrimary.MinRedeliveryDCQ) || 0) : 0,
      totalNominated,
      hasPrimary: !!oPrimary
    });
  }
  return mPools;
};

/**
 * Resolves Master Contract DCQ pools for every (Gasday, MasterContractNo) group
 * implied by aRows' clubbing candidates: RDP-side rows carrying a
 * MasterContractNo, not themselves the Primary Contract, with
 * Min/MaxRedeliveryDCQ = 0 — the signal that their real DCQ lives on the
 * Primary Contract instead. Fetches ALL peers per group (not just aRows' own
 * members) since an out-of-scope or already-confirmed peer still consumes a
 * share of the shared DCQ. Feeds both evaluateRowARI004 (so a clubbed
 * subcontract is checked against its Master Contract's real capacity instead
 * of its own, always-zero limit) and, afterward, applyMasterContractDCQClubbing's
 * pro-rata split. Keyed by (Gasday, MasterContractNo) — never MasterContractNo
 * alone — since a caller's row set can span multiple Gasdays.
 * @param {object[]} aRows
 * @param {import('@sap/cds').Service} GMSCONFIRMNOM_SRV
 * @param {object[]} [aDayPool] - every xGMSxNOMSOURCE row (all Versn, any confirm
 *   status, IsPrimaryContract included) for aRows' Gas Days. When given, peers are
 *   taken from it with the same Gasday/RedeliveryPoint/MasterContractNo conditions
 *   fetchMasterContractDCQPeers sends to S/4, instead of a remote query.
 * @returns {Promise<Map<string,object>>} '{dateKey}|{MasterContractNo}' → pool (see computeMasterContractDCQPools)
 */
const resolveMasterContractPools = async (aRows, GMSCONFIRMNOM_SRV, aDayPool) => {
  const isZero = v => v == null || v === '' || parseFloat(v) === 0;
  const mPools = new Map();

  const aCandidates = aRows.filter(r =>
    !!r.RedeliveryPoint && !!r.MasterContractNo &&
    !isTrue(r.IsPrimaryContract) &&
    isZero(r.MinRedeliveryDCQ) && isZero(r.MaxRedeliveryDCQ)
  );
  if (!aCandidates.length) return mPools;

  const mByGasday = new Map();
  aCandidates.forEach(r => {
    const gd = dateKey(r.Gasday);
    let a = mByGasday.get(gd);
    if (!a) mByGasday.set(gd, a = []);
    a.push(r);
  });

  for (const [gasday, aGroupRows] of mByGasday) {
    const aMasterContractNos = [...new Set(aGroupRows.map(r => String(r.MasterContractNo)))];
    let aPeerRows;
    if (aDayPool) {
      const sMC = new Set(aMasterContractNos);
      aPeerRows = aDayPool.filter(r => dateKey(r.Gasday) === gasday && !!r.RedeliveryPoint &&
        sMC.has(String(r.MasterContractNo)));
    } else {
      aPeerRows = await fetchMasterContractDCQPeers(GMSCONFIRMNOM_SRV, gasday, aMasterContractNos);
    }
    for (const [mc, oPool] of computeMasterContractDCQPools(aPeerRows)) {
      mPools.set(`${gasday}|${mc}`, oPool);
    }
  }
  return mPools;
};

/**
 * Looks up the effective Min/MaxRedeliveryDCQ for one row: the row's own
 * values, unless it's a Master Contract clubbing candidate (own values both
 * zero, not itself Primary) with a resolvable pool, in which case the Primary
 * Contract's own Min/Max substitute — otherwise ARI004 always fails/caps a
 * clubbed subcontract against its own, always-zero limit.
 * @param {object} row
 * @param {Map<string,object>} mPools - from resolveMasterContractPools
 * @returns {{ effectiveMin: number|string|null, effectiveMax: number|string|null }}
 */
const resolveEffectiveRedeliveryDCQ = (row, mPools) => {
  const rawMin = row.MinRedeliveryDCQ, rawMax = row.MaxRedeliveryDCQ;
  if (!mPools.size || !row.RedeliveryPoint || !row.MasterContractNo || isTrue(row.IsPrimaryContract)) {
    return { effectiveMin: rawMin, effectiveMax: rawMax };
  }
  const oPool = mPools.get(`${dateKey(row.Gasday)}|${String(row.MasterContractNo)}`);
  if (!oPool?.hasPrimary) return { effectiveMin: rawMin, effectiveMax: rawMax };
  return { effectiveMin: oPool.primaryMinRedeliveryDCQ, effectiveMax: oPool.primaryMaxRedeliveryDCQ };
};

/**
 * Builds the ProposedDnq override map for Master Contract DCQ clubbing, from
 * already-resolved pools (resolveMasterContractPools) — no further S/4 round
 * trip. Splits each clubbed group's combined nomination pro-rata across ALL of
 * its Gasday peers — including the Primary Contract's own row, which shares
 * the same pool and must be prorated alongside its peers, not left at its full
 * nominated quantity — when the total exceeds the Primary Contract's DCQ;
 * otherwise every row confirms at its full nominated quantity ("schedule as
 * requested"). Rows outside a resolvable clubbing group (no pool, or no
 * Primary Contract found — the "Special Condition") are left untouched.
 * @param {object[]} aRows - post-ARI004 confirmable rows
 * @param {Map<string,object>} mPools - from resolveMasterContractPools
 * @returns {Map<string,number>} '{dateKey}|{ContractNo}' → overridden ProposedDnq
 */
const applyMasterContractDCQClubbing = (aRows, mPools) => {
  const clubMap = new Map();
  if (!mPools.size) return clubMap;

  for (const r of aRows) {
    if (!r.RedeliveryPoint || !r.MasterContractNo) continue;

    const gasday = dateKey(r.Gasday);
    const oPool = mPools.get(`${gasday}|${String(r.MasterContractNo)}`);
    if (!oPool?.hasPrimary) continue; // no clubbing group resolved for this Master Contract — leave alone

    const fOwnNominated = parseFloat(r.ProposedDNQ) || 0;
    const fProposed = (oPool.totalNominated > oPool.primaryMaxRedeliveryDCQ && oPool.totalNominated > 0)
      ? (fOwnNominated / oPool.totalNominated) * oPool.primaryMaxRedeliveryDCQ
      : fOwnNominated;
    clubMap.set(`${gasday}|${String(r.ContractNo)}`, fProposed);
  }
  return clubMap;
};

/**
 * Records the most-restrictive cap for one ContractNo/field pair — lower wins
 * for ">"/">=" violations (value too high), higher wins for "<"/"<=" (too low).
 */
const applyCap = (capMap, contractNo, field, value, operator) => {
  const key = String(contractNo);
  if (!capMap.has(key)) capMap.set(key, {});
  const oCap = capMap.get(key);
  if (!(field in oCap)) {
    oCap[field] = value;
  } else {
    oCap[field] = (operator === '>' || operator === '>=')
      ? Math.min(oCap[field], value)
      : Math.max(oCap[field], value);
  }
};

/**
 * Evaluates all parsed ARI004 rules against one xGMSxNOMSOURCE row. This is
 * the single evaluator for both the confirm action and the READ-time "what
 * will be approved" projection — never duplicated. validFrom/validTo are
 * checked here, against THIS row's own Gasday — a caller's row set can span
 * multiple Gasdays, so a rule valid for one day may not be valid for another;
 * see fetchARI004Rules. When mPools is supplied (see resolveMasterContractPools),
 * a rule whose compareField is Min/MaxRedeliveryDCQ is checked against the
 * row's EFFECTIVE limit — the Master Contract's Primary Contract value for a
 * clubbed subcontract, otherwise the row's own value — so a clubbed
 * subcontract (whose own Min/MaxRedeliveryDCQ is always 0 by design) doesn't
 * spuriously fail/cap against a limit that was never meant to apply to it.
 * @param {Map<string,object>} [mPools] - from resolveMasterContractPools
 * @returns {{ rejected: boolean, messages: string[], caps: {field:string,value:number,operator:string,ruleID:string}[] }}
 */
const evaluateRowARI004 = (row, aParsedRules, mPools) => {
  const messages = [];
  const caps = [];
  let rejected = false;
  const sRowDay = dateKey(row.Gasday);
  const { effectiveMin, effectiveMax } = mPools
    ? resolveEffectiveRedeliveryDCQ(row, mPools)
    : { effectiveMin: row.MinRedeliveryDCQ, effectiveMax: row.MaxRedeliveryDCQ };
  for (const rule of aParsedRules) {
    if (sRowDay && (rule.validFrom > sRowDay || rule.validTo < sRowDay)) continue;
    if (rule.contractType && rule.contractType !== row.ContractType) continue;
    if (rule.serviceProfile && rule.serviceProfile !== row.ServiceType) continue;
    if (rule.rank && rule.rank !== row.Rank) continue;
    if (rule.customerSPId) {
      // CUSTOMER condition targets customer-type (SSP046/047/048) — fieldValue
      // already holds the literal CustomerKind value ('' / PRIMARY / HYBRID / THIRD-PARTY).
      if (rule.customer !== (row.CustomerKind || '')) continue;
    } else if (rule.customer) {
      if (rule.customer !== row.Partner) continue;
    }
    if (rule.businessLocation) {
      const sLoc = rule.businessLocation;
      if (sLoc !== row.DeliveryPoint && sLoc !== row.RedeliveryPoint) continue;
    }

    // Route by rule's intended side — prevents DP rules firing on RDP rows and vice versa
    if (DELIVERY_DCQ_FIELDS.has(rule.compareField) && !row.DeliveryPoint) continue;
    if (REDELIVERY_DCQ_FIELDS.has(rule.compareField) && !row.RedeliveryPoint) continue;

    const checkVal = parseFloat(row[rule.checkField] ?? 0);
    const raw = rule.compareField === 'MaxRedeliveryDCQ' ? effectiveMax
      : rule.compareField === 'MinRedeliveryDCQ' ? effectiveMin
        : row[rule.compareField];
    if (raw == null) continue; // limit field absent from S4 for this row type

    const compareVal = parseFloat(raw);
    if (!applyOperator(checkVal, rule.operator, compareVal)) continue;

    if (rule.actionType === 'Reject') {
      rejected = true;
      messages.push(rule.message || `${rule.ruleID} violated`);
    } else if (rule.actionType === 'Accept' && rule.capField) {
      caps.push({ field: rule.capField, value: compareVal, operator: rule.operator, ruleID: rule.ruleID });
    }
  }
  return { rejected, messages, caps };
};

module.exports = {
  SP_TO_FIELD, DELIVERY_DCQ_FIELDS, REDELIVERY_DCQ_FIELDS,
  applyOperator, toDateTime, fmt3, dateKey, isTrue,
  fetchARI004Rules, evaluateRowARI004, applyCap,
  fetchMasterContractDCQPeers, computeMasterContractDCQPools,
  resolveMasterContractPools, resolveEffectiveRedeliveryDCQ,
  applyMasterContractDCQClubbing
};
