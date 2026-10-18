// ── Allocation & Ticketing — Scheduled Items aggregate totals ─────────────────
// Serves getNomSummary: pre-computed totals from the warm ScheduledNomItems cache,
// optionally scoped by Location / TransportSystem / Partner.
const cds = require('@sap/cds');
const nomCache = require('./nomCache');
const { resolveLocationsByTS } = require('../../utils/locationResolver');

module.exports = async (srv) => {
  const GMSVALUEHELP_SRV = await cds.connect.to('GMSVALUEHELP_SRV');

  srv.on('getNomSummary', async req => {
    const log = cds.log('getNomSummary');
    const {
      Gasday,
      LocationFilter,
      TransportSystem,
      PartnerFilter
    } = req.data;
    if (!Gasday) return req.reject(400, 'Gasday is required');

    let entry = nomCache.cache.get(Gasday);
    if (!entry) {
      log.warn(`[getNomSummary] cache miss Gasday=${Gasday} — reloading`);
      await srv.send('getScheduledNomItemsWithSCADA', {
        Gasday
      });
      entry = nomCache.cache.get(Gasday);
      if (!entry) return req.reject(502, `No data available for Gasday ${Gasday}`);
    }

    // Same Gasday/TransportSystem/DeliveryPoint/RedeliveryPoint routing as
    // getScheduledNomItemsWithSCADA — TransportSystem only resolved when
    // LocationFilter is empty, ignored otherwise. No chunking needed here:
    // computeSummary only filters the already-cached in-memory rows, not a
    // remote $filter, so there's no IN-clause length limit to protect against.
    let sEffectiveLocationFilter = LocationFilter || '';
    const tsysts = !sEffectiveLocationFilter
      ? String(TransportSystem || '').split(',').map(s => s.trim()).filter(Boolean)
      : [];
    if (tsysts.length) {
      try {
        const { deliveryLocids, redeliveryLocids } = await resolveLocationsByTS(GMSVALUEHELP_SRV, tsysts);
        sEffectiveLocationFilter = [...new Set([...deliveryLocids, ...redeliveryLocids])].join(',');
      } catch (err) {
        log.error(`[getNomSummary] locid resolution failed tsysts=[${tsysts}]`, err);
      }
    }

    const summary = nomCache.computeSummary(entry, sEffectiveLocationFilter, PartnerFilter);
    log.info(`[getNomSummary] Gasday=${Gasday} loc=${sEffectiveLocationFilter || '*'} count=${summary.TotalCount}`);
    return summary;
  });
};
