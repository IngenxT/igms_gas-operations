sap.ui.define([
    "sap/m/MessageBox",
    "sap/m/Dialog",
    "sap/m/Button",
    "sap/m/List",
    "sap/m/StandardListItem",
    "sap/m/VBox",
    "sap/m/Text",
    "sap/base/Log",
    "com/ingenx/igmsgasflow/utils/ticketPurposeGate"
], function (MessageBox, Dialog, Button, List, StandardListItem, VBox, Text, Log, TicketPurposeGate) {
    "use strict";

    const _r3 = v => Math.round(Number(v || 0) * 1000) / 1000;
    const _sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

    return {

        /**
         * Main Ticketing handler invoked on button press
         */
        onPressTicket: async function () {
            const aGasDays = this._currentGasDays.slice();

            if (!aGasDays.length) {
                MessageBox.error("Please select a Gas Day and press Go before initiating Ticketing.");
                return;
            }
            const bRange = aGasDays.length > 1;
            const oBundle = this.getView().getModel("i18n").getResourceBundle();

            // 0. Nominations deleted/added in S/4 since Scheduled Items were loaded — the
            // saved allocation was split across the old list, so that day must not be
            // ticketed: reload and ask the user to re-run Allocation for it. In a range,
            // the other days still go ahead (the changed day shows as a pre-check issue).
            this._showBusy("Checking for nomination changes...");
            const aNomChanges = [];
            for (const sGasDay of aGasDays) {
                (await this._checkNominationChanges(sGasDay))
                    .forEach(c => aNomChanges.push(Object.assign({ GasDay: sGasDay }, c)));
            }
            this._hideBusy();
            const oChangedDays = new Set(aNomChanges.map(c => c.GasDay));
            if (aNomChanges.length > 0) {
                const fmt = c => `• ${bRange ? this.formatDate(c.GasDay) + "  " : ""}${c.NominationKey}/${c.NominationItem}  (Contract ${c.ContractNo}, ${c.Location})`;
                const aDeleted = aNomChanges.filter(c => c.ChangeType === "DELETED");
                const aAdded = aNomChanges.filter(c => c.ChangeType === "ADDED");
                let sMsg = "Nominations have changed since Scheduled Items were loaded:\n";
                if (aDeleted.length) sMsg += `\nDeleted (${aDeleted.length}):\n` + aDeleted.map(fmt).join("\n") + "\n";
                if (aAdded.length) sMsg += `\nAdded (${aAdded.length}):\n` + aAdded.map(fmt).join("\n") + "\n";
                if (oChangedDays.size === aGasDays.length) {
                    sMsg += "\nScheduled Items have been refreshed. Please run Allocation again, then press Ticketing.";
                    MessageBox.warning(sMsg, { title: "Nominations Changed — Run Allocation Again" });
                    await this._loadGasDays(aGasDays);
                    return;
                }
                sMsg += "\n" + oBundle.getText("antTicketingChangedDaysSkipped");
                await new Promise(resolve => MessageBox.warning(sMsg, {
                    title: "Nominations Changed — Run Allocation Again",
                    onClose: resolve
                }));
            }

            // 1. Identify Scope: Check if user explicitly selected rows in the GDA Segment Table
            // (across the whole range — with rows selected on other days only, a day has
            // nothing in scope)
            const oAllDaysSegmentFilter = this._buildSegmentFilterPayload();
            const bHasExplicitSegmentSelection = (
                (oAllDaysSegmentFilter.OWN && oAllDaysSegmentFilter.OWN.length > 0) ||
                (oAllDaysSegmentFilter.HYBRID && oAllDaysSegmentFilter.HYBRID.length > 0) ||
                (oAllDaysSegmentFilter.THIRDPARTY && oAllDaysSegmentFilter.THIRDPARTY.length > 0) ||
                (oAllDaysSegmentFilter.ENTRYPOINT && oAllDaysSegmentFilter.ENTRYPOINT.length > 0)
            );

            // 2. Client-side pre-checks with live Busy Dialog text updates — once per Gas Day
            this._showBusy(oBundle.getText("antPreCheckBusy"));
            await _sleep(150);

            const aAllNoms = await this._requestTableNominationItems();
            const aDayRuns = [];
            const aIssues = [];
            for (const sGasDay of aGasDays) {
                if (oChangedDays.has(sGasDay)) {
                    aIssues.push({
                        GasDay: sGasDay, Location: "-", Category: oBundle.getText("antTicketingChangedCategory"),
                        Reason: oBundle.getText("antTicketingChangedReason")
                    });
                    continue;
                }
                const aDayNoms = aAllNoms.filter(r => r.Gasday === sGasDay);
                // In a range, a day without any nomination simply has nothing to do
                if (!aDayNoms.length && bRange) continue;
                const oPreflight = await this._runClientSidePreflightChecks({
                    gasDay: sGasDay,
                    noms: aDayNoms,
                    hasExplicitSegmentSelection: bHasExplicitSegmentSelection,
                    explicitSegmentFilter: this._buildSegmentFilterPayload(sGasDay)
                });
                oPreflight.issues.forEach(i => aIssues.push(Object.assign({ GasDay: sGasDay }, i)));
                aDayRuns.push({ sGasDay, oPayload: oPreflight.scopedPayload });
            }

            this._hideBusy();

            const nEligibleCount = aDayRuns.reduce((n, d) => n + this._countEligibleTargets(d.oPayload), 0);

            // 3. Pre-Check gate — Proceed continues with the eligible locations only
            if (aIssues.length > 0) {
                const bProceed = await this._openPreCheckDialog({
                    sActionKey: "antActionTicketing",
                    aIssues: aIssues,
                    nEligible: nEligibleCount,
                    bShowGasDay: bRange
                });
                if (!bProceed) {
                    if (oChangedDays.size) await this._loadGasDays(aGasDays, true);
                    return;
                }
            }

            // 4. Case: Nothing selected / empty table
            if (nEligibleCount === 0) {
                MessageBox.information(oBundle.getText("antPreCheckNothingEligible", [oBundle.getText("antActionTicketing")]));
                if (oChangedDays.size) await this._loadGasDays(aGasDays, true);
                return;
            }

            // 5. 100% Clean: Proceed to backend
            const aToRun = aDayRuns.filter(d => this._countEligibleTargets(d.oPayload) > 0);
            if (bRange) {
                await this._submitRangeTicketing(aToRun);
                if (oChangedDays.size) await this._loadGasDays(aGasDays, true);
            } else {
                this._submitFilteredTicketing(aToRun[0].sGasDay, aToRun[0].oPayload);
            }
        },

        /**
         * Gas Day range: submits processTicketing once per day, in date order. Each day is
         * its own background job; a day that fails to submit is recorded and the rest
         * continue. The results page then follows every submitted job together.
         */
        _submitRangeTicketing: async function (aToRun) {
            const oBundle = this.getView().getModel("i18n").getResourceBundle();
            const aJobIds = [];
            const aLines = [];
            for (let i = 0; i < aToRun.length; i++) {
                const { sGasDay, oPayload } = aToRun[i];
                const sDay = this.formatDate(sGasDay);
                this._showBusy(oBundle.getText("antTicketingGasDay", [sDay, i + 1, aToRun.length]));
                try {
                    const oResponse = await this._callProcessTicketing(sGasDay, oPayload);
                    if (oResponse?.JobId && oResponse.Status === "SUBMITTED") {
                        aJobIds.push(oResponse.JobId);
                        aLines.push("✔ " + sDay + ": " + oBundle.getText("antRangeTicketSubmitted"));
                    } else {
                        aLines.push("✖ " + sDay + ": " + oBundle.getText("antRangeNothingSubmitted"));
                    }
                } catch (err) {
                    aLines.push("✖ " + sDay + ": " + (err?.error?.message || err?.message || "Failed to trigger Ticketing."));
                }
            }
            this._hideBusy();

            const sText = aLines.join("\n");
            if (!aJobIds.length) {
                MessageBox.warning(sText, {
                    title: oBundle.getText("antActionTicketing"),
                    onClose: () => this.onRefreshNomItems(true)
                });
                return;
            }
            const sViewLogs = oBundle.getText("antViewTicketLogs");
            MessageBox.information(oBundle.getText("antRangeTicketingStarted") + "\n\n" + sText, {
                title: oBundle.getText("antTicketingStartedTitle"),
                actions: [sViewLogs, oBundle.getText("antDismiss")],
                emphasizedAction: sViewLogs,
                onClose: sAction => {
                    if (sAction === sViewLogs) {
                        this.getOwnerComponent().getRouter().navTo("RouteTicketingRunLogs", { jobId: aJobIds.join(",") });
                    }
                }
            });
        },

        /** processTicketing for one Gas Day; resolves with { JobId, Status, ... }. */
        _callProcessTicketing: async function (sGasDay, oScopedPayload) {
            const oOperation = this.getView().getModel().bindContext("/processTicketing(...)");
            oOperation.setParameter("Gasday", sGasDay);
            oOperation.setParameter("SelectionFilter", oScopedPayload.SelectionFilter);
            oOperation.setParameter("SegmentFilter", oScopedPayload.SegmentFilter);
            await oOperation.execute();
            return oOperation.getBoundContext().getObject();
        },

        /**
         * Live-vs-loaded nomination list diff (checkNominationChanges). Non-fatal —
         * returns [] if the check itself fails, same as _checkGdaReadingChanges.
         */
        _checkNominationChanges: async function (sGasDay) {
            try {
                const oCtx = this.getView().getModel().bindContext("/checkNominationChanges(...)");
                oCtx.setParameter("Gasday", sGasDay);
                await oCtx.execute();
                const oResult = oCtx.getBoundContext().getObject();
                return oResult?.value ?? oResult ?? [];
            } catch (oErr) {
                Log.warning("checkNominationChanges failed", oErr);
                return [];
            }
        },

        /**
         * Safely extracts all nomination item data from IdANTTicketItemTbl
         */
        _getTableNominationItems: function () {
            const oTable = this.byId("IdANTTicketItemTbl");
            if (!oTable) return [];
            const oBinding = oTable.getBinding("rows");
            if (!oBinding) return [];
            if (oBinding.getModel() instanceof sap.ui.model.json.JSONModel) {
                const aData = oBinding.getModel().getProperty(oBinding.getPath());
                if (Array.isArray(aData)) return aData;
            }
            const aContexts = oBinding.getContexts(0, oBinding.getLength() || 5000);
            return aContexts.map(ctx => ctx.getObject()).filter(Boolean);
        },

        /**
         * Every row of IdANTTicketItemTbl's current binding, including rows the table has
         * not scrolled to yet — getContexts() only returns what is already loaded (the
         * table pages in by 150), which a multi-day range easily exceeds.
         */
        _requestTableNominationItems: async function () {
            const oBinding = this.byId("IdANTTicketItemTbl")?.getBinding("rows");
            if (!oBinding || typeof oBinding.requestContexts !== "function") return this._getTableNominationItems();
            const aContexts = await oBinding.requestContexts(0, Infinity);
            return aContexts.map(ctx => ctx.getObject()).filter(Boolean);
        },

        /**
         * Client-side Pre-Checks for Ticketing
         * Accurately detects HYBRID shift from hybridModel rows and Role column.
         * Runs for ONE Gas Day (opts.gasDay): opts.noms and the SCADA rows are that day's only.
         */
        _runClientSidePreflightChecks: async function (opts) {
            const oView = this.getView();
            const aAllNoms = opts.noms;
            const aAriRules = oView.getModel("ari006Model")?.getProperty("/rules") || [];

            const _dayRows = sModel => (oView.getModel(sModel)?.getProperty("/") || [])
                .filter(r => r._gasDay === opts.gasDay);
            const aOwnRows = _dayRows("ownModel");
            const aHybridRows = _dayRows("hybridModel");
            const aTpRows = _dayRows("tpModel");
            const aEpRows = _dayRows("epModel");

            const issues = [];
            const blockedLocationsSet = new Set();
            const blockedTpPairsSet = new Set();

            const emptyPayload = {
                SelectionFilter: { TransportSystem: [], DeliveryPoints: [], RedeliveryPoints: [] },
                SegmentFilter: { OWN: [], HYBRID: [], THIRDPARTY: [], ENTRYPOINT: [], Excluded: [] }
            };

            if (!aAllNoms || aAllNoms.length === 0) {
                return {
                    issues: [{ Location: "-", Category: "No Data", Reason: "No nomination items found in the table. Press Go first." }],
                    scopedPayload: emptyPayload
                };
            }

            // Helper to extract clean location string from any row
            const _getLoc = r => r?.BusinessLocation || r?.YybusLocation || r?.Location || "";

            // Helper to clean numeric strings with commas (e.g. "4,20,000.000" -> 420000)
            const _num = v => {
                if (typeof v === "number") return v;
                if (!v) return 0;
                return parseFloat(String(v).replace(/,/g, "").trim()) || 0;
            };

            // ── STEP 1: RESOLVE SCOPE (Segment Selection vs General Selection) ──
            const targetOwnLocs = new Set();
            const targetHybridLocs = new Set();
            const targetTpPairs = new Set();
            const targetEpLocs = new Set();

            if (opts.hasExplicitSegmentSelection) {
                (opts.explicitSegmentFilter.OWN || []).forEach(x => targetOwnLocs.add(x.Location));
                (opts.explicitSegmentFilter.HYBRID || []).forEach(x => targetHybridLocs.add(x.Location));
                (opts.explicitSegmentFilter.THIRDPARTY || []).forEach(x => targetTpPairs.add(`${x.Customer}__${x.Location}`));
                (opts.explicitSegmentFilter.ENTRYPOINT || []).forEach(x => targetEpLocs.add(x.Location));
            } else {
                for (const row of aAllNoms) {
                    const loc = _getLoc(row);
                    if (!loc || row.LocationType !== "REDELIVERY") continue;

                    const kind = row.CustomerKind || "OWN";
                    if (kind === "THIRD-PARTY") {
                        if (row.Partner) targetTpPairs.add(`${row.Partner}__${loc}`);
                    } else if (kind === "HYBRID") {
                        targetHybridLocs.add(loc);
                    } else {
                        targetOwnLocs.add(loc);
                    }
                }
            }

            // ── STEP 2: RANK INTEGRITY & ARI006 RULES ──────────────────────────
            for (const row of aAllNoms) {
                const loc = _getLoc(row);
                if (!loc) continue;

                const isTp = row.CustomerKind === "THIRD-PARTY";
                const tpKey = `${row.Partner}__${loc}`;

                let inScope = false;
                if (row.LocationType === "DELIVERY") {
                    inScope = targetEpLocs.has(loc);
                } else if (row.LocationType === "REDELIVERY") {
                    inScope = (row.CustomerKind === "HYBRID" && targetHybridLocs.has(loc)) ||
                              (isTp && targetTpPairs.has(tpKey)) ||
                              (!isTp && row.CustomerKind !== "HYBRID" && targetOwnLocs.has(loc));
                }

                if (!inScope) continue;

                // Ticket Purpose/Status gate — per line item: this item is skipped silently,
                // the rest of its location is still ticketed
                if (TicketPurposeGate.isTicketingBlocked(row)) {
                    continue;
                }

                // THIRD-PARTY Redelivery checks are Location+Customer: a block on one
                // partner never blocks another partner at the same connection point
                const bTpPairGrain = isTp && row.LocationType === "REDELIVERY";
                const sIssuePartner = bTpPairGrain ? row.Partner : "";

                const r = row.Rank;
                if (r == null || r === "" || isNaN(Number(r)) || Number(r) <= 0) {
                    if (bTpPairGrain) blockedTpPairsSet.add(tpKey);
                    else blockedLocationsSet.add(loc);

                    if (!issues.some(i => i.Location === loc && (i.Partner || "") === sIssuePartner && i.Category === "Missing / 0 Rank")) {
                        issues.push({
                            Location: loc,
                            Partner: sIssuePartner,
                            Category: "Missing / 0 Rank",
                            Reason: `Contract ${row.Contract || ""} (${row.NominationKey}/${row.NominationItem}) has missing or 0 rank.`
                        });
                    }
                }

                if (bTpPairGrain ? !blockedTpPairsSet.has(tpKey) : !blockedLocationsSet.has(loc)) {
                    for (const rule of aAriRules) {
                        if (rule.businessLocation && rule.businessLocation === loc) {
                            if (bTpPairGrain) blockedTpPairsSet.add(tpKey);
                            else blockedLocationsSet.add(loc);
                            issues.push({
                                Location: loc,
                                Partner: sIssuePartner,
                                Category: "Business Rule (ARI006)",
                                Reason: rule.message || "Ticketing blocked by Business Rule."
                            });
                        }
                    }
                }
            }

            // ── STEP 3: DETECT SHIFT & BUILD METER MAPS ─────────────────────────
            this._showBusy(this.getView().getModel("i18n").getResourceBundle().getText("antPreCheckBusyMeters"));
            await _sleep(150);

            // 1. Detect locations that shifted to HYBRID
            const shiftedHybridLocsSet = new Set();
            for (const r of aHybridRows) {
                const loc = _getLoc(r);
                const role = String(r.Role || r.Yy_Indicator || "").toUpperCase();
                if (loc && (role === "HYBRID" || role === "PRIMARY" || r._type === "GROUP")) {
                    shiftedHybridLocsSet.add(loc);
                }
            }

            // 2. Extract Hybrid Physical Meter Readings
            const hybridGrossMeterMap = new Map();
            for (const r of aHybridRows) {
                const loc = _getLoc(r);
                if (!loc || !shiftedHybridLocsSet.has(loc)) continue;

                const meterVal = _num(r.MeterReading || r.MeterReadingSM3 || r._scadaMeter || r.YycumVolCm || r.totalMR);
                const gcv = _num(r.AvgWtGCV || r.AVG_WT_GCV || r.YyavgGcvCm || r.YygcvNgail || r.gcv || 9500);
                const ncv = _num(r.AvgWtNCV || r.AVG_WT_NCV || r.YyavgNcvCm || r.YyncvNgail || r.ncv || 8500);

                if (meterVal > 0 && gcv > 0 && ncv > 0) {
                    if (r._type === "GROUP") {
                        hybridGrossMeterMap.set(loc, meterVal);
                    } else if (!hybridGrossMeterMap.has(loc) || meterVal > hybridGrossMeterMap.get(loc)) {
                        hybridGrossMeterMap.set(loc, meterVal);
                    }
                }
            }

            // 3. Own Gross Physical Meters (only for locations that did NOT shift to HYBRID)
            const ownGrossMeterMap = new Map();
            for (const r of aOwnRows) {
                const loc = _getLoc(r);
                if (!loc || shiftedHybridLocsSet.has(loc)) continue;

                const meter = _num(r.YycumVolCm || r.MeterReading || r._scadaMeter);
                const gcv = _num(r.YyavgGcvCm || r.AvgWtGCV || r.AVG_WT_GCV || r.gcv);
                const ncv = _num(r.YyavgNcvCm || r.AvgWtNCV || r.AVG_WT_NCV || r.ncv);
                if (meter > 0 && gcv > 0 && ncv > 0) {
                    ownGrossMeterMap.set(loc, meter);
                }
            }

            // 4. Entry Point CM Meters
            const epMeterMap = new Map();
            if (targetEpLocs.size > 0) {
                for (const r of aEpRows) {
                    const loc = _getLoc(r);
                    const scada = _num(r._scadaMeter || r.MeterReading || r.YdpalcqtyEp);
                    const gcv = _num(r.YyavgGcvCm || r.AvgWtGCV || r.gcv);
                    const ncv = _num(r.YyavgNcvCm || r.AvgWtNCV || r.ncv);
                    if (loc && scada > 0 && gcv > 0 && ncv > 0) epMeterMap.set(loc, scada);
                }
            }

            // 5. Third-Party Dedicated Meters
            const tpMeterMap = new Map();
            for (const r of aTpRows) {
                const loc = _getLoc(r);
                const cust = r.Yycustomer || r.Customer || r.Partner;
                const pairKey = `${cust}__${loc}`;
                const qty = _num(r.YyallocQtyNongailscm || r.MeterReading || r.CustomerQty);
                const gcv = _num(r.YygcvNgail || r.AvgWtGCV || r.gcv);
                const ncv = _num(r.YyncvNgail || r.AvgWtNCV || r.ncv);
                if (loc && cust && qty > 0 && gcv > 0 && ncv > 0) tpMeterMap.set(pairKey, qty);
            }

            // ── STEP 4: BALANCE INVARIANTS & PRE-FLIGHT VERIFICATION ────────────
            this._showBusy(this.getView().getModel("i18n").getResourceBundle().getText("antPreCheckBusyBalance"));
            await _sleep(150);

            const eligibleOwnLocs = [];
            const eligibleHybridLocs = [];
            const eligibleEpLocs = [];
            const eligibleTpPairs = [];

            // 1. ENTRY POINT VALIDATION (Only if explicitly selected)
            if (targetEpLocs.size > 0) {
                for (const loc of targetEpLocs) {
                    if (blockedLocationsSet.has(loc)) continue;

                    const locItems = aAllNoms.filter(r => _getLoc(r) === loc && r.LocationType === "DELIVERY");
                    const hasMeter = epMeterMap.has(loc);

                    if (!hasMeter) {
                        blockedLocationsSet.add(loc);
                        issues.push({
                            Location: loc,
                            Category: "Meter / Quality Missing",
                            Reason: locItems.length > 0
                                ? "Entry Point CM Meter Reading or GCV/NCV is missing."
                                : "Meter reading uploaded, but no nomination found for the location."
                        });
                        continue;
                    }

                    if (locItems.length === 0) {
                        blockedLocationsSet.add(loc);
                        issues.push({
                            Location: loc,
                            Category: "Missing Nomination",
                            Reason: "Meter reading uploaded, but no nomination found for the location."
                        });
                        continue;
                    }

                    const targetMR = epMeterMap.get(loc);
                    const sumAlloc = locItems.reduce((acc, r) => acc + (_num(r.AllocatedQty) + _num(r.OverDrawlGSA)), 0);
                    const balancedSum = _r3(sumAlloc);
                    const formattedMR = _r3(targetMR);

                    if (Math.abs(formattedMR - balancedSum) > 0.005) {
                        blockedLocationsSet.add(loc);
                        issues.push({
                            Location: loc,
                            Category: balancedSum === 0 ? "Not Allocated" : "Balance Mismatch",
                            Reason: balancedSum === 0
                                ? `Meter (${formattedMR}) != Total Allocated (0). Nominations exist but not allocated.`
                                : `Meter reading (${formattedMR}) != Total Allocated (${balancedSum}).`
                        });
                    } else {
                        eligibleEpLocs.push(loc);
                    }
                }
            }

            // 2. UNIFIED OWN & HYBRID PHYSICAL METER VALIDATION
            const redeliveryLocsToEvaluate = new Set([...targetOwnLocs, ...targetHybridLocs]);

            for (const loc of redeliveryLocsToEvaluate) {
                if (blockedLocationsSet.has(loc)) continue;

                const isShiftedToHybrid = shiftedHybridLocsSet.has(loc);

                let targetMR = isShiftedToHybrid
                    ? (hybridGrossMeterMap.get(loc) || 0)
                    : (ownGrossMeterMap.get(loc) || 0);

                if (targetMR <= 0) {
                    if (isShiftedToHybrid) {
                        const hRow = aHybridRows.find(r => _getLoc(r) === loc && _num(r.MeterReading || r._scadaMeter || r.YycumVolCm) > 0);
                        targetMR = _num(hRow?.MeterReading || hRow?._scadaMeter || hRow?.YycumVolCm);
                    } else {
                        const oRow = aOwnRows.find(r => _getLoc(r) === loc && _num(r.YycumVolCm || r.MeterReading) > 0);
                        targetMR = _num(oRow?.YycumVolCm || oRow?.MeterReading);
                    }
                }

                const hasMeter = targetMR > 0;

                const seenNomItemKeys = new Set();
                const locItems = [];

                for (const r of aAllNoms) {
                    if (
                        _getLoc(r) === loc &&
                        r.LocationType === "REDELIVERY" &&
                        r.CustomerKind !== "THIRD-PARTY"
                    ) {
                        const itemKey = `${r.NominationKey}__${r.NominationItem}`;
                        if (!seenNomItemKeys.has(itemKey)) {
                            seenNomItemKeys.add(itemKey);
                            locItems.push(r);
                        }
                    }
                }

                if (!hasMeter) {
                    blockedLocationsSet.add(loc);
                    issues.push({
                        Location: loc,
                        Category: "Meter / Quality Missing",
                        Reason: locItems.length > 0
                            ? (isShiftedToHybrid ? "HYBRID physical meter or GCV/NCV missing." : "OWN physical meter or GCV/NCV missing.")
                            : "Meter reading uploaded, but no nomination found for the location."
                    });
                    continue;
                }

                if (locItems.length === 0) {
                    blockedLocationsSet.add(loc);
                    issues.push({
                        Location: loc,
                        Category: "Missing Nomination",
                        Reason: "Meter reading uploaded, but no nomination found for the location."
                    });
                    continue;
                }

                const sumAlloc = locItems.reduce((acc, r) =>
                    acc + (_num(r.AllocatedQty) + _num(r.OverDrawlGSA)), 0
                );

                const balancedSum = _r3(sumAlloc);
                const formattedMR = _r3(targetMR);

                if (Math.abs(formattedMR - balancedSum) > 0.005) {
                    blockedLocationsSet.add(loc);
                    issues.push({
                        Location: loc,
                        Category: balancedSum === 0 ? "Not Allocated" : "Balance Mismatch",
                        Reason: balancedSum === 0
                            ? `Location Meter (${formattedMR}) != Total Allocated (0). Nominations exist but not allocated.`
                            : `Location Meter (${formattedMR}) != Total Allocated (${balancedSum}).`
                    });
                } else {
                    if (isShiftedToHybrid) {
                        eligibleHybridLocs.push(loc);
                    } else {
                        eligibleOwnLocs.push(loc);
                    }
                }
            }

            // 3. THIRD-PARTY VALIDATION (Checks Missing Uploads AND Missing Nominations)
            const allTpPairsToEvaluate = new Set([...targetTpPairs]);

            tpMeterMap.forEach(function (val, pairKey) {
                if (opts.hasExplicitSegmentSelection) {
                    const aParts = pairKey.split("__");
                    const sCust = aParts[0];
                    const sLoc = aParts[1];
                    const bSelected = (opts.explicitSegmentFilter.THIRDPARTY || []).some(function (x) {
                        return x.Location === sLoc && (!x.Customer || x.Customer === sCust);
                    });
                    if (bSelected) {
                        allTpPairsToEvaluate.add(pairKey);
                    }
                } else {
                    allTpPairsToEvaluate.add(pairKey);
                }
            });

            for (const pairKey of allTpPairsToEvaluate) {
                if (blockedTpPairsSet.has(pairKey)) continue;
                const [cust, loc] = pairKey.split("__");

                const pairItems = aAllNoms.filter(r =>
                    _getLoc(r) === loc &&
                    (r.Partner === cust || r.Customer === cust) &&
                    r.LocationType === "REDELIVERY" &&
                    r.CustomerKind === "THIRD-PARTY"
                );

                const hasUpload = tpMeterMap.has(pairKey);

                // Case A: Nom exists, but customer upload is missing
                if (!hasUpload && pairItems.length > 0) {
                    blockedTpPairsSet.add(pairKey);
                    issues.push({
                        Location: loc,
                        Partner: cust,
                        Category: "Meter / Quality Missing",
                        Reason: "Customer allocation quantity not uploaded for Partner & Location."
                    });
                    continue;
                }

                // Case B: Customer Qty uploaded, but no nomination found
                if (hasUpload && pairItems.length === 0) {
                    blockedTpPairsSet.add(pairKey);
                    issues.push({
                        Location: loc,
                        Partner: cust,
                        Category: "Missing Nomination",
                        Reason: "Customer Qty uploaded but no Nomination found for the Partner at the Business Location."
                    });
                    continue;
                }

                // Case C: Both present — verify energy balance
                const targetQty = tpMeterMap.get(pairKey);
                const sumAlloc = pairItems.reduce((acc, r) => acc + (_num(r.AllocatedQty) + _num(r.OverDrawlGSA)), 0);
                const balancedSum = _r3(sumAlloc);
                const formattedTargetQty = _r3(targetQty);

                if (Math.abs(formattedTargetQty - balancedSum) > 0.005) {
                    blockedTpPairsSet.add(pairKey);
                    issues.push({
                        Location: loc,
                        Partner: cust,
                        Category: balancedSum === 0 ? "Not Allocated" : "Balance Mismatch",
                        Reason: balancedSum === 0
                            ? `Partner allocation (${formattedTargetQty}) != Total Allocated (0). Nominations exist but not allocated.`
                            : `Partner allocation (${formattedTargetQty}) != Total Allocated (${balancedSum}).`
                    });
                } else {
                    eligibleTpPairs.push({ Location: loc, Customer: cust, Role: "" });
                }
            }

            // ── STEP 5: SCOPED PAYLOAD (Only cleared items sent in SegmentFilter) ─
            const scopedPayload = {
                SelectionFilter: {
                    TransportSystem: [],
                    DeliveryPoints: [],
                    RedeliveryPoints: []
                },
                SegmentFilter: {
                    OWN: eligibleOwnLocs.map(l => ({ Location: l, Customer: "", Role: "" })),
                    HYBRID: eligibleHybridLocs.map(l => ({ Location: l, Customer: "", Role: "" })),
                    THIRDPARTY: eligibleTpPairs.map(p => ({ Location: p.Location, Customer: p.Customer, Role: "" })),
                    ENTRYPOINT: eligibleEpLocs.map(l => ({ Location: l, Customer: "", Role: "" })),
                    Excluded: []
                }
            };

            return { issues, scopedPayload };
        },

        /**
         * Dispatches the filtered payload to the backend processTicketing action
         */
        _submitFilteredTicketing: async function (sGasDay, oScopedPayload) {
            const oBundle = this.getView().getModel("i18n").getResourceBundle();
            this._showBusy(oBundle.getText("antTicketingSubmitting"));

            try {
                const oResponse = await this._callProcessTicketing(sGasDay, oScopedPayload);
                this._hideBusy();

                // Navigate only on request — the results page waits for S/4 itself and
                // shows only this run's items
                if (oResponse.JobId && oResponse.Status === "SUBMITTED") {
                    const sViewLogs = oBundle.getText("antViewTicketLogs");
                    MessageBox.information(oBundle.getText("antTicketingStarted", [this.formatDate(sGasDay)]), {
                        title: oBundle.getText("antTicketingStartedTitle"),
                        actions: [sViewLogs, oBundle.getText("antDismiss")],
                        emphasizedAction: sViewLogs,
                        onClose: sAction => {
                            if (sAction === sViewLogs) {
                                this.getOwnerComponent().getRouter().navTo("RouteTicketingRunLogs", { jobId: oResponse.JobId });
                            }
                        }
                    });
                    return;
                }

                // Backend checks (nomination/GCV-NCV drift, balance) excluded every location
                MessageBox.warning(oBundle.getText("antTicketingNothingSubmitted"), {
                    title: oBundle.getText("antActionTicketing"),
                    onClose: () => this.onRefreshNomItems()
                });
            } catch (err) {
                this._hideBusy();
                MessageBox.error(err?.error?.message || err?.message || "Failed to trigger Ticketing.");
            }
        },



        /**
         * Shared Pre-Check dialog for Allocate & Save and Ticketing. Resolves true only
         * when the user chooses Proceed; Cancel, Close and Escape all resolve false.
         */
        _openPreCheckDialog: function ({ sActionKey, aIssues, nEligible, bShowGasDay }) {
            const oBundle = this.getView().getModel("i18n").getResourceBundle();
            const sAction = oBundle.getText(sActionKey);
            const bCanProceed = nEligible > 0;
            const sState = bCanProceed ? "Warning" : "Error";
            const nFailed = new Set(aIssues.map(i => `${i.GasDay || ""}|${i.Location}|${i.Partner || ""}`)).size;

            return new Promise(resolve => {
                let bProceed = false;

                const oList = new List({
                    items: aIssues.map(issue => new StandardListItem({
                        title: (bShowGasDay && issue.GasDay ? this.formatDate(issue.GasDay) + " · " : "") + (issue.Partner
                            ? oBundle.getText("antPreCheckItemTitlePartner", [issue.Location, issue.Partner])
                            : oBundle.getText("antPreCheckItemTitle", [issue.Location])),
                        description: issue.Reason,
                        info: issue.Category,
                        infoState: sState,
                        icon: bCanProceed ? "sap-icon://alert" : "sap-icon://error"
                    }))
                });

                const aButtons = [];
                if (bCanProceed) {
                    aButtons.push(new Button({
                        text: oBundle.getText("antPreCheckProceed"),
                        type: "Emphasized",
                        press: () => { bProceed = true; oDialog.close(); }
                    }));
                }
                aButtons.push(new Button({
                    text: oBundle.getText(bCanProceed ? "antPreCheckCancel" : "antPreCheckClose"),
                    press: () => oDialog.close()
                }));

                const oDialog = new Dialog({
                    title: oBundle.getText(bCanProceed ? "antPreCheckTitle" : "antPreCheckFailedTitle", [sAction]),
                    state: sState,
                    contentWidth: "40rem",
                    draggable: true,
                    resizable: true,
                    content: new VBox({
                        items: [
                            new Text({
                                text: bCanProceed
                                    ? oBundle.getText("antPreCheckPartial", [nFailed, nEligible, sAction])
                                    : oBundle.getText("antPreCheckNone", [sAction])
                            }).addStyleClass("sapUiSmallMargin"),
                            oList
                        ]
                    }),
                    buttons: aButtons,
                    afterClose: () => {
                        oDialog.destroy();
                        resolve(bProceed);
                    }
                });

                this.getView().addDependent(oDialog);
                oDialog.open();
            });
        },

        /** Count of locations/pairs the pre-checks cleared, across all four segments. */
        _countEligibleTargets: function (oScopedPayload) {
            const sf = oScopedPayload?.SegmentFilter || {};
            return (sf.OWN?.length || 0) + (sf.HYBRID?.length || 0) +
                   (sf.THIRDPARTY?.length || 0) + (sf.ENTRYPOINT?.length || 0);
        },


        _buildSegmentFilterPayload: function (sGasDay) {
            const sTab = this.byId("IdANTGDASegBtn")?.getSelectedKey() || "OWN";
            const aRows = (this._gdaSelectedRows || []).filter(r => !sGasDay || r._gasDay === sGasDay);
            const oPayload = { OWN: [], HYBRID: [], THIRDPARTY: [], ENTRYPOINT: [], Excluded: [] };

            aRows.forEach(r => {
                const loc = r.YybusLocation || r.Location || "";
                const cust = r.Yycustomer || "";
                const role = r._type || "";
                if (sTab === "OWN" && loc) oPayload.OWN.push({ Location: loc, Customer: "", Role: "" });
                else if (sTab === "HYBRID" && loc) oPayload.HYBRID.push({ Location: loc, Customer: cust, Role: role });
                else if (sTab === "THIRDPARTY" && loc) oPayload.THIRDPARTY.push({ Location: loc, Customer: cust, Role: "" });
                else if (sTab === "ENTRYPOINT" && loc) oPayload.ENTRYPOINT.push({ Location: loc, Customer: "", Role: "" });
            });
            return oPayload;
        }
    };
});