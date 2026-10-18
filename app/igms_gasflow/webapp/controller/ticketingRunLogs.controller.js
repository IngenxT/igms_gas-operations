sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/m/BusyDialog",
    "sap/base/Log",
    "com/ingenx/igmsgasflow/controller/shared/ticketDetailDialog",
    "com/ingenx/igmsgasflow/controller/shared/ticketJobResults",
    "com/ingenx/igmsgasflow/controller/allocationNTicketing/ticketDetail"
], function (Controller, JSONModel, Filter, FilterOperator, BusyDialog, Log,
    ticketDetailDialogMixin, ticketJobResultsMixin, ticketDetailMixin) {
    "use strict";

    const oLog = Log.getLogger("igms.gasflow.ticketingRunLogs");

    // S/4 pads Nomtk/Nomit with leading zeros — compare numerically so 9 sorts before 10
    const _num = v => Number(String(v || "").replace(/^0+(?=\d)/, "")) || 0;
    const _byNominationKeyItem = (a, b) => (_num(a.Nomtk) - _num(b.Nomtk)) || (_num(a.Nomit) - _num(b.Nomit));

    // Status checkbox id suffix → ProcessStatus code
    const STATUS_FILTERS = { Success: "S", Warning: "W", Error: "E", Partial: "P", NotCompleted: "N" };

    // ── Controller ──────────────────────────────────────────────────────────────
    // Results of ONE Ticketing run, opened from Allocation & Ticketing right after
    // processTicketing is submitted. The backend returns the job only to the user who
    // submitted it (S/4 logs every execution under the technical destination user), so
    // this page shows exactly the nomination items that user processed in that run.
    // Polling + row building: shared/ticketJobResults. Detail dialog + formatters:
    // shared/ticketDetailDialog. Nomination Key popup: allocationNTicketing/ticketDetail
    // (same NominationTicketsDialog the Scheduled Items table opens).
    return Controller.extend("com.ingenx.igmsgasflow.controller.ticketingRunLogs", Object.assign({

        /** Init models and attach the run route. */
        onInit: function () {
            this.getView().setModel(new JSONModel([]), "runRowsModel");
            this.getView().setModel(new JSONModel(this._emptyRunData("")), "runModel");
            this.getOwnerComponent().getRouter()
                .getRoute("RouteTicketingRunLogs")
                .attachPatternMatched(this._onRouteMatched, this);
        },

        onExit: function () {
            this._oBusyDialog?.destroy();
            this._oBusyDialog = null;
        },

        /** Load the run named in the URL. */
        _onRouteMatched: async function (oEvent) {
            const { jobId } = oEvent.getParameter("arguments");
            this._sJobId = jobId;
            this.getView().getModel("runRowsModel").setData([]);
            this.getView().getModel("runModel").setData(this._emptyRunData(jobId));
            if (jobId) await this._loadJobResults(jobId);
        },

        _emptyRunData: function (sJobId) {
            return {
                jobId: sJobId, gasday: "", tableTitle: this._getText("trlTableTitle", [0]),
                successCount: 0, warningCount: 0, errorCount: 0, pendingCount: 0
            };
        },

        _getText: function (sKey, aArgs) {
            return this.getOwnerComponent().getModel("i18n").getResourceBundle().getText(sKey, aArgs);
        },

        // ── Busy (used by the shared mixins) ─────────────────────────────────────

        _showBusy: function (sText) {
            if (!this._oBusyDialog) this._oBusyDialog = new BusyDialog();
            this._oBusyDialog.setText(sText || this._getText("trlBusy"));
            this._oBusyDialog.open();
        },

        _hideBusy: function () {
            this._oBusyDialog?.close();
        },

        /** Called by ticketJobResults once the run is resolved; oJob is null when unavailable. */
        _applyResultRows: function (aRows, sJobId, oJob) {
            const oCounts = { S: 0, W: 0, E: 0, P: 0, N: 0 };
            aRows.forEach(r => { if (oCounts[r.ProcessStatus] !== undefined) oCounts[r.ProcessStatus]++; });

            this._iTotal = aRows.length;
            // Rows of one nomination stay together: Gas Day (several runs of a Gas Day
            // range), then Nomination Key, then Nomination Item
            this.getView().getModel("runRowsModel").setData(aRows.slice().sort((a, b) =>
                String(a._gasDay || "").localeCompare(String(b._gasDay || "")) || _byNominationKeyItem(a, b)));
            this.getView().getModel("runModel").setData({
                jobId: sJobId,
                gasday: oJob?.gasday || "",
                multiDay: String(sJobId || "").includes(","),
                tableTitle: this._getText("trlTableTitle", [aRows.length]),
                successCount: oCounts.S,
                warningCount: oCounts.W + oCounts.P,
                errorCount: oCounts.E,
                pendingCount: oCounts.N
            });
            this._setAllStatusFilters(true);
            this._applyStatusFilter();
        },

        // ── Navigation / refresh ─────────────────────────────────────────────────

        onNavBack: function () {
            this.getOwnerComponent().getRouter().navTo("RouteallocationNTicketing");
        },

        /** Re-read S/4 logs for this run — fills in items whose log wasn't written yet. */
        onRefresh: async function () {
            if (!this._sJobId) return;
            try {
                await this._loadJobResults(this._sJobId);
            } catch (oErr) {
                oLog.error("Refresh failed", oErr?.message);
            }
        },

        // ── Row actions ──────────────────────────────────────────────────────────

        /** Nomination Key → every ticket of that nomination item (same popup as the Ticketing table). */
        onRunNomKeyPress: async function (oEvent) {
            const oRow = oEvent.getSource().getBindingContext("runRowsModel")?.getObject();
            if (!oRow?.Nomtk) return;
            await this._openNominationTickets({ NominationKey: oRow.Nomtk, NominationItem: oRow.Nomit });
        },

        /** Message Summary → execution detail dialog for this row. */
        onMessageSummaryLinkPress: function (oEvent) {
            const oRow = oEvent.getSource().getBindingContext("runRowsModel")?.getObject();
            if (oRow) this._openTicketDetailDialog(oRow);
        },

        // ── Status filter ────────────────────────────────────────────────────────

        onStatusFilterChange: function () {
            this._applyStatusFilter();
        },

        _setAllStatusFilters: function (bSelected) {
            Object.keys(STATUS_FILTERS).forEach(sKey => this.byId(`IdTRLFilter${sKey}`)?.setSelected(bSelected));
        },

        _applyStatusFilter: function () {
            const oBinding = this.byId("IdTRLMainTable").getBinding("rows");
            if (!oBinding) return;
            const aFilters = Object.entries(STATUS_FILTERS)
                .filter(([sKey]) => this.byId(`IdTRLFilter${sKey}`)?.getSelected())
                .map(([, sCode]) => new Filter("ProcessStatus", FilterOperator.EQ, sCode));
            oBinding.filter(aFilters.length
                ? [new Filter({ filters: aFilters, and: false })]
                : [new Filter("ProcessStatus", FilterOperator.EQ, "__NONE__")]);

            const iShown = oBinding.getLength();
            this.getView().getModel("runModel").setProperty("/tableTitle", iShown === this._iTotal
                ? this._getText("trlTableTitle", [this._iTotal])
                : this._getText("trlTableTitleFiltered", [iShown, this._iTotal]));
        }

    }, ticketDetailDialogMixin, ticketJobResultsMixin, ticketDetailMixin));
});
