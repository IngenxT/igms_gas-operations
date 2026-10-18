// ── Allocation & Ticketing — button-level authorization ──────────────────────
// Single responsibility: tell the frontend which of Simulate / Allocate & Save /
// Ticketing the current user may see. Purely a display hint — every action
// those buttons trigger (RunAllocateSave, processTicketing) carries its own
// @requires in
// allocationTicketing-service.cds and is enforced by CAP independently of what
// this returns, so the two can never drift into "UI allows it but backend
// rejects it" or vice versa — both read the same JWT roles.
module.exports = async (srv) => {
  srv.on('getAllocTicketingAuth', req => ({
    canSimulate: req.user.is('AllocTicketing-Simulate-Button'),
    canAllocateSave: req.user.is('AllocTicketing-AllocateSave-Button'),
    canTicket: req.user.is('AllocTicketing-Ticketing-Button')
  }));
};
