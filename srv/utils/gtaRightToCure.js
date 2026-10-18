// srv/utils/gtaRightToCure.js
'use strict';

// ── GTA (ZGT1) Right-to-Cure-Imbalance scheduling ────────────────────────────
// Applied on Confirm Nomination to every GTA pair: the Delivery Point leg and
// the Redelivery Point leg of one GTA, linked via CorrespondingDocNo. Demand is
// each leg's ProposedDNQ, the result replaces the ProposedDnq posted to S/4.
//
// The pair's imbalance (DP demand − RDP demand, the "curing as per demand") is
// always preserved — only one side (the anchor) is clamped to the limit it
// breached, and the other side moves by exactly the same delta:
//   1. at least one side within its own [Min, Max] → schedule both as demanded
//   2. both sides breach in the SAME direction     → anchor = the side with the
//      smaller breach ("nearest"); tie → RDP
//   3. one side breaches high, the other low       → anchor = RDP
// Unbundled CT (a leg linked to an unbundled GSA — pairLimits / resolveGsaLimits):
//   - DP linked  → the scenarios above are NOT used: DP is capped to the GSA's
//     [Min, Max] and RDP moves by the same delta, not re-clamped (GSA_DP_CAP)
//   - only RDP linked → scenarios above on the GSA's limits for RDP, then RDP is
//     clamped into the GSA's [Min, Max] (GSA_LIMIT when that's the only change)
// The adjusted (non-anchor) side is NOT re-clamped to its own limits — it may
// legitimately land outside them — only floored at 0.
//
// Replaces ARI004's per-row Min/Max DCQ capping for these rows: ARI004 would
// clamp each leg independently and so change the imbalance being cured (see
// isDcqLimitRule, used by the confirm action to skip those rules for GTA legs).

const { DELIVERY_DCQ_FIELDS, REDELIVERY_DCQ_FIELDS, dateKey, resolveEffectiveRedeliveryDCQ } = require('./ari004Rules');
const cds = require('@sap/cds');
const { chunk, fetchAllPaged, normDoc, dedupeLatestVersion } = require('./nomSourceFetch');

const GTA_CONTRACT_TYPE = 'ZGT1';
const GSA_CONTRACT_TYPE = 'ZGS1';
const CONTRACT_CHUNK = 100;
// GSA contract master (xGMSxCONTSALE): SSP034 'Linked Functionality' marks an
// unbundled GSA; to_contractcl holds the DCQ thresholds as % of the DCQ.
const SSP_LINKED_FUNCTIONALITY = 'SSP034';
const SSP_MAX_RDP_DCQ = 'SSP038';
const SSP_MIN_RDP_DCQ = 'SSP039';
const GSA_MASTER_TTL_MS = 5 * 60 * 1000;

const isGtaContract = r => String(r?.ContractType || '').trim().toUpperCase() === GTA_CONTRACT_TYPE;

/** ARI004 rules whose limit is a Min/Max DCQ — owned by Right to Cure for GTA legs. */
const isDcqLimitRule = rule =>
  DELIVERY_DCQ_FIELDS.has(rule.compareField) || REDELIVERY_DCQ_FIELDS.has(rule.compareField);

const r3 = v => Math.round(v * 1000) / 1000;
const num = v => {
  const n = parseFloat(v);
  return isNaN(n) ? 0 : n;
};

/**
 * Min below/at 0 means no lower limit (a demand can never breach it); Max
 * blank/0 means no upper limit configured — a 0 Max would otherwise flag
 * every positive demand as a high breach.
 */
const normLimits = (min, max) => {
  const fMax = num(max);
  return { min: Math.max(num(min), 0), max: fMax > 0 ? fMax : Infinity };
};

/** @returns {{ dir: 'HIGH'|'LOW'|null, by: number, limit: number|null }} */
const breachOf = (demand, { min, max }) => {
  if (demand > max) return { dir: 'HIGH', by: r3(demand - max), limit: max };
  if (demand < min) return { dir: 'LOW', by: r3(min - demand), limit: min };
  return { dir: null, by: 0, limit: null };
};

/**
 * Pure Right-to-Cure calculation for one GTA pair.
 * @param {{ dpDemand:number, rdpDemand:number, dpMin:number, dpMax:number, rdpMin:number, rdpMax:number }} p
 * @returns {{ scenario: 'AS_DEMANDED'|'BOTH_HIGH'|'BOTH_LOW'|'OPPOSITE', anchor: 'DP'|'RDP'|null,
 *   delta: number, curing: number, dpSchedule: number, rdpSchedule: number }}
 */
const computeRightToCure = ({ dpDemand, rdpDemand, dpMin, dpMax, rdpMin, rdpMax, dpClamp = false, rdpClamp = false }) => {
  const oDpLim = normLimits(dpMin, dpMax), oRdpLim = normLimits(rdpMin, rdpMax);
  const fDp = num(dpDemand), fRdp = num(rdpDemand);
  const clamp = (v, { min, max }) => r3(Math.min(Math.max(v, min), max));

  // Unbundled CT, DP linked to the GSA: DP has priority — DP is capped to the
  // GSA's [Min, Max] and RDP moves by exactly the same delta (DP up → RDP up,
  // DP down → RDP down), NOT re-clamped to its own limits, only floored at 0.
  if (dpClamp) {
    const dpSchedule = clamp(fDp, oDpLim);
    const delta = r3(dpSchedule - fDp);
    return {
      scenario: delta ? 'GSA_DP_CAP' : 'AS_DEMANDED', anchor: delta ? 'DP' : null, delta,
      curing: r3(fDp - fRdp), dpSchedule, rdpSchedule: Math.max(r3(fRdp + delta), 0),
      gsaCapped: delta ? ['DP'] : []
    };
  }

  const oRes = _rightToCure(fDp, fRdp, oDpLim, oRdpLim);
  // Only RDP linked to the GSA: Right to Cure as normal, then RDP must end
  // inside the GSA's [Min, Max].
  const aGsaCapped = [];
  if (rdpClamp) {
    const v = clamp(oRes.rdpSchedule, oRdpLim);
    if (v !== oRes.rdpSchedule) { oRes.rdpSchedule = v; aGsaCapped.push('RDP'); }
  }
  oRes.gsaCapped = aGsaCapped;
  if (aGsaCapped.length && oRes.scenario === 'AS_DEMANDED') oRes.scenario = 'GSA_LIMIT';
  return oRes;
};

const _rightToCure = (fDp, fRdp, oDpLim, oRdpLim) => {
  const oDp = breachOf(fDp, oDpLim);
  const oRdp = breachOf(fRdp, oRdpLim);
  const curing = r3(fDp - fRdp);

  if (!oDp.dir || !oRdp.dir) {
    return { scenario: 'AS_DEMANDED', anchor: null, delta: 0, curing, dpSchedule: r3(fDp), rdpSchedule: r3(fRdp) };
  }

  let scenario, anchor;
  if (oDp.dir === oRdp.dir) {
    scenario = oDp.dir === 'HIGH' ? 'BOTH_HIGH' : 'BOTH_LOW';
    anchor = oDp.by < oRdp.by ? 'DP' : 'RDP';
  } else {
    scenario = 'OPPOSITE';
    anchor = 'RDP';
  }

  const delta = anchor === 'DP' ? r3(oDp.limit - fDp) : r3(oRdp.limit - fRdp);
  const dpSchedule = anchor === 'DP' ? r3(oDp.limit) : Math.max(r3(fDp + delta), 0);
  const rdpSchedule = anchor === 'RDP' ? r3(oRdp.limit) : Math.max(r3(fRdp + delta), 0);
  return { scenario, anchor, delta, curing, dpSchedule, rdpSchedule };
};

/**
 * Fetches every xGMSxNOMSOURCE row (all items/versions, any confirm status) of
 * the eligible rows' own contracts and their CorrespondingDocNo partners, over
 * the eligible rows' Gasday range — the partner leg is often not part of the
 * user's selection but its demand and limits are still needed.
 * @param {import('@sap/cds').Service} GMSCONFIRMNOM_SRV
 * @param {object[]} aEligible
 * @returns {Promise<object[]>}
 */
const fetchGtaContextRows = async (GMSCONFIRMNOM_SRV, aEligible) => {
  const aGasdays = [...new Set(aEligible.map(r => dateKey(r.Gasday)).filter(Boolean))].sort();
  const sDocs = new Set();
  for (const r of aEligible) {
    if (r.ContractNo) sDocs.add(String(r.ContractNo).trim());
    // CorrespondingDocNo isn't ALPHA-converted — pad to match the ContractNo key.
    const doc = normDoc(r.CorrespondingDocNo);
    if (doc) sDocs.add(doc.padStart(10, '0'));
  }
  if (!aGasdays.length || !sDocs.size) return [];

  const aRows = [];
  for (const aChunk of chunk([...sDocs], CONTRACT_CHUNK)) {
    const q = SELECT.from('xGMSxNOMSOURCE')
      .where`Gasday >= ${aGasdays[0]} and Gasday <= ${aGasdays[aGasdays.length - 1]}`;
    q.where({ ContractNo: { in: aChunk } });
    aRows.push(...await fetchAllPaged(GMSCONFIRMNOM_SRV, q));
  }
  return aRows;
};

/**
 * Resolves the GTA pairs touched by aEligible. For each eligible row, its
 * candidate group is every (latest-Versn) row of its own contract plus its
 * CorrespondingDocNo partner contract on the same Gasday; the group is a GTA
 * pair when any member is ZGT1 and it holds exactly one Delivery-leg row
 * (DeliveryPoint set, RedeliveryPoint blank) and one Redelivery-leg row.
 * @param {object[]} aEligible
 * @param {object[]} aContextRows - from fetchGtaContextRows
 * @returns {{ pairs: {gasday:string, dp:object, rdp:object}[], skipped: {ContractNo:string, Message:string}[] }}
 */
const resolveGtaPairs = (aEligible, aContextRows) => {
  const mByDayDoc = new Map(); // '{dateKey}|{normDoc(ContractNo)}' → latest-Versn rows
  for (const r of dedupeLatestVersion(aContextRows)) {
    const k = `${dateKey(r.Gasday)}|${normDoc(r.ContractNo)}`;
    let a = mByDayDoc.get(k);
    if (!a) mByDayDoc.set(k, a = []);
    a.push(r);
  }

  const rowKey = r => `${dateKey(r.Gasday)}|${normDoc(r.ContractNo)}|${r.Item}|${r.NominationItem}`;
  const mPairs = new Map();
  const skipped = [];
  const sSkipped = new Set();

  for (const r of aEligible) {
    const gasday = dateKey(r.Gasday);
    const sOwn = normDoc(r.ContractNo);
    const sPartner = normDoc(r.CorrespondingDocNo);
    const aGroup = [
      ...(mByDayDoc.get(`${gasday}|${sOwn}`) || []),
      ...(sPartner && sPartner !== sOwn ? mByDayDoc.get(`${gasday}|${sPartner}`) || [] : [])
    ];
    if (!aGroup.some(isGtaContract) && !isGtaContract(r)) continue;

    const aDp = aGroup.filter(g => g.DeliveryPoint && !g.RedeliveryPoint);
    const aRdp = aGroup.filter(g => g.RedeliveryPoint);
    if (aDp.length !== 1 || aRdp.length !== 1) {
      const sKey = `${gasday}|${sOwn}`;
      if (!sSkipped.has(sKey)) {
        sSkipped.add(sKey);
        skipped.push({
          ContractNo: r.ContractNo ?? '',
          Message: `Right to Cure not applied on ${gasday} — expected 1 Delivery and 1 Redelivery leg, ` +
            `found ${aDp.length} and ${aRdp.length}`
        });
      }
      continue;
    }
    const sPairKey = `${rowKey(aDp[0])}#${rowKey(aRdp[0])}`;
    if (!mPairs.has(sPairKey)) mPairs.set(sPairKey, { gasday, dp: aDp[0], rdp: aRdp[0] });
  }
  return { pairs: [...mPairs.values()], skipped };
};

const _mGsaMaster = new Map(); // normDoc(GSA) → { ts, row } — contract master changes rarely

/** xGMSxCONTSALE rows (+ CF/CL/DQ) for the given GSAs, cache-first. */
const _fetchGsaMaster = async aGsas => {
  const now = Date.now();
  const aMiss = aGsas.filter(g => !(now - (_mGsaMaster.get(g)?.ts ?? 0) < GSA_MASTER_TTL_MS));
  if (aMiss.length) {
    const GMSCONTRACT_MGMT_SRV = await cds.connect.to('GMSCONTRACT_MGMT_SRV');
    for (const aChunk of chunk(aMiss, CONTRACT_CHUNK)) {
      const aRows = await GMSCONTRACT_MGMT_SRV.run(
        SELECT.from('xGMSxCONTSALE')
          .where({ ContractNo: { in: aChunk.map(g => g.padStart(10, '0')) } })
          // Nav props need expand '*' — a column list inside expand is dropped by the V2 remote.
          .columns('ContractNo', 'DocumentType',
            { ref: ['to_contractcf'], expand: ['*'] },
            { ref: ['to_contractcl'], expand: ['*'] },
            { ref: ['to_contractdq'], expand: ['*'] })
      );
      for (const g of aChunk) _mGsaMaster.set(g, { ts: now, row: null });
      for (const r of aRows || []) _mGsaMaster.set(normDoc(r.ContractNo), { ts: now, row: r });
    }
  }
  return new Map(aGsas.map(g => [g, _mGsaMaster.get(g)?.row || null]));
};

const _validOn = (r, gasday) =>
  (!r.ValidFrom || dateKey(r.ValidFrom) <= gasday) && (!r.ValidTo || dateKey(r.ValidTo) >= gasday);

/**
 * Unbundled CT: a GTA leg flagged LinkContexist='X' is linked
 * (xGMSxLINKCONT_NOMSOURCE_JOIN, Contract_NO = leg → LINKCONT) to a GSA whose
 * contract master marks SSP034 'Linked Functionality' = Unbundled. That GSA's
 * DCQ & limits replace the limits of every leg of the pair that is linked to it
 * (dpLinked / rdpLinked):
 *   DCQ = GSA to_contractdq RedeliveryDcq valid on the gas day (the row at the
 *         GTA's Redelivery Point when there are several, else their sum)
 *   Min = DCQ × SSP039 %,  Max = DCQ × SSP038 %  (to_contractcl, valid on the gas day)
 * Every GTA linked to the same GSA uses the GSA's full limits.
 * @param {{gasday:string, dp:object, rdp:object}[]} aPairs
 * @param {import('@sap/cds').Service} GMSCONFIRMNOM_SRV - for the link JOIN
 * @param {(svc:object, keys:string[], field:'Contract_NO')=>Promise<object[]>} fetchJoinRows
 * @returns {Promise<Map<object,{gsa:string, ok:boolean, dcq:number, minPer:number|null,
 *   maxPer:number|null, min:number, max:number, reason:string, dpLinked:boolean, rdpLinked:boolean}>>}
 *   pair → GSA limits, only for pairs linked to an unbundled GSA; ok=false when
 *   the GSA has no DCQ valid on the gas day (caller keeps the GTA's own limits)
 */
const resolveGsaLimits = async (GMSCONFIRMNOM_SRV, aPairs, fetchJoinRows) => {
  const mOut = new Map();
  const sLegs = new Set();
  for (const p of aPairs)
    for (const r of [p.dp, p.rdp]) if (r.LinkContexist === 'X' && r.ContractNo) sLegs.add(String(r.ContractNo).trim());
  if (!sLegs.size) return mOut;

  const aJoin = await fetchJoinRows(GMSCONFIRMNOM_SRV, [...sLegs], 'Contract_NO');
  const mLegToGsa = new Map();
  for (const jr of aJoin) {
    if (jr.linkcont_flag !== 'X') continue;
    const con = normDoc(jr.Contract_NO), gsa = normDoc(jr.LINKCONT);
    if (con && gsa && !mLegToGsa.has(con)) mLegToGsa.set(con, gsa);
  }
  const mPairGsa = new Map();
  for (const p of aPairs) {
    const gsa = mLegToGsa.get(normDoc(p.dp.ContractNo)) || mLegToGsa.get(normDoc(p.rdp.ContractNo));
    if (gsa) mPairGsa.set(p, gsa);
  }
  if (!mPairGsa.size) return mOut;

  const mMaster = await _fetchGsaMaster([...new Set(mPairGsa.values())]);
  for (const [p, gsa] of mPairGsa) {
    const m = mMaster.get(gsa);
    if (!m || String(m.DocumentType || '').trim().toUpperCase() !== GSA_CONTRACT_TYPE) continue;
    const sLinked = (m.to_contractcf || []).find(c => c.ContractFieldId === SSP_LINKED_FUNCTIONALITY)?.FieldValue;
    if (String(sLinked || '').trim().toUpperCase() !== 'UNBUNDLED') continue;

    const aDq = (m.to_contractdq || []).filter(d => _validOn(d, p.gasday));
    const sRdp = String(p.rdp.RedeliveryPoint || '').trim();
    const aAtRdp = aDq.filter(d => String(d.RedeliveryPoint || '').trim() === sRdp);
    const dcq = r3((aAtRdp.length ? aAtRdp : aDq).reduce((t, d) => t + num(d.RedeliveryDcq), 0));
    const per = id => {
      const c = (m.to_contractcl || []).find(x => x.QuantityParamId === id && _validOn(x, p.gasday));
      return c ? num(c.ThresholdPer) : null;
    };
    const minPer = per(SSP_MIN_RDP_DCQ), maxPer = per(SSP_MAX_RDP_DCQ);
    mOut.set(p, {
      gsa, ok: dcq > 0, dcq, minPer, maxPer,
      dpLinked: mLegToGsa.get(normDoc(p.dp.ContractNo)) === gsa,
      rdpLinked: mLegToGsa.get(normDoc(p.rdp.ContractNo)) === gsa,
      // A missing threshold means no limit on that side (normLimits: min 0 / max 0 = none).
      min: minPer == null ? 0 : r3(dcq * minPer / 100),
      max: maxPer == null ? 0 : r3(dcq * maxPer / 100),
      reason: dcq > 0 ? '' : `no DCQ valid on ${p.gasday}`
    });
  }
  return mOut;
};

/**
 * Effective limits for one pair — DP from the Delivery leg's own fields, RDP
 * through the same Master Contract fallback ARI004 uses (a clubbed subcontract
 * with zero Min/Max takes its Primary Contract's). Unbundled CT: a leg linked
 * to the GSA uses the GSA's limits instead.
 * @param {{dp:object, rdp:object}} pair
 * @param {Map<string,object>} mPools - from resolveMasterContractPools
 * @param {Map<object,object>} [mGsaLimits] - from resolveGsaLimits
 */
const pairLimits = (pair, mPools, mGsaLimits) => {
  const { dp, rdp } = pair;
  const { effectiveMin, effectiveMax } = resolveEffectiveRedeliveryDCQ(rdp, mPools || new Map());
  const oGsa = mGsaLimits?.get(pair);
  const bDp = !!(oGsa?.ok && oGsa.dpLinked), bRdp = !!(oGsa?.ok && oGsa.rdpLinked);
  return {
    dpMin: bDp ? oGsa.min : dp.MinDeliveryDCQ,
    dpMax: bDp ? oGsa.max : dp.MaxDeliveryDCQ,
    rdpMin: bRdp ? oGsa.min : effectiveMin,
    rdpMax: bRdp ? oGsa.max : effectiveMax,
    dpClamp: bDp, rdpClamp: bRdp
  };
};

module.exports = {
  GTA_CONTRACT_TYPE, GSA_CONTRACT_TYPE, isGtaContract, isDcqLimitRule,
  computeRightToCure, fetchGtaContextRows, resolveGtaPairs, resolveGsaLimits, pairLimits
};
