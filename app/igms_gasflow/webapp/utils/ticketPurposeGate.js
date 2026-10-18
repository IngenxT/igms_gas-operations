sap.ui.define([], () => {
    "use strict";

    // ── Ticket Purpose / Status gate ─────────────────────────────────────────
    // Frontend mirror of srv/utils/allocationUtils.getTicketPurposeGate — keep both in
    // sync. Applies per nomination line item, only to rows that carry a TicketKey:
    //   Purpose  Status        Allocation  Ticketing  Ticket Key shown
    //   1        00            BLOCK       BLOCK      Y   (Full Actualized)
    //   1        78            BLOCK       ALLOW      N   (Partially Actualized)
    //   1        other         BLOCK       ALLOW      N   (Not Completely Actualized)
    //   5        00            ALLOW       ALLOW      N   (Full Reversed)
    //   5        78            BLOCK       BLOCK      N   (Partially Reversed)
    //   5        other         BLOCK       BLOCK      N   (Not Completely Reversed)
    //   blank    blank         ALLOW       ALLOW      N
    //   any other combination BLOCK       ALLOW      N
    const _norm = v => String(v == null ? "" : v).trim();
    const _hasTicketKey = sKey => {
        const s = _norm(sKey);
        return s !== "" && !/^0+$/.test(s);
    };

    return {
        /** True when this row's existing ticket blocks re-allocation. */
        isAllocationBlocked(oRow) {
            if (!_hasTicketKey(oRow?.TicketKey)) return false;
            const sPurpose = _norm(oRow.TicketPurpose);
            const sStatus = _norm(oRow.TicketStatus);
            if (!sPurpose && !sStatus) return false;
            return !(sPurpose === "5" && sStatus === "00");
        },

        /** True when this row's existing ticket blocks re-ticketing. */
        isTicketingBlocked(oRow) {
            if (!_hasTicketKey(oRow?.TicketKey)) return false;
            const sPurpose = _norm(oRow.TicketPurpose);
            const sStatus = _norm(oRow.TicketStatus);
            if (sPurpose === "1") return sStatus === "00";
            if (sPurpose === "5") return sStatus !== "00";
            return false;
        },

        /** Ticket Key is shown on the row in every state except Full Reversed (5/00). */
        isTicketKeyVisible(sTicketKey, sPurpose, sStatus) {
            return _hasTicketKey(sTicketKey) && !(_norm(sPurpose) === "5" && _norm(sStatus) === "00");
        },

        /** Ticket state → Ticket Key link colour:
         *    1/00             Full Actualized             green  (Success)
         *    1/78, 5/78       Partially Actualized/Rev.   yellow (Indication03)
         *    1/other, 5/other Not Completely Actualized/Rev. red (Error)
         *  Anything else (5/00 is never shown, other Purposes, blank) → no colour. */
        valueState(sPurpose, sStatus) {
            const p = _norm(sPurpose);
            const s = _norm(sStatus);
            if (p !== "1" && p !== "5") return "None";
            if (s === "00") return p === "1" ? "Success" : "None";
            return s === "78" ? "Indication03" : "Error";
        },

        /** Human-readable ticket state for issue messages. */
        describe(oRow) {
            const sPurpose = _norm(oRow?.TicketPurpose);
            const sStatus = _norm(oRow?.TicketStatus);
            const sState = sPurpose === "1"
                ? (sStatus === "00" ? "Full Actualized" : sStatus === "78" ? "Partially Actualized" : "Not Completely Actualized")
                : sPurpose === "5"
                    ? (sStatus === "00" ? "Full Reversed" : sStatus === "78" ? "Partially Reversed" : "Not Completely Reversed")
                    : "Purpose " + (sPurpose || "NA");
            return sState + " (Purpose " + (sPurpose || "NA") + ", Status " + (sStatus || "NA") + ")";
        }
    };
});
