sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/Fragment",
    "sap/ui/model/json/JSONModel",
    "sap/ui/model/Sorter",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/ui/model/FilterType",
    "sap/m/BusyDialog",
    "sap/m/MessageToast",
    "sap/m/MessageBox",
    "sap/ui/Device",
    "sap/ui/core/routing/History",
    "com/ingenx/igmsgasflow/utils/errorHandler",
    "com/ingenx/igmsgasflow/controller/shared/ticketDetailDialog",
    "com/ingenx/igmsgasflow/controller/allocationNTicketing/ticketDetail"
], function (Controller, Fragment, JSONModel, Sorter, Filter, FilterOperator, FilterType, BusyDialog, MessageToast, MessageBox, Device, History, ErrorHandler,
    ticketDetailDialogMixin, ticketDetailMixin) {
    "use strict";

    // ── Constants ────────────────────────────────────────────────────────────────
    const ALL_STATUS_KEYS = ["S", "W", "E", "P", "N"];
    const MAX_RANGE_DAYS = 31;      // Fiori list-report guardrail — no unbounded date scans
    const KEY_SEARCH_LIMIT = 500;   // max ExecIds resolved from a free-text key search
    const SELECT_COLUMNS =
        "ExecId,ExecDate,ExecTime,ExecUser,ExecStatus,Gasday,TicketKey,TicketItem,Nomtk,Nomit,ProcessingTime,CompletedAt";
    const COLUMN_VISIBILITY_KEY = "igmsgasflow.ticketLogs.columnVisibility"; // localStorage — per-browser convenience only

    // ── Controller ───────────────────────────────────────────────────────────────
    // Table is bound directly to the OData V4 /ticketLogs list (server-side paging via
    // sap.ui.table.Table's own threshold/scrollThreshold — no more "fetch everything up
    // front into a JSONModel", which used to cap out at 5000 rows and load them all into
    // browser memory in one shot regardless of how wide a date range was picked.

    // Nomination Key popup: allocationNTicketing/ticketDetail (same as Allocation & Ticketing)
    return Controller.extend("com.ingenx.igmsgasflow.controller.ticketLogs", Object.assign({}, ticketDetailDialogMixin, ticketDetailMixin, {

        // ── Lifecycle ─────────────────────────────────────────────────────────────

        onInit: function () {
            this._sNomKeyFilter = "";
            this._sTicketKeyFilter = "";
            this._aExecIdFilter = null; // null = no key-search narrowing active
            this._sGasdayFrom = null;   // null = Gasday Range not set (Execution Range may be instead)
            this._sGasdayTo = null;
            this._iKeySearchToken = 0;  // guards against a stale async key-search resolving after Clear All
            this._mFragments = {};
            this.getView().setModel(new JSONModel({
                filterSummaryText: "",
                hasKeyFilter: false,
                // Status/Nomination Key/Ticket Key refinement filters stay hidden until
                // the first successful load — nothing meaningful to refine before then.
                filtersVisible: false
            }), "viewModel");

            // Responsive: re-evaluate row count on window resize
            Device.resize.attachHandler(this._onResize, this);

            // Restore any previously chosen hidden columns (see onOpenColumnSettings) —
            // the table's columns already exist at this point (static XML view).
            this._restoreColumnVisibility();

            // "Back to Allocation & Ticketing" button — visible only when navigation
            // actually originated there (see allocationNTicketing.controller.js#_navToTicketLogs).
            this.getOwnerComponent().getRouter()
                .getRoute("RouteTicketLogs")
                .attachPatternMatched(this._onRouteMatched, this);
        },

        onExit: function () {
            Device.resize.detachHandler(this._onResize, this);
            this.getOwnerComponent().getRouter()
                .getRoute("RouteTicketLogs")
                .detachPatternMatched(this._onRouteMatched, this);
            if (this._oBusyDialog) {
                this._oBusyDialog.destroy();
                this._oBusyDialog = null;
            }
        },

        _onRouteMatched: function (oEvent) {
            // Persisted (not just used to toggle the button) so onRowPress can carry it
            // through to RouteDateWiseTicketLogs — the user may drill into a row's detail
            // and come back; the origin must survive that round trip, not just the
            // initial navigation into this page.
            const oArgs = oEvent.getParameter("arguments");
            this._sFrom = oArgs.from;
            const oBackBtn = this.byId("IdTcktLogsBackToAllocBtn");
            if (oBackBtn) oBackBtn.setVisible(this._sFrom === "allocationNTicketing");

            // Pre-fill Gasday Range with the run just submitted and fetch immediately —
            // only when arriving straight from a Ticket submission on Allocation &
            // Ticketing, carrying that screen's own Gasday (oArgs.gasday). No other entry
            // point (Home tile, direct link) pre-fills or auto-fetches anything — the user
            // picks a Gasday Range or Execution Range and presses Go themselves. Guarded
            // on _bHasLoadedOnce so this only ever runs on the FIRST arrival this session
            // — returning here from a RouteDateWiseTicketLogs drill-down (onRowPress)
            // re-fires this same pattern-matched handler and must never clobber a range
            // the user already picked/queried.
            if (!this._bHasLoadedOnce) {
                this._bHasLoadedOnce = true;
                if (this._sFrom === "allocationNTicketing" && oArgs.gasday) {
                    const oGasdayRange = this.byId("IdTcktLogsGasdayRange");
                    const dGasday = new Date(oArgs.gasday + "T00:00:00");
                    oGasdayRange.setDateValue(dGasday);
                    oGasdayRange.setSecondDateValue(dGasday);
                    this.onPressGoTicketLogs();
                }
            }
        },

        // Real history back — same loop fix as dateWiseTicketLogs.onBackPress
        onNavBackToAllocation: function () {
            if (History.getInstance().getPreviousHash() !== undefined) {
                window.history.go(-1);
            } else {
                this.getOwnerComponent().getRouter().navTo("RouteallocationNTicketing", {}, true);
            }
        },

        // ── Busy Dialog — only for the initial load and key-search resolution;      ──
        // ── scroll-triggered page fetches use the table's own enableBusyIndicator.  ──

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
            // visibleRowCountMode="Auto" recalculates automatically;
            // an explicit invalidate forces the table to re-measure its container.
            const oTable = this.byId("IdTcktLogsMainTable");
            if (oTable) oTable.invalidate();
        },

        // ── Data Load ─────────────────────────────────────────────────────────────

        /** Reads one DateRangeSelection and validates it as either fully blank (both
         *  sides empty — not provided) or a complete, ≤MAX_RANGE_DAYS range. Returns
         *  {from, to} ISO date strings when complete, or null when blank/invalid (a
         *  value state + text is set on the control itself for the invalid case). */
        _readOptionalRange: function (oControl) {
            const dFrom = oControl.getDateValue();
            const dTo = oControl.getSecondDateValue();
            if (!dFrom && !dTo) {
                oControl.setValueState("None");
                return null;
            }
            if (!dFrom || !dTo) {
                oControl.setValueState("Error");
                oControl.setValueStateText("Please select a complete range.");
                return null;
            }
            const iSpanDays = Math.round((dTo - dFrom) / 86400000) + 1;
            if (iSpanDays > MAX_RANGE_DAYS) {
                oControl.setValueState("Error");
                oControl.setValueStateText(`Date range cannot exceed ${MAX_RANGE_DAYS} days.`);
                return null;
            }
            oControl.setValueState("None");
            return { from: this._toISODate(dFrom), to: this._toISODate(dTo) };
        },

        // Either Gasday Range or Execution Range is mandatory to fetch — never both
        // required together, and either one alone is enough (the other stays blank,
        // meaning "no constraint" for that dimension — see _buildCombinedFilter).
        onPressGoTicketLogs: async function () {
            // A key typed and Go clicked straight away: the input's change handler has
            // only just started resolving ExecIds — wait for it (or start it, if the
            // input text isn't the one last resolved) before deciding what to load.
            const sNom = this.byId("IdTcktLogsNomKeyFilter").getValue().trim();
            const sTicket = this.byId("IdTcktLogsTicketKeyFilter").getValue().trim();
            if (sNom !== this._sNomKeyFilter || sTicket !== this._sTicketKeyFilter) {
                await this._resolveExecIdsByKeys();
            } else {
                await this._pKeyResolve;
            }

            const oGasdayRange = this.byId("IdTcktLogsGasdayRange");
            const oExecRange = this.byId("IdTcktLogsDateRange");

            const oGasday = this._readOptionalRange(oGasdayRange);
            const oExec = this._readOptionalRange(oExecRange);

            // A range present on screen but incomplete/too wide already set its own
            // Error state above — bail without a second, redundant message.
            const bGasdayInvalid = !oGasday && (oGasdayRange.getDateValue() || oGasdayRange.getSecondDateValue());
            const bExecInvalid = !oExec && (oExecRange.getDateValue() || oExecRange.getSecondDateValue());
            if (bGasdayInvalid || bExecInvalid) return;

            // A Nomination/Ticket Key search is already a bounded ExecId set, so it can
            // run without a date range too.
            if (!oGasday && !oExec && !this._aExecIdFilter) {
                const sMsg = "Select a Gasday Range, an Execution Range, or a Nomination/Ticket Key.";
                oGasdayRange.setValueState("Error");
                oGasdayRange.setValueStateText(sMsg);
                oExecRange.setValueState("Error");
                oExecRange.setValueStateText(sMsg);
                return;
            }

            this._sGasdayFrom = oGasday?.from || null;
            this._sGasdayTo = oGasday?.to || null;
            this._sFromDate = oExec?.from || null;
            this._sToDate = oExec?.to || null;

            // Key filters are kept — they're entered before Go as often as after it.
            this._setStatusSelection(true);

            this._bindMainTable();
        },

        onRefreshTicketLogs: function () {
            if ((this._sGasdayFrom && this._sGasdayTo) || (this._sFromDate && this._sToDate) || this._aExecIdFilter) {
                this._bindMainTable();
            } else {
                this.byId("IdTcktLogsMainTable").unbindRows();
                this._updateTitle(0);
                this.getView().getModel("viewModel").setProperty("/filtersVisible", false);
            }
        },

        /** (Re)binds the table rows aggregation to /ticketLogs with the current filter set. */
        _bindMainTable: function () {
            const oTable = this.byId("IdTcktLogsMainTable");

            this._showBusy("Loading ticket logs…");
            oTable.bindRows({
                path: "/ticketLogs",
                filters: [this._buildCombinedFilter()],
                // desc on both — the backend (ConfirmNomNAlloc_service.js's ticketLogs READ
                // handler) strips ExecTime from the $orderby it forwards to Gateway (Edm.Time
                // sort errors on some Gateway versions) but restores ExecTime-desc as a local
                // tie-break within the returned page, so this second Sorter still reflects
                // real row order even though it's never sent over the wire as-is.
                sorter: [new Sorter("ExecDate", true), new Sorter("ExecTime", true)],
                parameters: {
                    $select: SELECT_COLUMNS,
                    $$groupId: "$direct",
                    $count: true
                }
            });

            const oBinding = oTable.getBinding("rows");
            // Keeps the title's count in step with every reload of this binding — incl.
            // the column-header filter/sort popovers, which re-query without going
            // through _applyAllFilters.
            oBinding.attachDataReceived(() => this._updateTitle(oBinding.getCount() ?? 0));
            oBinding.attachEventOnce("dataReceived", oEvent => {
                this._hideBusy();
                if (oEvent.getParameter("error")) {
                    MessageBox.error("Failed to load ticket logs.");
                    return;
                }
                // Status/Nomination Key/Ticket Key refinement filters only make sense
                // once a query has actually run — reveal them on the first successful load.
                this.getView().getModel("viewModel").setProperty("/filtersVisible", true);
                const iCount = oBinding.getCount() ?? 0;
                this._updateTitle(iCount);
                if (!iCount) {
                    MessageToast.show("No ticket logs found for the selected filters.");
                }
            });
        },

        _toISODate: function (oDate) {
            // Use local date parts — toISOString() converts to UTC and shifts the date
            // in non-UTC timezones (e.g. IST +5:30 turns Apr 4 into Apr 3).
            const yyyy = oDate.getFullYear();
            const mm   = String(oDate.getMonth() + 1).padStart(2, "0");
            const dd   = String(oDate.getDate()).padStart(2, "0");
            return `${yyyy}-${mm}-${dd}`;
        },

        // ── Combined server-side filter ───────────────────────────────────────────

        /**
         * Builds the full filter tree sent to /ticketLogs: Gasday range (if set) AND
         * Execution range (if set) — onPressGoTicketLogs guarantees at least one of
         * the two is always set, never both required together — AND status-set
         * (checkbox OR-group) AND, if a Nomination/Ticket Key search is active, an
         * ExecId OR-group resolved via xGMSxTKT_EXEC_TICKETS — TicketKey/Nomtk are
         * CAP-local virtual fields on ticketLogs, so they can never be filtered
         * directly against the remote TktlogDetailHeadSet entity.
         */
        _buildCombinedFilter: function () {
            const aFilters = [];

            if (this._sGasdayFrom && this._sGasdayTo) {
                aFilters.push(new Filter({
                    filters: [
                        new Filter("Gasday", FilterOperator.GE, this._sGasdayFrom),
                        new Filter("Gasday", FilterOperator.LE, this._sGasdayTo)
                    ],
                    and: true
                }));
            }

            if (this._sFromDate && this._sToDate) {
                aFilters.push(new Filter({
                    filters: [
                        new Filter("ExecDate", FilterOperator.GE, this._sFromDate),
                        new Filter("ExecDate", FilterOperator.LE, this._sToDate)
                    ],
                    and: true
                }));
            }

            const aStatusFilters = this.byId("IdTcktLogsStatusFilter").getSelectedKeys()
                .map(sKey => new Filter("ExecStatus", FilterOperator.EQ, sKey));
            aFilters.push(aStatusFilters.length
                ? new Filter({ filters: aStatusFilters, and: false })
                // Nothing selected → hide all rows
                : new Filter("ExecStatus", FilterOperator.EQ, "__NONE__"));

            if (this._aExecIdFilter) {
                aFilters.push(this._aExecIdFilter.length
                    ? new Filter({
                        filters: this._aExecIdFilter.map(id => new Filter("ExecId", FilterOperator.EQ, id)),
                        and: false
                    })
                    : new Filter("ExecId", FilterOperator.EQ, "__NONE__"));
            }

            return new Filter({ filters: aFilters, and: true });
        },

        _applyAllFilters: function () {
            const oBinding = this.byId("IdTcktLogsMainTable").getBinding("rows");
            if (!oBinding) return;
            // FilterType.Application — leaves the Control-type slot free for the table's
            // own per-column filterProperty popovers (ExecDate/ExecUser/ExecStatus) so the
            // two compose via AND instead of one silently overwriting the other.
            // Title count is refreshed by the binding's dataReceived listener (_bindMainTable).
            oBinding.filter([this._buildCombinedFilter()], FilterType.Application);
        },

        _updateTitle: function (iCount) {
            const oTitle = this.byId("IdTcktLogsTableTitle");
            if (!oTitle) return;
            oTitle.setText(`Ticket Execution Logs (${iCount ?? 0})`);
        },

        // ── Status Filters ────────────────────────────────────────────────────────

        onStatusFilterChange: function () {
            this._applyAllFilters();
        },

        // Resets every refinement filter back to its default (all statuses, no key
        // search) — there's no separate "Select All" button now that Status defaults
        // to all-selected on every load. Gasday Range/Execution Range are primary
        // fetch filters, not refinements — same as each other, neither is touched here
        // (matching Execution Range's own pre-existing treatment); change one and
        // press Go again to re-fetch.
        onClearAllFilters: function () {
            this._setStatusSelection(true);
            this._clearKeyFilterState();
            this._applyAllFilters();
        },

        _setStatusSelection: function (bSelected) {
            this.byId("IdTcktLogsStatusFilter").setSelectedKeys(bSelected ? ALL_STATUS_KEYS : []);
        },

        // ── Active key-filter summary (MessageStrip above the table) ────────────

        onClearKeyFilterSummary: function () {
            this._clearKeyFilterState();
            this._applyAllFilters();
        },

        _clearKeyFilterState: function () {
            this._iKeySearchToken++; // invalidate any in-flight _resolveExecIdsByKeys call
            this._sNomKeyFilter = "";
            this._sTicketKeyFilter = "";
            this._aExecIdFilter = null;
            this.byId("IdTcktLogsNomKeyFilter").setValue("");
            this.byId("IdTcktLogsTicketKeyFilter").setValue("");
            this._updateFilterSummary();
        },

        _updateFilterSummary: function () {
            const oVM = this.getView().getModel("viewModel");
            const aParts = [];
            if (this._sNomKeyFilter) aParts.push(`Nomination Key: ${this._sNomKeyFilter}`);
            if (this._sTicketKeyFilter) aParts.push(`Ticket Key: ${this._sTicketKeyFilter}`);
            const sText = aParts.length ? `Filtered by ${aParts.join(", ")}` : "";
            oVM.setProperty("/filterSummaryText", sText);
            oVM.setProperty("/hasKeyFilter", !!sText);
        },

        // ── Nomination Key / Ticket Key search ───────────────────────────────────
        // The value-help dialogs query the real /xGMSxTKT_EXEC_TICKETS entity directly
        // (server-driven search + paging, never the whole set loaded client-side).
        // Selecting a row — or typing free text — resolves to one or more ExecIds,
        // which is what actually narrows the main /ticketLogs list (ExecId is a real,
        // filterable field there; TicketKey/Nomtk are not).

        onNomKeyValueHelp: async function () {
            await this._openVHDialog("IdTcktLogsNomKeyDialog", "com.ingenx.igmsgasflow.fragments.TicketLogsNomKeyVH");
        },

        onTicketKeyValueHelp: async function () {
            await this._openVHDialog("IdTcktLogsTicketKeyDialog", "com.ingenx.igmsgasflow.fragments.TicketLogsTicketKeyVH");
        },

        _openVHDialog: async function (sKey, sName) {
            if (!this._mFragments[sKey]) {
                this._mFragments[sKey] = await Fragment.load({
                    id: this.getView().getId(),
                    name: sName,
                    controller: this
                });
                this.getView().addDependent(this._mFragments[sKey]);
            }
            this._mFragments[sKey].open();
        },

        onSearchNomKeyVH: function (oEvent) {
            this._filterVHBinding(oEvent, "Nomtk");
        },

        onSearchTicketKeyVH: function (oEvent) {
            this._filterVHBinding(oEvent, "TicketKey");
        },

        _filterVHBinding: function (oEvent, sField) {
            const sQuery = oEvent.getParameter("value");
            const oBinding = oEvent.getParameter("itemsBinding");
            if (!oBinding) return;
            oBinding.filter(sQuery ? [new Filter(sField, FilterOperator.Contains, sQuery)] : [], FilterType.Application);
        },

        // Value help pick or free text both resolve through _resolveExecIdsByKeys, so
        // the list narrows to EVERY execution for that key (not just the one row
        // picked), and Nomination Key + Ticket Key combine (AND).
        onConfirmNomKeyVH: function (oEvent) {
            const oRow = oEvent.getParameter("selectedItem")?.getBindingContext().getObject();
            if (!oRow) return;
            this.byId("IdTcktLogsNomKeyFilter").setValue(oRow.Nomtk || "");
            this._resolveExecIdsByKeys();
        },

        onConfirmTicketKeyVH: function (oEvent) {
            const oRow = oEvent.getParameter("selectedItem")?.getBindingContext().getObject();
            if (!oRow) return;
            this.byId("IdTcktLogsTicketKeyFilter").setValue(oRow.TicketKey || "");
            this._resolveExecIdsByKeys();
        },

        onNomKeyFilterChange: function () {
            this._resolveExecIdsByKeys();
        },

        onTicketKeyFilterChange: function () {
            this._resolveExecIdsByKeys();
        },

        /**
         * Resolves the Nomination Key / Ticket Key inputs (either or both) into the
         * ExecId set used to narrow /ticketLogs. Guarded by _iKeySearchToken — if Clear
         * All (or another search) runs while this is in flight, the stale response is
         * discarded instead of clobbering the reset.
         */
        _resolveExecIdsByKeys: function () {
            this._pKeyResolve = this._doResolveExecIdsByKeys();
            return this._pKeyResolve;
        },

        _doResolveExecIdsByKeys: async function () {
            const sNom = this.byId("IdTcktLogsNomKeyFilter").getValue().trim();
            const sTicket = this.byId("IdTcktLogsTicketKeyFilter").getValue().trim();
            this._sNomKeyFilter = sNom;
            this._sTicketKeyFilter = sTicket;
            this._updateFilterSummary();

            const iToken = ++this._iKeySearchToken;
            if (!sNom && !sTicket) {
                this._aExecIdFilter = null;
                this._applyAllFilters();
                return;
            }

            const aKeyFilters = [];
            if (sNom) aKeyFilters.push(new Filter("Nomtk", FilterOperator.Contains, sNom));
            if (sTicket) aKeyFilters.push(new Filter("TicketKey", FilterOperator.Contains, sTicket));

            this._showBusy("Searching…");
            try {
                const oBinding = this.getOwnerComponent().getModel().bindList(
                    "/xGMSxTKT_EXEC_TICKETS",
                    null, null,
                    [new Filter({ filters: aKeyFilters, and: true })],
                    { $select: "ExecId", $$groupId: "$direct" }
                );
                const aContexts = await oBinding.requestContexts(0, KEY_SEARCH_LIMIT);
                if (iToken !== this._iKeySearchToken) return; // superseded by a later search or Clear All

                this._aExecIdFilter = [...new Set(aContexts.map(c => c.getObject().ExecId))];
                if (!this._aExecIdFilter.length) {
                    MessageToast.show("No ticket logs found for the entered key(s).");
                }
                this._applyAllFilters();
            } catch (oError) {
                if (iToken === this._iKeySearchToken) {
                    MessageBox.error(oError.message || "Search failed.");
                }
            } finally {
                if (iToken === this._iKeySearchToken) this._hideBusy();
            }
        },

        // ── Row Press (cellClick) ─────────────────────────────────────────────────

        onRowPress: function (oEvent) {
            // A Nomination Key click opens its tickets popup instead (onLogNomKeyPress)
            if (oEvent.getParameter("cellControl")?.isA("sap.m.Link")) return;
            const iRowIndex = oEvent.getParameter("rowIndex");
            const oCtx = this.byId("IdTcktLogsMainTable").getContextByIndex(iRowIndex);
            if (!oCtx) return;
            const sExecId = oCtx.getProperty("ExecId");
            if (!sExecId) return;
            this.getOwnerComponent().getRouter().navTo("RouteDateWiseTicketLogs", {
                logId: sExecId,
                from: this._sFrom
            });
        },

        /** Nomination Key → every ticket recorded for that Nomtk+Nomit (NominationTicketsDialog) */
        onLogNomKeyPress: async function (oEvent) {
            const oRow = oEvent.getSource().getBindingContext()?.getObject();
            if (!oRow?.Nomtk) return;
            await this._openNominationTickets({ NominationKey: oRow.Nomtk, NominationItem: oRow.Nomit });
        },

        // ── Formatters ────────────────────────────────────────────────────────────

        /**
         * ExecStatus code → display text
         * S → Success  |  E → Error  |  W → Warning  |  P → Partial  |  N → Not Completed
         */
        formatStatusText: function (sStatus) {
            const map = { S: "Success", E: "Error", W: "Warning", P: "Partial", N: "Not Completed" };
            return map[sStatus] || sStatus || "";
        },

        /**
         * ExecStatus code → sap.ui.core.ValueState
         * Partial maps to Warning (no dedicated "Partial" state in UI5)
         */
        formatStatusState: function (sStatus) {
            const map = { S: "Success", E: "Error", W: "Warning", P: "Warning", N: "None" };
            return map[sStatus] || "None";
        },

        /**
         * ExecStatus code → SAP icon URI
         */
        formatStatusIcon: function (sStatus) {
            const map = {
                S: "sap-icon://accept",
                E: "sap-icon://error",
                W: "sap-icon://alert",
                P: "sap-icon://alert",
                N: "sap-icon://pending"
            };
            return map[sStatus] || "";
        },

        /** TicketKey/Nomtk display — S/4 zero-pads both to fixed width (e.g.
         *  "00000000000000072002"); strip the leading zeros for on-screen display
         *  only, keeping at least one digit ("0" stays "0"). Raw value is still what
         *  every filter/search/VH lookup uses — this is purely cosmetic. */
        formatKeyNoLeadingZeros: function (sVal) {
            if (!sVal) return "";
            return String(sVal).replace(/^0+(?=\d)/, "");
        },

        // ── Column Settings — show/hide IdTcktLogsMainTable's own columns ────────────
        // Fragment.load'd/cached the same way as the Nomination/Ticket Key VH dialogs
        // (see _openVHDialog); the dialog's own list is bound to a small JSON model
        // (columnSettings) built fresh from the table's real columns every time it
        // opens, so it always reflects whatever's currently visible (including a
        // previous session's restored choices — see _restoreColumnVisibility).

        onOpenColumnSettings: async function () {
            this._buildColumnSettingsModel();
            await this._openVHDialog("IdTcktLogsColumnSettingsDialog", "com.ingenx.igmsgasflow.fragments.TicketLogsColumnSettings");
        },

        onCloseColumnSettings: function () {
            this._mFragments.IdTcktLogsColumnSettingsDialog?.close();
        },

        _buildColumnSettingsModel: function () {
            const oTable = this.byId("IdTcktLogsMainTable");
            const aColumns = oTable.getColumns().map(oColumn => ({
                id: this.getView().getLocalId(oColumn.getId()),
                text: oColumn.getLabel().getText(),
                visible: oColumn.getVisible()
            }));
            if (!this._oColumnSettingsModel) {
                this._oColumnSettingsModel = new JSONModel();
                this.getView().setModel(this._oColumnSettingsModel, "columnSettings");
            }
            this._oColumnSettingsModel.setData({ columns: aColumns });
        },

        /** List selectionChange — listItems covers both a single checkbox toggle and a
         *  bulk "select all" change; each item's OWN current .getSelected() is its new
         *  visibility, applied to the real table column and the backing model alike. */
        onColumnVisibilitySelectionChange: function (oEvent) {
            const aChangedItems = oEvent.getParameter("listItems") || [oEvent.getParameter("listItem")];
            aChangedItems.filter(Boolean).forEach(oItem => {
                const oContext = oItem.getBindingContext("columnSettings");
                if (!oContext) return;
                const bVisible = oItem.getSelected();
                oContext.getModel().setProperty(oContext.getPath() + "/visible", bVisible);

                const oColumn = this.byId(oContext.getProperty("id"));
                if (oColumn) oColumn.setVisible(bVisible);
            });
            this._saveColumnVisibility();
        },

        onResetColumnSettings: function () {
            this.byId("IdTcktLogsMainTable").getColumns().forEach(oColumn => oColumn.setVisible(true));
            try {
                localStorage.removeItem(COLUMN_VISIBILITY_KEY);
            } catch (e) {
                // localStorage unavailable (private mode/blocked) — nothing was persisted anyway
            }
            this._buildColumnSettingsModel();
        },

        _saveColumnVisibility: function () {
            const oPrefs = {};
            (this._oColumnSettingsModel.getData().columns || []).forEach(c => { oPrefs[c.id] = c.visible; });
            try {
                localStorage.setItem(COLUMN_VISIBILITY_KEY, JSON.stringify(oPrefs));
            } catch (e) {
                // localStorage unavailable (private mode/blocked) — setting simply won't persist
            }
        },

        _restoreColumnVisibility: function () {
            let oPrefs;
            try {
                oPrefs = JSON.parse(localStorage.getItem(COLUMN_VISIBILITY_KEY) || "{}");
            } catch (e) {
                oPrefs = {};
            }
            this.byId("IdTcktLogsMainTable").getColumns().forEach(oColumn => {
                const sLocalId = this.getView().getLocalId(oColumn.getId());
                if (sLocalId && Object.prototype.hasOwnProperty.call(oPrefs, sLocalId)) {
                    oColumn.setVisible(oPrefs[sLocalId]);
                }
            });
        },

    }));
});
