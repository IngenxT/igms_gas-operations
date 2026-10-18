sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/m/BusyDialog",
    "sap/ui/core/BusyIndicator",
    "sap/ui/model/json/JSONModel",
    "com/ingenx/igmsgasflow/controller/allocationNTicketing/formatters",
    "com/ingenx/igmsgasflow/controller/allocationNTicketing/valueHelp",
    "com/ingenx/igmsgasflow/controller/allocationNTicketing/nominationTable",
    "com/ingenx/igmsgasflow/controller/allocationNTicketing/gdaScada",
    "com/ingenx/igmsgasflow/controller/allocationNTicketing/allocationActions",
    "com/ingenx/igmsgasflow/controller/allocationNTicketing/ticketingActions",
    "com/ingenx/igmsgasflow/controller/allocationNTicketing/exportUtils",
    "com/ingenx/igmsgasflow/controller/allocationNTicketing/authorization",
    "com/ingenx/igmsgasflow/controller/allocationNTicketing/ticketDetail",
    "com/ingenx/igmsgasflow/controller/shared/ticketDetailDialog",
    "com/ingenx/igmsgasflow/controller/shared/ticketJobResults",
    "com/ingenx/igmsgasflow/utils/columnOrderPersistence"
], (
    Controller, BusyDialog, BusyIndicator, JSONModel,
    formattersMixin, valueHelpMixin, nominationTableMixin, gdaScadaMixin,
    allocationActionsMixin, ticketingActionsMixin, exportUtilsMixin, authorizationMixin,
    ticketDetailMixin, ticketDetailDialogMixin, ticketJobResultsMixin,
    ColumnOrderPersistence
) => {
    "use strict";

    // ── Allocation & Ticketing controller ─────────────────────────────────────
    // Thin orchestration layer: owns view lifecycle (onInit) and the two
    // cross-cutting busy-dialog helpers every mixin below calls into via `this`.
    // All domain logic lives in the ./allocationNTicketing/*.js mixins, merged
    // onto this same prototype so every method still runs with the controller
    // instance as `this` — identical behavior to the single-file controller
    // this replaced, just split by responsibility.
    return Controller.extend("com.ingenx.igmsgasflow.controller.allocationNTicketing", Object.assign(
        {
        onInit: function () {
            this.getOwnerComponent().getRouter()
                .getRoute("RouteallocationNTicketing")
                .attachMatched(() => BusyIndicator.hide(), this);

            const oScadaModel = new JSONModel([]);
            oScadaModel.setSizeLimit(5000);
            this.getView().setModel(oScadaModel, "scadaModel");

            const oAllocModel = new JSONModel({
                AggrAdnq: "", TotalMeteredQty: "", NomUOM: "", MeteredUOM: "",
                AggrAdnqDP: "", NomUOMDP: "", AggrAdnqRDP: "", NomUOMRDP: "",
                TotalMeteredQtyDP: "", MeteredUOMDP: "", TotalMeteredQtyRDP: "", MeteredUOMRDP: "",
                ScadaCount: "", NomCount: "", SelectedCount: "", btnState: "initial",
                // Hidden until _initButtonAuthorization resolves — fail-safe default
                canSimulate: false, canAllocateSave: false, canTicket: false,
                // True only while _fetchGdaData's fire-and-forget whole-day GDA fetch is
                // in flight — the main Go-press busy indicator clears independently of
                // this (see nominationTable._loadGasDays), so without this the
                // SCADA Measurements panel looked "ready" while still silently loading,
                // showing no rows for a variable stretch of time (network-dependent).
                gdaBusy: false
            });
            this.getView().setModel(oAllocModel, "allocationModel");
            this._initButtonAuthorization();

            // STREAM-WISE REMOVED: locationStreamsModel no longer needed
            // GDA SCADA reading models (OWN / HYBRID / THIRDPARTY / ENTRY POINT)
            ["ownModel", "hybridModel", "tpModel", "epModel"].forEach(n => {
                const m = new JSONModel([]); m.setSizeLimit(5000); this.getView().setModel(m, n);
            });
            ["ownCountModel", "hybridCountModel", "tpCountModel", "epCountModel"].forEach(n =>
                this.getView().setModel(new JSONModel({ count: "" }), n)
            );
            this.getView().setModel(new JSONModel({ hasError: false }), "hybridErrModel");
            this.getView().setModel(new JSONModel({ hasError: false }), "epErrModel");

            // ARI006 Business Rule (Reject) — parsed rule descriptors for the Scheduled
            // Items table's client-side pre-check column (see formatters.js's
            // fmtARI006Icon/State/Text and nominationTable._fetchARI006Rules).
            // Re-fetched/parsed on every Go-press, never per row/cell.
            this.getView().setModel(new JSONModel({ rules: [] }), "ari006Model");

            // Data-issue summary (Missing SCADA Reading / Missing Uploaded Qty / Missing
            // GCV,NCV from Third Party / Conversion Failures / Missing Rank / Already
            // Ticketed) — populated by every Go/Refresh fetch (see
            // nominationTable._buildDataIssues), narrowed by SCADA Measurements row
            // selection (_applyDataIssuesFilter), shown via DataIssuesDialog's panels.
            this.getView().setModel(new JSONModel({
                ReadingIssues: [], ConversionIssues: [], RankIssues: [], TicketedIssues: [], OrphanIssues: [],
                ReadingCount: 0, ConversionCount: 0, RankCount: 0, TicketedCount: 0, OrphanCount: 0, Count: 0,
                ShowContinue: false // true only while DataIssuesDialog is the pre-run Simulate/Allocate & Save confirm gate
            }), "dataIssuesModel");

            // runtime state
            this._rawReadingIssues = []; // last-fetched Missing SCADA/Uploaded Qty/GCV,NCV issues, unfiltered by GDA selection
            this._rawConvIssues    = []; // last-fetched Conversion Failures, unfiltered by GDA selection
            this._rawRankIssues    = []; // last-fetched Missing/0 Rank issues, unfiltered by GDA selection
            this._rawTicketedIssues = []; // last-fetched Already Ticketed locations, unfiltered by GDA selection
            this._rawOrphanIssues  = []; // last-fetched SCADA-reading-with-no-nomination issues, unfiltered by GDA selection
            this._excludeEntriesForRun = []; // set by allocationActions._checkDataIssuesGate when the user presses Continue past known issues
            this._rawScada = [];
            this._nomSummaryAll = null; // NomSummary from last getScheduledNomItemsWithSCADA (unfiltered)
            this._currentGasDays = []; // Gas Days loaded by the last Go (yyyy-MM-dd, date order)
            this._gdaSelectionFilter = null; // Filter built from SCADA Measurements row selection
            this._gdaSelectedRows    = [];   // Raw GDA rows currently selected (for aggregate scoping)
            // Map<"NominationKey__NominationItem" → rowData>
            // Populated at click time so data is available even after virtual-scroll unloads the row.
            this._selectedKeys = new Map();
            this._bProcessing = false;

            // Transport System VH (custom Table + JSONModel dialog, mirrors confirmScheduleNomination)
            this._oTransportVHDialog = null;
            this._oTransportVHModel = null;
            this._oTransportSelSet = null;
            this._oTransportNameMap = null;
            this._oTransportAllData = null;
            this._bTransportSyncing = false;

            // Delivery / Redelivery location VHs — keyed by LOCATION_VH_CFG type
            this._oLocVHDialog = {};
            this._oLocVHModel = {};
            this._oLocAllData = {};
            this._oLocSelSet = { delivery: new Set(), redelivery: new Set(), interconnect: new Set() };
            this._oLocNameMap = { delivery: new Map(), redelivery: new Map(), interconnect: new Map() };
            this._bLocSyncing = {};

            // Attach native paste listeners once the view has rendered.
            // valueLiveChange is not reliably fired by sap.m.MultiInput on paste
            // because SAPUI5 intercepts the DOM input event internally.
            this.getView().attachEventOnce("afterRendering", this._attachPasteHandlers, this);

            // Column arrangement — restore any previously saved order, then ask before
            // saving any future drag reorder (see columnOrderPersistence.js's own
            // header comment for why permission is asked every time, not remembered).
            // Distinct from onOpenColumnSettings/_openColumnSettings (nominationTable.js)
            // — that toggles show/hide, this is purely about column ORDER.
            const oTicketItemTbl = this.byId("IdANTTicketItemTbl");
            ColumnOrderPersistence.restoreColumnOrder(oTicketItemTbl, this.getView(), "igmsgasflow.allocationNTicketing.columnOrder");
            ColumnOrderPersistence.attachColumnOrderPersistence(oTicketItemTbl, this.getView(), "igmsgasflow.allocationNTicketing.columnOrder");
        },

        // ── Busy Dialog ──────────────────────────────────────────────────────────

        _showBusy: function (sText) {
            if (!this._oBusyDialog) {
                this._oBusyDialog = new BusyDialog({ text: sText || "Processing your request..." });
            } else {
                this._oBusyDialog.setText(sText || "Processing your request...");
            }
            this._oBusyDialog.open();
        },

        _hideBusy: function () {
            if (this._oBusyDialog) this._oBusyDialog.close();
        },

        },
        formattersMixin,
        valueHelpMixin,
        nominationTableMixin,
        gdaScadaMixin,
        allocationActionsMixin,
        ticketingActionsMixin,
        exportUtilsMixin,
        authorizationMixin,
        ticketDetailMixin,
        ticketDetailDialogMixin,
        ticketJobResultsMixin
    ));
});
