sap.ui.define(["sap/base/Log"], function (Log) {
    "use strict";

    const oLog = Log.getLogger("igms.gasflow.utils.ari006Rules");

    // ── ARI006 business-rule evaluation — client-side mirror ─────────────────────
    // Direct JS port of srv/utils/ari006Rules.js's fetchARI006Rules/evaluateRowARI006 —
    // same FIELD_HANDLERS registry and matching logic, kept in sync deliberately so
    // the Scheduled Items table can flag a Reject-blocked row immediately on load,
    // before the user ever presses Create Ticket (the backend's own copy in
    // processTicketing.js remains the authoritative, final gate at ticket time).
    // See the backend file's own header comment for the full design rationale —
    // every condition field lives in ONE registry entry here; adding a new field
    // never touches parseARI006Rules/evaluateRowARI006 themselves.

    const dateKey = v => String(v == null ? "" : v).slice(0, 10);

    /** Parses a Gasday Range condition value into { start, end }, or null when
     *  blank/unparseable. Accepts the admin UI's own JSON shape,
     *  {"from":"YYYY-MM-DD","to":"YYYY-MM-DD"} (the actual fieldValue format), and the
     *  older "YYYY-MM-DD - YYYY-MM-DD" dash string, in case any existing rule still
     *  carries that shape — kept in sync with srv/utils/ari006Rules.js's own copy. */
    function parseGasdayRange(s) {
        const sVal = String(s || "").trim();
        if (!sVal) return null;
        if (sVal.startsWith("{")) {
            let o;
            try { o = JSON.parse(sVal); } catch (e) { return null; }
            const start = dateKey(o.from);
            const end = dateKey(o.to);
            return (start && end) ? { start: start, end: end } : null;
        }
        const m = sVal.match(/^(\d{4}-\d{2}-\d{2})\s*-\s*(\d{4}-\d{2}-\d{2})$/);
        return m ? { start: m[1], end: m[2] } : null;
    }

    /** Same Daily/Fortnight/Monthly release-date cadence as the backend's own copy. */
    function computeTicketReleaseDate(gasday, ticketType) {
        const gd = dateKey(gasday);
        if (!gd) return null;
        const d = new Date(gd + "T00:00:00Z");
        if (isNaN(d.getTime())) return null;
        const sType = String(ticketType || "").trim().toUpperCase();

        if (sType === "DAILY") {
            const rel = new Date(d.getTime());
            rel.setUTCDate(rel.getUTCDate() + 1);
            return dateKey(rel.toISOString());
        }
        if (sType === "MONTHLY") {
            return dateKey(new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth() + 1, 1)).toISOString());
        }
        if (sType === "FORTNIGHT") {
            const day = d.getUTCDate();
            const rel = day <= 15
                ? new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), 16))
                : new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth() + 1, 1));
            return dateKey(rel.toISOString());
        }
        return null;
    }

    /** Default matcher for a plain equality condition field — blank rule value means
     *  "no constraint", same convention every field in FIELD_HANDLERS shares. */
    function eqField(rowField) {
        return (row, parsed) => !parsed || (row[rowField] || "") === parsed;
    }

    // fieldKey → handler. Add a row here to support a new condition field — simple
    // equality needs only { match: eqField('RowField') }; anything needing its own
    // parsing/comparison supplies parse/match directly. BUSINESS_LOCATION is NOT
    // here — it's structural (selects Delivery/Redelivery side), handled directly
    // in parseARI006Rules/evaluateRowARI006 — see the backend file's own comment.
    const FIELD_HANDLERS = {
        CONTRACT_TYPE: { match: eqField("ContractType") },
        SERVICE_PROFILE: { match: eqField("ServiceType") },
        CUSTOMER: { match: eqField("Partner") },
        // Row field is TransportSystem (ScheduledNomItems' own field name) — Tsyst is
        // only the raw S/4 field name used elsewhere — kept in sync with the backend's
        // own copy in srv/utils/ari006Rules.js.
        TRANSPORT_SYSTEM: { match: eqField("TransportSystem") },

        GASDAY_RANGE: {
            parse: parseGasdayRange,
            match: (row, parsed, ctx) => !parsed || (ctx.sRowDay >= parsed.start && ctx.sRowDay <= parsed.end)
        },
        TICKET_TYPE: {
            match: (row, parsed, ctx) => {
                if (!parsed) return true;
                const releaseDate = computeTicketReleaseDate(row.Gasday, parsed);
                return !(releaseDate && ctx.today >= releaseDate);
            }
        }
    };

    /**
     * Parses the raw getBusinessRule OData response (its `value` array, already
     * $expand'd conditions/rows/fields, filtered to ARI006+isActive+isActiveRule)
     * into evaluatable descriptors — same shape/logic as the backend's
     * fetchARI006Rules, just operating on an already-fetched array instead of
     * running the query itself.
     * @param {object[]} aRawRules
     * @returns {object[]}
     */
    function parseARI006Rules(aRawRules) {
        const parsed = [];
        const oWarnedOperator = new Set(); // "ruleID|rowSequence" — warn once per offending row
        for (const rule of (aRawRules || [])) {
            if (rule.actionType !== "Reject") continue;
            for (const cond of (rule.conditions || [])) {
                for (const row of (cond?.rows || [])) {
                    const fields = row.fields;
                    if (!fields?.length) continue;

                    // Every row becomes its own independent descriptor below, and
                    // evaluateRowARI006 blocks on the FIRST matching one in the flat
                    // list — rows are unconditionally OR'd together, matching
                    // conditionalOperator="OR" (the only value the admin UI sets on
                    // any row after the first). A value this architecture can't
                    // represent (e.g. "AND") is still silently treated as OR — warn
                    // so a misconfigured rule doesn't go unnoticed. See the backend
                    // file's own copy of this same comment for the full rationale.
                    const sCondOp = String(row.conditionalOperator || "").trim().toUpperCase();
                    if (sCondOp && sCondOp !== "NULL" && sCondOp !== "OR") {
                        const sOpWarnKey = `${rule.ruleID}|${row.rowSequence}`;
                        if (!oWarnedOperator.has(sOpWarnKey)) {
                            oWarnedOperator.add(sOpWarnKey);
                            oLog.warning(`unsupported conditionalOperator "${row.conditionalOperator}" on rule ${rule.ruleID} row ${row.rowSequence} — every row is evaluated as OR regardless; this rule may not behave as configured`);
                        }
                    }

                    // Blank fieldValue is a valid "no specific Location" rule (e.g. a
                    // Transport-System-wide block) — same "blank = no constraint"
                    // convention every other field follows; NOT dropped here. See
                    // evaluateRowARI006's own handling of an empty businessLocation.
                    const oLocField = fields.find(f => f.fieldKey === "BUSINESS_LOCATION");
                    const businessLocation = oLocField?.fieldValue || "";

                    const fieldConditions = [];
                    for (const f of fields) {
                        if (f.fieldKey === "BUSINESS_LOCATION") continue; // structural, not an AND-condition
                        const handler = FIELD_HANDLERS[f.fieldKey];
                        if (!handler) continue; // unmapped — same silent-skip as the backend (no console here to warn into)
                        const parseFn = handler.parse || (v => v || "");
                        fieldConditions.push({ key: f.fieldKey, parsed: parseFn(f.fieldValue || "") });
                    }

                    parsed.push({
                        ruleID: rule.ruleID,
                        message: rule.messageToShow || `${rule.ruleID}: Ticketing blocked for this Business Location`,
                        validFrom: rule.validFrom,
                        validTo: rule.validTo,
                        fieldConditions,
                        businessLocation,
                        side: /redelivery/i.test(oLocField?.fieldLabel || "") ? "REDELIVERY" : "DELIVERY"
                    });
                }
            }
        }
        return parsed;
    }

    /**
     * Evaluates one ScheduledNomItems row (Location/LocationType/DeliveryPoint/
     * RedeliveryPoint/ContractType/ServiceType/Partner/Gasday) against parsed
     * ARI006 rules — identical matching logic to the backend's evaluateRowARI006.
     * @param {object} row
     * @param {object[]} aParsedRules
     * @param {string} today - dateKey string
     * @returns {{blocked:boolean, message:string, ruleID:string}|null}
     */
    function evaluateRowARI006(row, aParsedRules, today) {
        const sRowDay = dateKey(row.Gasday);
        const ctx = { sRowDay, today };

        ruleLoop:
        for (const rule of (aParsedRules || [])) {
            if (sRowDay && (rule.validFrom > sRowDay || rule.validTo < sRowDay)) continue;

            if (rule.businessLocation) {
                // Delivery-side rule checks the row's own DeliveryPoint; Redelivery-side
                // rule checks the row's own RedeliveryPoint — per rule, off the raw row,
                // not a single computed LocationType/sSide gate — see the backend's own
                // copy of this same comment (srv/utils/ari006Rules.js) for why.
                const sSideLoc = rule.side === "REDELIVERY" ? row.RedeliveryPoint : row.DeliveryPoint;
                if (!sSideLoc || rule.businessLocation !== sSideLoc) continue;
            } else {
                // No Location named (e.g. a Transport-System-wide block) — applies
                // regardless of Delivery/Redelivery side, gated purely by whichever
                // OTHER conditions the rule sets. The caller reports against the row's
                // own already-resolved Location either way.
                if (!row.Location) continue;
            }

            for (const { key, parsed } of rule.fieldConditions) {
                if (!FIELD_HANDLERS[key].match(row, parsed, ctx)) continue ruleLoop;
            }

            return { blocked: true, message: rule.message, ruleID: rule.ruleID };
        }
        return null;
    }

    return {
        dateKey, parseGasdayRange, computeTicketReleaseDate,
        parseARI006Rules, evaluateRowARI006
    };
});
