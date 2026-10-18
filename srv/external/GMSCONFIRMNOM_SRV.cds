/* checksum : 9e693b8ae3cb8555d9a09a5739ebad19 */
@cds.external : true
@m.IsDefaultEntityContainer : 'true'
@sap.message.scope.supported : 'true'
@sap.supported.formats : 'atom json xlsx'
service GMSCONFIRMNOM_SRV {
  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity Conf_nomiSet {
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Gas Day'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Gasday : Timestamp not null;
    nom_configSet : Association to many nom_configSet {  };
    GmsConfNomiNav : Association to many Conf_nomi_subSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity Conf_nomi_subSet {
    @sap.unicode : 'false'
    @sap.label : 'Document No'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ContractNo : String(10) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Gas Day'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Gasday : Timestamp not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Item : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nom. key item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key NominationItem : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Versn : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Delivery Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key DeliveryPoint : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Redelivery Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key RedelivryPoint : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Gross Cal. Value'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Avggcv : Double;
    @sap.unicode : 'false'
    @sap.label : 'Maste Agrmt. No'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Mastercontno : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Net Cal. Value'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Avgncv : Double;
    @sap.unicode : 'false'
    @sap.label : 'Int. Consump. Flag'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Icindicator : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Geographical Area ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GA_ID : String(4);
    @sap.unicode : 'false'
    @sap.unit : 'IcAllocUom'
    @sap.label : 'IC Allocated Qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IcAllocQty : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'GA ID DCQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GA_ID_DCQ : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'IC Allocated UoM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    IcAllocUom : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Customer'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Customer : String(10);
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'GA ID Proposed DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GA_ID_PDNQ : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'GA ID Scheduled DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GA_ID_SDNQ : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Source'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Source : String(10);
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'GA ID Location wise'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GA_ID_LOCDNQ : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Nomination key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NominationKey : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Sold-to Party'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SoldToParty : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Vendor'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vendor : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Document Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocumentType : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Trans system'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TransportSystem : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Zstat : String(4);
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'Daily ContractQty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DeliveryDcq : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'RDCQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RedeliveryDcq : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Unit of Measure'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ProposedDnq : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'Approved DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ApprovedDnq : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'RePublish DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RepublishDnq : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Time To'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ValidTo : Time;
    @sap.unicode : 'false'
    @sap.label : 'Service Profile'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ServiceProfile : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Time From'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ValidFrom : Time;
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Material : String(40);
    @sap.unicode : 'false'
    @sap.label : 'Sales Purchase Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SalesPurchInd : String(1);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Timestamp : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Event Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Event : String(40);
    @sap.unicode : 'false'
    @sap.label : 'Long comment'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Remarks : String(255);
    @sap.unicode : 'false'
    @sap.label : 'Nom. Flag'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Flag : String(6);
    @sap.unicode : 'false'
    @sap.label : 'Action'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Action : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Path'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Path : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Customer Group'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CustGrp : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Created By'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Createdby : String(15);
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Created Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Createddate : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Created Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Createdtime : Time;
    @sap.unicode : 'false'
    @sap.label : 'Changed By'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Changedby : String(15);
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Change Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Changeddate : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Change Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Changedtime : Time;
    to_Return : Association to many toReturnSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ConversionRequest {
    @sap.unicode : 'false'
    @sap.label : 'Request ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key RequestId : String(4) not null;
    ToItems : Association to many ConversionItem {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ConversionItem {
    @sap.unicode : 'false'
    @sap.label : 'Nomination key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key NominationKey : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nom. key item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key NominationItem : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'GCV'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GCV : Double not null;
    @sap.unicode : 'false'
    @sap.label : 'NCV'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NCV : Double not null;
    @sap.unicode : 'false'
    @sap.unit : 'ScheduledUoM'
    @sap.label : 'Scheduled Quantity'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ScheduledQty : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Scheduled Quantity UoM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    ScheduledUoM : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Target UoM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    TargetUoM : String(3) not null;
    @sap.unicode : 'false'
    @sap.unit : 'TargetUoM'
    @sap.label : 'Target Quantity'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TargetQty : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MsgType : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Message : String(220) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity nom_configSet {
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Docind : String(10) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Doctype : String(10) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key schtype : String(10) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key nomtype : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'One Location One Customer'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key OL_OC : Boolean not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity toReturnSet {
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Gas Day'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Gasday : DateTime not null;
    @sap.unicode : 'false'
    @sap.label : 'DocumentNo'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Vbeln : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Type : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Class'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Id : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Number : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Text'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Message : String(220) not null;
    @sap.unicode : 'false'
    @sap.label : 'Log Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LogNo : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LogMsgNo : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Variable'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MessageV1 : String(50) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Variable'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MessageV2 : String(50) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Variable'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MessageV3 : String(50) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Variable'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MessageV4 : String(50) not null;
    @sap.unicode : 'false'
    @sap.label : 'Parameter Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Parameter : String(32) not null;
    @sap.unicode : 'false'
    @sap.label : 'Parameter line'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Row : Integer not null;
    @sap.unicode : 'false'
    @sap.label : 'Field name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Field : String(30) not null;
    @sap.unicode : 'false'
    @sap.label : 'Logical system'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    System : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Linkcont & Nomsource join'
  entity xGMSxLINKCONT_NOMSOURCE_JOIN {
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key ITEM : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Link Contract'
    key LINKCONT : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document No'
    @sap.quickinfo : 'Document Number'
    Contract_NO : String(10);
    linkcont_flag : String(1);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Nomination Source for Scheduling'
  entity xGMSxNOMSOURCE {
    @sap.display.format : 'Date'
    @sap.label : 'Gas Day'
    @sap.quickinfo : 'Gas Day Date'
    key Gasday : Date not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document No'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Version'
    key Versn : String(3) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Nomination key item'
    @sap.quickinfo : 'Nomination Key Item'
    key NominationItem : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination key'
    @sap.quickinfo : 'Nomination (technical) Key'
    NominationKey : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Event Type'
    @sap.quickinfo : 'Nomination Event'
    Event : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document Type'
    ContractType : String(4);
    @sap.label : 'Doc. Type Descript.'
    @sap.quickinfo : 'Short Description of Purchasing Document Type'
    ContractTypeName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    MasterContractNo : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sold-to Party'
    Partner : String(10);
    @sap.label : 'Name of Customer'
    PartnerName : String(80);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    TransportSystem : String(10);
    @sap.label : 'System name'
    @sap.quickinfo : 'OIL-TSW: Transport system name'
    TransportSystemName : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivery Point'
    DeliveryPoint : String(10);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    DeliveryPointName : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Redelivery Point'
    @sap.quickinfo : 'Re-Delivery Ponit'
    RedeliveryPoint : String(20);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    RedeliveryPointName : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    Material : String(40);
    @sap.label : 'Material Description'
    MaterialName : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Parameter Value'
    @sap.quickinfo : 'Service Parameter Value'
    Rank : String(50);
    @sap.label : 'Daily ContractQty'
    @sap.quickinfo : 'Daily Contractual Quantity'
    DeliveryDCQ : Decimal(13, 3);
    @sap.label : 'RDCQ'
    @sap.heading : ''
    RedeliveryDCQ : Decimal(13, 3);
    @sap.label : 'DNQ'
    @sap.quickinfo : 'daily nomination Quantity'
    ProposedDNQ : Decimal(13, 3);
    @sap.label : 'DNQ'
    @sap.quickinfo : 'daily nomination Quantity'
    PrevProposedDNQ : Decimal(13, 3);
    @sap.label : 'DNQ'
    @sap.quickinfo : 'daily nomination Quantity'
    PostBalancingDNQ : Decimal(13, 3);
    @sap.label : 'RePublish DNQ'
    @sap.quickinfo : 'Re-Publish DNQ'
    RepublishDNQ : Decimal(13, 3);
    @sap.label : 'Approved DNQ'
    ApprovedDNQ : Decimal(13, 3);
    @sap.label : 'Allocated Qty'
    @sap.quickinfo : 'Allocated Quantity'
    SavedAllocatedQty : Decimal(13, 3);
    @sap.label : 'Allocated qty UOM'
    @sap.quickinfo : 'Unit of Measure for Allocated Quantity Field'
    @sap.semantics : 'unit-of-measure'
    SavedAllocatedUOM : String(3);
    @sap.label : 'Scheduled qty'
    ScheduledQty : Decimal(13, 3);
    @sap.label : 'SchedUoM'
    @sap.quickinfo : 'Scheduled UoM'
    @sap.semantics : 'unit-of-measure'
    ScheduledUoM : String(3);
    ProposedScheduledDiff : Decimal(14, 3);
    @sap.label : 'SchedUoM'
    @sap.quickinfo : 'Scheduled UoM'
    @sap.semantics : 'unit-of-measure'
    ProposedScheduledDiffUoM : String(3);
    @sap.label : 'TRUE'
    @sap.quickinfo : 'Data element for domain BOOLE: TRUE (=''X'') and FALSE (='' '')'
    isConfirmRequired : Boolean;
    MaxRedeliveryDCQ : Decimal(17, 3);
    MinRedeliveryDCQ : Decimal(17, 3);
    MaxDeliveryDCQ : Decimal(17, 3);
    MinDeliveryDCQ : Decimal(17, 3);
    @sap.label : 'Unit of Measure'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    UOM : String(3);
    @sap.label : 'Gross Cal. Value'
    @sap.quickinfo : 'Gross Calorific Value'
    Avggcv : Double;
    @sap.label : 'Net Cal. Value'
    @sap.quickinfo : 'Net Calorific Value'
    Avgncv : Double;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Geographical Area ID'
    GA_ID : String(10);
    @sap.label : 'GA ID DCQ'
    GA_ID_DCQ : Decimal(13, 3);
    @sap.label : 'GA ID Proposed DNQ'
    GA_ID_PDNQ : Decimal(13, 3);
    @sap.label : 'GA ID Scheduled DNQ'
    GA_ID_SDNQ : Decimal(13, 3);
    @sap.label : 'GA ID Location wise'
    @sap.quickinfo : 'GA ID Location wise DNQ'
    GA_ID_LOCDNQ : Decimal(13, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Item status'
    @sap.quickinfo : 'Nomination Item status'
    NominationStatus : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Source'
    Source : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Field Value'
    @sap.quickinfo : 'Contract Field Value'
    ServiceType : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Field Value'
    @sap.quickinfo : 'Contract Field Value'
    CustomerInd : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Field'
    @sap.quickinfo : 'Contract Field ID'
    CustomerIndId : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Document'
    CorrespondingDocNo : String(10);
    LinkContexist : String(1);
    @sap.unit : 'MonthlyConsumptionUom'
    @sap.label : 'DNQ'
    @sap.quickinfo : 'daily nomination Quantity'
    MonthlyConsumptionQty : Decimal(13, 3);
    @sap.label : 'Base Unit of Measure'
    @sap.semantics : 'unit-of-measure'
    MonthlyConsumptionUom : String(3);
    @sap.unit : 'MonthlyContractualUom'
    @sap.label : 'DNQ'
    @sap.quickinfo : 'daily nomination Quantity'
    MonthlyContractualQty : Decimal(13, 3);
    @sap.label : 'Base Unit of Measure'
    @sap.semantics : 'unit-of-measure'
    MonthlyContractualUom : String(3);
    @sap.unit : 'MonthlyRemainingUom'
    @sap.label : 'DNQ'
    @sap.quickinfo : 'daily nomination Quantity'
    MonthlyRemainingQty : Decimal(13, 3);
    @sap.label : 'Base Unit of Measure'
    @sap.semantics : 'unit-of-measure'
    MonthlyRemainingUom : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Address No. in ADRC'
    AddressNumber : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Search Term 2'
    CustomerKind : String(20);
    @sap.label : 'OD(Over drawl-GSA)'
    yyoij_od_qty : Decimal(13, 3);
    @sap.label : 'UD(Under drawl-GSA)'
    yyoij_un_qty : Decimal(13, 3);
    @sap.label : 'Authorized Over draw'
    @sap.quickinfo : 'Authorized Over drawl(GSA)'
    yyoij_aod_qty : Decimal(13, 3);
    @sap.label : 'Unauthorized Over dr'
    @sap.quickinfo : 'Unauthorized Over drawl(GSA)'
    yyoij_unaod_qty : Decimal(13, 3);
    @sap.label : 'Overrun(GTA)'
    @sap.quickinfo : 'Overrun(GTA)1'
    yyoij_ovr_qty : Decimal(13, 3);
    @sap.label : 'Authorized Overrun(G'
    @sap.quickinfo : 'Authorized Overrun(GTA)1'
    yyoij_aovr_qty : Decimal(13, 3);
    @sap.label : 'Unauthorized Overrun'
    @sap.quickinfo : 'Unauthorized Overrun(GTA)'
    yyoij_unaovr_qty : Decimal(13, 3);
    @sap.label : 'Daily Imbalance(GTA)'
    yyoij_dimb_qty : Decimal(13, 3);
    @sap.label : 'Contractual Nominate'
    @sap.quickinfo : 'Contractual Nominated qty'
    yyoij_cnom_qty : Decimal(13, 3);
    @sap.label : 'Cont Nom. UOM'
    @sap.quickinfo : 'Contractual Nominated UOM'
    @sap.semantics : 'unit-of-measure'
    yyoij_cnom_uom : String(3);
    @sap.label : 'Status'
    yyoij_status : String(15);
    @sap.label : 'DPI Quantity'
    @sap.quickinfo : 'Daily Positive Imbalance Quantity1'
    yyoij_dpimb_qty : Decimal(13, 3);
    @sap.label : 'DNI Quantity'
    @sap.quickinfo : 'Daily Negative Imbalance Quantity1'
    yyoij_dnimb_qty : Decimal(13, 3);
    @sap.label : 'Cumulative Imb Qty'
    @sap.quickinfo : 'Cumulative Imbalance Quantity'
    yyoij_cumimb_qty : Decimal(13, 3);
    @sap.label : 'Chrg Imb Qty'
    @sap.quickinfo : 'Chargable Imbalance Quantity'
    yyoij_crgimb_qty : Decimal(13, 3);
    @sap.label : 'Cum +ve Imb Qty'
    @sap.quickinfo : 'Cumulative Imbalance Quantity'
    yyoij_pos_cumimb : Decimal(13, 3);
    @sap.label : 'Cum -ve Imb Qty'
    @sap.quickinfo : 'Cumulative Imbalance Quantity'
    yyoij_neg_cumimb : Decimal(13, 3);
    @sap.label : 'Liq. Adjust Qty'
    @sap.quickinfo : 'Liquidated Damages Adjusted qty'
    yyoij_ld_a_qty : Decimal(13, 3);
    @sap.label : 'Liq. Dam. Disc Qty'
    @sap.quickinfo : 'Liquidated Damaages discount'
    yyoij_ld_d_qty : Decimal(13, 3);
    @sap.label : 'Sell or Pay Adj Qty'
    @sap.quickinfo : 'Sell or Pay'
    yyoij_sop_a_qty : Decimal(13, 3);
    @sap.label : 'Sell or Pay Disc qty'
    @sap.quickinfo : 'Sell or Pay discounted qty'
    yyoij_sop_d_qty : Decimal(13, 3);
    @sap.label : 'Sellers SF Adj Qty'
    @sap.quickinfo : 'Sell or Pay'
    yyoij_ssf_a_qty : Decimal(13, 3);
    @sap.label : 'SSF disc'
    @sap.quickinfo : 'Liquidated Damaages discount'
    yyoij_ssf_d_qty : Decimal(13, 3);
    @sap.label : 'Take or Pay Adj Qty'
    @sap.quickinfo : 'Sell or Pay'
    yyoij_top_a_qty : Decimal(13, 3);
    @sap.label : 'Take or Pay Disc qty'
    @sap.quickinfo : 'Sell or Pay discounted qty'
    yyoij_top_d_qty : Decimal(13, 3);
    @sap.label : 'SOP/LD adjusted'
    @sap.quickinfo : 'GTA adjust'
    yyoij_gta_adjust : Boolean;
    @sap.label : 'TOP/SSF Adjusted'
    @sap.quickinfo : 'GSA TOP/SSF adjsuted'
    yyoij_gsa_adjust : Boolean;
    @sap.label : 'Qty for Gujrat DNQ'
    yyoij_gujdnq : Decimal(13, 3);
    @sap.label : 'UOM for Gujrat DNQ'
    @sap.semantics : 'unit-of-measure'
    yyoij_gujdnq_uom : String(3);
    @sap.label : 'DDS Qty'
    @sap.quickinfo : 'Daily DDS Imbalance Quantity1'
    yyoij_dds_qty : Decimal(13, 3);
    @sap.label : 'Allocated Qty'
    @sap.quickinfo : 'Allocated Quantity'
    SavedAllocatedQty2 : Decimal(13, 3);
    @sap.label : 'Primary Indicator'
    @sap.quickinfo : 'Primary Contract Indicator'
    IsPrimaryContract : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket key'
    @sap.quickinfo : 'OIL-TSW: Ticket key'
    TicketKey : String(20);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Item number'
    @sap.quickinfo : 'OIL-TSW: Ticket item number'
    TicketItem : String(6);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Ticket version'
    @sap.quickinfo : 'OIL-TSW: Ticket version'
    TicketVersion : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket Purpose'
    @sap.quickinfo : 'OIL-TSW: Ticket Purpose'
    TicketPurpose : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Return code'
    @sap.quickinfo : 'OIL-TSW: Ticket process return code'
    TicketStatus : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket external no.'
    @sap.quickinfo : 'OIL-TSW: External ticket number'
    TicketExternalNumber : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Item status'
    @sap.quickinfo : 'Nomination Item status'
    TicketItemStatus : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Item sub-status'
    @sap.quickinfo : 'Nomination Item sub-status'
    TicketItemSubStatus : String(1);
    @sap.display.format : 'Date'
    @sap.label : 'Created On'
    @sap.quickinfo : 'Record Creation Date'
    TicketCreationDate : Date;
    @sap.label : 'Created'
    @sap.quickinfo : 'Time of creation'
    TicketCreationTime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    @sap.quickinfo : 'Name of Person Responsible for Creating the Object'
    TicketCreatedByUser : String(12);
    @sap.display.format : 'Date'
    @sap.label : 'Changed On'
    @sap.quickinfo : 'Last Changed On'
    TicketChangedDate : Date;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    @sap.quickinfo : 'Name of Person Who Changed Object'
    TicketChangedByUser : String(12);
    @sap.label : 'Boolean Variable (X = True, - = False, Space = Unknown)'
    @sap.heading : ''
    IsNominationItemClosed : Boolean;
  };
};

