// srv/utils/ari006Rules.js
'use strict';

// ── ARI006 business-rule evaluation — Ticketing Block ────────────────────────
// Single source of truth for the "Block ticket for Delivery/Redelivery point"
// rule family (ruleAreaCode=ARI006, actionType='Reject') — evaluated once here
// so every caller (today: processTicketing's ARI006 phase) stays in sync,
// same principle ari004Rules.js already established for nomination confirmation.
//
// A Reject rule excludes just the ONE Business Location it names (Delivery or
// Redelivery side — see BUSINESS_LOCATION's own fieldLabel below) from the
// Ticketing run; every OTHER location proceeds unaffected — confirmed business
// behavior ("Reject... for the Business Location Delivery or Redelivery...
// rest will execute"), never a hard block of the whole run.
//
// ── FIELD_HANDLERS — dynamic, per-field condition registry ───────────────────
// Every condition field a rule can carry (as authored in the admin UI, one
// RowFields row per fieldKey) is handled entirely through this ONE table — a
// new field needs ONE entry here, nothing else in this file. Two shapes:
//   - a plain equality field: { match: eqField('SomeRowField') } — matches
//     when the row's own field equals the rule's (or wildcards when the rule
//     left it blank, same "blank = no constraint" convention every field
//     shares).
//   - a "special" field needing its own parsing/comparison (a range, a date-
//     math gate, a multi-row-field lookup — GASDAY_RANGE/TICKET_TYPE below are
//     the two examples today): supply `parse` (raw fieldValue → whatever
//     shape `match` wants, computed once per rule at fetch time) and a custom
//     `match(row, parsed, ctx)` (ctx = { sRowDay, today }).
// BUSINESS_LOCATION is NOT in this table — it isn't an independent AND-
// condition, it's structural: it selects which side (Delivery/Redelivery, via
// its own fieldLabel) every other condition applies to. Its own VALUE follows
// the same "blank = no constraint" convention as everything else, though — a
// rule can name a side (via fieldLabel) with no specific Location, e.g. a
// Transport-System-wide block (BR_049) — it is NOT dropped for that; only a
// row with nothing at all on the rule's own side (no DeliveryPoint for a
// Delivery-side rule) is irrelevant to it. Handled directly in
// fetchARI006Rules/evaluateRowARI006 for that reason.

const dateKey = v => String(v ?? '').slice(0, 10);

/**
 * Parses a Gasday Range condition value into { start, end } (dateKey strings), or
 * null when blank/unparseable — a blank GASDAY_RANGE means "every Gasday". Accepts
 * the admin UI's own JSON shape, {"from":"YYYY-MM-DD","to":"YYYY-MM-DD"} (the actual
 * format fieldValue is stored in), and the older "YYYY-MM-DD - YYYY-MM-DD" dash
 * string, in case any existing rule still carries that shape.
 * @param {string} s @returns {{start:string,end:string}|null}
 */
const parseGasdayRange = s => {
  const sVal = String(s || '').trim();
  if (!sVal) return null;
  if (sVal.startsWith('{')) {
    let o;
    try { o = JSON.parse(sVal); } catch { return null; }
    const start = dateKey(o.from);
    const end = dateKey(o.to);
    return (start && end) ? { start, end } : null;
  }
  const m = sVal.match(/^(\d{4}-\d{2}-\d{2})\s*-\s*(\d{4}-\d{2}-\d{2})$/);
  return m ? { start: m[1], end: m[2] } : null;
};

/**
 * The date (dateKey string) on/after which a ticket for `gasday` is allowed to
 * post, per TICKET_TYPE — business-confirmed cadence:
 *   Daily     — the day after the Gasday itself (T+1, the app's own default).
 *   Fortnight — each month splits into two windows, 1st-15th and 16th-end; a
 *               Gasday in the first window releases on the 16th of the SAME
 *               month, a Gasday in the second window releases on the 1st of
 *               the NEXT month (e.g. 2026-08-01..15 -> 2026-08-16;
 *               2026-08-16..31 -> 2026-09-01).
 *   Monthly   — a Gasday anywhere in a calendar month releases on the 1st of
 *               the NEXT month (e.g. 2026-08-01..31 -> 2026-09-01).
 * Blank/unrecognized TICKET_TYPE -> null (no release-date gate; the rule's
 * other conditions alone decide the match).
 * @param {string|Date} gasday @param {string} ticketType @returns {string|null}
 */
const computeTicketReleaseDate = (gasday, ticketType) => {
  const gd = dateKey(gasday);
  if (!gd) return null;
  const d = new Date(gd + 'T00:00:00Z');
  if (isNaN(d.getTime())) return null;
  const sType = String(ticketType || '').trim().toUpperCase();

  if (sType === 'DAILY') {
    const rel = new Date(d.getTime());
    rel.setUTCDate(rel.getUTCDate() + 1);
    return dateKey(rel.toISOString());
  }
  if (sType === 'MONTHLY') {
    return dateKey(new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth() + 1, 1)).toISOString());
  }
  if (sType === 'FORTNIGHT') {
    const day = d.getUTCDate();
    const rel = day <= 15
      ? new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), 16))
      : new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth() + 1, 1));
    return dateKey(rel.toISOString());
  }
  return null;
};

/** Default matcher for a plain equality condition field — blank rule value (or
 *  no handler match at all) means "no constraint", same convention every
 *  field in FIELD_HANDLERS shares regardless of whether it's simple or
 *  special. @param {string} rowField @returns {(row:object, parsed:string, ctx:object) => boolean} */
const eqField = rowField => (row, parsed) => !parsed || (row[rowField] || '') === parsed;

// fieldKey (Business Rule condition, as authored in the admin UI) → its
// handler. Add a row here to support a new condition field — simple equality
// needs only `match: eqField('RowField')`; anything needing its own
// parsing/comparison supplies `parse`/`match` directly. No other function in
// this file needs to change to support a new field.
const FIELD_HANDLERS = {
  CONTRACT_TYPE: { match: eqField('ContractType') },
  SERVICE_PROFILE: { match: eqField('ServiceType') },
  CUSTOMER: { match: eqField('Partner') },
  // Row field is TransportSystem (ScheduledNomItems' own field name) — Tsyst is only
  // the raw S/4 field name used elsewhere (ActualizeTicket's Tsyst array, value helps).
  TRANSPORT_SYSTEM: { match: eqField('TransportSystem') },

  GASDAY_RANGE: {
    parse: parseGasdayRange,
    match: (row, parsed, ctx) => !parsed || (ctx.sRowDay >= parsed.start && ctx.sRowDay <= parsed.end)
  },
  TICKET_TYPE: {
    match: (row, parsed, ctx) => {
      if (!parsed) return true;
      const releaseDate = computeTicketReleaseDate(row.Gasday, parsed);
      return !(releaseDate && ctx.today >= releaseDate); // release date already reached — no longer applies
    }
  }
  // SERVICEPARAMETER/OPERATOR/COMPARISON_TYPE are part of the shared
  // condition-row template every rule area's admin form uses (see
  // ari004Rules.js) but carry no meaning for ARI006 — deliberately left
  // unregistered, so a blank value on them (as seen on every ARI006 rule so
  // far) is a no-op; a rule author who DOES set one gets a one-time warning
  // log (see fetchARI006Rules) rather than a silently-ignored condition.
};

/**
 * Fetches active ARI006 rules and returns parsed descriptors — same fetch
 * pattern as ari004Rules.fetchARI004Rules. Not cached — rules can change
 * between requests (admin config updates).
 *
 * Every condition field with a FIELD_HANDLERS entry is captured generically
 * into `fieldConditions` (an ordered [{key, parsed}] list — BUSINESS_LOCATION
 * excluded, handled separately as the rule's structural anchor) — a rule
 * author adding a NEW condition field only needs a FIELD_HANDLERS entry, not
 * a change here; evaluateRowARI006 loops this list so an unhandled-but-
 * populated field is still visible (logged once) instead of silently ignored.
 * @param {import('@sap/cds').Service} igmsConfigMetaData
 * @param {import('@sap/cds').Logger} [log]
 * @returns {Promise<object[]>}
 */
const fetchARI006Rules = async (igmsConfigMetaData, log) => {
  const aRules = await igmsConfigMetaData.run(
    SELECT.from('BusinessRules')
      .where({ 'areaOfInterest_ruleAreaCode': 'ARI006', isActive: true, isActiveRule: true })
      .columns('ID', 'ruleID', 'ruleDescription', 'actionType', 'messageToShow',
        'validFrom', 'validTo',
        {
          ref: ['conditions'], expand: [
            'ID', 'conditionSequence', 'conditionType',
            {
              ref: ['rows'], expand: [
                'ID', 'rowSequence', 'conditionalOperator',
                { ref: ['fields'], expand: ['fieldKey', 'fieldLabel', 'fieldValue'] }
              ]
            }
          ]
        }
      )
  );

  const sWarnedUnknown = new Set(); // fieldKey — warn once per key, not once per row
  const sWarnedOperator = new Set(); // "ruleID|rowSequence" — warn once per offending row
  const parsed = [];
  for (const rule of aRules) {
    if (rule.actionType !== 'Reject') continue; // the only actionType this area acts on today
    for (const cond of (rule.conditions || [])) {
      for (const row of (cond?.rows || [])) {
        const fields = row.fields;
        if (!fields?.length) continue;

        // Every row in a condition becomes its own independent descriptor below,
        // and evaluateRowARI006 blocks on the FIRST matching descriptor in the
        // flat list — i.e. rows are unconditionally OR'd together. That happens
        // to be exactly what conditionalOperator='OR' (the only value the admin
        // UI sets on any row after the first, which itself carries the literal
        // string 'NULL' — nothing to combine with yet) means, so it's never been
        // necessary to actually branch on it. But it IS necessary to notice a
        // value this architecture can't represent (e.g. 'AND' — there is no
        // mechanism here for "this row's conditions must ALSO hold alongside a
        // sibling row", since each row anchors to its own single Business
        // Location) rather than silently treating it as OR anyway.
        const sCondOp = String(row.conditionalOperator || '').trim().toUpperCase();
        if (sCondOp && sCondOp !== 'NULL' && sCondOp !== 'OR' && log) {
          const sOpWarnKey = `${rule.ruleID}|${row.rowSequence}`;
          if (!sWarnedOperator.has(sOpWarnKey)) {
            sWarnedOperator.add(sOpWarnKey);
            log.warn(`[ari006Rules] unsupported conditionalOperator "${row.conditionalOperator}" on rule ${rule.ruleID} row ${row.rowSequence} — every row is evaluated as OR regardless; this rule may not behave as configured`);
          }
        }

        // Blank fieldValue is a valid, deliberate "no specific Location" rule (e.g.
        // BR_049, a Transport-System-wide block) — same "blank = no constraint"
        // convention every other condition field follows; NOT dropped here. See
        // evaluateRowARI006's own handling of an empty businessLocation.
        const oLocField = fields.find(f => f.fieldKey === 'BUSINESS_LOCATION');
        const businessLocation = oLocField?.fieldValue || '';

        const fieldConditions = [];
        for (const f of fields) {
          if (f.fieldKey === 'BUSINESS_LOCATION') continue; // structural, not an AND-condition
          const handler = FIELD_HANDLERS[f.fieldKey];
          if (!handler) {
            if (f.fieldValue && log && !sWarnedUnknown.has(f.fieldKey)) {
              sWarnedUnknown.add(f.fieldKey);
              log.warn(`[ari006Rules] unmapped condition fieldKey "${f.fieldKey}" (rule ${rule.ruleID}) — add it to FIELD_HANDLERS or it's silently skipped`);
            }
            continue;
          }
          const parseFn = handler.parse || (v => v || '');
          fieldConditions.push({ key: f.fieldKey, parsed: parseFn(f.fieldValue || '') });
        }

        parsed.push({
          ruleID: rule.ruleID,
          description: rule.ruleDescription,
          message: rule.messageToShow || `${rule.ruleID}: Ticketing blocked for this Business Location`,
          validFrom: rule.validFrom,
          validTo: rule.validTo,
          fieldConditions,
          businessLocation,
          // fieldLabel names which side this Location is ("Delivery"/"Redelivery") —
          // defaults to Delivery when unlabeled, matching every rule seen so far.
          side: /redelivery/i.test(oLocField?.fieldLabel || '') ? 'REDELIVERY' : 'DELIVERY'
        });
      }
    }
  }
  return parsed;
};

/**
 * Evaluates all parsed ARI006 rules against one ScheduledNomItems-shaped row
 * (Location/LocationType/DeliveryPoint/RedeliveryPoint/ContractType/
 * ServiceType/Partner/Gasday, plus whichever fields FIELD_HANDLERS names).
 * validFrom/validTo are checked against the row's own Gasday (a caller's row
 * set can span multiple Gasdays), same as ARI004; every other condition field
 * — GASDAY_RANGE/TICKET_TYPE included — runs through its own FIELD_HANDLERS
 * entry uniformly, so adding a new condition field never touches this loop.
 * @param {object} row
 * @param {object[]} aParsedRules
 * @param {string} today - dateKey string, injectable for tests
 * @returns {{ blocked: boolean, message: string, ruleID: string }|null}
 */
const evaluateRowARI006 = (row, aParsedRules, today) => {
  const sRowDay = dateKey(row.Gasday);
  const ctx = { sRowDay, today };

  ruleLoop:
  for (const rule of aParsedRules) {
    if (sRowDay && (rule.validFrom > sRowDay || rule.validTo < sRowDay)) continue;

    if (rule.businessLocation) {
      // Delivery-side rule checks the row's own DeliveryPoint field; Redelivery-side
      // rule checks the row's own RedeliveryPoint field — read directly off the raw
      // row, per rule, rather than once per row via a single computed LocationType/
      // sSide. LocationType follows BusinessLocation, which prefers whichever side
      // has the GDA reading (scheduledNomItems.js: `loc = gdaAgg.has(rdp) ? rdp :
      // gdaAgg.has(dp) ? dp : rdp || dp`) — a row can end up LocationType=REDELIVERY
      // while still genuinely carrying its own DeliveryPoint value, and a single
      // sSide gate would skip every Delivery-side rule for it entirely. Checking
      // each rule against its own side's raw field instead means a row is always
      // evaluated against whichever of its two fields a given rule actually names.
      const sSideLoc = rule.side === 'REDELIVERY' ? row.RedeliveryPoint : row.DeliveryPoint;
      if (!sSideLoc || rule.businessLocation !== sSideLoc) continue;
    } else {
      // No Location named (e.g. BR_049, a Transport-System-wide block) — applies to
      // this row regardless of Delivery/Redelivery side, gated purely by whichever
      // OTHER conditions the rule sets (TRANSPORT_SYSTEM, CONTRACT_TYPE, ...). The
      // caller reports against the row's own already-resolved r.Location either way
      // (see processTicketing.js), so no side-specific field needs
      // to be read here at all.
      if (!row.Location) continue;
    }

    for (const { key, parsed } of rule.fieldConditions) {
      if (!FIELD_HANDLERS[key].match(row, parsed, ctx)) continue ruleLoop;
    }

    return { blocked: true, message: rule.message, ruleID: rule.ruleID };
  }
  return null;
};

module.exports = {
  FIELD_HANDLERS, eqField,
  dateKey, parseGasdayRange, computeTicketReleaseDate,
  fetchARI006Rules, evaluateRowARI006
};
