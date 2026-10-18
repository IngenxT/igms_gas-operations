// ── Allocation & Ticketing tile — backend entry point ────────────────────────
// Single responsibility: wire up every handler module for this tile, in the
// dependency order below (each module is independently `require`-safe; order
// here only reflects reading order, not a runtime constraint — cds.connect.to
// and require() are both idempotent/cached).
const scheduledNomItems = require('./scheduledNomItems');
const nomSummary = require('./nomSummary');
const gdaChangeDetection = require('./gdaChangeDetection');
const gdaScada = require('./gdaScada');
const authorization = require('./authorization');
const runAllocationSave = require('./runAllocationSave');
const processTicketing = require('./processTicketing');
module.exports = async (srv) => {
  await scheduledNomItems(srv);
  await nomSummary(srv);
  await gdaChangeDetection(srv);
  await gdaScada(srv);
  await authorization(srv);
  await runAllocationSave(srv);
  await processTicketing(srv);
};
