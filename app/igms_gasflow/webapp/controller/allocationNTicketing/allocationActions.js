sap.ui.define([
    "sap/m/MessageBox",
    "sap/m/MessageToast",
    "sap/base/Log",
    "com/ingenx/igmsgasflow/utils/ticketPurposeGate"
], function (MessageBox, MessageToast, Log, TicketPurposeGate) {
    "use strict";

    function _sleep(ms) {
        return new Promise(function (resolve) {
            setTimeout(resolve, ms);
        });
    }

    return {
        /**
         * Main UI Handler for "Allocate & Save"
         */
        onPressAllocateNSave: async function () {
            if (this._bProcessing) {
                return;
            }

            // 1. Precondition checks (GasDay, Filters loaded)
            if (!this._validateAllocationPreconditions()) {
                return;
            }

            const oBundle = this.getView().getModel("i18n").getResourceBundle();
            this._bProcessing = true;
            this._showBusy(oBundle.getText("antPreCheckBusy"));

            try {
                // 2. Run client-side pre-checks with segment filtering — once per Gas Day,
                // since meters, ranks and tickets are all per day
                const aGasDays = this._currentGasDays.slice();
                const aAllNoms = await this._requestTableNominationItems();
                const bAnySegmentSelection = this._hasEligibleTargetsInPayload({ SegmentFilter: this._buildSegmentFilter() });
                const aDayRuns = [];
                const aIssues = [];
                for (const sGasDay of aGasDays) {
                    const aDayNoms = aAllNoms.filter(r => r.Gasday === sGasDay);
                    // In a range, a day without any nomination simply has nothing to do
                    if (!aDayNoms.length && aGasDays.length > 1) continue;
                    const oPreflightResult = await this._runClientSideAllocationPreflightChecks(
                        sGasDay, aDayNoms, bAnySegmentSelection);
                    (oPreflightResult.issues || []).forEach(i => aIssues.push(Object.assign({ GasDay: sGasDay }, i)));
                    aDayRuns.push({ sGasDay, oPayload: oPreflightResult.scopedPayload });
                }

                this._hideBusy();

                // 3. Pre-Check gate — Proceed continues with the eligible locations only
                const nEligible = aDayRuns.reduce((n, d) => n + this._countEligibleTargets(d.oPayload), 0);
                if (aIssues.length > 0) {
                    const bProceed = await this._openPreCheckDialog({
                        sActionKey: "antActionAllocateSave",
                        aIssues: aIssues,
                        nEligible: nEligible,
                        bShowGasDay: aGasDays.length > 1
                    });
                    if (!bProceed) {
                        return;
                    }
                }

                // Guard: Ensure there is at least one eligible target to process
                const aToRun = aDayRuns.filter(d => this._hasEligibleTargetsInPayload(d.oPayload));
                if (!aToRun.length) {
                    MessageBox.information(oBundle.getText("antPreCheckNothingEligible", [oBundle.getText("antActionAllocateSave")]));
                    return;
                }

                // 4. Call backend action: RunAllocateSave — one Gas Day at a time; a day
                // that fails is recorded and the remaining days still run
                const aResults = [];
                for (let i = 0; i < aToRun.length; i++) {
                    const { sGasDay, oPayload } = aToRun[i];
                    this._showBusy(aToRun.length > 1
                        ? oBundle.getText("antAllocatingGasDay", [this.formatDate(sGasDay), i + 1, aToRun.length])
                        : "Allocating and persisting to S/4HANA...");
                    try {
                        aResults.push({ sGasDay, oResult: await this._callRunAllocateSave(oPayload, sGasDay) });
                    } catch (oErr) {
                        aResults.push({ sGasDay, sError: this._getAllocationErrorText(oErr) });
                    }
                }
                this._hideBusy();

                // 5. Handle action outcome
                if (aGasDays.length === 1) {
                    if (aResults[0].sError) {
                        MessageBox.error(aResults[0].sError, { title: "Allocation Error" });
                    } else {
                        this._showAllocateSaveOutcome(aResults[0].oResult);
                    }
                } else {
                    this._showRangeAllocateSaveOutcome(aResults);
                }

                // 6. Refresh grid data — also after a partial failure, since earlier chunks did save
                this._bProcessing = false;
                await this._loadGasDays(aGasDays, true);

            } catch (oErr) {
                this._hideBusy();
                this._showAllocationError(oErr);
            } finally {
                this._bProcessing = false;
                this._hideBusy();
            }
        },

        /**
         * Validates Gas Day and loaded state before running allocation.
         */
        _validateAllocationPreconditions: function () {
            const oGasDay = this.byId("IdANTFilterGasDay");
            if (!oGasDay || !oGasDay.getDateValue()) {
                if (oGasDay) {
                    oGasDay.setValueState("Error");
                    oGasDay.setValueStateText("Gas Day is required for allocation");
                    oGasDay.focus();
                }
                MessageToast.show("Please select a Gas Day before running allocation.");
                return false;
            }

            if (!this._currentGasDays.length) {
                MessageToast.show("No nomination items loaded. Please press Go first.");
                return false;
            }

            oGasDay.setValueState("None");

            if (!this._validateLocationFilterExclusivity()) {
                return false;
            }
            if (!this._validateSegmentSelectionExclusivity()) {
                return false;
            }

            return true;
        },

        /**
         * Ensures user has not simultaneously applied conflicting Delivery and Redelivery filter tokens
         */
        _validateLocationFilterExclusivity: function () {
            const oDelCtrl = this.byId("IdANTFilterDeliveryPoint");
            const oRedelCtrl = this.byId("IdANTFilterRedeliveryPoint");

            const aDelTokens = oDelCtrl ? oDelCtrl.getTokens() : [];
            const aRedelTokens = oRedelCtrl ? oRedelCtrl.getTokens() : [];

            if (aDelTokens.length > 0 && aRedelTokens.length > 0) {
                MessageBox.warning(
                    "You cannot select both Delivery Point and Redelivery Point filters simultaneously for allocation.",
                    { title: "Filter Exclusivity Conflict" }
                );
                return false;
            }
            return true;
        },

        /**
         * Ensures user has not selected rows across conflicting SCADA segment tabs
         */
        _validateSegmentSelectionExclusivity: function () {
            if (!this._gdaSelectedRows || this._gdaSelectedRows.length === 0) {
                return true;
            }

            const oSegments = new Set(this._gdaSelectedRows.map(function (r) {
                return r._gdaSegment;
            }).filter(Boolean));

            if (oSegments.has("ENTRYPOINT") && (oSegments.has("OWN") || oSegments.has("HYBRID") || oSegments.has("THIRDPARTY"))) {
                MessageBox.warning(
                    "Entry Point measurements cannot be selected simultaneously with Redelivery segments (Own, Hybrid, or Third-Party).",
                    { title: "Segment Selection Conflict" }
                );
                return false;
            }

            return true;
        },

        /**
         * Buckets the current SCADA Measurements row selection (_gdaSelectedRows) into
         * the typed SegmentFilter shape (OWN, HYBRID, THIRDPARTY, ENTRYPOINT, Excluded).
         */
        _buildSegmentFilter: function (sGasDay) {
            const oBuckets = { OWN: [], HYBRID: [], THIRDPARTY: [], ENTRYPOINT: [] };
            const aRows = (this._gdaSelectedRows || []).filter(r => !sGasDay || r._gasDay === sGasDay);

            for (let i = 0; i < aRows.length; i++) {
                const r = aRows[i];
                const sSeg = r._gdaSegment;
                if (!oBuckets[sSeg]) {
                    continue;
                }

                const sLoc = (r.YvbelnEp !== undefined) ? r.Location : (r.YybusLocation || r.BusinessLocation || r.Location);
                if (!sLoc) {
                    continue;
                }

                if (sSeg === "HYBRID") {
                    const bSecondary = (r._type === "SECONDARY" || String(r.Role || "").toUpperCase() === "HYBRID");
                    const sPartner = r.Yycustomer || r.Customer || r.Partner || "";
                    oBuckets.HYBRID.push({
                        Location: sLoc,
                        Customer: (bSecondary && sPartner) ? sPartner : "",
                        Role: bSecondary ? "HYBRID" : "PRIMARY"
                    });
                    continue;
                }

                const sCustomer = r.Yycustomer || r.Customer || r.Partner;
                const bPartner = (sSeg === "THIRDPARTY" && !!sCustomer);
                oBuckets[sSeg].push({
                    Location: sLoc,
                    Customer: bPartner ? sCustomer : "",
                    Role: ""
                });
            }

            return Object.assign({}, oBuckets, {
                Excluded: this._excludeEntriesForRun || []
            });
        },

        /**
         * Filter panel tokens as typed SelectionFilter
         */
        _buildSelectionFilter: function () {
            const that = this;
            const getKeys = function (sId) {
                const oCtrl = that.byId(sId);
                return oCtrl ? oCtrl.getTokens().map(function (t) { return t.getKey(); }) : [];
            };

            return {
                TransportSystem:  getKeys("IdANTFilterTransportSystem"),
                DeliveryPoints:   getKeys("IdANTFilterDeliveryPoint"),
                RedeliveryPoints: getKeys("IdANTFilterRedeliveryPoint")
            };
        },

        /**
         * Client-side Pre-Checks for Allocate & Save with Segment Filtering
         * Handles TicketKey, Rank, GCV/NCV, OWN vs HYBRID shift, and Third-Party missing nominations.
         * Runs for ONE Gas Day: aAllNoms and the SCADA rows are that day's only.
         * bAnySegmentSelection is the whole range's — with SCADA rows selected on other
         * days only, this day has no explicit selection and so nothing in scope.
         */
        _runClientSideAllocationPreflightChecks: async function (sGasDay, aAllNoms, bAnySegmentSelection) {
            const oView = this.getView();
            const oAriModel = oView.getModel("ari006Model");
            const aAriRules = (oAriModel && oAriModel.getProperty("/rules")) || [];

            const _dayRows = sModel => ((oView.getModel(sModel) && oView.getModel(sModel).getProperty("/")) || [])
                .filter(r => r._gasDay === sGasDay);
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

            const _getLoc = function (r) {
                return (r && (r.BusinessLocation || r.YybusLocation || r.Location)) || "";
            };

            const _num = function (v) {
                if (typeof v === "number") {
                    return v;
                }
                if (!v) {
                    return 0;
                }
                return parseFloat(String(v).replace(/,/g, "").trim()) || 0;
            };

            // ── STEP 1: RESOLVE SEGMENT SELECTION FILTER ───────────────────────
            const oSegmentFilter = this._buildSegmentFilter(sGasDay);
            const bHasExplicitSegmentSelection = !!bAnySegmentSelection;

            const targetOwnLocs = new Set();
            const targetHybridLocs = new Set();
            const targetTpPairs = new Set();
            const targetEpLocs = new Set();

            if (bHasExplicitSegmentSelection) {
                (oSegmentFilter.OWN || []).forEach(function (x) { targetOwnLocs.add(x.Location); });
                (oSegmentFilter.HYBRID || []).forEach(function (x) { targetHybridLocs.add(x.Location); });
                (oSegmentFilter.THIRDPARTY || []).forEach(function (x) { targetTpPairs.add(x.Customer + "__" + x.Location); });
                (oSegmentFilter.ENTRYPOINT || []).forEach(function (x) { targetEpLocs.add(x.Location); });
            } else {
                for (let i = 0; i < aAllNoms.length; i++) {
                    const row = aAllNoms[i];
                    const loc = _getLoc(row);
                    if (!loc || row.LocationType !== "REDELIVERY") {
                        continue;
                    }

                    const kind = row.CustomerKind || "OWN";
                    if (kind === "THIRD-PARTY") {
                        if (row.Partner) {
                            targetTpPairs.add(row.Partner + "__" + loc);
                        }
                    } else if (kind === "HYBRID") {
                        targetHybridLocs.add(loc);
                    } else {
                        targetOwnLocs.add(loc);
                    }
                }
            }

            // ── STEP 2: TICKETKEY (ALREADY TICKETED) & RANK VALIDATIONS ────────
            for (let j = 0; j < aAllNoms.length; j++) {
                const row = aAllNoms[j];
                const loc = _getLoc(row);
                if (!loc) {
                    continue;
                }

                const isTp = row.CustomerKind === "THIRD-PARTY";
                const tpKey = row.Partner + "__" + loc;

                let inScope = false;
                if (row.LocationType === "DELIVERY") {
                    inScope = targetEpLocs.has(loc);
                } else if (row.LocationType === "REDELIVERY") {
                    // A location is under either the OWN or the HYBRID tab; selecting it picks up
                    // every non-Third-Party item there (mirrors runAllocationSave._isKindInActiveSegments)
                    inScope = (isTp && targetTpPairs.has(tpKey)) ||
                              (!isTp && (targetOwnLocs.has(loc) || targetHybridLocs.has(loc)));
                }

                if (!inScope) {
                    continue;
                }

                // 1. TICKET PURPOSE/STATUS — any item whose ticket is not Full Reversed (5/00)
                // or blank/blank blocks its whole Location (THIRD-PARTY Redelivery: the pair)
                if (TicketPurposeGate.isAllocationBlocked(row)) {
                    if (isTp && row.LocationType === "REDELIVERY") {
                        blockedTpPairsSet.add(tpKey);
                    } else {
                        blockedLocationsSet.add(loc);
                    }

                    const bAlreadyReported = issues.some(function (i) {
                        return i.Location === loc && (isTp ? i.Partner === row.Partner : true) && i.Category === "Already Ticketed";
                    });

                    if (!bAlreadyReported) {
                        issues.push({
                            Location: loc,
                            Partner: isTp ? row.Partner : "",
                            Category: "Already Ticketed",
                            Reason: "Ticket " + String(row.TicketKey || "").trim() + " is " + TicketPurposeGate.describe(row) + ". Cannot re-allocate."
                        });
                    }
                    continue;
                }

                // 2. RANK VALIDATION
                const r = row.Rank;
                if (r == null || r === "" || isNaN(Number(r)) || Number(r) <= 0) {
                    if (isTp && row.LocationType === "REDELIVERY") {
                        blockedTpPairsSet.add(tpKey);
                    } else {
                        blockedLocationsSet.add(loc);
                    }

                    const bRankReported = issues.some(function (i) {
                        return i.Location === loc && (isTp ? i.Partner === row.Partner : true) && i.Category === "Missing / 0 Rank";
                    });

                    if (!bRankReported) {
                        issues.push({
                            Location: loc,
                            Partner: isTp ? row.Partner : "",
                            Category: "Missing / 0 Rank",
                            Reason: "Contract " + (row.Contract || "") + " (" + row.NominationKey + "/" + row.NominationItem + ") has missing or 0 rank."
                        });
                    }
                }

                // 3. ARI006 Business Rule Validation
                // THIRD-PARTY Redelivery is Location+Customer: only that partner is blocked
                const bTpPairGrain = isTp && row.LocationType === "REDELIVERY";
                if (bTpPairGrain ? !blockedTpPairsSet.has(tpKey) : !blockedLocationsSet.has(loc)) {
                    for (let k = 0; k < aAriRules.length; k++) {
                        const rule = aAriRules[k];
                        if (rule.businessLocation && rule.businessLocation === loc) {
                            if (bTpPairGrain) {
                                blockedTpPairsSet.add(tpKey);
                            } else {
                                blockedLocationsSet.add(loc);
                            }
                            issues.push({
                                Location: loc,
                                Partner: isTp ? row.Partner : "",
                                Category: "Business Rule (ARI006)",
                                Reason: rule.message || "Allocation blocked by Business Rule."
                            });
                        }
                    }
                }
            }

            // ── STEP 3: METER READINGS & GCV/NCV CHECKS ─────────────────────────
            this._showBusy(this.getView().getModel("i18n").getResourceBundle().getText("antPreCheckBusyMeters"));
            await _sleep(100);

            // Detect Shift from OWN to HYBRID
            const shiftedHybridLocsSet = new Set();
            for (let m = 0; m < aHybridRows.length; m++) {
                const rHyb = aHybridRows[m];
                const locHyb = _getLoc(rHyb);
                const roleHyb = String(rHyb.Role || rHyb.Yy_Indicator || "").toUpperCase();
                if (locHyb && (roleHyb === "HYBRID" || roleHyb === "PRIMARY" || rHyb._type === "GROUP")) {
                    shiftedHybridLocsSet.add(locHyb);
                }
            }

            const hybridGrossMeterMap = new Map();
            for (let n = 0; n < aHybridRows.length; n++) {
                const rH = aHybridRows[n];
                const locH = _getLoc(rH);
                if (!locH || !shiftedHybridLocsSet.has(locH)) {
                    continue;
                }

                const meterVal = _num(rH.MeterReading || rH.MeterReadingSM3 || rH._scadaMeter || rH.YycumVolCm || rH.totalMR);
                const gcv = _num(rH.AvgWtGCV || rH.AVG_WT_GCV || rH.YyavgGcvCm || rH.YygcvNgail || rH.gcv || 9500);
                const ncv = _num(rH.AvgWtNCV || rH.AVG_WT_NCV || rH.YyavgNcvCm || rH.YyncvNgail || rH.ncv || 8500);

                if (meterVal > 0 && gcv > 0 && ncv > 0) {
                    if (rH._type === "GROUP" || !hybridGrossMeterMap.has(locH) || meterVal > hybridGrossMeterMap.get(locH)) {
                        hybridGrossMeterMap.set(locH, meterVal);
                    }
                }
            }

            const ownGrossMeterMap = new Map();
            for (let p = 0; p < aOwnRows.length; p++) {
                const rO = aOwnRows[p];
                const locO = _getLoc(rO);
                if (!locO || shiftedHybridLocsSet.has(locO)) {
                    continue;
                }

                const meterO = _num(rO.YycumVolCm || rO.MeterReading || rO._scadaMeter);
                const gcvO = _num(rO.YyavgGcvCm || rO.AvgWtGCV || rO.AVG_WT_GCV || rO.gcv || 9500);
                const ncvO = _num(rO.YyavgNcvCm || rO.AvgWtNCV || rO.AVG_WT_NCV || rO.ncv || 8500);
                if (meterO > 0 && gcvO > 0 && ncvO > 0) {
                    ownGrossMeterMap.set(locO, meterO);
                }
            }

            const epMeterMap = new Map();
            if (targetEpLocs.size > 0) {
                for (let q = 0; q < aEpRows.length; q++) {
                    const rE = aEpRows[q];
                    const locE = _getLoc(rE);
                    const scadaE = _num(rE._scadaMeter || rE.MeterReading || rE.YdpalcqtyEp);
                    const gcvE = _num(rE.YyavgGcvCm || rE.AvgWtGCV || rE.gcv || 9500);
                    const ncvE = _num(rE.YyavgNcvCm || rE.AvgWtNCV || rE.ncv || 8500);
                    if (locE && scadaE > 0 && gcvE > 0 && ncvE > 0) {
                        epMeterMap.set(locE, scadaE);
                    }
                }
            }

            const tpMeterMap = new Map();
            for (let s = 0; s < aTpRows.length; s++) {
                const rT = aTpRows[s];
                const locT = _getLoc(rT);
                const custT = rT.Yycustomer || rT.Customer || rT.Partner;
                const pairKeyT = custT + "__" + locT;
                const qtyT = _num(rT.YyallocQtyNongailscm || rT.CustomerQty || rT.MeterReading);
                const gcvT = _num(rT.YygcvNgail || rT.AvgWtGCV || rT.gcv || 9500);
                const ncvT = _num(rT.YyncvNgail || rT.AvgWtNCV || rT.ncv || 8500);
                if (locT && custT && qtyT > 0 && gcvT > 0 && ncvT > 0) {
                    tpMeterMap.set(pairKeyT, qtyT);
                }
            }

            // ── STEP 4: VERIFY ELIGIBILITY ─────────────────────────────────────
            const eligibleOwnLocs = [];
            const eligibleHybridLocs = [];
            const eligibleEpLocs = [];
            const eligibleTpPairs = [];

            // 1. Entry Point Checks (Only if explicitly selected)
            if (targetEpLocs.size > 0) {
                targetEpLocs.forEach(function (loc) {
                    if (blockedLocationsSet.has(loc)) {
                        return;
                    }
                    if (!epMeterMap.has(loc)) {
                        blockedLocationsSet.add(loc);
                        issues.push({
                            Location: loc,
                            Category: "Meter / Quality Missing",
                            Reason: "Entry Point CM Meter Reading or GCV/NCV is missing or zero."
                        });
                    } else {
                        eligibleEpLocs.push(loc);
                    }
                });
            }

            // 2. Unified OWN / HYBRID Checks
            const redeliveryLocsToEvaluate = new Set([...targetOwnLocs, ...targetHybridLocs]);

            redeliveryLocsToEvaluate.forEach(function (loc) {
                if (blockedLocationsSet.has(loc)) {
                    return;
                }

                const isShiftedToHybrid = shiftedHybridLocsSet.has(loc);
                let targetMR = isShiftedToHybrid ? (hybridGrossMeterMap.get(loc) || 0) : (ownGrossMeterMap.get(loc) || 0);

                if (targetMR <= 0) {
                    if (isShiftedToHybrid) {
                        const hRow = aHybridRows.find(function (r) {
                            return _getLoc(r) === loc && _num(r.MeterReading || r._scadaMeter || r.YycumVolCm) > 0;
                        });
                        targetMR = _num(hRow ? (hRow.MeterReading || hRow._scadaMeter || hRow.YycumVolCm) : 0);
                    } else {
                        const oRow = aOwnRows.find(function (r) {
                            return _getLoc(r) === loc && _num(r.YycumVolCm || r.MeterReading) > 0;
                        });
                        targetMR = _num(oRow ? (oRow.YycumVolCm || oRow.MeterReading) : 0);
                    }
                }

                if (targetMR <= 0) {
                    blockedLocationsSet.add(loc);
                    issues.push({
                        Location: loc,
                        Category: "Meter / Quality Missing",
                        Reason: isShiftedToHybrid
                            ? "HYBRID physical meter or GCV/NCV missing or not uploaded."
                            : "OWN physical meter reading or GCV/NCV missing or not uploaded."
                    });
                } else {
                    if (isShiftedToHybrid) {
                        eligibleHybridLocs.push(loc);
                    } else {
                        eligibleOwnLocs.push(loc);
                    }
                }
            });

            // 3. Third-Party Checks (Evaluates Missing Uploads AND Missing Nominations)
            const allTpPairsToEvaluate = new Set([...targetTpPairs]);

            // Ensure uploaded Third-Party pairs from tpMeterMap are evaluated for orphan check
            tpMeterMap.forEach(function (val, pairKey) {
                if (bHasExplicitSegmentSelection) {
                    const aParts = pairKey.split("__");
                    const sCust = aParts[0];
                    const sLoc = aParts[1];
                    const bSelected = (oSegmentFilter.THIRDPARTY || []).some(function (x) {
                        return x.Location === sLoc && (!x.Customer || x.Customer === sCust);
                    });
                    if (bSelected) {
                        allTpPairsToEvaluate.add(pairKey);
                    }
                } else {
                    allTpPairsToEvaluate.add(pairKey);
                }
            });

            allTpPairsToEvaluate.forEach(function (pairKey) {
                if (blockedTpPairsSet.has(pairKey)) {
                    return;
                }
                const aParts = pairKey.split("__");
                const cust = aParts[0];
                const loc = aParts[1];

                const pairItems = aAllNoms.filter(function (r) {
                    return _getLoc(r) === loc &&
                           (r.Partner === cust || r.Customer === cust) &&
                           r.LocationType === "REDELIVERY" &&
                           r.CustomerKind === "THIRD-PARTY";
                });

                const hasUpload = tpMeterMap.has(pairKey);

                // Case A: Nomination exists, but customer upload is missing or zero
                if (!hasUpload && pairItems.length > 0) {
                    blockedTpPairsSet.add(pairKey);
                    issues.push({
                        Location: loc,
                        Partner: cust,
                        Category: "Meter / Quality Missing",
                        Reason: "Customer allocation quantity or GCV/NCV not uploaded for Partner & Location."
                    });
                    return;
                }

                // Case B: Allocation Qty is uploaded, but NO nomination data exists (Orphan Reading)
                if (hasUpload && pairItems.length === 0) {
                    blockedTpPairsSet.add(pairKey);
                    issues.push({
                        Location: loc,
                        Partner: cust,
                        Category: "Missing Nomination",
                        Reason: "Customer Qty uploaded but no Nomination found for the Partner at the Business Location."
                    });
                    return;
                }

                // Cleared
                eligibleTpPairs.push({ Location: loc, Customer: cust, Role: "" });
            });

            // ── STEP 5: BUILD SCOPED PAYLOAD FOR BACKEND ACTION ─────────────────
            const scopedPayload = {
                SelectionFilter: this._buildSelectionFilter(),
                SegmentFilter: {
                    OWN: eligibleOwnLocs.map(function (l) { return { Location: l, Customer: "", Role: "" }; }),
                    HYBRID: eligibleHybridLocs.map(function (l) { return { Location: l, Customer: "", Role: "" }; }),
                    THIRDPARTY: eligibleTpPairs.map(function (p) { return { Location: p.Location, Customer: p.Customer, Role: "" }; }),
                    ENTRYPOINT: eligibleEpLocs.map(function (l) { return { Location: l, Customer: "", Role: "" }; }),
                    Excluded: []
                }
            };

            return { issues: issues, scopedPayload: scopedPayload };
        },

        _hasEligibleTargetsInPayload: function (oPayload) {
            if (!oPayload || !oPayload.SegmentFilter) {
                return false;
            }
            const sf = oPayload.SegmentFilter;
            return (
                (sf.OWN && sf.OWN.length > 0) ||
                (sf.HYBRID && sf.HYBRID.length > 0) ||
                (sf.THIRDPARTY && sf.THIRDPARTY.length > 0) ||
                (sf.ENTRYPOINT && sf.ENTRYPOINT.length > 0)
            );
        },

        _callRunAllocateSave: async function (oScopedPayload, sGasDay) {
            const oModel = this.getView().getModel();
            const oCtx = oModel.bindContext("/RunAllocateSave(...)");

            oCtx.setParameter("Gasday", sGasDay);
            oCtx.setParameter("SelectionFilter", oScopedPayload.SelectionFilter);
            oCtx.setParameter("SegmentFilter", oScopedPayload.SegmentFilter);

            await oCtx.execute();

            const oRaw = oCtx.getBoundContext().getObject();
            return (oRaw && oRaw.value && typeof oRaw.value === "object" && !Array.isArray(oRaw.value))
                ? oRaw.value
                : oRaw;
        },

        /**
         * Surfaces RunAllocateSave's result: saved count, S/4 save errors, and any location the
         * backend skipped although the client pre-checks passed it (client/server check divergence).
         */
        _showAllocateSaveOutcome: function (oResult) {
            const oBundle = this.getView().getModel("i18n").getResourceBundle();
            const nSaved = Number(oResult?.SavedToS4Count) || 0;
            const bSaveOk = oResult?.SaveSuccess !== false;
            const aSaveErrors = oResult?.SaveErrors || [];
            const aBackendSkipped = [].concat(
                oResult?.SkippedDueToMissingMeters || [],
                oResult?.OrphanMetersWithoutNominations || [],
                oResult?.BlockedByTicketOrRank || []
            );

            const sSkippedText = aBackendSkipped.length
                ? oBundle.getText("antAllocSaveBackendSkipped") + "\n\n" + aBackendSkipped.map(function (i) {
                    const sTarget = i.Partner ? (i.Location + " (Partner: " + i.Partner + ")") : i.Location;
                    const sSegment = i.Segment ? " [" + i.Segment + "]" : "";
                    return "• " + sTarget + sSegment + ": " + (i.Reason || "");
                }).join("\n")
                : "";

            if (!bSaveOk) {
                const sErrors = aSaveErrors.map(function (s) { return "• " + s; }).join("\n");
                MessageBox.error(
                    oBundle.getText("antAllocSavePartialFailure", [nSaved]) + "\n\n" + sErrors +
                        (sSkippedText ? "\n\n" + sSkippedText : ""),
                    { title: oBundle.getText("antAllocSaveErrorTitle") }
                );
                return;
            }

            const oAllocModel = this.getView().getModel("allocationModel");
            if (oAllocModel) {
                oAllocModel.setProperty("/btnState", "saved");
            }
            MessageToast.show(oBundle.getText("antAllocSaveSuccess", [nSaved]));

            if (sSkippedText) {
                MessageBox.warning(sSkippedText, { title: oBundle.getText("antAllocSaveSkippedTitle") });
            }
        },

        /**
         * One summary for a Gas Day range: every day that ran, with its saved count, S/4
         * save errors, backend-skipped locations, or the error that stopped that day.
         */
        _showRangeAllocateSaveOutcome: function (aResults) {
            const oBundle = this.getView().getModel("i18n").getResourceBundle();
            let bAnyProblem = false;
            const aLines = aResults.map(({ sGasDay, oResult, sError }) => {
                const sDay = this.formatDate(sGasDay);
                if (sError) {
                    bAnyProblem = true;
                    return "✖ " + sDay + ": " + oBundle.getText("antRangeDayFailed") + " " + sError;
                }
                const nSaved = Number(oResult?.SavedToS4Count) || 0;
                const aSaveErrors = oResult?.SaveErrors || [];
                const aSkipped = [].concat(
                    oResult?.SkippedDueToMissingMeters || [],
                    oResult?.OrphanMetersWithoutNominations || [],
                    oResult?.BlockedByTicketOrRank || []
                );
                const bSaveOk = oResult?.SaveSuccess !== false;
                if (!bSaveOk || aSkipped.length) bAnyProblem = true;
                let sLine = (bSaveOk ? "✔ " : "✖ ") + sDay + ": " + oBundle.getText("antRangeDaySaved", [nSaved]);
                aSaveErrors.forEach(s => { sLine += "\n    • " + s; });
                aSkipped.forEach(i => {
                    const sTarget = i.Partner ? (i.Location + " (Partner: " + i.Partner + ")") : i.Location;
                    sLine += "\n    • " + oBundle.getText("antRangeSkipped") + " " + sTarget + ": " + (i.Reason || "");
                });
                return sLine;
            });

            const sText = oBundle.getText("antRangeAllocSummary") + "\n\n" + aLines.join("\n\n");
            const sTitle = oBundle.getText("antRangeAllocTitle");
            if (bAnyProblem) {
                MessageBox.warning(sText, { title: sTitle });
            } else {
                const oAllocModel = this.getView().getModel("allocationModel");
                if (oAllocModel) {
                    oAllocModel.setProperty("/btnState", "saved");
                }
                MessageBox.success(sText, { title: sTitle });
            }
        },

        _getAllocationErrorText: function (oErr) {
            let sErrMsg = (oErr && oErr.message) || "Allocation failed. Please try again.";
            try {
                const oBody = (typeof oErr?.responseText === "string")
                    ? JSON.parse(oErr.responseText) : null;
                sErrMsg = oBody?.error?.innererror?.errordetails?.[0]?.message
                       || oBody?.error?.message?.value
                       || sErrMsg;
            } catch (ex) {
                // Keep original message if unparseable
            }
            return sErrMsg;
        },

        _showAllocationError: function (oErr) {
            MessageBox.error(this._getAllocationErrorText(oErr), { title: "Allocation Error" });
        }
    };
});