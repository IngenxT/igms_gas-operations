sap.ui.define([
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator",
    "sap/m/MessageToast",
    "sap/ui/model/json/JSONModel",
    "com/ingenx/igmsgasflow/utils/errorHandler"
], (Filter, FilterOperator, MessageToast, JSONModel, ErrorHandler) => {
    "use strict";

    // ── Allocation & Ticketing — Scheduled Items ticket drill-down ─────────────
    // Single responsibility: when a Scheduled Items row already carries a
    // TicketKey/TicketItem (it's been ticketed), pressing the Ticket Key link
    // opens the same Success/Partial/Error/Warning detail dialog dateWiseTicketLogs
    // and the job-results path (RouteTicketJobLog) use — shared via
    // shared/ticketDetailDialog's _openTicketDetailDialog, merged onto this same
    // controller in allocationNTicketing.controller.js.
    //
    // Reads TicketDetailSet (GMSTICKET_API_SRV) directly instead of the old
    // xGMSxTKT_EXEC_TICKETS → TktlogDetailHeadSet double-hop: TicketDetailSet's
    // own row IS one execution record, with TO_DOCFLOW/TO_ERRLOG attached
    // directly, and its own field names (TicketKey/TicketItem/Nomtk/Nomit/
    // ProcessStatus/MessageSummary/HasErrors) already match what
    // _openTicketDetailDialog expects — no grouping/reshaping needed.
    //
    // Primary path: a Scheduled Items row carries TicketKey/TicketItem/
    // TicketVersion/TicketPurpose as adjacent properties (all sourced straight off
    // xGMSxNOMSOURCE — see scheduledNomItems.js), which together are
    // TicketDetailSet's own compound key — one single-entity-by-key GET, no
    // search/resolution round trip at all.
    // Fallback path: TicketVersion/TicketPurpose missing on the row for any reason
    // — resolves via Nomtk+Nomit instead ($filter, confirmed to work against this
    // service despite the remote metadata's own filterable:false annotations —
    // see TicketDetailSet's own cds doc comment), narrowed to this row's exact
    // TicketKey+TicketItem, then the most recently changed entry if more than one
    // Version/Purpose combination still matches (e.g. an original ticket and its
    // own later reversal sharing the same TicketKey).
    //
    // Nom Key link: reads every TicketDetailSet row for the row's Nomtk+Nomit and opens
    // NominationTicketsDialog straight on that tickets list; each ticket opens the same
    // shared Ticket Execution Detail dialog as the Ticket Key link.

    /** Zero-pads a purely-numeric value up to `iLen` — TicketDetailSet's own
     *  TicketKey/TicketItem/TicketVersion/Nomtk/Nomit are real OData KEY-shaped
     *  fields there, which SAP Gateway ALPHA-converts (zero-pads) to their
     *  declared length on that entity — but the SAME value sourced off
     *  xGMSxNOMSOURCE (scheduledNomItems.js/nomItemsCache), where these are plain
     *  reference fields, not keys, comes back unpadded (e.g. TicketKey "11044"
     *  instead of "00000000000000011044"). Building a TicketDetailSet request
     *  with the unpadded value finds nothing. Non-numeric input (or already
     *  padded/over-length input) is returned unchanged — safe no-op either way. */
    function _alphaPad(v, iLen) {
        const s = String(v || "").trim();
        return /^\d+$/.test(s) ? s.padStart(iLen, "0") : s;
    }

    /** Parses a time into seconds — either an Edm.Time duration ("PT19H42M47S") or
     *  an OData V4 Edm.TimeOfDay ("19:42:47", what the CAP service actually returns
     *  for ChangedTime/CreatedTime). Returns 0 for anything unparseable. */
    function _durationToSeconds(sDuration) {
        const s = sDuration || "";
        let m = /^PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+(?:\.\d+)?)S)?$/.exec(s)
             || /^(\d{1,2}):(\d{2})(?::(\d{2}(?:\.\d+)?))?$/.exec(s);
        if (!m) return 0;
        return (parseInt(m[1] || "0", 10) * 3600) + (parseInt(m[2] || "0", 10) * 60) + parseFloat(m[3] || "0");
    }

    /** Combines a TicketDetailSet row's ChangedDate/ChangedTime (falling back to Created*) into one comparable timestamp, for picking the most recent of several matching executions. */
    function _rowTimestamp(r) {
        const dDate = r.ChangedDate || r.CreatedDate;
        const sTime = r.ChangedDate ? r.ChangedTime : r.CreatedTime;
        if (!dDate) return 0;
        const oDate = dDate instanceof Date ? dDate : new Date(dDate);
        if (isNaN(oDate.getTime())) return 0;
        return oDate.getTime() + _durationToSeconds(sTime) * 1000;
    }

    /** ChangedDate/ChangedTime (falling back to Created*) as "dd-mm-yyyy HH:mm:ss".
     *  The date is a UTC-midnight value, so UTC parts are used — local parts would
     *  shift the day in negative-offset timezones; the time is S/4's own wall-clock
     *  time, shown as is. */
    function _formatRowDate(r) {
        const dDate = r.ChangedDate || r.CreatedDate;
        const sTime = r.ChangedDate ? r.ChangedTime : r.CreatedTime;
        if (!dDate) return "";
        const oDate = dDate instanceof Date ? dDate : new Date(dDate);
        if (isNaN(oDate.getTime())) return "";
        const pad = n => String(n).padStart(2, "0");
        const sDate = `${pad(oDate.getUTCDate())}-${pad(oDate.getUTCMonth() + 1)}-${oDate.getUTCFullYear()}`;
        if (!sTime) return sDate;
        const iSecs = Math.floor(_durationToSeconds(sTime));
        return `${sDate} ${pad(Math.floor(iSecs / 3600))}:${pad(Math.floor(iSecs / 60) % 60)}:${pad(iSecs % 60)}`;
    }

    /** TicketDetailSet rows → list rows: copied (never mutate the OData model's own
     *  cached objects), with a display timestamp, newest first. */
    function _toTicketListRows(aRaw) {
        return aRaw
            .map(t => {
                const iTs = _rowTimestamp(t);
                return { ...t, _ts: iTs, _lastChanged: _formatRowDate(t) };
            })
            .sort((a, b) => b._ts - a._ts);
    }

    return {
        onTicketKeyPress: async function (oEvent) {
            const oCtx = oEvent.getSource().getBindingContext();
            if (!oCtx) return;
            const oRow = oCtx.getObject();
            if (!oRow.TicketKey) return; // link is hidden otherwise — defensive only
            await this._openTicketKeyList(oRow);
        },

        /** Ticket Key link → list of this ticket's own execution records first (every
         *  TicketDetailSet Version/Purpose row for this row's TicketKey+TicketItem, e.g.
         *  an original ticket and its later reversal), newest first; pressing a row opens
         *  the shared detail dialog (onNomTicketPress). Same list page as the Nom Key
         *  drill-down, opened directly on it with no back navigation. */
        _openTicketKeyList: async function (oRow) {
            this._showBusy("Loading ticket details…");
            try {
                const oModel = this.getOwnerComponent().getModel();
                const sTicketKey = _alphaPad(oRow.TicketKey, 20);
                const sTicketItem = _alphaPad(oRow.TicketItem, 6);
                let aRaw = (await this._fetchNominationTickets(oModel, oRow))
                    .filter(r => r.TicketKey === sTicketKey && r.TicketItem === sTicketItem);

                // Nothing matched via Nomtk+Nomit — fall back to the direct by-key read.
                if (!aRaw.length && oRow.TicketVersion && oRow.TicketPurpose) {
                    const oDetail = await this._fetchTicketDetailByKey(oModel, oRow);
                    if (oDetail) aRaw = [oDetail];
                }

                if (!aRaw.length) {
                    MessageToast.show("No execution log found for this ticket yet.");
                    return;
                }

                const aTickets = _toTicketListRows(aRaw);
                this._showNomTicketsDialog({
                    fromTicketKey: true,
                    selected: {
                        TicketKey: sTicketKey,
                        TicketItem: sTicketItem,
                        Nomtk: aTickets[0].Nomtk || oRow.NominationKey,
                        Nomit: aTickets[0].Nomit || oRow.NominationItem,
                        tickets: aTickets
                    }
                });
            } catch (oError) {
                ErrorHandler.handleError("Failed to load ticket details", oError, ErrorHandler.SEVERITY.ERROR, true);
            } finally {
                this._hideBusy();
            }
        },

        _openScheduledItemTicketDetail: async function (oRow) {
            this._showBusy("Loading ticket details…");
            try {
                const oModel = this.getOwnerComponent().getModel();
                let oDetail = null;

                if (oRow.TicketKey && oRow.TicketItem && oRow.TicketVersion && oRow.TicketPurpose) {
                    oDetail = await this._fetchTicketDetailByKey(oModel, oRow);
                }

                if (!oDetail) {
                    oDetail = await this._fetchTicketDetailByNomination(oModel, oRow);
                }

                if (!oDetail) {
                    MessageToast.show("No execution log found for this ticket yet.");
                    return;
                }

                this._openTicketDetailDialog(oDetail);
            } catch (oError) {
                ErrorHandler.handleError("Failed to load ticket details", oError, ErrorHandler.SEVERITY.ERROR, true);
            } finally {
                this._hideBusy();
            }
        },

        /** Primary path — single-entity-by-key GET against TicketDetailSet using
         *  this row's own TicketKey/TicketItem/TicketVersion/TicketPurpose. Returns
         *  null (not throw) on a 404/not-found so the caller can fall back to the
         *  Nomtk+Nomit lookup instead of surfacing a raw error for what may just be
         *  a stale/edge-case row. */
        _fetchTicketDetailByKey: async function (oModel, oRow) {
            try {
                const sTicketItem = _alphaPad(oRow.TicketItem, 6);
                const sTicketKey = _alphaPad(oRow.TicketKey, 20);
                const sTicketVersion = _alphaPad(oRow.TicketVersion, 3);
                const oCtx = oModel.bindContext(
                    `/TicketDetailSet(TicketItem='${sTicketItem}',TicketKey='${sTicketKey}',TicketVersion='${sTicketVersion}',Purpose='${oRow.TicketPurpose}')`,
                    null,
                    { $expand: "TO_DOCFLOW,TO_ERRLOG", $$groupId: "$direct" }
                );
                return await oCtx.requestObject();
            } catch (oErr) {
                return null; // not found (or transient) — caller falls back to Nomtk+Nomit
            }
        },

        /** Fallback path — TicketDetailSet$filter=Nomtk eq ... and Nomit eq ...,
         *  narrowed to this row's own TicketKey+TicketItem (a Nomtk+Nomit pair can
         *  carry the item's ENTIRE ticket history — many distinct TicketKeys over
         *  time, e.g. corrections/reversals — so an unnarrowed match would pick up
         *  unrelated tickets). Picks the most recently changed entry when more than
         *  one Version/Purpose combination still matches this exact TicketKey. */
        _fetchTicketDetailByNomination: async function (oModel, oRow) {
            const sNomtk = _alphaPad(oRow.NominationKey, 20);
            const sNomit = _alphaPad(oRow.NominationItem, 10);
            const oListBinding = oModel.bindList("/TicketDetailSet", null, null, [
                new Filter({
                    filters: [
                        new Filter("Nomtk", FilterOperator.EQ, sNomtk),
                        new Filter("Nomit", FilterOperator.EQ, sNomit)
                    ],
                    and: true
                })
            ], {
                $expand: "TO_DOCFLOW,TO_ERRLOG",
                $$groupId: "$direct"
            });
            const aContexts = await oListBinding.requestContexts(0, Infinity);
            const aAll = aContexts.map(ctx => ctx.getObject());

            // TicketDetailSet's own TicketKey/TicketItem come back ALPHA-padded
            // (real key fields there) — pad this row's own values the same way
            // before comparing, or a correct match would never narrow at all.
            const sTicketKey = _alphaPad(oRow.TicketKey, 20);
            const sTicketItem = _alphaPad(oRow.TicketItem, 6);
            const aMatching = aAll.filter(r => r.TicketKey === sTicketKey && r.TicketItem === sTicketItem);
            const aPool = aMatching.length ? aMatching : aAll;
            if (!aPool.length) return null;

            aPool.sort((a, b) => _rowTimestamp(b) - _rowTimestamp(a));
            return aPool[0];
        },

        // ── Nom Key drill-down ────────────────────────────────────────────────────

        /** Nom Key only — TicketDetailSet$filter=Nomtk eq ... and Nomit eq ..., every
         *  ticket ever recorded against this nomination item, TO_DOCFLOW/TO_ERRLOG
         *  expanded. Kept separate from the Ticket Key path's own
         *  _fetchTicketDetailByNomination so that path stays exactly as it was. */
        _fetchNominationTickets: async function (oModel, oRow) {
            const oListBinding = oModel.bindList("/TicketDetailSet", null, null, [
                new Filter({
                    filters: [
                        new Filter("Nomtk", FilterOperator.EQ, _alphaPad(oRow.NominationKey, 20)),
                        new Filter("Nomit", FilterOperator.EQ, _alphaPad(oRow.NominationItem, 10))
                    ],
                    and: true
                })
            ], {
                $expand: "TO_DOCFLOW,TO_ERRLOG",
                $$groupId: "$direct"
            });
            const aContexts = await oListBinding.requestContexts(0, Infinity);
            return aContexts.map(ctx => ctx.getObject());
        },

        onNomKeyPress: async function (oEvent) {
            const oCtx = oEvent.getSource().getBindingContext();
            if (!oCtx) return;
            const oRow = oCtx.getObject();
            if (!oRow.NominationKey) return; // link is hidden otherwise — defensive only
            await this._openNominationTickets(oRow);
        },

        /** Loads every ticket behind this row's NominationKey+NominationItem and opens
         *  NominationTicketsDialog straight on that list of tickets. */
        _openNominationTickets: async function (oRow) {
            this._showBusy("Loading nomination tickets…");
            try {
                const oModel = this.getOwnerComponent().getModel();
                const aRaw = await this._fetchNominationTickets(oModel, oRow);

                if (!aRaw.length) {
                    MessageToast.show("No tickets found for this nomination item yet.");
                    return;
                }

                const aTickets = _toTicketListRows(aRaw);
                this._showNomTicketsDialog({
                    fromTicketKey: false,
                    selected: {
                        Nomtk: aTickets[0].Nomtk || oRow.NominationKey,
                        Nomit: aTickets[0].Nomit || oRow.NominationItem,
                        tickets: aTickets
                    }
                });
            } catch (oError) {
                ErrorHandler.handleError("Failed to load nomination tickets", oError, ErrorHandler.SEVERITY.ERROR, true);
            } finally {
                this._hideBusy();
            }
        },

        /** Opens NominationTicketsDialog (tickets list) with `oData` as nomTicketsModel. */
        _showNomTicketsDialog: function (oData) {
            const oView = this.getView();
            if (!this._oNomTicketsDialog) {
                this._oNomTicketsDialog = sap.ui.xmlfragment(
                    oView.getId(),
                    "com.ingenx.igmsgasflow.fragments.NominationTicketsDialog",
                    this
                );
                oView.addDependent(this._oNomTicketsDialog);
            }
            oView.setModel(new JSONModel(oData), "nomTicketsModel");
            this._oNomTicketsDialog.open();
        },

        /** Ticket row → the same shared detail dialog the Ticket Key link opens. */
        onNomTicketPress: function (oEvent) {
            const oCtx = oEvent.getSource().getBindingContext("nomTicketsModel");
            if (!oCtx) return;
            this._openTicketDetailDialog(oCtx.getObject());
        },

        onCloseNomTicketsDialog: function () {
            if (this._oNomTicketsDialog) {
                this._oNomTicketsDialog.close();
            }
        }
    };
});

