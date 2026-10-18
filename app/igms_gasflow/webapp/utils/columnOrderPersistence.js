sap.ui.define(["sap/m/MessageBox"], function (MessageBox) {
    "use strict";

    // ── Column Order Persistence — shared by BalancingScheduling (IdCSNTable) and
    // Allocation & Ticketing (IdANTTicketItemTbl) ────────────────────────────────
    // Saves a sap.ui.table.Table's column order to localStorage (per-browser only,
    // never synced across devices/users, never sent to the backend) — but only when
    // the user explicitly opts in via a confirm prompt shown right after a drag
    // reorder. Declining leaves the reorder in place for this session only; nothing
    // is persisted, and the table reverts to its saved/default order next visit.
    //
    // Columns are matched by their view-LOCAL id (oView.getLocalId), never the
    // control's own runtime id — a view instance's own id prefix is regenerated on
    // every reload, so the raw runtime id would never match a previously saved one.

    /**
     * Restores a previously saved column order, if any, by re-inserting each column
     * at its saved index — sap.ui.table.Table has no direct "set order" API, but
     * insertColumn() on an already-aggregated column simply moves it.
     * @param {sap.ui.table.Table} oTable
     * @param {sap.ui.core.mvc.View} oView
     * @param {string} sStorageKey
     */
    function restoreColumnOrder(oTable, oView, sStorageKey) {
        let aSavedLocalIds;
        try {
            aSavedLocalIds = JSON.parse(localStorage.getItem(sStorageKey) || "null");
        } catch (e) {
            aSavedLocalIds = null;
        }
        if (!Array.isArray(aSavedLocalIds) || !aSavedLocalIds.length) return;

        const oByLocalId = new Map();
        oTable.getColumns().forEach(oColumn => {
            const sLocalId = oView.getLocalId(oColumn.getId());
            if (sLocalId) oByLocalId.set(sLocalId, oColumn);
        });

        let iIndex = 0;
        aSavedLocalIds.forEach(sLocalId => {
            const oColumn = oByLocalId.get(sLocalId);
            if (!oColumn) return; // a column since removed/renamed — skip, don't break the rest
            oTable.insertColumn(oColumn, iIndex);
            iIndex++;
        });
    }

    /**
     * Attaches the table's own columnMove event: on every completed drag reorder,
     * asks the user whether to remember the new arrangement, and persists it to
     * localStorage only on an explicit yes.
     * @param {sap.ui.table.Table} oTable
     * @param {sap.ui.core.mvc.View} oView
     * @param {string} sStorageKey
     */
    function attachColumnOrderPersistence(oTable, oView, sStorageKey) {
        oTable.attachColumnMove(() => {
            // columnMove fires WHILE the drag completes, before the framework applies
            // the reorder (it's cancelable via preventDefault, which this handler never
            // calls) — deferred one tick so getColumns() below reflects the new order,
            // not the one being replaced.
            setTimeout(() => {
                MessageBox.confirm(
                    "Save this column arrangement for next time you open this screen?",
                    {
                        title: "Save Column Arrangement",
                        onClose: sAction => {
                            if (sAction !== MessageBox.Action.OK) return;
                            const aLocalIds = oTable.getColumns()
                                .map(oColumn => oView.getLocalId(oColumn.getId()))
                                .filter(Boolean);
                            try {
                                localStorage.setItem(sStorageKey, JSON.stringify(aLocalIds));
                            } catch (e) {
                                // localStorage unavailable (private mode/blocked) — setting simply won't persist
                            }
                        }
                    }
                );
            }, 0);
        });
    }

    return { restoreColumnOrder, attachColumnOrderPersistence };
});
