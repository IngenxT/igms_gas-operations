sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/Fragment",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/ui/model/FilterType",
    "sap/ui/core/BusyIndicator",
    "sap/ui/core/ValueState",
    "sap/m/MessageBox",
    "sap/m/MessageToast",
    "sap/m/Token",
    "sap/m/Dialog",
    "sap/m/Button",
    "sap/m/CheckBox",
    "sap/m/VBox",
    "sap/m/ScrollContainer",
    "sap/ui/export/Spreadsheet",
    "sap/ui/export/EdmType",
    "sap/base/Log",
    "com/ingenx/igmsgasflow/utils/columnOrderPersistence",
], (Controller, Fragment, JSONModel, Filter, FilterOperator, FilterType, BusyIndicator, ValueState, MessageBox,
    MessageToast, Token, Dialog, Button, CheckBox, VBox, ScrollContainer, Spreadsheet, EdmType, Log,
    ColumnOrderPersistence) => {
    "use strict";

    const LOCATION_MI_IDS = ["IdCSNDeliveryMI", "IdCSNRedeliveryMI", "IdCSNInterconnectMI"];

    // Shared $select for table + paired-MC fetch — single source of truth.
    // CorrespondingDocNo + LinkContexist are REQUIRED by selection sync and
    // the linked-DNQ copy at confirm time.
    const NOMSOURCE_SELECT =
        "Gasday,ContractNo,Item,Versn,NominationItem,NominationKey,Event,ContractType," +
        "ContractTypeName,MasterContractNo,Partner,PartnerName,TransportSystem," +
        "TransportSystemName,DeliveryPoint,DeliveryPointName,RedeliveryPoint," +
        "RedeliveryPointName,Material,MaterialName,Rank,DeliveryDCQ,RedeliveryDCQ," +
        "ProposedDNQ,ApprovedDNQ,isConfirmRequired,MaxDeliveryDCQ,MinDeliveryDCQ," +
        "MaxRedeliveryDCQ,MinRedeliveryDCQ,UOM,NominationStatus,Source,ServiceType," +
        "CustomerInd,CustomerKind,CorrespondingDocNo,LinkContexist,IsPrimaryContract," +
        "MonthlyConsumptionQty,MonthlyConsumptionUom,MonthlyContractualQty," +
        "MonthlyContractualUom,MonthlyRemainingQty,MonthlyRemainingUom";

    // Sentinel sent as the TransportSystem filter value on a Go press with no
    // Transport System explicitly chosen — see onSearch's own doc comment for why
    // this is a single sentinel instead of every 'YA' code enumerated client-side.
    // Resolved server-side by the xGMSxNOMSOURCE before:READ hook
    // (balancingScheduling-service.js) — keep the literal value in sync with that
    // file's own identical constant.
    const TS_DEFAULT_YA = "__ALL_YA__";

    // Config for each location VH type — drives all generic _openLocationVH / _onLocVH* methods.
    const LOCATION_VH_CFG = {
        delivery: {
            fragName: "com.ingenx.igmsgasflow.fragments.CSNDeliveryVH",
            tableId: "IdCSNDeliveryVHTable",
            searchId: "IdCSNDeliveryVHSearch",
            inputId: "IdCSNDeliveryMI",
            entityPath: "/CSNDeliveryPoint",
            keysFn: "getAllDeliveryPointKeys",
            makeExtraFilters: () => []
        },
        redelivery: {
            fragName: "com.ingenx.igmsgasflow.fragments.CSNRedeliveryVH",
            tableId: "IdCSNRedeliveryVHTable",
            searchId: "IdCSNRedeliveryVHSearch",
            inputId: "IdCSNRedeliveryMI",
            entityPath: "/CSNRedeliveryPoint",
            keysFn: "getAllRedeliveryPointKeys",
            makeExtraFilters: () => [],
            // CSNRedeliveryPoint returns one row per Location + Transport System —
            // the VH shows each Location only once (no Transport column).
            uniqueLocid: true
        },
        interconnect: {
            fragName: "com.ingenx.igmsgasflow.fragments.CSNInterconnectVH",
            tableId: "IdCSNInterconnectVHTable",
            searchId: "IdCSNInterconnectVHSearch",
            inputId: "IdCSNInterconnectMI",
            entityPath: "/getAllDeliveryPoints",
            keysFn: "getAllInterconnectPointKeys",
            makeExtraFilters: () => [new Filter("isInterconnect", FilterOperator.EQ, "X")]
        }
    };

    // ── Excel export column definitions ──────────────────────────────────────
    // Mirrors all table columns. Both Delivery and Redelivery side-specific
    // fields are included as separate columns so analysts can work with raw data.
    const _EXPORT_COLS = [
        { label: "Gas Day", property: "Gasday", type: EdmType.String },
        { label: "Contract Type", property: "ContractType", type: EdmType.String },
        { label: "Contract No", property: "ContractNo", type: EdmType.String },
        { label: "Item", property: "Item", type: EdmType.String },
        { label: "Version", property: "Versn", type: EdmType.String },
        { label: "Contract Type Desc.", property: "ContractTypeName", type: EdmType.String },
        { label: "Master Contract", property: "MasterContractNo", type: EdmType.String },
        { label: "Service Type", property: "ServiceType", type: EdmType.String },
        { label: "Transport System", property: "TransportSystem", type: EdmType.String },
        { label: "Transport System Name", property: "TransportSystemName", type: EdmType.String },
        { label: "Partner No", property: "Partner", type: EdmType.String },
        { label: "Partner Name", property: "PartnerName", type: EdmType.String },
        { label: "Delivery Point", property: "DeliveryPoint", type: EdmType.String },
        { label: "Delivery Point Name", property: "DeliveryPointName", type: EdmType.String },
        { label: "Redelivery Point", property: "RedeliveryPoint", type: EdmType.String },
        { label: "Redelivery Point Name", property: "RedeliveryPointName", type: EdmType.String },
        { label: "Material", property: "Material", type: EdmType.String },
        { label: "Material Name", property: "MaterialName", type: EdmType.String },
        { label: "UOM", property: "UOM", type: EdmType.String },
        { label: "Rank", property: "Rank", type: EdmType.String },
        { label: "Nomination Item", property: "NominationItem", type: EdmType.String },
        { label: "Nomination Key", property: "NominationKey", type: EdmType.String },
        { label: "Delivery DCQ", property: "DeliveryDCQ", type: EdmType.Number, scale: 3 },
        { label: "Max Delivery DCQ", property: "MaxDeliveryDCQ", type: EdmType.Number, scale: 3 },
        { label: "Min Delivery DCQ", property: "MinDeliveryDCQ", type: EdmType.Number, scale: 3 },
        { label: "Redelivery DCQ", property: "RedeliveryDCQ", type: EdmType.Number, scale: 3 },
        { label: "Max Redelivery DCQ", property: "MaxRedeliveryDCQ", type: EdmType.Number, scale: 3 },
        { label: "Min Redelivery DCQ", property: "MinRedeliveryDCQ", type: EdmType.Number, scale: 3 },
        { label: "Proposed DNQ", property: "ProposedDNQ", type: EdmType.Number, scale: 3 },
        { label: "Approved DNQ", property: "ApprovedDNQ", type: EdmType.Number, scale: 3 },
        { label: "Projected Approved Qty", property: "ProjectedApprovedQty", type: EdmType.Number, scale: 3 },
        { label: "Monthly Consumption Qty", property: "MonthlyConsumptionQty", type: EdmType.Number, scale: 3 },
        { label: "Monthly Consumption UOM", property: "MonthlyConsumptionUom", type: EdmType.String },
        { label: "Monthly Contractual Qty", property: "MonthlyContractualQty", type: EdmType.Number, scale: 3 },
        { label: "Monthly Contractual UOM", property: "MonthlyContractualUom", type: EdmType.String },
        { label: "Monthly Remaining Qty", property: "MonthlyRemainingQty", type: EdmType.Number, scale: 3 },
        { label: "Monthly Remaining UOM", property: "MonthlyRemainingUom", type: EdmType.String },
        { label: "Nomination Status", property: "NominationStatus", type: EdmType.String },
        { label: "Confirm Required", property: "isConfirmRequired", type: EdmType.String },
        { label: "Event", property: "Event", type: EdmType.String },
        { label: "Source", property: "Source", type: EdmType.String }
    ];

    return Controller.extend("com.ingenx.igmsgasflow.controller.confirmScheduleNomination", {

        onInit() {
            this.getView().setModel(new JSONModel({
                showAdditionalFilters: false,
                gasDayMode: "SINGLE",
                tableSelectionMode: "MultiToggle",
                enableSelectAll: false,
                noDataIcon: "sap-icon://filter",
                noDataTitle: "No Nominations Loaded",
                noDataText: "Select Transport System and Gas Day, then press Go",
                // Hidden until _initConfirmNominationAuth resolves — fail-safe default
                canConfirmNomination: false
            }), "viewModel");
            this._initConfirmNominationAuth();

            this.getView().setModel(new JSONModel({ deliveryText: "", redeliveryText: "" }), "aggCSN");

            // Location VH state — lazily-opened dialogs, per-type selection Sets and name Maps
            this._oLocVHDialog = {};
            this._oLocVHModel = {};   // JSONModel per type, set on dialog
            this._oLocAllData = {};   // full fetched array per type for local search
            this._oLocSelSet = { delivery: new Set(), redelivery: new Set(), interconnect: new Set() };
            this._oLocNameMap = { delivery: new Map(), redelivery: new Map(), interconnect: new Map() };
            this._bLocSyncing = {};
            this._aCurrentTransportKeys = [];
            this._oTransportAllData = [];   // full transport array for local search
            this._oLinkMapsPromise = null; // memoized (async) link maps for selection sync

            this.getOwnerComponent().getRouter()
                .getRoute("RouteConfirmScheduleNomination")
                .attachPatternMatched(this._onRouteMatched, this);

            this._attachPasteHandlers();

            // Column arrangement — restore any previously saved order, then ask before
            // saving any future drag reorder (see columnOrderPersistence.js's own
            // header comment for why permission is asked every time, not remembered).
            const oCSNTable = this.byId("IdCSNTable");
            ColumnOrderPersistence.restoreColumnOrder(oCSNTable, this.getView(), "igmsgasflow.confirmScheduleNomination.columnOrder");
            ColumnOrderPersistence.attachColumnOrderPersistence(oCSNTable, this.getView(), "igmsgasflow.confirmScheduleNomination.columnOrder");
        },

        /**
         * Fetches getConfirmNominationAuth and sets viewModel>/canConfirmNomination.
         * Display only — confirmNominationSelected independently enforces the same
         * scope server-side via @requires, so this never substitutes for that check.
         * Defaults to hidden on any failure.
         */
        async _initConfirmNominationAuth() {
            const oViewModel = this.getView().getModel("viewModel");
            try {
                // getOwnerComponent().getModel() — not getView().getModel(): the view's
                // default model isn't reliably propagated yet this early in onInit.
                const oCtx = this.getOwnerComponent().getModel().bindContext("/getConfirmNominationAuth(...)");
                await oCtx.execute("$direct");
                const oAuth = oCtx.getBoundContext().getObject();
                oViewModel.setProperty("/canConfirmNomination", !!oAuth?.canConfirmNomination);
            } catch (oErr) {
                Log.error("[CSN] getConfirmNominationAuth failed — hiding Confirm Nomination button", oErr?.message, "confirmScheduleNomination");
                oViewModel.setProperty("/canConfirmNomination", false);
            }
        },

        /** Attaches a paste delegate to each filter MultiInput so pasted values become tokens. */
        _attachPasteHandlers() {
            [
                { id: "IdCSNTransportMI", cascade: true },
                { id: "IdCSNDeliveryMI", cascade: false },
                { id: "IdCSNRedeliveryMI", cascade: false },
                { id: "IdCSNInterconnectMI", cascade: false }
            ].forEach(({ id, cascade }) => {
                const oInput = this.byId(id);
                if (!oInput) return;
                oInput.addEventDelegate({
                    onpaste: (oEvent) => {
                        const oBE = oEvent.originalEvent || oEvent;
                        const sText = oBE.clipboardData?.getData("text/plain") || "";
                        if (!sText.trim()) return;
                        oBE.preventDefault();
                        this._pasteTokens(oInput, sText, cascade);
                    }
                }, this);
            });
        },

        onAfterRendering() {

            const oMultiInput = this.byId("IdCSNTransportMI");

            if (!this._fnTransportPaste) {

                this._fnTransportPaste = (oEvent) => {

                    oEvent.preventDefault();

                    const sText = (oEvent.originalEvent || oEvent)
                        .clipboardData
                        .getData("text");

                    this._pasteTokens(oMultiInput, sText, true);
                };

                oMultiInput.attachBrowserEvent("paste", this._fnTransportPaste);
            }
        },

        /** Splits pasted text into individual keys and adds them as tokens; skips duplicates. */
        _pasteTokens(oInput, sRaw, bCascadeTransport) {
            const aKeys = sRaw
                .split(/[\r\n,;]+/)
                .map(s => s.split("\t")[0].trim())
                .filter(Boolean);

            const oPresent = new Set(
                oInput.getTokens().map(t => t.getKey())
            );

            aKeys.forEach(sKey => {
                if (!oPresent.has(sKey)) {
                    oInput.addToken(new Token({
                        key: sKey,
                        text: sKey
                    }));
                    oPresent.add(sKey);
                }
            });

            // Clear after native paste processing
            setTimeout(() => {
                oInput.setValue("");
            }, 0);

            if (bCascadeTransport) {
                this._syncTransportCascade(this._getTransportKeys());
            }
            this._clearNominationTable();
        },
        onBeforeRendering() {
            return new Promise(resolve => setTimeout(resolve, 1000));
        },

        _onRouteMatched() {
            BusyIndicator.hide();
            // Defer one microtask: Work Zone shell can fire route-match before MDC restores
            // conditions from its navigation state, causing getConditions() to return [] and
            // locking location fields to ReadOnly even when transport was already selected.
            Promise.resolve().then(() => this._syncTransportCascade(this._getTransportKeys()));
        },

        _getTransportKeys() {
            return (this.byId("IdCSNTransportMI")?.getTokens() || [])
                .map(t => t.getKey())
                .filter(Boolean);
        },

        _getLocationKeys(sId) {
            return (this.byId(sId)?.getTokens() || [])
                .map(t => t.getKey())
                .filter(Boolean);
        },

        /** Fired when user removes a token directly from the MultiInput chip. */
        onTransportTokenUpdate(oEvent) {
            if (oEvent.getParameter("type") === "removed") {
                this._clearTransportValueState();
                const aRemoved = oEvent.getParameter("removedTokens") || [];
                aRemoved.forEach(t => this._oTransportSelSet?.delete(t.getKey()));
                this._syncTransportCascade(this._getTransportKeys());
                this._clearNominationTable();
            }
        },

        /** Fired when user removes a location token directly from the MultiInput chip. */
        _onLocTokenUpdate(sType, oEvent) {
            if (oEvent.getParameter("type") === "removed") {
                const aRemoved = oEvent.getParameter("removedTokens") || [];
                aRemoved.forEach(t => this._oLocSelSet[sType]?.delete(t.getKey()));
                this._clearNominationTable();
            }
        },
        onDeliveryTokenUpdate(e) { this._onLocTokenUpdate("delivery", e); },
        onRedeliveryTokenUpdate(e) { this._onLocTokenUpdate("redelivery", e); },
        onInterconnectTokenUpdate(e) { this._onLocTokenUpdate("interconnect", e); },

        /** Stores transport keys for location VH pre-filter; clears location tokens when transport removed. */
        _syncTransportCascade(aKeys) {
            this._aCurrentTransportKeys = aKeys;
            if (!aKeys.length) {
                LOCATION_MI_IDS.forEach(sId => this.byId(sId)?.removeAllTokens());
            }
        },

        /** Switches Gas Day / Gas Day Range mode; clears date fields and location selections. */
        onGasDayModeChange(oEvent) {
            const sKey = oEvent.getParameter("item").getKey();
            const sListMode = sKey === "RANGE" ? "SingleSelect" : "MultiSelect";
            this.getView().getModel("viewModel").setProperty("/gasDayMode", sKey);
            this.byId("IdCSNGasDay")?.setValue("");
            this.byId("IdCSNGasDayRange")?.setValue("");
            this._clearNominationTable();
            // Clear location tokens and reset value states
            LOCATION_MI_IDS.forEach(sId => {
                this.byId(sId)?.removeAllTokens();
                this.byId(sId)?.setValueState(ValueState.None);
            });
            // Clear transport tokens so stale multi-selections don't survive a mode switch
            this.byId("IdCSNTransportMI")?.removeAllTokens();
            this._syncTransportCascade([]);
            // Update selection mode on any VH dialogs already loaded in the DOM
            this._applyVHTableMode(sListMode);
        },

        onGasDayRangeChange() {
            this._clearNominationTable();
            this._validateGasDayRange();
        },



        _validateGasDayRange() {

            const oDRS = this.byId("IdCSNGasDayRange");

            const dFrom = oDRS.getDateValue();
            const dTo = oDRS.getSecondDateValue();

            if (!dFrom || !dTo) {
                return true;
            }

            const iDays = Math.floor(
                (dTo.getTime() - dFrom.getTime()) / (1000 * 60 * 60 * 24)
            ) + 1;

            if (iDays > 31) {
                oDRS.setValue("");
                oDRS.setValueState(ValueState.Error);
                oDRS.setValueStateText(
                    "Gas Day range cannot exceed 31 days."
                );

                MessageBox.error(
                    "Gas Day range cannot exceed 31 days."
                );

                return false;
            }

            oDRS.setValueState(ValueState.None);
            return true;
        },

        /** Returns "SingleSelect" for Date Range mode, "MultiSelect" for Gas Day. */
        _currentVHTableMode() {
            const sMode = this.getView().getModel("viewModel").getProperty("/gasDayMode");
            return sMode === "RANGE" ? "SingleSelect" : "MultiSelect";
        },

        /** Sets the given ListMode on every loaded VH dialog table. */
        _applyVHTableMode(sListMode) {
            this.byId("IdCSNTransportVHTable")?.setMode(sListMode);
            Object.values(LOCATION_VH_CFG).forEach(oCfg =>
                this.byId(oCfg.tableId)?.setMode(sListMode)
            );
        },

        // ── More / Less Filters toggle ────────────────────────────────────────────
        onToggleAdditionalFilters() {
            const oVM = this.getView().getModel("viewModel");
            oVM.setProperty("/showAdditionalFilters", !oVM.getProperty("/showAdditionalFilters"));
        },

        /**
         * Clears the table + every derived display/controller state that onSearch
         * populates — without touching filter control values — so a result set
         * already on screen is never shown against a filter selection that no
         * longer produced it. Called on every Gasday/Transport/Delivery/Redelivery/
         * Interconnect/Document Type change; Go re-populates. Same reset shape
         * onClearFilters already applies to the table/state block, minus the
         * filter-control resets (those stay as the user just set them) and minus
         * the gasDayMode reset (only Clear/mode-switch touch that).
         */
        _clearNominationTable() {
            const oTable = this.byId("IdCSNTable");
            oTable?.setSelectionMode("Multi");
            oTable?.setEnableSelectAll(true);
            oTable?.unbindRows();
            oTable?.clearSelection();
            this._resetColumnFilterSort();
            this.byId("IdCSNTableTitle")?.setText("Schedule Nominations");

            this.byId("IdCSNSBConfirmedFilter")?.setSelectedKey("NOT_CONFIRMED");
            const oVM = this.getView().getModel("viewModel");
            oVM.setProperty("/tableSelectionMode", "MultiToggle");
            oVM.setProperty("/enableSelectAll", false);

            this._aCurrentFilters = [];
            this._sAggGasDay = null;
            this._sAggGasDayTo = null;
            this._aGasDayFilter = null;
            this._aAggTransportKeys = [];
            this._sCurrentSegment = null;
            this._oLinkMapsPromise = null;
            this._clearAggDisplay();
            this._ensureCsnDataIssuesModel().setData({ Count: 0, Violations: [] });

            oVM.setProperty("/noDataIcon", "sap-icon://filter");
            oVM.setProperty("/noDataTitle", "No Nominations Loaded");
            oVM.setProperty("/noDataText", "Select Transport System and Gas Day, then press Go");
        },

        /** Gas Day / Document Type value changed — clear stale table data (see _clearNominationTable). */
        onFilterValueChanged() {
            this._clearNominationTable();
        },

        /**
         * Single choke point for the Confirm Nomination busy state — disables the
         * button alongside the _bConfirmProcessing flag so a rapid double-press
         * can't queue a second request behind the flag check (and gives the user
         * visible feedback instead of an apparently-inert button).
         */
        _setConfirmBusy(bBusy) {
            this._bConfirmProcessing = bBusy;
            this.byId("IdCSNBtnConfirmNomination")?.setEnabled(!bBusy);
        },

        async onConfirmNomination() {
            if (this._bConfirmProcessing) return;
            if (!this._sAggGasDay) {
                MessageBox.information("Please apply filters and press Go before confirming.");
                return;
            }

            const oTable = this.byId("IdCSNTable");
            const aSelectedIdx = oTable.getSelectedIndices();
            if (!aSelectedIdx.length) {
                MessageBox.information("Please select at least one row to confirm.");
                return;
            }

            this._setConfirmBusy(true);
            BusyIndicator.show(0);

            const oRowBinding = oTable.getBinding("rows");
            const nTotal = oRowBinding.getLength();

            // Force-load ALL rows into V4 cache before reading contexts.
            // getContexts() returns undefined for unloaded virtual rows — in RANGE
            // mode Select All, only the visible viewport is cached; this ensures
            // every selected index has a live context object.
            await oRowBinding.requestContexts(0, nTotal);

            const aAllCtx = oRowBinding.getContexts(0, nTotal);
            const aCtx = aSelectedIdx.map(i => aAllCtx[i]).filter(Boolean);

            BusyIndicator.hide();
            if (!aCtx.length) { this._setConfirmBusy(false); return; }

            const aGated = await this._checkMonthlyQtyGate(aCtx);
            if (!aGated || !aGated.length) { this._setConfirmBusy(false); return; }

            this._showConfirmGate(aGated);
        },

        /**
         * Evaluates one row against the Monthly Contractual Qty rule — only applies when
         * MonthlyContractualQty > 0; returns null for every other row (not subject to this
         * check) and for one that passes (ProjectedApprovedQty <= MonthlyRemainingQty).
         * Compares at 3dp (same scale as these columns) to avoid a floating-point false
         * positive on an exact-equal quantity. Returns a violation object (values pre-
         * formatted to 3dp strings for direct display) when it fails. Shared by
         * _checkMonthlyQtyGate (confirm-time, selected rows only) and
         * _computeMonthlyQtyIssues (table-wide, on every refresh, for the header badge).
         */
        _evalMonthlyQtyRow(oCtx) {
            const round3 = v => parseFloat((parseFloat(v) || 0).toFixed(3));
            const fContractual = round3(oCtx.getProperty("MonthlyContractualQty"));
            if (!(fContractual > 0)) return null;

            const fRemaining = round3(oCtx.getProperty("MonthlyRemainingQty"));
            const fProjected = round3(oCtx.getProperty("ProjectedApprovedQty"));
            if (fProjected <= fRemaining) return null;

            return {
                ContractNo: oCtx.getProperty("ContractNo"),
                MonthlyContractualQty: fContractual.toFixed(3),
                MonthlyRemainingQty: fRemaining.toFixed(3),
                ProjectedApprovedQty: fProjected.toFixed(3)
            };
        },

        /** Lazily creates/returns the "csnDataIssuesModel" backing IdCSNDataIssuesBtn's badge
         *  count and its on-demand review dialog (onShowMonthlyQtyIssues). */
        _ensureCsnDataIssuesModel() {
            if (!this._oCsnDataIssuesModel) {
                this._oCsnDataIssuesModel = new JSONModel({ Count: 0, Violations: [] });
                this.getView().setModel(this._oCsnDataIssuesModel, "csnDataIssuesModel");
            }
            return this._oCsnDataIssuesModel;
        },

        /**
         * Recomputes the Data Issue count/list for IdCSNDataIssuesBtn from the table's
         * currently loaded rows, on every onTableRowsUpdated firing — same "as of what's
         * currently loaded, not force-fetched" scope _computeAggFromTable already accepts for
         * the Aggregated DNQ header just above it, not a fresh full-table fetch. The
         * authoritative check still runs at Confirm time via _checkMonthlyQtyGate.
         */
        _computeMonthlyQtyIssues(oBinding, nCount) {
            const aContexts = oBinding.getContexts(0, nCount);
            const aViolations = [];
            for (const oCtx of aContexts) {
                if (!oCtx) continue;
                const oViolation = this._evalMonthlyQtyRow(oCtx);
                if (oViolation) aViolations.push(oViolation);
            }
            this._ensureCsnDataIssuesModel().setData({ Count: aViolations.length, Violations: aViolations });
        },

        /** IdCSNDataIssuesBtn press — reopens the last-computed Monthly Qty violation list
         *  (view-only, no Continue) for the whole table, same rule as _checkMonthlyQtyGate. */
        async onShowMonthlyQtyIssues() {
            const aViolations = this._oCsnDataIssuesModel?.getProperty("/Violations") || [];
            if (!aViolations.length) {
                MessageToast.show("No Monthly Contractual Qty issues for the current data.");
                return;
            }
            await this._openMonthlyQtyDialog();
            this._oMonthlyQtyModel.setData({
                Violations: aViolations,
                IntroText: `${aViolations.length} row(s) have Monthly Contractual Qty > 0 but ` +
                    "Projected Approved Qty exceeds Monthly Remaining Qty:",
                TailText: "",
                ShowContinue: false,
                CancelButtonText: "Close"
            });
            this._oMonthlyQtyDialog.open();
        },

        /**
         * Monthly Contractual Qty gate — only applies to rows with MonthlyContractualQty > 0;
         * every other row passes through unconditionally. For those rows, ProjectedApprovedQty
         * must not exceed MonthlyRemainingQty — a row that fails is excluded from the payload
         * sent to ConfirmNomination rather than blocking the whole selection. See
         * _evalMonthlyQtyRow for the per-row rule.
         *
         * No violations → resolves with aCtx unchanged, no dialog shown. Some violations →
         * opens CSNMonthlyQtyViolations listing the offending rows and asks to Continue with
         * the rest; resolves with the surviving rows on Continue, or null on Cancel/Close (or
         * when every row failed — nothing left to continue with).
         *
         * @returns {Promise<Array|null>}
         */
        async _checkMonthlyQtyGate(aCtx) {
            const aValid = [];
            const aViolations = [];
            aCtx.forEach(oCtx => {
                const oViolation = this._evalMonthlyQtyRow(oCtx);
                if (oViolation) aViolations.push(oViolation);
                else aValid.push(oCtx);
            });

            if (!aViolations.length) return aCtx;

            this._aMonthlyQtyValidCtx = aValid;
            await this._openMonthlyQtyDialog();
            this._oMonthlyQtyModel.setData({
                Violations: aViolations,
                IntroText: `${aViolations.length} row(s) have Monthly Contractual Qty > 0 but ` +
                    "Projected Approved Qty exceeds Monthly Remaining Qty — these will be skipped:",
                TailText: aValid.length
                    ? `${aValid.length} row(s) pass this check and will proceed.`
                    : "No remaining rows to confirm.",
                ShowContinue: aValid.length > 0,
                CancelButtonText: aValid.length ? "Cancel" : "Close"
            });
            this._oMonthlyQtyDialog.open();

            return new Promise(resolve => { this._fnMonthlyQtyResolve = resolve; });
        },

        /** Lazily loads/caches the CSNMonthlyQtyViolations dialog + its JSON model. */
        async _openMonthlyQtyDialog() {
            if (!this._oMonthlyQtyDialog) {
                this._oMonthlyQtyDialog = await Fragment.load({
                    id: this.getView().getId(),
                    name: "com.ingenx.igmsgasflow.fragments.CSNMonthlyQtyViolations",
                    controller: this
                });
                this.getView().addDependent(this._oMonthlyQtyDialog);
                this._oMonthlyQtyModel = new JSONModel({});
                this._oMonthlyQtyDialog.setModel(this._oMonthlyQtyModel, "monthlyQtyModel");
            }
        },

        onContinueMonthlyQtyGate() {
            this._oMonthlyQtyDialog?.close();
            if (this._fnMonthlyQtyResolve) {
                this._fnMonthlyQtyResolve(this._aMonthlyQtyValidCtx || []);
                this._fnMonthlyQtyResolve = null;
            }
        },

        onCancelMonthlyQtyGate() {
            this._oMonthlyQtyDialog?.close();
            if (this._fnMonthlyQtyResolve) {
                this._fnMonthlyQtyResolve(null);
                this._fnMonthlyQtyResolve = null;
            }
        },

        /**
         * Client-side approval gate built entirely from data already on screen —
         * the ProjectedApprovedQty/ProjectedStatus columns computed server-side at
         * table READ time (balancingScheduling-service.js / srv/utils/ari004Rules.js).
         * No backend call here; this is an estimate as of the grid's last refresh —
         * the confirm action always recomputes fresh at posting time and is the only
         * authoritative result. On Proceed, kicks off the real confirm job.
         */
        _showConfirmGate(aCtx) {
            let nCapped = 0, nRejected = 0, fProjectedTotal = 0;
            aCtx.forEach(oCtx => {
                const sStatus = oCtx.getProperty("ProjectedStatus");
                if (sStatus === "CAPPED") nCapped++;
                else if (sStatus === "WOULD_REJECT") nRejected++;
                fProjectedTotal += parseFloat(oCtx.getProperty("ProjectedApprovedQty")) || 0;
            });

            const aLines = [
                `${aCtx.length} row(s) selected.`,
                nCapped ? `${nCapped} will be capped by business rules.` : null,
                nRejected ? `${nRejected} would currently be rejected by business rules.` : null,
                `Projected total approved qty: ${fProjectedTotal.toFixed(3)}`,
                "",
                "Estimated as of last refresh — final result is validated at posting time.",
                "",
                "Proceed with confirmation?"
            ].filter(Boolean);

            MessageBox.confirm(aLines.join("\n"), {
                title: "Confirm Nomination",
                onClose: sAction => {
                    if (sAction !== MessageBox.Action.OK) {
                        this._setConfirmBusy(false);
                        return;
                    }
                    const sSelectedKeys = aCtx.map(oCtx => {
                        const p = f => oCtx.getProperty(f);
                        return `${p("Gasday")}|${p("ContractNo")}|${p("Item")}|${p("Versn")}|${p("NominationItem")}`;
                    }).join(",");

                    this._startConfirmJob(sSelectedKeys).catch(oErr => {
                        Log.error("[CSN] confirmNominationSelected failed to start", oErr?.message, "confirmScheduleNomination");
                        MessageBox.error("Failed to start confirm. Please try again.");
                        this._setConfirmBusy(false);
                    });
                }
            });
        },

        /** Sends the selected row keys to confirmNominationSelected and routes inline vs. polled result. */
        async _startConfirmJob(sSelectedKeys) {
            const oModel = this.getView().getModel();
            const oAction = oModel.bindContext("/confirmNominationSelected(...)");
            oAction.setParameter("SelectedKeys", sSelectedKeys);

            // Every confirm — one row or thousands — runs via cds.spawn server-side;
            // there's no inline/sync fast path, so this action call itself only waits
            // on row resolution, not the actual posting. Open the progress dialog
            // immediately: its own "Resolving eligible nominations…" initial state
            // covers that short wait, then polling takes over once a jobId comes back.
            this._openBulkProgressDialog();

            let oResult;
            try {
                await oAction.execute("$direct");
                oResult = await oAction.getBoundContext().requestObject();
            } finally {
                oAction.destroy();
            }

            // Only reachable without a jobId if row resolution itself failed before a
            // job could even be spawned (e.g. S/4 unreachable) — nothing to poll for.
            if (oResult.status !== "SUBMITTED") {
                this._finishConfirm(oResult);
                return;
            }

            this._pollConfirmJobStatus(oResult.jobId);
        },

        /** Builds (once) and opens the non-dismissable confirm progress dialog. */
        _openBulkProgressDialog() {
            const oInitialData = {
                totalText: "Resolving eligible nominations…",
                statusText: "Confirming nominations — please wait, this can take a while for large selections…",
                displayValue: "",
                percent: 0,
                state: "Information"
            };
            if (!this._oBulkProgressModel) {
                this._oBulkProgressModel = new JSONModel(oInitialData);
            }
            if (!this._oBulkProgressDialog) {
                this._oBulkProgressDialog = new Dialog({
                    title: "Confirming Nominations",
                    showHeader: true,
                    contentWidth: "26rem",
                    content: [
                        new VBox({
                            items: [
                                new sap.m.Text({ text: "{bulkProgress>/totalText}" })
                                    .addStyleClass("sapUiTinyMarginBottom csnBulkProgressTotal"),
                                // sap.m.MessageStrip — the standard Fiori control for this: native
                                // border/background/icon/semantic color per type, no custom CSS
                                // needed (unlike a hand-styled Text/VBox). type reuses the same
                                // Information/Success/Warning/Error binding already computed for
                                // the ProgressIndicator's state below — both properties accept the
                                // same value set.
                                new sap.m.MessageStrip({
                                    text: "{bulkProgress>/statusText}",
                                    type: "{bulkProgress>/state}",
                                    showIcon: true
                                }).addStyleClass("sapUiSmallMarginBottom"),
                                new sap.m.ProgressIndicator({
                                    width: "100%",
                                    height: "1.5rem",
                                    showValue: true,
                                    displayAnimation: true,
                                    displayValue: "{bulkProgress>/displayValue}",
                                    percentValue: "{bulkProgress>/percent}",
                                    state: "{bulkProgress>/state}"
                                }).addStyleClass("csnBulkProgressBar")
                            ]
                        }).addStyleClass("sapUiMediumMargin csnBulkProgressBox")
                    ]
                });
                this._oBulkProgressDialog.setModel(this._oBulkProgressModel, "bulkProgress");
                this.getView().addDependent(this._oBulkProgressDialog);
            } else {
                this._oBulkProgressModel.setData(oInitialData);
            }
            this._oBulkProgressDialog.open();
        },

        /** Polls getConfirmNominationJobStatus every ~1.5s until the job leaves RUNNING/SUBMITTED. */
        _pollConfirmJobStatus(sJobId) {
            const oModel = this.getView().getModel();

            const poll = async () => {
                const oCtx = oModel.bindContext("/getConfirmNominationJobStatus(...)");
                oCtx.setParameter("jobId", sJobId);
                let oStatus;
                try {
                    await oCtx.execute("$direct");
                    oStatus = await oCtx.getBoundContext().requestObject();
                } catch (oErr) {
                    oCtx.destroy();
                    // Transient — backend/network hiccup mid-poll; retry rather than fail the job.
                    this._iBulkPollTimer = setTimeout(poll, 5000);
                    return;
                }
                oCtx.destroy();

                const nTotal = oStatus.totalItems || 0;
                const nTotalContracts = oStatus.totalContracts || 0;
                const nDoneContracts = oStatus.processedContracts || 0;
                const nDone = (oStatus.confirmedItems || 0) + (oStatus.rejectedItems || 0) +
                    (oStatus.failedItems || 0) + (oStatus.linkedPendingItems || 0) + (oStatus.lockedItems || 0) +
                    (oStatus.preConfirmedItems || 0);
                const nPct = nTotal ? Math.min(100, Math.round((nDone / nTotal) * 100)) : 0;
                const sState = oStatus.status === "FAILED" ? "Error"
                    : (oStatus.rejectedItems || oStatus.failedItems || oStatus.linkedPendingItems ||
                        oStatus.lockedItems || oStatus.preConfirmedItems) ? "Warning"
                        : "Information";

                this._oBulkProgressModel.setData({
                    totalText: nTotal
                        ? `Total ${nTotal} item${nTotal === 1 ? "" : "s"} ` +
                        `(${nTotalContracts} contract${nTotalContracts === 1 ? "" : "s"}) ` +
                        `processing for Confirm Nomination`
                        : "Resolving eligible nominations…",
                    statusText: `${oStatus.status} — ${nDone} of ${nTotal} items, ` +
                        `${nDoneContracts} of ${nTotalContracts} contracts processed`,
                    displayValue: nTotal ? `${nDone} / ${nTotal}` : "",
                    percent: nPct,
                    state: sState
                });

                if (oStatus.status === "RUNNING" || oStatus.status === "SUBMITTED") {
                    this._iBulkPollTimer = setTimeout(poll, 1500);
                } else {
                    this._finishConfirm(oStatus);
                }
            };
            poll();
        },

        /** Closes the progress dialog, shows a summary, and resets table state. */
        _finishConfirm(oStatus) {
            this._oBulkProgressDialog?.close();
            this._setConfirmBusy(false);

            if (oStatus.status === "FAILED" || oStatus.status === "NOT_FOUND") {
                MessageBox.error(oStatus.errorMessage || "Confirm nomination failed.", { title: "Confirmation Failed" });
                return;
            }

            const aLines = [
                `Selected: ${oStatus.requestedItems || 0} item(s)`,
                `Total: ${oStatus.totalItems || 0} item(s) across ${oStatus.totalContracts || 0} contract(s)`,
                `Confirmed: ${oStatus.confirmedItems || 0}`,
                `Rule-rejected: ${oStatus.rejectedItems || 0}`,
                `Failed at S/4: ${oStatus.failedItems || 0}`,
                `Capped (ARI004): ${oStatus.cappedItems || 0}`,
                `GTA Right to Cure adjusted: ${oStatus.rtcItems || 0}`,
                `Pending — linked contract not yet confirmed: ${oStatus.linkedPendingItems || 0}`,
                `Locked — being confirmed elsewhere: ${oStatus.lockedItems || 0}`,
                `Skipped — already confirmed before posting: ${oStatus.preConfirmedItems || 0}`,
                `Skipped — stale selection: ${oStatus.staleSkippedItems || 0}`
            ];

            MessageBox.information(aLines.join("\n"), { title: "Confirm Nomination — Result" });

            // Detail — every sample category plus S/4's own return messages, all in
            // the one "Nomination Messages" dialog (Errors/Warnings/Success filter)
            // instead of duplicating them as plain text bullets in the summary above.
            const aDetailMessages = [
                ...(oStatus.rejectedSamples || []).map(s => ({ type: "E", contractNo: s.ContractNo, message: `Rejected: ${s.Message}` })),
                ...(oStatus.s4ErrorSamples || []).map(s => ({ type: "E", contractNo: s.ContractNo, message: `S/4 error: ${s.Message}` })),
                ...(oStatus.cappedSamples || []).map(s => ({ type: "W", contractNo: s.ContractNo, message: `Capped: ${s.Message}` })),
                ...(oStatus.rtcSamples || []).map(s => ({ type: "W", contractNo: s.ContractNo, message: `GTA Right to Cure: ${s.Message}` })),
                ...(oStatus.linkedPendingSamples || []).map(s => ({ type: "W", contractNo: s.ContractNo, message: `Linked pending: ${s.Message}` })),
                ...(oStatus.lockedSamples || []).map(s => ({ type: "W", contractNo: s.ContractNo, message: `Locked: ${s.Message}` })),
                ...(oStatus.preConfirmedSamples || []).map(s => ({ type: "W", contractNo: s.ContractNo, message: `Already confirmed: ${s.Message}` })),
                ...(oStatus.staleSkippedSamples || []).map(s => ({ type: "W", contractNo: s.ContractNo, message: `Stale skipped: ${s.Message}` })),
                ...(oStatus.toReturn || []).map(m => ({ type: m.Type, contractNo: m.ContractNo || "", message: m.Message }))
            ];
            if (aDetailMessages.length) this._showReturnMessages(aDetailMessages);

            this._sCurrentSegment = "CONFIRMED";
            this.byId("IdCSNSBConfirmedFilter")?.setSelectedKey("CONFIRMED");
            this._applySegmentFilter("CONFIRMED");
            this.byId("IdCSNTable").clearSelection();
            this.byId("IdCSNTable").getBinding("rows")?.refresh();
        },

        _showReturnMessages(aMessages) {
            if (!this._oCSNMsgDialog) this._createCSNMessageDialog();
            this._oCSNMsgDialog.setModel(new JSONModel({ messages: aMessages }), "msg");
            this._oCSNMsgDialog.open();
        },

        _createCSNMessageDialog() {
            const oTable = new sap.m.Table({
                growing: true,
                growingThreshold: 20,
                columns: [
                    new sap.m.Column({ header: new sap.m.Label({ text: "Contract No" }) }),
                    new sap.m.Column({ header: new sap.m.Label({ text: "Status" }), width: "120px" }),
                    new sap.m.Column({ header: new sap.m.Label({ text: "Message" }) })
                ]
            });

            oTable.bindItems({
                path: "msg>/messages",
                template: new sap.m.ColumnListItem({
                    cells: [
                        new sap.m.Text({ text: "{msg>contractNo}" }),
                        new sap.m.ObjectStatus({
                            text: "{msg>type}",
                            state: { path: "msg>type", formatter: this._statusStateFormatter }
                        }),
                        new sap.m.Text({ text: "{msg>message}" })
                    ]
                })
            });

            const oFilterSelect = new sap.m.Select({
                width: "200px",
                change: this._filterMessageStatus.bind(this),
                items: [
                    new sap.ui.core.Item({ key: "ALL", text: "All" }),
                    new sap.ui.core.Item({ key: "E", text: "Errors" }),
                    new sap.ui.core.Item({ key: "W", text: "Warnings" }),
                    new sap.ui.core.Item({ key: "S", text: "Success" })
                ]
            });

            this._oCSNMsgDialog = new sap.m.Dialog({
                contentWidth: "800px",
                contentHeight: "500px",
                resizable: true,
                draggable: true,
                customHeader: new sap.m.Bar({
                    contentLeft: [new sap.m.Title({ text: "Nomination Messages" })],
                    contentRight: [new sap.m.Label({ text: "Filter:" }), oFilterSelect]
                }),
                content: [oTable],
                endButton: new sap.m.Button({
                    text: "Close",
                    press: () => this._oCSNMsgDialog.close()
                })
            });
            this.getView().addDependent(this._oCSNMsgDialog);
        },

        _statusStateFormatter(sType) {
            return { E: "Error", W: "Warning", S: "Success" }[sType] || "None";
        },

        _filterMessageStatus(oEvent) {
            const sKey = oEvent.getSource().getSelectedKey();
            const oBinding = this._oCSNMsgDialog.getContent()[0].getBinding("items");
            oBinding.filter(
                sKey === "ALL" ? [] : [new Filter("type", FilterOperator.EQ, sKey)]
            );
        },

        // ── Column Visibility Settings ────────────────────────────────────────────
        onOpenCSNColumnSettings(oEvent) {
            const oTable = this.byId("IdCSNTable");
            const aColumns = oTable.getColumns();

            if (!this._oColSettingsDialog) {
                const aCheckBoxes = aColumns.map(oCol => {
                    const sLabel = oCol.getLabel()?.getText?.() || "";
                    const oCheckBox = new CheckBox({
                        text: sLabel,
                        selected: oCol.getVisible(),
                        select: oEvt => oCol.setVisible(oEvt.getParameter("selected"))
                    });
                    oCheckBox.data("column", oCol);
                    return oCheckBox;
                });

                const oScroll = new ScrollContainer({
                    height: "28rem",
                    vertical: true,
                    content: [new VBox({ items: aCheckBoxes, class: "sapUiSmallMargin" })]
                });

                this._oColSettingsDialog = new Dialog({
                    title: "Show / Hide Columns",
                    contentWidth: "18rem",
                    content: [oScroll],
                    endButton: new Button({
                        text: "Close",
                        press: () => this._oColSettingsDialog.close()
                    })
                });
                this.getView().addDependent(this._oColSettingsDialog);
            } else {
                // Sync checkbox state with current column visibility on re-open
                const aItems = this._oColSettingsDialog
                    .getContent()[0].getContent()[0].getItems();
                aColumns.forEach((oCol, i) => aItems[i]?.setSelected(oCol.getVisible()));
            }

            this._oColSettingsDialog.open();
        },

        // ── Transport System Custom Value Help ────────────────────────────────────

        /** Opens Transport VH dialog; snapshots current tokens into the working Set. */
        async onOpenTransportVH() {
            if (!this._oTransportVHDialog) {
                this._oTransportVHDialog = await Fragment.load({
                    id: this.getView().getId(),
                    name: "com.ingenx.igmsgasflow.fragments.CSNTransportVH",
                    controller: this
                });
                // Set JSONModel as the dialog's default model BEFORE addDependent so
                // no OData request fires when the control tree connects to the view.
                // Unqualified bindings like {Tsyst} in the fragment resolve on the
                // default ("") model — they must find the JSONModel, not the OData model.
                this._oTransportVHModel = new JSONModel([]);
                this._oTransportVHModel.setSizeLimit(5000);
                this._oTransportVHDialog.setModel(this._oTransportVHModel);
                this.getView().addDependent(this._oTransportVHDialog);
                const oTable = this.byId("IdCSNTransportVHTable");
                const oTmpl = oTable.removeItem(0);   // pull XML-declared template item
                oTable.bindItems({ path: "/", template: oTmpl });
            }

            // Snapshot committed tokens → working Set so Cancel can revert
            this._oTransportSelSet = new Set(
                (this.byId("IdCSNTransportMI")?.getTokens() || []).map(t => t.getKey())
            );
            this._oTransportNameMap = new Map();

            const oSearch = this.byId("IdCSNTransportVHSearch");
            if (oSearch) oSearch.setValue("");

            // Sync selection mode to the current gas day mode before opening
            this.byId("IdCSNTransportVHTable")?.setMode(this._currentVHTableMode());

            // Open the dialog immediately; populate while it shows busy
            this._oTransportVHDialog.open();
            this._oTransportVHDialog.setBusy(true);
            try {
                const aData = await this._fetchTransportKeys("");
                this._oTransportAllData = aData;
                this._oTransportVHModel.setData(aData);
                this._resyncTransportCheckboxes();
            } catch (oErr) {
                Log.error("[CSN] Transport VH load failed", oErr?.message, "confirmScheduleNomination");
                MessageBox.error(this._friendlyErrorMessage(oErr, "Failed to load transport systems. Please try again."));
                this._oTransportVHDialog.close();
            } finally {
                this._oTransportVHDialog.setBusy(false);
            }
        },

        /** Keeps the selection Set in sync as the user checks / unchecks rows. */
        onTransportVHSelectionChange(oEvent) {

            if (this._bTransportSyncing) {
                return;
            }

            const oTable = this.byId("IdCSNTransportVHTable");

            // Rebuild selection set from table selection state
            this._oTransportSelSet = new Set();

            if (!this._oTransportNameMap) {
                this._oTransportNameMap = new Map();
            }

            oTable.getSelectedItems().forEach(oItem => {
                const oData = oItem.getBindingContext()?.getObject();

                if (!oData?.Tsyst) {
                    return;
                }

                this._oTransportSelSet.add(oData.Tsyst);
                this._oTransportNameMap.set(oData.Tsyst, oData);
            });

            // Sync MultiInput immediately
            const oInput = this.byId("IdCSNTransportMI");

            oInput.removeAllTokens();

            this._oTransportSelSet.forEach(sTsyst => {

                const oEntry = this._oTransportNameMap.get(sTsyst);

                oInput.addToken(new Token({
                    key: sTsyst,
                    text: oEntry
                        ? `${sTsyst} – ${oEntry.Tsnam}`
                        : sTsyst
                }));
            });

            this._syncTransportCascade(this._getTransportKeys());
        },

        /** Resyncs checkbox state after each growing page finishes loading. */
        onTransportVHUpdateFinished() {
            this._resyncTransportCheckboxes();
        },

        _resyncTransportCheckboxes() {
            const oTable = this.byId("IdCSNTransportVHTable");
            if (!oTable || !this._oTransportSelSet) return;
            this._bTransportSyncing = true;
            oTable.getItems().forEach(oItem => {
                const oData = oItem.getBindingContext()?.getObject();
                if (!oData?.Tsyst) return;
                if (!this._oTransportNameMap) this._oTransportNameMap = new Map();
                this._oTransportNameMap.set(oData.Tsyst, oData);
                oItem.setSelected(this._oTransportSelSet.has(oData.Tsyst));
            });
            this._bTransportSyncing = false;
        },

        /** Local-filters _oTransportAllData in memory; no OData request. */
        onTransportVHSearch(oEvent) {
            const sQuery = (oEvent.getParameter("query") || oEvent.getParameter("newValue") || "").trim().toUpperCase();
            const aFiltered = sQuery
                ? (this._oTransportAllData || []).filter(o =>
                    o.Tsyst?.toUpperCase().includes(sQuery) ||
                    o.Tsnam?.toUpperCase().includes(sQuery))
                : (this._oTransportAllData || []);
            this._oTransportVHModel?.setData(aFiltered);
            this._resyncTransportCheckboxes();
        },

        /** Selects all rows currently visible in the model (after search filter). */
        onTransportSelectAll() {
            if (!this._oTransportNameMap) this._oTransportNameMap = new Map();
            (this._oTransportVHModel?.getData() || []).forEach(o => {
                this._oTransportSelSet?.add(o.Tsyst);
                this._oTransportNameMap.set(o.Tsyst, o);
            });
            this._resyncTransportCheckboxes();
        },

        /** Deselects all rows currently visible in the model (after search filter). */
        onTransportDeselectAll() {
            (this._oTransportVHModel?.getData() || []).forEach(o =>
                this._oTransportSelSet?.delete(o.Tsyst)
            );
            this._resyncTransportCheckboxes();
        },

        /** Strips the generic "Failed to get contexts for ..." wrapper CAP's OData V4
         *  model puts around a remote-service error, surfacing just the underlying
         *  message (e.g. an S/4 business message) when present; falls back to a
         *  generic sFallback text for anything unrecognized (network drop, timeout). */
        _friendlyErrorMessage(oErr, sFallback) {
            const sMsg = oErr?.message || "";
            const oMatch = sMsg.match(/Error during request to remote service:\s*(.+)$/i);
            return oMatch ? oMatch[1].trim() : sFallback;
        },

        /** Pages an OData V4 list binding in chunks — CAP caps every response at
         *  cds.query.limit.max (1000) regardless of the requested $top, so a single
         *  large requestContexts() call silently truncates. Keeps issuing successive
         *  $skip/$top pages until a short page signals the end of the collection. */
        async _fetchAllPages(sPath, aFilters, sSelect, iPageSize = 1000) {
            const oBinding = this.getView().getModel().bindList(
                sPath, null, null, aFilters,
                { $$groupId: "$direct", $select: sSelect }
            );
            try {
                const aAll = [];
                let iSkip = 0;
                for (;;) {
                    const aCtxs = await oBinding.requestContexts(iSkip, iPageSize);
                    aAll.push(...aCtxs.map(c => c.getObject()));
                    if (aCtxs.length < iPageSize) break;
                    iSkip += iPageSize;
                }
                return aAll;
            } finally {
                oBinding.destroy();
            }
        },

        /** Reads all matching transport rows directly from the CSNTransportSystem entity
         *  (LocPoint_MapSet-backed — see balancingScheduling-service.cds). */
        async _fetchTransportKeys(sSearch) {
            const aFilters = sSearch
                ? [new Filter("Tsnam", FilterOperator.Contains, sSearch)]
                : [];
            return this._fetchAllPages("/CSNTransportSystem", aFilters, "Tsyst,Tsnam");
        },

        /** Commits the working Set as tokens; cascades Tsyst keys to location VHs. */
        onTransportVHConfirm() {
            const oInput = this.byId("IdCSNTransportMI");
            oInput.removeAllTokens();
            // _oTransportSelSet contains Tsyst values; token key must be Tsyst so
            // _getTransportKeys() / _buildTransportFilter() receive the system code.
            (this._oTransportSelSet || new Set()).forEach(sTsyst => {
                const oEntry = this._oTransportNameMap?.get(sTsyst);
                oInput.addToken(new Token({
                    key: sTsyst,
                    text: oEntry ? `${sTsyst} – ${oEntry.Tsnam}` : sTsyst
                }));
            });
            this._clearTransportValueState();
            this._syncTransportCascade(this._getTransportKeys());
            this._clearNominationTable();
            this._oTransportVHDialog.close();
        },

        /** Reverts working Set to last committed tokens without changing the MultiInput. */
        onTransportVHCancel() {
            this._oTransportSelSet = new Set(
                (this.byId("IdCSNTransportMI")?.getTokens() || []).map(t => t.getKey())
            );
            this._oTransportVHDialog.close();
        },

        // ── Material Value Help ─────────────────────────────────────────────────
        // Reuses the shared BNSMaterial SelectDialog (materiallMaster entity, same
        // fragment ticketCorrection/capacityRelease already use) rather than the
        // heavier custom checkbox-table pattern above — Material has no cascading
        // filter relationship to Transport/Location, so a plain multi-select
        // SelectDialog is sufficient.

        /** Opens the shared Material SelectDialog; resyncs its checked rows to the
         *  currently committed IdCSNMaterialMI tokens once data lands. */
        async onValueHelpMaterial() {
            if (!this._oMaterialVHDialog) {
                this._oMaterialVHDialog = await Fragment.load({
                    id: this.getView().getId(),
                    name: "com.ingenx.igmsgasflow.fragments.BNSMaterial",
                    controller: this
                });
                this.getView().addDependent(this._oMaterialVHDialog);
            }
            const oBinding = this._oMaterialVHDialog.getBinding("items");
            if (oBinding) {
                oBinding.filter([]);
                oBinding.attachEventOnce("dataReceived", () => this._resyncMaterialSelection());
            }
            this._oMaterialVHDialog.open();
        },

        /** Checks SelectDialog rows whose Material matches an already-committed token. */
        _resyncMaterialSelection() {
            const aKeys = this.byId("IdCSNMaterialMI").getTokens().map(t => t.getKey());
            this._oMaterialVHDialog.getItems().forEach(oItem => {
                const oObj = oItem.getBindingContext()?.getObject();
                oItem.setSelected(oObj ? aKeys.includes(oObj.Material) : false);
            });
        },

        /** Commits the SelectDialog's confirmed selection as IdCSNMaterialMI tokens. */
        onConfirmMaterial(oEvent) {
            const aContexts = oEvent.getParameter("selectedContexts") || [];
            const aItems    = oEvent.getParameter("selectedItems") || [];
            const oInput    = this.byId("IdCSNMaterialMI");
            oInput.removeAllTokens();
            if (aContexts.length) {
                aContexts.forEach(oCtx => {
                    const oObj = oCtx.getObject();
                    if (!oObj?.Material) return;
                    oInput.addToken(new Token({
                        key: oObj.Material,
                        text: oObj.Material_Text ? `${oObj.Material} – ${oObj.Material_Text}` : oObj.Material
                    }));
                });
            } else {
                aItems.forEach(oItem => {
                    const sKey = oItem.getTitle();
                    if (sKey) oInput.addToken(new Token({ key: sKey, text: sKey }));
                });
            }
        },

        /** Filters the open Material dialog on Material/Material_Text; re-checks rows when cleared. */
        onLiveSearchMaterial(oEvent) {
            const sQuery   = oEvent.getParameter("value") || "";
            const oBinding = this._oMaterialVHDialog?.getBinding("items");
            if (!oBinding) return;
            if (sQuery) {
                oBinding.filter([new Filter({
                    filters: [
                        new Filter("Material",      FilterOperator.Contains, sQuery),
                        new Filter("Material_Text", FilterOperator.Contains, sQuery)
                    ],
                    and: false
                })]);
            } else {
                oBinding.filter([]);
                oBinding.attachEventOnce("dataReceived", () => this._resyncMaterialSelection());
            }
        },

        /** SelectDialog cancel — no working state to revert (selection re-syncs on next open). */
        pressToClearSearch() { },

        /** Removes deleted tokens from the Material MultiInput. */
        onMaterialTokenUpdate(oEvent) {
            if (oEvent.getParameter("type") !== "removed") return;
            const oInput = this.byId("IdCSNMaterialMI");
            oEvent.getParameter("removedTokens").forEach(t => oInput.removeToken(t));
        },

        // ── Location Value Help (Delivery / Redelivery / Interconnect) ────────────

        /** Builds a transport Tsyst OR-filter from the currently active transport keys. */
        _buildTransportFilter() {
            const aKeys = this._aCurrentTransportKeys || [];
            if (!aKeys.length) return null;
            if (aKeys.length === 1) return new Filter("Tsyst", FilterOperator.EQ, aKeys[0]);
            return new Filter({ filters: aKeys.map(k => new Filter("Tsyst", FilterOperator.EQ, k)), and: false });
        },

        /** Generic open — loads fragment once, wires JSONModel, fetches all data on every open. */
        async _openLocationVH(sType) {
            const oCfg = LOCATION_VH_CFG[sType];
            if (!this._oLocVHDialog[sType]) {
                this._oLocVHDialog[sType] = await Fragment.load({
                    id: this.getView().getId(),
                    name: oCfg.fragName,
                    controller: this
                });
                // Same model isolation pattern as transport VH — set JSONModel as
                // the dialog's default model before addDependent so {Locid}/{Locnam}
                // bindings in the fragment resolve on JSONModel, not OData V4.
                const oModel = new JSONModel([]);
                oModel.setSizeLimit(5000);
                this._oLocVHModel[sType] = oModel;
                this._oLocVHDialog[sType].setModel(oModel);
                this.getView().addDependent(this._oLocVHDialog[sType]);
                const oTable = this.byId(oCfg.tableId);
                const oTmpl = oTable.removeItem(0);   // pull XML-declared template item
                oTable.bindItems({ path: "/", template: oTmpl });
            }

            // Snapshot committed tokens → working Set so Cancel can revert
            const oInput = this.byId(oCfg.inputId);
            this._oLocSelSet[sType] = new Set((oInput?.getTokens() || []).map(t => t.getKey()));
            this._oLocNameMap[sType] = new Map();

            const oSearch = this.byId(oCfg.searchId);
            if (oSearch) oSearch.setValue("");

            // Sync selection mode to the current gas day mode before opening
            this.byId(oCfg.tableId)?.setMode(this._currentVHTableMode());

            // Open dialog immediately; populate while it shows busy
            this._oLocVHDialog[sType].open();
            this._oLocVHDialog[sType].setBusy(true);
            try {
                let aData = await this._fetchLocationKeys(sType, "");
                if (oCfg.uniqueLocid) {
                    aData = [...new Map(aData.filter(o => o.Locid).map(o => [o.Locid, o])).values()];
                }
                this._oLocAllData[sType] = aData;
                this._oLocVHModel[sType].setData(aData);
                this._onLocVHUpdateFinished(sType);
            } catch (oErr) {
                Log.error(`[CSN] ${sType} VH load failed`, oErr?.message, "confirmScheduleNomination");
                MessageBox.error(this._friendlyErrorMessage(oErr, "Failed to load data. Please try again."));
                this._oLocVHDialog[sType].close();
            } finally {
                this._oLocVHDialog[sType].setBusy(false);
            }
        },

        /** Keeps the selection Set in sync as the user checks/unchecks rows. */
        _onLocVHSelectionChange(sType, oEvent) {

            if (this._bLocSyncing[sType]) {
                return;
            }

            const bRangeMode = this._currentVHTableMode() === "SingleSelect"; // Ranges allow only one selection; gas day mode allows multiple

            const bSelected = oEvent.getParameter("selected");
            const aItems = oEvent.getParameter("listItems") || [];

            aItems.forEach(oItem => {

                const oData = oItem.getBindingContext()?.getObject();

                if (!oData?.Locid) {
                    return;
                }

                this._oLocNameMap[sType].set(oData.Locid, oData);

                if (bSelected) {

                    // RANGE mode => only one selection allowed
                    if (bRangeMode) {

                        const oTable = oEvent.getSource();

                        this._bLocSyncing[sType] = true;

                        try {

                            // Clear previous selections
                            this._oLocSelSet[sType].clear();

                            // Unselect all rows
                            oTable.removeSelections(true);

                            // Select only current row
                            oTable.setSelectedItem(oItem, true);

                            // Keep only latest selected value
                            this._oLocSelSet[sType].add(oData.Locid);

                        } finally {
                            this._bLocSyncing[sType] = false;
                        }

                    } else {

                        // SINGLE gasday mode => multi-select allowed
                        this._oLocSelSet[sType].add(oData.Locid);
                    }

                } else {

                    this._oLocSelSet[sType].delete(oData.Locid);
                }
            });
        },

        /** Resyncs checkbox state after each growing page finishes loading. */
        _onLocVHUpdateFinished(sType) {
            const oTable = this.byId(LOCATION_VH_CFG[sType].tableId);
            if (!oTable) return;
            this._bLocSyncing[sType] = true;
            oTable.getItems().forEach(oItem => {
                const oData = oItem.getBindingContext()?.getObject();
                if (!oData?.Locid) return;
                this._oLocNameMap[sType].set(oData.Locid, oData);
                oItem.setSelected(this._oLocSelSet[sType].has(oData.Locid));
            });
            this._bLocSyncing[sType] = false;
        },

        /** Local-filters _oLocAllData[sType] in memory; no OData request. */
        _onLocVHSearch(sType, oEvent) {
            const sQuery = (oEvent.getParameter("query") || oEvent.getParameter("newValue") || "").trim().toUpperCase();
            const aFiltered = sQuery
                ? (this._oLocAllData?.[sType] || []).filter(o =>
                    o.Locid?.toUpperCase().includes(sQuery) ||
                    o.Locnam?.toUpperCase().includes(sQuery))
                : (this._oLocAllData?.[sType] || []);
            this._oLocVHModel?.[sType]?.setData(aFiltered);
            this._onLocVHUpdateFinished(sType);
        },

        /** Selects all rows currently visible in the model (after search filter). */
        _onLocSelectAll(sType) {
            (this._oLocVHModel?.[sType]?.getData() || []).forEach(o => {
                this._oLocSelSet[sType].add(o.Locid);
                this._oLocNameMap[sType].set(o.Locid, o);
            });
            this._onLocVHUpdateFinished(sType);
        },

        /** Deselects all rows currently visible in the model (after search filter). */
        _onLocDeselectAll(sType) {
            (this._oLocVHModel?.[sType]?.getData() || []).forEach(o =>
                this._oLocSelSet[sType].delete(o.Locid)
            );
            this._onLocVHUpdateFinished(sType);
        },

        /** Reads all matching location rows directly from the entity — same filters as the VH table. */
        async _fetchLocationKeys(sType, sSearch) {
            const oCfg = LOCATION_VH_CFG[sType];
            const aFilters = oCfg.makeExtraFilters();
            const oTransF = this._buildTransportFilter();
            if (oTransF) aFilters.push(oTransF);
            if (sSearch) {
                aFilters.push(new Filter({
                    filters: [
                        new Filter("Locid", FilterOperator.Contains, sSearch),
                        new Filter("Locnam", FilterOperator.Contains, sSearch)
                    ],
                    and: false
                }));
            }
            return this._fetchAllPages(oCfg.entityPath, aFilters, "Locid,Locnam,Tsyst");
        },

        /** Commits working Set as tokens on the MultiInput. */
        _onLocVHConfirm(sType) {
            const oCfg = LOCATION_VH_CFG[sType];
            const oInput = this.byId(oCfg.inputId);
            oInput.removeAllTokens();
            this._oLocSelSet[sType].forEach(sKey => {
                const oEntry = this._oLocNameMap[sType].get(sKey);
                oInput.addToken(new Token({
                    key: sKey,
                    text: oEntry ? `${sKey} – ${oEntry.Locnam}` : sKey
                }));
            });
            console.log(
                "Confirm",
                sType,
                [...this._oLocSelSet[sType]]
            );
            this._clearNominationTable();
            this._oLocVHDialog[sType].close();
        },

        /** Reverts working Set to committed tokens without changing the MultiInput. */
        _onLocVHCancel(sType) {
            const oCfg = LOCATION_VH_CFG[sType];
            this._oLocSelSet[sType] = new Set(
                (this.byId(oCfg.inputId)?.getTokens() || []).map(t => t.getKey())
            );
            this._oLocVHDialog[sType].close();
        },

        // ── Typed wrappers — referenced from fragment XML ─────────────────────────
        onOpenDeliveryVH() { return this._openLocationVH("delivery"); },
        onDeliveryVHSearch(e) { this._onLocVHSearch("delivery", e); },
        onDeliveryVHSelectionChange(e) { this._onLocVHSelectionChange("delivery", e); },
        onDeliveryVHUpdateFinished() { this._onLocVHUpdateFinished("delivery"); },
        onDeliveryVHConfirm() { this._onLocVHConfirm("delivery"); },
        onDeliveryVHCancel() { this._onLocVHCancel("delivery"); },
        onDeliverySelectAll() { return this._onLocSelectAll("delivery"); },
        onDeliveryDeselectAll() { return this._onLocDeselectAll("delivery"); },

        onOpenRedeliveryVH() { return this._openLocationVH("redelivery"); },
        onRedeliveryVHSearch(e) { this._onLocVHSearch("redelivery", e); },
        onRedeliveryVHSelectionChange(e) { this._onLocVHSelectionChange("redelivery", e); },
        onRedeliveryVHUpdateFinished() { this._onLocVHUpdateFinished("redelivery"); },
        onRedeliveryVHConfirm() { this._onLocVHConfirm("redelivery"); },
        onRedeliveryVHCancel() { this._onLocVHCancel("redelivery"); },
        onRedeliverySelectAll() { return this._onLocSelectAll("redelivery"); },
        onRedeliveryDeselectAll() { return this._onLocDeselectAll("redelivery"); },

        onOpenInterconnectVH() { return this._openLocationVH("interconnect"); },
        onInterconnectVHSearch(e) { this._onLocVHSearch("interconnect", e); },
        onInterconnectVHSelectionChange(e) { this._onLocVHSelectionChange("interconnect", e); },
        onInterconnectVHUpdateFinished() { this._onLocVHUpdateFinished("interconnect"); },
        onInterconnectVHConfirm() { this._onLocVHConfirm("interconnect"); },
        onInterconnectVHCancel() { this._onLocVHCancel("interconnect"); },
        onInterconnectSelectAll() { return this._onLocSelectAll("interconnect"); },
        onInterconnectDeselectAll() { return this._onLocDeselectAll("interconnect"); },

        // ── Go ────────────────────────────────────────────────────────────────────
        async onSearch() {
            this._commitPendingLocationText();
            const sMode = this.getView().getModel("viewModel").getProperty("/gasDayMode");
            let sGasDay, aGasDayFilter, sGasDayTo;

            if (sMode === "RANGE") {
                const oDRS = this.byId("IdCSNGasDayRange");
                const oFrom = oDRS.getDateValue();
                const oTo = oDRS.getSecondDateValue();
                if (!oFrom || !oTo) {
                    MessageBox.error("Gas Day range is required.");
                    return;
                }
                const _p = n => String(n).padStart(2, "0");
                const _fmt = d => `${d.getFullYear()}-${_p(d.getMonth() + 1)}-${_p(d.getDate())}`;
                sGasDay = _fmt(oFrom);
                sGasDayTo = _fmt(oTo);
                aGasDayFilter = new Filter("Gasday", FilterOperator.BT, sGasDay, sGasDayTo);

                // At least one of Delivery or Redelivery is mandatory in Range mode
                const aDPKeys = this._getLocationKeys("IdCSNDeliveryMI");
                const aRDPKeys = this._getLocationKeys("IdCSNRedeliveryMI");
                if (!aDPKeys.length && !aRDPKeys.length) {
                    this.byId("IdCSNDeliveryMI").setValueState(ValueState.Error);
                    this.byId("IdCSNDeliveryMI").setValueStateText("Select at least one Delivery or Redelivery Point.");
                    this.byId("IdCSNRedeliveryMI").setValueState(ValueState.Error);
                    this.byId("IdCSNRedeliveryMI").setValueStateText("Select at least one Delivery or Redelivery Point.");
                    MessageBox.error("Please select at least one Delivery Point or Redelivery Point when using Gas Day Range.");
                    return;
                }

                // In RANGE mode: only one token allowed across both Delivery and Redelivery combined
                const iTotalTokens = aDPKeys.length + aRDPKeys.length;
                if (iTotalTokens > 1) {
                    this.byId("IdCSNDeliveryMI").setValueState(ValueState.Error);
                    this.byId("IdCSNDeliveryMI").setValueStateText("Only one Delivery or Redelivery Point allowed in Range mode.");
                    this.byId("IdCSNRedeliveryMI").setValueState(ValueState.Error);
                    this.byId("IdCSNRedeliveryMI").setValueStateText("Only one Delivery or Redelivery Point allowed in Range mode.");
                    MessageBox.error("Only one Delivery or Redelivery Point is allowed when using Gas Day Range.");
                    return;
                }

                this.byId("IdCSNDeliveryMI").setValueState(ValueState.None);
                this.byId("IdCSNRedeliveryMI").setValueState(ValueState.None);
            } else {
                sGasDay = this.byId("IdCSNGasDay").getValue();
                if (!sGasDay) {
                    MessageBox.error("Gas Day is required.");
                    return;
                }
                aGasDayFilter = new Filter("Gasday", FilterOperator.EQ, sGasDay);
                // Clear any location error states left from a prior RANGE attempt
                this.byId("IdCSNDeliveryMI").setValueState(ValueState.None);
                this.byId("IdCSNRedeliveryMI").setValueState(ValueState.None);
            }

            let aTransportKeys = this._getTransportKeys();
            this._clearTransportValueState();
            if (!(await this._validateRedeliveryInTransport(aTransportKeys))) return;

            // No Transport System explicitly chosen — default to every YA transport
            // system (the same set the Transport VH dropdown offers) instead of
            // showing contracts from every transport system that has nominations.
            // Resolved server-side via the TS_DEFAULT_YA sentinel (before:READ hook,
            // balancingScheduling-service.js) rather than fetched and enumerated here
            // as an explicit per-code OR filter — with 1000+ 'YA' transport systems in
            // some tenants, embedding every single code into this request's own
            // $filter exceeded the browser/Node HTTP request-line size limit (431
            // Request Header Fields Too Large) before the request ever left the
            // client. aTransportKeys deliberately stays empty here — it also gates the
            // Redelivery Point auto-derive call just below, which would hit the same
            // per-code URL-size problem for the same reason.
            const bDefaultToAllYA = !aTransportKeys.length;

            const aFilters = [aGasDayFilter];
            if (bDefaultToAllYA) {
                aFilters.push(new Filter("TransportSystem", FilterOperator.EQ, TS_DEFAULT_YA));
            } else {
                this._addOrFilter(aFilters, aTransportKeys, "TransportSystem");
            }
            const aDPKeys = this._getLocationKeys("IdCSNDeliveryMI");
            const aRDPKeys = this._getLocationKeys("IdCSNRedeliveryMI");
            const aICKeys = this._getLocationKeys("IdCSNInterconnectMI");

            // A Transport System selection with no explicit Delivery/Redelivery Point
            // is deliberately left TS-only here (no client-side auto-derive-then-embed
            // of its Redelivery Points into an explicit filter) — the backend's own
            // before:READ hook (balancingScheduling-service.js) already resolves a
            // TS-only xGMSxNOMSOURCE query server-side via resolveLocationsByTS +
            // chunked fetch (_fetchAndMergeTsOnly), which that file's own doc comment
            // confirms is a trustworthy, non-leaking signal — location membership
            // alone, no row-level TS re-check needed. This screen used to resolve and
            // embed that same location set itself as an explicit RedeliveryPoint OR
            // filter (one "eq" per Locid) specifically to avoid relying on that
            // server-side path; for a Transport System spanning thousands of Redelivery
            // Points that filter grew large enough to overflow the request's own
            // header/multipart-part size limit (431 Request Header Fields Too Large /
            // CAP's own "Header overflow" $batch parse error) before ever reaching the
            // backend. Fixed now that the backend path itself is known-safe.

            // Merge IC into both sides and deduplicate — prevents the same locid
            // appearing in both a standalone DP condition and the IC sub-filter,
            // and avoids an AND between DP and RDP that would return empty results.
            const aAllDP = [...new Set([...aDPKeys, ...aICKeys])];
            const aAllRDP = [...new Set([...aRDPKeys, ...aICKeys])];

            // One combined (DP IN [...] OR RDP IN [...]) filter.
            if (aAllDP.length || aAllRDP.length) {
                const aLocF = [
                    ...aAllDP.map(k => new Filter("DeliveryPoint", FilterOperator.EQ, k)),
                    ...aAllRDP.map(k => new Filter("RedeliveryPoint", FilterOperator.EQ, k))
                ];
                aFilters.push(aLocF.length === 1 ? aLocF[0] : new Filter({ filters: aLocF, and: false }));
            }

            const aDocKeys = this.byId("IdCSNDocType").getSelectedKeys();
            if (aDocKeys.length) {
                this._addOrFilter(aFilters, aDocKeys, "ContractType");
            }

            const aMatKeys = this.byId("IdCSNMaterialMI").getTokens().map(t => t.getKey());
            if (aMatKeys.length) {
                this._addOrFilter(aFilters, aMatKeys, "Material");
            }

            const oVM = this.getView().getModel("viewModel");
            oVM.setProperty("/noDataIcon", "sap-icon://search");
            oVM.setProperty("/noDataTitle", "No Nominations Found");
            oVM.setProperty("/noDataText", "No data matches the selected filters");

            this._aCurrentFilters = aFilters;
            this._sAggGasDay = sGasDay;
            this._sAggGasDayTo = sGasDayTo || sGasDay;
            this._aGasDayFilter = aGasDayFilter;
            this._aAggTransportKeys = aTransportKeys;
            this._sCurrentSegment = "NOT_CONFIRMED";
            this._clearAggDisplay();
            this.byId("IdCSNSBConfirmedFilter")?.setSelectedKey("NOT_CONFIRMED");
            const nomTable = this.byId("IdCSNTable");
            nomTable.setSelectionMode("Multi");
            nomTable.setEnableSelectAll(true);
            this._applySegmentFilter("NOT_CONFIRMED");
        },


        /** Turns an ID typed into a location MultiInput but never tokenized into a token,
         *  so Go filters by it instead of silently ignoring it. */
        _commitPendingLocationText() {
            LOCATION_MI_IDS.forEach(sId => {
                const oInput = this.byId(sId);
                const sText = oInput?.getValue()?.trim();
                if (!sText) return;
                const oPresent = new Set(oInput.getTokens().map(t => t.getKey()));
                sText.split(/[\r\n,;]+/).map(v => v.split("\t")[0].trim()).filter(Boolean).forEach(sKey => {
                    if (!oPresent.has(sKey)) {
                        oInput.addToken(new Token({ key: sKey, text: sKey }));
                        oPresent.add(sKey);
                    }
                });
                oInput.setValue("");
            });
        },

        /** Transport System + Redelivery Point both filled: every RDP token must be mapped
         *  to one of the selected Transport Systems (same list the Redelivery VH shows). */
        async _validateRedeliveryInTransport(aTransportKeys) {
            const oRDPInput = this.byId("IdCSNRedeliveryMI");
            const aRdpKeys = this._getLocationKeys("IdCSNRedeliveryMI");
            if (!aTransportKeys.length || !aRdpKeys.length) return true;

            const oBundle = this.getOwnerComponent().getModel("i18n").getResourceBundle();
            let aAllowed;
            try {
                aAllowed = await this._fetchLocationKeys("redelivery", "");
            } catch (oErr) {
                Log.error("[CSN] Redelivery/Transport validation failed", oErr?.message, "confirmScheduleNomination");
                MessageBox.error(oBundle.getText("antErrRdpTransportCheckFailed"));
                return false;
            }

            const norm = v => String(v || "").trim().toUpperCase();
            const oAllowed = new Set(aAllowed.map(o => norm(o.Locid)));
            const aInvalid = aRdpKeys.filter(k => !oAllowed.has(norm(k)));
            if (!aInvalid.length) return true;

            const sMsg = oBundle.getText("antErrRdpNotInTransport", [aInvalid.join(", "), aTransportKeys.join(", ")]);
            oRDPInput.setValueState(ValueState.Error);
            oRDPInput.setValueStateText(sMsg);
            MessageBox.error(sMsg);
            return false;
        },

        _applyFiltersToTable(aFilters) {
            const oTable = this.byId("IdCSNTable");
            const oSegment = this.byId("IdCSNSBConfirmedFilter");
            const selectedKey = oSegment?.getSelectedKey() || "NOT_CONFIRMED";
            if (!oTable) return;

            // After unbindRows() on clear the binding is gone — recreate it before filtering
            let oBinding = oTable.getBinding("rows");
            if (!oBinding) {
                oTable.bindRows({
                    path: "/xGMSxNOMSOURCE",
                    parameters: {
                        $select: NOMSOURCE_SELECT,
                        $count: true,
                        $$ownRequest: true
                    }
                });
                oBinding = oTable.getBinding("rows");
            }
            if (!oBinding) return;

            oBinding.filter(aFilters, FilterType.Application);
            if (oBinding.isSuspended()) {
                oBinding.resume();
            }

            if (selectedKey === "ALL") {
                oTable.setSelectionMode("Multi");
                oTable.setEnableSelectAll(false);
            }
            else if (selectedKey === "CONFIRMED") {
                oTable.setSelectionMode("None");
                oTable.setEnableSelectAll(false);
            }
            else if (selectedKey === "NOT_CONFIRMED") {
                oTable.setSelectionMode("Multi");
                oTable.setEnableSelectAll(true);
            }
        },

        /**
         * Column-header search. The table's own filter would reach the backend inside
         * $filter, mixed with the filter bar's conditions on the same fields — so it
         * is replaced by the `colFilter` custom query option, applied by the
         * xGMSxNOMSOURCE READ over the final arranged rows. "=value" is an exact
         * match, anything else "contains"; leading zeros are ignored backend-side.
         */
        onCSNColumnFilter(oEvent) {
            oEvent.preventDefault();
            const oColumn = oEvent.getParameter("column");
            const sValue = (oEvent.getParameter("value") || "").trim();
            oColumn.setFilterValue(sValue);
            oColumn.setFiltered(!!sValue);
            this._applyColumnFilters();
        },

        _applyColumnFilters() {
            const oTable = this.byId("IdCSNTable");
            const oBinding = oTable?.getBinding("rows");
            if (!oBinding) return;
            const aColFilters = oTable.getColumns()
                .filter(c => c.getFiltered() && c.getFilterProperty() && c.getFilterValue())
                .map(c => {
                    const s = c.getFilterValue().trim();
                    return s.startsWith("=")
                        ? { f: c.getFilterProperty(), op: "eq", v: s.slice(1).trim() }
                        : { f: c.getFilterProperty(), op: "contains", v: s };
                });
            // undefined removes the option from the request
            this._sColFilter = aColFilters.length ? JSON.stringify(aColFilters) : undefined;
            oBinding.changeParameters({ colFilter: this._sColFilter });
        },

        /** Clears every column's search/sort indicator. Table#sort() without a column also
         *  removes the binding's sorters (if still bound) and the table's own sorted list. */
        _resetColumnFilterSort() {
            const oTable = this.byId("IdCSNTable");
            if (!oTable) return;
            oTable.getColumns().forEach(c => {
                c.setFilterValue("");
                c.setFiltered(false);
            });
            oTable.sort();
            this._sColFilter = undefined;
        },

        onTableRowsUpdated() {
            // Data changed — invalidate memoized link maps; rebuilt lazily on
            // the next selection change.
            this._oLinkMapsPromise = null;

            const oTable = this.byId("IdCSNTable");
            const oBinding = oTable?.getBinding("rows");
            if (!oBinding) return;

            const nCount = oBinding.getCount?.() ?? oBinding.getLength?.() ?? 0;
            this.byId("IdCSNTableTitle")?.setText(`Schedule Nominations (${nCount})`);

            // Recompute straight from whatever the table is currently bound to —
            // guarantees the Aggregated DNQ header always equals the sum of the
            // table's own rows for the active Gasday/filter/segment combination.
            if (nCount > 0) {
                this._computeAggFromTable(oBinding, nCount);
                this._computeMonthlyQtyIssues(oBinding, nCount);
            } else {
                this._clearAggDisplay();
                this._ensureCsnDataIssuesModel().setData({ Count: 0, Violations: [] });
            }

            const SOURCE_CLASSES = ["csnSrcSystem", "csnSrcManual", "csnSrcCustomer"];
            oTable.getRows().forEach(oRow => {
                const oDom = oRow.getDomRef();
                if (!oDom) return;
                SOURCE_CLASSES.forEach(c => oDom.classList.remove(c));

                const oCtx = oRow.getBindingContext();
                if (!oCtx) return;

                switch ((oCtx.getProperty("Source") || "").toUpperCase()) {
                    case "SYSTEM": oDom.classList.add("csnSrcSystem"); break;
                    case "MANUAL": oDom.classList.add("csnSrcManual"); break;
                    case "CUSTOMER": // intentional fall-through
                    case "PORTAL": oDom.classList.add("csnSrcCustomer"); break;
                    default: break;
                }
            });
        },

        /**
         * Builds (once per data load, memoized as a Promise in _oLinkMapsPromise,
         * invalidated in onTableRowsUpdated) every map onRowSelectionChange's link-
         * chain traversal needs:
         *  - mByContract: Gasday|ContractNo → row indices sharing that key.
         *  - mParentOf/mChildOf: CorrespondingDocNo pairing (Gasday-scoped, 1:1).
         *  - mIsPrimary: Gasday|ContractNo → that row's own IsPrimaryContract.
         *  - mMasterContractOf/mByMasterContract: Master Contract sibling groups
         *    (Gasday-scoped) — traversal only follows this edge from a row whose
         *    OWN IsPrimaryContract is true; a non-primary row links via
         *    CorrespondingDocNo/LinkContexist only, never Master Contract.
         *  - mLinkChildOf/mLinkChildrenOf: LinkContexist='X' JOIN pairing (1
         *    parent → many children, unlike CorrespondingDocNo) — mirrors
         *    balancingScheduling-service.js's own server-side Stage 2
         *    (getLinkedContracts, LINKCONT ↔ Contract_NO) so the selection
         *    link-chain sees the same linked-contract relationships the backend
         *    already arranges into the table's row order. Not Gasday-scoped on
         *    the join entity itself (no Gasday field there); the child row is
         *    keyed under the PARENT row's own Gasday, same convention
         *    CorrespondingDocNo pairing already uses.
         */
        async _buildLinkMaps(aAllContexts) {
            const mByContract = new Map();
            const mParentOf = new Map();
            const mChildOf = new Map();
            const mIsPrimary = new Map();
            const mMasterContractOf = new Map(); // contract sKey → its Master Contract group key
            const mByMasterContract = new Map(); // Master Contract group key → Set<contract sKey>
            const mLinkContexistParents = new Map(); // bare ContractNo → { sKey, sGd }, LinkContexist='X' rows

            aAllContexts.forEach((oCtx, iIdx) => {
                if (!oCtx) return;
                const oData = oCtx.getObject();
                const sCon = String(oData.ContractNo ?? "");
                if (!sCon) return;
                const sGd = String(oData.Gasday ?? "");
                const sKey = `${sGd}|${sCon}`;
                let a = mByContract.get(sKey);
                if (!a) mByContract.set(sKey, a = []);
                a.push(iIdx);

                mIsPrimary.set(sKey, oData.IsPrimaryContract === true);

                const sDoc = String(oData.CorrespondingDocNo ?? "").trim();
                if (sDoc) {
                    mChildOf.set(sKey, `${sGd}|${sDoc}`);
                    mParentOf.set(`${sGd}|${sDoc}`, sKey);
                }

                // Master Contract siblings — scoped by Gasday, same convention as the
                // Master Contract DCQ pooling above (never MasterContractNo alone).
                const sMC = String(oData.MasterContractNo ?? "").trim();
                if (sMC) {
                    const sMCKey = `${sGd}|MC|${sMC}`;
                    mMasterContractOf.set(sKey, sMCKey);
                    let oSiblings = mByMasterContract.get(sMCKey);
                    if (!oSiblings) mByMasterContract.set(sMCKey, oSiblings = new Set());
                    oSiblings.add(sKey);
                }

                if (String(oData.LinkContexist ?? "").trim().toUpperCase() === "X") {
                    mLinkContexistParents.set(sCon, { sKey, sGd });
                }
            });

            const mLinkChildOf = new Map();     // child sKey → parent sKey
            const mLinkChildrenOf = new Map();  // parent sKey → Set<child sKey>
            if (mLinkContexistParents.size) {
                try {
                    const aParents = [...mLinkContexistParents.keys()];
                    // _fetchAllPages ANDs every entry of its aFilters array together —
                    // must be one OR-group (LINKCONT = p1 OR p2 OR …), not one entry per
                    // parent, or a table with more than one LinkContexist parent would
                    // never match anything.
                    const aParentFilters = aParents.map(p => new Filter("LINKCONT", FilterOperator.EQ, p));
                    const oParentFilter = aParentFilters.length === 1
                        ? aParentFilters[0]
                        : new Filter({ filters: aParentFilters, and: false });
                    const aJoinRows = await this._fetchAllPages(
                        "/getLinkedContracts",
                        [oParentFilter],
                        "ITEM,LINKCONT,Contract_NO,linkcont_flag"
                    );
                    aJoinRows.forEach(jr => {
                        if (jr.linkcont_flag !== "X") return;
                        const sChild = String(jr.Contract_NO ?? "").trim();
                        const sParent = String(jr.LINKCONT ?? "").trim();
                        if (!sChild || !sParent) return;
                        const oParentInfo = mLinkContexistParents.get(sParent);
                        if (!oParentInfo) return;
                        const sChildKey = `${oParentInfo.sGd}|${sChild}`;
                        mLinkChildOf.set(sChildKey, oParentInfo.sKey);
                        let oChildren = mLinkChildrenOf.get(oParentInfo.sKey);
                        if (!oChildren) mLinkChildrenOf.set(oParentInfo.sKey, oChildren = new Set());
                        oChildren.add(sChildKey);
                    });
                } catch (oErr) {
                    Log.error("[CSN] getLinkedContracts fetch failed — LinkContexist link-chain edges unavailable this pass", oErr?.message, "confirmScheduleNomination");
                }
            }

            return { mByContract, mParentOf, mChildOf, mIsPrimary, mMasterContractOf, mByMasterContract, mLinkChildOf, mLinkChildrenOf };
        },

        /**
         * Bidirectional link selection:
         * selecting a row auto-selects its CorrespondingDocNo rows (children)
         * and selecting a child auto-selects its parent — and vice-versa on
         * deselect. Link group = same Gasday, ContractNo ↔ CorrespondingDocNo.
         * Also extends via LinkContexist='X' JOIN pairing (see _buildLinkMaps) —
         * a parent auto-selects every one of its linked children and vice versa.
         * Also extends the SAME group transitively to every other contract
         * sharing the row's MasterContractNo (same Gasday) — but ONLY from a row
         * whose own IsPrimaryContract is true; a non-primary row never expands
         * via Master Contract, only via CorrespondingDocNo/LinkContexist. Since
         * group expansion is a single stack-based traversal, a Master Contract
         * sibling that itself has its own CorrespondingDocNo/LinkContexist link
         * pulls that link's rows in too.
         * Link maps are memoized per data load (invalidated in onTableRowsUpdated,
         * fetched via _buildLinkMaps — LinkContexist edges need a getLinkedContracts
         * round trip, so the whole build is async and memoized as a Promise).
         */
        async onRowSelectionChange(oEvent) {
            if (this._bSyncingSelection) return;
            if (!oEvent.getParameter("userInteraction")) return;

            const oTable = this.byId("IdCSNTable");

            const oBinding = oTable.getBinding("rows");
            if (!oBinding) return;

            const aChangedIndices = oEvent.getParameter("rowIndices") || [];
            if (!aChangedIndices.length) return;

            const aAllContexts = oBinding.getContexts(0, oBinding.getLength());
            const oSelectedSet = new Set(oTable.getSelectedIndices());

            // ── Block selection of already-confirmed rows ─────────────────────────
            // Deselect any newly-selected row where isConfirmRequired = false/No.
            // Must run before link-chain so confirmed partners aren't force-selected.
            const aBlocked = aChangedIndices.filter(iIdx => {
                if (!oSelectedSet.has(iIdx)) return false;   // deselect event — not a block
                const oData = aAllContexts[iIdx]?.getObject();
                if (!oData) return false;
                const v = oData.isConfirmRequired;
                return v === false || v === "false" || v === "No";
            });

            if (aBlocked.length) {
                this._bSyncingSelection = true;
                try {
                    aBlocked.forEach(iIdx => oTable.removeSelectionInterval(iIdx, iIdx));
                } finally {
                    this._bSyncingSelection = false;
                }
                MessageToast.show("Already confirmed nominations cannot be selected.");
                // Remove blocked indices — only process remaining changed rows
                const oBlockedSet = new Set(aBlocked);
                const aRemaining = aChangedIndices.filter(i => !oBlockedSet.has(i));
                if (!aRemaining.length) return;
                // Rebuild selectedSet after deselect so link-chain sees correct state
                oSelectedSet.clear();
                oTable.getSelectedIndices().forEach(i => oSelectedSet.add(i));
                // Reassign so link-chain below uses filtered list
                aChangedIndices.length = 0;
                aRemaining.forEach((v, i) => (aChangedIndices[i] = v));
            }

            // ── memoized link maps ────────────────────────────────────────────────
            if (!this._oLinkMapsPromise) {
                this._oLinkMapsPromise = this._buildLinkMaps(aAllContexts);
            }
            const { mByContract, mParentOf, mChildOf, mIsPrimary, mMasterContractOf, mByMasterContract, mLinkChildOf, mLinkChildrenOf } = await this._oLinkMapsPromise;

            // ── resolve full link group per changed row ───────────────────────────
            const mTargetState = new Map();
            aChangedIndices.forEach(iIdx => {
                const oCtx = aAllContexts[iIdx];
                if (!oCtx) return;
                const bSel = oSelectedSet.has(iIdx);
                const sGd = String(oCtx.getProperty("Gasday") ?? "");
                const sKey = `${sGd}|${String(oCtx.getProperty("ContractNo") ?? "")}`;

                const oGroup = new Set([sKey]);
                const aStack = [sKey];
                while (aStack.length) {
                    const k = aStack.pop();
                    const aNext = [mChildOf.get(k), mParentOf.get(k), mLinkChildOf.get(k)];
                    mLinkChildrenOf.get(k)?.forEach(sChildKey => aNext.push(sChildKey));
                    // Master Contract sibling expansion only from a row that is
                    // itself IsPrimaryContract=true — see this function's doc comment.
                    const sMCKey = mIsPrimary.get(k) ? mMasterContractOf.get(k) : undefined;
                    if (sMCKey) mByMasterContract.get(sMCKey)?.forEach(sSibling => aNext.push(sSibling));
                    for (const next of aNext) {
                        if (next && !oGroup.has(next)) { oGroup.add(next); aStack.push(next); }
                    }
                }

                oGroup.forEach(k => (mByContract.get(k) || [])
                    .forEach(i => {
                        // Never force-select an already-confirmed partner via link-chain
                        if (bSel) {
                            const oD = aAllContexts[i]?.getObject();
                            const v = oD?.isConfirmRequired;
                            if (v === false || v === "false" || v === "No") return;
                        }
                        mTargetState.set(i, bSel);
                    }));
            });

            if (!mTargetState.size) return;

            this._bSyncingSelection = true;
            try {
                mTargetState.forEach((bSel, iIdx) => {
                    if (bSel === oSelectedSet.has(iIdx)) return;
                    if (bSel) oTable.addSelectionInterval(iIdx, iIdx);
                    else oTable.removeSelectionInterval(iIdx, iIdx);
                });
            } finally {
                this._bSyncingSelection = false;
            }
        },

        onRefreshTable() {
            const oBinding = this.byId("IdCSNTable")?.getBinding("rows");
            if (!oBinding || oBinding.isSuspended()) return;

            // _sCurrentSegment is preserved — agg reflects whichever segment was active.
            // onTableRowsUpdated recomputes the agg from the table once refreshed rows land.
            this._clearAggDisplay();

            // Refresh also drops any column-header search/sort, back to the full,
            // arranged result. Removing them reloads the binding by itself — a
            // separate refresh() on top would only send a second request.
            const bHasColFilter = !!this._sColFilter;
            const bHasColSort = this.byId("IdCSNTable").getColumns().some(c => c.getSortOrder() !== "None");
            this._resetColumnFilterSort();   // also removes the binding's sorters (Table#sort)
            if (bHasColFilter) oBinding.changeParameters({ colFilter: undefined });
            if (!bHasColSort && !bHasColFilter) oBinding.refresh();
        },

        // ── Segmented Button: All / Confirmed / Not Confirmed ─────────────────────
        onSegmentedButtonFilter(oEvent) {
            const selectedKey = oEvent.getParameter("item").getKey();
            const nomTable = this.byId("IdCSNTable");
            if (selectedKey === "ALL") {
                nomTable.setSelectionMode("Multi");
                nomTable.setEnableSelectAll(false);
            }
            else if (selectedKey === "CONFIRMED") {
                nomTable.setSelectionMode("None");
                nomTable.setEnableSelectAll(false);
            }
            else if (selectedKey === "NOT_CONFIRMED") {
                nomTable.setSelectionMode("Multi");
                nomTable.setEnableSelectAll(true);
            }
            // No active search — do not resume the binding
            if (!this._aCurrentFilters?.length) return;
            const sKey = oEvent.getParameter("item").getKey();
            this._applySegmentFilter(sKey);
        },

        _applySegmentFilter(sKey) {
            this._sCurrentSegment = sKey;
            const oTable = this.byId("IdCSNTable");
            const oVM = this.getView().getModel("viewModel");
            // oVM.setProperty("/tableSelectionMode", sKey === "CONFIRMED" ? "None" : "MultiToggle");
            // oVM.setProperty("/enableSelectAll", sKey === "NOT_CONFIRMED");
            // sap.ui.table.Table selection is index-based, not key-based — switching
            // segments changes which rows occupy which index (ALL and NOT_CONFIRMED
            // apply different isConfirmRequired filters), so a selected index from the
            // old segment can silently point at an unrelated row (possibly already
            // confirmed) in the new one without ever re-validating through
            // onRowSelectionChange (that guard only runs on userInteraction). Must
            // clear on every segment switch, not just when landing on CONFIRMED.
            oTable?.clearSelection();

            const aBase = this._aCurrentFilters ? [...this._aCurrentFilters] : [];
            if (sKey === "CONFIRMED") {
                aBase.push(new Filter("isConfirmRequired", FilterOperator.EQ, false));
            } else if (sKey === "NOT_CONFIRMED") {
                aBase.push(new Filter("isConfirmRequired", FilterOperator.EQ, true));
            }
            this._applyFiltersToTable(aBase);
            // onTableRowsUpdated recomputes the agg from the table's own rows once the
            // re-filtered data lands — no separate network round trip needed here.
        },

        /** @param {string[]} aKeys — plain key strings */
        _addOrFilter(aFilters, aKeys, sField) {
            if (!aKeys.length) return;
            const aF = aKeys.map(k => new Filter(sField, FilterOperator.EQ, k));
            aFilters.push(aF.length === 1 ? aF[0] : new Filter({ filters: aF, and: false }));
        },

        _clearTransportValueState() {
            this.byId("IdCSNTransportMI")?.setValueState(ValueState.None);
        },

        // /** @param {string} sCustomerKind @param {string} sCustomerKind1 */
        // fmtCustomerType(sCustomerKind, sCustomerKind1) {
        //     return sCustomerKind || sCustomerKind1 || "OWN";
        // },

        fmtConditionalQty(sDeliveryPoint, vDelivery, vRedelivery, vLinkedGsa) {
            // Unbundled CT leg — the linked GSA's DCQ/limit applies (LinkedGsa*).
            if (vLinkedGsa !== null && vLinkedGsa !== undefined && vLinkedGsa !== "") return vLinkedGsa;
            return sDeliveryPoint ? vDelivery : vRedelivery;
        },

        /** @param {string} sProjectedStatus - OK | CAPPED | WOULD_REJECT (see ari004Rules.js) */
        formatProjectedStatus(sProjectedStatus) {
            return { OK: "None", CAPPED: "Warning", WOULD_REJECT: "Error" }[sProjectedStatus] || "None";
        },

        /** @param {string} sSource */
        fmtSourceText(sSource) {
            return sSource ? sSource.toUpperCase() : "";
        },

        /**
         * @param {string} sSource
         * @returns {"Success"|"Warning"|"Information"|"None"}
         */
        fmtSourceState(sSource) {
            switch ((sSource || "").toUpperCase()) {
                case "CUSTOMER": return "Success";     // green
                case "MANUAL": return "Warning";       // amber
                case "SYSTEM": return "Information";   // blue
                default: return "None";
            }
        },

        // ── Aggregated Proposed DNQ display ──────────────────────────────────────
        /**
         * Sums ProposedDNQ by Side (Delivery/Redelivery) + UOM directly from the
         * table's own bound rows — no separate backend call, so the header total
         * can never drift from what the table actually displays (Gasday, location,
         * doc type, material and Confirmed/Not-Confirmed segment filters are all
         * already baked into the binding's current rows).
         * @param {object} oBinding - table's "rows" list binding
         * @param {number} nCount
         */
        _computeAggFromTable(oBinding, nCount) {
            const aContexts = oBinding.getContexts(0, nCount);

            const oAgg = Object.create(null);
            for (const oCtx of aContexts) {
                if (!oCtx) continue;
                const oRow = oCtx.getObject();
                if (!oRow) continue;
                const side = oRow.DeliveryPoint ? "Delivery" : "Redelivery";
                const uom = oRow.UOM ?? "";
                const key = `${side}::${uom}`;
                const qty = Number(oRow.ProposedDNQ) || 0;
                if (!oAgg[key]) oAgg[key] = { Side: side, UOM: uom, TotalDNQ: 0 };
                oAgg[key].TotalDNQ = Math.round((oAgg[key].TotalDNQ + qty) * 1000) / 1000;
            }

            const aResult = Object.values(oAgg).sort((a, b) =>
                a.Side === b.Side
                    ? a.UOM.localeCompare(b.UOM)
                    : a.Side === "Delivery" ? -1 : 1
            );
            this._setAggCSNDisplay(aResult);
        },

        _setAggCSNDisplay(aResults) {
            const fmtNum = n =>
                Number(n).toLocaleString("en-US", { minimumFractionDigits: 3, maximumFractionDigits: 3 });

            const fmtGroup = (sSide) => {
                const aItems = aResults.filter(r => r.Side === sSide);
                if (!aItems.length) return "";
                return aItems.map(r =>
                    `<span style="color:#0854a0;font-weight:bold;font-size:0.875rem;">${fmtNum(r.TotalDNQ)}</span>` +
                    `&#160;<span style="color:#6a6d70;font-size:0.775rem;font-weight:normal;">${r.UOM}</span>`
                ).join(",&nbsp;");
            };

            const oAggModel = this.getView().getModel("aggCSN");
            oAggModel?.setProperty("/deliveryText", fmtGroup("Delivery"));
            oAggModel?.setProperty("/redeliveryText", fmtGroup("Redelivery"));
        },

        _clearAggDisplay() {
            const oAggModel = this.getView().getModel("aggCSN");
            oAggModel?.setProperty("/deliveryText", "");
            oAggModel?.setProperty("/redeliveryText", "");
        },

        // ── Export to Excel ───────────────────────────────────────────────────────
        onExportToExcel() {
            const oBinding = this.byId("IdCSNTable")?.getBinding("rows");

            if (!oBinding || oBinding.isSuspended()) {
                MessageBox.information("Apply filters and press Go before exporting.");
                return;
            }

            // getCount() is available immediately — $count:true was set on the binding.
            // It reflects the current active filter (Gasday + Transport + DP/RDP + segment).
            // No additional backend call needed.
            const nTotal = oBinding.getCount?.() ?? 0;
            if (nTotal === 0) {
                MessageBox.information("No data to export.");
                return;
            }

            const nFmt = nTotal.toLocaleString();
            const sDetail = nTotal > 5000
                ? `\n\nThis is a large dataset (${nFmt} rows). Export may take a moment.`
                : "";

            MessageBox.confirm(`Export ${nFmt} row(s) to Excel?${sDetail}`, {
                title: "Export to Spreadsheet",
                onClose: sAction => {
                    if (sAction === MessageBox.Action.OK) {
                        this._executeExport(oBinding, nTotal);
                    }
                }
            });
        },

        /**
         * Fetches ALL rows for the current filter via requestContexts, then
         * builds and triggers an XLSX download via sap/ui/export/Spreadsheet.
         *
         * requestContexts(0, nTotal) sends $top=nTotal to the OData V4 model.
         * The model handles server-driven pagination (nextLink) internally —
         * the promise resolves only when all pages have been received.
         * Node.js holds nothing; rows land in the V4 binding cache temporarily
         * and are released after oSheet.destroy().
         *
         * @param {sap.ui.model.odata.v4.ODataListBinding} oBinding
         * @param {number} nTotal
         */
        async _executeExport(oBinding, nTotal) {
            BusyIndicator.show(0);
            let oSheet;
            try {
                const aContexts = await oBinding.requestContexts(0, nTotal);
                // OData V4 returns Gasday as ISO string "YYYY-MM-DD".
                // EdmType.String is used; reformat to displayFormat dd-MM-yyyy here.
                const aData = aContexts.map(ctx => {
                    const oObj = ctx.getObject();
                    const sRaw = oObj.Gasday ? String(oObj.Gasday).slice(0, 10) : "";
                    const sFormatted = sRaw
                        ? sRaw.split("-").reverse().join("-")   // "2026-05-31" → "31-05-2026"
                        : "";
                    return Object.assign({}, oObj, { Gasday: sFormatted });
                });

                oSheet = new Spreadsheet({
                    dataSource: aData,
                    workbook: {
                        columns: _EXPORT_COLS,
                        context: { sheetName: "Schedule Nominations" }
                    },
                    fileName: `ScheduleNominations_${this._sAggGasDay || "export"}.xlsx`
                });

                await oSheet.build();
            } catch (err) {
                Log.error("[CSN] Export failed", err.message, "confirmScheduleNomination");
                MessageBox.error(`Export failed. Please try again.\n${err.message || ""}`);
            } finally {
                BusyIndicator.hide();
                oSheet?.destroy();
            }
        },

        // ── Clear ─────────────────────────────────────────────────────────────────
        onClearFilters() {
            // ── Filter controls ───────────────────────────────────────────────
            this.byId("IdCSNGasDay").setValue("");
            this.byId("IdCSNGasDayModeSB").setSelectedKey("SINGLE");
            this.byId("IdCSNGasDayRange")?.setValue("");
            this._clearTransportValueState();
            this.byId("IdCSNTransportMI")?.removeAllTokens();
            LOCATION_MI_IDS.forEach(sId => {
                this.byId(sId)?.removeAllTokens();
                this.byId(sId)?.setValueState(ValueState.None);
            });
            this.byId("IdCSNDocType").setSelectedKeys([]);
            this.byId("IdCSNMaterialMI").setTokens([]);
            this._syncTransportCascade([]);

            // ── Table binding — unbind clears cached contexts so noData shows ──
            const oTable = this.byId("IdCSNTable");
            oTable.setSelectionMode("Multi");
            oTable.setEnableSelectAll(true);
            oTable?.unbindRows();
            oTable?.clearSelection();
            this._resetColumnFilterSort();
            this.byId("IdCSNTableTitle")?.setText("Schedule Nominations");

            // ── Segment button ────────────────────────────────────────────────
            this.byId("IdCSNSBConfirmedFilter")?.setSelectedKey("NOT_CONFIRMED");
            const oVM = this.getView().getModel("viewModel");
            oVM.setProperty("/tableSelectionMode", "MultiToggle");
            oVM.setProperty("/enableSelectAll", false);

            // ── Controller state ──────────────────────────────────────────────
            this._aCurrentFilters = [];
            this._sAggGasDay = null;
            this._sAggGasDayTo = null;
            this._aGasDayFilter = null;
            this._aAggTransportKeys = [];
            this._sCurrentSegment = null;
            this._oLinkMapsPromise = null;
            this._clearAggDisplay();

            // ── noData message — back to initial prompt ───────────────────────
            oVM.setProperty("/gasDayMode", "SINGLE");
            oVM.setProperty("/noDataIcon", "sap-icon://filter");
            oVM.setProperty("/noDataTitle", "No Nominations Loaded");
            oVM.setProperty("/noDataText", "Select Transport System and Gas Day, then press Go");
        },

        // ── Nomination Logs Dialog ──────────────────────────────────────────────────

        /** Opens the full-size Nomination Logs dialog; fragment + mdc.Table load once. */
        async onOpenNominationLogs() {
            if (!this._oNominationLogsDialog) {
                this._oNominationLogsDialog = await Fragment.load({
                    id: this.getView().getId(),
                    name: "com.ingenx.igmsgasflow.fragments.CSNNominationLogs",
                    controller: this
                });
                this.getView().addDependent(this._oNominationLogsDialog);
            }
            this.byId("IdCSNLogsGasDayRange")?.setValue("");
            this.byId("IdCSNLogsGasDayRange")?.setValueState(ValueState.None);
            this.byId("IdCSNLogsMsgIndicatorSB")?.setSelectedKey("ALL");
            this._oNominationLogsDialog.open();
        },

        /** Clears the loaded rows (drops the Gas Day range + quick filter from the payload + rebinds) before closing. */
        onCloseNominationLogs() {
            const oTable = this.byId("IdCSNNominationLogsTable");
            if (oTable) {
                const oPayload = oTable.getPayload();
                delete oPayload.gasdayFrom;
                delete oPayload.gasdayTo;
                delete oPayload.msgIndicator;
                oTable.rebind();
            }
            this._oNominationLogsDialog?.close();
        },

        /** Full label for the GetNominationLogs MsgIndicator code. */
        formatMsgIndicatorText(sCode) {
            return { I: "Information", W: "Warning", E: "Error", S: "Success" }[sCode] || sCode || "";
        },

        /** ValueState for the MsgIndicator ObjectStatus — names match sap.ui.core.ValueState 1:1. */
        formatMsgIndicatorState(sCode) {
            return { I: "Information", W: "Warning", E: "Error", S: "Success" }[sCode] || "None";
        },

        /** Mirrors _validateGasDayRange — Nomination Logs range is capped at 31 days too. */
        _validateLogsGasDayRange() {
            const oDRS = this.byId("IdCSNLogsGasDayRange");
            const dFrom = oDRS.getDateValue();
            const dTo = oDRS.getSecondDateValue();
            if (!dFrom || !dTo) return true;

            const iDays = Math.floor((dTo.getTime() - dFrom.getTime()) / (1000 * 60 * 60 * 24)) + 1;
            if (iDays > 31) {
                oDRS.setValue("");
                oDRS.setValueState(ValueState.Error);
                oDRS.setValueStateText("Gas Day range cannot exceed 31 days.");
                MessageBox.error("Gas Day range cannot exceed 31 days.");
                return false;
            }

            oDRS.setValueState(ValueState.None);
            return true;
        },

        /**
         * DateRangeSelection's change fires once both From and To are picked — no
         * separate Go button. Validates the 31-day cap, then pushes the range into
         * the mdc.Table delegate payload and rebinds immediately.
         */
        onLogsGasDayRangeChange() {
            if (!this._validateLogsGasDayRange()) return;

            const oDRS = this.byId("IdCSNLogsGasDayRange");
            const dFrom = oDRS.getDateValue();
            const dTo = oDRS.getSecondDateValue();
            if (!dFrom || !dTo) return;   // range not complete yet — wait for the second date

            const oTable = this.byId("IdCSNNominationLogsTable");
            const oPayload = oTable.getPayload();
            // No public setter for the delegate payload — CSNNominationLogsTableDelegate
            // reads these two fields on every rebind to inject the mandatory Gasday
            // BETWEEN filter (see updateBindingInfo there). Gasday is Edm.Date (date-only,
            // no time component) on xGMSxCONFIRMNOM_LOGS, so plain yyyy-MM-dd bounds suffice.
            oPayload.gasdayFrom = this._logsIsoDate(dFrom);
            oPayload.gasdayTo = this._logsIsoDate(dTo);
            oTable.rebind();
        },

        /** Formats a local-midnight Date as a plain yyyy-MM-dd string (Edm.Date literal). */
        _logsIsoDate(oDate) {
            const y = oDate.getFullYear();
            const m = String(oDate.getMonth() + 1).padStart(2, "0");
            const d = String(oDate.getDate()).padStart(2, "0");
            return `${y}-${m}-${d}`;
        },

        /** Quick-filter (All/Error/Warning/Information/Success) on the Logs table's MsgIndicator. */
        onLogsMsgIndicatorFilter(oEvent) {
            const sKey = oEvent.getParameter("item").getKey();
            const oTable = this.byId("IdCSNNominationLogsTable");
            const oPayload = oTable.getPayload();
            oPayload.msgIndicator = sKey === "ALL" ? null : sKey;
            if (oPayload.gasdayFrom && oPayload.gasdayTo) oTable.rebind();
        }
    });
});