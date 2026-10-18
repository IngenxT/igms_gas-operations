# Gas Day Range — Allocation & Ticketing

This file explains the Gas Day range change on the Allocation & Ticketing screen. It also contains a ready-to-use prompt for making the same change in **igms-shipper**.

- **Done in:** `igms_gascockpit` (this project), 17-10-2026
- **To do in:** `igms-shipper` (use the prompt below)

---

## 1. Requirement

On Allocation & Ticketing the whole process ran for **one Gas Day only**. The client wants to select a **Gas Day range** and run the process for several days in one go.

### Decisions confirmed with the client

| Topic | Decision |
|---|---|
| Display | **All days together.** The Scheduled Items table and the 4 SCADA Measurement tables show every day in date order, each with a Gas Day column. Header totals are the sum of all days. |
| On error | **Continue other days.** Each day runs on its own. At the end, one summary shows ✔ or ✖ per day. |
| Max range | **7 days.** A single date still works exactly as before. |

---

## 2. What was changed in igms_gascockpit

The design rule is that every backend function stays **single-day**: the cache, allocation and ticketing all work per Gas Day. The UI calls them **once per day, in date order**. Only one backend change was needed.

### Backend
- `srv/serviceHandlers/allocationTicketing/scheduledNomItems.js`: the `READ ScheduledNomItems` handler accepts several Gas Days in `$filter`. Each day is arranged on its own, with Redelivery→Delivery pairing kept within that day. The days are then joined in date order before paging.

### UI (`app/igms_gasflow/webapp`)
| File | Change |
|---|---|
| `view/allocationNTicketing.view.xml` | The DatePicker is now a `DateRangeSelection`. A Gas Day column was added to the 4 SCADA tables. |
| `fragments/DataIssuesDialog.fragment.xml` | Gas Day column added to all 5 issue tables. |
| `controller/allocationNTicketing.controller.js` | `_currentGasDay` was replaced by `_currentGasDays` (an array). |
| `controller/allocationNTicketing/nominationTable.js` | Range reading and the 7-day check. `_loadGasDays` loads each day and merges the results. Summaries are summed. Issues are tagged per day. Filters and aggregates are scoped per day. |
| `controller/allocationNTicketing/gdaScada.js` | SCADA data is fetched per day and each row is tagged `_gasDay`. Row selection filters by day. |
| `controller/allocationNTicketing/allocationActions.js` | Pre-check runs per day, with one combined dialog. RunAllocateSave runs per day and continues after a failure. A range summary is shown at the end. |
| `controller/allocationNTicketing/ticketingActions.js` | Nomination-change check and pre-check run per day. processTicketing runs per day. All job ids are passed to the results page. All table rows are read (not just the loaded ones). |
| `controller/shared/ticketJobResults.js` | Loads several runs and merges their rows, tagged with the Gas Day. |
| `controller/ticketingRunLogs.controller.js` + view | Rows are sorted by day. A Gas Day column is shown for multi-day runs. |
| `controller/allocationNTicketing/exportUtils.js` | Export file name shows the range. The Gas Day column reads `_gasDay`. |
| `i18n/i18n.properties` | New block of keys: "Allocation & Ticketing — Gas Day range". |

### Tested (QA backend, 14–16 Oct 2026)
- All 3 days load: 21 rows in date order. Totals equal the 3 single days added together.
- Issues and SCADA rows carry the correct day. Selecting a SCADA row filters to that day only.
- Pre-checks run per day. A failing middle day (simulated) does not stop the later days.
- A single day behaves as before.
- Allocate & Save and Ticketing were **not** called for real (stubbed), so nothing was written to S/4.
- **Not tested in a browser yet.** Check it once with `npm run hybrid`.

### Known existing gap (not part of this change)
The **Simulate** button calls `onPressRunAllocation`, which does not exist here or in igms-shipper.

---

## 3. Prompt for igms-shipper

Open Claude Code **inside `/home/user/projects/igms-shipper`** and paste the prompt below.

````
In this project (igms-shipper), the Allocation & Ticketing screen works on one Gas Day at a time. The client wants to select a Gas Day RANGE and run the whole process for multiple days in one go. Implement this.

A finished, tested implementation of exactly this already exists in another project on this machine — the same screen was copied there from shipper and then changed:
  /home/user/projects/igms_gascockpit/app/igms_gasflow/webapp   (UI, namespace com.ingenx.igmsgasflow)
  /home/user/projects/igms_gascockpit/srv/serviceHandlers/allocationTicketing/scheduledNomItems.js   (backend)
  /home/user/projects/igms_gascockpit/GAS_DAY_RANGE_README.md   (summary of the change)
Use it as the reference: diff each file against the shipper version and port the gas-day-range changes. Keep shipper's namespace (com.ingenx.igmsshipper / com/ingenx/igmsshipper) and logger names. Do NOT port anything else that differs (namespace renames, Home page, package.json, etc.).

Agreed business decisions (already confirmed with the client):
1. Display: all days together. Scheduled Items table and the 4 SCADA Measurement tables (Own / Hybrid / Third Party / Entry Point) show every day of the range, in date order, each with a Gas Day column. Header totals = sum of all days.
2. On error: each day runs on its own. If one day fails (S/4 error, or all locations blocked), the other days continue; at the end show one summary listing ✔/✖ per day.
3. Max range: 7 days. A single date (no end date) must still work exactly like today.

Design rule: keep every backend function single-day (the nomination cache, getScheduledNomItemsWithSCADA, getGasAllocationData, getNomSummary, checkGdaReadingChanges, checkNominationChanges, RunAllocateSave, processTicketing are all per Gas Day). The UI calls them once per day, in date order. Only ONE backend change is needed (below).

Changes, file by file:

BACKEND — srv/serviceHandlers/allocationTicketing/scheduledNomItems.js
- READ ScheduledNomItems: accept several Gasday values in $filter (e.g. "(Gasday eq A or Gasday eq B)", also "(Gasday eq A and Location eq X) or (...)"). _extractSimpleFilters already collects all Gasday values. Loop the days in date order, read each day's own nomCache entry, and run the existing steps (TransportSystem filter, CQL where, Redelivery→Delivery stitching) PER DAY via a helper (_arrangeDay) — the same Delivery contract recurs every day, so pairing must never cross days. Concatenate days, then renumber SortSeq and page ($skip/$top/$count) over the combined list.

UI — app/igms_shipper/webapp
- view/allocationNTicketing.view.xml: replace the Gas Day DatePicker (id IdANTFilterGasDay, keep the id) with a DateRangeSelection (displayFormat dd-MM-yyyy, change=.onGasDayChange). Add a first column "Gas Day" bound to {<model>>_gasDay} with formatter .formatDate in the 4 SCADA tables.
- fragments/DataIssuesDialog.fragment.xml: add a first "Gas Day" column (dataIssuesModel>GasDay, .formatDate) to all 5 tables.
- allocationNTicketing.controller.js: replace this._currentGasDay with this._currentGasDays = [] (array of 'yyyy-MM-dd').
- controller/allocationNTicketing/nominationTable.js:
  * add MAX_GAS_DAYS: 7, _getSelectedGasDays() (reads getDateValue/getSecondDateValue, returns every day in the range or null + Error state if empty or > 7 days), _buildGasDaysFilter(aDays) (OR of Gasday EQ).
  * rename _filterScadaByGasDay(sDay) → _loadGasDays(aDays): one getScheduledNomItemsWithSCADA per day (extract _fetchScheduledDay); merge SCADA data, locations; sum NomSummary with a new _sumNomSummaries (add qty fields, take UOM from first day); build Data Issues per day and tag each row with GasDay; a day that fails to load is reported and left out, others still show.
  * _bindNomTable / _bindExpandNomTable: Gasday filter = _buildGasDaysFilter(this._currentGasDays).
  * _refreshAggregates: one getNomSummary per day and sum; with SCADA rows selected, each day uses only the rows selected on that day (skip days with none). _getSelectedTpPairs(aRows) takes optional rows.
  * _applyDataIssuesFilter: when SCADA rows are selected, an issue only matches if its Location was selected on the issue's own GasDay.
  * _checkGdaReadingChanges(aDays), onRefreshScada, onRefreshNomItems, onClearFilters, _clearLoadedData: use the array.
- controller/allocationNTicketing/gdaScada.js:
  * _fetchGdaData(aDays): one getGasAllocationData per day (Promise.all), tag every row with _gasDay, concatenate in date order.
  * _buildGdaSelectionFilter: AND each row filter with (Gasday eq row._gasDay); move the per-row logic into _buildGdaRowFilter.
  * _gdaRowKey: prefix with _gasDay.
- controller/allocationNTicketing/allocationActions.js — onPressAllocateNSave:
  * read ALL table rows with a new _requestTableNominationItems() (binding.requestContexts(0, Infinity) — getContexts only returns loaded rows, the table loads 150 at a time).
  * for each day: _runClientSideAllocationPreflightChecks(sGasDay, dayRows, bAnySegmentSelection) — scope SCADA model rows to r._gasDay === sGasDay and _buildSegmentFilter(sGasDay). bAnySegmentSelection is computed once over the whole selection exactly like the old single-day check (so a day with no selected rows has nothing in scope). In a range, skip days with zero nominations.
  * tag issues with GasDay, show ONE _openPreCheckDialog (new bShowGasDay → prefix each item title with the date), then call RunAllocateSave per eligible day sequentially (_callRunAllocateSave(payload, sGasDay)); catch per day and continue.
  * 1 day → existing outcome messages unchanged; range → new _showRangeAllocateSaveOutcome (per-day ✔/✖, saved count, S/4 errors, skipped locations). Then reload all days.
- controller/allocationNTicketing/ticketingActions.js — onPressTicket:
  * checkNominationChanges per day. If ALL days changed → existing message + reload + stop. Otherwise warn, and show the changed days as a "Nominations Changed" pre-check issue; other days continue.
  * per-day _runClientSidePreflightChecks({ gasDay, noms: dayRows, hasExplicitSegmentSelection, explicitSegmentFilter: _buildSegmentFilterPayload(sGasDay) }) with SCADA rows scoped to the day; one combined pre-check dialog (include GasDay in its failed-count key).
  * 1 day → existing _submitFilteredTicketing unchanged. Range → new _submitRangeTicketing: processTicketing per day (extract _callProcessTicketing), collect JobIds, one summary; "View Ticket Logs" navigates to RouteTicketingRunLogs with jobId = ids joined by ",".
- controller/shared/ticketJobResults.js: _loadJobResults accepts comma-separated ids → new _loadMultiJobResults (poll each job, merge rows, tag rows with _gasDay from job.gasday, one warning listing failed/expired runs). Single id = old behaviour.
- controller/ticketingRunLogs.controller.js + view: sort rows by _gasDay then Nomination Key/Item; runModel>/multiDay = jobId contains ","; add Gas Day column (runRowsModel>_gasDay) visible only when multiDay.
- controller/allocationNTicketing/exportUtils.js: file name uses _getExportGasDayLabel() ("from_to"); SCADA export Gas Day column reads _gasDay.
- i18n/i18n.properties: add the "Allocation & Ticketing — Gas Day range" block of keys from the reference project's i18n (antGasDayRangePlaceholder … antRangeNothingSubmitted).

Rules:
- Work on a new git branch. Don't commit unless I ask.
- Never call RunAllocateSave or processTicketing for real while testing (they write to S/4 QA) — stub them.
- Single-day behaviour must stay exactly as it is today.
- Verify: start the app (cds watch --profile hybrid on a free port), load 14-10-2026 to 16-10-2026, check the ScheduledNomItems multi-day $filter returns all days in date order, summaries equal the sum of single days, SCADA rows and issues carry their day, a SCADA row selected on one day filters to that day only, and (with the write actions stubbed) a failing middle day doesn't stop the later days. Finish with a short report of what changed and what was tested.
````

### Tips
- Start the session inside the `igms-shipper` folder so the paths match.
- The other session can read the gascockpit files directly, so it mostly copies tested code.
- To fix the missing **Simulate** handler, ask for it as a separate task.
