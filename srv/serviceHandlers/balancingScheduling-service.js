// srv/handlers/balancingScheduling.js
'use strict';

const cds = require('@sap/cds');
const crypto = require('crypto');
const LOG = cds.log('balancingScheduling-service');
const { resolveLocationsByTS } = require('../utils/locationResolver');
const {
    chunk: _chunk, runChunked: _runChunked, fetchAllPaged: _fetchAllPaged,
    rowKey: _rowKey, dedupeLatestVersion: _dedupeLatestVersion, normDoc: _normDoc
} = require('../utils/nomSourceFetch');
// Same ARI004 evaluation + Master Contract DCQ clubbing the Confirm Nomination
// action uses (ConfirmNomNAlloc_service.js) — reused here to project a "what
// will be approved" preview onto the table READ, so the two can never drift.
const {
    fetchARI004Rules, evaluateRowARI004, resolveMasterContractPools, fmt3, dateKey, isTrue
} = require('../utils/ari004Rules');
// Final display arrangement (Redelivery -> Corresponding -> Linked). Distinct
// from _resolveCorrespondingDocs/_resolveLinkedContracts below, which only
// FETCH rows missing from the initial filtered result — when a query already
// contains every leg (e.g. plain Gasday-only, nothing missing to fetch),
// those add nothing and S/4's native row order passes through unarranged.
const { arrangeNominationsMultiGasDay } = require('../utils/nominationRowArranger');
// GTA Right to Cure (incl. unbundled CT → GSA limits) — same evaluator the
// Confirm action uses, so the preview shows what Confirm will post.
const {
    isDcqLimitRule, resolveGtaPairs, resolveGsaLimits, pairLimits, computeRightToCure
} = require('../utils/gtaRightToCure');

// ─── tunables ────────────────────────────────────────────────────────────────
// REMOTE_PAGE / MAX_ROWS / CONCURRENCY now live in utils/nomSourceFetch.js —
// shared with the Confirm Nomination action so both consumers page S/4 identically.

const LOC_CHUNK = 50;       // values per remote $filter chunk
const CACHE_TTL_MS = 30000;    // merged-result snapshot lifetime (ms)
const CACHE_MAX = 2;        // 150k-row snapshots ≈ 300-500MB each — keep minimal

// ═══ PERF TRACE — TEMPORARY, for analyzing the Gas Day + Go pipeline ══════════
// Stage-by-stage timing for the xGMSxNOMSOURCE before:READ/on:READ pipeline,
// logged to console as plain `console.log` (not cds.log's LOG, so it always
// prints regardless of configured log level) with a `[BNS][PERF]` prefix —
// grep for that tag to isolate this output from everything else.
//
// TO REVERT once done analyzing, either:
//   (a) flip PERF_TRACE to false below — zero overhead, code stays in place, or
//   (b) delete this whole block plus every `_perfMark(...)`/`_perfStart(...)`
//       call site — each one is a single, clearly-tagged line (search for
//       "_perf" in this file) that's safe to remove independently; nothing
//       else in the pipeline depends on them.
const PERF_TRACE = true;
/** Starts a new trace context. @returns {{t0:number, last:number}} */
const _perfStart = () => {
    const now = Date.now();
    return { t0: now, last: now };
};
/** Logs elapsed time since the last mark (and since trace start) for `label`. */
const _perfMark = (ctx, label) => {
    if (!ctx) return;
    const now = Date.now();
    console.log(`[BNS][PERF] ${label} — +${now - ctx.last}ms (total ${now - ctx.t0}ms)`);
    ctx.last = now;
};
// ═══════════════════════════════════════════════════════════════════════════

// ─── CQN helpers ─────────────────────────────────────────────────────────────

/** @param {any[]} where @param {string} field @returns {string[]} */
const _extractVals = (where, field) => {
    if (!Array.isArray(where)) return [];
    const vals = [];
    for (let i = 0; i < where.length; i++) {
        const el = where[i];
        if (Array.isArray(el)) { vals.push(..._extractVals(el, field)); continue; }
        if (el?.xpr) { vals.push(..._extractVals(el.xpr, field)); continue; }
        if (el?.ref?.[0] !== field) continue;
        const op = where[i + 1], next = where[i + 2];
        if (op === '=' && next?.val != null) vals.push(String(next.val));
        if (op === 'in' && next?.list)
            next.list.forEach(v => v?.val != null && vals.push(String(v.val)));
    }
    return [...new Set(vals)].filter(Boolean);
};

/** @param {any[]} where @param {string} field @returns {boolean} */
const _hasField = (where, field) => {
    if (!Array.isArray(where)) return false;
    for (const el of where) {
        if (Array.isArray(el) && _hasField(el, field)) return true;
        if (el?.xpr && _hasField(el.xpr, field)) return true;
        if (el?.ref?.[0] === field) return true;
    }
    return false;
};

/** True when every ref in a non-empty where is `field`. @param {any[]} where @param {string} field */
const _onlyField = (where, field) => {
    if (!Array.isArray(where) || !where.length) return false;
    const _every = w => w.every(el =>
        Array.isArray(el) ? _every(el) : el?.xpr ? _every(el.xpr) : !el?.ref || el.ref[0] === field);
    return _every(where);
};

/** @param {any[]} where @param {string} field @returns {any[]} */
const _stripField =     (where, field) => {
    if (!Array.isArray(where)) return [];
    const out = [];
    for (let i = 0; i < where.length; i++) {
        const t = where[i];
        if (Array.isArray(t)) {
            const inner = _stripField(t, field);
            if (inner.length) out.push(inner);
            continue;
        }
        if (t?.xpr) {
            const inner = _stripField(t.xpr, field);
            if (inner.length) out.push({ xpr: inner });
            continue;
        }
        if (t?.ref?.[0] === field) { i += where[i + 1] === 'between' ? 4 : 2; continue; }
        out.push(t);
    }
    const clean = [];
    for (const t of out) {
        if ((t === 'and' || t === 'or') &&
            (!clean.length || clean[clean.length - 1] === 'and' || clean[clean.length - 1] === 'or'))
            continue;
        clean.push(t);
    }
    while (clean.length && (clean[0] === 'and' || clean[0] === 'or')) clean.shift();
    while (clean.length && (clean[clean.length - 1] === 'and' || clean[clean.length - 1] === 'or')) clean.pop();
    return clean;
};

// ─── shared utils ────────────────────────────────────────────────────────────

// _chunk / _runChunked / _fetchAllPaged / _rowKey now imported from
// utils/nomSourceFetch.js (see top of file) — shared with the bulk-confirm
// job handler so both consumers page and key S/4 rows identically.

// ─── TS-only Redelivery/Delivery map merge (Scenario A) — SUPERSEDED ─────────
// No longer called from on:READ xGMSxNOMSOURCE below (see that hook's own
// comment) — a TS resolving to thousands of points made this cluster's own
// per-location chunked fetch take ~10 minutes; replaced with a full-day fetch
// + in-memory location filter, the same strategy the unfiltered path already
// used. Left defined (unused) rather than deleted in this pass — flag for
// removal in a follow-up cleanup once the replacement has proven out.
// A transport system can resolve to hundreds of Delivery/Redelivery points.
// Folding them all into one $filter IN-list risks exceeding Gateway's $filter
// length limit and degrading query performance, so each point list is chunked
// to LOC_CHUNK and fetched in its own paged query (same reasoning as before).
//
// What changed from the old union-everything fetch: Redelivery and Delivery
// are now fetched and bucketed into their own ContractNo-keyed Maps, and the
// CorrespondingDocNo pairing between them is resolved right here from what's
// already in hand — no second S/4 round trip through the generic
// _resolveCorrespondingDocs lookup for this path (see the on:READ call site).
//
//  1. Redelivery rows (Gasday + RedeliveryPoint, chunked) — fetched first.
//  1.5. Those Redelivery rows' OWN CorrespondingDocNo values (a document
//     outside this TS's redelivery locations, e.g. a chained/linked contract)
//     are resolved and fetched by Gasday + ContractNo, then folded into the
//     Redelivery set BEFORE it becomes the match target for step 4 — so a
//     Delivery contract matching one of THESE extra docs isn't wrongly
//     dropped as "no match" just because it wasn't in the initial location
//     fetch. mRedelivery is bucketed (by normDoc(ContractNo)) after this.
//  2. Delivery rows (Gasday + DeliveryPoint, chunked) -> mDelivery, same key.
//  3. Delivery rows with a blank/absent CorrespondingDocNo have no parent to
//     pair with -> merged straight into the result as their own entries.
//  4. Remaining Delivery rows (CorrespondingDocNo set) -> normDoc-matched
//     against mRedelivery's keys (see nomSourceFetch.js's normDoc doc comment
//     for why exact string equality is unsafe here — ALPHA zero-padding):
//     CorrespondingDocNo on a Delivery row stores the ContractNo of its
//     Redelivery contract, so this is a direct key match, not a reverse one.
//       - match    -> pulled out of the Delivery bucket and merged into the
//                     result alongside their parent Redelivery contract
//       - no match -> dropped; it points at a contract outside this TS's own
//                     Redelivery fetch (+ step 1.5 extension), so it is out
//                     of scope here
//
// Final row order/interleaving (parent directly above its matched child) is
// not this function's job — arrangeNominationsMultiGasDay already re-sorts
// the complete merged set for display further down in the READ handler.

/**
 * @param {any[]} aGasdayWhere - CQN where tokens for the Gasday condition only
 *   (whatever shape — EQ or BETWEEN — TS/DP/RDP already stripped by the caller)
 * @param {string} sField
 * @param {string[]} aVals
 * @returns {object} CQN SELECT
 */
const _mkLocChunkQuery = (aGasdayWhere, sField, aVals) => {
    const q = SELECT.from('xGMSxNOMSOURCE');
    q.SELECT.where = [...aGasdayWhere, 'and',
        { xpr: [{ ref: [sField] }, 'in', { list: aVals.map(v => ({ val: v })) }] }];
    return q;
};

/**
 * Fetches one side (Delivery or Redelivery) in LOC_CHUNK-sized pages, matching
 * purely on location id — no row-level TransportSystem re-check. That check
 * used to run here (filtering fetched rows by `r.TransportSystem`) on the
 * theory that a location shared across TS's in xGMSxLocPoint_Map could
 * otherwise leak in rows from a different TS. It doesn't: verified against
 * live data (scheduledNomItems.js's getScheduledNomItemsWithSCADA hit the
 * same issue first) that a row's own TransportSystem field does not
 * necessarily equal the TS its Location is filed under in xGMSxLocPoint_Map —
 * a literal field match silently drops real rows (e.g. a genuine
 * RedeliveryPoint under the requested TS with a differently-coded
 * TransportSystem value), which is worse than the shared-location
 * over-inclusion it was meant to prevent. Location membership from
 * resolveLocationsByTS is the trustworthy signal; same trade-off
 * scheduledNomItems.js already made for this exact scenario.
 * @param {import('@sap/cds').Service} svc
 * @param {any[]} aGasdayWhere
 * @param {string} sField - 'DeliveryPoint' | 'RedeliveryPoint'
 * @param {string[]} aLocids
 * @returns {Promise<object[]>}
 */
const _fetchSideChunked = async (svc, aGasdayWhere, sField, aLocids) => {
    const aQueries = _chunk(aLocids, LOC_CHUNK).map(c => _mkLocChunkQuery(aGasdayWhere, sField, c));
    if (!aQueries.length) return [];
    return _runChunked(svc, aQueries);
};

/**
 * Step 1.5 — resolves the Redelivery set's OWN CorrespondingDocNo values
 * (each pointing at a contract outside this TS's redelivery locations, e.g.
 * a chained/linked document) by Gasday + ContractNo, and returns only the
 * newly-fetched rows for the caller to fold in — same "only fetch what's
 * genuinely missing" shape as _resolveCorrespondingDocs, just scoped to the
 * Redelivery-only set here instead of the full merged result.
 * @param {import('@sap/cds').Service} svc
 * @param {object[]} aRedeliveryRows
 * @returns {Promise<object[]>}
 */
const _resolveRedeliveryCorrespondingDocs = async (svc, aRedeliveryRows) => {
    const sKnownContracts = new Set();
    const sExisting = new Set();
    for (const r of aRedeliveryRows) {
        sKnownContracts.add(_normDoc(r.ContractNo));
        sExisting.add(_rowKey(r));
    }

    const mFetch = new Map();   // Gasday -> { raw, contracts: Set }
    for (const r of aRedeliveryRows) {
        const doc = _normDoc(r.CorrespondingDocNo);
        if (!doc || sKnownContracts.has(doc) || !r.Gasday) continue;
        const gd = String(r.Gasday);
        let f = mFetch.get(gd);
        if (!f) mFetch.set(gd, f = { raw: r.Gasday, contracts: new Set() });
        f.contracts.add(doc);
        // Same ALPHA zero-pad safety net _resolveCorrespondingDocs uses below —
        // ContractNo is an OData key field (zero-padded to 10 chars) while
        // CorrespondingDocNo is a plain field that can read unpadded for the
        // same document.
        if (/^\d+$/.test(doc) && doc.length < 10) f.contracts.add(doc.padStart(10, '0'));
    }
    if (!mFetch.size) return [];

    const aPairs = [...mFetch.values()].map(({ raw, contracts }) => ({ gasday: raw, contracts: [...contracts] }));
    const nCandidates = aPairs.reduce((n, p) => n + p.contracts.length, 0);
    const aExtra = await _fetchContractsByGasday(svc, aPairs, sExisting);
    LOG.info(`[BNS] rdpCorrDoc — redeliveryRows=${aRedeliveryRows.length} candidateDocs=${nCandidates} fetched=${aExtra.length}`);
    return aExtra;
};

/** @param {object[]} aRows @returns {Map<string, object[]>} keyed by normDoc(ContractNo) */
const _bucketByContract = aRows => {
    const m = new Map();
    for (const r of aRows) {
        const key = _normDoc(r.ContractNo);
        let bucket = m.get(key);
        if (!bucket) m.set(key, bucket = []);
        bucket.push(r);
    }
    return m;
};

/**
 * Restricts a result set to the selected Transport System's own Redelivery
 * Points: a row whose RedeliveryPoint is set but not in sRdp is dropped —
 * including CorrespondingDocNo/LinkContexist legs pulled in by stage 1/2,
 * which are fetched by contract number with no location gate. Rows with a
 * blank RedeliveryPoint (delivery legs) are kept, unless their
 * CorrespondingDocNo points at a contract dropped here on the same Gas Day —
 * that leg would otherwise be left orphaned without its Redelivery parent.
 * @param {object[]} aRows
 * @param {Set<string>} sRdp - the TS's redelivery locids
 * @returns {object[]}
 */
const _restrictToTsRedelivery = (aRows, sRdp) => {
    const sDropped = new Set();   // `${Gasday}|${normDoc(ContractNo)}`
    const sDroppedRdp = new Set();
    const aKept = [];
    for (const r of aRows) {
        if (r.RedeliveryPoint && !sRdp.has(r.RedeliveryPoint)) {
            sDropped.add(`${r.Gasday}|${_normDoc(r.ContractNo)}`);
            sDroppedRdp.add(r.RedeliveryPoint);
        } else {
            aKept.push(r);
        }
    }
    if (!sDropped.size) return aRows;
    const aResult = aKept.filter(r => r.RedeliveryPoint ||
        !sDropped.has(`${r.Gasday}|${_normDoc(r.CorrespondingDocNo)}`));
    LOG.info(`[BNS] TS redelivery restriction — in=${aRows.length} out=${aResult.length} droppedRdp=[${[...sDroppedRdp].slice(0, 20)}]`);
    return aResult;
};

/**
 * @param {import('@sap/cds').Service} svc
 * @param {any[]} aGasdayWhere
 * @param {string[]} deliveryLocids
 * @param {string[]} redeliveryLocids
 * @returns {Promise<object[]>}
 */
const _fetchAndMergeTsOnly = async (svc, aGasdayWhere, deliveryLocids, redeliveryLocids) => {
    // Step 1 — Redelivery side first.
    let aRedeliveryRows = await _fetchSideChunked(svc, aGasdayWhere, 'RedeliveryPoint', redeliveryLocids);

    // Step 1.5 — pull in whatever those Redelivery rows' own CorrespondingDocNo
    // points at, BEFORE bucketing — see _resolveRedeliveryCorrespondingDocs and
    // the header comment above for why this has to happen before step 4's match.
    const aRedeliveryExtra = await _resolveRedeliveryCorrespondingDocs(svc, aRedeliveryRows);
    if (aRedeliveryExtra.length) aRedeliveryRows = [...aRedeliveryRows, ...aRedeliveryExtra];

    const mRedelivery = _bucketByContract(aRedeliveryRows);

    // Step 2 — Delivery side second, bucketed by contract.
    const aDeliveryRows = await _fetchSideChunked(svc, aGasdayWhere, 'DeliveryPoint', deliveryLocids);
    const mDelivery = _bucketByContract(aDeliveryRows);

    // Steps 3/4 — merge: all Redelivery rows always in; each Delivery
    // contract is either standalone (no CorrespondingDocNo), matched into a
    // Redelivery contract already fetched, or dropped.
    const mResult = new Map();   // rowKey -> row, final dedupe against either side
    for (const r of aRedeliveryRows) mResult.set(_rowKey(r), r);

    let nStandalone = 0, nMatched = 0, nDropped = 0;
    for (const [, dpRows] of mDelivery) {
        const doc = _normDoc(dpRows[0]?.CorrespondingDocNo);
        if (!doc) {
            nStandalone += dpRows.length;
            for (const r of dpRows) mResult.set(_rowKey(r), r);
        } else if (mRedelivery.has(doc)) {
            nMatched += dpRows.length;
            for (const r of dpRows) mResult.set(_rowKey(r), r);
        } else {
            nDropped += dpRows.length;
        }
    }

    LOG.info(`[BNS] tsOnlyMerge — rdpRows=${aRedeliveryRows.length} rdpContracts=${mRedelivery.size} ` +
        `dpRows=${aDeliveryRows.length} dpContracts=${mDelivery.size} ` +
        `standalone=${nStandalone} matched=${nMatched} dropped=${nDropped} result=${mResult.size}`);
    return [...mResult.values()];
};

/**
 * Cache key for the TS-only chunked path — sel.where is Gasday-only here
 * (TS stripped, no DP/RDP ever injected into it), so the resolved locid sets
 * must be folded in explicitly to keep distinct TS filters from colliding.
 * @param {any[]} where
 * @param {{ deliveryLocids: string[], redeliveryLocids: string[] }} tsLocids
 * @returns {string}
 */
const _cacheKeyForTsLocids = (where, { deliveryLocids, redeliveryLocids }) =>
    crypto.createHash('md5')
        .update(JSON.stringify({
            w: where ?? null,
            dp: [...deliveryLocids].sort(),
            rdp: [...redeliveryLocids].sort()
        }))
        .digest('hex');

// ─── NominationItem sort ──────────────────────────────────────────────────────
// Within each (Gasday, ContractNo) group, rows must be ordered by NominationItem
// numerically ascending so that parent (NomItem=10) precedes child (NomItem=20).
// Leading zeros: '0000000010' → 10, '0000000020' → 20 (parseInt base-10).
//
// Algorithm: single-pass insertion-order Map bucketing.
// Pass 1 (O(n)): build Map<groupKey, row[]> in first-seen order.
// Pass 2 (O(n log k) where k = avg group size, typically 2-5): sort each bucket.
// Pass 3 (O(n)): emit buckets in insertion order into preallocated output.
// Total: O(n log k) ≈ O(n) for tiny k; no Uint8Array, no second full scan.

/**
 * @param {object[]} aRows
 * @returns {object[]}
 */
const _sortByNominationItem = aRows => {
    if (aRows.length < 2) return aRows;

    // Pass 1: bucket by (Gasday|ContractNo) in first-seen (insertion) order
    // Using Map preserves cross-group row order from the remote response.
    const mBucket = new Map();          // groupKey → row[]
    let bNeedsSort = false;
    for (const r of aRows) {
        const k = `${String(r.Gasday ?? '')}|${String(r.ContractNo ?? '')}`;
        let b = mBucket.get(k);
        if (!b) { mBucket.set(k, b = []); }
        else bNeedsSort = true;         // at least one group has >1 row
        b.push(r);
    }
    if (!bNeedsSort) return aRows;      // all singletons — nothing to sort

    // Pass 2: sort each multi-row bucket by NominationItem numerically
    for (const b of mBucket.values()) {
        if (b.length < 2) continue;
        b.sort((a, b) =>
            parseInt(a.NominationItem ?? '0', 10) -
            parseInt(b.NominationItem ?? '0', 10)
        );
    }

    // Pass 3: emit all buckets into preallocated output — preserves cross-group order
    const aOut = new Array(aRows.length);
    let n = 0;
    for (const b of mBucket.values())
        for (const r of b) aOut[n++] = r;

    aOut.length = n;
    return aOut;
};

/**
 * GTA Right to Cure preview — overwrites the ARI004 projection of both legs of
 * every GTA pair with what the Confirm action will post. Demand per leg is its
 * ARI004 projection (non-DCQ rules only); a DP leg whose GTA is linked to a GSA
 * takes the GSA's demand the way Confirm's linked-contract copy does (GSA shown
 * in this table → its projection; else confirmed → its ScheduledQty). An
 * unbundled CT's DP limits are its GSA's DCQ limits (resolveGsaLimits).
 * @param {object[]} aRows - rows already carrying the ARI004 projection
 * @param {{gasday:string, dp:object, rdp:object}[]} aGtaPairs
 * @param {import('@sap/cds').Service} svc
 */
const _applyProjectedRightToCure = async (aRows, aGtaPairs, svc) => {
    const mGsa = await resolveGsaLimits(svc, aGtaPairs, _fetchJoinRows);
    const mShown = new Map(aRows.map(r => [`${dateKey(r.Gasday)}|${_normDoc(r.ContractNo)}`, r]));
    // GSA's own row on the pair's gas day, for the GSA→DP demand copy — fetched
    // only for GSAs not already in this table.
    const mMissing = new Map(); // gasday → Set<GSA>
    for (const [pair, { gsa }] of mGsa) {
        if (mShown.has(`${pair.gasday}|${gsa}`)) continue;
        let set = mMissing.get(pair.gasday);
        if (!set) mMissing.set(pair.gasday, set = new Set());
        set.add(gsa.padStart(10, '0'));
    }
    const mGsaDayRow = new Map();
    for (const [gasday, set] of mMissing) {
        const aGsaRows = await _fetchAllPaged(svc, SELECT.from('xGMSxNOMSOURCE')
            .where`Gasday = ${gasday}`.where({ ContractNo: { in: [...set] } }));
        for (const r of _dedupeLatestVersion(aGsaRows)) mGsaDayRow.set(`${dateKey(r.Gasday)}|${_normDoc(r.ContractNo)}`, r);
    }
    for (const pair of aGtaPairs) {
        const { dp, rdp } = pair;
        if (dp.ProjectedStatus === 'WOULD_REJECT' && rdp.ProjectedStatus === 'WOULD_REJECT') continue;
        const oGsa = mGsa.get(pair);
        let fDpDemand = parseFloat(dp.ProjectedApprovedQty) || 0;
        if (oGsa) {
            const sKey = `${pair.gasday}|${oGsa.gsa}`;
            const oShown = mShown.get(sKey), oDayRow = mGsaDayRow.get(sKey);
            if (oShown) fDpDemand = parseFloat(oShown.ProjectedApprovedQty) || 0;
            else if (oDayRow && !isTrue(oDayRow.isConfirmRequired)) fDpDemand = parseFloat(oDayRow.ScheduledQty) || 0;
        }
        const fRdpDemand = parseFloat(rdp.ProjectedApprovedQty) || 0;
        const oRes = computeRightToCure({
            dpDemand: fDpDemand, rdpDemand: fRdpDemand, ...pairLimits(pair, new Map(), mGsa)
        });
        // Show the GSA's DCQ / Min / Max on each linked leg (DCQ columns).
        if (oGsa?.ok) {
            for (const [row, bLinked] of [[dp, oGsa.dpLinked], [rdp, oGsa.rdpLinked]]) {
                if (!bLinked) continue;
                row.LinkedGsaNo = oGsa.gsa;
                row.LinkedGsaDcq = fmt3(oGsa.dcq);
                row.LinkedGsaMinDcq = fmt3(oGsa.min);
                row.LinkedGsaMaxDcq = fmt3(oGsa.max);
            }
        }
        const sRule = oRes.scenario === 'AS_DEMANDED' ? ''
            : `RTC ${oRes.scenario}${oRes.anchor ? ` ${oRes.anchor}` : ''}` +
              (oGsa?.ok ? ` · GSA ${oGsa.gsa}` : '');
        for (const [row, fQty] of [[dp, oRes.dpSchedule], [rdp, oRes.rdpSchedule]]) {
            if (row.ProjectedStatus === 'WOULD_REJECT') continue;
            row.ProjectedApprovedQty = fmt3(fQty);
            row.ProjectedStatus = sRule ? 'CAPPED' : row.ProjectedStatus;
            row.ProjectedCapRuleId = sRule || row.ProjectedCapRuleId;
        }
    }
};

/**
 * Attaches ProjectedApprovedQty/ProjectedCapRuleId/ProjectedStatus (and the
 * LinkedGsa* DCQ limits of an unbundled CT's legs) to every row
 * — REQUIRED on every row, always, even on failure: these are `virtual` OData
 * V4 properties, and the V4 client throws ("invalid segment", breaking the
 * whole drill-down for that row) if a $select'd property is completely absent
 * from a returned row rather than present-but-null. Safe defaults are set
 * first so the keys exist even if the ARI004 evaluation below throws; the
 * real values then overwrite them on success. Called from both READ branches
 * (with and without a location filter) so behavior — and OData correctness —
 * never depends on which filter shape the caller used.
 * @param {object[]} aRows
 * @param {import('@sap/cds').Service} igmsConfigMetaData
 * @param {import('@sap/cds').Service} GMSCONFIRMNOM_SRV1
 */
const _applyProjectedFields = async (aRows, igmsConfigMetaData, GMSCONFIRMNOM_SRV1, aDayPool) => {
    if (!aRows.length) return;
    for (const row of aRows) {
        row.ProjectedStatus = null;
        row.ProjectedCapRuleId = null;
        row.ProjectedApprovedQty = null;
        row.LinkedGsaNo = null;
        row.LinkedGsaDcq = null;
        row.LinkedGsaMinDcq = null;
        row.LinkedGsaMaxDcq = null;
    }
    try {
        const aParsedRules = await fetchARI004Rules(igmsConfigMetaData);
        const mPools = await resolveMasterContractPools(aRows, GMSCONFIRMNOM_SRV1, aDayPool);
        // GTA legs skip ARI004's Min/Max DCQ rules — Right to Cure below owns them,
        // exactly as in the Confirm action.
        const { pairs: aGtaPairs } = resolveGtaPairs(aRows, aRows);
        const mGtaRowToPair = new Map();
        for (const p of aGtaPairs) { mGtaRowToPair.set(p.dp, p); mGtaRowToPair.set(p.rdp, p); }
        const aRulesNoDcq = aParsedRules.filter(rule => !isDcqLimitRule(rule));
        LOG.info(`[CAP] projection — rules=${aParsedRules.length} pools=${mPools.size} rows=${aRows.length} ` +
            `gtaPairs=${aGtaPairs.length}`);
        for (const row of aRows) {
            const aRowRules = mGtaRowToPair.has(row) ? aRulesNoDcq : aParsedRules;
            const { rejected, caps } = aRowRules.length
                ? evaluateRowARI004(row, aRowRules, mPools)
                : { rejected: false, caps: [] };
            row.ProjectedStatus = rejected ? 'WOULD_REJECT' : caps.length ? 'CAPPED' : 'OK';
            row.ProjectedCapRuleId = caps[0]?.ruleID ?? '';
            row.ProjectedApprovedQty = rejected ? '0.000'
                : caps.length ? fmt3(caps[0].value)
                    : fmt3(row.ProposedDNQ);
            // Per-row debug log — commented out (not deleted): at a few hundred
            // rows this synchronous LOG.info + JSON.stringify per row measured
            // ~19s on its own (see the PERF TRACE "ARI004 projected fields"
            // stage), dominating the whole request. Uncomment for row-by-row
            // capping diagnosis on a small, deliberately scoped dataset only.
            // LOG.info(`[CAP] projection row=${row.Gasday}|${row.ContractNo}|${row.Item}|${row.Versn}|${row.NominationItem} ` +
            //     `ProposedDNQ(raw)=${row.ProposedDNQ} caps=${JSON.stringify(caps)} → ` +
            //     `ProjectedStatus=${row.ProjectedStatus} ProjectedApprovedQty=${row.ProjectedApprovedQty}`);
        }
        if (aGtaPairs.length) await _applyProjectedRightToCure(aRows, aGtaPairs, GMSCONFIRMNOM_SRV1);
    } catch (err) {
        LOG.error('[BNS] ARI004 capping preview failed — rows returned with default projection', err);
    }
};

// ─── LINKCONT join cache ──────────────────────────────────────────────────────
// Dual-index O(1) cache shared by stage-2 merge (LINKCONT key) and client
// confirm flow (Contract_NO key). One S/4 fetch warms both consumers.
// TTL=5min: contract linkage is near-static master data.

const LINK_TTL_MS = 300000;
const _linkRows = new Map();   // 'LINKCONT|Contract_NO' → { ts, row }
const _idxByParent = new Map();   // LINKCONT    → Set<rowKey>
const _idxByChild = new Map();   // Contract_NO → Set<rowKey>

/** Store JOIN rows + maintain both indexes. @param {object[]} aJoinRows */
const _linkCachePut = aJoinRows => {
    const now = Date.now();
    for (const jr of aJoinRows) {
        const parent = String(jr.LINKCONT ?? '').trim();
        const child = String(jr.Contract_NO ?? '').trim();
        if (!parent || !child) continue;
        const k = `${parent}|${child}`;
        _linkRows.set(k, { ts: now, row: jr });
        let p = _idxByParent.get(parent);
        if (!p) _idxByParent.set(parent, p = new Set());
        p.add(k);
        let c = _idxByChild.get(child);
        if (!c) _idxByChild.set(child, c = new Set());
        c.add(k);
    }
};

/**
 * Cache lookup — evicts stale entries lazily on access.
 * @param {string[]} aKeys
 * @param {Map<string,Set<string>>} idx
 * @returns {{ hits: object[], misses: string[] }}
 */
const _linkCacheGet = (aKeys, idx) => {
    const now = Date.now(), hits = [], misses = [];
    for (const key of aKeys) {
        const rowKeys = idx.get(key);
        if (!rowKeys?.size) { misses.push(key); continue; }
        let found = false;
        for (const rk of rowKeys) {
            const e = _linkRows.get(rk);
            if (!e) { rowKeys.delete(rk); continue; }
            if (now - e.ts > LINK_TTL_MS) { _linkRows.delete(rk); rowKeys.delete(rk); continue; }
            hits.push(e.row);
            found = true;
        }
        if (!found) misses.push(key);
    }
    return { hits, misses };
};

/**
 * Cache-first JOIN lookup — S/4 hit only on cold/expired keys.
 * @param {import('@sap/cds').Service} svc
 * @param {string[]} aKeys
 * @param {'LINKCONT'|'Contract_NO'} sField
 * @returns {Promise<object[]>}
 */
const _fetchJoinRows = async (svc, aKeys, sField) => {
    if (!aKeys.length) return [];
    const idx = sField === 'LINKCONT' ? _idxByParent : _idxByChild;
    const { hits, misses } = _linkCacheGet(aKeys, idx);
    if (!misses.length) {
        LOG.info(`[BNS] linkCache — full hit field=${sField} rows=${hits.length}`);
        return hits;
    }
    const aQueries = _chunk(misses, LOC_CHUNK).map(c =>
        SELECT.from('xGMSxLINKCONT_NOMSOURCE_JOIN').where({ [sField]: { in: c } })
    );
    const aFetched = await _runChunked(svc, aQueries);
    _linkCachePut(aFetched);
    LOG.info(`[BNS] linkCache — field=${sField} hits=${hits.length} fetched=${aFetched.length}`);
    return [...hits, ...aFetched];
};

/**
 * Two-hop resolution for arrangeNominationsMultiGasDay's LinkContexist grouping.
 * Verified against live data: a row flagged LinkContexist='X' shows up as the
 * join's Contract_NO (child) side, and LINKCONT is a separate group id shared
 * by every contract in that link group (not itself a ContractNo in
 * xGMSxNOMSOURCE) — so hop 1 finds each flagged row's own group id, then hop 2
 * fetches every member of that group, including siblings that don't carry the
 * flag themselves (e.g. the corresponding delivery leg of a flagged redelivery
 * row). Both hops are cache-first via _fetchJoinRows.
 * @param {import('@sap/cds').Service} svc
 * @param {object[]} aRows
 * @returns {Promise<object[]>}
 */
const _fetchLinkGroupRows = async (svc, aRows) => {
    const sFlagged = new Set();
    for (const r of aRows) if (r.LinkContexist === 'X' && r.ContractNo) sFlagged.add(String(r.ContractNo));
    if (!sFlagged.size) return [];

    const aHop1 = await _fetchJoinRows(svc, [...sFlagged], 'Contract_NO');
    const sGroupIds = new Set();
    for (const jr of aHop1) {
        const g = String(jr.LINKCONT ?? '').trim();
        if (g) sGroupIds.add(g);
    }
    if (!sGroupIds.size) return aHop1;

    const aHop2 = await _fetchJoinRows(svc, [...sGroupIds], 'LINKCONT');
    return aHop2.length ? aHop2 : aHop1;
};

// ─── linked contract pipeline ─────────────────────────────────────────────────
// Stage 1: CorrespondingDocNo → fetch missing contracts → arrange below parent.
// Stage 2: LinkContexist='X' → JOIN → fetch missing → arrange below parent.
// Stage 2 runs on the stage-1-merged set so fetched stage-1 children are scanned.

/**
 * Fetch xGMSxNOMSOURCE rows for explicit (Gasday, ContractNo) pairs.
 * Deduped against sExisting composite-key Set before returning.
 * @param {import('@sap/cds').Service} svc
 * @param {{ gasday: any, contracts: string[] }[]} aPairs
 * @param {Set<string>} sExisting
 * @param {object[]} [aPool] - every xGMSxNOMSOURCE row for these Gas Days
 *   (unfiltered beyond Gasday). When given, contracts are looked up here instead
 *   of S/4: a contract absent from a complete day pool does not exist that day.
 * @returns {Promise<object[]>}
 */
const _fetchContractsByGasday = async (svc, aPairs, sExisting, aPool) => {
    if (!aPairs.length) return [];
    if (aPool) {
        const sWanted = new Set();
        for (const { gasday, contracts } of aPairs)
            for (const c of contracts) sWanted.add(`${gasday}|${_normDoc(c)}`);
        const aNew = aPool.filter(r => sWanted.has(`${r.Gasday}|${_normDoc(r.ContractNo)}`) &&
            !sExisting.has(_rowKey(r)));
        LOG.info(`[BNS] fetchContracts (day pool) — pairs=${aPairs.length} new=${aNew.length}`);
        return aNew;
    }
    const aQueries = [];
    for (const { gasday, contracts } of aPairs)
        for (const docs of _chunk(contracts, LOC_CHUNK))
            aQueries.push(
                SELECT.from('xGMSxNOMSOURCE')
                    .where`Gasday = ${gasday}`
                    .where({ ContractNo: { in: docs } })
            );
    const aLinked = await _runChunked(svc, aQueries);
    const aNew = aLinked.filter(r => !sExisting.has(_rowKey(r)));
    LOG.info(`[BNS] fetchContracts — pairs=${aPairs.length} fetched=${aLinked.length} new=${aNew.length}`);
    return aNew;
};

/**
 * Stage 1 — resolve children via CorrespondingDocNo field.
 * Single pass builds contract Set + existing Set + child→parent Map + fetch Map.
 * @param {import('@sap/cds').Service} svc
 * @param {object[]} aMain
 * @param {object[]} [aPool] - complete day pool, see _fetchContractsByGasday
 * @returns {Promise<{ aLinked: object[], mChildToParent: Map<string,string> }>}
 */
const _resolveCorrespondingDocs = async (svc, aMain, aPool) => {
    const EMPTY = { aLinked: [], mChildToParent: new Map() };

    const sMainContracts = new Set();
    const sExisting = new Set();
    for (const r of aMain) {
        sMainContracts.add(String(r.ContractNo));
        sExisting.add(_rowKey(r));
    }

    const mChildToParent = new Map();
    const mFetch = new Map();
    for (const r of aMain) {
        const doc = String(r.CorrespondingDocNo ?? '').trim();
        if (!doc || !r.Gasday) continue;
        const gd = String(r.Gasday);
        mChildToParent.set(`${gd}|${doc}`, `${gd}|${String(r.ContractNo)}`);
        if (sMainContracts.has(doc)) continue;
        let f = mFetch.get(gd);
        if (!f) mFetch.set(gd, f = { raw: r.Gasday, contracts: new Set() });
        f.contracts.add(doc);
        // ContractNo is an OData KEY field (String(10) — SAP Gateway ALPHA-converts/
        // zero-pads key fields to their declared length on read), while
        // CorrespondingDocNo is a plain reference field that is NOT ALPHA-converted —
        // the same document can read unpadded here (e.g. '18201229') but padded
        // ('0018201229') as a ContractNo key (same class of mismatch nomSourceFetch.js's
        // normDoc documents for YvbelnEp vs CorrespondingDocNo). Querying ContractNo IN
        // [doc] with only the unpadded value can silently miss the linked row whenever
        // it isn't already present in aMain — e.g. selecting only a Redelivery Point,
        // where the paired Delivery-leg row must be fetched here to exist at all. Add
        // the zero-padded variant as an extra candidate so the IN-list matches whichever
        // convention the live key actually uses; a non-existent extra key returns nothing
        // and is harmless.
        if (/^\d+$/.test(doc) && doc.length < 10) f.contracts.add(doc.padStart(10, '0'));
    }
    if (!mChildToParent.size) return EMPTY;

    const aPairs = [...mFetch.values()]
        .map(({ raw, contracts }) => ({ gasday: raw, contracts: [...contracts] }));

    const aLinked = await _fetchContractsByGasday(svc, aPairs, sExisting, aPool);
    LOG.info(`[BNS] corrDoc — parents=${mChildToParent.size} fetched=${aLinked.length}`);
    return { aLinked, mChildToParent };
};

/**
 * Stage 2 — resolve children for parents flagged LinkContexist='X' via JOIN.
 * Single pass builds all required structures; JOIN queried cache-first.
 * @param {import('@sap/cds').Service} svc
 * @param {object[]} aMain - stage-1-merged rows
 * @param {object[]} [aPool] - complete day pool, see _fetchContractsByGasday
 * @returns {Promise<{ aLinked: object[], mChildToParent: Map<string,string> }>}
 */
const _resolveLinkedContracts = async (svc, aMain, aPool) => {
    const EMPTY = { aLinked: [], mChildToParent: new Map() };

    const mByGasday = new Map();
    const sMainContracts = new Set();
    const sExisting = new Set();
    for (const r of aMain) {
        sMainContracts.add(String(r.ContractNo));
        sExisting.add(_rowKey(r));
        if (r.LinkContexist !== 'X' || !r.ContractNo || !r.Gasday) continue;
        const gd = String(r.Gasday);
        let e = mByGasday.get(gd);
        if (!e) mByGasday.set(gd, e = { raw: r.Gasday, parents: new Set() });
        e.parents.add(String(r.ContractNo));
    }
    if (!mByGasday.size) return EMPTY;

    // Deduplicated parent set across all gasdays → single JOIN query set
    const sAllParents = new Set();
    for (const { parents } of mByGasday.values())
        for (const p of parents) sAllParents.add(p);

    const aJoinRows = await _fetchJoinRows(svc, [...sAllParents], 'LINKCONT');
    LOG.info(`[BNS] linkCont — parents=${sAllParents.size} joinRows=${aJoinRows.length}`);
    if (!aJoinRows.length) return EMPTY;

    // Build parent→children Map in one pass; flag-check inline
    const mParentChildren = new Map();
    for (const jr of aJoinRows) {
        if (jr.linkcont_flag !== 'X') continue;
        const child = String(jr.Contract_NO ?? '').trim();
        const parent = String(jr.LINKCONT ?? '').trim();
        if (!child || !parent) continue;
        let s = mParentChildren.get(parent);
        if (!s) mParentChildren.set(parent, s = new Set());
        s.add(child);
    }
    if (!mParentChildren.size) return EMPTY;

    // Map children per gasday; collect missing for fetch — one pass
    const mChildToParent = new Map();
    const mFetch = new Map();
    for (const [gd, { raw, parents }] of mByGasday) {
        for (const parent of parents) {
            const children = mParentChildren.get(parent);
            if (!children) continue;
            for (const child of children) {
                mChildToParent.set(`${gd}|${child}`, `${gd}|${parent}`);
                if (sMainContracts.has(child)) continue;
                let f = mFetch.get(gd);
                if (!f) mFetch.set(gd, f = { raw, contracts: new Set() });
                f.contracts.add(child);
            }
        }
    }

    const aPairs = [...mFetch.values()]
        .map(({ raw, contracts }) => ({ gasday: raw, contracts: [...contracts] }));

    const aLinked = await _fetchContractsByGasday(svc, aPairs, sExisting, aPool);
    return { aLinked, mChildToParent };
};

// ─── compressed snapshot cache ────────────────────────────────────────────────
// zlib deflate reduces 150k-row JSON by ~75%; inflate on cache hit is ~5ms
// — negligible vs the 10-30s cold load it avoids.
// Node.js zlib is synchronous-capable but async preferred to avoid blocking
// the event loop during compress/decompress of large buffers.

const zlib = require('zlib');
const { promisify } = require('util');
const _deflate = promisify(zlib.deflate);
const _inflate = promisify(zlib.inflate);

const _cache = new Map();   // hash → { ts, buf: Buffer, count: number }

/** @param {object} sel @returns {string} */
// ── Column sort / search (xGMSxNOMSOURCE table) ──────────────────────────────
// Applied in memory over the final arranged result — the pipeline re-orders every
// row (Redelivery → Corresponding → Linked) after the S/4 fetch, and several
// searchable columns share fields with the screen's own filter bar, so neither can
// go to S/4. Column searches arrive as the `colFilter` custom query option (JSON
// [{f, op, v}], built by confirmScheduleNomination.controller.js), sorts as $orderby.
const NOM_COLUMN_FIELDS = new Set([
    'ContractType', 'ContractNo', 'Partner', 'TransportSystem', 'ServiceType',
    'MasterContractNo', 'DeliveryPoint', 'RedeliveryPoint', 'Material', 'Rank',
    'NominationKey', 'Source'
]);

/** Match text — lower-case, no ALPHA padding ("12345" matches "0000012345"). */
const _colText = v => String(v ?? '').trim().replace(/^0+(?=\d)/, '').toLowerCase();

/** Parses the colFilter custom query option; unknown fields/ops and bad JSON are ignored.
 *  Read from req._.req — the request's OWN http request. Inside a $batch (how the UI5
 *  table reads), req.http is inherited from the outer $batch POST, whose query string
 *  never carries a sub-request's custom options. */
const _parseColFilters = req => {
    const sRaw = req._?.req?.query?.colFilter ?? req.http?.req?.query?.colFilter;
    if (!sRaw) return [];
    try {
        const a = JSON.parse(sRaw);
        const aValid = Array.isArray(a)
            ? a.filter(c => NOM_COLUMN_FIELDS.has(c?.f) && ['contains', 'eq'].includes(c.op) && String(c.v ?? '').trim())
            : [];
        LOG.info(`[BNS] column search: ${JSON.stringify(aValid)}`);
        return aValid;
    } catch {
        LOG.warn(`[BNS] ignoring malformed colFilter: ${sRaw}`);
        return [];
    }
};

const _matchesColFilters = (row, aColFilters) => aColFilters.every(({ f, op, v }) => {
    const sRow = _colText(row[f]), sVal = _colText(v);
    return op === 'eq' ? sRow === sVal : sRow.includes(sVal);
});

/** Stable sort by a CQN orderBy — numeric-aware, blanks last in either direction. */
const _sortByColumns = (aRows, aOrderBy) => {
    const aSorts = aOrderBy.filter(o => o.ref?.[0]).map(o => ({ f: o.ref[0], desc: o.sort === 'desc' }));
    if (!aSorts.length) return aRows;
    return aRows.slice().sort((a, b) => {
        for (const { f, desc } of aSorts) {
            const x = a[f], y = b[f];
            const bxBlank = x == null || x === '', byBlank = y == null || y === '';
            if (bxBlank || byBlank) {
                if (bxBlank !== byBlank) return bxBlank ? 1 : -1;
                continue;
            }
            const c = String(x).localeCompare(String(y), undefined, { numeric: true, sensitivity: 'base' });
            if (c) return desc ? -c : c;
        }
        return 0;
    });
};

const _cacheKey = sel => crypto.createHash('md5')
    .update(JSON.stringify({
        w: sel.where ?? null,
        o: sel.orderBy ?? null,
        c: sel.columns ?? null
    }))
    .digest('hex');

/**
 * Store rows compressed. Returns immediately — compression is async.
 * @param {string} key @param {object[]} rows @returns {Promise<void>}
 */
const _cacheSet = async (key, rows) => {
    try {
        const buf = await _deflate(JSON.stringify(rows));
        if (_cache.size >= CACHE_MAX)
            _cache.delete(_cache.keys().next().value);   // evict LRU
        _cache.set(key, { ts: Date.now(), buf, count: rows.length });
        LOG.info(`[BNS] cacheSet — rows=${rows.length} compressed=${buf.length} bytes`);
    } catch (err) {
        LOG.error('[BNS] cacheSet compress failed — snapshot not stored', err);
    }
};

/**
 * Retrieve and decompress snapshot. Returns null on miss/stale/error.
 * @param {string} key @returns {Promise<object[]|null>}
 */
const _cacheGet = async key => {
    const e = _cache.get(key);
    if (!e) return null;
    if (Date.now() - e.ts > CACHE_TTL_MS) { _cache.delete(key); return null; }
    try {
        const rows = JSON.parse((await _inflate(e.buf)).toString());
        _cache.delete(key); _cache.set(key, e);   // LRU bump
        LOG.info(`[BNS] cache hit — rows=${rows.length}`);
        return rows;
    } catch (err) {
        LOG.error('[BNS] cacheGet decompress failed — treating as miss', err);
        _cache.delete(key);
        return null;
    }
};

/** Invalidate all compressed snapshots. */
const clearNomSourceCache = () => _cache.clear();

// ─────────────────────────────────────────────────────────────────────────────

module.exports = async srv => {

    const GMSCONFIRMNOM_SRV1 = await cds.connect.to('GMSCONFIRMNOM_SRV');
    const GMSVALUEHELP_SRV1 = await cds.connect.to('GMSVALUEHELP_SRV');
    const GMSNOMLOG_SRV = await cds.connect.to("GMSNOMLOG_SRV");
    const igmsConfigMetaData = await cds.connect.to('igmsConfigMetaData');
    srv.on('READ', 'ConfNomiLogSet', req => GMSNOMLOG_SRV.run(req.query));
    srv.on('READ', 'GetNominationLogs', req => GMSNOMLOG_SRV.run(req.query));

    // ─── Transport / Delivery / Redelivery value help (CSN Transport VH cascade) ──
    // Backed by LocPoint_MapSet — the frontend (confirmScheduleNomination.controller.js)
    // already sends a Tsyst filter when a transport is selected; this only adds the
    // server-side isDeliveryPoint/isRedeliveryPoint='YES' gate.
    const _appendEq = (query, field, val) => {
        const condition = [{ ref: [field] }, '=', { val }];
        query.SELECT.where = query.SELECT.where?.length
            ? [...query.SELECT.where, 'and', ...condition]
            : condition;
    };

    // LocPoint_MapSet's remote RFC handler raises a hard error instead of an
    // empty result set when a filter (e.g. a Tsyst with no redelivery point)
    // matches nothing — "No locations matched the provided criteria (or they
    // were blocked/deleted)." That's a legitimate empty answer for a value
    // help, not a failure, so swallow just that known message into []; any
    // other error (auth, timeout, malformed filter, …) still propagates so
    // it surfaces as a real error.
    const _NO_MATCH_RE = /no locations matched/i;
    const _runValueHelp = async (svc, query, sEntity) => {
        try {
            return await svc.run(query);
        } catch (err) {
            if (_NO_MATCH_RE.test(err?.message || '')) {
                LOG.info(`[CSN] ${sEntity} — no matches for current filter, returning []`);
                return [];
            }
            throw err;
        }
    };

    // Redelivery Points of the given Transport Systems, from the SAME source the
    // Redelivery Point value help (CSNRedeliveryPoint) reads — LocPoint_MapSet with
    // isRedeliveryPoint='YES' — so the table's "belongs to this TS" check agrees with
    // what the user sees in that VH. Deliberately not resolveLocationsByTS's
    // xGMSxLocPoint_Map: that entity also returns blocked/deleted TS-location
    // mappings (LocidDelind/TsystBloind/… are never filtered there), which let rows
    // at a location no longer under this TS through. Plain run() per Tsyst chunk,
    // no $skip/$top paging — the VH itself reads LocPoint_MapSet the same way.
    const _mRdpCache = new Map();   // sorted tsysts key -> { ts, set }
    const RDP_CACHE_TTL = 10 * 60 * 1000;
    const _fetchTsRedeliverySet = async tsysts => {
        const sKey = tsysts.slice().sort().join('|');
        const hit = _mRdpCache.get(sKey);
        if (hit && Date.now() - hit.ts < RDP_CACHE_TTL) return hit.set;

        const aQueries = _chunk(tsysts, LOC_CHUNK).map(c => {
            const q = SELECT.from('LocPoint_MapSet').columns('Locid');
            q.SELECT.where = [
                { ref: ['Tsyst'] }, 'in', { list: c.map(v => ({ val: v })) },
                'and', { ref: ['isRedeliveryPoint'] }, '=', { val: 'YES' }
            ];
            return q;
        });
        const aRows = [];
        for (const q of aQueries) aRows.push(...await _runValueHelp(GMSVALUEHELP_SRV1, q, 'LocPoint_MapSet'));
        const set = new Set(aRows.map(r => r.Locid).filter(Boolean));
        LOG.info(`[BNS] TS redelivery set — tsysts=${tsysts.length} rdp=${set.size}`);
        _mRdpCache.set(sKey, { ts: Date.now(), set });
        return set;
    };

    // Sentinel the frontend sends in place of a real Transport System code when the
    // user pressed Go with none selected (confirmScheduleNomination.controller.js's
    // own onSearch — defaults to every 'YA' Transport System rather than showing
    // contracts from every transport type). Resolved to the full 'YA' code list HERE,
    // server-side (see _fetchAllYATransportSystems below), instead of the frontend
    // enumerating every one of potentially 1000+ codes itself and embedding them as an
    // explicit per-code $filter — that filter's own URL/header size blew past the
    // browser/Node HTTP request-line limit (431 Request Header Fields Too Large)
    // before the request ever reached this handler. Keep in sync with the identical
    // constant in confirmScheduleNomination.controller.js.
    const TS_DEFAULT_YA = '__ALL_YA__';

    // Fetches every Transport System code classified Vsart='YA' from
    // xGMSxLocPoint_Map — the same entity CSNTransportSystem's own READ handler
    // below now queries, and the same one resolveLocationsByTS (locationResolver.js)
    // already uses to resolve a TS selection into locations, so every consumer of
    // "what counts as a YA Transport System" agrees on one source. Vsart is a
    // genuine server-side filter here (unlike on LocPoint_MapSet, which silently
    // ignores it), so no local re-filter is needed — still paged via _fetchAllPaged
    // as a safety net against silent truncation past 1000 rows, though the
    // server-side filter alone should keep this well under a single page in
    // practice.
    const _fetchAllYATransportSystems = async () => {
        const q = SELECT.from('xGMSxLocPoint_Map').columns('Tsyst');
        q.SELECT.where = [{ ref: ['Vsart'] }, '=', { val: 'YA' }];
        const data = await _fetchAllPaged(GMSVALUEHELP_SRV1, q);
        return [...new Set(data.map(r => r.Tsyst).filter(Boolean))];
    };

    // Transport System list — xGMSxLocPoint_Map, the same source Allocation &
    // Ticketing's own getAllTransportSystem uses (ConfirmNomNAlloc_service.js).
    // Delivery/Redelivery Point value help (below) stays on LocPoint_MapSet.
    srv.on('READ', 'CSNTransportSystem', async req => {
        req.query.SELECT.where = req.query.SELECT.where?.length
            ? [...req.query.SELECT.where, 'and', { ref: ['Vsart'] }, '=', { val: 'YA' }]
            : [{ ref: ['Vsart'] }, '=', { val: 'YA' }];

        // Paged via _fetchAllPaged as a safety net against silent truncation past
        // 1000 rows (xGMSxLocPoint_Map DOES honor this Vsart filter server-side,
        // unlike LocPoint_MapSet, so in practice this is a single page).
        const qUnbounded = cds.ql.clone(req.query);
        delete qUnbounded.SELECT.limit;
        const data = await _fetchAllPaged(GMSVALUEHELP_SRV1, qUnbounded);
        const aDeduped = [...new Map(data.map(item => [item.Tsyst, item])).values()];

        // This handler fully replaces the generic READ pipeline, so it must apply the
        // client's own requested window to the deduped result itself — same
        // manual-paging pattern the ScheduledNomItems READ handler uses.
        const limit = req.query.SELECT.limit;
        const top = Number(limit?.rows?.val ?? limit?.rows ?? aDeduped.length);
        const skip = Number(limit?.offset?.val ?? limit?.offset ?? 0);
        const page = aDeduped.slice(skip, top > 0 ? skip + top : undefined);
        if (req.query.SELECT.count) page.$count = aDeduped.length;
        return page;
    });

    srv.on('READ', 'CSNDeliveryPoint', req => {
        _appendEq(req.query, 'isDeliveryPoint', 'YES');
        return _runValueHelp(GMSVALUEHELP_SRV1, req.query, 'CSNDeliveryPoint');
    });

    srv.on('READ', 'CSNRedeliveryPoint', req => {
        _appendEq(req.query, 'isRedeliveryPoint', 'YES');
        return _runValueHelp(GMSVALUEHELP_SRV1, req.query, 'CSNRedeliveryPoint');
    });

    // ─── before READ — strip TS, resolve TS-only locids for chunked fetch ────

    srv.before('READ', 'xGMSxNOMSOURCE', async req => {
        const where = req.query?.SELECT?.where;
        if (!Array.isArray(where) || !where.length) return;

        // _perf carries forward into on:READ (req persists across before/on
        // hooks for one request) so the whole pipeline shows as one continuous
        // trace — see the PERF TRACE block near the top of this file.
        const _perf = PERF_TRACE ? _perfStart() : null;
        req._perf = _perf;

        let tsysts = _extractVals(where, 'TransportSystem');

        // Strip TS unconditionally — Gateway does not support this field
        req.query.SELECT.where = _stripField(where, 'TransportSystem');
        if (!tsysts.length) return;
        _perfMark(_perf, 'before:READ — TransportSystem extracted+stripped');

        // TS_DEFAULT_YA sentinel — resolve to the full 'YA' Transport System code list
        // HERE instead of trusting whatever the client sent for real codes (see the
        // sentinel's own doc comment above for why the frontend sends this instead of
        // enumerating every code itself).
        if (tsysts.length === 1 && tsysts[0] === TS_DEFAULT_YA) {
            tsysts = await _fetchAllYATransportSystems();
            _perfMark(_perf, `before:READ — TS_DEFAULT_YA resolved (${tsysts.length} 'YA' codes)`);
            if (!tsysts.length) {
                LOG.warn('[BNS] before:READ — TS_DEFAULT_YA resolved to zero \'YA\' transport systems');
                req._noLocations = true;
                return;
            }
            LOG.info(`[BNS] before:READ — TS_DEFAULT_YA resolved to ${tsysts.length} 'YA' transport system(s)`);
        } else {
            LOG.info(`[BNS] before:READ — stripped TS=[${tsysts}]`);
        }

        const hasDP = _hasField(where, 'DeliveryPoint');
        const hasRDP = _hasField(where, 'RedeliveryPoint');

        let deliveryLocids = [], redeliveryLocids = [];
        try {
            ({ deliveryLocids, redeliveryLocids } =
                await resolveLocationsByTS(GMSVALUEHELP_SRV1, tsysts));
        } catch (err) {
            LOG.error(`[BNS] locid resolution failed tsysts=[${tsysts}]`, err);
            req._noLocations = true;
            return;
        }
        _perfMark(_perf, `before:READ — resolveLocationsByTS (dp=${deliveryLocids.length} rdp=${redeliveryLocids.length})`);

        // Only rows whose RedeliveryPoint belongs to the selected TS are shown —
        // applied in on:READ over the complete result (stage 1/2 legs included),
        // for both rules below. See _restrictToTsRedelivery / _fetchTsRedeliverySet.
        try {
            req._tsRdpSet = await _fetchTsRedeliverySet(tsysts);
        } catch (err) {
            LOG.error(`[BNS] TS redelivery set failed tsysts=[${tsysts}]`, err);
            req._noLocations = true;
            return;
        }
        _perfMark(_perf, `before:READ — TS redelivery set (${req._tsRdpSet.size})`);

        // Rule 1: explicit DP/RDP present → TS stripped, DP/RDP forwarded as-is
        if (hasDP || hasRDP) {
            LOG.info('[BNS] Rule1 — TS stripped; existing DP/RDP forwarded as-is');
            return;
        }

        // Rule 2: TS-only → full-day fetch, narrowed to these locids in on:READ

        if (!deliveryLocids.length && !redeliveryLocids.length) {
            LOG.warn(`[BNS] Rule2 — no locations for TS=[${tsysts}] → empty`);
            req._noLocations = true;
            return;
        }

        // req.query.SELECT.where stays Gasday-only (TS already stripped above) —
        // on:READ fetches the WHOLE Gas Day the same single/few-page way Scenario D
        // (no TS/DP/RDP at all) already does, then filters down to this Set in JS
        // (req._tsDpSet / req._tsRdpSet below), instead of chunking the resolved DP/RDP union
        // into hundreds of small per-location $filter queries against S/4 (the old
        // _fetchAndMergeTsOnly approach, kept below but no longer called from here):
        // for a Transport System resolving to thousands of points, that many small
        // remote round trips took ~10 minutes end to end. A handful of large paged
        // fetches is dramatically faster and returns the identical rows — only how
        // many requests it takes to gather them changes.
        req._tsLocids = { deliveryLocids, redeliveryLocids };
        req._tsDpSet = new Set(deliveryLocids);

        LOG.info(`[BNS] Rule2 — TS resolved to dp=${deliveryLocids.length} rdp=${redeliveryLocids.length} locations; full-day fetch + in-memory filter`);
    });

    // ─── on READ xGMSxNOMSOURCE ──────────────────────────────────────────────

    srv.on('READ', 'xGMSxNOMSOURCE', async req => {
        if (req._noLocations) {
            LOG.warn('[BNS] xGMSxNOMSOURCE — no locations resolved, returning []');
            return [];
        }

        // req._perf was started in before:READ for the same request; falls back to
        // a fresh trace here for any caller that reaches on:READ without going
        // through before:READ's own TS branch (e.g. no TransportSystem filter at
        // all). See the PERF TRACE block near the top of this file.
        const _perf = req._perf || (PERF_TRACE ? _perfStart() : null);

        const sel = req.query.SELECT;
        const oLimit = sel.limit;
        const bTsChunked = !!req._tsLocids;   // Scenario A — TS-only, resolved via locationResolver
        // Column sort/search — applied in memory after the arrangement below (see
        // NOM_COLUMN_FIELDS). orderBy is taken off the S/4 query so every sort order
        // shares one cached snapshot.
        const aColOrderBy = sel.orderBy || [];
        delete sel.orderBy;
        const aColFilters = _parseColFilters(req);

        // Every filter shape — including plain Gasday-only (Scenario D) and
        // Gasday+isConfirmRequired with no location filter at all — runs the
        // same full-fetch + corresponding/linked-contract arrangement pipeline
        // below. A cheap server-side-paged passthrough here previously skipped
        // _resolveCorrespondingDocs/_resolveLinkedContracts entirely, returning
        // S/4's native row order (grouped by document-number range) instead of
        // each DeliveryPoint row interleaved below its RedeliveryPoint parent —
        // confirmed live: a Gasday-only request left every corresponding
        // DeliveryPoint contract trailing at the very end of the result instead
        // of directly under its RedeliveryPoint contract.
        delete sel.limit;
        const sKey = bTsChunked ? _cacheKeyForTsLocids(sel.where, req._tsLocids) : _cacheKey(sel);

        // await async decompress
        let aFull = await _cacheGet(sKey);
        _perfMark(_perf, aFull ? `on:READ — cache HIT (${aFull.length} rows)` : 'on:READ — cache MISS');
        if (!aFull) {
            // TS-only (Rule 2, req._tsLocids set) fetches the WHOLE Gas Day the
            // same way the unfiltered path does — no location $filter sent to S/4 at
            // all — then narrows to this TS's own DP/RDP union in JS. See the
            // before:READ hook's own doc comment for why (replaces the old
            // per-location chunked _fetchAndMergeTsOnly fetch, which took ~10 minutes
            // for a TS resolving to thousands of points).
            //
            // Day pool: when the S/4-side where is Gasday plus at most the segment's
            // isConfirmRequired, fetch by Gasday alone and apply isConfirmRequired in
            // memory. The pool then holds every contract on those Gas Days, so stage
            // 1/2 look up missing CorrespondingDocNo/linked legs in it instead of a
            // separate S/4 query (~8s each against xGMSxNOMSOURCE) — a contract not
            // in the pool does not exist that day. Cached under its own key, so a
            // segment switch (Not Confirmed / Confirmed / All) reuses it too.
            // Cleared on confirm via clearNomSourceCache.
            const aConfirmVals = _extractVals(sel.where, 'isConfirmRequired');
            const aDayWhere = _stripField(sel.where, 'isConfirmRequired');
            let aPool = null, aFetchedRaw;
            if (_onlyField(aDayWhere, 'Gasday')) {
                const sDayKey = 'day:' + _cacheKey({ where: aDayWhere, columns: sel.columns });
                aPool = await _cacheGet(sDayKey);
                if (!aPool) {
                    const qDay = cds.ql.clone(req.query);
                    qDay.SELECT.where = aDayWhere;
                    // IsPrimaryContract isn't in the table's $select but the ARI004
                    // Master Contract peer lookup (resolveMasterContractPools) reads it
                    // from this pool instead of its own S/4 query.
                    const aCols = qDay.SELECT.columns;
                    if (Array.isArray(aCols) && !aCols.some(c => c?.ref?.[0] === 'IsPrimaryContract' || c === '*'))
                        qDay.SELECT.columns = [...aCols, { ref: ['IsPrimaryContract'] }];
                    aPool = await _fetchAllPaged(GMSCONFIRMNOM_SRV1, qDay);
                    _cacheSet(sDayKey, aPool).catch(() => { });
                }
                aFetchedRaw = aConfirmVals.length
                    ? aPool.filter(r => aConfirmVals.includes(String(r.isConfirmRequired)))
                    : aPool;
            } else {
                aFetchedRaw = await _fetchAllPaged(GMSCONFIRMNOM_SRV1, req.query);
            }
            _perfMark(_perf, `on:READ — full-day fetch (${aFetchedRaw.length} rows${aPool ? `, day pool ${aPool.length}` : ''})`);
            const aFetched = bTsChunked
                ? aFetchedRaw.filter(r => req._tsDpSet.has(r.DeliveryPoint) || req._tsRdpSet.has(r.RedeliveryPoint))
                : aFetchedRaw;
            if (bTsChunked) _perfMark(_perf, `on:READ — in-memory TS location filter (${aFetched.length} rows)`);

            // S/4 returns one row per Versn — dedupe to the highest Versn per business
            // key before linked-contract resolution runs on this set.
            const aMain = _dedupeLatestVersion(aFetched);
            _perfMark(_perf, `on:READ — dedupe latest Versn (${aMain.length} rows)`);
            if (!aMain.length) {
                const empty = [];
                empty.$count = 0;
                return empty;
            }

            aFull = aMain;
            const aExtra = [];
            try {
                // Stage 1 (CorrespondingDocNo pairing) — runs for every path, TS-only
                // included: the TS-only fetch above is a plain Gasday-only S/4 fetch
                // filtered down to this TS's own locations in JS afterward, so —
                // unlike the old chunked-merge approach it replaces — nothing has
                // already resolved a cross-location linked leg for us.
                const s1 = await _resolveCorrespondingDocs(GMSCONFIRMNOM_SRV1, aFull, aPool);
                if (s1.aLinked.length) aExtra.push(...s1.aLinked);
                _perfMark(_perf, `on:READ — Stage1 CorrespondingDocNo resolution (+${s1.aLinked.length} rows)`);

                // Stage 2 — Linked Contract (LinkContexist='X' JOIN) — runs for every
                // path, TS-only included. Scans [...aFull, ...aExtra] so any stage-1
                // child fetched just above (e.g. a corresponding delivery leg that
                // itself flags LinkContexist) is considered too.
                const s2 = await _resolveLinkedContracts(GMSCONFIRMNOM_SRV1, [...aFull, ...aExtra], aPool);
                if (s2.aLinked.length) aExtra.push(...s2.aLinked);
                _perfMark(_perf, `on:READ — Stage2 LinkedContracts resolution (+${s2.aLinked.length} rows)`);
            } catch (err) {
                LOG.error('[BNS] linked resolution failed — partial/main result only', err);
            }
            // Resolved purely by Gasday + CorrespondingDocNo/ContractNo (see
            // _resolveCorrespondingDocs/_resolveLinkedContracts, non-TS-only path) —
            // deliberately no Transport System/Location gate there: a paired leg is
            // always pulled in regardless of which Location or TS it sits at, so the
            // confirm-time table shows both sides of a linked contract together.
            if (aExtra.length) aFull = [...aFull, ...aExtra];

            aFull = _sortByNominationItem(aFull);
            _perfMark(_perf, `on:READ — sort by NominationItem (${aFull.length} rows total)`);

            // ── Final display arrangement — Redelivery -> Corresponding -> Linked ──
            // Must run over the COMPLETE set regardless of whether anything above
            // was missing and fetched: when the initial query already contains
            // every leg (aExtra empty — e.g. plain Gasday-only), there is nothing
            // for _resolveCorrespondingDocs/_resolveLinkedContracts to interleave,
            // and S/4's native order (grouped by document-number range) would
            // otherwise pass straight through unarranged.
            try {
                const aJoinRows = await _fetchLinkGroupRows(GMSCONFIRMNOM_SRV1, aFull);
                _perfMark(_perf, `on:READ — _fetchLinkGroupRows (${aJoinRows.length} join rows)`);
                aFull = await arrangeNominationsMultiGasDay(aFull, aJoinRows);
                _perfMark(_perf, 'on:READ — arrangeNominationsMultiGasDay');
            } catch (err) {
                LOG.error('[BNS] final arrangement failed — returning unarranged merge', err);
            }

            // ── ARI004 capping preview — "what will be approved if confirmed now" ──
            // Runs once per cache-miss (same amortization the two merges above already
            // get from the 30s snapshot cache) and is stored as part of the cached
            // snapshot. Estimated as of this fetch; the confirm action always
            // recomputes fresh at posting time and is the only authoritative result —
            // see srv/utils/ari004Rules.js, the single evaluator both sides share.
            await _applyProjectedFields(aFull, igmsConfigMetaData, GMSCONFIRMNOM_SRV1, aPool);
            _perfMark(_perf, 'on:READ — ARI004 projected fields (capping preview)');

            // fire-and-forget compress + store — don't block the first-page response
            _cacheSet(sKey, aFull).catch(() => { });
        }

        // Applied after the cache, not before it: Rule 1's cache key (_cacheKey)
        // is built from the TS-stripped where and so is shared across TS selections.
        if (req._tsRdpSet) aFull = _restrictToTsRedelivery(aFull, req._tsRdpSet);

        if (aColFilters.length) aFull = aFull.filter(r => _matchesColFilters(r, aColFilters));
        aFull = _sortByColumns(aFull, aColOrderBy);

        const iTotal = aFull.length;
        let aPage;
        if (oLimit) {
            const iSkip = oLimit.offset?.val ?? 0;
            const iTop = oLimit.rows?.val ?? iTotal;
            aPage = aFull.slice(iSkip, iSkip + iTop);
            LOG.info(`[BNS] page skip=${iSkip} top=${iTop} of total=${iTotal}`);
        } else {
            aPage = aFull.slice();
        }

        aPage.$count = iTotal;
        _perfMark(_perf, `on:READ — response ready (page ${aPage.length} of total ${iTotal})`);
        // console.log(`[BNS] xGMSxNOMSOURCE — returning ${aPage.length} of ${iTotal} rows:`, aPage);
        return aPage;
    });

    // ─── on READ getLinkedContracts ───────────────────────────────────────────
    // Cache-first: stage-2 merge warms the cache during table READ, so client
    // confirm-time calls hit cache and cost zero S/4 round trips when warm.

    srv.on('READ', 'getLinkedContracts', async req => {
        const where = req.query?.SELECT?.where;
        const aChildKeys = _extractVals(where, 'Contract_NO');
        const aParentKeys = _extractVals(where, 'LINKCONT');

        if (!aChildKeys.length && !aParentKeys.length)
            return GMSCONFIRMNOM_SRV1.run(req.query);

        const aRows = aChildKeys.length
            ? await _fetchJoinRows(GMSCONFIRMNOM_SRV1, aChildKeys, 'Contract_NO')
            : await _fetchJoinRows(GMSCONFIRMNOM_SRV1, aParentKeys, 'LINKCONT');

        const aFlags = _extractVals(where, 'linkcont_flag');
        return aFlags.length
            ? aRows.filter(r => aFlags.includes(r.linkcont_flag))
            : aRows;
    });
};

module.exports.clearNomSourceCache = clearNomSourceCache;
// Exposed for allocationTicketing/scheduledNomItems.js's getScheduledNomItemsWithSCADA
// — same CorrespondingDocNo merge the table READ runs, so Allocation & Ticketing sees
// the same linked-child completeness as BNS.
module.exports.resolveCorrespondingDocs = _resolveCorrespondingDocs;
// Exposed for ConfirmNomNAlloc_service.js's LinkContexist='X' resolution
// (confirmNominationSelected) — same cache-first LINKCONT JOIN lookup the CSN
// controller's getLinkedContracts uses, keyed by either 'LINKCONT' or 'Contract_NO'.
module.exports.fetchLinkJoinRows = _fetchJoinRows;
// Exposed for ConfirmNomNAlloc_service.js's getScheduledNomItemsWithSCADA — same
// stage-2 LinkContexist='X' JOIN merge the table READ runs, so Allocation &
// Ticketing sees the same linked-contract completeness as BNS.
module.exports.resolveLinkedContracts = _resolveLinkedContracts;