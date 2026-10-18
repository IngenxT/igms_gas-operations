/* checksum : 9829b0263b233c469a3522b87ece9189 */
@cds.external : true
@m.IsDefaultEntityContainer : 'true'
@sap.message.scope.supported : 'true'
@sap.supported.formats : 'atom json xlsx'
service GMSNOMLOG_SRV {
  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity GetNomLogSet {
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
    @sap.label : 'Document No'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ContractNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nom. key item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key NominationItem : String(10) not null;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Timestamp : DateTime not null;
    @sap.unicode : 'false'
    @sap.label : 'Message type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MsgIndicator : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocumentType : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nomination key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NominationKey : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Material : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Delivery Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DeliveryPoint : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Redelivery Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RedelivryPoint : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Trans system'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TransportSystem : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Source'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Source : String(10) not null;
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ProposedDnq : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'Approved DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ApprovedDnq : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Unit of Measure'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Text'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Message : String(200) not null;
    @sap.unicode : 'false'
    @sap.label : 'Created By'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Createdby : String(15) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Created Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Createddate : Timestamp not null;
    @sap.unicode : 'false'
    @sap.label : 'Created Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Createdtime : Time not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity ConfNomiLogSet {
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
    @sap.label : 'Contract No'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ContractNo : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Nomination Logs'
  entity xGMSxCONFIRMNOM_LOGS {
    @sap.display.format : 'Date'
    @sap.label : 'Gas Day'
    @sap.quickinfo : 'Gas Day Date'
    key Gasday : Date not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document No'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Nomination key item'
    @sap.quickinfo : 'Nomination Key Item'
    key NominationItem : String(10) not null;
    @odata.Type : 'Edm.DateTimeOffset'
    @sap.label : 'Short Time Stamp'
    @sap.quickinfo : 'UTC Time Stamp in Short Form (YYYYMMDDhhmmss)'
    key Timestamp : DateTime not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Message type'
    @sap.quickinfo : 'Message type: S Success, E Error, W Warning, I Info, A Abort'
    key MsgIndicator : String(1) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Counter'
    @sap.quickinfo : 'Count parameters'
    key LogItem : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document Type'
    DocumentType : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination key'
    @sap.quickinfo : 'Nomination (technical) Key'
    NominationKey : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    Material : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivery Point'
    DeliveryPoint : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Redelivery Point'
    @sap.quickinfo : 'Re-Delivery Ponit'
    RedelivryPoint : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    TransportSystem : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Source'
    Source : String(10);
    @sap.label : 'DNQ'
    @sap.quickinfo : 'daily nomination Quantity'
    ProposedDnq : Decimal(13, 3);
    @sap.label : 'Approved DNQ'
    ApprovedDnq : Decimal(13, 3);
    @sap.label : 'Unit of Measure'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.label : 'Text'
    @sap.quickinfo : 'Text for translation'
    Message : String(200);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
  };
};

