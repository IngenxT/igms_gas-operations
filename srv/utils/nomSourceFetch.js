// srv/utils/nomSourceFetch.js
'use strict';

const cds = require('@sap/cds');
const LOG = cds.log('nomSourceFetch');

// ─── tunables — shared by every consumer of xGMSxNOMSOURCE bulk fetches ──────
const REMOTE_PAGE = 5000;       // $top per remote page (full-set fetch)
const MAX_ROWS    = 150000;     // hard safety cap — 120-150k production headroom
const CONCURRENCY = 5;          // parallel remote calls for chunked lookups

/**
 * Chunk array into sub-arrays of given size.
 * Pre-allocates output — avoids repeated push() overhead at 150k scale.
 * @param {any[]} arr @param {number} size @returns {any[][]}
 */
const chunk = (arr, size) => {
    const out = new Array(Math.ceil(arr.length / size));
    for (let i = 0, j = 0; i < arr.length; i += size, j++)
        out[j] = arr.slice(i, i + size);
    return out;
};

/**
 * Run CQN queries against a remote service with bounded concurrency.
 * Flattens results into one array; skips non-array pages gracefully.
 * @param {import('@sap/cds').Service} svc
 * @param {object[]} aQueries
 * @returns {Promise<object[]>}
 */
const runChunked = async (svc, aQueries) => {
    const out = [];
    for (let i = 0; i < aQueries.length; i += CONCURRENCY) {
        const pages = await Promise.all(
            aQueries.slice(i, i + CONCURRENCY).map(q => svc.run(q))
        );
        for (const p of pages) if (Array.isArray(p)) out.push(...p);
    }
    return out;
};

/**
 * Fetch the COMPLETE remote result set via explicit $skip/$top pagination.
 * Gateway default page truncation bypassed — required for 150k datasets.
 * Sequential pages (not parallel) — $skip without stable $orderby is unsafe
 * in parallel since concurrent requests may observe different sort states.
 * @param {import('@sap/cds').Service} svc
 * @param {object} query - CQN SELECT (must have no limit set by caller)
 * @returns {Promise<object[]>}
 */
const fetchAllPaged = async (svc, query) => {
    const out = [];
    for (let skip = 0; skip < MAX_ROWS; skip += REMOTE_PAGE) {
        const q = cds.ql.clone(query);
        q.SELECT.limit = { rows: { val: REMOTE_PAGE }, offset: { val: skip } };
        const page = await svc.run(q);
        if (!Array.isArray(page) || !page.length) break;
        out.push(...page);
        if (page.length < REMOTE_PAGE) break;   // last page — stop early
    }
    if (out.length >= MAX_ROWS)
        LOG.warn(`[nomSourceFetch] fetchAllPaged — hit MAX_ROWS=${MAX_ROWS}, result truncated`);
    LOG.info(`[nomSourceFetch] fetchAllPaged — total=${out.length}`);
    return out;
};

/**
 * Builds a (DeliveryPoint in [...] or RedeliveryPoint in [...]) CQN xpr.
 * @param {string[]} dpLocids @param {string[]} rdpLocids @returns {object}
 */
const buildLocFilter = (dpLocids, rdpLocids) => {
    const parts = [];
    if (dpLocids.length)
        parts.push({ xpr: [{ ref: ['DeliveryPoint'] }, 'in',
            { list: dpLocids.map(v => ({ val: v })) }] });
    if (rdpLocids.length) {
        if (parts.length) parts.push('or');
        parts.push({ xpr: [{ ref: ['RedeliveryPoint'] }, 'in',
            { list: rdpLocids.map(v => ({ val: v })) }] });
    }
    return { xpr: parts };
};

/**
 * Builds a (YybusLocation in [...]) CQN xpr — chunk callers to ~10-15 locations
 * per query (see GDA_LOC_CHUNK in scheduledNomItems.js) since the remote entity
 * may reject an unbounded IN-list the same way it rejects any $filter at all.
 * @param {string[]} locids @returns {object}
 */
const buildBusLocFilter = locids => ({
    xpr: [{ ref: ['YybusLocation'] }, 'in', { list: locids.map(v => ({ val: v })) }]
});

/**
 * Builds a (YvbelnEp in [...]) CQN xpr — chunked lookup of Entry Point GDA rows by
 * SD Document/Contract number. Entry Point readings carry no YybusLocation of their
 * own (see scheduledNomItems.js's Entry Point resolution comment), so they can't be
 * reached via buildBusLocFilter — the candidate Vbelns must come from nomination
 * data (xGMSxNOMSOURCE's own ContractNo) instead of from location.
 * @param {string[]} vbelns @returns {object}
 */
const buildVbelnFilter = vbelns => ({
    xpr: [{ ref: ['YvbelnEp'] }, 'in', { list: vbelns.map(v => ({ val: v })) }]
});

/**
 * Composite entity key — used for O(1) dedupe Sets across xGMSxNOMSOURCE rows.
 * @param {object} r @returns {string}
 */
const rowKey = r =>
    `${r.Gasday}|${r.ContractNo}|${r.Item}|${r.Versn}|${r.NominationItem}`;

/** @param {string} s @returns {string[]} */
const splitArr = s =>
    s ? [...new Set(s.split(',').map(x => x.trim()).filter(Boolean))] : [];

/**
 * Normalizes a VBELN-style document number (ContractNo/CorrespondingDocNo/YvbelnEp
 * are all CHAR10) for cross-entity comparison. SAP commonly ALPHA-converts (strips
 * leading zeros) on a KEY field but not on a plain reference field of the same
 * conceptual type — an 8-digit number like '18201514' can read as '0018201514' from
 * one source while another source for the same document reads unpadded. Invisible
 * for a 10-digit number (padding to 10 chars is a no-op there). Every document-number
 * comparison across Entry Point resolution (scheduledNomItems.js) and its GDA display
 * lookup (gdaScada.js) must use this instead of exact string equality/Map keys.
 * @param {*} v @returns {string}
 */
const normDoc = v => String(v || '').trim().replace(/^0+(?=\d)/, '');

/**
 * Collapse duplicate xGMSxNOMSOURCE rows carrying multiple Versn for the same
 * business key (Gasday+ContractNo+Item+NominationItem) — S/4 keeps one row per
 * version; only the highest Versn is the current one, older Versn rows are stale.
 * @param {object[]} rows
 * @returns {object[]}
 */
const dedupeLatestVersion = rows => {
    const latest = new Map();
    for (const r of rows) {
        const key = `${r.Gasday}|${r.ContractNo}|${r.Item}|${r.NominationItem}`;
        const prev = latest.get(key);
        if (!prev || Number(r.Versn) > Number(prev.Versn)) latest.set(key, r);
    }
    return [...latest.values()];
};

/**
 * Collapse exact duplicate rows sharing NominationKey+NominationItem+Item+ContractNo —
 * e.g. getScheduledNomItemsWithSCADA's resolveCorrespondingDocs linked-contract merge
 * (step 1a) can pull the same underlying row back in when it was already present in
 * the original xGMSxNOMSOURCE fetch, producing an exact duplicate that later collides
 * on the Location+NominationKey+NominationItem OData key. Keeps the first occurrence
 * of each key.
 * @param {object[]} rows
 * @returns {object[]}
 */
const dedupeByNomKey = rows => {
    const seen = new Set();
    const out = [];
    for (const r of rows) {
        const key = `${r.NominationKey}|${r.NominationItem}|${r.Item}|${r.ContractNo}`;
        if (seen.has(key)) continue;
        seen.add(key);
        out.push(r);
    }
    return out;
};

module.exports = {
    REMOTE_PAGE, MAX_ROWS, CONCURRENCY,
    chunk, runChunked, fetchAllPaged, buildLocFilter, buildBusLocFilter, buildVbelnFilter,
    rowKey, splitArr, dedupeLatestVersion, dedupeByNomKey, normDoc
};
