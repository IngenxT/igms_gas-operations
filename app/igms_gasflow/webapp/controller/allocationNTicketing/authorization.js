sap.ui.define([
    "sap/base/Log"
], (Log) => {
    "use strict";

    // ── Allocation & Ticketing — button-level authorization ───────────────────
    // Single responsibility: ask the backend which of Simulate / Allocate & Save /
    // Ticketing the current user may see, and set those three flags on
    // allocationModel. Display only — the backend independently enforces the
    // same roles via @requires/@restrict on every action these buttons call
    // (see allocationTicketing-service.cds), so hiding a button here is a
    // convenience, not the actual security boundary.
    return {
        /** Fetches getAllocTicketingAuth and applies it to allocationModel; defaults to all-hidden on failure. */
        _initButtonAuthorization: async function () {
            const oAllocModel = this.getView().getModel("allocationModel");
            try {
                // getOwnerComponent().getModel() — not getView().getModel(): the view's
                // default model isn't reliably propagated yet this early in onInit;
                // the component's own model is available immediately (see e.g.
                // DisplayTemplate.controller.js, capacityRelease.controller.js).
                const oCtx = this.getOwnerComponent().getModel().bindContext("/getAllocTicketingAuth(...)");
                await oCtx.execute("$direct");
                const oAuth = oCtx.getBoundContext().getObject();
                oAllocModel.setProperty("/canSimulate", !!oAuth?.canSimulate);
                oAllocModel.setProperty("/canAllocateSave", !!oAuth?.canAllocateSave);
                oAllocModel.setProperty("/canTicket", !!oAuth?.canTicket);
            } catch (oErr) {
                Log.getLogger("igms.gasflow.allocationNTicketing").error("getAllocTicketingAuth failed — hiding all action buttons", oErr);
                oAllocModel.setProperty("/canSimulate", false);
                oAllocModel.setProperty("/canAllocateSave", false);
                oAllocModel.setProperty("/canTicket", false);
            }
        }
    };
});
