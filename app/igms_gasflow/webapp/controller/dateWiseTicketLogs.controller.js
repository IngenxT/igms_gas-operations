sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/m/BusyDialog",
    "sap/m/MessageBox",
    "sap/m/MessageToast",
    "sap/ui/Device",
    "sap/ui/core/routing/History",
    "com/ingenx/igmsgasflow/utils/errorHandler",
    "com/ingenx/igmsgasflow/controller/shared/ticketDetailDialog"
], function (Controller, JSONModel, Filter, FilterOperator, BusyDialog, MessageBox, MessageToast, Device, History, ErrorHandler, ticketDetailDialogMixin) {
    "use strict";

    // ── Constants ────────────────────────────────────────────────────────────────

    const STATUS_CONFIG = {
        Success: { value: "S", state: "Success"     },
        Warning: { value: "W", state: "Warning"     },
        Error:   { value: "E", state: "Error"       },
        Partial: { value: "P", state: "Information" },
        NotCompleted: { value: "N", state: "None" }
    };

    // ── Controller ───────────────────────────────────────────────────────────────
    // RouteDateWiseTicketLogs/{logId} — one execution's own diagnostic lines, reached
    // from the general Ticket Logs list. A Ticketing run's results page is the separate
    // ticketingRunLogs view. The detail dialog (TktlogDetailHeadSet expand, grouping,
    // formatters) is shared via ./shared/ticketDetailDialog.

    return Controller.extend("com.ingenx.igmsgasflow.controller.dateWiseTicketLogs", Object.assign(
        {

        // ── Lifecycle ─────────────────────────────────────────────────────────────

        onInit: function () {
            this.getView().setModel(new JSONModel([]), "ticketLogDataModel");
            this.getView().setModel(new JSONModel({
                refId: "",
                totalCount: 0, successCount: 0, warningCount: 0, errorCount: 0, partialCount: 0
            }), "pageModel");

            this._iTotalCount = 0;

            this.getOwnerComponent().getRouter()
                .getRoute("RouteDateWiseTicketLogs")
                .attachPatternMatched(this._onRouteMatched, this);

            Device.resize.attachHandler(this._onResize, this);
        },

        onExit: function () {
            Device.resize.detachHandler(this._onResize, this);
            if (this._oBusyDialog) {
                this._oBusyDialog.destroy();
                this._oBusyDialog = null;
            }
        },

        // ── Busy Dialog ───────────────────────────────────────────────────────────

        _showBusy: function (sText) {
            if (!this._oBusyDialog) {
                this._oBusyDialog = new BusyDialog({ text: sText || "Processing your request..." });
            } else {
                this._oBusyDialog.setText(sText || "Processing your request...");
            }
            this._oBusyDialog.open();
        },

        _hideBusy: function () {
            if (this._oBusyDialog) {
                this._oBusyDialog.close();
            }
        },

        // ── Responsive ────────────────────────────────────────────────────────────

        _onResize: function () {
            const oTable = this.byId("IdDWTLMainTable");
            if (oTable) oTable.invalidate();
        },

        // ── Route ─────────────────────────────────────────────────────────────────

        _onRouteMatched: async function (oEvent) {
            const { logId, from } = oEvent.getParameter("arguments");
            // Carried back to RouteTicketLogs on onBackPress so the origin (e.g. Allocation
            // & Ticketing) survives the ticketLogs → dateWiseTicketLogs → ticketLogs round trip.
            this._sFrom = from;
            if (logId) await this._loadData(logId);
        },

        // ── Data Load ─────────────────────────────────────────────────────────────

        _loadData: async function (sExecId) {
            this._showBusy("Loading execution details…");
            try {
                const oModel = this.getOwnerComponent().getModel();
                // Single source of truth: TktlogDetailHeadSet, expanded down to the
                // per-ticket rows (to_logtkts) and each row's own docflow/errlog —
                // replaces the earlier separate xGMSxTKT_EXEC_TICKETS bind.
                const oListBinding = oModel.bindList(
                    "/TktlogDetailHeadSet",
                    null,
                    null,
                    [new Filter("ExecId", FilterOperator.EQ, sExecId)],
                    { $expand: "to_logtkts($expand=TO_DOCFLOW,TO_ERRLOG)" }
                );

                const aContexts = await oListBinding.requestContexts(0, Infinity);
                const oHead = aContexts[0]?.getObject();
                const aData = this._groupLogEntries(oHead?.to_logtkts || []);

                this._applyResultRows(aData, sExecId);
            } catch (oError) {
                ErrorHandler.handleError("Failed to load execution details", oError, ErrorHandler.SEVERITY.ERROR, true);
            } finally {
                this._hideBusy();
            }
        },

        /** Tallies Status counts, sets ticketLogDataModel/pageModel, resets status filters, refreshes the title. */
        _applyResultRows: function (aData, sRefId) {
            const counts = { S: 0, W: 0, E: 0, P: 0 };
            aData.forEach(r => {
                if (counts[r.ProcessStatus] !== undefined) counts[r.ProcessStatus]++;
            });

            this._iTotalCount = aData.length;
            this.getView().setModel(new JSONModel(aData), "ticketLogDataModel");
            this.getView().getModel("pageModel").setData({
                refId: sRefId,
                totalCount:   aData.length,
                successCount: counts.S,
                warningCount: counts.W,
                errorCount:   counts.E,
                partialCount: counts.P
            });

            this._setAllCheckboxes(true);
            this.byId("IdDWTLMainTable").getBinding("rows")?.filter([]);
            this._updateTitle(aData.length);

            if (!aData.length) {
                MessageToast.show("No ticket entries found for this execution.");
            }
        },

        // ── Navigation ────────────────────────────────────────────────────────────

        // Real history back — a forward navTo here pushed a new Ticket Logs entry, so
        // the shell Back then bounced between the two screens and never reached the tiles.
        onBackPress: function () {
            if (History.getInstance().getPreviousHash() !== undefined) {
                window.history.go(-1);
            } else {
                this.getOwnerComponent().getRouter().navTo("RouteTicketLogs", { from: this._sFrom }, true);
            }
        },

        // ── Refresh ───────────────────────────────────────────────────────────────

        onDWTLRefresh: async function () {
            try {
                const sRefId = this.getView().getModel("pageModel")?.getProperty("/refId");
                if (!sRefId) return;
                await this._loadData(sRefId);
            } catch (oError) {
                ErrorHandler.handleError("Refresh failed", oError, ErrorHandler.SEVERITY.ERROR, true);
            }
        },

        // ── Row Press (cellClick) ─────────────────────────────────────────────────

        onTicketRowPress: function (oEvent) {
            const iRowIndex = oEvent.getParameter("rowIndex");
            const oCtx = this.byId("IdDWTLMainTable").getContextByIndex(iRowIndex);
            if (!oCtx) return;

            const oRow = oCtx.getObject();
            // Detail dialog opens for every status (Success/Partial/Error/Warning) —
            // whichever of Generated Documents / Error Log tabs actually has data for
            // that row is shown; see _openTicketDetailDialog (shared/ticketDetailDialog.js).
            this._openTicketDetailDialog(oRow);
        },

        onMessageSummaryLinkPress: function (oEvent) {
            const oCtx = oEvent.getSource().getBindingContext("ticketLogDataModel");
            if (!oCtx) return;

            this._openTicketDetailDialog(oCtx.getObject());
        },

        // ── Status Filters ────────────────────────────────────────────────────────

        onDWTLStatusFilterChange: function () {
            this._applyFilters();
        },

        onDWTLSelectAll: function () {
            this._setAllCheckboxes(true);
            this._applyFilters();
        },

        onDWTLClearAll: function () {
            this._setAllCheckboxes(false);
            this._applyFilters();
        },

        _setAllCheckboxes: function (bSelected) {
            Object.keys(STATUS_CONFIG).forEach(sKey => {
                const oCb = this.byId(`IdDWTLFilter${sKey}`);
                if (oCb) oCb.setSelected(bSelected);
            });
        },

        _applyFilters: function () {
            const oTable   = this.byId("IdDWTLMainTable");
            const oBinding = oTable?.getBinding("rows");
            if (!oBinding) return;

            const aFilters = Object.entries(STATUS_CONFIG)
                .filter(([sKey]) => this.byId(`IdDWTLFilter${sKey}`)?.getSelected())
                .map(([, cfg])   => new Filter("ProcessStatus", FilterOperator.EQ, cfg.value));

            if (!aFilters.length) {
                oBinding.filter([new Filter("ProcessStatus", FilterOperator.EQ, "__NONE__")]);
                this._updateTitle(0);
            } else {
                oBinding.filter([new Filter({ filters: aFilters, and: false })]);
                this._updateTitle(oBinding.getLength());
            }
        },

        _updateTitle: function (iFiltered) {
            const oTitle = this.byId("IdDWTLTableTitle");
            if (!oTitle) return;
            const sLabel = "Ticket Execution Details";
            const sText = (iFiltered === this._iTotalCount || this._iTotalCount === 0)
                ? `${sLabel} (${this._iTotalCount})`
                : `${sLabel} (${iFiltered} of ${this._iTotalCount})`;
            oTitle.setText(sText);
        }

        },
        ticketDetailDialogMixin
    ));
});
