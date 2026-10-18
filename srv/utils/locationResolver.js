// srv/utils/locationResolver.js
'use strict';

const cds = require('@sap/cds');
const LOG = cds.log('locationResolver');
const { fetchAllPaged } = require('./nomSourceFetch');

const _cache   = new Map();
const CACHE_TTL = 10 * 60 * 1000; // 10 min

/** @param {string[]} tsysts @returns {string} */
const _key = tsysts => tsysts.slice().sort().join('|');

/**
 * Resolve unique DeliveryPoint and RedeliveryPoint location IDs
 * for the given transport systems via xGMSxLocPoint_Map.
 * Results are TTL-cached (10 min) by sorted tsyst key.
 *
 * @param {import('@sap/cds').Service} valueHelpSvc  - connected GMSVALUEHELP_SRV
 * @param {string[]}                   tsysts         - deduplicated transport system IDs
 * @returns {Promise<{ deliveryLocids: string[], redeliveryLocids: string[] }>}
 */
const resolveLocationsByTS = async (valueHelpSvc, tsysts) => {
    if (!tsysts?.length) return { deliveryLocids: [], redeliveryLocids: [] };

    const key    = _key(tsysts);
    const cached = _cache.get(key);
    if (cached && (Date.now() - cached.ts < CACHE_TTL)) {
        LOG.info(`[locResolver] cache HIT key="${key}" dp=${cached.deliveryLocids.length} rdp=${cached.redeliveryLocids.length}`);
        return cached;
    }

    LOG.info(`[locResolver] cache MISS — querying xGMSxLocPoint_Map tsysts=[${tsysts}]`);

    // xGMSxLocPoint_Map has a compound key (Pblnr, Tsyst, Locid, Pbltyp) and no
    // Delivery_Point/Redelivery_Point filter is applied here (both flags need
    // scanning), so a busy TS can return far more rows than distinct Locids —
    // easily past Gateway's default page size. A plain .run() silently
    // truncates instead of erroring (same truncation nomSourceFetch.js's
    // fetchAllPaged exists to bypass), so use it here too rather than dropping
    // locations that happen to fall past the first page.
    const rows = await fetchAllPaged(valueHelpSvc,
        SELECT.from('xGMSxLocPoint_Map')
            .columns('Locid', 'Delivery_Point', 'Redelivery_Point')
            .where({ Tsyst: { in: tsysts } })
    );

    LOG.info(`[locResolver] xGMSxLocPoint_Map returned ${rows.length} rows`);

    const entry = {
        // unique delivery locids — rows where Delivery_Point flag is set
        deliveryLocids:   [...new Set(rows.filter(r => r.Delivery_Point).map(r => r.Locid))],
        // unique redelivery locids — rows where Redelivery_Point flag is set
        redeliveryLocids: [...new Set(rows.filter(r => r.Redelivery_Point).map(r => r.Locid))],
        ts: Date.now()
    };

    LOG.info(`[locResolver] resolved dp=${entry.deliveryLocids.length} rdp=${entry.redeliveryLocids.length}`);
    _cache.set(key, entry);
    return entry;
};

/**
 * Invalidate all cached entries (e.g. after master data change).
 */
const clearLocationCache = () => _cache.clear();

module.exports = { resolveLocationsByTS, clearLocationCache };