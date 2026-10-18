sap.ui.define([
    "sap/ui/mdc/odata/v4/TableDelegate",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator"
], (TableDelegate, Filter, FilterOperator) => {
    "use strict";

    const CSNNominationLogsTableDelegate = Object.assign({}, TableDelegate);

    // GetNominationLogs is a small, fixed CDS projection — static propertyInfo
    // avoids a metamodel round trip and keeps Sort/Filter p13n working even
    // though the remote S/4 service marks every field non-sortable/filterable
    // (that flag only governs the remote Gateway's own SmartFilterBar hints).
    const PROPERTY_INFO = [
        { key: "Gasday", path: "Gasday", label: "Gas Day", dataType: "Edm.Date", sortable: true, filterable: true },
        { key: "ContractNo", path: "ContractNo", label: "Contract No", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "NominationItem", path: "NominationItem", label: "Nomination Item", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "Timestamp", path: "Timestamp", label: "Time Stamp", dataType: "Edm.DateTimeOffset", sortable: true, filterable: true },
        { key: "MsgIndicator", path: "MsgIndicator", label: "Message Type", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "LogItem", path: "LogItem", label: "Counter", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "DocumentType", path: "DocumentType", label: "Document Type", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "NominationKey", path: "NominationKey", label: "Nomination Key", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "Material", path: "Material", label: "Material", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "DeliveryPoint", path: "DeliveryPoint", label: "Delivery Point", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "RedelivryPoint", path: "RedelivryPoint", label: "Redelivery Point", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "TransportSystem", path: "TransportSystem", label: "Transport System", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "Source", path: "Source", label: "Source", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "ProposedDnq", path: "ProposedDnq", label: "Proposed DNQ", dataType: "Edm.Decimal", sortable: true, filterable: true },
        { key: "ApprovedDnq", path: "ApprovedDnq", label: "Approved DNQ", dataType: "Edm.Decimal", sortable: true, filterable: true },
        { key: "Uom", path: "Uom", label: "UoM", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "Message", path: "Message", label: "Message", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "Createdby", path: "Createdby", label: "Created By", dataType: "Edm.String", sortable: true, filterable: true },
        { key: "Createddate", path: "Createddate", label: "Created Date", dataType: "Edm.Date", sortable: true, filterable: true },
        { key: "Createdtime", path: "Createdtime", label: "Created Time", dataType: "Edm.TimeOfDay", sortable: true, filterable: true }
    ];

    CSNNominationLogsTableDelegate.fetchProperties = function () {
        return Promise.resolve(PROPERTY_INFO.slice());
    };

    // Sentinel filter used when no Gas Day range is set yet (initial open, or after
    // Close clears the payload) — keeps the table in a clean, empty, bound state
    // via the normal rebind mechanism instead of fetching unfiltered/unbounded rows.
    const NO_RANGE_FILTER = new Filter({ path: "Gasday", operator: FilterOperator.EQ, value1: "1900-01-01" });

    /**
     * Sets the entity path and injects the mandatory Gas Day range filter, plus the
     * optional quickFilter MsgIndicator filter, on every rebind. gasdayFrom/gasdayTo/
     * msgIndicator are written directly onto the table's delegate payload by the
     * controller (onLogsGasDayRangeChange / onLogsMsgIndicatorFilter) before calling
     * oTable.rebind() — sap.ui.mdc.Table has no public binding-info hook outside the
     * delegate, so the payload object is the only place to pass these controller-
     * owned filters through.
     */
    CSNNominationLogsTableDelegate.updateBindingInfo = function (oTable, oBindingInfo) {
        TableDelegate.updateBindingInfo.apply(this, arguments);
        oBindingInfo.path = "/GetNominationLogs";

        const oPayload = oTable.getPayload() || {};
        if (!oPayload.gasdayFrom || !oPayload.gasdayTo) {
            oBindingInfo.filters = NO_RANGE_FILTER;
            return;
        }

        const aMandatory = [new Filter({
            path: "Gasday",
            operator: FilterOperator.BT,
            value1: oPayload.gasdayFrom,
            value2: oPayload.gasdayTo
        })];
        if (oPayload.msgIndicator) {
            aMandatory.push(new Filter({ path: "MsgIndicator", operator: FilterOperator.EQ, value1: oPayload.msgIndicator }));
        }
        const oMandatory = aMandatory.length === 1 ? aMandatory[0] : new Filter({ filters: aMandatory, and: true });

        const aExisting = [].concat(oBindingInfo.filters || []);
        oBindingInfo.filters = aExisting.length
            ? new Filter({ filters: [...aExisting, oMandatory], and: true })
            : oMandatory;
    };

    return CSNNominationLogsTableDelegate;
});
