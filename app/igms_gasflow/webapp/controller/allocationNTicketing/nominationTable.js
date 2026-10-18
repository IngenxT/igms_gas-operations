sap.ui.define([
    "sap/ui/core/Fragment",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/m/MessageBox",
    "sap/m/MessageToast",
    "sap/m/Token",
    "sap/base/Log",
    "com/ingenx/igmsgasflow/utils/ari006Rules"
], (Fragment, Filter, FilterOperator, MessageBox, MessageToast, Token, Log, ARI006Rules) => {
    "use strict";

    // ── Allocation & Ticketing — Scheduled Items table ────────────────────────
    // Single responsibility: Gas Day selection, the Go/Refresh data-fetch pipeline
    // (getScheduledNomItemsWithSCADA), binding/filtering/aggregating the Scheduled
    // Items table (incl. its full-screen Expand dialog), Clear Filters, and column
    // show/hide + row-coloring for that table.
    return {
        async onExpandTicketing() {
            if (!this._oTicketExpandDlg) {
                this._oTicketExpandDlg = await Fragment.load({
                    id: this.getView().getId(),
                    name: "com.ingenx.igmsgasflow.fragments.TicketExpandDialog",
                    controller: this
                });
                this.getView().addDependent(this._oTicketExpandDlg);
            }
            // Bind the dialog table to the same entity + filters as the main table.
            // Backend cache is already warm — first page returns in ~5ms.
            this._bindExpandNomTable();
            this._oTicketExpandDlg.open();
        },

        // NOTE: keep this $select list in sync with _bindNomTable's — same
        // /ScheduledNomItems entity, just rendered in the expand dialog.
        _bindExpandNomTable: function () {
            const oTable = this.byId("IdTicketExpandTable");
            if (!oTable || !this._currentGasDays.length) return;

            const aDelivery = this.byId("IdANTFilterDeliveryPoint").getTokens().map(t => t.getKey());
            const aRedelivery = this.byId("IdANTFilterRedeliveryPoint").getTokens().map(t => t.getKey());
            const oLocSet = new Set([...aDelivery, ...aRedelivery]);

            const aFilters = [this._buildGasDaysFilter(this._currentGasDays)];
            if (oLocSet.size) {
                aFilters.push(this._buildLocPointFilter());
            } else {
                const oTsFilter = this._buildTransportSystemFilter();
                if (oTsFilter) aFilters.push(oTsFilter);
            }

            oTable.bindRows({
                path: "/ScheduledNomItems",
                parameters: {
                    $$ownRequest: true,
                    $count: true,
                    $select: [
                        "Location", "LocationDesc", "LocationType", "DeliveryPoint", "RedeliveryPoint", "TicketKey", "TicketKeyDisplay", "TicketItem", "TicketVersion", "NominationKey", "NominationItem",
                        "Gasday", "Contract", "CorrespondingDocNo", "ContractType", "ServiceType", "Source", "Rank",
                        "TransportSystem", "TransportSystemName",
                        "Material", "MaterialName", "AVG_WT_GCV", "AVG_WT_NCV",
                        "ProposedDNQ", "UOM", "ConversionQty", "ConversionUOM",
                        "SavedAllocatedQty", "SavedAllocatedUOM", "AllocatedQty", "AllocUOM", "AllocatedQtyMBG",
                        "Partner", "PartnerName", "CustomerKind", "CustomerTypeDisplay", "CustomerTypeState",
                        "TicketPurpose", "TicketStatus", "TicketItemSubStatus",
                        "OverDrawlGSA", "UnderDrawlGSA", "AuthOverrunGTA", "UnauthOverrunGTA", "UnauthOverDrawlGSA",
                        "DPIQty", "DNIQty", "CumImbQty", "ChrgImbQty", "PosCumImbQty", "NegCumImbQty",
                        "LiqAdjustQty", "LiqDamDiscQty", "SellOrPayAdjQty", "SellOrPayDiscQty",
                        "SellersSFAdjQty", "SSFDiscQty", "TakeOrPayAdjQty", "TakeOrPayDiscQty",
                        "GTAAdjust", "GSAAdjust", "GujDNQQty", "GujDNQUOM", "DDSQty"
                    ].join(","),
                    threshold: 150
                },
                filters: aFilters
                // No default sorters: the backend cache is already pre-sorted
                // (CustomerKind→ServiceType→LocationDesc→Rank) at build time, so omitting
                // $orderby serves that order as a zero-cost slice instead of forcing a
                // re-sort on every page request. Column-header clicks (sortProperty on
                // each <table:Column>) still attach their own Sorter independently.
            });

            // bindRows() can be a no-op against the OData V4 model when the path/filters/
            // sorters are identical to the previous binding (e.g. Refresh/Go pressed again
            // for the same Gas Day) — force a real round-trip so backend changes since the
            // last fetch are always reflected, not just when the Gas Day value itself changes.
            oTable.getBinding("rows")?.refresh();
        },

        onCloseScadaExpand() { this._oScadaExpandDlg?.close(); },
        onCloseTicketExpand() { this._oTicketExpandDlg?.close(); },

        // ── Excel Export ─────────────────────────────────────────────────────────

        _formatGasDay: function (oDate) {
            const yyyy = oDate.getFullYear();
            const mm = String(oDate.getMonth() + 1).padStart(2, "0");
            const dd = String(oDate.getDate()).padStart(2, "0");
            return `${yyyy}-${mm}-${dd}`;
        },

        // ── Gas Day range ────────────────────────────────────────────────────────
        // The screen works on 1..MAX_GAS_DAYS Gas Days at once. Every backend function
        // stays single-day (cache, allocation and ticketing are all per Gas Day), so a
        // range is always processed as one call per day, in date order.

        MAX_GAS_DAYS: 7,

        /** Every Gas Day ('yyyy-MM-dd') in the range picker, or null (with the field
         *  set to Error) when nothing is selected or the range is longer than allowed.
         *  A single picked date (no end date) is a one-day range. */
        _getSelectedGasDays: function () {
            const oPicker = this.byId("IdANTFilterGasDay");
            const oBundle = this.getView().getModel("i18n").getResourceBundle();
            const dFrom = oPicker.getDateValue();
            const dTo = oPicker.getSecondDateValue() || dFrom;
            const fnError = sText => {
                oPicker.setValueState("Error");
                oPicker.setValueStateText(sText);
                MessageToast.show(sText);
                oPicker.focus();
                return null;
            };
            if (!dFrom) return fnError(oBundle.getText("antGasDayRequired"));

            const aDays = [];
            const d = new Date(dFrom.getFullYear(), dFrom.getMonth(), dFrom.getDate());
            const dEnd = new Date(dTo.getFullYear(), dTo.getMonth(), dTo.getDate());
            while (d <= dEnd) {
                aDays.push(this._formatGasDay(d));
                if (aDays.length > this.MAX_GAS_DAYS) {
                    return fnError(oBundle.getText("antGasDayRangeTooLong", [this.MAX_GAS_DAYS]));
                }
                d.setDate(d.getDate() + 1);
            }
            oPicker.setValueState("None");
            return aDays;
        },

        /** OR-group Filter matching any of the given Gas Days. */
        _buildGasDaysFilter: function (aGasDays) {
            const aFilters = aGasDays.map(sDay => new Filter("Gasday", FilterOperator.EQ, sDay));
            return aFilters.length === 1 ? aFilters[0] : new Filter({ filters: aFilters, and: false });
        },

        /** Resets stale selection/state when Gas Day changes; data is loaded only via the Go button (onSearch). */
        onGasDayChange: function (oEvent) {
            if (this._bProcessing) return;
            const oDate = oEvent.getSource().getDateValue();
            if (!oDate) return;
            oEvent.getSource().setValueState("None");
            this._clearLoadedData();
        },

        /** Wipes every previously loaded/derived Allocation & Ticketing dataset — Scheduled
         *  Items table, SCADA reading tables/aggregates, Data Issues, GDA row selection —
         *  without touching the filter fields (Gas Day value, Transport/Delivery/Redelivery/
         *  Interconnect tokens). The previous Gas Day's data must never remain visible after
         *  switching to a new one; Go must be pressed again before anything shows. Uses
         *  setProperty (not setData) on allocationModel so canSimulate/canAllocateSave/
         *  canTicket/gdaBusy — set once by _initButtonAuthorization, unrelated to Gas Day —
         *  are left untouched. */
        _clearLoadedData: function () {
            this._rawReadingIssues = [];
            this._rawConvIssues = [];
            this._rawRankIssues = [];
            this._rawTicketedIssues = [];
            this._rawOrphanIssues = [];
            this._excludeEntriesForRun = [];
            this._rawScada = [];
            this._rawAllLocations = [];
            this._nomSummaryAll = null;
            this._currentGasDays = [];
            this._gdaSelectionFilter = null;
            this._gdaSelectedRows = [];
            this._selectedKeys.clear();
            this._clearGDASelection();

            this.getView().getModel("scadaModel").setData([]);
            this.getView().getModel("ari006Model").setProperty("/rules", []);
            const oAllocModel = this.getView().getModel("allocationModel");
            ["AggrAdnq", "TotalMeteredQty", "NomUOM", "MeteredUOM", "AggrAdnqDP", "NomUOMDP",
                "AggrAdnqRDP", "NomUOMRDP", "TotalMeteredQtyDP", "MeteredUOMDP", "TotalMeteredQtyRDP",
                "MeteredUOMRDP", "TotalAllocatedQty", "AllocatedUOM", "ScadaCount", "NomCount", "SelectedCount"]
                .forEach(k => oAllocModel.setProperty("/" + k, ""));
            oAllocModel.setProperty("/btnState", "initial");

            // unbind the Scheduled Items table — old Gas Day's rows must not linger
            this.byId("IdANTTicketItemTbl").unbindRows();

            // Reset GDA SCADA reading section
            ["ownModel", "hybridModel", "tpModel", "epModel"].forEach(n => this.getView().getModel(n).setData([]));
            ["ownCountModel", "hybridCountModel", "tpCountModel", "epCountModel"].forEach(n =>
                this.getView().getModel(n).setProperty("/count", "")
            );
            this.getView().getModel("hybridErrModel").setProperty("/hasError", false);
            this.getView().getModel("epErrModel").setProperty("/hasError", false);
            this.byId("IdANTGDABtnOwn").setText("Own Pipeline");
            this.byId("IdANTGDABtnHybrid").setText("Hybrid");
            this.byId("IdANTGDABtnTP").setText("Third Party");
            this.byId("IdANTGDABtnEntryPoint").setText("Entry Point");
            this.byId("IdANTGDACountText").setText("");
            this.byId("IdANTGDAHybridErrStrip").setVisible(false);
            this.byId("IdANTGDAEntryPointErrStrip").setVisible(false);

            // Default tab selection back to Own Pipeline on every reset
            this.byId("IdANTGDASegBtn").setSelectedKey("OWN");
            this.byId("IdANTGDAOwnSection").setVisible(true);
            this.byId("IdANTGDAHybridSection").setVisible(false);
            this.byId("IdANTGDATPSection").setVisible(false);
            this.byId("IdANTGDAEntryPointSection").setVisible(false);

            // Data Issues summary ("Issues (n)" button + DataIssuesDialog) — must not keep
            // showing the previous Gas Day's count/rows.
            this.getView().getModel("dataIssuesModel").setData({
                ReadingIssues: [], ConversionIssues: [], RankIssues: [], TicketedIssues: [], OrphanIssues: [],
                ReadingCount: 0, ConversionCount: 0, RankCount: 0, TicketedCount: 0, OrphanCount: 0, Count: 0,
                ShowContinue: false
            });
        },
        onSearch: async function () {
            if (this._bProcessing) return;
            const aGasDays = this._getSelectedGasDays();
            if (!aGasDays) return;
            // Tokenize a pasted/typed ID left as plain text — otherwise the RDP filter
            // reads as empty and the Transport auto-derive below selects every RDP
            this._commitPendingFilterText();
            if (!this._validateLocationFilterExclusivity()) return;
            if (!(await this._validateRedeliveryInTransport())) return;

            // Transport selected but no explicit Delivery/Redelivery/Interconnect
            // point — auto-derive that Transport's Redelivery Point(s) so the fetch
            // takes Scenario B/C in scheduledNomItems.js (exact LocationFilter match)
            // instead of Scenario A (fuzzy TS-only locid resolution, which can pull
            // in another transport system sharing a location). Same fix as
            // confirmScheduleNomination.controller.js's onSearch.
            const aTransportKeys = this._getTransportSystemFilterString().split(",").filter(Boolean);
            if (aTransportKeys.length && !this._getLocationFilterString()) {
                try {
                    const aAutoRDP = await this._fetchRedeliveryPointsForTransports(aTransportKeys);
                    const oRDPInput = this.byId("IdANTFilterRedeliveryPoint");
                    aAutoRDP.forEach(o => {
                        if (o.Locid) oRDPInput.addToken(new Token({ key: o.Locid, text: o.Locid }));
                    });
                } catch (oErr) {
                    Log.error("[ANT] Failed to auto-derive Redelivery Point from Transport", oErr?.message, "allocationNTicketing");
                    // fall through — proceed on Scenario A (TS-only) rather than block Go
                }
            }

            this._loadGasDays(aGasDays);
        },

        /** Transport System + Redelivery Point both filled: every RDP token (typed, pasted
         *  or picked) must be mapped to one of the selected Transport Systems. Returns true
         *  when valid or when either filter is empty. */
        _validateRedeliveryInTransport: async function () {
            const oRDPInput = this.byId("IdANTFilterRedeliveryPoint");
            oRDPInput.setValueState("None");
            const aTransportKeys = this._getTransportSystemFilterString().split(",").filter(Boolean);
            const aRdpKeys = oRDPInput.getTokens().map(t => t.getKey());
            if (!aTransportKeys.length || !aRdpKeys.length) return true;

            const oBundle = this.getView().getModel("i18n").getResourceBundle();
            let aAllowed;
            try {
                aAllowed = await this._fetchRedeliveryPointsForTransports(aTransportKeys);
            } catch (oErr) {
                Log.error("[ANT] Redelivery/Transport validation failed", oErr?.message, "allocationNTicketing");
                MessageBox.error(oBundle.getText("antErrRdpTransportCheckFailed"));
                return false;
            }

            const norm = v => String(v || "").trim().toUpperCase();
            const oAllowed = new Set(aAllowed.map(o => norm(o.Locid)));
            const aInvalid = aRdpKeys.filter(k => !oAllowed.has(norm(k)));
            if (!aInvalid.length) return true;

            const sMsg = oBundle.getText("antErrRdpNotInTransport", [aInvalid.join(", "), aTransportKeys.join(", ")]);
            oRDPInput.setValueState("Error");
            oRDPInput.setValueStateText(sMsg);
            MessageBox.error(sMsg);
            return false;
        },

        // If the SCADA/GDA meter reading changed since the cache backing Scheduled Items
        // was built, refresh Scheduled Items too (not just the GDA display tables) and
        // warn the user to re-run Allocation — its AllocatedQty math would otherwise
        // silently keep reflecting the old reading. Returns true when a change was found.
        _checkGdaReadingChanges: async function (aGasDays) {
            const aDelivery   = this.byId("IdANTFilterDeliveryPoint").getTokens().map(t => t.getKey());
            const aRedelivery = this.byId("IdANTFilterRedeliveryPoint").getTokens().map(t => t.getKey());
            const sLocFilter  = [...new Set([...aDelivery, ...aRedelivery])].join(",");
            const bRange = aGasDays.length > 1;

            try {
                const aChanges = [];
                for (const sGasDay of aGasDays) {
                    const oCtx = this.getView().getModel().bindContext("/checkGdaReadingChanges(...)");
                    oCtx.setParameter("Gasday", sGasDay);
                    oCtx.setParameter("LocationFilter", sLocFilter);
                    await oCtx.execute();
                    const oResult = oCtx.getBoundContext().getObject();
                    (oResult?.value ?? oResult ?? []).forEach(c => aChanges.push(Object.assign({ GasDay: sGasDay }, c)));
                }
                if (aChanges.length > 0) {
                    // THIRDPARTY locations have no GAIL meter — their qty is the partner's
                    // own uploaded Customer Qty, so label it as such instead of "Meter Reading".
                    const bIsTp = c => c.Indicator === "THIRDPARTY";
                    const bAnyTp = aChanges.some(bIsTp);
                    const bAllTp = aChanges.every(bIsTp);
                    const sSubject = bAllTp ? "Customer Qty" : bAnyTp ? "Meter Reading / Customer Qty" : "Meter Reading";
                    const sRefreshed = bAllTp ? "customer qty" : bAnyTp ? "reading / customer qty" : "reading";
                    MessageBox.warning(
                        `${sSubject} has changed since Allocation was last run:\n\n` +
                        aChanges.map(c => {
                            const sLabel = bIsTp(c) ? "Customer Qty" : "Reading";
                            const sDay = bRange ? `${this.formatDate(c.GasDay)} ` : "";
                            let s = `• ${sDay}${c.BusinessLocation}:  ${sLabel}: ${c.OldMeterReading.toFixed(3)} → ${c.NewMeterReading.toFixed(3)}`;
                            if (c.OldGCV !== c.NewGCV) s += `  |  GCV: ${c.OldGCV.toFixed(3)} → ${c.NewGCV.toFixed(3)}`;
                            if (c.OldNCV !== c.NewNCV) s += `  |  NCV: ${c.OldNCV.toFixed(3)} → ${c.NewNCV.toFixed(3)}`;
                            return s;
                        }).join("\n") +
                        `\n\nScheduled Items have been refreshed with the new ${sRefreshed}. Please run Allocation again.`,
                        { title: `${sSubject} Changed — Run Allocation Again` }
                    );
                }
                return aChanges.length > 0;
            } catch {
                return false; // non-fatal — refresh continues even if the change check fails
            }
        },

        onRefreshScada: async function () {
            const aGasDays = this._currentGasDays.length ? this._currentGasDays : this._getSelectedGasDays();
            if (!aGasDays) return;
            const bChanged = await this._checkGdaReadingChanges(aGasDays);
            if (bChanged) {
                // Refreshes Scheduled Items' meter reading too (and the GDA tables as part
                // of the same pipeline) — not just the GDA display tables.
                await this._loadGasDays(aGasDays);
            } else {
                this._fetchGdaData(aGasDays);
            }
        },

        // Re-fetches nomination + GDA data from S4/TSW for the current Gas Day — same
        // backend pipeline as Go, so changes made in the backend since the last Go/Refresh
        // are picked up without needing to switch Gas Day away and back.
        // bSuppressMissingScada: pass true only from an internal caller (e.g. Simulate's
        // post-stage refresh) — a direct press of the Refresh button always passes the
        // UI5 event object here instead, so the check below only honors an explicit true.
        onRefreshNomItems: async function (bSuppressMissingScada) {
            if (!this._currentGasDays.length) {
                MessageToast.show("Please select a Gas Day first.");
                return;
            }
            await this._checkGdaReadingChanges(this._currentGasDays);
            await this._loadGasDays(this._currentGasDays, bSuppressMissingScada === true);
        },

        // ── Main Data Fetch ──────────────────────────────────────────────────────
        // getScheduledNomItemsWithSCADA warms the backend _nomCache (kept full-day —
        // Allocation/Ticketing/other callers depend on that). LocationFilter only scopes
        // the NomSummary totals returned to this caller down to the selected locations.
        // Immediately after, _bindNomTable sets the OData V4 binding on the table —
        // the first page arrives as a cache hit in ~5ms.

        /** Comma-separated Delivery+Redelivery+Interconnect keys currently selected. */
        _getLocationFilterString: function () {
            const aDelivery     = this.byId("IdANTFilterDeliveryPoint").getTokens().map(t => t.getKey());
            const aRedelivery   = this.byId("IdANTFilterRedeliveryPoint").getTokens().map(t => t.getKey());
            const aInterconnect = this.byId("IdANTFilterInterconnectPoint").getTokens().map(t => t.getKey());
            return [...new Set([...aDelivery, ...aRedelivery, ...aInterconnect])].join(",");
        },

        /** Comma-separated Transport System keys currently selected — resolved to
         *  Delivery/Redelivery points server-side (scheduledNomItems.js) only when
         *  no explicit Delivery/Redelivery/Interconnect point is also selected,
         *  same Scenario A/B routing as BNS's xGMSxNOMSOURCE READ handler. */
        _getTransportSystemFilterString: function () {
            return this.byId("IdANTFilterTransportSystem").getTokens().map(t => t.getKey()).join(",");
        },

        /** OR-group Filter on the ScheduledNomItems entity's own TransportSystem
         *  field (every cached row carries one) — null when no TS token is
         *  selected. Used only when oLocSet is empty: an explicit Delivery/
         *  Redelivery/Interconnect selection always takes precedence, same as
         *  the backend's TransportSystem-ignored-when-LocationFilter-present
         *  routing (getScheduledNomItemsWithSCADA/getNomSummary). */
        _buildTransportSystemFilter: function () {
            const aKeys = this.byId("IdANTFilterTransportSystem").getTokens().map(t => t.getKey());
            if (!aKeys.length) return null;
            return new Filter({
                filters: aKeys.map(k => new Filter("TransportSystem", FilterOperator.EQ, k)),
                and: false
            });
        },

        // ── Data Issues (Missing SCADA / Allocation Qty / GCV,NCV / Conversion) ────

        // Shapes MissingSCADAReading + ConversionFailures into the two DataIssuesDialog
        // tabs — kept separate (not one flat list) because they're different grains:
        // MissingSCADAReading is Location-level (has TransportSystem, no Nomination),
        // ConversionFailures is nomination-item-level (has NominationKey/Item, no
        // TransportSystem — never tracked at that point in the backend pipeline).
        // Merging them into one table produced a column that was blank for every row of
        // one category or the other. Backend Message text (scheduledNomItems.js's
        // per-segment report, using allocationUtils.js's message helpers) already names
        // the exact gap — "Meter Reading is missing" (OWN/PRIMARY/fallback-HYBRID) vs.
        // "Allocation reading is missing for {Location}/{Partner}" (HYBRID's own
        // dedicated bifurcation meter) vs. "Missing Allocation Qty"/"GCV/NCV reading is
        // missing" (THIRDPARTY) vs. a combination — this maps it to a display
        // category/icon. A GCV/NCV-only gap reads identically ("GCV/NCV reading is
        // missing") whether it's against the OWN meter or a Third Party upload, so the
        // category can't be derived from Message text alone — ReadingSource (OWN/
        // HYBRID/THIRDPARTY/NONE, set server-side in scheduledNomItems.js) disambiguates it.
        _buildDataIssues: function (aMissing, aConvFailures, aMissingRank, aAlreadyTicketed, aOrphanReading) {
            const readingIssues = (aMissing || []).map(m => {
                const sMsg = m.Message || "";
                const sSource = m.ReadingSource || "";
                // Case-insensitive — the standalone "OWN meter never found at all" message
                // (scheduledNomItems.js) reads "Meter reading is missing", while the
                // combined case built via allocationUtils.missingReasonMsg's own 'Meter
                // Reading' label still reads "GCV/NCV & Meter Reading missing" — both must
                // still set bMeter regardless of casing.
                const bMeter = sMsg.toLowerCase().includes("meter reading");
                // "SM3 conversion pending" is deliberately distinct from "Missing Allocation
                // Qty" — it means the partner's quantity IS there, S/4 just hasn't converted
                // it yet, the opposite of what "Missing Allocation Qty" would mean. Checked
                // before bQty so it can't ever collide with the real missing-upload case.
                const bConversionPending = sMsg.includes("SM3 conversion pending");
                const bQty = !bConversionPending && sMsg.includes("Allocation Qty");
                const bQual = sMsg.includes("GCV/NCV");
                // "CM Meter Qty missing" (ReadingSource=ENTRYPOINT, scheduledNomItems.js) —
                // Entry Point's own reading, distinct from OWN's "Meter reading is missing"/
                // THIRDPARTY's "Missing Allocation Qty" even though all three read similarly.
                const bCmMeterQty = sMsg.includes("CM Meter Qty");
                const sSuffix = sSource === "THIRDPARTY" ? " (Third Party)"
                    : sSource === "ENTRYPOINT" ? " (Entry Point)" : "";

                let sCategory = "Missing SCADA Reading"; // no reading of any kind yet
                if (bConversionPending && bQual) sCategory = "SM3 Conversion Pending & Missing GCV,NCV (Third Party)";
                else if (bConversionPending) sCategory = "SM3 Conversion Pending (Third Party)";
                else if (bMeter && bQual) sCategory = "Missing Meter Reading & GCV,NCV";
                // Matches the Details column's own Message text verbatim for this specific
                // case (the standalone "OWN meter never found at all" gap) — previously a
                // differently-worded category label ("Missing Meter Reading") sat over a
                // differently-worded Details message ("Meter reading is missing") for the
                // same issue, reading as two different things.
                else if (bMeter) sCategory = "Meter reading is missing";
                // HYBRID's own dedicated bifurcation meter (YybusLocation+Yycustomer) — a
                // distinct segment from OWN/THIRDPARTY, so it gets its own category rather
                // than falling through to the generic "Missing SCADA Reading" bucket.
                else if (sSource === "HYBRID") sCategory = "Missing Allocation Reading (Hybrid)";
                else if (bCmMeterQty) sCategory = "CM Meter Qty missing (Entry Point)";
                else if (bQty && bQual) sCategory = "Missing Allocation Qty & GCV,NCV (Third Party)";
                else if (bQty) sCategory = "Missing Allocation Qty (Third Party)";
                else if (bQual) sCategory = "Missing GCV,NCV" + sSuffix;

                return {
                    Category: sCategory,
                    CategoryState: "Error",
                    CategoryIcon: "sap-icon://alert",
                    TransportSystem: m.TransportSystem || "",
                    TransportSystemName: m.TransportSystemName || "",
                    BusinessLocation: m.BusinessLocation || "",
                    BusinessLocationDesc: m.BusinessLocationDesc || "",
                    // Set only for a THIRDPARTY row scoped to one partner at a shared
                    // connection point (Partner+Location grain) — blank for a location-wide
                    // gap. allocationActions._checkDataIssuesGate uses this to tell a
                    // self-contained per-partner gap (never excludes the whole Location)
                    // apart from a genuine location-wide block.
                    ReadingSource: sSource,
                    Partner: m.Partner || "",
                    PartnerName: m.PartnerName || "",
                    Message: sMsg
                };
            });
            const conversionIssues = (aConvFailures || []).map(f => ({
                BusinessLocation: f.BusinessLocation || "",
                BusinessLocationDesc: f.BusinessLocationDesc || "",
                NominationKey: f.NominationKey || "",
                NominationItem: f.NominationItem || "",
                Message: f.Message || ""
            }));
            // Rank blank/0 — RunAllocateSave/processTicketing block the whole Location for
            // these; tracked server-side
            // (scheduledNomItems.js) and surfaced here proactively, same as the other two.
            const rankIssues = (aMissingRank || []).map(r => ({
                TransportSystem: r.TransportSystem || "",
                TransportSystemName: r.TransportSystemName || "",
                BusinessLocation: r.BusinessLocation || "",
                BusinessLocationDesc: r.BusinessLocationDesc || "",
                NominationKey: r.NominationKey || "",
                NominationItem: r.NominationItem || "",
                Contract: r.Contract || "",
                Partner: r.Partner || "",
                PartnerName: r.PartnerName || "",
                Message: r.Message || ""
            }));
            // Already ticketed — at least one item at this Location already carries a
            // TicketKey (see scheduledNomItems.js's AlreadyTicketedLocations). Blocks
            // Simulate/Allocate & Save/Ticketing for the whole Location — EXCEPT a
            // THIRDPARTY row scoped to one Partner (ReadingSource=THIRDPARTY + Partner
            // set), which is Partner+Location grain: that partner's prior ticket must
            // not hold back another partner (or OWN/HYBRID) still waiting at the same
            // shared connection point. allocationActions._checkDataIssuesGate treats
            // those as self-handled — surfaced via Continue/Close instead of a hard
            // block, unless the user's own selection IS that exact already-ticketed pair.
            const ticketedIssues = (aAlreadyTicketed || []).map(t => ({
                TransportSystem: t.TransportSystem || "",
                TransportSystemName: t.TransportSystemName || "",
                BusinessLocation: t.BusinessLocation || "",
                BusinessLocationDesc: t.BusinessLocationDesc || "",
                ReadingSource: t.ReadingSource || "",
                Partner: t.Partner || "",
                PartnerName: t.PartnerName || "",
                Message: t.Message || ""
            }));
            // SCADA Measurement present but no matching nomination at all — the mirror case
            // of readingIssues (a nomination with no reading). Same grain rules as
            // ticketedIssues: OWN/PRIMARY/HYBRID-fallback is Location-wide (one shared
            // physical meter, no Partner concept); a HYBRID item with its own dedicated
            // bifurcation meter and THIRDPARTY are both Partner+Location — a shared
            // connection point's partners are independent, so one partner's orphan reading
            // must not block another partner (or OWN/HYBRID) still waiting at the same
            // Location. allocationActions._checkDataIssuesGate treats a Partner-scoped row
            // as self-handled, same as readingIssues/ticketedIssues.
            const orphanIssues = (aOrphanReading || []).map(o => ({
                TransportSystem: o.TransportSystem || "",
                TransportSystemName: o.TransportSystemName || "",
                BusinessLocation: o.BusinessLocation || "",
                BusinessLocationDesc: o.BusinessLocationDesc || "",
                ReadingSource: o.ReadingSource || "",
                Partner: o.Partner || "",
                PartnerName: o.PartnerName || "",
                Message: o.Message || "SCADA Measurement present — no Nomination found"
            }));
            return { readingIssues, conversionIssues, rankIssues, ticketedIssues, orphanIssues };
        },

        // Narrows the raw (Delivery/Redelivery/Interconnect-scoped) issue lists further by
        // the current SCADA Measurements row selection — same oEffectiveLocSet _applyLocalFilters
        // already computes for the Scheduled Items table/aggregates, so the Data Issues dialog
        // stays in sync with "based on selection from SCADA Measurement it automatically filters".
        // Empty set = no GDA row selected = show everything already scoped server-side.
        //
        // Location alone isn't precise enough for a Reading/Ticketed row carrying a Partner
        // (both can be Partner-scoped, self-handled issues at a shared THIRDPARTY — or
        // dedicated-bifurcation-meter HYBRID — connection point; see
        // allocationActions._checkDataIssuesGate) — the Location-only oEffectiveLocSet
        // match would keep showing Partner B's issue even when the user selected only
        // Partner A's row. When the current selection is specifically Third-Party or
        // Hybrid rows, also require the row's own Partner+Location to be one of the
        // selected pairs; a row with no Partner (Location-wide — OWN, fallback HYBRID, or
        // a THIRDPARTY location with no reading at all) is unaffected and still matches on
        // Location alone. Missing Rank stays Location-only, same as Conversion Failures —
        // unlike Reading/Ticketed it's still a location-wide blocking issue regardless of
        // which partner is selected (no self-handled bypass for it in
        // _checkDataIssuesGate), so narrowing it by partner would silently hide/un-block a
        // real missing-Rank item for another partner at the same Location.
        _applyDataIssuesFilter: function (oEffectiveLocSet) {
            const bScoped = !!(oEffectiveLocSet && oEffectiveLocSet.size);
            const aSelectedTpPairs = (this._gdaSelectedRows || [])
                .filter(r => (r._gdaSegment === "THIRDPARTY" || r._gdaSegment === "HYBRID") && r.YybusLocation && r.Yycustomer)
                .map(r => `${r.Yycustomer}__${r.YybusLocation}`);
            const oSelectedTpPairSet = new Set(aSelectedTpPairs);
            const _matchesPartnerScope = r => {
                if (!r.Partner || !oSelectedTpPairSet.size) return true;
                return oSelectedTpPairSet.has(`${r.Partner}__${r.BusinessLocation}`);
            };

            // Gas Day range: a SCADA row is selected on one specific day, so its Location's
            // issues on the other days of the range are out of scope.
            const oSelectedDaysByLoc = new Map();
            (this._gdaSelectedRows || []).forEach(r => {
                const sLoc = r.YvbelnEp !== undefined ? r.Location : r.YybusLocation;
                if (!sLoc) return;
                if (!oSelectedDaysByLoc.has(sLoc)) oSelectedDaysByLoc.set(sLoc, new Set());
                oSelectedDaysByLoc.get(sLoc).add(r._gasDay);
            });
            const _inScope = r => {
                if (bScoped && !oEffectiveLocSet.has(r.BusinessLocation)) return false;
                if (!oSelectedDaysByLoc.size || !oSelectedDaysByLoc.has(r.BusinessLocation)) return true;
                return oSelectedDaysByLoc.get(r.BusinessLocation).has(r.GasDay);
            };

            const aReading = (this._rawReadingIssues || []).filter(_inScope).filter(_matchesPartnerScope);
            const aConversion = (this._rawConvIssues || []).filter(_inScope);
            const aRank = (this._rawRankIssues || []).filter(_inScope);
            const aTicketed = (this._rawTicketedIssues || []).filter(_inScope).filter(_matchesPartnerScope);
            const aOrphan = (this._rawOrphanIssues || []).filter(_inScope).filter(_matchesPartnerScope);

            const oModel = this.getView().getModel("dataIssuesModel");
            oModel.setProperty("/ReadingIssues", aReading);
            oModel.setProperty("/ConversionIssues", aConversion);
            oModel.setProperty("/RankIssues", aRank);
            oModel.setProperty("/TicketedIssues", aTicketed);
            oModel.setProperty("/OrphanIssues", aOrphan);
            oModel.setProperty("/ReadingCount", aReading.length);
            oModel.setProperty("/ConversionCount", aConversion.length);
            oModel.setProperty("/RankCount", aRank.length);
            oModel.setProperty("/TicketedCount", aTicketed.length);
            oModel.setProperty("/OrphanCount", aOrphan.length);
            oModel.setProperty("/Count", aReading.length + aConversion.length + aRank.length + aTicketed.length + aOrphan.length);
        },

        /** Opens DataIssuesDialog (fragment cached on first load) against the current dataIssuesModel. */
        _openDataIssuesDialog: async function () {
            if (!this._oDataIssuesDlg) {
                this._oDataIssuesDlg = await Fragment.load({
                    id: this.getView().getId(),
                    name: "com.ingenx.igmsgasflow.fragments.DataIssuesDialog",
                    controller: this
                });
                this.getView().addDependent(this._oDataIssuesDlg);
            }
            this._oDataIssuesDlg.open();
        },

        /** SCADA Measurements header Issues button — reopens the last-fetched issues list on demand. */
        onShowDataIssues: async function () {
            const nCount = this.getView().getModel("dataIssuesModel").getProperty("/Count") || 0;
            if (!nCount) {
                MessageToast.show("No data issues for the current selection.");
                return;
            }
            await this._openDataIssuesDialog();
        },

        /**
         * Opens DataIssuesDialog as a Continue/Close confirm gate — used by
         * allocationActions._checkDataIssuesGate before Simulate/Allocate & Save when
         * nothing is selected from SCADA Measurements. Resolves true if the user presses
         * Continue (run for the locations without issues), false if they Close instead
         * (cancel the run). Distinct from the plain onShowDataIssues view (header Issues
         * button), which has no Continue button and nothing to resolve.
         * @param {boolean} [bAnyEligible=true] - spec 3.5: pass false when the caller has
         *  determined zero Locations remain eligible after excluding every Data Issue in
         *  scope — hides the Continue button entirely (Dismiss only) instead of offering a
         *  Continue that would run against nothing.
         */
        _openDataIssuesDialogForConfirm: async function (bAnyEligible) {
            await this._openDataIssuesDialog();
            this.getView().getModel("dataIssuesModel").setProperty("/ShowContinue", bAnyEligible !== false);
            return new Promise(resolve => { this._fnDataIssuesResolve = resolve; });
        },

        onContinueDataIssues: function () {
            this.getView().getModel("dataIssuesModel").setProperty("/ShowContinue", false);
            this._oDataIssuesDlg?.close();
            if (this._fnDataIssuesResolve) {
                this._fnDataIssuesResolve(true);
                this._fnDataIssuesResolve = null;
            }
        },

        onCloseDataIssuesDialog() {
            this.getView().getModel("dataIssuesModel").setProperty("/ShowContinue", false);
            this._oDataIssuesDlg?.close();
            if (this._fnDataIssuesResolve) {
                this._fnDataIssuesResolve(false);
                this._fnDataIssuesResolve = null;
            }
        },

        // Loads every Gas Day of the selection — one getScheduledNomItemsWithSCADA call per
        // day (each warms that day's own backend cache entry), results merged in date order.
        // A day that fails to load is reported and left out; the other days still show.
        async _loadGasDays(aGasDays, bSuppressMissingScada) {
            if (this._bProcessing) return;
            this._bProcessing = true;
            const oBundle = this.getView().getModel("i18n").getResourceBundle();
            try {
                const aLoadedDays = [];
                const aFailedDays = [];
                const aScada = [];
                const aAllLocations = [];
                const aSummaries = [];
                const oIssues = { readingIssues: [], conversionIssues: [], rankIssues: [], ticketedIssues: [], orphanIssues: [] };

                for (let i = 0; i < aGasDays.length; i++) {
                    const sGasDay = aGasDays[i];
                    this._showBusy(aGasDays.length > 1
                        ? oBundle.getText("antLoadingGasDay", [this.formatDate(sGasDay), i + 1, aGasDays.length])
                        : "Fetching scheduled nominations with SCADA data...");
                    try {
                        const oData = await this._fetchScheduledDay(sGasDay);
                        aLoadedDays.push(sGasDay);
                        aScada.push(...(oData?.SCADAData ?? []));
                        aAllLocations.push(...(oData?.AllBusinessLocations ?? []));
                        if (oData?.NomSummary) aSummaries.push(oData.NomSummary);

                        // Data Issues are built per day and tagged with it — the same Location
                        // can have a problem on one day and be fine on the next.
                        const oDayIssues = this._buildDataIssues(oData?.MissingSCADAReading, oData?.ConversionFailures,
                            oData?.MissingRank, oData?.AlreadyTicketedLocations, oData?.OrphanReadingLocations);
                        Object.keys(oIssues).forEach(k =>
                            oIssues[k].push(...oDayIssues[k].map(r => Object.assign({ GasDay: sGasDay }, r))));
                    } catch (oErr) {
                        aFailedDays.push({ day: sGasDay, message: oErr?.message ?? "Failed to load data." });
                    }
                }

                this._rawScada = aScada.map(s => ({
                    Businesslocation: s.BusinessLocation,
                    Gasday: s.Gasday,
                    Actualquanty: s.MeterReading,
                    ReadingUOM: s.MeterReadingUOM,
                    AggrNomQty: s.AggreNominatedQty,
                    NomUOM: s.AggreNominatedUOM,
                    Actualgcv: s.AverageGCV,
                    Averagencv: s.AverageNCV
                }));
                // Full Business Location universe across the loaded days (locMeta,
                // server-side) — SCADAData above is legacy-empty (SCADA table removed), so
                // this is the only reliable source for "how many Locations exist at all".
                this._rawAllLocations = [...new Set(aAllLocations.map(l => l.Location).filter(Boolean))];
                this._nomSummaryAll = this._sumNomSummaries(aSummaries); // pre-computed totals for unfiltered view
                this._currentGasDays = aLoadedDays;

                // Clear row selection on every new Gas Day search
                this._selectedKeys.clear();
                this.getView().getModel("allocationModel").setProperty("/SelectedCount", "");

                // Data Issues (Missing SCADA Reading / Missing Uploaded Qty / Missing
                // GCV,NCV from Third Party / Conversion Failures) — stored raw here (already
                // scoped server-side to the Delivery/Redelivery/Interconnect filter), then
                // _applyLocalFilters (below) narrows it further by any active SCADA
                // Measurements row selection via _applyDataIssuesFilter, and keeps doing so
                // on every later selection change too — instead of stacking separate
                // MessageBoxes, surfaced via DataIssuesDialog, also reachable any time from
                // the SCADA Measurements header Issues button.
                this._rawReadingIssues = oIssues.readingIssues;
                this._rawConvIssues = oIssues.conversionIssues;
                this._rawRankIssues = oIssues.rankIssues;
                this._rawTicketedIssues = oIssues.ticketedIssues;
                this._rawOrphanIssues = oIssues.orphanIssues;

                if (aLoadedDays.length) {
                    this._applyLocalFilters();
                    this._fetchGdaData(aLoadedDays); // fire-and-forget
                    this._fetchARI006Rules(); // fire-and-forget — client-side pre-check only
                }

                this._hideBusy();
                if (aFailedDays.length) {
                    MessageBox.error(oBundle.getText("antLoadFailedDays") + "\n\n" +
                        aFailedDays.map(f => `• ${this.formatDate(f.day)}: ${f.message}`).join("\n"));
                }

                const nIssueCount = this.getView().getModel("dataIssuesModel").getProperty("/Count") || 0;
                if (nIssueCount && !bSuppressMissingScada) {
                    await this._openDataIssuesDialog();
                }

            } catch (oErr) {
                MessageBox.error(oErr?.message ?? "Failed to load data.");
            } finally {
                this._bProcessing = false;
                this._hideBusy();
            }
        },

        /** getScheduledNomItemsWithSCADA for one Gas Day — warms that day's backend cache. */
        _fetchScheduledDay: async function (sGasDay) {
            const oCtx = this.getView().getModel().bindContext("/getScheduledNomItemsWithSCADA(...)");
            oCtx.setParameter("Gasday", sGasDay);
            oCtx.setParameter("LocationFilter", this._getLocationFilterString());
            oCtx.setParameter("TransportSystem", this._getTransportSystemFilterString());
            await oCtx.execute();
            const oResult = oCtx.getBoundContext().getObject();
            return oResult?.value?.[0] ?? oResult;
        },

        /** Adds up per-day NomSummary totals; each UOM is taken from the first day that has one. */
        _sumNomSummaries: function (aSummaries) {
            if (!aSummaries.length) return null;
            if (aSummaries.length === 1) return aSummaries[0];
            const aQtyFields = ["TotalCount", "AggrApprovedQty", "AggrApprovedQtyDP", "AggrApprovedQtyRDP",
                "AggrMeteredQty", "AggrMeteredQtyDP", "AggrMeteredQtyRDP",
                "AggrAllocatedQty", "AggrAllocatedQtyDP", "AggrAllocatedQtyRDP"];
            const aUomFields = ["AggrUOM", "AggrUOMDP", "AggrUOMRDP", "MeteredUOM", "MeteredUOMDP", "MeteredUOMRDP",
                "AllocatedUOM", "AllocatedUOMDP", "AllocatedUOMRDP"];
            const oSum = {};
            aQtyFields.forEach(k => {
                oSum[k] = aSummaries.reduce((n, s) => n + (parseFloat(s[k]) || 0), 0);
            });
            aUomFields.forEach(k => {
                oSum[k] = (aSummaries.find(s => s[k]) || {})[k] || "";
            });
            return oSum;
        },

        // ── ARI006 Business Rule (Reject) — client-side pre-check ────────────────
        // Fetches active Reject rules for ARI006 directly from the already-exposed
        // getBusinessRule entity (same one the admin Business Rules UI reads —
        // igmsConfigDataHandlers.js's plain passthrough READ) and parses them once
        // per Go-press via app/.../utils/ari006Rules.js — the Scheduled Items
        // table's fmtARI006Icon/State/Text formatters then evaluate each row
        // against ari006Model>/rules with zero extra network/parse cost per row.
        // Non-fatal on failure: this is a pre-check only, never the gate itself —
        // processTicketing.js's own server-side copy still runs (and still blocks)
        // at ticket-post time regardless of whether this succeeded.
        _fetchARI006Rules: async function () {
            try {
                const oModel = this.getView().getModel();
                const oBinding = oModel.bindList("/getBusinessRule", null, null, [
                    new Filter("areaOfInterest_ruleAreaCode", FilterOperator.EQ, "ARI006"),
                    new Filter("isActive", FilterOperator.EQ, true),
                    new Filter("isActiveRule", FilterOperator.EQ, true),
                    new Filter("actionType", FilterOperator.EQ, "Reject")
                ], null, {
                    $expand: "conditions($expand=rows($expand=fields))",
                    $$groupId: "$direct"
                });
                const aContexts = await oBinding.requestContexts(0, 200);
                const aParsed = ARI006Rules.parseARI006Rules(aContexts.map(c => c.getObject()));
                this.getView().getModel("ari006Model").setProperty("/rules", aParsed);
            } catch {
                this.getView().getModel("ari006Model").setProperty("/rules", []);
            }
        },

        // ── Local Filters ────────────────────────────────────────────────────────

        _applyLocalFilters: function () {
            const aDelivery = this.byId("IdANTFilterDeliveryPoint").getTokens().map(t => t.getKey());
            const aRedelivery = this.byId("IdANTFilterRedeliveryPoint").getTokens().map(t => t.getKey());
            const aInterconnect = this.byId("IdANTFilterInterconnectPoint").getTokens().map(t => t.getKey());
            const oLocSet = new Set([...aDelivery, ...aRedelivery, ...aInterconnect]);

            // SCADA table — small dataset (≤ locations), kept as JSONModel
            const aScada = oLocSet.size
                ? this._rawScada.filter(r => oLocSet.has(r.Businesslocation))
                : this._rawScada.slice();
            this.getView().getModel("scadaModel").setData(aScada);

            // Nomination table — OData V4 binding with server-side paging (threshold: 150)
            if (this._currentGasDays.length) this._bindNomTable(this._currentGasDays, oLocSet);

            // Aggregates — narrow to GDA-selected locations when a row selection is active.
            // Entry Point rows carry their resolved Business Location in `Location`, not
            // `YybusLocation` (blank on the raw GDA row — EP has no location field of its
            // own, see epVbelnToLocation) — same per-row resolution _buildGdaSelectionFilter
            // uses, so an Entry-Point-only selection isn't silently dropped from the
            // aggregates/Data Issues scope below.
            let oEffectiveLocSet = oLocSet;
            if (this._gdaSelectedRows && this._gdaSelectedRows.length) {
                const gdaLocSet = new Set(this._gdaSelectedRows
                    .map(r => (r.YvbelnEp !== undefined ? r.Location : r.YybusLocation))
                    .filter(Boolean));
                // Intersect with delivery/redelivery filter when active; else use GDA locs directly.
                // Entry Point locations are kept regardless — they may be a Redelivery filter's
                // linked Delivery-leg location (see _buildLocPointFilter), never in oLocSet itself.
                const oEpLocSet = new Set(this._getSelectedEpLocations());
                oEffectiveLocSet = oLocSet.size
                    ? new Set([...gdaLocSet].filter(l => oLocSet.has(l) || oEpLocSet.has(l)))
                    : gdaLocSet;
            }
            this._refreshAggregates(oEffectiveLocSet, this._gdaSelectedRows);

            // Data Issues dialog — same effective location scope as the Scheduled Items
            // table/aggregates above, so selecting a Business Location in SCADA Measurements
            // automatically narrows the issues list too (re-run on every filter/selection
            // change since this function is the shared "re-derive everything" entry point).
            this._applyDataIssuesFilter(oEffectiveLocSet);

            this.getView().getModel("allocationModel")
                .setProperty("/ScadaCount", aScada.length ? String(aScada.length) : "");
        },

        /** Delivery tokens → DeliveryPoint, Redelivery → RedeliveryPoint, Interconnect → either. */
        _buildLocPointFilter: function () {
            const fnKeys = sId => this.byId(sId).getTokens().map(t => t.getKey());
            const fnEq = (sPath, aKeys) => aKeys.map(k => new Filter(sPath, FilterOperator.EQ, k));
            const aInterconnect = fnKeys("IdANTFilterInterconnectPoint");
            return new Filter({
                filters: [
                    ...fnEq("DeliveryPoint",   fnKeys("IdANTFilterDeliveryPoint")),
                    ...fnEq("RedeliveryPoint", fnKeys("IdANTFilterRedeliveryPoint")),
                    // Interconnect points sit on either leg of a nomination.
                    ...fnEq("DeliveryPoint",   aInterconnect),
                    ...fnEq("RedeliveryPoint", aInterconnect),
                    // Selected Entry Point locations — getGasAllocationData already admits a
                    // Redelivery-only filter's linked Delivery-leg location (nomCache.
                    // expandLinkedLocations, e.g. C50533 → DAHEJ), but those Delivery rows
                    // carry DeliveryPoint=DAHEJ, not the toolbar's RedeliveryPoint, so without
                    // this the EP selection filter ANDed below always matched zero rows.
                    ...fnEq("DeliveryPoint",   this._getSelectedEpLocations())
                ],
                and: false
            });
        },

        /** Resolved Business Locations of the currently selected Entry Point rows. */
        _getSelectedEpLocations: function () {
            return [...new Set((this._gdaSelectedRows || [])
                .filter(r => r._gdaSegment === "ENTRYPOINT" && r.Location)
                .map(r => r.Location))];
        },

        // Binds (or re-binds) IdANTTicketItemTbl to /ScheduledNomItems.
        // Clears the selection registry so stale keys from the previous binding cannot be used.
        // The backend cache is already warm — first page returns in ~5ms.
        _bindNomTable: function (aGasDays, oLocSet) {
            const oTable = this.byId("IdANTTicketItemTbl");

            // Reset row selection state
            this._selectedKeys.clear();
            oTable.clearSelection();
            this.getView().getModel("allocationModel").setProperty("/SelectedCount", "");

            const aFilters = [this._buildGasDaysFilter(aGasDays)];

            if (oLocSet && oLocSet.size) {
                aFilters.push(this._buildLocPointFilter());
            } else {
                const oTsFilter = this._buildTransportSystemFilter();
                if (oTsFilter) aFilters.push(oTsFilter);
            }

            // SCADA Measurements row-selection filter (Customer + Business Location)
            if (this._gdaSelectionFilter) aFilters.push(this._gdaSelectionFilter);

            // Unbind first, unconditionally, instead of just re-calling bindRows() — a V4
            // ODataListBinding can be reused (not recreated) when bindRows() judges the new
            // BindingInfo "the same as before", silently keeping the old binding's already-
            // fetched page around. Explicitly destroying the old binding first guarantees
            // bindRows() always creates a fresh one — no reliance on UI5's reuse heuristics.
            oTable.unbindAggregation("rows", true);

            oTable.bindRows({
                path: "/ScheduledNomItems",
                parameters: {
                    $$ownRequest: true,
                    $count: true,
                    $select: [
                        "Location", "LocationDesc", "LocationType", "DeliveryPoint", "RedeliveryPoint", "TicketKey", "TicketKeyDisplay", "TicketItem", "TicketVersion", "NominationKey", "NominationItem",
                        "Gasday", "Contract", "CorrespondingDocNo", "ContractType", "ServiceType", "Source", "Rank",
                        "TransportSystem", "TransportSystemName",
                        "Material", "MaterialName", "AVG_WT_GCV", "AVG_WT_NCV",
                        "ProposedDNQ", "UOM", "ConversionQty", "ConversionUOM",
                        "SavedAllocatedQty", "SavedAllocatedUOM", "AllocatedQty", "AllocUOM", "AllocatedQtyMBG",
                        "Partner", "PartnerName", "CustomerKind", "CustomerTypeDisplay", "CustomerTypeState",
                        "TicketPurpose", "TicketStatus", "TicketItemSubStatus",
                        "OverDrawlGSA", "UnderDrawlGSA", "AuthOverrunGTA", "UnauthOverrunGTA", "UnauthOverDrawlGSA",
                        "DPIQty", "DNIQty", "CumImbQty", "ChrgImbQty", "PosCumImbQty", "NegCumImbQty",
                        "LiqAdjustQty", "LiqDamDiscQty", "SellOrPayAdjQty", "SellOrPayDiscQty",
                        "SellersSFAdjQty", "SSFDiscQty", "TakeOrPayAdjQty", "TakeOrPayDiscQty",
                        "GTAAdjust", "GSAAdjust", "GujDNQQty", "GujDNQUOM", "DDSQty"
                    ].join(","),
                    threshold: 150
                },
                filters: aFilters
                // No default sorters: the backend cache is already pre-sorted
                // (CustomerKind→ServiceType→LocationDesc→Rank) at build time, so omitting
                // $orderby serves that order as a zero-cost slice instead of forcing a
                // re-sort on every page request. Column-header clicks (sortProperty on
                // each <table:Column>) still attach their own Sorter independently.
            });
            // No trailing .refresh() needed — the unconditional unbindAggregation above
            // guarantees bindRows() always creates a fresh binding (which fetches on
            // creation), so there's no stale/reused binding left to force a round-trip on.

            // "Scheduled Items (n)" comes from this binding's own $count, so it always
            // matches the rows the table shows under every filter/selection combination.
            const oAllocModel = this.getView().getModel("allocationModel");
            oAllocModel.setProperty("/NomCount", "");
            oTable.getBinding("rows")?.attachDataReceived(oEvent => {
                const iCount = oEvent.getSource().getCount();
                oAllocModel.setProperty("/NomCount", iCount != null ? String(iCount) : "");
            });
        },

        // Fetches NomSummary from backend and applies it to the allocationModel.
        // When no location filter is active, reuses the summary returned with the
        // getScheduledNomItemsWithSCADA response (zero extra network round-trip).
        // When a location filter is active, calls getNomSummary so the backend
        // computes exact totals from its cache — no 1.5 L row transfer to the UI.
        _refreshAggregates: async function (oLocSet, aGdaRows) {
            if (!this._currentGasDays.length) return;

            const bHasGda = Array.isArray(aGdaRows) && aGdaRows.length > 0;
            const bHasLoc = !!(oLocSet && oLocSet.size);
            // Resolved server-side (nomSummary.js) against that TS's Delivery/
            // Redelivery points — same Scenario A routing as the Go fetch — only when
            // no explicit Delivery/Redelivery/Interconnect point is also selected.
            const sTransportSystem = bHasLoc ? "" : this._getTransportSystemFilterString();

            if (!bHasGda && !bHasLoc && !sTransportSystem) {
                this._applyAggregates(this._nomSummaryAll);
                return;
            }

            try {
                // One getNomSummary per Gas Day, then added up. With a SCADA row selection,
                // each day is scoped to the rows selected on THAT day only — a day with no
                // selected rows contributes nothing (same as the Scheduled Items table).
                const aSummaries = [];
                for (const sGasDay of this._currentGasDays) {
                    let oDayLocSet = oLocSet;
                    let aDayGdaRows = aGdaRows;
                    if (bHasGda) {
                        aDayGdaRows = aGdaRows.filter(r => r._gasDay === sGasDay);
                        if (!aDayGdaRows.length) continue;
                        const oDayGdaLocs = new Set(aDayGdaRows
                            .map(r => (r.YvbelnEp !== undefined ? r.Location : r.YybusLocation))
                            .filter(Boolean));
                        oDayLocSet = bHasLoc ? new Set([...oLocSet].filter(l => oDayGdaLocs.has(l))) : oDayGdaLocs;
                    }
                    const sLocFilter = oDayLocSet && oDayLocSet.size ? [...oDayLocSet].join(",") : "";
                    // THIRD-PARTY rows are Location+Customer scoped (unlike OWN/HYBRID/
                    // ENTRYPOINT, which stay Location-based) — without this, "Scheduled Items
                    // (n)" counted every OTHER partner sharing the same Business Location too.
                    const sPartnerFilter = this._getSelectedTpPairs(aDayGdaRows).join(",");
                    const oModel = this.getView().getModel();
                    const oCtx = oModel.bindContext("/getNomSummary(...)");
                    oCtx.setParameter("Gasday", sGasDay);
                    oCtx.setParameter("LocationFilter", sLocFilter);
                    oCtx.setParameter("TransportSystem", sTransportSystem);
                    oCtx.setParameter("PartnerFilter", sPartnerFilter);
                    await oCtx.execute();
                    aSummaries.push(Object.assign({}, oCtx.getBoundContext().getObject()));
                }
                const oSummary = Object.assign({}, this._sumNomSummaries(aSummaries));

                // Selected SCADA rows carry the exact per-segment meter qty (OWN/HYBRID
                // location meter, TP customer upload, EP CM meter) — use it instead of the
                // backend's location-level total, which can't split a TP pair's own share.
                if (bHasGda) oSummary.SelectionMeteredQty = this._sumGDAMeterQty(aGdaRows);

                this._applyAggregates(oSummary);
            } catch (oErr) {
                // Aggregates are informational — never block the screen, but don't hide it
                Log.error("[ANT] Failed to refresh Scheduled Items aggregates", oErr?.message, "allocationNTicketing");
            }
        },

        /** Current effective Location scope: filter tokens narrowed by SCADA-row and table-row selection. */
        _getEffectiveLocations: function () {
            const aDelivery   = this.byId("IdANTFilterDeliveryPoint").getTokens().map(t => t.getKey());
            const aRedelivery = this.byId("IdANTFilterRedeliveryPoint").getTokens().map(t => t.getKey());
            let oEffLoc = new Set([...aDelivery, ...aRedelivery]);
            const _narrow = aLocs => {
                if (!aLocs.length) return;
                const oSet = new Set(aLocs);
                oEffLoc = oEffLoc.size ? new Set([...oSet].filter(l => oEffLoc.has(l))) : oSet;
            };
            if (this._gdaSelectedRows?.length) {
                // Entry Point rows carry their resolved Business Location in `Location`, not
                // `YybusLocation` (blank on the raw GDA row)
                _narrow(this._gdaSelectedRows
                    .map(r => (r.YvbelnEp !== undefined ? r.Location : r.YybusLocation))
                    .filter(Boolean));
            }
            if (this._selectedKeys?.size) {
                _narrow([...this._selectedKeys.values()].map(r => r.Location).filter(Boolean));
            }
            return oEffLoc;
        },

        /** "Partner__Location" pairs of selected Third-Party rows — the only Location+Customer-scoped segment.
         *  aRows defaults to the whole SCADA selection; pass one day's rows to scope it to that day. */
        _getSelectedTpPairs: function (aRows) {
            return (aRows || this._gdaSelectedRows || [])
                .filter(r => r._gdaSegment === "THIRDPARTY" && r.YybusLocation && r.Yycustomer)
                .map(r => `${r.Yycustomer}__${r.YybusLocation}`);
        },

        /** True when every selected SCADA row is from the Entry Point segment → header shows Delivery totals. */
        _isEntryPointSelection: function () {
            const aRows = this._gdaSelectedRows || [];
            return aRows.length > 0 && aRows.every(r => r._gdaSegment === "ENTRYPOINT");
        },

        // Returns the sum of Qty to Allocate for each selected GDA row, keyed by type:
        //   OWN          → YycumVolCm   (raw SCADA meter reading)
        //   HYBRID GROUP → _scadaVol    (the Location's whole meter — HYBRID is Location-based,
        //                  only the GROUP row is selectable; PRIMARY/SECONDARY share this meter)
        //   HYBRID PRIMARY / SECONDARY → _allocQty  (PRIMARY = totalMR−bifurcations; SECONDARY = bifurcation share)
        //   THIRD PARTY  → YyallocQtyNongailscm (S/4-provided SM3 equivalent — this
        //                  method's result is reported as MeteredUOM "SM3" by the caller,
        //                  so it must not sum the raw, possibly non-SM3 YyallocQtyNongail)
        //   ENTRY POINT  → YalcsqtyEp (identified by a defined YvbelnEp, unlike the other three) —
        //                  EXCEPT the whole-Location GROUP row, where gdaTransform.js deliberately
        //                  sets YalcsqtyEp null and puts the real CM Meter Qty in _scadaVol instead
        //                  (same convention as OWN/HYBRID's own GROUP rows). Selecting that row must
        //                  show the CM meter reading, not 0.
        _sumGDAMeterQty: function (aRows) {
            const sum = aRows.reduce((s, r) => {
                if (r._type === "GROUP" && r.YvbelnEp === undefined)
                    return s + parseFloat(r._scadaVol || 0);
                if (r._type === "PRIMARY" || r._type === "SECONDARY")
                    return s + parseFloat(r._allocQty || 0);
                if (r.YvbelnEp !== undefined)
                    return s + parseFloat((r._type === "GROUP" ? r._scadaVol : r.YalcsqtyEp) || 0);
                if (r.YyallocQtyNongailscm !== undefined)
                    return s + parseFloat(r.YyallocQtyNongailscm || 0);
                return s + parseFloat(r.YycumVolCm || 0);
            }, 0);
            return parseFloat(sum.toFixed(3));
        },

        /** Header totals: Redelivery DNQ/meter by default; Delivery DNQ/EP meter for an Entry-Point-only selection. */
        _applyAggregates: function (oSummary) {
            const oAllocModel = this.getView().getModel("allocationModel");
            if (!oSummary) {
                ["AggrAdnq", "NomUOM", "AggrAdnqDP", "NomUOMDP", "AggrAdnqRDP", "NomUOMRDP",
                    "TotalMeteredQty", "MeteredUOM", "TotalMeteredQtyDP", "MeteredUOMDP",
                    "TotalMeteredQtyRDP", "MeteredUOMRDP", "TotalAllocatedQty", "AllocatedUOM"]
                    .forEach(k => oAllocModel.setProperty("/" + k, ""));
                return;
            }
            const fmt = v => v != null ? this._roundHalfUp(parseFloat(v), 3).toFixed(3) : "";
            const bEntryPoint = this._isEntryPointSelection();
            const nMetered = oSummary.SelectionMeteredQty != null
                ? oSummary.SelectionMeteredQty
                : (bEntryPoint ? oSummary.AggrMeteredQtyDP : oSummary.AggrMeteredQtyRDP);
            const sMeteredUom = oSummary.SelectionMeteredQty != null
                ? "SM3"
                : ((bEntryPoint ? oSummary.MeteredUOMDP : oSummary.MeteredUOMRDP) || "SM3");
            oAllocModel.setProperty("/AggrAdnq", fmt(bEntryPoint ? oSummary.AggrApprovedQtyDP : oSummary.AggrApprovedQtyRDP));
            oAllocModel.setProperty("/NomUOM", (bEntryPoint ? oSummary.AggrUOMDP : oSummary.AggrUOMRDP) || "");
            oAllocModel.setProperty("/AggrAdnqDP", fmt(oSummary.AggrApprovedQtyDP));
            oAllocModel.setProperty("/NomUOMDP", oSummary.AggrUOMDP || "");
            oAllocModel.setProperty("/AggrAdnqRDP", fmt(oSummary.AggrApprovedQtyRDP));
            oAllocModel.setProperty("/NomUOMRDP", oSummary.AggrUOMRDP || "");
            oAllocModel.setProperty("/TotalMeteredQty", fmt(nMetered));
            oAllocModel.setProperty("/MeteredUOM", sMeteredUom);
            oAllocModel.setProperty("/TotalMeteredQtyDP", fmt(oSummary.AggrMeteredQtyDP));
            oAllocModel.setProperty("/MeteredUOMDP", oSummary.MeteredUOMDP || "");
            oAllocModel.setProperty("/TotalMeteredQtyRDP", fmt(oSummary.AggrMeteredQtyRDP));
            oAllocModel.setProperty("/MeteredUOMRDP", oSummary.MeteredUOMRDP || "");
            oAllocModel.setProperty("/TotalAllocatedQty", fmt(bEntryPoint ? oSummary.AggrAllocatedQtyDP : oSummary.AggrAllocatedQtyRDP));
            oAllocModel.setProperty("/AllocatedUOM", (bEntryPoint ? oSummary.AllocatedUOMDP : oSummary.AllocatedUOMRDP) || "");
        },

        onClearFilters: function () {
            this.byId("IdANTFilterGasDay").setValue("");
            this.byId("IdANTFilterGasDay").setValueState("None");
            this.byId("IdANTFilterTransportSystem").removeAllTokens();
            this.byId("IdANTFilterDeliveryPoint").removeAllTokens();
            this.byId("IdANTFilterRedeliveryPoint").removeAllTokens();
            this.byId("IdANTFilterInterconnectPoint").removeAllTokens();

            this._rawScada = [];
            this._rawAllLocations = [];
            this._nomSummaryAll = null;
            this._currentGasDays = [];
            this._selectedKeys.clear();
            this._clearGDASelection();

            this.getView().getModel("scadaModel").setData([]);
            this.getView().getModel("allocationModel").setData({
                AggrAdnq: "", TotalMeteredQty: "", NomUOM: "", MeteredUOM: "",
                AggrAdnqDP: "", NomUOMDP: "", AggrAdnqRDP: "", NomUOMRDP: "",
                TotalMeteredQtyDP: "", MeteredUOMDP: "", TotalMeteredQtyRDP: "", MeteredUOMRDP: "",
                TotalAllocatedQty: "", AllocatedUOM: "",
                ScadaCount: "", NomCount: "", SelectedCount: "", btnState: "initial"
            });

            // unbind the nomination table
            this.byId("IdANTTicketItemTbl").unbindRows();

            // Location VH working Sets — next open re-derives from the now-empty MultiInputs
            this._oTransportSelSet = null;
            this._oLocSelSet.delivery.clear();
            this._oLocSelSet.redelivery.clear();
            this._oLocSelSet.interconnect.clear();

            // Reset GDA SCADA reading section
            ["ownModel", "hybridModel", "tpModel", "epModel"].forEach(n => this.getView().getModel(n).setData([]));
            ["ownCountModel", "hybridCountModel", "tpCountModel", "epCountModel"].forEach(n =>
                this.getView().getModel(n).setProperty("/count", "")
            );
            this.getView().getModel("hybridErrModel").setProperty("/hasError", false);
            this.getView().getModel("epErrModel").setProperty("/hasError", false);
            this.byId("IdANTGDABtnOwn").setText("Own Pipeline");
            this.byId("IdANTGDABtnHybrid").setText("Hybrid");
            this.byId("IdANTGDABtnTP").setText("Third Party");
            this.byId("IdANTGDABtnEntryPoint").setText("Entry Point");
            this.byId("IdANTGDACountText").setText("");
            this.byId("IdANTGDAHybridErrStrip").setVisible(false);
            this.byId("IdANTGDAEntryPointErrStrip").setVisible(false);

            // Default tab selection back to Own Pipeline on every reset
            this.byId("IdANTGDASegBtn").setSelectedKey("OWN");
            this.byId("IdANTGDAOwnSection").setVisible(true);
            this.byId("IdANTGDAHybridSection").setVisible(false);
            this.byId("IdANTGDATPSection").setVisible(false);
            this.byId("IdANTGDAEntryPointSection").setVisible(false);
        },

        // ── GDA SCADA Reading — Fetch ────────────────────────────────────────────

        onOpenColumnSettings: function () {
            this._openColumnSettings(this.byId("IdANTTicketItemTbl"));
        },

        onOpenExpandColumnSettings: function () {
            this._openColumnSettings(this.byId("IdTicketExpandTable"));
        },

        _openColumnSettings: function (oTable) {
            const aColumns = oTable.getColumns();
            const aCheckBoxes = aColumns.map((oCol, idx) => new sap.m.CheckBox({
                text: oCol.getLabel() ? oCol.getLabel().getText() : ("Column " + (idx + 1)),
                selected: oCol.getVisible()
            }));

            const oDialog = new sap.m.Dialog({
                title: "Show / Hide Columns",
                contentWidth: "300px",
                verticalScrolling: true,
                content: [new sap.m.VBox({ items: aCheckBoxes, class: "sapUiSmallMarginBeginEnd sapUiSmallMarginTopBottom" })],
                beginButton: new sap.m.Button({
                    text: "Apply",
                    type: "Emphasized",
                    press: function () {
                        aCheckBoxes.forEach((oCB, idx) => aColumns[idx].setVisible(oCB.getSelected()));
                        oDialog.close();
                    }
                }),
                endButton: new sap.m.Button({
                    text: "Cancel",
                    press: function () { oDialog.close(); }
                }),
                afterClose: function () { oDialog.destroy(); }
            });
            this.getView().addDependent(oDialog);
            oDialog.open();
        },

        // ── Nom Table Source Row Coloring ────────────────────────────────────────

        onANTRowsUpdated: function (oEvent) {
            const oTable = oEvent.getSource();
            const ALL_CLASSES = ["antRowSystem", "antRowManual", "antRowPortal", "antRowNoRank"];
            oTable.getRows().forEach(oRow => {
                const oDom = oRow.getDomRef();
                if (!oDom) return;
                ALL_CLASSES.forEach(c => oDom.classList.remove(c));
                const oCtx = oRow.getBindingContext();
                if (!oCtx) return;
                // Missing rank takes priority — row is blocked from allocation
                const nRank = oCtx.getProperty("Rank");
                if (nRank == null) {
                    oDom.classList.add("antRowNoRank");
                    return;
                }
                const sSource = (oCtx.getProperty("Source") || "").toUpperCase();
                switch (sSource) {
                    case "SYSTEM":   oDom.classList.add("antRowSystem"); break;
                    case "MANUAL":   oDom.classList.add("antRowManual"); break;
                    case "CUSTOMER": // intentional fall-through
                    case "PORTAL":   oDom.classList.add("antRowPortal"); break;
                }
            });
        },

        // ── Ticketing Table Row Selection ────────────────────────────────────────
        // Maintains _selectedKeys so row data is captured at click time.
        // Virtual scroll unloads rows outside the threshold window — capturing at
        // click time ensures getContextByIndex is always valid when it's called.

        onTicketTableRowSelectionChange: function (oEvent) {
            const oTable = oEvent.getSource();
            const aChanged = oEvent.getParameter("rowIndices") || [];

            aChanged.forEach(idx => {
                const ctx = oTable.getContextByIndex(idx);
                if (!ctx) return;
                const d = ctx.getObject();
                if (!d) return;
                const sKey = `${d.NominationKey}__${d.NominationItem}`;
                if (oTable.isIndexSelected(idx)) {
                    this._selectedKeys.set(sKey, d);
                } else {
                    this._selectedKeys.delete(sKey);
                }
            });

            const n = this._selectedKeys.size;
            this.getView().getModel("allocationModel")
                .setProperty("/SelectedCount", n > 0 ? String(n) : "");

            // Recompute the DP/RDP DNQ + Metered Reading summary strip against the combined
            // filter-token / GDA-selection / row-selection location set. Calls _refreshAggregates
            // directly (not _applyLocalFilters) — _bindNomTable clears row selection on every
            // call, which would immediately wipe the very selection this handler just captured.
            this._refreshAggregates(this._getEffectiveLocations(), this._gdaSelectedRows);
        },
    };
});
