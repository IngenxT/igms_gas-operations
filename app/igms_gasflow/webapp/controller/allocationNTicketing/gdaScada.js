sap.ui.define([
    "sap/ui/core/Fragment",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/m/MessageBox"
], (Fragment, Filter, FilterOperator, MessageBox) => {
    "use strict";

    // ── Allocation & Ticketing — GDA SCADA Measurements ───────────────────────
    // Single responsibility: fetch/transform getGasAllocationData into the four
    // SCADA Measurement tabs (Own/Hybrid/Third-Party/Entry Point), tab switching,
    // row selection → nomination-table filter, and selection identity/restore
    // across data refreshes.
    return {
        // Called fire-and-forget (not awaited) from _loadGasDays, so the caller's
        // own busy indicator clears before this resolves — gdaBusy is this call's OWN
        // loading state, bound on both the SCADA Measurements panel and the Scheduled
        // Items table (see view — Scheduled Items' own AllocatedQty/Balanced columns
        // read off the same meter reading this call refreshes), so neither looks ready
        // with stale/empty data while the fetch is still in flight.
        // One getGasAllocationData call per Gas Day (in parallel); every row is tagged with
        // its day (_gasDay) and the days are concatenated in date order, so each day's
        // Hybrid/Entry Point GROUP row stays directly above its own rows.
        _fetchGdaData: async function (aGasDays) {
            if (!aGasDays || !aGasDays.length) return;
            const aDelivery     = this.byId("IdANTFilterDeliveryPoint").getTokens().map(t => t.getKey());
            const aRedelivery   = this.byId("IdANTFilterRedeliveryPoint").getTokens().map(t => t.getKey());
            const aInterconnect = this.byId("IdANTFilterInterconnectPoint").getTokens().map(t => t.getKey());
            const sLocKeys = [...new Set([...aDelivery, ...aRedelivery, ...aInterconnect])].join(',');
            const sTransportSystem = this._getTransportSystemFilterString();

            this.getView().getModel("allocationModel").setProperty("/gdaBusy", true);
            try {
                const oModel = this.getView().getModel();
                const aResults = await Promise.all(aGasDays.map(async sGasDay => {
                    const oCtx = oModel.bindContext("/getGasAllocationData(...)");
                    oCtx.setParameter("Gasday",    sGasDay);
                    oCtx.setParameter("Locations", sLocKeys);
                    oCtx.setParameter("TransportSystem", sTransportSystem);
                    try {
                        await oCtx.execute();
                        const oRaw = oCtx.getBoundContext().getObject();
                        return { sGasDay, oResult: oRaw?.value?.[0] ?? oRaw };
                    } catch {
                        // GDA SCADA is supplementary — a day that fails just shows no readings
                        return { sGasDay, oResult: null };
                    } finally {
                        oCtx.destroy();
                    }
                }));

                const _tag = (aRows, sGasDay) => (aRows || []).map(r => Object.assign({}, r, { _gasDay: sGasDay }));
                const oMerged = { ownRows: [], hybridRows: [], tpRows: [], epRows: [] };
                aResults.forEach(({ sGasDay, oResult }) => {
                    Object.keys(oMerged).forEach(k => oMerged[k].push(..._tag(oResult?.[k], sGasDay)));
                });
                this._gdaTransform(oMerged);
            } finally {
                this.getView().getModel("allocationModel").setProperty("/gdaBusy", false);
            }
        },

        // ── GDA SCADA Reading — Transform ────────────────────────────────────────

        _gdaTransform: function (result) {
            const own    = result?.ownRows    || [];
            const hybrid = result?.hybridRows || [];
            const tp     = result?.tpRows     || [];
            const ep     = result?.epRows     || [];

            const hybridDataRows = hybrid.filter(r => r._type !== "GROUP");
            const hasError       = hybrid.some(r => r._balState === "err");
            const epDataRows     = ep.filter(r => r._type !== "GROUP");
            const epHasError     = ep.some(r => r._balState === "err");

            this.getView().getModel("ownModel").setData(own);
            this.getView().getModel("hybridModel").setData(hybrid);
            this.getView().getModel("tpModel").setData(tp);
            this.getView().getModel("epModel").setData(ep);
            this.getView().getModel("ownCountModel").setProperty("/count",    String(own.length));
            this.getView().getModel("hybridCountModel").setProperty("/count", String(hybridDataRows.length));
            this.getView().getModel("tpCountModel").setProperty("/count",     String(tp.length));
            this.getView().getModel("epCountModel").setProperty("/count",     String(epDataRows.length));
            this.getView().getModel("hybridErrModel").setProperty("/hasError", hasError);
            this.getView().getModel("epErrModel").setProperty("/hasError", epHasError);

            this.byId("IdANTGDABtnOwn").setText("Own Pipeline (" + own.length + ")");
            this.byId("IdANTGDABtnHybrid").setText("Hybrid (" + hybridDataRows.length + ")");
            this.byId("IdANTGDABtnTP").setText("Third Party (" + tp.length + ")");
            this.byId("IdANTGDABtnEntryPoint").setText("Entry Point (" + epDataRows.length + ")");

            const sActiveKey = this.byId("IdANTGDASegBtn").getSelectedKey() || "OWN";
            this._updateGdaCountText(sActiveKey);
            this.byId("IdANTGDAHybridErrStrip").setVisible(sActiveKey === "HYBRID" && hasError);
            this.byId("IdANTGDAEntryPointErrStrip").setVisible(sActiveKey === "ENTRYPOINT" && epHasError);

            this._restoreGdaSelection();
        },

        // ── GDA SCADA Reading — Tab Switching ────────────────────────────────────

        /** Open the full Hybrid / Entry Point over-allocation message in a popover anchored to the pressed button. */
        onShowGdaOverAllocInfo: async function (oEvent) {
            const oButton = oEvent.getSource();
            const oBundle = this.getView().getModel("i18n").getResourceBundle();
            this._mFragments = this._mFragments || {};
            if (!this._mFragments.gdaOverAllocPopover) {
                this._mFragments.gdaOverAllocPopover = await Fragment.load({
                    id: this.getView().getId(),
                    name: "com.ingenx.igmsgasflow.fragments.GdaOverAllocPopover",
                    controller: this
                });
                this.getView().addDependent(this._mFragments.gdaOverAllocPopover);
            }
            const oPopover = this._mFragments.gdaOverAllocPopover;
            oPopover.setTitle(oBundle.getText(oButton.data("titleKey")));
            Fragment.byId(this.getView().getId(), "IdGdaOverAllocText").setText(oBundle.getText(oButton.data("textKey")));
            oPopover.openBy(oButton);
        },

        onANTGDATabSegmentChange: function (oEvent) {
            const sKey = oEvent.getParameter("item").getKey();
            this.byId("IdANTGDAOwnSection").setVisible(sKey === "OWN");
            this.byId("IdANTGDAHybridSection").setVisible(sKey === "HYBRID");
            this.byId("IdANTGDATPSection").setVisible(sKey === "THIRDPARTY");
            this.byId("IdANTGDAEntryPointSection").setVisible(sKey === "ENTRYPOINT");
            this._updateGdaCountText(sKey);
            this.byId("IdANTGDAHybridErrStrip").setVisible(
                sKey === "HYBRID" && this.getView().getModel("hybridErrModel").getProperty("/hasError")
            );
            this.byId("IdANTGDAEntryPointErrStrip").setVisible(
                sKey === "ENTRYPOINT" && this.getView().getModel("epErrModel").getProperty("/hasError")
            );
        },

        // ── SCADA Measurements row selection → filter Scheduled Items ─────────
        // Business Location from measurements can be a Delivery Point OR a Redelivery
        // Point — we cannot reliably determine which, so we do NOT modify the
        // Delivery / Redelivery Point MultiInput tokens. We only build a server-side
        // Location+Partner filter and refresh the nomination table binding.
        onGDARowSelectionChange: function () {
            // removeSelectionInterval below re-fires rowSelectionChange — the outer call
            // finishes the filter rebuild once pruning is done.
            if (this._bGdaPruning) return;
            this._bGdaPruning = true;
            this._pruneNonGroupSelection("IdANTGDAHybridTable", "hybridModel");
            this._pruneNonGroupSelection("IdANTGDAEntryPointTable", "epModel");
            this._bGdaPruning = false;

            const _getRows = (sTableId, sModelName, sSegment) => {
                const oTable = this.byId(sTableId);
                if (!oTable) return [];
                const oModel = this.getView().getModel(sModelName);
                // HYBRID/Entry Point: only the GROUP row survives _pruneNonGroupSelection —
                // it IS the Business Location summary row (real YybusLocation/Location,
                // Yycustomer null), so selecting it means "filter by this whole location".
                // _buildGdaSelectionFilter resolves it to a Location-only filter (no Partner
                // clause), and _sumGDAMeterQty contributes 0 for it (YycumVolCm/YalcsqtyEp
                // undefined/null) — no double-counting against the rows under it.
                return oTable.getSelectedIndices()
                    .map(i => oModel.getProperty(`/${i}`))
                    .filter(Boolean)
                    // Tag with the tab it came from — OWN/HYBRID/TP/EP rows share the
                    // same shape (no _type on OWN/TP, no YvbelnEp on OWN/HYBRID), so
                    // _buildGdaSelectionFilter can't otherwise tell an OWN row from a
                    // THIRDPARTY one to decide whether Yycustomer means anything.
                    .map(r => Object.assign(r, { _gdaSegment: sSegment }));
            };

            const aAll = [
                ..._getRows("IdANTGDAOwnTable",         "ownModel",    "OWN"),
                ..._getRows("IdANTGDAHybridTable",      "hybridModel", "HYBRID"),
                ..._getRows("IdANTGDATPTable",          "tpModel",     "THIRDPARTY"),
                ..._getRows("IdANTGDAEntryPointTable",  "epModel",     "ENTRYPOINT")
            ];

            this._gdaSelectedRows = aAll; // saved so _applyLocalFilters can scope the aggregates
            this._gdaSelectionFilter = this._buildGdaSelectionFilter(aAll);

            // Refresh nomination table binding with the new GDA filter
            this._applyLocalFilters();
        },

        /** Deselect every non-GROUP row — Hybrid/Entry Point select by Business Location only. */
        _pruneNonGroupSelection: function (sTableId, sModelName) {
            const oTable = this.byId(sTableId);
            if (!oTable) return;
            const oModel = this.getView().getModel(sModelName);
            // Covers Select All and keyboard Space, which bypass the hidden row selector.
            oTable.getSelectedIndices()
                .filter(i => oModel.getProperty(`/${i}/_type`) !== "GROUP")
                .forEach(i => oTable.removeSelectionInterval(i, i));
        },

        /** Hide the row selector on non-GROUP rows; rows are recycled on scroll. */
        _syncGroupOnlySelector: function (oRow, sType) {
            const oSel = oRow.getDomRefs().rowSelector;
            if (oSel) oSel.classList.toggle("antGdaNoSelect", sType !== "GROUP");
        },

        /** Redelivery Point allocation (OWN/HYBRID/THIRD-PARTY) and Entry Point allocation
         *  are mutually exclusive scopes — a mixed selection across the SCADA Measurements
         *  tables must block Simulate/Allocate & Save before any backend call fires. An
         *  empty selection (filter-based scope, no segment rows picked) is always valid here
         *  — this only guards against a mixed *segment* selection. */
        _validateSegmentSelectionExclusivity: function () {
            const aRows = this._gdaSelectedRows || [];
            if (!aRows.length) return true;
            const bHasEntryPoint = aRows.some(r => r._gdaSegment === "ENTRYPOINT");
            const bHasRedeliverySide = aRows.some(r => r._gdaSegment === "OWN" || r._gdaSegment === "HYBRID" || r._gdaSegment === "THIRDPARTY");
            if (bHasEntryPoint && bHasRedeliverySide) {
                MessageBox.error(this.getView().getModel("i18n").getResourceBundle().getText("antErrSegmentScopeMixed"));
                return false;
            }
            return true;
        },

        // Location(+Customer) filter for the nomination table, from a set of selected GDA rows.
        // Business Location is always the primary/required criterion. Customer is layered on
        // top only for THIRD-PARTY rows, where Yycustomer genuinely corresponds to the
        // nomination item's own Partner (several customers can share one connection point).
        // HYBRID is Location-based ONLY — Customer never narrows it, regardless of Role
        // (_type PRIMARY vs SECONDARY); when both Roles exist at one Location, the backend's
        // own allocation logic (Gate 6 shared pool / hybridSecondaryMeterMap grouping)
        // reconciles them together. OWN rows' Yycustomer is S/4's location-level "Loc.partner" code, not a real nomination
        // Partner — ANDing it in returned zero rows for any OWN selection, so OWN stays
        // Location-only. Entry Point rows are Contract-shaped, not Location-shaped — a GROUP
        // row IS "the whole Business Location" (many Delivery contracts share it, filter by
        // Location, same as OWN), but an ITEM row is one specific reading tied to one specific
        // Delivery contract — filter by that Contract instead, or selecting what looks like one
        // contract's row would confusingly publish every OTHER Delivery contract at that
        // Location into the table too. Deliberately Delivery-only: the Redelivery leg behind
        // that same nomination item carries a DIFFERENT Contract number on its own row, so it's
        // excluded from this view by construction — the user wants Delivery-contract visibility
        // here, not the paired Redelivery leg. A BALANCE row (Location's residual after its EP
        // contracts, no Contract of its own) falls back to Location-only like GROUP. Entry
        // Point's Yycustomer is the GDA source's own customer, not a real nomination Partner
        // either way, so never used for matching here.
        //
        // Gas Day range: every row filter is also ANDed with that row's own Gas Day, so a
        // Location selected on one day does not pull in the same Location's other days.
        _buildGdaSelectionFilter: function (aRows) {
            if (!aRows.length) return null;
            const aRowFilters = aRows.map(r => {
                const oFilter = this._buildGdaRowFilter(r);
                if (!oFilter || !r._gasDay) return oFilter;
                return new Filter({
                    filters: [new Filter("Gasday", FilterOperator.EQ, r._gasDay), oFilter],
                    and: true
                });
            }).filter(Boolean);
            if (!aRowFilters.length) return null;
            return aRowFilters.length === 1
                ? aRowFilters[0]
                : new Filter({ filters: aRowFilters, and: false });
        },

        /** Location(+Partner / Contract) filter for one selected GDA row — see _buildGdaSelectionFilter. */
        _buildGdaRowFilter: function (r) {
            const bIsEP = r.YvbelnEp !== undefined;
            if (bIsEP && r._type === "ITEM" && r.Contract) {
                return new Filter({
                    filters: [
                        new Filter("Contract",     FilterOperator.EQ, r.Contract),
                        new Filter("LocationType", FilterOperator.EQ, "DELIVERY")
                    ],
                    and: true
                });
            }
            const loc = bIsEP ? r.Location : r.YybusLocation;
            if (!loc) return null; // unresolved EP row — nothing to filter by
            // HYBRID is Location-based only — Partner-matching applies to THIRDPARTY
            // rows exclusively (see this function's own doc comment above).
            const bMatchPartner = r._gdaSegment === "THIRDPARTY";
            const customer  = bMatchPartner && r.Yycustomer ? r.Yycustomer : "";
            if (customer) {
                return new Filter({
                    filters: [
                        new Filter("Location", FilterOperator.EQ, loc),
                        new Filter("Partner",  FilterOperator.EQ, customer)
                    ],
                    and: true
                });
            }
            // An Entry Point GROUP/BALANCE row (no specific Contract of its own,
            // caught above) still means "every Delivery contract at this Business
            // Location" — Entry Point is Delivery-side by construction (see the
            // ITEM-row comment above), so scope to LocationType=DELIVERY here too;
            // otherwise a location code that's also someone else's Redelivery point
            // would pull in unrelated Redelivery-leg rows the user never selected.
            if (bIsEP) {
                return new Filter({
                    filters: [
                        new Filter("Location",     FilterOperator.EQ, loc),
                        new Filter("LocationType", FilterOperator.EQ, "DELIVERY")
                    ],
                    and: true
                });
            }
            return new Filter("Location", FilterOperator.EQ, loc);
        },

        // Stable identity for a GDA row across data refreshes (Own has no _type,
        // Hybrid PRIMARY/SECONDARY share a location, TP/OWN keyed by customer too).
        // Entry Point rows are uniquely identified by their own Vbeln (YvbelnEp) —
        // several EP rows can share the same resolved Location+Customer. The GROUP
        // header row AND the bifurcation BALANCE row both have a blank Vbeln (same as
        // each other) at the SAME Location, so Location alone does not disambiguate
        // them — _type is appended too, or selecting one silently re-selects/merges
        // with the other on the next refresh (see _restoreGdaSelection).
        // Prefixed with the row's Gas Day — the same Location appears once per day of a range.
        _gdaRowKey: function (r) {
            const sDay = (r._gasDay || "") + "|";
            if (r.YvbelnEp !== undefined) return sDay + "EP|" + r.YvbelnEp + "|" + (r.Location || "") + "|" + (r._type || "");
            return sDay + [r.YybusLocation, r.Yycustomer || "", r._type || ""].join("|");
        },

        // Refresh (onRefreshScada/onRefreshNomItems) reloads Own/Hybrid/TP with fresh
        // row objects via setData — the table keeps its selected indices highlighted,
        // but _gdaSelectedRows still points at the pre-refresh objects, so TotalMeteredQty
        // and the nomination table filter stay stale until the user deselects/reselects.
        // Re-derive the selection against the fresh data by row identity instead.
        _restoreGdaSelection: function () {
            if (!this._gdaSelectedRows || !this._gdaSelectedRows.length) return;

            const oKeySet = new Set(this._gdaSelectedRows.map(r => this._gdaRowKey(r)));
            const aFresh = [];

            [
                ["IdANTGDAOwnTable",        "ownModel",    "OWN"],
                ["IdANTGDAHybridTable",     "hybridModel", "HYBRID"],
                ["IdANTGDATPTable",         "tpModel",     "THIRDPARTY"],
                ["IdANTGDAEntryPointTable", "epModel",     "ENTRYPOINT"]
            ].forEach(([sTableId, sModelName, sSegment]) => {
                const oTable = this.byId(sTableId);
                if (!oTable) return;
                oTable.clearSelection();
                const aData = this.getView().getModel(sModelName).getData() || [];
                aData.forEach((r, i) => {
                    if (!oKeySet.has(this._gdaRowKey(r))) return;
                    oTable.addSelectionInterval(i, i);
                    aFresh.push(Object.assign(r, { _gdaSegment: sSegment }));
                });
            });

            this._gdaSelectedRows = aFresh;
            this._gdaSelectionFilter = this._buildGdaSelectionFilter(aFresh);

            this._applyLocalFilters();
        },

        _clearGDASelection: function () {
            ["IdANTGDAOwnTable", "IdANTGDAHybridTable", "IdANTGDATPTable", "IdANTGDAEntryPointTable"].forEach(sId => {
                const oTbl = this.byId(sId);
                if (oTbl) oTbl.clearSelection();
            });
            this._gdaSelectionFilter = null;
            this._gdaSelectedRows    = [];
        },

        _updateGdaCountText: function (sKey) {
            const mModels = { "OWN": "ownCountModel", "HYBRID": "hybridCountModel", "THIRDPARTY": "tpCountModel", "ENTRYPOINT": "epCountModel" };
            const sCount = this.getView().getModel(mModels[sKey] || "ownCountModel").getProperty("/count");
            const oText  = this.byId("IdANTGDACountText");
            if (oText) oText.setText(sCount ? sCount + " record" + (parseInt(sCount) !== 1 ? "s" : "") : "");
        },

        onANTGDAHybridRowsUpdated: function () {
            const oTable = this.byId("IdANTGDAHybridTable");
            oTable.getRows().forEach(oRow => {
                const oDom = oRow.getDomRef();
                if (!oDom) return;
                oDom.classList.remove("igmsGroupHdr", "igmsSecondaryRow");
                const oCtx = oRow.getBindingContext("hybridModel");
                const sType = oCtx?.getProperty("_type");
                this._syncGroupOnlySelector(oRow, sType);
                if (!oCtx) return;
                if (sType === "GROUP")     oDom.classList.add("igmsGroupHdr");
                if (sType === "SECONDARY") oDom.classList.add("igmsSecondaryRow");
            });
        },

        // Entry Point's bifurcation grouping — GROUP header + ITEM rows nested under it,
        // same visual treatment as Hybrid's GROUP/SECONDARY rows above.
        onANTGDAEntryPointRowsUpdated: function () {
            const oTable = this.byId("IdANTGDAEntryPointTable");
            oTable.getRows().forEach(oRow => {
                const oDom = oRow.getDomRef();
                if (!oDom) return;
                oDom.classList.remove("igmsGroupHdr", "igmsSecondaryRow");
                const oCtx = oRow.getBindingContext("epModel");
                const sType = oCtx?.getProperty("_type");
                this._syncGroupOnlySelector(oRow, sType);
                if (!oCtx) return;
                if (sType === "GROUP") oDom.classList.add("igmsGroupHdr");
                if (sType === "ITEM")  oDom.classList.add("igmsSecondaryRow");
            });
        },
    };
});
