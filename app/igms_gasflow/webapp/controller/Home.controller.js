sap.ui.define([
    "sap/ui/core/mvc/Controller"
], (Controller) => {
    "use strict";

    return Controller.extend("com.ingenx.igmsgasflow.controller.Home", {
        onInit() {
        },

        onBalancing() {
            this.getOwnerComponent().getRouter().navTo("RouteConfirmScheduleNomination");
        },

        onAllocationNTicketing() {
            this.getOwnerComponent().getRouter().navTo("RouteallocationNTicketing");
        },

        onPressTicketLogsTile() {
            this.getOwnerComponent().getRouter().navTo("RouteTicketLogs");
        }
    });
});
