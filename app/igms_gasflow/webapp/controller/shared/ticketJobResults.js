sap.ui.define([
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/ui/model/Sorter",
    "sap/m/MessageToast",
    "sap/m/MessageBox",
    "com/ingenx/igmsgasflow/utils/errorHandler"
], (Filter, FilterOperator, Sorter, MessageToast, MessageBox, ErrorHandler) => {
    "use strict";

    // ── Ticket Job Results — shared mixin ─────────────────────────────────────────
    // Given a processTicketing jobId, poll getProcessTicketingJobStatus to completion and
    // resolve the job's processedItems into grouped log rows (same shape
    // shared/ticketDetailDialog#_groupLogEntries produces). Used by ticketingRunLogs —
    // the page Allocation & Ticketing opens right after a Ticketing submission.
    //
    // Rows come from TktlogDetailSet, queried per Nomination Key
    // ($filter=Nomtk eq '<20-char padded>', newest first, TO_DOCFLOW/TO_ERRLOG expanded),
    // grouped exactly like the Message Summary detail dialog groups them, so grid and
    // dialog never disagree.
    //
    // Host controller provides _showBusy/_hideBusy, _groupLogEntries (ticketDetailDialog
    // mixin) and _applyResultRows.

    const JOB_POLL_MS = 2000;

    // job.processedItems carry unpadded values ("67211" / "10"); TktlogDetailSet pads
    // Nomtk to 20 and Nomit to 10 chars — strip the padding on both sides or matches drop.
    const _unpad = v => String(v || "").trim().replace(/^0+(?=\d)/, "");
    function _matchKey(sNomtk, sNomit) {
        return `${_unpad(sNomtk)}|${_unpad(sNomit)}`;
    }

    // TktlogDetailSet leaves a line at ProcessStatus "N" even when its TO_ERRLOG holds
    // an error (e.g. "Create sales document" not allowed) — the error log decides.
    function _lineStatus(r) {
        const aErrlog = r.TO_ERRLOG || [];
        if (aErrlog.some(e => e.MsgTyp === "E" || e.MsgTyp === "A")) return "E";
        if (aErrlog.some(e => e.MsgTyp === "W")) return "W";
        if (r.HasErrors && (!r.ProcessStatus || r.ProcessStatus === "N")) return "E";
        return r.ProcessStatus;
    }

    return {

        // sJobId may name several runs, comma-separated — a Gas Day range submits one
        // processTicketing job per day. Rows of every run are shown together, each
        // tagged with its run's Gas Day (_gasDay).
        _loadJobResults: async function (sJobId) {
            const aJobIds = String(sJobId).split(",").filter(Boolean);
            if (aJobIds.length > 1) {
                await this._loadMultiJobResults(sJobId, aJobIds);
                return;
            }
            this._showBusy("Ticket is processing in background…");
            try {
                const oModel = this.getOwnerComponent().getModel();
                const oJob = await this._pollJobUntilDone(oModel, sJobId);

                if (!oJob || oJob.status === "NOT_FOUND") {
                    this._applyResultRows([], sJobId, null);
                    MessageToast.show("This Ticketing run is no longer available (runs are kept for 2 hours) — check Ticket Logs by Gas Day instead.");
                    return;
                }
                if (oJob.status === "FAILED") {
                    this._applyResultRows([], sJobId, oJob);
                    MessageBox.error(`Ticketing failed: ${oJob.error || "S/4 returned an error."}`);
                    return;
                }

                const aProcessedRows = await this._buildJobRows(oModel, oJob);
                this._applyResultRows(aProcessedRows, sJobId, oJob);
            } catch (oError) {
                this._applyResultRows([], sJobId, null);
                ErrorHandler.handleError("Failed to load ticketing results", oError, ErrorHandler.SEVERITY.ERROR, true);
            } finally {
                this._hideBusy();
            }
        },

        /** Several runs (one per Gas Day): waits for each, merges their rows, and reports
         *  the runs that failed or are no longer available in one message. */
        _loadMultiJobResults: async function (sJobIds, aJobIds) {
            this._showBusy("Ticket is processing in background…");
            try {
                const oModel = this.getOwnerComponent().getModel();
                const aRows = [];
                const aDays = [];
                const aProblems = [];
                for (const sJobId of aJobIds) {
                    const oJob = await this._pollJobUntilDone(oModel, sJobId);
                    if (!oJob || oJob.status === "NOT_FOUND") {
                        aProblems.push(`• Run ${sJobId}: no longer available (runs are kept for 2 hours) — check Ticket Logs by Gas Day instead.`);
                        continue;
                    }
                    if (oJob.gasday) aDays.push(oJob.gasday);
                    if (oJob.status === "FAILED") {
                        aProblems.push(`• Gas Day ${oJob.gasday || "-"}: Ticketing failed: ${oJob.error || "S/4 returned an error."}`);
                        continue;
                    }
                    aRows.push(...await this._buildJobRows(oModel, oJob));
                }
                this._applyResultRows(aRows, sJobIds, { gasday: aDays.sort().join(", ") });
                if (aProblems.length) {
                    MessageBox.warning(aProblems.join("\n"));
                }
            } catch (oError) {
                this._applyResultRows([], sJobIds, null);
                ErrorHandler.handleError("Failed to load ticketing results", oError, ErrorHandler.SEVERITY.ERROR, true);
            } finally {
                this._hideBusy();
            }
        },

        /** One finished run's result rows, each tagged with the run's Gas Day. */
        _buildJobRows: async function (oModel, oJob) {
            const aItems = oJob.processedItems || [];
            const dStartedAt = oJob.startedAt ? new Date(oJob.startedAt) : null;
            const aRows = await this._buildProcessedRows(oModel, aItems, dStartedAt);
            return aRows.map(r => Object.assign({}, r, { _gasDay: oJob.gasday || "" }));
        },

        /** Polls getProcessTicketingJobStatus every ~2s until the job leaves SUBMITTED/RUNNING. */
        _pollJobUntilDone: function (oModel, sJobId) {
            return new Promise(resolve => {
                const poll = async () => {
                    const oCtx = oModel.bindContext("/getProcessTicketingJobStatus(...)");
                    oCtx.setParameter("jobId", sJobId);
                    let oStatus;
                    try {
                        await oCtx.execute("$direct");
                        oStatus = oCtx.getBoundContext().getObject();
                    } catch {
                        oCtx.destroy();
                        setTimeout(poll, 5000); // transient — retry rather than give up
                        return;
                    }
                    oCtx.destroy();

                    if (oStatus.status === "SUBMITTED" || oStatus.status === "RUNNING") {
                        setTimeout(poll, JOB_POLL_MS);
                        return;
                    }
                    resolve(oStatus);
                };
                poll();
            });
        },

        /** Reads TktlogDetailSet once per distinct Nomination Key (in parallel), groups
         *  the lines (_groupLogEntries, shared/ticketDetailDialog) and keeps, per job
         *  item, the newest group created at/after dStartedAt — falling back to the
         *  newest overall when S/4 has nothing in that window yet. An item can carry
         *  several groups (e.g. a reversal of the previous ticket plus the new
         *  actualization); the most recent one represents it in the grid. */
        _buildProcessedRows: async function (oModel, aItems, dStartedAt) {
            const oWanted = new Set(aItems.map(i => _matchKey(i.NominationKey, i.NominationItem)));
            const aNomtks = [...new Set(aItems.map(i => _unpad(i.NominationKey)).filter(Boolean))];

            const aGroupedPerNomtk = await Promise.all(aNomtks.map(sNomtk => this._fetchNomtkLogs(oModel, sNomtk)));

            const oCandidatesByItem = new Map(); // matchKey → grouped rows
            aGroupedPerNomtk.flat().forEach(oRow => {
                const sKey = _matchKey(oRow.Nomtk, oRow.Nomit);
                if (!oWanted.has(sKey)) return; // other items of the same nomination
                if (!oCandidatesByItem.has(sKey)) oCandidatesByItem.set(sKey, []);
                oCandidatesByItem.get(sKey).push(oRow);
            });

            const nStartedTs = dStartedAt ? dStartedAt.getTime() : 0;
            const aRows = [];
            for (const oItem of aItems) {
                const sKey = _matchKey(oItem.NominationKey, oItem.NominationItem);
                const aCandidates = oCandidatesByItem.get(sKey) || [];
                const aInWindow = nStartedTs
                    ? aCandidates.filter(c => !c._createdTs || c._createdTs >= nStartedTs)
                    : aCandidates;
                const aPool = aInWindow.length ? aInWindow : aCandidates;
                if (!aPool.length) {
                    // S/4 hasn't written this item's execution log yet — still show the
                    // processed item so the user sees the whole run; Refresh fills it in
                    aRows.push({
                        Nomtk: oItem.NominationKey,
                        Nomit: oItem.NominationItem,
                        TicketKey: "",
                        TicketItem: "",
                        ProcessStatus: "N",
                        MessageSummary: "Execution log not available yet — press Refresh.",
                        HasErrors: "",
                        HasDocs: "",
                        _logEntries: []
                    });
                    continue;
                }

                // Newest first; versions split off the same log line share its timestamp,
                // so on a tie prefer the highest TicketVersion.
                aPool.sort((a, b) => (b._createdTs || 0) - (a._createdTs || 0) ||
                    String(b.TicketVersion || "").localeCompare(String(a.TicketVersion || "")));
                aRows.push(aPool[0]);
            }
            return aRows;
        },

        /** TktlogDetailSet?$filter=Nomtk eq '<padded>'&$orderby=CreatedDate desc,CreatedTime desc
         *  &$expand=TO_DOCFLOW,TO_ERRLOG — every log line S/4 holds for one nomination,
         *  grouped per ticket item/version. bRawStatus keeps S/4's own ProcessStatus
         *  (Allocation & Ticketing ticket dialog) instead of the error-log-derived
         *  _lineStatus this page shows. */
        _fetchNomtkLogs: async function (oModel, sNomtk, bRawStatus) {
            const oListBinding = oModel.bindList(
                "/TktlogDetailSet",
                null,
                [new Sorter("CreatedDate", true), new Sorter("CreatedTime", true)],
                [new Filter("Nomtk", FilterOperator.EQ, sNomtk.padStart(20, "0"))],
                { $expand: "TO_DOCFLOW,TO_ERRLOG", $$groupId: "$direct" }
            );
            const aContexts = await oListBinding.requestContexts(0, Infinity);
            return this._groupLogEntries(aContexts.map(ctx => {
                const oLine = ctx.getObject();
                return bRawStatus ? { ...oLine } : { ...oLine, ProcessStatus: _lineStatus(oLine) };
            }));
        }
    };
});
