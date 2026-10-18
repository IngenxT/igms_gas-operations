sap.ui.define([
    "sap/m/Token",
    "sap/ui/core/Fragment",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/m/MessageBox",
    "sap/ui/model/json/JSONModel"
], (Token, Fragment, Filter, FilterOperator, MessageBox, JSONModel) => {
    "use strict";

    // Config for the Delivery / Redelivery location VHs — reuses confirmScheduleNomination's
    // CSNDeliveryVH / CSNRedeliveryVH fragments; drives the generic _openLocationVH / _onLocVH* methods.
    const LOCATION_VH_CFG = {
        delivery: {
            fragName: "com.ingenx.igmsgasflow.fragments.CSNDeliveryVH",
            tableId: "IdCSNDeliveryVHTable",
            searchId: "IdCSNDeliveryVHSearch",
            inputId: "IdANTFilterDeliveryPoint",
            entityPath: "/CSNDeliveryPoint"
        },
        redelivery: {
            fragName: "com.ingenx.igmsgasflow.fragments.CSNRedeliveryVH",
            tableId: "IdCSNRedeliveryVHTable",
            searchId: "IdCSNRedeliveryVHSearch",
            inputId: "IdANTFilterRedeliveryPoint",
            entityPath: "/CSNRedeliveryPoint"
        },
        interconnect: {
            fragName: "com.ingenx.igmsgasflow.fragments.CSNInterconnectVH",
            tableId: "IdCSNInterconnectVHTable",
            searchId: "IdCSNInterconnectVHSearch",
            inputId: "IdANTFilterInterconnectPoint",
            entityPath: "/getAllInterconnectPoints"
        }
    };

    // ── Allocation & Ticketing — value help ───────────────────────────────────
    // Single responsibility: Transport System / Delivery / Redelivery / Interconnect
    // Point value-help dialogs (open/search/select/confirm/cancel), the generic
    // multi-page OData fetch helper they share, and delimited paste-to-token
    // handling on the four filter MultiInputs.
    return {
        onValueHelpTransport: async function () {
            if (!this._oTransportVHDialog) {
                this._oTransportVHDialog = await Fragment.load({
                    id: this.getView().getId(),
                    name: "com.ingenx.igmsgasflow.fragments.CSNTransportVH",
                    controller: this
                });
                // Set JSONModel as the dialog's default model BEFORE addDependent so
                // no OData request fires when the control tree connects to the view.
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
                (this.byId("IdANTFilterTransportSystem")?.getTokens() || []).map(t => t.getKey())
            );
            this._oTransportNameMap = new Map();

            const oSearch = this.byId("IdCSNTransportVHSearch");
            if (oSearch) oSearch.setValue("");

            // Open the dialog immediately; populate while it shows busy
            this._oTransportVHDialog.open();
            this._oTransportVHDialog.setBusy(true);
            try {
                const aData = await this._fetchTransportKeys("");
                this._oTransportAllData = aData;
                this._oTransportVHModel.setData(aData);
                this._resyncTransportCheckboxes();
            } catch (oErr) {
                MessageBox.error("Failed to load transport systems.");
                this._oTransportVHDialog.close();
            } finally {
                this._oTransportVHDialog.setBusy(false);
            }
        },

        /** Keeps the selection Set in sync as the user checks / unchecks rows. */
        onTransportVHSelectionChange: function () {
            if (this._bTransportSyncing) return;

            const oTable = this.byId("IdCSNTransportVHTable");
            this._oTransportSelSet = new Set();
            if (!this._oTransportNameMap) this._oTransportNameMap = new Map();

            oTable.getSelectedItems().forEach(oItem => {
                const oData = oItem.getBindingContext()?.getObject();
                if (!oData?.Tsyst) return;
                this._oTransportSelSet.add(oData.Tsyst);
                this._oTransportNameMap.set(oData.Tsyst, oData);
            });

            const oInput = this.byId("IdANTFilterTransportSystem");
            oInput.removeAllTokens();
            this._oTransportSelSet.forEach(sTsyst => {
                const oEntry = this._oTransportNameMap.get(sTsyst);
                oInput.addToken(new Token({
                    key: sTsyst,
                    text: oEntry ? `${sTsyst} – ${oEntry.Tsnam}` : sTsyst
                }));
            });
        },

        /** Resyncs checkbox state after each growing page finishes loading. */
        onTransportVHUpdateFinished: function () {
            this._resyncTransportCheckboxes();
        },

        _resyncTransportCheckboxes: function () {
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
        onTransportVHSearch: function (oEvent) {
            const sQuery = (oEvent.getParameter("query") || oEvent.getParameter("newValue") || "").trim().toUpperCase();
            const aFiltered = sQuery
                ? (this._oTransportAllData || []).filter(o =>
                    o.Tsyst?.toUpperCase().includes(sQuery) ||
                    o.Tsnam?.toUpperCase().includes(sQuery))
                : (this._oTransportAllData || []);
            this._oTransportVHModel?.setData(aFiltered);
            this._resyncTransportCheckboxes();
        },

        /** Pages an OData V4 list binding in chunks — CAP caps every response at
         *  cds.query.limit.max (1000) regardless of the requested $top, so a single
         *  large requestContexts() call silently truncates. Keeps issuing successive
         *  $skip/$top pages until a short page signals the end of the collection. */
        _fetchAllPages: async function (sPath, aFilters, sSelect, iPageSize) {
            iPageSize = iPageSize || 1000;
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
         *  (LocPoint_MapSet-backed, Vsart='YA'-filtered — see balancingScheduling-service.cds;
         *  shared across confirmScheduleNomination and this screen). */
        _fetchTransportKeys: async function (sSearch) {
            const aFilters = sSearch
                ? [new Filter("Tsnam", FilterOperator.Contains, sSearch)]
                : [];
            return this._fetchAllPages("/CSNTransportSystem", aFilters, "Tsyst,Tsnam");
        },

        /** Reads the Redelivery Point(s) mapped to the given Transport System(s)
         *  directly from CSNRedeliveryPoint — used by nominationTable.onSearch to
         *  auto-derive RedeliveryPoint from a Transport selection instead of
         *  requiring the user to also pick one from the Redelivery Point dialog.
         *  Passing the result as an explicit LocationFilter makes the backend
         *  (scheduledNomItems.js) take Scenario B/C (exact field match) instead
         *  of Scenario A (fuzzy locid-based TS resolution, which can leak in
         *  other transport systems sharing a location) — same fix as
         *  confirmScheduleNomination.controller.js's onSearch. */
        _fetchRedeliveryPointsForTransports: async function (aTsysts) {
            if (!aTsysts?.length) return [];
            const oTransF = aTsysts.length === 1
                ? new Filter("Tsyst", FilterOperator.EQ, aTsysts[0])
                : new Filter({ filters: aTsysts.map(k => new Filter("Tsyst", FilterOperator.EQ, k)), and: false });
            return this._fetchAllPages("/CSNRedeliveryPoint", [oTransF], "Locid,Tsyst");
        },

        /** Commits the working Set as tokens. */
        onTransportVHConfirm: function () {
            const oInput = this.byId("IdANTFilterTransportSystem");
            oInput.removeAllTokens();
            (this._oTransportSelSet || new Set()).forEach(sTsyst => {
                const oEntry = this._oTransportNameMap?.get(sTsyst);
                oInput.addToken(new Token({
                    key: sTsyst,
                    text: oEntry ? `${sTsyst} – ${oEntry.Tsnam}` : sTsyst
                }));
            });
            this._oTransportVHDialog.close();
        },

        /** Reverts working Set to last committed tokens without changing the MultiInput. */
        onTransportVHCancel: function () {
            this._oTransportSelSet = new Set(
                (this.byId("IdANTFilterTransportSystem")?.getTokens() || []).map(t => t.getKey())
            );
            this._oTransportVHDialog.close();
        },

        /** Fired when user removes a transport token directly from the MultiInput chip. */
        onTransportTokenUpdate: function (oEvent) {
            if (oEvent.getParameter("type") !== "removed") return;
            const aRemoved = oEvent.getParameter("removedTokens") || [];
            aRemoved.forEach(t => this._oTransportSelSet?.delete(t.getKey()));
        },

        /** Delivery Point and Redelivery Point are mutually exclusive scope filters — only
         *  one may be filled at a time. Interconnect Point is hidden and out of scope, so it
         *  is never part of this check. Called from Go, Simulate, and Allocate & Save before
         *  any backend call fires. Returns true when the filters are valid. */
        _validateLocationFilterExclusivity: function () {
            const bHasDelivery = (this.byId("IdANTFilterDeliveryPoint")?.getTokens() || []).length > 0;
            const bHasRedelivery = (this.byId("IdANTFilterRedeliveryPoint")?.getTokens() || []).length > 0;
            if (bHasDelivery && bHasRedelivery) {
                MessageBox.error(this.getView().getModel("i18n").getResourceBundle().getText("antErrLocationFilterExclusive"));
                return false;
            }
            return true;
        },

        /** Turns text still sitting un-tokenized in a filter MultiInput (e.g. a single
         *  pasted ID with no delimiter) into tokens. Without this Go ignores it, and an
         *  empty Redelivery Point makes onSearch auto-select every RDP of the Transport. */
        _commitPendingFilterText: function () {
            this._PASTE_TARGET_IDS.forEach(sId => {
                const oInput = this.byId(sId);
                const sText = oInput?.getValue()?.trim();
                if (sText) this._parsePastedInput(oInput, sText, true);
            });
        },

        // ── Delivery / Redelivery Value Help (reuses CSNDeliveryVH / CSNRedeliveryVH) ──

        /** Builds a transport Tsyst OR-filter from the currently selected Transport tokens. */
        _buildTransportFilter: function () {
            const aKeys = (this.byId("IdANTFilterTransportSystem")?.getTokens() || []).map(t => t.getKey());
            if (!aKeys.length) return null;
            if (aKeys.length === 1) return new Filter("Tsyst", FilterOperator.EQ, aKeys[0]);
            return new Filter({ filters: aKeys.map(k => new Filter("Tsyst", FilterOperator.EQ, k)), and: false });
        },

        /** Generic open — loads fragment once, wires JSONModel, fetches all data on every open. */
        _openLocationVH: async function (sType) {
            const oCfg = LOCATION_VH_CFG[sType];
            if (!this._oLocVHDialog[sType]) {
                this._oLocVHDialog[sType] = await Fragment.load({
                    id: this.getView().getId(),
                    name: oCfg.fragName,
                    controller: this
                });
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

            // Open dialog immediately; populate while it shows busy
            this._oLocVHDialog[sType].open();
            this._oLocVHDialog[sType].setBusy(true);
            try {
                const aData = await this._fetchLocationKeys(sType, "");
                this._oLocAllData[sType] = aData;
                this._oLocVHModel[sType].setData(aData);
                this._onLocVHUpdateFinished(sType);
            } catch (oErr) {
                MessageBox.error("Failed to load data. Please try again.");
                this._oLocVHDialog[sType].close();
            } finally {
                this._oLocVHDialog[sType].setBusy(false);
            }
        },

        /** Keeps the selection Set in sync as the user checks/unchecks rows. */
        _onLocVHSelectionChange: function (sType, oEvent) {
            if (this._bLocSyncing[sType]) return;

            const bSelected = oEvent.getParameter("selected");
            const aItems = oEvent.getParameter("listItems") || [];

            aItems.forEach(oItem => {
                const oData = oItem.getBindingContext()?.getObject();
                if (!oData?.Locid) return;
                this._oLocNameMap[sType].set(oData.Locid, oData);
                if (bSelected) this._oLocSelSet[sType].add(oData.Locid);
                else this._oLocSelSet[sType].delete(oData.Locid);
            });
        },

        /** Resyncs checkbox state after each growing page finishes loading. */
        _onLocVHUpdateFinished: function (sType) {
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
        _onLocVHSearch: function (sType, oEvent) {
            const sQuery = (oEvent.getParameter("query") || oEvent.getParameter("newValue") || "").trim().toUpperCase();
            const aFiltered = sQuery
                ? (this._oLocAllData?.[sType] || []).filter(o =>
                    o.Locid?.toUpperCase().includes(sQuery) ||
                    o.Locnam?.toUpperCase().includes(sQuery))
                : (this._oLocAllData?.[sType] || []);
            this._oLocVHModel?.[sType]?.setData(aFiltered);
            this._onLocVHUpdateFinished(sType);
        },

        /** Reads all matching location rows directly from the entity — same filters as the VH table. */
        _fetchLocationKeys: async function (sType, sSearch) {
            const oCfg = LOCATION_VH_CFG[sType];
            const aFilters = [];
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
            const aRows = await this._fetchAllPages(oCfg.entityPath, aFilters, "Locid,Locnam,Tsyst");
            // The entity returns one row per Location + Transport System, so the same
            // Locid repeats; the VH shows (and selects by) Locid only — keep one row each.
            const mByLocid = new Map();
            aRows.forEach(o => {
                if (o.Locid && !mByLocid.has(o.Locid)) mByLocid.set(o.Locid, o);
            });
            return Array.from(mByLocid.values());
        },

        /** Commits working Set as tokens on the MultiInput. */
        _onLocVHConfirm: function (sType) {
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
            this._oLocVHDialog[sType].close();
            this._applyLocalFilters();
        },

        /** Reverts working Set to committed tokens without changing the MultiInput. */
        _onLocVHCancel: function (sType) {
            const oCfg = LOCATION_VH_CFG[sType];
            this._oLocSelSet[sType] = new Set(
                (this.byId(oCfg.inputId)?.getTokens() || []).map(t => t.getKey())
            );
            this._oLocVHDialog[sType].close();
        },

        /** Fired when user removes a location token directly from the MultiInput chip. */
        _onLocTokenUpdate: function (sType, oEvent) {
            if (oEvent.getParameter("type") !== "removed") return;
            const aRemoved = oEvent.getParameter("removedTokens") || [];
            aRemoved.forEach(t => this._oLocSelSet[sType]?.delete(t.getKey()));
            this._applyLocalFilters();
        },

        // ── Typed wrappers — referenced from CSNDeliveryVH / CSNRedeliveryVH fragment XML ──
        onValueHelpDelivery: function () { return this._openLocationVH("delivery"); },
        onDeliveryVHSearch: function (e) { this._onLocVHSearch("delivery", e); },
        onDeliveryVHSelectionChange: function (e) { this._onLocVHSelectionChange("delivery", e); },
        onDeliveryVHUpdateFinished: function () { this._onLocVHUpdateFinished("delivery"); },
        onDeliveryVHConfirm: function () { this._onLocVHConfirm("delivery"); },
        onDeliveryVHCancel: function () { this._onLocVHCancel("delivery"); },
        onDeliveryTokenUpdate: function (e) { this._onLocTokenUpdate("delivery", e); },

        onValueHelpRedelivery: function () { return this._openLocationVH("redelivery"); },
        onRedeliveryVHSearch: function (e) { this._onLocVHSearch("redelivery", e); },
        onRedeliveryVHSelectionChange: function (e) { this._onLocVHSelectionChange("redelivery", e); },
        onRedeliveryVHUpdateFinished: function () { this._onLocVHUpdateFinished("redelivery"); },
        onRedeliveryVHConfirm: function () { this._onLocVHConfirm("redelivery"); },
        onRedeliveryVHCancel: function () { this._onLocVHCancel("redelivery"); },
        onRedeliveryTokenUpdate: function (e) { this._onLocTokenUpdate("redelivery", e); },

        // ── Typed wrappers — referenced from CSNInterconnectVH fragment XML ───────
        onValueHelpInterconnect: function () { return this._openLocationVH("interconnect"); },
        onInterconnectVHSearch: function (e) { this._onLocVHSearch("interconnect", e); },
        onInterconnectVHSelectionChange: function (e) { this._onLocVHSelectionChange("interconnect", e); },
        onInterconnectVHUpdateFinished: function () { this._onLocVHUpdateFinished("interconnect"); },
        onInterconnectVHConfirm: function () { this._onLocVHConfirm("interconnect"); },
        onInterconnectVHCancel: function () { this._onLocVHCancel("interconnect"); },
        onInterconnectTokenUpdate: function (e) { this._onLocTokenUpdate("interconnect", e); },

        // ── Paste / delimited input ─────────────────────────────────────────────

        // Delimiters accepted when splitting a pasted/typed multi-value string:
        // comma, semicolon, newline (CR/LF) — covers Excel-column paste as well
        // as comma-separated manual entry.
        _PASTE_SPLIT_RE: /[\r\n,;]+/,
        // A tab also marks a paste worth tokenizing: Excel rows copied with more than
        // one column (e.g. Location ID + Location Name) arrive tab-separated.
        _PASTE_TRIGGER_RE: /[\r\n,;\t]/,

        // MultiInput ids that accept delimited paste, keyed to whether a paste
        // should re-trigger _applyLocalFilters (Transport tokens don't feed it —
        // they only scope the Delivery/Redelivery/Interconnect VH dialogs on next open).
        _PASTE_TARGET_IDS: ["IdANTFilterTransportSystem", "IdANTFilterDeliveryPoint",
            "IdANTFilterRedeliveryPoint", "IdANTFilterInterconnectPoint"],

        // Listens on `document` in the CAPTURE phase — ahead of MultiInput's own
        // built-in paste-to-token handling on the input itself — so this owns the
        // event outright (stopPropagation keeps the control's internal handling
        // from ever running) instead of racing it, which previously left a
        // duplicate/final line committed as a token AND still sitting as raw text.
        // Attached once via attachEventOnce("afterRendering"); document-level means
        // it survives the MultiInput re-rendering its inner <input> later.
        _attachPasteHandlers: function () {
            document.addEventListener("paste", e => {
                const sId = this._PASTE_TARGET_IDS.find(id => {
                    const oInput = this.byId(id);
                    return oInput && oInput.getFocusDomRef() === e.target;
                });
                if (!sId) return;

                const sText = (e.clipboardData || window.clipboardData)?.getData("text") || "";
                if (!this._PASTE_TRIGGER_RE.test(sText)) return; // single value — let normal flow handle it

                e.preventDefault();
                e.stopPropagation();

                this._parsePastedInput(this.byId(sId), sText);
                if (sId !== "IdANTFilterTransportSystem") this._applyLocalFilters();
            }, true);
        },

        // Splits the raw value on comma/semicolon/newline, adds a token for each
        // distinct non-empty entry that is not already present, clears the text
        // field, and returns true so the caller can decide whether to trigger
        // _applyLocalFilters.
        // bForce tokenizes a single undelimited value too; only the first tab-separated
        // column of each entry is kept (the ID of a multi-column Excel row).
        _parsePastedInput: function (oInput, sValue, bForce) {
            if (!sValue || (!bForce && !this._PASTE_TRIGGER_RE.test(sValue))) return false;
            const oExisting = new Set(oInput.getTokens().map(t => t.getKey()));
            sValue.split(this._PASTE_SPLIT_RE).map(v => v.split("\t")[0].trim()).filter(Boolean).forEach(sKey => {
                if (!oExisting.has(sKey)) {
                    oInput.addToken(new Token({ key: sKey, text: sKey }));
                    oExisting.add(sKey);
                }
            });
            oInput.setValue("");
            return true;
        },

        onTransportLiveChange: function (oEvent) {
            this._parsePastedInput(oEvent.getSource(), oEvent.getParameter("value") || "");
        },

        onDeliveryLiveChange: function (oEvent) {
            if (this._parsePastedInput(oEvent.getSource(), oEvent.getParameter("value") || ""))
                this._applyLocalFilters();
        },

        onRedeliveryLiveChange: function (oEvent) {
            if (this._parsePastedInput(oEvent.getSource(), oEvent.getParameter("value") || ""))
                this._applyLocalFilters();
        },

        onInterconnectLiveChange: function (oEvent) {
            if (this._parsePastedInput(oEvent.getSource(), oEvent.getParameter("value") || ""))
                this._applyLocalFilters();
        },
    };
});
