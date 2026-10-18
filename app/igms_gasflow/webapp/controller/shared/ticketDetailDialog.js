sap.ui.define([
    "sap/ui/model/json/JSONModel"
], (JSONModel) => {
    "use strict";

    // ── Ticket Execution Detail Dialog — shared mixin ─────────────────────────────
    // Single responsibility: group raw TktlogDetailHeadSet.to_logtkts diagnostic
    // lines into one row per ticket item, and open the TicketExecDetailDialog
    // fragment against a grouped row. Shared verbatim between dateWiseTicketLogs
    // (one ExecId's worth of rows) and sessionTicketLog (one row per resolved
    // ExecId across a whole ticketing run) — both consume the identical
    // TktlogDetailHeadSet($expand=to_logtkts($expand=TO_DOCFLOW,TO_ERRLOG)) shape,
    // so the grouping/dialog logic must stay identical between them too.

    // S/4 returns this generic application-log message even for executions with no
    // real error — never actual, useful content. Suppressed whenever HasErrors is false.
    const NOISE_MESSAGE_PREFIX = "log not found";

    function _isNoiseMessage(sMessage) {
        return !!sMessage && sMessage.trim().toLowerCase().startsWith(NOISE_MESSAGE_PREFIX);
    }

    // Ticket Purpose → label S/4 prefixes onto MessageSummary ("Reversal: Ticket
    // Actualization Process Completed"), as seen on TicketDetailSet.
    const PURPOSE_LABELS = { "1": "Field ticket", "2": "Correction", "5": "Reversal" };

    /** "19:42:47" (Edm.TimeOfDay) or "PT19H42M47S" (Edm.Time) → seconds; 0 if unparseable. */
    function _timeToSeconds(sTime) {
        const m = /^PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+(?:\.\d+)?)S)?$/.exec(sTime || "")
               || /^(\d{1,2}):(\d{2})(?::(\d{2}(?:\.\d+)?))?$/.exec(sTime || "");
        if (!m) return 0;
        return (parseInt(m[1] || "0", 10) * 3600) + (parseInt(m[2] || "0", 10) * 60) + parseFloat(m[3] || "0");
    }

    /** A log line's ChangedDate/ChangedTime (falling back to Created*) as one
     *  sortable timestamp plus its "dd-mm-yyyy HH:mm:ss" display — same rule as
     *  the Allocation & Ticketing tickets dialog (allocationNTicketing/ticketDetail.js).
     *  The date is UTC midnight, so UTC parts are used for the day. */
    function _lastChanged(r) {
        return r.ChangedDate ? _stamp(r.ChangedDate, r.ChangedTime) : _stamp(r.CreatedDate, r.CreatedTime);
    }

    /** One date + time pair as { ts, text } — see _lastChanged. */
    function _stamp(dDate, sTime) {
        const oDate = dDate ? (dDate instanceof Date ? dDate : new Date(dDate)) : null;
        if (!oDate || isNaN(oDate.getTime())) return { ts: 0, text: "" };
        const iSecs = Math.floor(_timeToSeconds(sTime));
        const pad = n => String(n).padStart(2, "0");
        let sText = `${pad(oDate.getUTCDate())}-${pad(oDate.getUTCMonth() + 1)}-${oDate.getUTCFullYear()}`;
        if (sTime) sText += ` ${pad(Math.floor(iSecs / 3600))}:${pad(Math.floor(iSecs / 60) % 60)}:${pad(iSecs % 60)}`;
        return { ts: oDate.getTime() + iSecs * 1000, text: sText };
    }

    function _versionKey(r) {
        return `${r.TicketVersion || ""}|${r.Purpose || ""}`;
    }

    /** Swaps a "<Purpose label>: ..." MessageSummary's prefix for sPurpose's own label. */
    function _relabelMessage(sMessage, sPurpose) {
        const sLabel = PURPOSE_LABELS[sPurpose];
        if (!sLabel || !sMessage || sMessage.indexOf(":") < 0) return sMessage;
        return `${sLabel}${sMessage.slice(sMessage.indexOf(":"))}`;
    }

    /** Status for a version split off a log line — derived from its own error log. */
    function _statusFromErrlog(aErrlog, sFallback) {
        if (aErrlog.some(e => e.MsgTyp === "E" || e.MsgTyp === "A")) return "E";
        if (aErrlog.some(e => e.MsgTyp === "W")) return "W";
        return sFallback;
    }

    /**
     * S/4 logs only ONE to_logtkts line per ticket item per execution (e.g. the
     * "Field ticket" Version 0 line), yet that line's TO_DOCFLOW/TO_ERRLOG carry
     * records for every version of the ticket — actualization AND its later
     * reversal/correction — each record stamped with its own TicketVersion/Purpose.
     * Splits one grouped row into one row per distinct Version/Purpose found there,
     * each keeping only its own documents/errors, matching the per-version list the
     * Allocation & Ticketing Nom Key drill-down (TicketDetailSet) shows.
     */
    function _splitByVersion(oRow) {
        if (!oRow.TicketKey) return [oRow];

        const aEntries = oRow._logEntries || [oRow];
        const sOwnKey = _versionKey(oRow);
        const aKeys = [...new Set(aEntries.flatMap(e =>
            [...(e.TO_DOCFLOW || []), ...(e.TO_ERRLOG || [])].map(_versionKey)))];
        if (oRow.TicketVersion && !aKeys.includes(sOwnKey)) aKeys.push(sOwnKey);
        if (aKeys.length <= 1 && (!aKeys.length || aKeys[0] === sOwnKey)) return [oRow];

        return aKeys.map(sKey => {
            const [sVersion, sPurpose] = sKey.split("|");
            const bOwn = sKey === sOwnKey;
            const aSplitEntries = aEntries.map(e => {
                const aDocs = (e.TO_DOCFLOW || []).filter(d => _versionKey(d) === sKey);
                const aErrs = (e.TO_ERRLOG || []).filter(d => _versionKey(d) === sKey);
                return {
                    ...e,
                    TicketVersion:  sVersion,
                    Purpose:        sPurpose,
                    TO_DOCFLOW:     aDocs,
                    TO_ERRLOG:      aErrs,
                    // The log line's own message/HasErrors belong to its own version
                    // only — keeps the dialog from synthesizing its error onto others.
                    HasDocs:        aDocs.length ? "X" : "",
                    HasErrors:      bOwn ? e.HasErrors : (aErrs.length ? "X" : ""),
                    MessageSummary: bOwn ? e.MessageSummary : _relabelMessage(e.MessageSummary, sPurpose)
                };
            });
            const aAllErrs = aSplitEntries.flatMap(e => e.TO_ERRLOG);
            return {
                ...oRow,
                TicketVersion:  sVersion,
                Purpose:        sPurpose,
                ProcessStatus:  bOwn ? oRow.ProcessStatus : _statusFromErrlog(aAllErrs, "S"),
                MessageSummary: bOwn ? oRow.MessageSummary : _relabelMessage(oRow.MessageSummary, sPurpose),
                HasDocs:        aSplitEntries.some(e => e.HasDocs)   ? "X" : "",
                HasErrors:      aSplitEntries.some(e => e.HasErrors) ? "X" : "",
                _logEntries:    aSplitEntries
            };
        });
    }

    return {
        /**
         * Collapses multiple to_logtkts diagnostic lines that describe the SAME
         * nomination into a single main-table row. This happens whenever S/4 never
         * assigned a TicketKey (nomination failed before ticket creation) — several
         * Logitm entries ([Final]/[Summary]/[Result] outcome lines) describe the same
         * failed nomination but can each carry a different, not-yet-meaningful
         * TicketItem (e.g. "000000" vs "000010"). Grouping key falls back to just
         * Nomtk/Nomit (TicketItem excluded) when TicketKey is blank, so those lines
         * always collapse together regardless of TicketItem; a real ticket (non-blank
         * TicketKey) groups by TicketKey/TicketItem, which is a no-op there since S/4
         * only ever logs one line per real ticket item. Each real-ticket row is then
         * split per TicketVersion/Purpose found in its documents (_splitByVersion).
         * Every raw entry in the group is kept on `_logEntries` so the detail dialog
         * can still show the full diagnostic trail once opened.
         */
        _groupLogEntries: function (aRaw) {
            const STATUS_PRIORITY = { E: 0, W: 1, P: 2, S: 3 };
            const mGroups = new Map();
            aRaw.forEach(r => {
                // TicketVersion/Purpose are part of the key: an actualization and its
                // later reversal share TicketKey/TicketItem but are separate ticket
                // versions, each with its own generated documents — same split the
                // Allocation & Ticketing Nom Key drill-down shows.
                const sKey = r.TicketKey
                    ? `${r.TicketKey}|${r.TicketItem}|${r.TicketVersion}|${r.Purpose}`
                    : `${r.Nomtk}|${r.Nomit}`;
                if (!mGroups.has(sKey)) mGroups.set(sKey, []);
                mGroups.get(sKey).push(r);
            });

            return [...mGroups.values()].map(aEntries => {
                aEntries.sort((a, b) => String(a.Logitm).localeCompare(String(b.Logitm)));
                // The table's own row (TicketItem/MessageSummary shown to the user)
                // represents the group via its "[Final]" outcome line when one exists
                // — the full trail (every line in the group) still shows once the
                // dialog is opened. Status shown is the worst across the whole group,
                // since a [Final] line's own ProcessStatus may not be the worst one.
                const oFinal = aEntries.find(e => /^\[final\]/i.test(e.MessageSummary || "")) || aEntries[0];
                const sWorstStatus = aEntries.reduce((sWorst, e) =>
                    (STATUS_PRIORITY[e.ProcessStatus] ?? 9) < (STATUS_PRIORITY[sWorst] ?? 9) ? e.ProcessStatus : sWorst,
                    oFinal.ProcessStatus);
                // Group's Last Changed = its most recent line.
                const oLast = aEntries.map(_lastChanged).reduce((a, b) => (b.ts > a.ts ? b : a));
                // Created At = the group's earliest line; Changed At = its latest actual change
                const aCreated = aEntries.map(e => _stamp(e.CreatedDate, e.CreatedTime)).filter(o => o.ts);
                const oCreated = aCreated.length ? aCreated.reduce((a, b) => (b.ts < a.ts ? b : a)) : { ts: 0, text: "" };
                const oChanged = aEntries.map(e => _stamp(e.ChangedDate, e.ChangedTime))
                    .reduce((a, b) => (b.ts > a.ts ? b : a), { ts: 0, text: "" });
                return {
                    ...oFinal,
                    _ts:          oLast.ts,
                    _lastChanged: oLast.text,
                    _createdTs:   oCreated.ts,
                    _createdAt:   oCreated.text,
                    _changedTs:   oChanged.ts,
                    _changedAt:   oChanged.text,
                    ProcessStatus: sWorstStatus,
                    HasErrors: aEntries.some(e => !!e.HasErrors) ? "X" : "",
                    HasDocs:   aEntries.some(e => !!e.HasDocs)   ? "X" : "",
                    _logEntries: aEntries
                };
            // Newest first by Last Changed, like the Allocation & Ticketing tickets
            // dialog; versions split off the same log line share its timestamp, so
            // the latest version (e.g. the reversal) goes above the actualization.
            }).flatMap(_splitByVersion).sort((a, b) =>
                (b._ts - a._ts) ||
                String(b.TicketKey).localeCompare(String(a.TicketKey)) ||
                String(a.TicketItem).localeCompare(String(b.TicketItem)) ||
                String(b.TicketVersion).localeCompare(String(a.TicketVersion)) ||
                String(a.Nomtk).localeCompare(String(b.Nomtk)) ||
                String(a.Nomit).localeCompare(String(b.Nomit)));
        },

        _openTicketDetailDialog: function (oRow) {
            const oView = this.getView();
            if (!this._oTicketDetailDialog) {
                this._oTicketDetailDialog = sap.ui.xmlfragment(
                    oView.getId(),
                    "com.ingenx.igmsgasflow.fragments.TicketExecDetailDialog",
                    this
                );
                oView.addDependent(this._oTicketDetailDialog);
            }

            // The row clicked may represent several collapsed Logitm lines (see
            // _groupLogEntries) — pull TO_DOCFLOW/TO_ERRLOG from every one of them,
            // not just the single representative row, so nothing in the group's
            // diagnostic trail is lost when the dialog opens.
            const aGroupRows = oRow._logEntries || [oRow];

            const aDocflow = aGroupRows.flatMap(r => r.TO_DOCFLOW || []);
            let aErrlog    = aGroupRows.flatMap(r => r.TO_ERRLOG || []);

            // Any line in the group with no TO_ERRLOG of its own — typically because
            // S/4 never assigned a TicketKey (e.g. "ticket key or ticket item is
            // missing"), so ErrorLogSet has nothing to join on — contributes its own
            // MessageSummary as a synthesized Error Log row instead. This is what
            // surfaces the full [Final]/[Summary]/[Result] trail in the fragment even
            // though the main table shows only one collapsed row per ticket item.
            const aSynthesized = aGroupRows
                .filter(r => !(r.TO_ERRLOG && r.TO_ERRLOG.length) && r.HasErrors && r.MessageSummary)
                .map(r => ({
                    SequenceNo:       r.Logitm || "",
                    Nomtk:            r.Nomtk,
                    Nomit:            r.Nomit,
                    MsgTyp:           "E",
                    MsgNo:            "",
                    TSWDate:          null,
                    RefDoc:           "",
                    DocCategory:      "",
                    ErrorDescription: r.MessageSummary
                }));
            aErrlog = [...aErrlog, ...aSynthesized];

            const sMessageSummary = (!oRow.HasErrors && _isNoiseMessage(oRow.MessageSummary))
                ? "" : (oRow.MessageSummary || "");

            oView.setModel(new JSONModel({
                TicketKey:        oRow.TicketKey,
                TicketItem:       oRow.TicketItem,
                TicketVersion:    oRow.TicketVersion,
                Purpose:          oRow.Purpose,
                Nomtk:            oRow.Nomtk,
                Nomit:            oRow.Nomit,
                ProcessStatus:    oRow.ProcessStatus,
                MessageSummary:   sMessageSummary,
                to_docflow:       aDocflow,
                to_errlog_errors: aErrlog,
                docflowCount:     aDocflow.length ? String(aDocflow.length) : "",
                errlogCount:      aErrlog.length  ? String(aErrlog.length)  : ""
            }), "ticketDetailModel");

            // Each tab is only visible when it actually has rows to show (see
            // formatDocflowTabVisible/formatErrlogTabVisible in the fragment binding),
            // independent of ProcessStatus — a Partial/Error row can still carry
            // generated documents, and a Success row can still carry log entries.
            // Select whichever tab ends up visible so the dialog opens straight on
            // real content; if neither has data the tab bar itself hides (see
            // formatTabBarVisible) and nothing needs selecting. Prefer Error Log over
            // Generated Documents when both exist — the error is the reason the user
            // opened the dialog.
            this.byId("IdTicketDetailTabBar")?.setSelectedKey(aErrlog.length ? "errlog" : "docflow");

            this._oTicketDetailDialog.open();
        },

        onCloseTicketDetailDialog: function () {
            if (this._oTicketDetailDialog) {
                this._oTicketDetailDialog.close();
            }
        },

        // ── Formatters (referenced by TicketExecDetailDialog.fragment.xml) ────────

        /** ProcessStatus code → display text */
        formatStatusText: function (sStatus) {
            const map = { S: "Success", E: "Error", W: "Warning", P: "Partial", N: "Not Completed" };
            return map[sStatus] || sStatus || "";
        },

        /** ProcessStatus code → sap.ui.core.ValueState  (Partial → Warning) */
        formatStatusState: function (sStatus) {
            const map = { S: "Success", E: "Error", W: "Warning", P: "Warning", N: "None" };
            return map[sStatus] || "None";
        },

        /** ProcessStatus code → SAP icon URI */
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

        /** Flag ("X"/"Y"/true) → "Yes" / "No" */
        formatBoolText: function (vVal) {
            return (vVal === true || vVal === "X" || vVal === "Y") ? "Yes" : "No";
        },

        /** TicketKey/Nomtk display — S/4 zero-pads both to fixed width (e.g.
         *  "00000000000000072002"); strip the leading zeros for on-screen display
         *  only, keeping at least one digit ("0" stays "0"). Raw value is still what
         *  every filter/lookup/grouping key uses — this is purely cosmetic. */
        formatKeyNoLeadingZeros: function (sVal) {
            if (!sVal) return "";
            return String(sVal).replace(/^0+(?=\d)/, "");
        },

        /** Generated Documents tab visibility — purely data-driven: visible whenever
         *  the row's TO_DOCFLOW actually returned rows, regardless of ProcessStatus
         *  (Success/Partial/Error/Warning can each carry generated documents). */
        formatDocflowTabVisible: function (sDocflowCount) {
            return !!sDocflowCount;
        },

        /** Error Log tab visibility — purely data-driven: visible whenever the row's
         *  TO_ERRLOG actually returned rows, regardless of ProcessStatus. */
        formatErrlogTabVisible: function (sErrlogCount) {
            return !!sErrlogCount;
        },

        /** Tab bar visibility — hide the whole strip when neither tab has anything to
         *  show; the summary strip's own Message field already carries the real
         *  information then. */
        formatTabBarVisible: function (sDocflowCount, sErrlogCount) {
            return this.formatDocflowTabVisible(sDocflowCount) ||
                   this.formatErrlogTabVisible(sErrlogCount);
        },

        /** MessageSummary/RevDoc text visibility — hide if empty/null */
        formatHasValue: function (sVal) {
            return !!(sVal && sVal.trim());
        },

        /** MatYear is Edm.Single/Double on the wire (e.g. "2026.0", "2.026E3") —
         *  truncate to a plain integer year string; 0/blank/NaN → "" (not meaningful). */
        formatMatYear: function (vYear) {
            const nYear = Number(vYear);
            return nYear ? String(Math.trunc(nYear)) : "";
        },

        /** RevDoc flag ("X"/"Y"/true) → Warning state if set, else None */
        formatReversalState: function (vVal) {
            return (vVal === true || vVal === "X" || vVal === "Y") ? "Warning" : "None";
        },

        /** MsgTyp "E" → "Error" text, else "-" */
        formatErrMsgTypeText: function (sType) {
            const map = { E: "Error", W: "Warning", I: "Info" };
            return map[sType] || "-";
        },

        /** MsgTyp → ValueState */
        formatErrMsgTypeState: function (sType) {
            const map = { E: "Error", W: "Warning", I: "Information" };
            return map[sType] || "None";
        }
    };
});
