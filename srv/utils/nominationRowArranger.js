// srv/utils/nominationRowArranger.js
'use strict';

const { normDoc } = require('./nomSourceFetch');

/**
 * Arranges nomination records across multiple Gas Days.
 *
 * Order of Output:
 * - Sorted chronologically by Gas Day
 *   └── Within each Gas Day:
 *       ├── Redelivery Contract
 *       │   ├── Corresponding / Delivery Contracts (linked via Master/DocNo)
 *       │   └── Linked Contracts
 *       └── Standalone / Unlinked Contracts
 *
 * @param {Array<Object>} aRows - Raw rows from xGMSxNOMSOURCE
 * @param {Array<Object>} [aJoinRows] - Rows from getLinkedContracts
 *   (xGMSxLINKCONT_NOMSOURCE_JOIN: LINKCONT/Contract_NO/linkcont_flag), needed
 *   to resolve LinkContexist='X' rows into real LINKED siblings. The join
 *   entity carries no Gasday of its own, so pass every row the caller has —
 *   membership in each day's own contract index naturally scopes matches.
 * @returns {Array<Object>} - Clean flat array formatted for table binding
 */
function arrangeNominationsMultiGasDay(aRows, aJoinRows = []) {
  if (!Array.isArray(aRows) || aRows.length === 0) return [];

  // 1. Group raw records by normalized Gas Day key
  const gasDayGroups = new Map();

  for (const row of aRows) {
    // Fall back to a single bucket for a missing/blank Gasday rather than
    // dropping the row — Gasday is a mandatory key field so this should be
    // rare, but a row must never silently vanish from the output.
    const rawGasDay = String(row.Gasday || row["Gas Day"] || "").trim() || "UNASSIGNED";

    if (!gasDayGroups.has(rawGasDay)) {
      gasDayGroups.set(rawGasDay, []);
    }
    gasDayGroups.get(rawGasDay).push(row);
  }

  // 2. Sort Gas Days chronologically
  const parseGasDay = (dStr) => {
    // Handles ISO "YYYY-MM-DD" or standard Indian format "DD-MM-YYYY"
    if (dStr.includes("-")) {
      const parts = dStr.split("-");
      if (parts[0].length === 4) {
        return new Date(parts[0], parts[1] - 1, parts[2]).getTime(); // YYYY-MM-DD
      } else if (parts[2].length === 4) {
        return new Date(parts[2], parts[1] - 1, parts[0]).getTime(); // DD-MM-YYYY
      }
    }
    return new Date(dStr).getTime() || 0;
  };

  const sortedGasDays = Array.from(gasDayGroups.keys()).sort(
    (a, b) => parseGasDay(a) - parseGasDay(b)
  );

  const finalOutput = [];

  // 3. Process each Gas Day independently
  for (const currentGasDay of sortedGasDays) {
    const dayRows = gasDayGroups.get(currentGasDay);
    const dayResult = arrangeSingleDay(dayRows, currentGasDay, aJoinRows);
    finalOutput.push(...dayResult);
  }

  return finalOutput;
}

/**
 * Internal helper to sort and link rows strictly within a single Gas Day
 */
function arrangeSingleDay(dayRows, gasDay, aJoinRows) {
  // Normalize row properties and build composite keys
  const normalize = (r) => {
    const contractNo = String(r.ContractNo || r["Contract No"] || "").trim();
    const item = String(r.Item || "").trim();
    const versn = String(r.Versn ?? r["Versn"] ?? "").trim();
    const nomItem = String(r.NominationItem ?? r["Nomination Item"] ?? "").trim();
    const master = String(r.MasterContractNo || r["Master Contract"] || "").trim();
    const corrDoc = String(r.CorrespondingDocNo || r["Corresponding Doc No"] || "").trim();
    // LinkContexist is an 'X'/blank existence flag, not a contract number — the
    // real linked contracts come from the join rows resolved below.
    const linkCont = String(r.LinkContexist || r["Link Contract"] || "").trim();
    const delPoint = String(r.DeliveryPoint || r["Delivery Point"] || "").trim();
    const redelPoint = String(r.RedeliveryPoint || r["Redelivery Point"] || "").trim();

    return {
      raw: r,
      // ContractNo+Item alone isn't unique within a day — multiple
      // NominationItem line items (10, 20, 30...) or Versn revisions share
      // it; omitting them collides distinct rows onto one key and drops one.
      key: `${contractNo}_${item}_${versn}_${nomItem}`,
      contractNo,
      // Leading-zero-stripped match keys — ContractNo can come back unpadded
      // (e.g. '18200990') while CorrespondingDocNo holds '0018200990', or the
      // reverse; same normDoc gtaRightToCure.js pairs GTA legs with.
      docKey: normDoc(contractNo),
      corrKey: normDoc(corrDoc),
      item,
      master: master && master !== "NaN" ? master : "",
      corrDoc,
      linkCont,
      isRedelivery: Boolean(redelPoint),
      isDelivery: Boolean(delPoint)
    };
  };

  const normRows = dayRows.map(normalize);

  // ── LinkContexist group resolution ─────────────────────────────────────
  // Verified against live xGMSxLINKCONT_NOMSOURCE_JOIN data: a row flagged
  // LinkContexist='X' shows up as the join's Contract_NO (child) side, and
  // LINKCONT is a separate group id shared by every contract in that link
  // group — it is not itself a ContractNo in xGMSxNOMSOURCE. So resolution
  // must go Contract_NO -> LINKCONT (this row's group) -> every other
  // Contract_NO sharing that LINKCONT (its linked siblings).
  const groupIdByContract = new Map(); // Contract_NO -> LINKCONT
  const siblingsByGroup = new Map();   // LINKCONT -> Set<Contract_NO>
  for (const jr of aJoinRows || []) {
    if (jr.linkcont_flag !== "X") continue;
    const group = String(jr.LINKCONT ?? "").trim();
    const child = String(jr.Contract_NO ?? "").trim();
    if (!group || !child) continue;
    groupIdByContract.set(normDoc(child), group);
    if (!siblingsByGroup.has(group)) siblingsByGroup.set(group, new Set());
    siblingsByGroup.get(group).add(normDoc(child));
  }

  // Index maps scoped strictly to this single Gas Day
  const byContractNo = new Map(); // keyed by docKey
  const byMasterContract = new Map();
  const byCorrDoc = new Map();    // keyed by corrKey

  for (const item of normRows) {
    // Group by ContractNo
    if (!byContractNo.has(item.docKey)) byContractNo.set(item.docKey, []);
    byContractNo.get(item.docKey).push(item);

    // Group by Master Contract
    if (item.master) {
      if (!byMasterContract.has(item.master)) byMasterContract.set(item.master, []);
      byMasterContract.get(item.master).push(item);
    }

    // Group by Corresponding Doc No
    if (item.corrKey) {
      if (!byCorrDoc.has(item.corrKey)) byCorrDoc.set(item.corrKey, []);
      byCorrDoc.get(item.corrKey).push(item);
    }
  }

  const sortedList = [];
  const processedKeys = new Set();

  const pushRow = (item, role, parentContract = "") => {
    if (processedKeys.has(item.key)) return false;
    processedKeys.add(item.key);

    sortedList.push({
      ...item.raw,
      RowCategory: role,           // "REDELIVERY", "CORRESPONDING_DELIVERY", "LINKED", "STANDALONE"
      ParentContractNo: parentContract,
      DisplayGasDay: gasDay
    });
    return true;
  };

  // Step A: Process all Redelivery Points first — grouped by MasterContractNo
  // so that two separate redelivery legs sharing the same master contract
  // (but not otherwise connected via LinkContexist) land as adjacent family
  // blocks in the output, instead of scattered wherever each leg naturally
  // falls in fetch order. Single-pass insertion-order bucketing, same pattern
  // as _sortByNominationItem in balancingScheduling-service.js: a bucket's
  // final position is where its FIRST member was encountered; a row without a
  // MasterContractNo gets its own single-row bucket and keeps its original
  // relative position.
  const redeliveryRowsRaw = normRows.filter(r => r.isRedelivery);
  const mMasterBucket = new Map();
  let masterlessSeq = 0;
  for (const r of redeliveryRowsRaw) {
    const k = r.master || `__no_master_${masterlessSeq++}`;
    if (!mMasterBucket.has(k)) mMasterBucket.set(k, []);
    mMasterBucket.get(k).push(r);
  }
  const redeliveryRows = [].concat(...mMasterBucket.values());

  for (const parent of redeliveryRows) {
    if (processedKeys.has(parent.key)) continue;

    // 1. Redelivery Contract
    pushRow(parent, "REDELIVERY", parent.contractNo);

    // 2. Paired Delivery Contract via Master Contract within the same day —
    // skip a peer whose own CorrespondingDocNo names a *different* contract;
    // when a master contract has multiple redelivery legs, that peer belongs
    // to its own direct pairing below (step 3), not to whichever redelivery
    // row iterates first. This check depends only on the peer's own field, so
    // it holds correctly regardless of which parent in redeliveryRows it's
    // evaluated against — no separate pass needed.
    if (parent.master && byMasterContract.has(parent.master)) {
      const peers = byMasterContract.get(parent.master);
      for (const peer of peers) {
        if (peer.key === parent.key || !peer.isDelivery) continue;
        if (peer.corrKey && peer.corrKey !== parent.docKey) continue;
        pushRow(peer, "CORRESPONDING_DELIVERY", parent.contractNo);
      }
    }

    // 3. Paired Delivery Contract via CorrespondingDocNo (bidirectional, padding-tolerant)
    if (parent.corrKey && byContractNo.has(parent.corrKey)) {
      for (const corr of byContractNo.get(parent.corrKey)) {
        pushRow(corr, "CORRESPONDING_DELIVERY", parent.contractNo);
      }
    }
    if (byCorrDoc.has(parent.docKey)) {
      for (const corr of byCorrDoc.get(parent.docKey)) {
        pushRow(corr, "CORRESPONDING_DELIVERY", parent.contractNo);
      }
    }

    // 4. Linked Contracts via LinkContexist — resolve this row's own link
    // group (Contract_NO -> LINKCONT), then pull in every sibling Contract_NO
    // in that group that also exists in today's dataset and isn't already
    // claimed as some other contract's direct CorrespondingDocNo pairing.
    if (parent.linkCont === "X") {
      const groupId = groupIdByContract.get(parent.docKey);
      const siblings = groupId ? siblingsByGroup.get(groupId) : null;
      if (siblings) {
        for (const siblingContractNo of siblings) {
          if (siblingContractNo === parent.docKey) continue;
          if (byContractNo.has(siblingContractNo)) {
            for (const linked of byContractNo.get(siblingContractNo)) {
              pushRow(linked, "LINKED", parent.contractNo);
            }
          }
        }
      }
    }
  }

  // Step B: Append remaining rows for this Gas Day (pure standalone or unlinked
  // delivery rows), sorted by ContractNo — raw fetch order otherwise left
  // DeliveryPoint-only contracts scattered arbitrarily at the tail.
  const remaining = normRows
    .filter(item => !processedKeys.has(item.key))
    .sort((a, b) => {
      const na = Number(a.contractNo), nb = Number(b.contractNo);
      if (!Number.isNaN(na) && !Number.isNaN(nb) && na !== nb) return na - nb;
      return a.contractNo.localeCompare(b.contractNo);
    });

  for (const item of remaining) {
    pushRow(item, "STANDALONE", "");
  }

  return sortedList;
}

module.exports = { arrangeNominationsMultiGasDay };
