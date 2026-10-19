const cds = require('@sap/cds');
const crypto = require('crypto');
const { logError } = require('../utils/s4Logger');
const {
  fetchAllPaged, splitArr
} = require('../utils/nomSourceFetch');
const { fetchLinkJoinRows, clearNomSourceCache } = require('./balancingScheduling-service');
// The Allocation & Ticketing tile's handlers now live in ./allocationTicketing/ —
// this require is only for the shared cache singleton, which Nomination Confirmation
// (confirmNominationSelected below) still invalidates on every confirm.
const nomCache = require('./allocationTicketing/nomCache');
// Single source of truth for ARI004 evaluation + Master Contract DCQ clubbing —
// shared with the xGMSxNOMSOURCE READ (balancingScheduling-service.js), which
// projects a "what will be approved" preview using the exact same functions.
const {
  fetchARI004Rules, evaluateRowARI004, applyCap,
  resolveMasterContractPools, applyMasterContractDCQClubbing,
  toDateTime, fmt3, dateKey, isTrue
} = require('../utils/ari004Rules');
// GTA (ZGT1) Right-to-Cure-Imbalance — sets the posted ProposedDnq on both legs of a GTA
// pair; owns Min/Max DCQ limiting for those rows in place of ARI004.
const {
  isDcqLimitRule, computeRightToCure, fetchGtaContextRows, resolveGtaPairs, resolveGsaLimits, pairLimits
} = require('../utils/gtaRightToCure');

// ── Confirm Nomination — unified selected-rows job (any size) ───────────────
// Job state lives in an in-memory Map — safe only while this module runs at
// instances:1 (see mta.yaml). Revisit with a persisted store before any
// horizontal scale-out, since a status poll could otherwise land on an
// instance that never ran the job.
const _confirmJobs = new Map();       // jobId → status object
const JOB_TTL_MS = 2 * 60 * 60 * 1000; // evict completed jobs after 2h
const SAMPLE_MAX = 50;                 // cap per-category sample arrays kept per job

/** Sweeps completed jobs older than JOB_TTL_MS — bounds Map growth over time. */
const _evictOldConfirmJobs = () => {
  const now = Date.now();
  for (const [id, job] of _confirmJobs) {
    if (job.completedAt && (now - job.completedAt.getTime()) > JOB_TTL_MS) {
      _confirmJobs.delete(id);
    }
  }
};

/** Merges a partial update into a job's status object. */
const _setJobStatus = (jobId, patch) => {
  const job = _confirmJobs.get(jobId);
  if (job) Object.assign(job, patch);
};

/** Pushes a sample onto arr only while under SAMPLE_MAX — keeps job payload small. */
const _pushSample = (arr, sample) => { if (arr.length < SAMPLE_MAX) arr.push(sample); };

// ── Ticket Logs — per-ticket reference fields ─────────────────────────────────
const TICKET_LOG_VIRTUAL_FIELDS = ['TicketKey', 'TicketItem', 'Nomtk', 'Nomit'];

/**
 * Fills ticketLogs rows (execution-level, TktlogDetailHeadSet) in place with
 * TicketKey/TicketItem/Nomtk/Nomit from their own expanded to_logtkts
 * (TktlogDetailSet) lines, then drops to_logtkts from the row. One execution can
 * carry several lines ([Final]/[Summary]/[Result] outcome lines, some with a
 * blank TicketKey) — the first line (by Logitm) that has a TicketKey is used,
 * falling back to the first line when none does.
 */
const _fillTicketRefsFromLogLines = aLogs => {
  for (const row of aLogs) {
    const aLines = (row.to_logtkts || []).slice()
      .sort((a, b) => String(a.Logitm).localeCompare(String(b.Logitm)));
    const t = aLines.find(l => l.TicketKey && /[1-9]/.test(l.TicketKey)) || aLines[0];
    row.TicketKey = t?.TicketKey || '';
    row.TicketItem = t?.TicketItem || '';
    row.Nomtk = t?.Nomtk || '';
    row.Nomit = t?.Nomit || '';
    delete row.to_logtkts;
  }
};

// Keys are ALPHA-padded digit strings — compared numerically; blanks sort last.
const _compareKeys = (a, b) => {
  if (!a || !b) return (a ? 0 : 1) - (b ? 0 : 1);
  return String(a).localeCompare(String(b), undefined, { numeric: true });
};

// ── Ticket Logs column filters ────────────────────────────────────────────────
// Same labels as ticketLogs.controller.js formatStatusText — what the user sees and types.
const TICKET_LOG_STATUS_TEXT = { S: 'Success', E: 'Error', W: 'Warning', P: 'Partial', N: 'Not Completed' };

/** Unwraps tolower()/toupper() around a ref or val — case never matters for these fields. */
const _cqnBase = t => (t?.func && /^to(lower|upper)$/i.test(t.func) ? _cqnBase(t.args?.[0]) : t);

/** ExecStatus codes whose label (or code) the typed text matches under the given operator. */
const _statusCodesFor = (sOp, sTyped) => {
  const s = String(sTyped ?? '').trim().toLowerCase();
  if (TICKET_LOG_STATUS_TEXT[s.toUpperCase()]) return [s.toUpperCase()]; // typed the code itself
  const fMatch = {
    contains: t => t.includes(s), startswith: t => t.startsWith(s),
    endswith: t => t.endsWith(s), '=': t => t === s
  }[sOp];
  return fMatch ? Object.keys(TICKET_LOG_STATUS_TEXT).filter(c => fMatch(TICKET_LOG_STATUS_TEXT[c].toLowerCase())) : null;
};

/** ExecStatus = code OR … as a CQN xpr; no match → an impossible code, i.e. no rows.
 *  Flagged _local: sent to Gateway (ANDed with the Status checkbox OR-group), this
 *  returned only 1 of several 'S' rows — so it is evaluated in memory instead, like
 *  the virtual fields. */
const _statusXpr = aCodes => ({
  _local: true,
  xpr: (aCodes.length ? aCodes : ['#']).flatMap((c, i) =>
    [...(i ? ['or'] : []), { ref: ['ExecStatus'] }, '=', { val: c }])
});

/**
 * The Status column shows labels ("Error"), but ExecStatus holds codes ("E") —
 * rewrites column-filter conditions on it (contains/startswith/endswith/=, typed as
 * label or code) into ExecStatus = code conditions, applied in memory (_statusXpr).
 * A plain code/placeholder equality (the Status checkbox filter) is left as is for
 * Gateway. Recurses into xprs.
 */
const _rewriteStatusFilter = aTokens => {
  if (!Array.isArray(aTokens)) return aTokens;
  const aOut = [];
  for (let i = 0; i < aTokens.length; i++) {
    const t = aTokens[i];
    if (t?.xpr) { aOut.push({ ...t, xpr: _rewriteStatusFilter(t.xpr) }); continue; }
    if (t?.func && _cqnBase(t.args?.[0])?.ref?.[0] === 'ExecStatus') {
      const aCodes = _statusCodesFor(t.func.toLowerCase(), _cqnBase(t.args[1])?.val);
      aOut.push(aCodes ? _statusXpr(aCodes) : t);
      continue;
    }
    const vEq = aTokens[i + 1] === '=' ? _cqnBase(aTokens[i + 2])?.val : undefined;
    if (_cqnBase(t)?.ref?.[0] === 'ExecStatus' && vEq !== undefined &&
        !TICKET_LOG_STATUS_TEXT[vEq] && vEq !== '__NONE__') {
      aOut.push(_statusXpr(_statusCodesFor('=', vEq)));
      i += 2;
      continue;
    }
    aOut.push(t);
  }
  return aOut;
};

/** True for a condition that must run in memory — on a virtual field, or a _local Status one. */
const _hasVirtualRef = t => Array.isArray(t)
  ? t.some(_hasVirtualRef)
  : !!t && typeof t === 'object' &&
    (t._local || (t.ref && TICKET_LOG_VIRTUAL_FIELDS.includes(t.ref[0])) || _hasVirtualRef(t.xpr) || _hasVirtualRef(t.args));

/** Splits a CQN where into its top-level AND conjuncts (nested and-only xprs flattened). */
const _whereConjuncts = aTokens => {
  if (!aTokens?.length) return [];
  if (aTokens.includes('or')) return [aTokens];
  const aSegs = [[]];
  aTokens.forEach(t => (t === 'and' ? aSegs.push([]) : aSegs[aSegs.length - 1].push(t)));
  // A _local xpr stays whole — flattening it would lose the flag.
  return aSegs.flatMap(s => (s.length === 1 && s[0].xpr && !s[0]._local ? _whereConjuncts(s[0].xpr) : [s]));
};

/** Key text for matching — no ALPHA padding, so "71906" matches "00000000000000071906". */
const _keyText = v => String(v ?? '').trim().replace(/^0+(?=\d)/, '').toLowerCase();

const _cqnValue = (t, row) => {
  const b = _cqnBase(t);
  if (b?.ref) return row[b.ref[0]];
  if (b?.val !== undefined) return b.val;
  if (b?.xpr) return _evalCqn(b.xpr, row);
  if (b?.func) return _evalCqnFunc(b, row);
  return undefined;
};

const _evalCqnFunc = (f, row) => {
  const [a, b] = (f.args || []).map(x => _keyText(_cqnValue(x, row)));
  switch (f.func.toLowerCase()) {
    case 'contains': return a.includes(b);
    case 'startswith': return a.startsWith(b);
    case 'endswith': return a.endsWith(b);
    default: return true; // unsupported — never hide rows over it
  }
};

const _evalCqnAtom = (aTokens, row) => {
  if (aTokens[0] === 'not') return !_evalCqnAtom(aTokens.slice(1), row);
  if (aTokens.length === 1) return !!_cqnValue(aTokens[0], row);
  const [l, op, r] = aTokens;
  const v = _cqnValue(l, row);
  if (op === 'is') return (r === 'not') === (v != null && v !== '');
  const c = String(_keyText(v)).localeCompare(_keyText(_cqnValue(r, row)), undefined, { numeric: true });
  switch (op) {
    case '=': return c === 0;
    case '!=': case '<>': return c !== 0;
    case '<': return c < 0;
    case '>': return c > 0;
    case '<=': return c <= 0;
    case '>=': return c >= 0;
    default: return true;
  }
};

/** Evaluates a CQN where token list against one row: or-groups of and-chains of atoms. */
const _evalCqn = (aTokens, row) => {
  const aOr = [[]];
  aTokens.forEach(t => (t === 'or' ? aOr.push([]) : aOr[aOr.length - 1].push(t)));
  return aOr.some(aPart => {
    const aAnd = [[]];
    aPart.forEach(t => (t === 'and' ? aAnd.push([]) : aAnd[aAnd.length - 1].push(t)));
    return aAnd.every(a => _evalCqnAtom(a, row));
  });
};

/** One ticketLogs field compared ascending — ExecDate as a date, the rest via _compareKeys. */
const _compareTicketLogField = (f, a, b) => {
  if (f !== 'ExecDate') return _compareKeys(a[f], b[f]);
  const x = a.ExecDate ? new Date(a.ExecDate).getTime() : NaN;
  const y = b.ExecDate ? new Date(b.ExecDate).getTime() : NaN;
  if (isNaN(x) || isNaN(y)) return (isNaN(x) ? 1 : 0) - (isNaN(y) ? 1 : 0);
  return x - y;
};

/** Row comparator for a ticketLogs CQN orderBy. Blanks stay last in either direction;
 *  ExecTime follows ExecDate's direction when not sorted on explicitly; ExecDate desc /
 *  ExecTime desc is the final tie-break. */
const _ticketLogComparator = aOrderBy => {
  const aSorts = aOrderBy.filter(o => o.ref?.[0]).map(o => ({ f: o.ref[0], desc: o.sort === 'desc' }));
  const oDate = aSorts.find(s => s.f === 'ExecDate');
  if (oDate && !aSorts.some(s => s.f === 'ExecTime')) {
    aSorts.splice(aSorts.indexOf(oDate) + 1, 0, { f: 'ExecTime', desc: oDate.desc });
  }
  aSorts.push({ f: 'ExecDate', desc: true }, { f: 'ExecTime', desc: true });
  return (a, b) => {
    for (const { f, desc } of aSorts) {
      const c = _compareTicketLogField(f, a, b);
      const bBlank = f === 'ExecDate' ? (!a.ExecDate || !b.ExecDate) : (!a[f] || !b[f]);
      if (c) return desc && !bBlank ? -c : c;
    }
    return 0;
  };
};

// Composite row identity used throughout this module — Gasday is always
// date-normalized via dateKey() since S/4 can return a full datetime; matches
// the pipe-delimited 'Gasday|ContractNo|Item|Versn|NominationItem' convention
// the frontend already sends in SelectedKeys.
const _rowKeyBE = row => `${dateKey(row.Gasday)}|${row.ContractNo}|${row.Item}|${row.Versn}|${row.NominationItem}`;

// ── Same-row concurrency guard ────────────────────────────────────────────
// A row must never be posted to S/4 by two overlapping requests at once — two
// users (or two tabs) confirming an overlapping selection could otherwise both
// attempt to post the same row. Claiming happens in one synchronous loop (no
// `await` inside it) immediately before the posting loop starts — Node's
// single-threaded execution makes this race-free without a distributed lock,
// the same way this module already depends on instances:1 for bnsCache/nomCache.
// Release is per-row, in a `finally` around each individual POST (posting is
// one row at a time, so a claim is only ever held for that one row's own S/4
// round trip, not the whole job).
const _claimedRowKeys = new Map();    // row key → { jobId, claimedAt }
const CLAIM_TTL_MS = 5 * 60 * 1000;   // abandoned-claim safety valve — defense in depth

/** Synchronously claims every row in aRows not already held by another job. */
const _claimRows = (aRows, jobId) => {
  const now = Date.now();
  const aClaimed = [];
  const aLocked = [];
  for (const row of aRows) {
    const key = _rowKeyBE(row);
    const existing = _claimedRowKeys.get(key);
    if (existing && (now - existing.claimedAt) < CLAIM_TTL_MS) {
      aLocked.push(row);
      continue;
    }
    _claimedRowKeys.set(key, { jobId, claimedAt: now });
    aClaimed.push(row);
  }
  return { aClaimed, aLocked };
};

/** Releases one row's claim — always called from a finally around its POST. */
const _releaseRowClaim = row => _claimedRowKeys.delete(_rowKeyBE(row));

/**
 * Builds the nom_configSet array required by every Conf_nomiSet deep-insert,
 * derived from the nominationConfiguration reference table.
 */
const _buildNomConfigSet = async (igmsConfigMetaData) => {
  const fetchNominationConfig = await igmsConfigMetaData.run(SELECT.from('nominationConfiguration'));
  return fetchNominationConfig.map(cfg => ({
    Docind: cfg.RDICode,
    Doctype: cfg.DocType,
    nomtype: cfg.NominationType,
    schtype: cfg.ScheduleType,
    OL_OC: cfg.OCustONom
  }));
};

/**
 * Builds one GmsConfNomiNav entry from a fetched xGMSxNOMSOURCE row, applying
 * any ARI004 cap recorded for its ContractNo.
 * @param {object} row
 * @param {Map<string,object>} capMap - ContractNo → { ProposedDNQ: cappedVal, ... }
 * @param {Map<string,number>} [clubMap] - '{dateKey}|{ContractNo}' → Master
 *   Contract DCQ-clubbing override for ProposedDnq (see ari004Rules.js's
 *   applyMasterContractDCQClubbing). Takes precedence over the ARI004 cap —
 *   it's computed from the same effective pool limit but with the correct
 *   pro-rata split for this scenario.
 */
const _buildNavItemBE = (row, capMap, clubMap) => {
  const cap = capMap.get(String(row.ContractNo)) || {};
  const clubbedProposed = clubMap?.get(`${dateKey(row.Gasday)}|${String(row.ContractNo)}`);
  return {
    Gasday: toDateTime(row.Gasday),
    ContractNo: row.ContractNo ?? '',
    Item: row.Item ?? '',
    NominationItem: row.NominationItem ?? '',
    Zstat: '',
    Versn: row.Versn ?? '000',
    Mastercontno: row.MasterContractNo ?? '',
    DeliveryPoint: row.DeliveryPoint ?? '',
    RedelivryPoint: row.RedeliveryPoint ?? '',
    SoldToParty: row.Partner ?? '',
    Vendor: '',
    ValidTo: 'PT06H00M00S',
    ValidFrom: 'PT06H00M00S',
    Material: row.Material ?? '',
    Timestamp: null,
    NominationKey: row.NominationKey ?? '',
    DeliveryDcq: fmt3(row.DeliveryDCQ),
    RedeliveryDcq: fmt3(row.RedeliveryDCQ),
    Uom: row.UOM ?? '',
    ProposedDnq: fmt3(clubbedProposed ?? cap.ProposedDNQ ?? row.ProposedDNQ),
    Event: row.Event ?? '',
    ApprovedDnq: fmt3(row.ApprovedDNQ),
    RepublishDnq: '0.000',
    TransportSystem: row.TransportSystem ?? '',
    to_Return: []
  };
};

/**
 * Resolves LinkContexist='X' rows against the FINAL set of nav items about to
 * be posted (mByContractNav). Fully automatic — no interactive dialog: when
 * the LINKCONT source isn't resolvable automatically, the pair is blocked and
 * reported as pending rather than guessed or prompted for.
 *
 * Keyed by (Gasday, ContractNo) throughout — never ContractNo alone — since a
 * selected-rows confirm can span multiple Gasdays and the same ContractNo can
 * legitimately recur across multiple days with different DNQ/confirm state
 * each day. The LINKCONT JOIN (con→src) is day-independent master data, but
 * every row/nav lookup keyed off it pins the flagged row's own Gasday so a
 * multi-day batch never mixes one day's value into another.
 *
 * Per flagged row (ContractNo=con, LinkContexist='X', CorrespondingDocNo=doc):
 *   - source (LINKCONT) already in mByContractNav for the same Gasday → copy
 *     its own (capped) ProposedDnq into doc's DeliveryPoint-side nav.
 *   - source not in payload, isConfirmRequired=false (already confirmed in
 *     S/4 for that Gasday) → copy its ScheduledQty into doc's nav.
 *   - source not in payload, isConfirmRequired=true (or not found) → nothing
 *     copied; doc keeps its own ProposedDnq and the pair is still posted (the
 *     former "Confirm First" block is skipped, so blockedContracts stays empty).
 *
 * @param {object[]} aRowCtx - rows carrying Gasday/ContractNo/LinkContexist/CorrespondingDocNo
 * @param {Map<string,object[]>} mByContractNav - '{dateKey}|{ContractNo}' → nav item(s) in the final payload
 * @param {(gasday:string,contractNo:string)=>Promise<object|null>} fetchSourceRow - fresh S/4 lookup, {isConfirmRequired, ScheduledQty}
 * @param {import('@sap/cds').Service} GMSCONFIRMNOM_SRV
 * @returns {Promise<{ blockedContracts: Set<string>, pendingSamples: {ContractNo:string,Message:string}[] }>}
 */
const _resolveLinkedContractCopies = async (aRowCtx, mByContractNav, fetchSourceRow, GMSCONFIRMNOM_SRV) => {
  const blockedContracts = new Set();
  const pendingSamples = [];

  const aFlagged = aRowCtx
    .filter(r => r.LinkContexist === 'X')
    .map(r => ({
      con: String(r.ContractNo ?? ''),
      doc: String(r.CorrespondingDocNo ?? '').trim(),
      gasday: dateKey(r.Gasday)
    }))
    .filter(o => o.con && o.doc && o.gasday);
  if (!aFlagged.length) return { blockedContracts, pendingSamples };

  const sFlaggedContracts = [...new Set(aFlagged.map(o => o.con))];
  const aJoinRows = await fetchLinkJoinRows(GMSCONFIRMNOM_SRV, sFlaggedContracts, 'Contract_NO');
  const mFlaggedToSource = new Map();
  for (const jr of aJoinRows) {
    if (jr.linkcont_flag !== 'X') continue;
    const con = String(jr.Contract_NO ?? '').trim();
    const src = String(jr.LINKCONT ?? '').trim();
    if (con && src) mFlaggedToSource.set(con, src);
  }

  for (const { con, doc, gasday } of aFlagged) {
    const src = mFlaggedToSource.get(con);
    if (!src) continue;   // JOIN has no record for this contract — nothing to resolve

    const sDocKey = `${gasday}|${doc}`;
    const aTargetNav = mByContractNav.get(sDocKey);
    if (!aTargetNav?.length) continue;   // target not part of this payload — nothing to apply

    // Case A — source already in the same final payload, same Gasday: use its own (capped) ProposedDnq
    const aSourceNav = mByContractNav.get(`${gasday}|${src}`);
    if (aSourceNav?.length) {
      const sDNQ = aSourceNav[0].ProposedDnq;
      aTargetNav.forEach(nav => { if (nav.DeliveryPoint) nav.ProposedDnq = sDNQ; });
      continue;
    }

    // Case B — source not in payload for this Gasday: copy only once it is confirmed in S/4.
    // "Confirm First" validation is skipped — an unconfirmed/missing source no longer blocks
    // the pair; the target is posted with its own ProposedDnq, nothing copied.
    const oSource = await fetchSourceRow(gasday, src);
    if (!oSource || isTrue(oSource.isConfirmRequired)) continue;

    const sDNQ = parseFloat(oSource.ScheduledQty ?? 0).toFixed(3);
    aTargetNav.forEach(nav => { if (nav.DeliveryPoint) nav.ProposedDnq = sDNQ; });
  }

  return { blockedContracts, pendingSamples };
};

/**
 * Extracts {ContractNo, Type, Message} from S/4's Conf_nomiSet response —
 * same shape/field names as the CSN controller's _extractReturnMessages.
 * @param {object} oResult - response body from the Conf_nomiSet POST
 * @returns {{ContractNo:string,Type:string,Message:string}[]}
 */
const _extractReturnMessagesBE = (oResult) => {
  const aMsg = [];
  for (const oNav of (oResult?.GmsConfNomiNav ?? [])) {
    for (const oRet of (oNav?.to_Return ?? [])) {
      if (!oRet.Message) continue;
      aMsg.push({ ContractNo: oNav.ContractNo ?? '', Type: oRet.Type ?? '', Message: oRet.Message });
    }
  }
  return aMsg;
};

/**
 * Resolves the client's SelectedKeys fresh from S4 (never the client's own
 * cached row data, for correctness) — constrained by the selection's Gasday
 * range and distinct ContractNo list (a real IN-filter, avoiding a fragile
 * giant composite-key OR-filter) — then filters down in JS via a Set to
 * exactly the requested (Gasday, ContractNo, Item, Versn, NominationItem)
 * tuples. Deliberately skips the CorrespondingDocNo display-parity merge the
 * table READ does — not needed here since the client's own
 * onRowSelectionChange link-chain logic already guarantees paired/sibling rows
 * are part of the selection.
 * @param {{gasday:string,contractNo:string,item:string,versn:string,nominationItem:string}[]} aSelectedKeys
 * @param {import('@sap/cds').Service} GMSCONFIRMNOM_SRV
 * @returns {Promise<{aResolved:object[], aEligible:object[], staleSkippedItems:number, sFoundKeys:Set<string>}>}
 */
const _resolveSelectedEligibleRows = async (aSelectedKeys, GMSCONFIRMNOM_SRV) => {
  const aGasdays = aSelectedKeys.map(k => k.gasday).filter(Boolean).sort();
  const sGasdayFrom = aGasdays[0];
  const sGasdayTo = aGasdays[aGasdays.length - 1];
  const aContractNos = [...new Set(aSelectedKeys.map(k => k.contractNo))];

  const q = SELECT.from('xGMSxNOMSOURCE')
    .where`Gasday >= ${sGasdayFrom} and Gasday <= ${sGasdayTo}`;
  q.where({ ContractNo: { in: aContractNos } });

  const aAllRows = await fetchAllPaged(GMSCONFIRMNOM_SRV, q);

  const sRequested = new Set(aSelectedKeys.map(k =>
    `${k.gasday}|${k.contractNo}|${k.item}|${k.versn}|${k.nominationItem}`
  ));

  const sFoundKeys = new Set();
  const aResolved = [];
  for (const row of aAllRows) {
    const key = _rowKeyBE(row);
    if (!sRequested.has(key)) continue;
    sFoundKeys.add(key);
    aResolved.push(row);
  }

  // Rows no longer confirm-required (already confirmed elsewhere) or not found
  // at all on this fresh re-fetch are both "stale" — the caller reports them
  // as staleSkippedItems rather than silently dropping or erroring the batch.
  const aEligible = aResolved.filter(row => isTrue(row.isConfirmRequired));
  const staleSkippedItems = aSelectedKeys.length - aEligible.length;

  return { aResolved, aEligible, staleSkippedItems, sFoundKeys };
};

/**
 * Processes an already-resolved eligible row set for confirmNominationSelected:
 * applies ARI004 capping, resolves LinkContexist='X' pairs against the FINAL
 * post-ARI004 nav set (via _resolveLinkedContractCopies — auto-copies when
 * resolvable, blocks the {flagged, target} pair otherwise), claims each row
 * against concurrent duplicate posting (see _claimRows), and posts to S4 ONE
 * ROW PER CALL, strictly sequential — S/4 TSW does not support parallel
 * nomination creation, and even if it did, one HTTP response per call is the
 * only granularity CAP can observe mid-job, so per-row status can never be
 * genuinely live at any coarser POST size. Job status updates after every
 * single row so getConfirmNominationJobStatus reflects real progress, never a
 * batch-sized jump. Rows are still iterated in Gasday+Location+Partner order
 * (the grouping originally requested) — that's posting ORDER now, not a
 * batching unit; every row is its own individual call regardless of group.
 * Always run via cds.spawn (see the handler below) — no inline/sync fast
 * path, so the caller always gets a jobId to poll and the progress dialog
 * always has something real to show, regardless of selection size.
 */
const _processConfirmSelectedRows = async (jobId, aResolved, aEligible, igmsConfigMetaData, GMSCONFIRMNOM_SRV, log, tStart) => {
  const totalContracts = new Set(aEligible.map(r => String(r.ContractNo))).size;
  const sProcessedContracts = new Set();
  _setJobStatus(jobId, { status: 'RUNNING', totalItems: aEligible.length, totalContracts });

  try {
    if (!aEligible.length) {
      _setJobStatus(jobId, { status: 'COMPLETED', completedAt: new Date() });
      return;
    }

    // ── Master Contract DCQ pools (RDP-side) — resolved BEFORE ARI004 so a
    // clubbed subcontract's always-zero Min/MaxRedeliveryDCQ never reaches the
    // rule engine directly; see resolveEffectiveRedeliveryDCQ.
    const mMasterContractPools = await resolveMasterContractPools(aEligible, GMSCONFIRMNOM_SRV);

    // ── ARI004 — evaluate + cap server-side, once, before building any payload ──
    // Not date-filtered here — a selected-rows confirm can span multiple
    // Gasdays, so each row is checked against its OWN Gasday inside evaluateRowARI004.
    const aParsedRules = await fetchARI004Rules(igmsConfigMetaData);

    // ── GTA pairs — resolved before ARI004 so their legs skip ARI004's Min/Max
    // DCQ rules (Right to Cure must see each leg's uncapped demand). The partner
    // leg is fetched even when not selected; its own Master Contract pool is
    // resolved separately so it never feeds the clubbing step below.
    const aGtaContext = await fetchGtaContextRows(GMSCONFIRMNOM_SRV, aEligible);
    const { pairs: aGtaPairs, skipped: aGtaSkipped } = resolveGtaPairs(aEligible, aGtaContext);
    const sGtaRowKeys = new Set(aGtaPairs.flatMap(p => [_rowKeyBE(p.dp), _rowKeyBE(p.rdp)]));
    const mGtaPools = aGtaPairs.length
      ? await resolveMasterContractPools(aGtaPairs.map(p => p.rdp), GMSCONFIRMNOM_SRV)
      : new Map();
    // Unbundled CT — a GTA linked to a GSA takes the GSA's DCQ & limits as its DP limits.
    const mGsaLimits = await resolveGsaLimits(GMSCONFIRMNOM_SRV, aGtaPairs, fetchLinkJoinRows);
    const aRulesNoDcq = aParsedRules.filter(rule => !isDcqLimitRule(rule));
    log.info(`[confirmNominationSelected] jobId=${jobId} GTA right-to-cure — pairs=${aGtaPairs.length} ` +
      `skipped=${aGtaSkipped.length} unbundled=${[...mGsaLimits.values()].filter(o => o.ok).length}`);

    const capMap = new Map();
    const aConfirmable = [];
    let rejectedItems = 0;
    let cappedItems = 0;
    const rejectedSamples = [];
    const cappedSamples = [];

    for (const row of aEligible) {
      const aRowRules = sGtaRowKeys.has(_rowKeyBE(row)) ? aRulesNoDcq : aParsedRules;
      const { rejected, messages, caps } = aRowRules.length
        ? evaluateRowARI004(row, aRowRules, mMasterContractPools)
        : { rejected: false, messages: [], caps: [] };

      if (rejected) {
        rejectedItems++;
        sProcessedContracts.add(String(row.ContractNo ?? ''));
        _pushSample(rejectedSamples, { ContractNo: row.ContractNo ?? '', Message: messages.join('; ') });
        continue;
      }
      if (caps.length) {
        cappedItems++;
        caps.forEach(c => {
          applyCap(capMap, row.ContractNo, c.field, c.value, c.operator);
          _pushSample(cappedSamples, {
            ContractNo: row.ContractNo ?? '',
            Message: `${c.field} capped to ${fmt3(c.value)} by rule ${c.ruleID}`
          });
        });
      }
      aConfirmable.push(row);
    }

    _setJobStatus(jobId, {
      rejectedItems, cappedItems, rejectedSamples, cappedSamples,
      processedItems: rejectedItems, processedContracts: sProcessedContracts.size
    });

    // ── Master Contract DCQ clubbing (RDP-side) — reuses the pools already
    // resolved above; no further S/4 round trip.
    const mClubbedProposed = applyMasterContractDCQClubbing(aConfirmable, mMasterContractPools);
    // GTA legs keep their own demand as ProposedDnq — Right to Cure decides their quantity.
    for (const p of aGtaPairs) {
      for (const r of [p.dp, p.rdp]) mClubbedProposed.delete(`${dateKey(r.Gasday)}|${String(r.ContractNo)}`);
    }
    // ── GTA partner legs outside the selection — a pair is usually confirmed by
    // selecting just one leg, but S/4's GTA auto-processing then confirms the
    // other leg at its stored, uncured ProposedDNQ (DP scheduled = DP demand on
    // every breach scenario). Pull a still-confirm-required partner into the
    // payload so both legs post together with their cured quantities. Added
    // after clubbing so an unselected leg never shifts the clubbing split.
    const sEligibleKeys = new Set(aEligible.map(_rowKeyBE));
    let gtaPartnerItems = 0;
    for (const p of aGtaPairs) {
      for (const r of [p.dp, p.rdp]) {
        if (sEligibleKeys.has(_rowKeyBE(r)) || !isTrue(r.isConfirmRequired)) continue;
        const { rejected, caps } = aRulesNoDcq.length
          ? evaluateRowARI004(r, aRulesNoDcq, mGtaPools)
          : { rejected: false, caps: [] };
        if (rejected) continue; // left to the generic path, as before
        caps.forEach(c => applyCap(capMap, r.ContractNo, c.field, c.value, c.operator));
        aConfirmable.push(r);
        sEligibleKeys.add(_rowKeyBE(r));
        gtaPartnerItems++;
      }
    }
    if (gtaPartnerItems) {
      _setJobStatus(jobId, {
        totalItems: aEligible.length + gtaPartnerItems,
        totalContracts: new Set([...aEligible, ...aConfirmable].map(r => String(r.ContractNo))).size
      });
      log.info(`[confirmNominationSelected] jobId=${jobId} GTA right-to-cure — added ${gtaPartnerItems} unselected partner leg(s)`);
    }

    // ── LinkContexist='X' resolution — against the FINAL (post-ARI004) nav set ──
    // A row dropped by ARI004 rejection above no longer counts as "in the payload"
    // for this check, so build the nav items first and resolve against that index.
    // Keyed by (Gasday, ContractNo) — a selected-rows confirm can span multiple
    // days, so the same ContractNo can recur on multiple days with different
    // DNQ/confirm state; keying off the source row's own raw Gasday (not the
    // nav's transformed one) keeps this index trivially consistent with
    // aResolved's row-context keys.
    const aAllNavPairs = aConfirmable.map(r => {
      const nav = 
      _buildNavItemBE(r, capMap, mClubbedProposed);
      return { key: `${dateKey(r.Gasday)}|${String(r.ContractNo)}`, nav };
    });
    const mByContractNav = new Map();
    aAllNavPairs.forEach(({ key, nav }) => {
      let a = mByContractNav.get(key);
      if (!a) mByContractNav.set(key, a = []);
      a.push(nav);
    });

    const mResolvedByContract = new Map();
    for (const r of aResolved) {
      const k = `${dateKey(r.Gasday)}|${String(r.ContractNo)}`;
      if (!mResolvedByContract.has(k)) mResolvedByContract.set(k, r);
    }
    const mFetchedSourceCache = new Map();
    const fetchSourceRow = async (gasday, contractNo) => {
      const k = `${gasday}|${contractNo}`;
      if (mResolvedByContract.has(k)) return mResolvedByContract.get(k);
      if (mFetchedSourceCache.has(k)) return mFetchedSourceCache.get(k);
      const aRows = await fetchAllPaged(GMSCONFIRMNOM_SRV,
        SELECT.from('xGMSxNOMSOURCE').where`Gasday = ${gasday} and ContractNo = ${contractNo}`
      );
      const oRow = aRows[0] || null;
      mFetchedSourceCache.set(k, oRow);
      return oRow;
    };

    const { blockedContracts, pendingSamples: linkedPendingSamples } =
      await _resolveLinkedContractCopies(aResolved, mByContractNav, fetchSourceRow, GMSCONFIRMNOM_SRV);

    // ── GTA Right to Cure — after linked-contract copies, so a Delivery leg whose
    // ProposedDnq was just replaced by its LINKCONT source uses that as its demand.
    // A leg outside this payload (unselected or already confirmed) still supplies
    // its demand from its own row; only legs in the payload get their ProposedDnq
    // replaced — S/4 confirms ProposedDnq (ARI004 capping/clubbing/LINKCONT all
    // adjust that same field), ApprovedDnq is only passed through.
    let rtcItems = 0;
    const rtcSamples = [...aGtaSkipped];
    const mNavByRowKey = new Map(aAllNavPairs.map(({ nav }) => [_rowKeyBE(nav), nav]));
    for (const pair of aGtaPairs) {
      const oDpNav = mNavByRowKey.get(_rowKeyBE(pair.dp));
      const oRdpNav = mNavByRowKey.get(_rowKeyBE(pair.rdp));
      if (!oDpNav && !oRdpNav) continue; // both legs rejected by ARI004 — nothing to post
      const fDpDemand = oDpNav ? oDpNav.ProposedDnq : pair.dp.ProposedDNQ;
      const fRdpDemand = oRdpNav ? oRdpNav.ProposedDnq : pair.rdp.ProposedDNQ;
      const oRes = computeRightToCure({
        dpDemand: fDpDemand,
        rdpDemand: fRdpDemand,
        ...pairLimits(pair, mGtaPools, mGsaLimits)
      });
      const oGsa = mGsaLimits.get(pair);
      if (oDpNav) oDpNav.ProposedDnq = fmt3(oRes.dpSchedule);
      if (oRdpNav) oRdpNav.ProposedDnq = fmt3(oRes.rdpSchedule);
      // Scheduled-as-demanded pairs are the normal case — only report pairs the rule adjusted.
      if (oRes.scenario === 'AS_DEMANDED') continue;
      rtcItems += (oDpNav ? 1 : 0) + (oRdpNav ? 1 : 0);
      _pushSample(rtcSamples, {
        ContractNo: pair.dp.ContractNo ?? '',
        Message: `${oRes.scenario}${oRes.anchor ? ` (anchor ${oRes.anchor})` : ''}` +
          `${oRes.gsaCapped?.length ? ` (${oRes.gsaCapped.join(' & ')} capped to GSA limits)` : ''} — ` +
          `DP ${pair.dp.ContractNo}: ${fmt3(fDpDemand)} → ${fmt3(oRes.dpSchedule)}` +
          `${oDpNav ? '' : ' (not posted)'}, ` +
          `RDP ${pair.rdp.ContractNo}: ${fmt3(fRdpDemand)} → ${fmt3(oRes.rdpSchedule)}` +
          `${oRdpNav ? '' : ' (not posted)'}, imbalance ${fmt3(oRes.curing)}` +
          (oGsa ? (oGsa.ok
            ? `, ${[oGsa.dpLinked && 'DP', oGsa.rdpLinked && 'RDP'].filter(Boolean).join(' & ')} limits from ` +
              `linked GSA ${oGsa.gsa} (DCQ ${fmt3(oGsa.dcq)}, Min ${fmt3(oGsa.min)}, Max ${fmt3(oGsa.max)})`
            : `, GSA ${oGsa.gsa} ${oGsa.reason} — GTA's own limits used`) : '')
      });
    }
    _setJobStatus(jobId, { rtcItems, rtcSamples });

    const aFinalNavPairs = blockedContracts.size
      ? aAllNavPairs.filter(p => !blockedContracts.has(p.key))
      : aAllNavPairs;
    const aFinalNav = aFinalNavPairs.map(p => p.nav);
    const linkedPendingItems = aAllNavPairs.length - aFinalNavPairs.length;
    // blockedContracts holds '{dateKey}|{ContractNo}' composite keys — pull the ContractNo back out
    for (const k of blockedContracts) sProcessedContracts.add(k.split('|')[1] ?? '');

    _setJobStatus(jobId, {
      linkedPendingItems, linkedPendingSamples,
      processedItems: rejectedItems + linkedPendingItems,
      processedContracts: sProcessedContracts.size
    });

    // ── Same-row concurrency guard — claim exactly the rows about to be
    // posted; anything already claimed by another in-flight job is reported
    // as locked rather than double-posted.
    const { aClaimed: aClaimedNav, aLocked: aLockedNav } = _claimRows(aFinalNav, jobId);
    const lockedItems = aLockedNav.length;
    const lockedSamples = [];
    if (lockedItems) {
      aLockedNav.forEach(nav => {
        sProcessedContracts.add(String(nav.ContractNo ?? ''));
        _pushSample(lockedSamples, { ContractNo: nav.ContractNo ?? '', Message: 'Currently being confirmed in another session — retry shortly.' });
      });
    }
    _setJobStatus(jobId, {
      lockedItems, lockedSamples,
      processedItems: rejectedItems + linkedPendingItems + lockedItems,
      processedContracts: sProcessedContracts.size
    });

    // ── Pre-post freshness check — a row can go from confirm-required to
    // already-confirmed in S/4 during the window between initial resolution
    // (top of this job) and the moment it's actually about to be POSTed:
    // ARI004 evaluation, Master Contract pool resolution, and linked-contract
    // resolution all take real time, and this job runs fully server-side with
    // no UI round trip back to the user to re-confirm. One batched re-fetch of
    // isConfirmRequired for every row that survived claiming — same IN-filter
    // pattern as the post-POST verification pass below — catches rows
    // confirmed elsewhere in that window and skips their POST entirely rather
    // than sending a doomed or duplicate confirm to S/4.
    let preConfirmedItems = 0;
    const preConfirmedSamples = [];
    let aPostableNav = aClaimedNav;
    if (aClaimedNav.length) {
      try {
        const aCheckContractNos = [...new Set(aClaimedNav.map(n => n.ContractNo))];
        const aCheckGasdays = [...new Set(aClaimedNav.map(n => dateKey(n.Gasday)))].sort();
        const qCheck = SELECT.from('xGMSxNOMSOURCE')
          .columns('Gasday', 'ContractNo', 'Item', 'Versn', 'NominationItem', 'isConfirmRequired')
          .where`Gasday >= ${aCheckGasdays[0]} and Gasday <= ${aCheckGasdays[aCheckGasdays.length - 1]}`;
        qCheck.where({ ContractNo: { in: aCheckContractNos } });
        const aCheckRows = await fetchAllPaged(GMSCONFIRMNOM_SRV, qCheck);
        const mCheck = new Map(aCheckRows.map(r => [_rowKeyBE(r), r]));

        aPostableNav = [];
        for (const nav of aClaimedNav) {
          const oFresh = mCheck.get(_rowKeyBE(nav));
          // Not found on re-fetch — trust the earlier resolution rather than guess; still post it.
          if (oFresh && !isTrue(oFresh.isConfirmRequired)) {
            preConfirmedItems++;
            sProcessedContracts.add(String(nav.ContractNo ?? ''));
            _pushSample(preConfirmedSamples, {
              ContractNo: nav.ContractNo ?? '',
              Message: 'Already confirmed in S/4 — skipped before posting.'
            });
            _releaseRowClaim(nav);
            continue;
          }
          aPostableNav.push(nav);
        }
        log.info(`[confirmNominationSelected] jobId=${jobId} pre-post check — ` +
          `checked=${aClaimedNav.length} preConfirmed=${preConfirmedItems}`);
      } catch (err) {
        log.error(`[confirmNominationSelected] jobId=${jobId} pre-post freshness check failed — posting all claimed rows`, err);
        aPostableNav = aClaimedNav;
      }
    }
    _setJobStatus(jobId, {
      preConfirmedItems, preConfirmedSamples,
      processedItems: rejectedItems + linkedPendingItems + lockedItems + preConfirmedItems,
      processedContracts: sProcessedContracts.size
    });

    const aNomConfigSet = await _buildNomConfigSet(igmsConfigMetaData);

    // ── CorrespondingDocNo pairing — claim a row's paired row as part of the SAME
    // logical unit as the row itself, when both sides survived every gate above and
    // are part of THIS run, so the paired row is never posted as its own separate
    // Conf_nomiSet call. It is NOT, however, added to GmsConfNomiNav on the wire (see
    // below) — S/4's GTA logic auto-processes a document's CorrespondingDocNo partner
    // as a side effect of confirming the primary document, so explicitly sending the
    // partner too in the same array causes S/4 to process it a second time within
    // that call ("send again"). The partner still gets full bookkeeping (claim
    // release, confirmedItems, processedContracts, and the post-loop verification
    // pass) — it's just never present in the outbound payload.
    // Keyed by ContractNo (not NominationItem) — same grain BNS's own
    // _resolveCorrespondingDocs (balancingScheduling-service.js) uses for this field.
    //
    // Single-pass, map-consuming algorithm: pull one row out of the map, look up its
    // CorrespondingDocNo (a ContractNo) in that SAME map and, if still present, fold
    // it into this row's payload and delete it too — so a row can never be claimed as
    // a partner twice and the outcome no longer depends on scan order. The old
    // two-pass mark-and-filter version (find every pairing first via a Set, then
    // filter the array) let a 3-way CorrespondingDocNo chain (A→B, B→C) resolve
    // differently depending purely on which row was visited first — whichever row
    // reached B first "won" it as a partner, and the loser silently posted alone.
    // Consuming the map as we go removes that ambiguity entirely.
    const mCorrDocByRowKey = new Map(); // rowKey → CorrespondingDocNo, from the raw rows —
    // nav itself carries no such field, so this must come from aConfirmable, correlated by
    // _rowKeyBE (identical whether given a raw row or its built nav — both dateKey() to
    // the same 'YYYY-MM-DD' prefix).
    for (const r of aConfirmable) {
      const doc = String(r.CorrespondingDocNo ?? '').trim();
      if (doc) mCorrDocByRowKey.set(_rowKeyBE(r), doc);
    }
    // ── GTA Right to Cure pairs — BOTH legs go on the wire, each with its own cured
    // ProposedDnq. Sending only one would let S/4's auto-processing confirm the other
    // leg at its stored, uncured ProposedDNQ (seen on Gasday 01-11-2026: every RDP leg
    // saved cured, every DP leg kept its demand). Pulled out before the generic
    // pairing below, which never sees these rows.
    const aPostUnits = [];
    const sSendAllUnits = new Set(); // units whose every nav is sent, not just unit[0]
    const mPostableByRowKey = new Map(aPostableNav.map(nav => [_rowKeyBE(nav), nav]));
    const sGtaPostedKeys = new Set();
    for (const p of aGtaPairs) {
      const oDpNav = mPostableByRowKey.get(_rowKeyBE(p.dp));
      const oRdpNav = mPostableByRowKey.get(_rowKeyBE(p.rdp));
      if (!oDpNav || !oRdpNav) continue; // one leg not posted in this run — generic path below
      const unit = [oDpNav, oRdpNav];
      aPostUnits.push(unit);
      sSendAllUnits.add(unit);
      sGtaPostedKeys.add(_rowKeyBE(oDpNav));
      sGtaPostedKeys.add(_rowKeyBE(oRdpNav));
    }
    const aGenericNav = aPostableNav.filter(nav => !sGtaPostedKeys.has(_rowKeyBE(nav)));

    const mRemainingNav = new Map(); // '{dateKey}|{ContractNo}' → nav; deleted as each row is consumed
    for (const nav of aGenericNav) {
      const k = `${dateKey(nav.Gasday)}|${String(nav.ContractNo)}`;
      if (!mRemainingNav.has(k)) mRemainingNav.set(k, nav);
    }
    for (const nav of aGenericNav) {
      const k = `${dateKey(nav.Gasday)}|${String(nav.ContractNo)}`;
      if (!mRemainingNav.delete(k)) continue; // already consumed as an earlier row's partner
      const doc = mCorrDocByRowKey.get(_rowKeyBE(nav));
      const sPartnerKey = doc ? `${dateKey(nav.Gasday)}|${doc}` : null;
      const partnerNav = sPartnerKey ? mRemainingNav.get(sPartnerKey) : null;
      if (partnerNav) {
        mRemainingNav.delete(sPartnerKey);
        aPostUnits.push([nav, partnerNav]);
      } else {
        aPostUnits.push([nav]); // no CorrespondingDocNo, or paired row isn't part of this run
      }
    }

    // ── Group by Gasday + Location (RedeliveryPoint preferred, DeliveryPoint
    // fallback) + Partner — POSTING ORDER only (see function doc). Grouped as POST
    // units now, not flat navs — a unit is 1 nav, or 2 when CorrespondingDocNo-paired
    // above (only unit[0] is ever sent to S/4, see the posting loop below); each unit
    // is still its own individual Conf_nomiSet call. Pipe-delimited, matching this
    // file's existing '{dateKey}|{ContractNo}' convention. Built from the nav item's
    // own field names (RedelivryPoint/SoldToParty — the S/4 nav shape, not
    // RedeliveryPoint/Partner) to avoid a silent field-name mismatch.
    const _groupKeyBE = nav => `${dateKey(nav.Gasday)}|${nav.RedelivryPoint || nav.DeliveryPoint || ''}|${nav.SoldToParty || ''}`;
    const mByGroup = new Map();
    for (const unit of aPostUnits) {
      const key = _groupKeyBE(unit[0]);
      let g = mByGroup.get(key);
      if (!g) mByGroup.set(key, g = []);
      g.push(unit);
    }

    let confirmedItems = 0;
    let failedItems = 0;
    const s4ErrorSamples = [];
    const toReturn = [];
    const sTouchedGasdays = new Set();
    const aAttempted = []; // { nav, ok, errMsg } — one entry per individual row, even when
    // bundled — feeds the post-loop verification pass below, which re-checks each row's own
    // isConfirmRequired independently regardless of how many rows shared a POST call.

    for (const unitGroup of mByGroup.values()) {
      for (const unit of unitGroup) {
        const sRowKeys = unit.map(_rowKeyBE).join(',');
        unit.forEach(nav => sTouchedGasdays.add(dateKey(nav.Gasday)));
        // Only unit[0] (the primary row) ever goes on the wire — see the
        // CorrespondingDocNo pairing comment above for why the partner is deliberately
        // left out of GmsConfNomiNav even though it's tracked as part of this unit.
        // Exception: a GTA Right to Cure pair (sSendAllUnits) sends both legs.
        const bSendAll = sSendAllUnits.has(unit);
        const oPayload = { Gasday: unit[0].Gasday, GmsConfNomiNav: bSendAll ? unit : [unit[0]], nom_configSet: aNomConfigSet };
        // Verifiable evidence of the CorrespondingDocNo pairing decision for this unit —
        // grep server logs for jobId to confirm which rows were paired (posted via their
        // primary only) vs sent standalone, without needing a separate dry-run mode.
        log.info(`[confirmNominationSelected] jobId=${jobId} posting contract=${unit[0].ContractNo} ` +
          `${bSendAll ? `(GTA Right to Cure pair, both sent: ${unit.map(n => `${n.ContractNo}=${n.ProposedDnq}`).join(', ')})`
            : unit.length > 1 ? `(CorrespondingDocNo partner=${unit[1].ContractNo} relies on S/4 auto-link, not sent)` : '(standalone)'}`);
        let bOk = true, sErrMsg = null;
        try {
          // srv.send() with an explicit remote path — same pattern already used for
          // ConversionRequest above. Conf_nomiSet is the remote OData V2 entity set
          // (see srv/external/GMSCONFIRMNOM_SRV.cds); GmsConfNomiNav/nom_configSet
          // are its actual nav property names, matched 1:1 in oPayload. GmsConfNomiNav
          // always carries exactly 1 item — the CorrespondingDocNo partner, when this
          // unit is a pair, is never included (S/4 auto-processes it).
          const oResult = await GMSCONFIRMNOM_SRV.send({ method: 'POST', path: '/Conf_nomiSet', data: oPayload });
          // A non-throwing POST is not on its own proof the row confirmed — S/4 can
          // return HTTP 200 with the nav item's own Path still something other than
          // CONFIRMED (e.g. a rejected/pending workflow state). Path is the
          // authoritative per-row outcome carried on the response itself; every
          // returned nav entry must read CONFIRMED for this unit to count as such —
          // ground-truth verification below (isConfirmRequired re-fetch) still
          // double-checks this for batches small enough to afford it, but the
          // provisional classification here (used as-is for >1000-row batches) must
          // not blindly trust "the call didn't throw".
          const aRespNav = oResult?.GmsConfNomiNav ?? [];
          const bAllConfirmed = aRespNav.length > 0 && aRespNav.every(n => n.Path === 'CONFIRMED');
          if (bAllConfirmed) {
            confirmedItems += unit.length;
            // Only collected on success — the failure branch below already turns
            // this same to_Return payload into one s4ErrorSamples entry; pulling it
            // again here unconditionally used to duplicate every S/4 error into
            // toReturn too, showing each message twice in the Nomination Messages
            // dialog (once prefixed "S/4 error:", once bare).
            for (const m of _extractReturnMessagesBE(oResult)) _pushSample(toReturn, m);
          } else {
            bOk = false;
            const sRespMsg = _extractReturnMessagesBE(oResult).map(m => m.Message).join('; ');
            sErrMsg = sRespMsg || `S/4 did not confirm this row (Path=${aRespNav.map(n => n.Path).join(',') || 'none returned'}).`;
            failedItems += unit.length;
            _pushSample(s4ErrorSamples, { ContractNo: unit.map(n => n.ContractNo ?? '').join(' + '), Message: sErrMsg });
            log.error(`[confirmNominationSelected] jobId=${jobId} rows=${sRowKeys} NOT CONFIRMED (Path=${aRespNav.map(n => n.Path).join(',')})`);
          }
        } catch (err) {
          bOk = false;
          sErrMsg = logError(err);
          failedItems += unit.length;
          _pushSample(s4ErrorSamples, { ContractNo: unit.map(n => n.ContractNo ?? '').join(' + '), Message: sErrMsg });
          log.error(`[confirmNominationSelected] jobId=${jobId} rows=${sRowKeys} FAILED ProposedDnq=${unit.map(n => n.ProposedDnq).join(',')}`, err);
        } finally {
          unit.forEach(nav => _releaseRowClaim(nav));
        }
        unit.forEach(nav => aAttempted.push({ nav, ok: bOk, errMsg: sErrMsg }));
        unit.forEach(nav => sProcessedContracts.add(String(nav.ContractNo ?? '')));
        _setJobStatus(jobId, {
          processedItems: rejectedItems + linkedPendingItems + lockedItems + preConfirmedItems + confirmedItems + failedItems,
          processedContracts: sProcessedContracts.size,
          confirmedItems, failedItems, s4ErrorSamples, toReturn
        });
      }
    }

    // ── Ground-truth verification (attempted selections <=1000 rows) ──────────
    // A POST's HTTP outcome can be misleading — S/4 has been observed returning
    // a generic error even though the underlying confirm actually committed
    // (SAP BAPI quirk: a follow-up step failing after the core data write
    // succeeds). isConfirmRequired on a fresh re-fetch is the only reliable
    // signal of whether a row is ACTUALLY confirmed, so for a batch small
    // enough to afford one extra batched read, the provisional POST-result
    // classification above is replaced with the verified truth. Skipped above
    // 1000 attempted rows to avoid doubling S/4 read traffic on large jobs —
    // those keep relying on the POST response alone, as before.
    if (aAttempted.length && aAttempted.length <= 1000) {
      try {
        const aVerifyContractNos = [...new Set(aAttempted.map(a => a.nav.ContractNo))];
        const aVerifyGasdays = [...new Set(aAttempted.map(a => dateKey(a.nav.Gasday)))].sort();
        const q = SELECT.from('xGMSxNOMSOURCE')
          .columns('Gasday', 'ContractNo', 'Item', 'Versn', 'NominationItem', 'isConfirmRequired')
          .where`Gasday >= ${aVerifyGasdays[0]} and Gasday <= ${aVerifyGasdays[aVerifyGasdays.length - 1]}`;
        q.where({ ContractNo: { in: aVerifyContractNos } });
        const aVerifyRows = await fetchAllPaged(GMSCONFIRMNOM_SRV, q);
        const mVerify = new Map(aVerifyRows.map(r => [_rowKeyBE(r), r]));

        let vConfirmed = 0, vFailed = 0;
        const vErrorSamples = [];
        for (const { nav, ok, errMsg } of aAttempted) {
          const oFresh = mVerify.get(_rowKeyBE(nav));
          // Not found on re-fetch — trust the POST result rather than guess.
          const bTrulyConfirmed = oFresh ? !isTrue(oFresh.isConfirmRequired) : ok;
          if (bTrulyConfirmed) {
            vConfirmed++;
          } else {
            vFailed++;
            _pushSample(vErrorSamples, {
              ContractNo: nav.ContractNo ?? '',
              Message: errMsg || 'S/4 reported success but the row is still not confirmed — verification failed.'
            });
          }
        }
        confirmedItems = vConfirmed;
        failedItems = vFailed;
        s4ErrorSamples.length = 0;
        vErrorSamples.forEach(s => _pushSample(s4ErrorSamples, s));
        _setJobStatus(jobId, {
          processedItems: rejectedItems + linkedPendingItems + lockedItems + preConfirmedItems + confirmedItems + failedItems,
          confirmedItems, failedItems, s4ErrorSamples
        });
      } catch (err) {
        log.error(`[confirmNominationSelected] jobId=${jobId} verification pass failed — keeping POST-result counts`, err);
      }
    }

    for (const k of sTouchedGasdays) nomCache.cache.delete(k);
    _bnsCache.clear();
    // Schedule Nominations table snapshot + day pool — the post-confirm re-read
    // (Confirmed segment) must not be served pre-confirm rows from cache.
    clearNomSourceCache();

    _setJobStatus(jobId, { status: 'COMPLETED', completedAt: new Date() });
    log.info(`[TIMING] jobId=${jobId} done total=${aEligible.length} confirmed=${confirmedItems} ` +
      `rejected=${rejectedItems} failed=${failedItems} capped=${cappedItems} ` +
      `linkedPending=${linkedPendingItems} locked=${lockedItems} preConfirmed=${preConfirmedItems} ` +
      `elapsed=${Date.now() - tStart}ms`);

  } catch (err) {
    log.error(`[confirmNominationSelected] jobId=${jobId} job failed`, err);
    _setJobStatus(jobId, {
      status: 'FAILED',
      errorMessage: err.message || 'Confirm nomination failed',
      completedAt: new Date()
    });
  }
};

// ── Service Parameter ID → xGMSxNOMSOURCE field name ─────────────────────────
// Mirrors SP_TO_FIELD in the CSN controller. Backend uses this to resolve
// which numeric fields to compare when evaluating ARI004 business rules
// before posting to S/4.




// ── Value-help master data cache ─────────────────────────────────────────────
// Keyed by entity name. Loaded from S/4 on first open, re-fetched after TTL.
// Dedup + sort happen once at fill time; every subsequent VH open is a cheap
// in-memory filter + slice. 15-min TTL — master locations change at most once
// per shift; transport systems even less frequently.
const _vhCache = new Map();
const VH_CACHE_TTL = 15 * 60 * 1000;


// Shared rank comparator: 1 = highest priority, 0 and null/empty = last
const _rankOrder = r => {
  if (r.Rank == null || r.Rank === '' || isNaN(Number(r.Rank))) return Number.MAX_SAFE_INTEGER;
  const n = Number(r.Rank);
  return n <= 0 ? Number.MAX_SAFE_INTEGER - 1 : n;
};

// Sort order for CustomerKind: blank(OWN)=0, PRIMARY=1, HYBRID=2, other(TP)=3
const _custKindOrder = (kind) => !kind ? 0 : kind === 'PRIMARY' ? 1 : kind === 'HYBRID' ? 2 : 3;

// ServiceType sort bucket: FIRM=0, FALLBACK=1, anything else=2
const _stBucket = st => {
  const s = (st || '').trim().toUpperCase();
  return s === 'FIRM' ? 0 : s === 'FALLBACK' ? 1 : 2;
};

// Normalise a Gasday value to 'yyyy-MM-dd' for reliable lexicographic sort.
// CAP may return Edm.Date as a JS Date object; String(Date) is locale-dependent
// and does not sort chronologically, so we always convert to ISO slice.
const _toIsoDate = v => {
  if (!v) return '';
  if (v instanceof Date) return v.toISOString().slice(0, 10);
  return String(v).slice(0, 10); // already 'yyyy-MM-dd' from server
};

// ── BNS cache (keyed by a compound string built in warmBNSData) ───────────────
// Always holds at most ONE entry — cleared before every new warm.
// Structure: { data[], ts, count, isRange, GasdayFrom, GasdayTo, TransportSystems }
const _bnsCache = new Map();

// Pre-sort comparator for single-day results.
// Order: CustomerKind → RedeliveryPoint → DeliveryPoint → ServiceType → Rank
const _bnsSortComparator = (a, b) => {
  const cidCmp = _custKindOrder(a.CustomerKind) - _custKindOrder(b.CustomerKind);
  if (cidCmp !== 0) return cidCmp;

  const rdpCmp = String(a.RedeliveryPoint || '').localeCompare(String(b.RedeliveryPoint || ''));
  if (rdpCmp !== 0) return rdpCmp;

  const dpCmp = String(a.DeliveryPoint || '').localeCompare(String(b.DeliveryPoint || ''));
  if (dpCmp !== 0) return dpCmp;

  const stCmp = _stBucket(a.ServiceType) - _stBucket(b.ServiceType);
  if (stCmp !== 0) return stCmp;

  return _rankOrder(a) - _rankOrder(b);
};

// Pre-sort comparator for date-range results.
// Order: Gasday → CustomerKind → RedeliveryPoint → DeliveryPoint → ServiceType → Rank
const _bnsSortComparatorRange = (a, b) => {
  const gdCmp = _toIsoDate(a.Gasday).localeCompare(_toIsoDate(b.Gasday));
  if (gdCmp !== 0) return gdCmp;

  const cidCmp = _custKindOrder(a.CustomerKind) - _custKindOrder(b.CustomerKind);
  if (cidCmp !== 0) return cidCmp;

  const rdpCmp = String(a.RedeliveryPoint || '').localeCompare(String(b.RedeliveryPoint || ''));
  if (rdpCmp !== 0) return rdpCmp;

  const dpCmp = String(a.DeliveryPoint || '').localeCompare(String(b.DeliveryPoint || ''));
  if (dpCmp !== 0) return dpCmp;

  const stCmp = _stBucket(a.ServiceType) - _stBucket(b.ServiceType);
  if (stCmp !== 0) return stCmp;

  return _rankOrder(a) - _rankOrder(b);
};





module.exports = async (srv) => {
  const igmsConfigMetaData = await cds.connect.to("igmsConfigMetaData");
  const GMSVALUEHELP_SRV = await cds.connect.to("GMSVALUEHELP_SRV");
  const GMSNOMINATIONS_SRV = await cds.connect.to("GMSNOMINATIONS_SRV");

  // ── Error handler ────────────────────────────────────────────────────────
  srv.on('error', (err, req) => {
    const correlationId = req?.headers?.['x-correlation-id'];
    if (correlationId) err.message = `${err.message}`;
  });


  const GMSTICKET_API_SRV = await cds.connect.to("GMSTICKET_API_SRV");

  srv.on('READ', 'DocFlowSet', req => GMSTICKET_API_SRV.run(req.query));
    srv.on('READ', 'ErrorLogSet', req => GMSTICKET_API_SRV.run(req.query));
    srv.on('READ', 'TktlogDetailHeadSet', req => GMSTICKET_API_SRV.run(req.query));
    srv.on('READ', 'TktlogDetailSet', req => GMSTICKET_API_SRV.run(req.query));
    srv.on('READ', 'TicketDetailSet', req => GMSTICKET_API_SRV.run(req.query));



  srv.on('READ', 'CVParamsSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'returnSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualDateSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualErrorSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualLocidSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualMatnrSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualNomitSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualNomnrSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualSuccessFlowSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualSuccessSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualTsystSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'xGMSxTKT_EXEC_TICKETS', req => GMSTICKET_API_SRV.run(req.query));
  // ── getBalancingDocumentTypes ─────────────────────────────────────────────
  srv.on('getBalancingDocumentTypes', async (req) => {
    const allData = await igmsConfigMetaData.run(
      SELECT.from("ContractProfileMapping", ['documentType', 'documentTypeDesc']).where({
        igmsServiceIndicator: {
          in: ["SHIPPER", "TSO"]
        }
      })
    );

    const seen = new Set();
    const result = [];
    for (const row of allData) {
      if (!seen.has(row.documentType)) {
        seen.add(row.documentType);
        result.push({
          documentType: row.documentType,
          documentTypeDesc: row.documentTypeDesc
        });
      }
    }
    return result;
  });

  srv.on('READ', 'getAllocationRule', async (req) => {
    const allData = await igmsConfigMetaData.run(req.query);
    return allData;
  });

  function _appendYAFilter(query) {
    _appendFilter(query, { ref: ["Vsart"] }, "YA");
  }

  srv.on("READ", "getAllTransportSystem", async (req) => {
    const query = req.query;
    query.SELECT.where = query.SELECT.where
      ? [...query.SELECT.where, 'and', { ref: ['Vsart'] }, '=', { val: 'YA' }]
      : [{ ref: ['Vsart'] }, '=', { val: 'YA' }];
    const data = await GMSVALUEHELP_SRV.run(query);
    return [...new Map(data.map(item => [item.Tsyst, item])).values()];
  });

  /** Returns distinct (Tsyst, Tsnam) keys matching the optional search term.
   *  Used by the frontend Select All / Deselect All to avoid loading full dataset.
   *  Deduplicated by Tsyst — the system code used as the VH token key. */
  srv.on('getAllTransportSystemKeys', async req => {
    const { search } = req.data;
    const where = [{ ref: ['Vsart'] }, '=', { val: 'YA' }];
    if (search) {
      where.push('and', { ref: ['Tsnam'] }, 'like', { val: `%${search}%` });
    }
    const q = SELECT.from('GMSValueHelps.xGMSxLocPoint_Map').columns(['Tsyst', 'Tsnam']);
    q.SELECT.where = where;
    const data = await GMSVALUEHELP_SRV.run(q);
    return data
  });

  // ── Location key functions — used by VH Select All / Deselect All ──────────

  function _appendTransportWhere(where, transportSystems) {
    if (!transportSystems) return;
    const aKeys = transportSystems.split(',').map(s => s.trim()).filter(Boolean);
    if (!aKeys.length) return;
    if (aKeys.length === 1) {
      where.push('and', { ref: ['Tsyst'] }, '=', { val: aKeys[0] });
    } else {
      const orParts = [];
      aKeys.forEach((k, i) => {
        if (i > 0) orParts.push('or');
        orParts.push({ ref: ['Tsyst'] }, '=', { val: k });
      });
      where.push('and', { xpr: orParts });
    }
  }

  function _appendSearchWhere(where, search) {
    if (!search) return;
    where.push('and', {
      xpr: [
        { ref: ['Locid'] }, 'like', { val: `%${search}%` },
        'or',
        { ref: ['Locnam'] }, 'like', { val: `%${search}%` }
      ]
    });
  }

  /** Returns distinct (Locid, Locnam, Tsyst) for delivery points. */
  srv.on('getAllDeliveryPointKeys', async req => {
    const { search, transportSystems } = req.data;
    const where = [{ ref: ['Delivery_Point'] }, '=', { val: true }];
    _appendTransportWhere(where, transportSystems);
    _appendSearchWhere(where, search);
    const q = SELECT.from('GMSValueHelps.xGMSxLocPoint_Map').columns(['Locid', 'Locnam', 'Tsyst']);
    q.SELECT.where = where;
    const data = await GMSVALUEHELP_SRV.run(q);
    return [...new Map(data.map(item => [item.Locid, item])).values()];
  });

  /** Returns distinct (Locid, Locnam, Tsyst) for redelivery points. */
  srv.on('getAllRedeliveryPointKeys', async req => {
    const { search, transportSystems } = req.data;
    const where = [{ ref: ['Redelivery_Point'] }, '=', { val: true }];
    _appendTransportWhere(where, transportSystems);
    _appendSearchWhere(where, search);
    const q = SELECT.from('GMSValueHelps.xGMSxLocPoint_Map').columns(['Locid', 'Locnam', 'Tsyst']);
    q.SELECT.where = where;
    const data = await GMSVALUEHELP_SRV.run(q);
    return [...new Map(data.map(item => [item.Locid, item])).values()];
  });

  /** Returns distinct (Locid, Locnam, Tsyst) for interconnect points (isInterconnect='YES'). */
  srv.on('getAllInterconnectPointKeys', async req => {
    const { search, transportSystems } = req.data;
    const where = [{ ref: ['isInterconnect'] }, '=', { val: 'YES' }];
    _appendTransportWhere(where, transportSystems);
    _appendSearchWhere(where, search);
    const q = SELECT.from('GMSValueHelps.xGMSxLocPoint_Map').columns(['Locid', 'Locnam', 'Tsyst']);
    q.SELECT.where = where;
    const data = await GMSVALUEHELP_SRV.run(q);
    return [...new Map(data.map(item => [item.Locid, item])).values()];
  });

  // Delivery locations — backend enforces Delivery_Point=true
  srv.on("READ", "getAllDeliveryPoints", req => {
    _appendYAFilter(req.query);
    _appendFilter(req.query, { ref: ["Delivery_Point"] }, true);
    return GMSVALUEHELP_SRV.run(req.query);
  });

  // Redelivery locations — backend enforces Redelivery_Point=true
  srv.on("READ", "getAllRedDeliveryPoints", req => {
    _appendYAFilter(req.query);
    _appendFilter(req.query, { ref: ["Redelivery_Point"] }, true);
    return GMSVALUEHELP_SRV.run(req.query);
  });

  // Interconnect locations — backend enforces isInterconnect='YES'
  srv.on("READ", "getAllInterconnectPoints", req => {
    _appendYAFilter(req.query);
    _appendFilter(req.query, { ref: ["isInterconnect"] }, "YES");
    return GMSVALUEHELP_SRV.run(req.query);
  });

  /**
* Appends an AND equality condition to req.query.SELECT.where in CQN format.
* @param {object} query    CQN query object
* @param {object} ref      CQN column ref, e.g. { ref: ["fieldName"] }
* @param {*}      val      value to compare
*/
  function _appendFilter(query, ref, val) {
    const condition = [ref, "=", { val }];
    if (query.SELECT.where?.length) {
      query.SELECT.where.push("and", ...condition);
    } else {
      query.SELECT.where = condition;
    }
  }


  // CONFIRMNOMSRV_________________________________________________________________________START HERE
  const GMSCONFIRMNOM_SRV = await cds.connect.to("GMSCONFIRMNOM_SRV");

  // ── getBNSAggQty — ProposedDNQ aggregate for BNS table ──────────────────────
  // Cache-first: if _bnsCache covers the requested Gas Day / range, the sum is
  // computed in-memory in a single pass — zero S4 round trips.
  // Falls back to paginated S4 query (ProposedDNQ + UOM only) when cache is cold.
  srv.on('getBNSAggQty', async req => {
    const log = cds.log('getBNSAggQty');
    const {
      GasdayFrom,
      GasdayTo,
      ContractType,
      TransportSystems,
      DeliveryPoints,
      RedeliveryPoints,
      Materials,
      HasNomKey
    } = req.data;
    if (!GasdayFrom) return req.reject(400, 'GasdayFrom is required');

    const sTo = GasdayTo || GasdayFrom;
    const splitArr = s => s ? s.split(',').map(x => x.trim()).filter(Boolean) : [];
    const tsSet = new Set(splitArr(TransportSystems));
    const dpSet = new Set(splitArr(DeliveryPoints));
    const rpSet = new Set(splitArr(RedeliveryPoints));
    const matSet = new Set(splitArr(Materials));

    const toResult = uomMap => [...uomMap.entries()]
      .map(([UOM, t]) => ({ UOM, TotalDNQ: parseFloat(t.toFixed(3)) }));

    // ── Cache path ────────────────────────────────────────────────────────────
    const cacheEntry = _getActiveBNSCache(GasdayFrom, sTo);
    if (cacheEntry) {
      const uomMap = new Map();
      for (const r of cacheEntry.data) {
        const gasDay = String(r.Gasday || '').substring(0, 10);
        if (gasDay < GasdayFrom || gasDay > sTo) continue;
        if (ContractType && r.ContractType !== ContractType) continue;
        if (tsSet.size && !tsSet.has(r.TransportSystem)) continue;
        if (dpSet.size && !dpSet.has(r.DeliveryPoint)) continue;
        if (rpSet.size && !rpSet.has(r.RedeliveryPoint)) continue;
        if (matSet.size && !matSet.has(r.Material)) continue;
        if (HasNomKey === 1 && r.isConfirmRequired !== false) continue;
        if (HasNomKey === -1 && r.isConfirmRequired === false) continue;
        const uom = r.UOM || '';
        uomMap.set(uom, (uomMap.get(uom) || 0) + parseFloat(r.ProposedDNQ || 0));
      }
      log.info(`[getBNSAggQty] cache-hit from=${GasdayFrom} to=${sTo} uoms=${[...uomMap.keys()].join(',')}`);
      return toResult(uomMap);
    }

    // ── S4 fallback (cache cold) ──────────────────────────────────────────────
    const isRange = sTo !== GasdayFrom;
    const whereExpr = isRange ?
      [{
        ref: ['Gasday']
      }, '>=', {
        val: GasdayFrom
      }, 'and', {
        ref: ['Gasday']
      }, '<=', {
        val: sTo
      }] :
      [{
        ref: ['Gasday']
      }, '=', {
        val: GasdayFrom
      }];

    if (ContractType) whereExpr.push('and', {
      ref: ['ContractType']
    }, '=', {
      val: ContractType
    });

    const addInFilter = (field, arr) => {
      if (!arr.length) return;
      const orParts = [];
      arr.forEach((v, i) => {
        if (i > 0) orParts.push('or');
        orParts.push({
          ref: [field]
        }, '=', {
          val: v
        });
      });
      whereExpr.push('and', {
        xpr: orParts
      });
    };
    addInFilter('TransportSystem', [...tsSet]);
    addInFilter('DeliveryPoint', [...dpSet]);
    addInFilter('RedeliveryPoint', [...rpSet]);
    addInFilter('Material', [...matSet]);

    if (HasNomKey === 1) whereExpr.push('and', { ref: ['isConfirmRequired'] }, '=', { val: false });
    if (HasNomKey === -1) whereExpr.push('and', { ref: ['isConfirmRequired'] }, '=', { val: true });

    const PAGE_SIZE = 5000;
    let skip = 0;
    const uomMap = new Map();
    while (true) {
      const page = await GMSCONFIRMNOM_SRV.run(
        SELECT.from('xGMSxNOMSOURCE').columns('ProposedDNQ', 'UOM').where(whereExpr).limit(PAGE_SIZE, skip)
      );
      if (!page?.length) break;
      for (const item of page) {
        const uom = item.UOM || '';
        uomMap.set(uom, (uomMap.get(uom) || 0) + parseFloat(item.ProposedDNQ || 0));
      }
      if (page.length < PAGE_SIZE) break;
      skip += PAGE_SIZE;
    }
    log.info(`[getBNSAggQty] S4-fallback from=${GasdayFrom} to=${sTo} uoms=${[...uomMap.keys()].join(',')}`);
    return toResult(uomMap);
  });

  // ── getBNSStatusCounts — confirmed / not-confirmed counts ────────────────────
  // Field-to-field comparison (ApprovedDNQ eq ProposedDNQ) is not supported by
  // CAP OData $filter; must be evaluated in JS.
  // Cache-first (zero S4 calls when warm); falls back to a paginated S4 fetch
  // fetching only the three columns needed — handles CF multi-instance scenarios
  // where warmBNSData may have run on a different app instance.
  srv.on('getBNSStatusCounts', async req => {
    const { GasdayFrom, GasdayTo, ContractType, TransportSystems, DeliveryPoints, RedeliveryPoints, Materials } = req.data;
    if (!GasdayFrom) return req.reject(400, 'GasdayFrom is required');

    const sTo = GasdayTo || GasdayFrom;
    const splitArr = s => s ? s.split(',').map(x => x.trim()).filter(Boolean) : [];
    const tsSet = new Set(splitArr(TransportSystems));
    const dpSet = new Set(splitArr(DeliveryPoints));
    const rpSet = new Set(splitArr(RedeliveryPoints));
    const matSet = new Set(splitArr(Materials));
    const f3 = v => parseFloat(v || 0).toFixed(3);

    const countRows = rows => {
      let confirmed = 0, notConfirmed = 0, total = 0;
      for (const r of rows) {
        const gasDay = String(r.Gasday || '').substring(0, 10);
        if (gasDay < GasdayFrom || gasDay > sTo) continue;
        if (ContractType && r.ContractType !== ContractType) continue;
        if (tsSet.size && !tsSet.has(r.TransportSystem)) continue;
        if (dpSet.size && !dpSet.has(r.DeliveryPoint)) continue;
        if (rpSet.size && !rpSet.has(r.RedeliveryPoint)) continue;
        if (matSet.size && !matSet.has(r.Material)) continue;
        total++;
        if (r.isConfirmRequired === false) confirmed++;
        else notConfirmed++;
      }
      return { confirmed, notConfirmed, total };
    };

    // ── Cache path ────────────────────────────────────────────────────────────
    const cacheEntry = _getActiveBNSCache(GasdayFrom, sTo);
    if (cacheEntry) return countRows(cacheEntry.data);

    // ── S4 fallback (cache cold — e.g. different CF instance) ─────────────────
    // Fetch only the columns needed for counting; avoids transferring full rows.
    const isRange = sTo !== GasdayFrom;
    const whereExpr = isRange
      ? [{ ref: ['Gasday'] }, '>=', { val: GasdayFrom }, 'and', { ref: ['Gasday'] }, '<=', { val: sTo }]
      : [{ ref: ['Gasday'] }, '=', { val: GasdayFrom }];

    if (ContractType) whereExpr.push('and', { ref: ['ContractType'] }, '=', { val: ContractType });

    const addInFilter = (field, arr) => {
      if (!arr.length) return;
      const orParts = [];
      arr.forEach((v, i) => {
        if (i > 0) orParts.push('or');
        orParts.push({ ref: [field] }, '=', { val: v });
      });
      whereExpr.push('and', { xpr: orParts });
    };
    addInFilter('TransportSystem', [...tsSet]);
    addInFilter('DeliveryPoint', [...dpSet]);
    addInFilter('RedeliveryPoint', [...rpSet]);
    addInFilter('Material', [...matSet]);

    const PAGE_SIZE = 5000;
    let skip = 0;
    const all = [];
    while (true) {
      const page = await GMSCONFIRMNOM_SRV.run(
        SELECT.from('xGMSxNOMSOURCE')
          .columns('Gasday', 'ContractType', 'TransportSystem', 'DeliveryPoint',
            'RedeliveryPoint', 'Material', 'isConfirmRequired')
          .where(whereExpr).limit(PAGE_SIZE, skip)
      );
      if (!page?.length) break;
      all.push(...page);
      if (page.length < PAGE_SIZE) break;
      skip += PAGE_SIZE;
    }
    return countRows(all);
  });

  // ── checkTechBalancingRules — validates "Label Wise Ranking" rule for every  ──
  // Business Location in the current BNS filter scope.  Returns violations only. ──
  srv.on('checkTechBalancingRules', async req => {
    const log = cds.log('checkTechBalancingRules');
    const {
      Gasday,
      ContractType,
      TransportSystems,
      DeliveryPoints,
      RedeliveryPoints,
      Materials,
      HasNomKey
    } = req.data;
    if (!Gasday) return req.reject(400, 'Gasday is required');

    const splitArr = s => s ? s.split(',').map(x => x.trim()).filter(Boolean) : [];
    const tsArr = splitArr(TransportSystems);
    const dpArr = splitArr(DeliveryPoints);
    const rpArr = splitArr(RedeliveryPoints);
    const matArr = splitArr(Materials);

    const whereExpr = [{
      ref: ['Gasday']
    }, '=', {
      val: Gasday
    }];
    if (ContractType) whereExpr.push('and', {
      ref: ['ContractType']
    }, '=', {
      val: ContractType
    });

    const addInFilter = (field, arr) => {
      if (!arr.length) return;
      const orParts = [];
      arr.forEach((v, i) => {
        if (i > 0) orParts.push('or');
        orParts.push({
          ref: [field]
        }, '=', {
          val: v
        });
      });
      whereExpr.push('and', {
        xpr: orParts
      });
    };
    addInFilter('TransportSystem', tsArr);
    addInFilter('DeliveryPoint', dpArr);
    addInFilter('RedeliveryPoint', rpArr);
    addInFilter('Material', matArr);
    if (HasNomKey === 1) whereExpr.push('and', { ref: ['isConfirmRequired'] }, '=', { val: false });
    if (HasNomKey === -1) whereExpr.push('and', { ref: ['isConfirmRequired'] }, '=', { val: true });

    // ── Collect unique locations — cache-first (O(n) in-memory), S4 fallback ───
    const locMap = new Map(); // location → desc

    const bnsEntry = _getActiveBNSCache(Gasday, Gasday);
    if (bnsEntry) {
      // Filter the cache using the same criteria as the BNS table
      for (const r of bnsEntry.data) {
        if (ContractType && r.ContractType !== ContractType) continue;
        if (tsArr.length && !tsArr.includes(r.TransportSystem)) continue;
        if (dpArr.length && !dpArr.includes(r.DeliveryPoint)) continue;
        if (rpArr.length && !rpArr.includes(r.RedeliveryPoint)) continue;
        if (matArr.length && !matArr.includes(r.Material)) continue;
        if (HasNomKey === 1 && r.isConfirmRequired !== false) continue;
        if (HasNomKey === -1 && r.isConfirmRequired === false) continue;
        if (r.RedeliveryPoint && !locMap.has(r.RedeliveryPoint))
          locMap.set(r.RedeliveryPoint, r.RedeliveryPointName || r.RedeliveryPoint);
        if (r.DeliveryPoint && !locMap.has(r.DeliveryPoint))
          locMap.set(r.DeliveryPoint, r.DeliveryPointName || r.DeliveryPoint);
      }
    } else {
      // S4 fallback — paginate with the already-built whereExpr
      const PAGE_SIZE = 5000;
      let skip = 0;
      while (true) {
        const page = await GMSCONFIRMNOM_SRV.run(
          SELECT.from('xGMSxNOMSOURCE')
            .columns('RedeliveryPoint', 'RedeliveryPointName', 'DeliveryPoint', 'DeliveryPointName')
            .where(whereExpr).limit(PAGE_SIZE, skip)
        );
        if (!page?.length) break;
        for (const r of page) {
          if (r.RedeliveryPoint && !locMap.has(r.RedeliveryPoint))
            locMap.set(r.RedeliveryPoint, r.RedeliveryPointName || r.RedeliveryPoint);
          if (r.DeliveryPoint && !locMap.has(r.DeliveryPoint))
            locMap.set(r.DeliveryPoint, r.DeliveryPointName || r.DeliveryPoint);
        }
        if (page.length < PAGE_SIZE) break;
        skip += PAGE_SIZE;
      }
    }

    if (!locMap.size) return [];

    // Fetch all Technical Balancing rules (small config table — no pagination needed)
    const allRules = await igmsConfigMetaData.run(
      SELECT.from('AllocationLocationRule').where({
        RuleMapWith: 'Technical Balancing'
      })
    );

    const gasDate = new Date(Gasday);
    gasDate.setHours(0, 0, 0, 0);

    const violations = [];
    for (const [loc, desc] of locMap) {
      const locRules = allRules.filter(r => r.location === loc);

      if (!locRules.length) {
        violations.push({
          Location: loc,
          LocationDesc: desc,
          AllocRule: 'No Rule Maintained',
          Reason: 'No Technical Balancing rule exists for this location.'
        });
        continue;
      }

      const validRule = locRules.find(r => {
        const from = new Date(r.validFromAlloc);
        from.setHours(0, 0, 0, 0);
        const to = new Date(r.validToAlloc);
        to.setHours(0, 0, 0, 0);
        return gasDate >= from && gasDate <= to;
      });

      if (!validRule) {
        // Rule exists but none covers the Gas Day — show the nearest candidate's validity window
        const best = locRules[0];
        violations.push({
          Location: loc,
          LocationDesc: desc,
          AllocRule: best.AllocRule,
          Reason: `Rule not valid for Gas Day ${Gasday} (Valid: ${best.validFromAlloc} to ${best.validToAlloc})`
        });
      } else if (validRule.AllocRule !== 'Label Wise Ranking') {
        violations.push({
          Location: loc,
          LocationDesc: desc,
          AllocRule: validRule.AllocRule,
          Reason: `"${validRule.AllocRule}" is maintained instead of "Label Wise Ranking"`
        });
      }
    }

    log.info(`[checkTechBalancingRules] Gasday=${Gasday} locations=${locMap.size} violations=${violations.length}`);
    return violations;
  });

  srv.on('READ', 'createConfirmNom', req => GMSCONFIRMNOM_SRV.run(req.query));
  srv.on('CREATE', 'createConfirmNom', req => GMSCONFIRMNOM_SRV.run(req.query));
  srv.on('READ', 'Conf_nomi_subSet', req => GMSCONFIRMNOM_SRV.run(req.query));
  srv.on('READ', 'nom_configSet', req => GMSCONFIRMNOM_SRV.run(req.query));
  srv.on('READ', 'toReturnSet', req => GMSCONFIRMNOM_SRV.run(req.query));
  // ── warmBNSData — loads BNS rows from S4 into _bnsCache ─────────────────────
  // Single day  : GasdayTo = GasdayFrom (or empty); no mandatory S4 filters.
  // Date range  : GasdayTo > GasdayFrom; TransportSystems applied at S4 level to
  //               cap data volume (1L rows/day × 31 days without filter = 31L rows).
  // Always clears the previous cache entry — only one warm dataset is kept in memory.
  srv.on('warmBNSData', async req => {
    const log = cds.log('warmBNSData');
    const {
      GasdayFrom,
      GasdayTo,
      TransportSystems
    } = req.data;
    if (!GasdayFrom) return req.reject(400, 'GasdayFrom is required');

    const sTo = (GasdayTo && GasdayTo !== GasdayFrom) ? GasdayTo : GasdayFrom;
    const isRange = sTo !== GasdayFrom;

    // Build WHERE — Gasday EQ for single day, GE+LE for range
    const whereExpr = isRange ?
      [{
        ref: ['Gasday']
      }, '>=', {
        val: GasdayFrom
      }, 'and', {
        ref: ['Gasday']
      }, '<=', {
        val: sTo
      }] :
      [{
        ref: ['Gasday']
      }, '=', {
        val: GasdayFrom
      }];

    // For date range apply Transport System at S4 level to keep payload manageable
    if (isRange && TransportSystems) {
      const tsArr = TransportSystems.split(',').map(s => s.trim()).filter(Boolean);
      if (tsArr.length) {
        const orParts = [];
        tsArr.forEach((v, i) => {
          if (i > 0) orParts.push('or');
          orParts.push({
            ref: ['TransportSystem']
          }, '=', {
            val: v
          });
        });
        whereExpr.push('and', {
          xpr: orParts
        });
      }
    }

    // Paginate S4 in 10 000-row chunks — halves round trips vs the former 5 000 limit
    const PAGE_SIZE = 10000;
    const all = [];
    let skip = 0;
    while (true) {
      const page = await GMSCONFIRMNOM_SRV.run(
        SELECT.from('xGMSxNOMSOURCE').where(whereExpr).limit(PAGE_SIZE, skip)
      );
      if (!page?.length) break;
      all.push(...page);
      if (page.length < PAGE_SIZE) break;
      skip += PAGE_SIZE;
    }

    // ── Post-process in one pass ───────────────────────────────────────────────
    // Default PostBalancingDNQ to ApprovedDNQ when zero and nomination exists.
    for (const item of all) {
      if (item.NominationKey &&
        (item.PostBalancingDNQ == null || item.PostBalancingDNQ === '' ||
          parseFloat(item.PostBalancingDNQ) === 0))
        item.PostBalancingDNQ = item.ApprovedDNQ;
    }

    // ── Pre-sort once — zero cost on every subsequent paginated READ ──────────
    all.sort(isRange ? _bnsSortComparatorRange : _bnsSortComparator);

    // Build compound cache key; normalise TS list so key is order-independent
    const tsKey = isRange ?
      (TransportSystems || '').split(',').map(s => s.trim()).sort().join(',') :
      '';
    const cacheKey = isRange ? `${GasdayFrom}__${sTo}__${tsKey}` : GasdayFrom;

    // Evict previous entry — only one dataset in memory at a time
    _bnsCache.clear();
    _bnsCache.set(cacheKey, {
      data: all,
      ts: Date.now(),
      count: all.length,
      isRange,
      GasdayFrom,
      GasdayTo: sTo,
      TransportSystems: TransportSystems || ''
    });

    log.info(`[warmBNSData] key=${cacheKey} loaded=${all.length} isRange=${isRange}`);
    return all.length;
  });

  // ── READ scheduledNomData — cache-backed, in-memory filter + server paging ──
  // The table binding sends $filter/$orderby/$top/$skip as normal OData requests.
  // All heavy lifting (S4 fetch, post-process, pre-sort) happened in warmBNSData.
  // A cache miss returns an empty result so the table shows "No Data — press Go."
  // srv.on('READ', 'scheduledNomData', async req => {
  //   const log = cds.log('scheduledNomData');

  //   // Locate the cache entry that matches the current Gas Day / range filter
  //   const entry = _findBNSCacheEntry(req.query.SELECT ?.where || []);
  //   if (!entry) {
  //     const empty = [];
  //     if (req.query.SELECT.count) empty.$count = 0;
  //     return empty;
  //   }

  //   let data = entry.data;

  //   // In-memory filter — parse WHERE once into native JS structures, then filter
  //   // with direct property access + Set.has(). Replaces per-row recursive AST eval
  //   // which was the main CPU bottleneck for 1.5L-row datasets.
  //   const where = req.query.SELECT ?.where || [];
  //   if (where.length) {
  //     const f = _parseBNSFilters(where);
  //     data = data.filter(r => {
  //       const gd = String(r.Gasday || '').substring(0, 10);
  //       if (gd < f.gasdayFrom || gd > f.gasdayTo) return false;
  //       if (f.contractType && r.ContractType !== f.contractType) return false;
  //       if (f.tsSet.size  && !f.tsSet.has(r.TransportSystem))   return false;
  //       if (f.dpSet.size  && !f.dpSet.has(r.DeliveryPoint))     return false;
  //       if (f.rpSet.size  && !f.rpSet.has(r.RedeliveryPoint))   return false;
  //       if (f.matSet.size && !f.matSet.has(r.Material))         return false;
  //       if (f.nomKeyMode ===  1 && !r.NominationKey) return false;
  //       if (f.nomKeyMode === -1 &&  r.NominationKey) return false;
  //       for (const c of f.colFilters) {
  //         const rv = String(r[c.field] || '').toLowerCase();
  //         if (c.fn === 'contains'   && !rv.includes(c.val))   return false;
  //         if (c.fn === 'startswith' && !rv.startsWith(c.val)) return false;
  //         if (c.fn === 'endswith'   && !rv.endsWith(c.val))   return false;
  //         if (c.fn === '='          && rv !== c.val)          return false;
  //         if (c.fn === '!='         && rv === c.val)          return false;
  //       }
  //       return true;
  //     });
  //   }

  //   // Column-header sort — skip when the request matches the pre-sort order to avoid
  //   // copying + sorting 150K rows unnecessarily on every paginated page request.
  //   // Pre-sort for range: Gasday ASC. Pre-sort for single day: natural BNS order.
  //   const orderBy = req.query.SELECT ?.orderBy;
  //   if (orderBy ?.length) {
  //     const isPreSorted =
  //       orderBy.length === 1 &&
  //       orderBy[0].ref ?. [0] === 'Gasday' &&
  //       orderBy[0].sort !== 'desc';
  //     if (!isPreSorted) {
  //       data = [...data].sort((a, b) => {
  //         for (const ord of orderBy) {
  //           const field = ord.ref ?. [0];
  //           if (!field) continue;
  //           const va = a[field] ?? '',
  //             vb = b[field] ?? '';
  //           const na = parseFloat(va),
  //             nb = parseFloat(vb);
  //           const cmp = (!isNaN(na) && !isNaN(nb) && na !== nb) ?
  //             na - nb :
  //             _toIsoDate(va).localeCompare(_toIsoDate(vb));
  //           if (cmp !== 0) return ord.sort === 'desc' ? -cmp : cmp;
  //         }
  //         return 0;
  //       });
  //     }
  //   }

  //   // Server-side paging — the UI table requests $top rows starting at $skip
  //   const limit = req.query.SELECT.limit;
  //   const top = Number(limit ?.rows ?.val ?? limit ?.rows ?? data.length);
  //   const skip = Number(limit ?.offset ?.val ?? limit ?.offset ?? 0);
  //   const total = data.length;
  //   const page = data.slice(skip, top > 0 ? skip + top : undefined);
  //   if (req.query.SELECT.count) page.$count = total;

  //   log.info(`[READ scheduledNomData] total=${total} skip=${skip} top=${top} returned=${page.length}`);
  //   return page;
  // });


  srv.on('READ', 'scheduledNomData', req => GMSCONFIRMNOM_SRV.run(req.query));

  // ── confirmNominationSelected — unified Confirm Nomination flow ──────────
  // Frontend always sends the exact selected line items (SelectedKeys); the
  // server resolves them fresh from S/4, applies ARI004 rules automatically
  // (no client pre-flight dialog), and posts one row per S/4 call, strictly
  // sequential. Every confirm — one row or thousands — runs via cds.spawn and
  // reports live progress through getConfirmNominationJobStatus; there is no
  // inline/sync fast path, deliberately: (a) the frontend then always has a
  // real jobId to poll and a progress dialog with genuine incremental
  // progress to show, regardless of selection size, and (b) the initiating
  // HTTP request never blocks on the actual S/4 posting work, so it can never
  // hold a connection open past a gateway/app-router timeout no matter how
  // large the selection.
  srv.on('confirmNominationSelected', async req => {
    const { SelectedKeys } = req.data || {};
    if (!SelectedKeys) return req.reject(400, 'SelectedKeys is required');

    const aSelectedKeys = splitArr(SelectedKeys).map(s => {
      const [gasday, contractNo, item, versn, nominationItem] = s.split('|');
      return { gasday, contractNo, item, versn, nominationItem };
    }).filter(k => k.gasday && k.contractNo);
    if (!aSelectedKeys.length) return req.reject(400, 'No valid selected keys');

    _evictOldConfirmJobs();

    const log = cds.log('confirmNominationSelected');
    const tStart = Date.now();
    const jobId = crypto.randomUUID();

    _confirmJobs.set(jobId, {
      jobId,
      status: 'SUBMITTED',
      requestedItems: aSelectedKeys.length,
      totalItems: 0,
      totalContracts: 0,
      processedItems: 0,
      processedContracts: 0,
      confirmedItems: 0,
      rejectedItems: 0,
      failedItems: 0,
      cappedItems: 0,
      rtcItems: 0,
      linkedPendingItems: 0,
      staleSkippedItems: 0,
      lockedItems: 0,
      preConfirmedItems: 0,
      startedAt: new Date(),
      completedAt: null,
      errorMessage: null,
      rejectedSamples: [],
      s4ErrorSamples: [],
      linkedPendingSamples: [],
      staleSkippedSamples: [],
      cappedSamples: [],
      rtcSamples: [],
      lockedSamples: [],
      preConfirmedSamples: [],
      toReturn: []
    });

    let aResolved, aEligible, staleSkippedItems, sFoundKeys;
    try {
      ({ aResolved, aEligible, staleSkippedItems, sFoundKeys } =
        await _resolveSelectedEligibleRows(aSelectedKeys, GMSCONFIRMNOM_SRV));
    } catch (err) {
      log.error(`[confirmNominationSelected] jobId=${jobId} row resolution failed`, err);
      _setJobStatus(jobId, {
        status: 'FAILED',
        errorMessage: err.message || 'Failed to resolve rows',
        completedAt: new Date()
      });
      return _confirmJobs.get(jobId);
    }

    // Stale samples cover both "not found on fresh re-fetch" and "found but no
    // longer confirm-required" (confirmed elsewhere between load and press).
    const staleSkippedSamples = [];
    const sEligibleKeys = new Set(aEligible.map(_rowKeyBE));
    for (const k of aSelectedKeys) {
      const sKey = `${k.gasday}|${k.contractNo}|${k.item}|${k.versn}|${k.nominationItem}`;
      if (sEligibleKeys.has(sKey)) continue;
      _pushSample(staleSkippedSamples, {
        ContractNo: k.contractNo,
        Message: sFoundKeys.has(sKey)
          ? 'Already confirmed elsewhere — skipped.'
          : 'Not found on fresh re-fetch — may have changed or been removed.'
      });
    }
    _setJobStatus(jobId, { staleSkippedItems, staleSkippedSamples });

    // Set totalItems/totalContracts before spawning — cds.spawn queues a new
    // transaction, so the client's first poll could otherwise land before
    // _processConfirmSelectedRows gets a chance to set them itself.
    _setJobStatus(jobId, {
      totalItems: aEligible.length,
      totalContracts: new Set(aEligible.map(r => String(r.ContractNo))).size
    });
    cds.spawn({ tenant: req.tenant, user: req.user }, async () => {
      await _processConfirmSelectedRows(jobId, aResolved, aEligible, igmsConfigMetaData, GMSCONFIRMNOM_SRV, log, tStart);
    });

    return { jobId, status: 'SUBMITTED' };
  });

  // ── getConfirmNominationJobStatus — poll endpoint for confirmNominationSelected ──
  srv.on('getConfirmNominationJobStatus', async req => {
    const { jobId } = req.data || {};
    const job = jobId && _confirmJobs.get(jobId);
    if (!job) {
      return { jobId: jobId || '', status: 'NOT_FOUND' };
    }
    return job;
  });

  // ── getConfirmNominationAuth — button-level authorization for Confirm Nomination ──
  // Display-only; confirmNominationSelected itself enforces the same scope via
  // @requires independently, so hiding the button here is never the security boundary.
  // TEMP (demo): role check disabled — button always shown. Restore the block below afterwards.
  // srv.on('getConfirmNominationAuth', req => ({
  //   canConfirmNomination: req.user.is('BalancingScheduling-ConfirmNomination-Button')
  // }));
  srv.on('getConfirmNominationAuth', () => ({
    canConfirmNomination: true
  }));


  srv.on('READ', 'ConversionRequest', req => GMSCONFIRMNOM_SRV.run(req.query));
  srv.on('CREATE', 'quantityConversion', req => GMSCONFIRMNOM_SRV.run(req.query));
  srv.on('READ', 'ConversionItem', req => GMSCONFIRMNOM_SRV.run(req.query));


  const GMSSCADAAPI_SRV = await cds.connect.to("GMSSCADAAPI_SRV");
  srv.on('READ', 'ScadaFieldSet', req => GMSSCADAAPI_SRV.run(req.query));
  srv.on('READ', 'ScadaUploadSet', req => GMSSCADAAPI_SRV.run(req.query));

  srv.on('CREATE', 'uploadSCADAReading', async (req) => {
    const log = cds.log('uploadSCADAReading');
    const items = req.data?.to_scadaitems || [];
    if (!items.length) return req.reject(400, 'No items provided');

    const toDateOnly = v => v ? String(v).substring(0, 10) : "";
    const toNum = v => parseFloat(v) || 0;

    const gasdayArr = [...new Set(items.map(i => toDateOnly(i.Gasday)))];

    // Fetch existing records (including Versn — required key for ScadaFieldSet UPDATE)
    const existing = await GMSSCADAAPI_SRV.run(
      SELECT.from('xGMSxscada_api')
        .columns('Streamid', 'Businesslocation', 'Gasday', 'Customer', 'Versn')
        .where({
          Gasday: {
            in: gasdayArr
          }
        })
    );

    // Map: "Streamid__Businesslocation__Gasday__Customer" → Versn
    const existingMap = new Map(
      existing.map(e => [
        `${e.Streamid}__${e.Businesslocation}__${toDateOnly(e.Gasday)}__${e.Customer}`,
        e.Versn || ''
      ])
    );

    const toInsert = [];
    const toUpdate = [];

    for (const item of items) {
      const key = `${item.Streamid}__${item.Businesslocation}__${toDateOnly(item.Gasday)}__${item.Customer}`;

      if (existingMap.has(key)) {
        toUpdate.push({
          ...item,
          _versn: existingMap.get(key)
        });
      } else {
        // Normalize for SAP backend deep insert
        item.Gasday = new Date(item.Gasday).toISOString();
        item.Streamflow = item.Streamflow === '+' ? 'I' : 'O';
        item.Meterreading = String(item.Meterreading);
        item.Actualgcv = String(item.Actualgcv);
        item.Actualncv = String(item.Actualncv);
        item.Averagegcv = String(item.Averagegcv);
        item.Averagencv = String(item.Averagencv);
        item.Relativehumidity = String(item.Relativehumidity);
        item.Floatingtemp = String(item.Floatingtemp);
        item.Pressure = String(item.Pressure);
        toInsert.push(item);
      }
    }

    // ── INSERT new records via deep insert ───────────────────────────────────
    let insertedResult;
    if (toInsert.length || toUpdate.length) {

      req.data.to_scadaitems = toInsert.length ? toInsert : toUpdate;

      try {
        insertedResult = await GMSSCADAAPI_SRV.run(req.query);
      } catch (error) {
        log.error('[uploadSCADAReading] Deep insert failed', error);
        return req.reject(502, 'Failed to process SCADA data in backend');
      }
    }

    return {
      status: 'SUCCESS',
      insertedCount: toInsert.length,
      skippedCount: 0,
      skippedRecords: [],
      insertedData: insertedResult?.to_scadaitems || []
    };
  });


  const SCADA_NUM_FIELDS = ['Actualgcv', 'Actualncv', 'Averagegcv', 'Averagencv', 'Meterreading', 'Relativehumidity', 'Floatingtemp', 'Pressure'];

  srv.on('READ', 'SCADAReadings', req => GMSSCADAAPI_SRV.run(req.query));

  srv.after('READ', 'SCADAReadings', data => {
    if (!data?.length) return;
    for (const row of data) {
      for (const f of SCADA_NUM_FIELDS) {
        if (row[f] !== undefined) row[f] = parseFloat(row[f]) || 0;
      }
    }
  });


  srv.on('READ', 'fetchSCADAData', async (req) => {
    const filters = extractSimpleFilters(req.query.SELECT?.where || []);
    const Gasday = filters.Gasday?.[0];

    let q = SELECT.from('xGMSxscada_api');
    if (Gasday) q = q.where({
      Gasday
    });

    const rows = await GMSSCADAAPI_SRV.run(q);
    if (!rows.length) return [];

    const map = new Map();

    for (const s of rows) {
      const loc = s.Businesslocation;
      const mr = Number(s.Meterreading || 0);
      const gcv = Number(s.Actualgcv || 0);
      const ncv = Number(s.Actualncv || 0);
      const isIn = s.Streamflow === 'I' || s.Streamflow === '+';

      if (!map.has(loc)) {
        map.set(loc, {
          Businesslocation: loc,
          Gasday: s.Gasday,
          Streamid: s.Streamid,
          Customer: s.Customer,
          Schedulematerial: s.Schedulematerial,
          Unit: s.Unit,
          Streamflow: s.Streamflow,
          totalMR: mr,
          gcvSum: gcv,
          ncvSum: ncv,
          tempSum: Number(s.Floatingtemp || 0),
          pressSum: Number(s.Pressure || 0),
          humSum: Number(s.Relativehumidity || 0),
          count: 1,
          wtGcvNum: isIn ? mr * gcv : 0,
          wtNcvNum: isIn ? mr * ncv : 0,
          netMR: isIn ? mr : -mr
        });
      } else {
        const a = map.get(loc);
        a.totalMR += mr;
        a.gcvSum += gcv;
        a.ncvSum += ncv;
        a.tempSum += Number(s.Floatingtemp || 0);
        a.pressSum += Number(s.Pressure || 0);
        a.humSum += Number(s.Relativehumidity || 0);
        a.count += 1;
        if (isIn) {
          a.wtGcvNum += mr * gcv;
          a.wtNcvNum += mr * ncv;
          a.netMR += mr;
        } else a.netMR -= mr;
      }
    }

    const f3 = v => parseFloat(v.toFixed(3));
    const f5 = v => parseFloat(v.toFixed(3));

    return Array.from(map.values()).map(a => ({
      Businesslocation: a.Businesslocation,
      Gasday: a.Gasday,
      Streamid: a.Streamid,
      Customer: a.Customer,
      Schedulematerial: a.Schedulematerial,
      Unit: a.Unit,
      Streamflow: a.Streamflow,
      Meterreading: f3(a.totalMR),
      Actualgcv: f3(a.gcvSum / a.count),
      Actualncv: f3(a.ncvSum / a.count),
      AverageWtgcv: a.netMR ? f5(a.wtGcvNum / a.netMR) : 0,
      AverageWtncv: a.netMR ? f5(a.wtNcvNum / a.netMR) : 0,
      Floatingtemp: f3(a.tempSum / a.count),
      Pressure: f3(a.pressSum / a.count),
      Relativehumidity: f3(a.humSum / a.count)
    }));
  });

  srv.on('READ', 'CREATENOMINATION', req => GMSNOMINATIONS_SRV.run(req.query));

  srv.on('READ', 'ActualDateSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualErrorSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualLocidSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualMatnrSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualNomitSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualSuccessFlowSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualSuccessSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'ActualTsystSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'I_TicketErrorLog', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'CreateTicket', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'SaveTicketData', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('CREATE', 'SaveTicketData', async req => {
    // CAP's OData v2 adapter serialises Edm.Decimal fields as strings automatically
    // when going through run(req.query). This handler is only reached from the UI
    // path where req.query is fully built by the CAP OData HTTP parser.
    const result = await GMSTICKET_API_SRV.run(req.query);

    // Invalidate the nomination cache so the next READ re-fetches SavedAllocatedQty from S4.
    const nomtk = req.data.toTicketItems?.[0]?.Nomtk;
    if (nomtk) {
      for (const [gasday, entry] of nomCache.cache) {
        if (entry.data.some(item => item.NominationKey === nomtk)) {
          nomCache.cache.delete(gasday);
          break;
        }
      }
    }
    return result;
  });
  srv.on('READ', 'TicketHeaderSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'TicketItemsSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'returnSet', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'xGMSxNOMTICKET', req => GMSTICKET_API_SRV.run(req.query));
  // Source: TktlogDetailHeadSet (execution header) with to_logtkts
  // (TktlogDetailSet) expanded for the per-ticket fields — one S/4 round trip.
  // TktlogDetailHeadSet only returns executions that have TktlogDetailSet lines;
  // older executions logged before those lines existed are not returned by it.
  srv.on('READ', 'ticketLogs', async req => {
    // Drop nav-property expand and ExecTime sort — both cause errors on some Gateway versions.
    const q = req.query;
    // Column sort/filter on the virtual Nomtk/TicketKey can't go to Gateway either —
    // it is applied here in memory. To cover ALL rows (not just one page), the whole
    // (date-range-bounded) result is fetched, then filtered, paged and counted here.
    const aOrderBy = q.SELECT.orderBy || [];
    const aVirtualSort = aOrderBy.filter(o => TICKET_LOG_VIRTUAL_FIELDS.includes(o.ref?.[0]));
    const oLimit = q.SELECT.limit;
    if (q.SELECT.orderBy) {
      q.SELECT.orderBy = q.SELECT.orderBy.filter(o =>
        o.ref?.[0] !== 'ExecTime' && !TICKET_LOG_VIRTUAL_FIELDS.includes(o.ref?.[0]));
    }
    if (q.SELECT.where) q.SELECT.where = _rewriteStatusFilter(q.SELECT.where);
    const aConjuncts = _whereConjuncts(q.SELECT.where);
    const aLocalWhere = aConjuncts.filter(_hasVirtualRef);
    if (aLocalWhere.length) {
      const aServerWhere = aConjuncts.filter(c => !_hasVirtualRef(c))
        .flatMap((c, i) => [...(i ? ['and'] : []), { xpr: c }]);
      if (aServerWhere.length) q.SELECT.where = aServerWhere;
      else delete q.SELECT.where;
    }
    const bLocal = aVirtualSort.length > 0 || aLocalWhere.length > 0;
    if (bLocal) delete q.SELECT.limit;
    delete q.SELECT.expand;
    // TicketKey/TicketItem/Nomtk/Nomit are virtual (CAP-local, populated below) —
    // xGMSxTICKET_LOGS has no such columns, so a $select including them would fail
    // the remote Gateway call. The OData response is still projected against the
    // client's original $select by the protocol adapter regardless of this.
    if (Array.isArray(q.SELECT.columns)) {
      q.SELECT.columns = q.SELECT.columns.filter(
        c => !(c.ref && TICKET_LOG_VIRTUAL_FIELDS.includes(c.ref[0]))
      );
    }
    // Re-target FROM to the external entity so CAP's OData v2 adapter can look up
    // the correct Edm.DateTime type for ExecDate and format $filter as
    // datetime'...' instead of a plain string — without this, Gateway ignores
    // the date filter and returns all rows.
    q.SELECT.from = {
      ref: ['GMSTICKET_API_SRV.TktlogDetailHeadSet']
    };
    const oLogLinesExpand = {
      ref: ['to_logtkts'],
      expand: ['Logitm', 'TicketKey', 'TicketItem', 'Nomtk', 'Nomit'].map(f => ({ ref: [f] }))
    };
    q.SELECT.columns = Array.isArray(q.SELECT.columns) && q.SELECT.columns.length
      ? [...q.SELECT.columns, oLogLinesExpand]
      : ['*', oLogLinesExpand];
    const aLogs = await GMSTICKET_API_SRV.run(q);
    _fillTicketRefsFromLogLines(aLogs);
    // Re-apply the client's own column sort (Status, Execution Date, Nomtk, TicketKey…)
    // — Gateway's order only covers the fields it was sent, and ExecTime/virtual fields
    // never are. ExecTime follows ExecDate's direction; ExecDate desc/ExecTime desc is
    // the final tie-break. In the normal (paged) path this only orders THIS page — a
    // day with more executions than one page can straddle a boundary in Gateway's order.
    aLogs.sort(_ticketLogComparator(aOrderBy));
    if (!bLocal) return aLogs;

    const aHits = aLocalWhere.length
      ? aLogs.filter(row => aLocalWhere.every(c => _evalCqn(c, row)))
      : aLogs;
    const iSkip = oLimit?.offset?.val || 0;
    const iTop = oLimit?.rows?.val;
    const aPage = aHits.slice(iSkip, iTop != null ? iSkip + iTop : undefined);
    aPage.$count = aHits.length;
    return aPage;
  });
  srv.on('READ', 'xGMSxTKTDATA', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'xGMSxTKT_EXEC_TICKETS', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'TicketedDocuments', req => GMSTICKET_API_SRV.run(req.query));
  srv.on('READ', 'xGMSxTKTDETAILS03', req => GMSTICKET_API_SRV.run(req.query));


  const YGMS_GAS_ALLOCATION_SRV = await cds.connect.to("YGMS_GAS_ALLOCATION_SRV");
  srv.on('READ', 'YGMS_ALLOCATION_GAS_DATASet', req => YGMS_GAS_ALLOCATION_SRV.run(req.query));




  const YGMS_TRANSPORT_VALUEHELP_SRV = await cds.connect.to("YGMS_TRANSPORT_VALUEHELP_SRV");

  // Tsyst and TSNAM are sap:filterable=false in the external OData V2 service, so we
  // fetch all records (applying only the filterable Vsart filter) and do text search in-memory.
  srv.on('READ', 'TransportSystem', async (req) => {
    try {
      const where = req.query.SELECT?.where;
      const vsart = _tsExtractEq(where, 'Vsart');
      const textQ = _tsExtractContains(where, ['Tsyst', 'TSNAM']);

      const cqn = SELECT.from('TransportSystemValueEntitySet').columns('Vsart', 'Tsyst', 'TSNAM');
      if (vsart) cqn.where({
        Vsart: vsart
      });

      let rows = await YGMS_TRANSPORT_VALUEHELP_SRV.run(cqn);
      if (!Array.isArray(rows)) rows = [];

      if (textQ) {
        const lo = textQ.toLowerCase();
        rows = rows.filter(r =>
          (r.Tsyst || '').toLowerCase().includes(lo) ||
          (r.TSNAM || '').toLowerCase().includes(lo)
        );
      }
      return rows;
    } catch (err) {
      req.reject(500, err.message || 'Failed to read TransportSystem');
    }
  });

  const YGMS_LOCATIONID_VH_SRV = await cds.connect.to("YGMS_LOCATIONID_VH_SRV");

  // LOCID and LOCNAME are sap:filterable=false in the external OData V2 service.
  // TSYST is the key (filterable). Fetch by TSYST filter(s), then apply text search in-memory.
  srv.on('READ', 'BusinessLocations', req => YGMS_LOCATIONID_VH_SRV.run(req.query));

  // Walks a flat CQN WHERE array and returns the value of a simple EQ predicate
  // on the given field, recursing into xpr / and / or sub-expressions.
  function _tsExtractEq(where, field) {
    if (!Array.isArray(where)) return null;
    for (let i = 0; i <= where.length - 3; i++) {
      if (where[i]?.ref?.[0] === field && where[i + 1] === '=' && where[i + 2]?.val !== undefined)
        return where[i + 2].val;
    }
    for (const item of where) {
      if (typeof item === 'string') continue;
      for (const key of ['xpr', 'and', 'or']) {
        if (item?.[key]) {
          const v = _tsExtractEq(item[key], field);
          if (v !== null) return v;
        }
      }
    }
    return null;
  }

  // Walks a CQN WHERE array and returns the search string from a contains() call
  // on any of the given fields, recursing into xpr / and / or sub-expressions.
  function _tsExtractContains(where, fields) {
    if (!Array.isArray(where)) return null;
    for (const item of where) {
      if (typeof item === 'string') continue;
      if (item?.func === 'contains' && Array.isArray(item.args) && item.args.length >= 2) {
        if (fields.includes(item.args[0]?.ref?.[0]) && item.args[1]?.val !== undefined)
          return item.args[1].val;
      }
      for (const key of ['xpr', 'and', 'or']) {
        if (item?.[key]) {
          const v = _tsExtractContains(item[key], fields);
          if (v !== null) return v;
        }
      }
    }
    return null;
  }


  // ── BNS cache helper functions ────────────────────────────────────────────────

  // Extracts the Gas Day range from a CAP CQL WHERE array.
  // Handles EQ (single day: from=to), GE+LE (BT range filter), and xpr wrappers.
  function _extractGasdayRange(where) {
    let from = null,
      to = null;

    function scan(arr) {
      for (let i = 0; i < arr.length; i++) {
        const t = arr[i];
        if (t?.xpr) {
          scan(t.xpr);
          continue;
        }
        if (t?.ref?.[0] === 'Gasday') {
          const op = arr[i + 1];
          const val = arr[i + 2]?.val;
          if (val === undefined) continue;
          if (op === '=') {
            from = String(val).substring(0, 10);
            to = from;
            i += 2;
          } else if (op === '>=') {
            from = String(val).substring(0, 10);
            i += 2;
          } else if (op === '<=') {
            to = String(val).substring(0, 10);
            i += 2;
          }
        }
      }
    }
    scan(where);
    return from ? {
      from,
      to: to || from
    } : null;
  }

  // Returns the _bnsCache entry whose Gas Day range covers the request, or null.
  function _findBNSCacheEntry(where) {
    if (!_bnsCache.size) return null;
    const range = _extractGasdayRange(where);
    if (!range) return null;
    const entry = _bnsCache.values().next().value;
    if (range.from >= entry.GasdayFrom && range.to <= entry.GasdayTo) return entry;
    return null;
  }

  // Returns the _bnsCache entry if it covers the given from/to dates, else null.
  function _getActiveBNSCache(from, to) {
    if (!_bnsCache.size) return null;
    const entry = _bnsCache.values().next().value;
    const f = String(from || '').substring(0, 10);
    const t = String(to || f).substring(0, 10);
    return (f >= entry.GasdayFrom && t <= entry.GasdayTo) ? entry : null;
  }

  function extractSimpleFilters(where) {

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

        // nested expression
        if (token?.xpr) {
          parse(token.xpr);
        }

      }

    }

    parse(where);

    return result;
  }

  // ── _parseBNSFilters — parse WHERE once into native JS structures ─────────────
  // Extracts all BNS filter conditions in a single WHERE scan. The caller then
  // runs a tight filter() loop with direct property access + Set.has() — no
  // recursive AST evaluation per row. Handles: Gasday EQ/GE/LE, ContractType EQ,
  // TransportSystem/DeliveryPoint/RedeliveryPoint/Material OR-sets, NominationKey
  // NE/EQ '', column contains()/startswith()/endswith()/EQ.
  function _parseBNSFilters(where) {
    const f = {
      gasdayFrom: '', gasdayTo: '',
      contractType: '',
      tsSet: new Set(), dpSet: new Set(), rpSet: new Set(), matSet: new Set(),
      nomKeyMode: 0, // 0 = all, 1 = NE '' (has key), -1 = EQ '' (no key)
      colFilters: []
    };
    function scan(arr) {
      for (let i = 0; i < arr.length; i++) {
        const t = arr[i];
        if (typeof t === 'string') continue; // 'and' / 'or'
        if (t?.xpr) { scan(t.xpr); continue; }
        if (t?.func) {
          const fn = (t.func || '').toLowerCase();
          const field = t.args?.[0]?.ref?.[0];
          const val = t.args?.[1]?.val;
          if (field !== undefined && val !== undefined)
            f.colFilters.push({ field, fn, val: String(val).toLowerCase() });
          continue;
        }
        if (t?.ref && arr[i + 1] && arr[i + 2]?.val !== undefined) {
          const field = t.ref[0];
          const op = arr[i + 1];
          const val = arr[i + 2].val;
          i += 2;
          switch (field) {
            case 'Gasday':
              if (op === '=') { f.gasdayFrom = f.gasdayTo = String(val).substring(0, 10); }
              else if (op === '>=') f.gasdayFrom = String(val).substring(0, 10);
              else if (op === '<=') f.gasdayTo = String(val).substring(0, 10);
              break;
            case 'ContractType': if (op === '=') f.contractType = String(val); break;
            case 'TransportSystem': if (op === '=') f.tsSet.add(String(val)); break;
            case 'DeliveryPoint': if (op === '=') f.dpSet.add(String(val)); break;
            case 'RedeliveryPoint': if (op === '=') f.rpSet.add(String(val)); break;
            case 'Material': if (op === '=') f.matSet.add(String(val)); break;
            case 'NominationKey':
              if (op === '!=' && val === '') f.nomKeyMode = 1;
              else if (op === '=' && val === '') f.nomKeyMode = -1;
              break;
            default:
              f.colFilters.push({ field, fn: op, val: String(val).toLowerCase() });
          }
        }
      }
    }
    scan(where);
    if (!f.gasdayTo) f.gasdayTo = f.gasdayFrom;
    return f;
  }

  /**
   * Evaluates a CAP CQL WHERE array as a predicate against a plain object row.
   * Handles EQ, AND, OR, and nested xpr groupings — sufficient for OData $filter
   * expressions generated by SAPUI5 Filter objects.
   */
};