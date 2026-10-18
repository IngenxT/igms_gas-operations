sap.ui.define([
    "com/ingenx/igmsgasflow/utils/ari006Rules",
    "com/ingenx/igmsgasflow/utils/ticketPurposeGate"
], (ARI006Rules, TicketPurposeGate) => {
    "use strict";

    // ── Allocation & Ticketing — formatters ──────────────────────────────────
    // Single responsibility: pure display formatters (dates, quantities, GDA
    // Hybrid/Entry-Point row-aware formatting). No side effects beyond reading
    // `this` for the handful that delegate to another formatter on the mixin.
    return {
        /** Ticket Key is shown on the row in every state except Full Reversed (5/00). */
        formatTicketKeyVisible: function (sTicketKey, sPurpose, sStatus) {
            return TicketPurposeGate.isTicketKeyVisible(sTicketKey, sPurpose, sStatus);
        },

        /** Ticket Key link colour by ticket state (see TicketPurposeGate.valueState). */
        fmtTicketKeyState: function (sPurpose, sStatus) {
            return TicketPurposeGate.valueState(sPurpose, sStatus);
        },

        /** Icon paired with fmtTicketKeyState, so the state doesn't rely on colour alone. */
        fmtTicketKeyIcon: function (sPurpose, sStatus) {
            const mIcons = {
                Success: "sap-icon://sys-enter-2",
                Indication03: "sap-icon://alert",
                Error: "sap-icon://error"
            };
            return mIcons[TicketPurposeGate.valueState(sPurpose, sStatus)] || "";
        },

        /** Ticket Key tooltip — the ticket state in words, e.g. "Partially Actualized (Purpose 1, Status 78)". */
        fmtTicketKeyTooltip: function (sPurpose, sStatus) {
            return TicketPurposeGate.describe({ TicketPurpose: sPurpose, TicketStatus: sStatus }) +
                " — click to view ticket execution details";
        },

        formatDate: function (value) {
            if (!value) return "";

            let oDate;

            if (typeof value === "string") {
                let match = value.match(/\/Date\((\d+)\)\//);
                if (match) {
                    oDate = new Date(parseInt(match[1]));
                } else {
                    oDate = new Date(value);
                }
            } else if (value instanceof Date) {
                oDate = value;
            }

            if (!oDate || isNaN(oDate)) return value;

            let dd = String(oDate.getDate()).padStart(2, '0');
            let mm = String(oDate.getMonth() + 1).padStart(2, '0');
            let yyyy = oDate.getFullYear();

            return `${dd}-${mm}-${yyyy}`;
        },

        // ── Expand Dialogs ───────────────────────────────────────────────────────

        fmtDate: function (v) {
            if (!v) return "";
            const d = new Date(v);
            if (isNaN(d.getTime())) return String(v);
            return String(d.getDate()).padStart(2, "0") + "-" + String(d.getMonth() + 1).padStart(2, "0") + "-" + d.getFullYear();
        },

        fmtQty: function (v) {
            const n = parseFloat(v);
            if (v === null || v === undefined || v === "" || isNaN(n) || n === 0) return "—";
            return n.toLocaleString("en-IN", { minimumFractionDigits: 3, maximumFractionDigits: 3 });
        },

        // Third Party Uploaded Qty / Qty to Allocate — unlike fmtQty, a genuine 0 is a
        // real reading (partner uploaded/allocated nothing) and must display as 0.000,
        // not "—". "—" is reserved for actually missing/null data.
        fmtTpQty: function (v) {
            const n = parseFloat(v);
            if (v === null || v === undefined || v === "" || isNaN(n)) return "—";
            return n.toLocaleString("en-IN", { minimumFractionDigits: 3, maximumFractionDigits: 3 });
        },

        fmtHHCust: function (sType, sCust, sBusLoc) {
            if (sType === "GROUP") return sBusLoc || "";
            return sCust || "";
        },
        fmtHHStr:       function (sType, v)         { return sType === "GROUP" ? "" : (v || ""); },
        fmtHHDate:      function (sType, v)         { return sType === "GROUP" ? "" : this.fmtDate(v); },
        // Hybrid/Entry-Point Qty columns (SCADA Meter, Bifurcated/Allocated Qty, GCV/NCV)
        // — a genuine 0/0.000 (e.g. an Entry Point reading with Upload Flag set and
        // nothing allocated) is a real reading and must display as 0.000, never blanked
        // out; only a truly missing value (null/undefined/blank/NaN) shows "—". Relies
        // on gdaTransform.js's _numOrNull keeping blank ('') and 0 apart upstream —
        // both used to collapse to the same 0 before reaching this formatter.
        fmtHHQty: function (sType, v) {
            if (sType === "GROUP") return "";
            const n = parseFloat(v);
            if (v === null || v === undefined || v === "" || isNaN(n)) return "—";
            return n.toLocaleString("en-IN", { minimumFractionDigits: 3, maximumFractionDigits: 3 });
        },
        fmtHHRoleText:  function (sType)            { return sType === "GROUP" ? "" : sType === "PRIMARY" ? "PRIMARY" : "HYBRID"; },
        fmtHHRoleState: function (sType)            { return sType === "GROUP" ? "None" : sType === "PRIMARY" ? "Warning" : "Information"; },
        fmtHHAllocState:function (sType)            { return sType === "GROUP" ? "None" : "Information"; },
        fmtHHBalText:   function (sType, bShow, sState, fDiff) {
            if (sType === "GROUP" || !bShow) return "";
            if (!sState) return "";
            if (sState === "ok") return "Balanced";
            const abs = Math.round(Math.abs(fDiff) * 1000) / 1000;
            return sState === "warn" ? "Short " + abs + " SM³" : "Over " + abs + " SM³";
        },
        fmtHHBalState: function (sType, sState) { return (sType === "GROUP" || !sState) ? "None" : (sState === "ok" ? "Success" : sState === "warn" ? "Warning" : "Error"); },
        fmtHHBalIcon:  function (sType, sState) { return (sType === "GROUP" || !sState) ? "" : (sState === "ok" ? "sap-icon://accept" : sState === "warn" ? "sap-icon://alert" : "sap-icon://error"); },

        // ── Formatters ───────────────────────────────────────────────────────────

        _roundHalfUp: function (value, dp) {
            return Number(Math.round(value + "e" + dp) + "e-" + dp);
        },

        /** Allocated Qty input cell fill — Delivery Point vs Redelivery Point contract.
         *  Style class only (see AllocationNTicketing.css antAllocDeliveryCell/
         *  antAllocRedeliveryCell) — purely visual grouping, distinct from the row's own
         *  Source coloring (antRowSystem/antRowManual/antRowPortal/antRowNoRank). */
        fmtAllocQtyClass: function (sLocationType) {
            return sLocationType === "DELIVERY" ? "antAllocDeliveryCell" : sLocationType === "REDELIVERY" ? "antAllocRedeliveryCell" : "";
        },

        // ── ARI006 Business Rule (Reject) — client-side pre-check ────────────────
        // Same row shape/matching logic as srv/utils/ari006Rules.js's own
        // evaluateRowARI006 (see app/.../utils/ari006Rules.js) — flags a row the
        // backend's own copy would exclude from Ticketing, so the user sees it
        // immediately on the Scheduled Items table instead of only after pressing
        // Create Ticket. aRules is bound from ari006Model>/rules (see
        // nominationTable._loadGasDays), already parsed once per Go-press —
        // never fetched/parsed per cell. This is a pre-check only: processTicketing.js
        // remains the authoritative, final gate at ticket-post time.
        _ari006Hit: function (sLocationType, sDeliveryPoint, sRedeliveryPoint, sContractType, sServiceType, sPartner, sGasday, aRules) {
            if (!aRules || !aRules.length) return null;
            const row = {
                LocationType: sLocationType,
                DeliveryPoint: sDeliveryPoint,
                RedeliveryPoint: sRedeliveryPoint,
                ContractType: sContractType,
                ServiceType: sServiceType,
                Partner: sPartner,
                Gasday: sGasday
            };
            return ARI006Rules.evaluateRowARI006(row, aRules, ARI006Rules.dateKey(new Date()));
        },
        fmtARI006Icon: function (...a) { return this._ari006Hit(...a) ? "sap-icon://alert" : ""; },
        fmtARI006State: function (...a) { return this._ari006Hit(...a) ? "Error" : "None"; },
        fmtARI006Text: function (...a) {
            const hit = this._ari006Hit(...a);
            return hit ? hit.message : "";
        },

        // ── SCADA Row Selection → Stream Details ─────────────────────────────────

        // STREAM-WISE REMOVED: onSelectLocationItem dropped — stream detail drill-down no longer needed

        // ── Column Show / Hide ───────────────────────────────────────────────────

        // ── DataIssuesDialog ─────────────────────────────────────────────────────

        /** Ticket Key is shown on the row only for a Fully Actualized ticket —
         *  TicketPurpose 1 (Field ticket) with TicketStatus 00; hidden in every other case. */
        fmtTicketKeyVisible: function (sTicketKey, sPurpose, sStatus) {
            return !!String(sTicketKey || "").trim()
                && String(sPurpose || "").trim() === "1"
                && String(sStatus || "").trim() === "00";
        },

        fmtIssueTransport: function (sTs, sTsName) { return sTsName ? `${sTs} – ${sTsName}` : (sTs || ""); },
        fmtIssueLocation:  function (sLoc, sLocDesc) { return sLocDesc ? `${sLoc} – ${sLocDesc}` : (sLoc || ""); },
        fmtIssueNomination:function (sKey, sItem) { return sKey ? `${sKey}/${sItem || ""}` : ""; },
        fmtIssuePartner:   function (sPartner, sPartnerName) { return sPartnerName ? `${sPartner} – ${sPartnerName}` : (sPartner || ""); }

    };
});
