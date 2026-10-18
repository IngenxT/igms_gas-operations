/* checksum : 88c845b1a7fbd4db2319ce45ee8b1ffb */
@cds.external : true
@m.IsDefaultEntityContainer : 'true'
@sap.message.scope.supported : 'true'
@sap.supported.formats : 'atom json xlsx'
service GMSVALUEHELP_SRV {
  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity Interconnect_pointSet {
    @sap.unicode : 'false'
    @sap.label : 'Transport 1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Transport1 : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Transport 2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Transport2 : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Interconnect Location'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IntLoc : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IntLocNam : String(60) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity GET_CVI_LINK {
    @sap.unicode : 'false'
    @sap.label : 'Customer'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    key Customer : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Supplier'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    key Supplier : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Placeholder 1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Field1 : String(200);
    @sap.unicode : 'false'
    @sap.label : 'Placeholder 2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Field2 : String(200);
    @sap.unicode : 'false'
    @sap.label : 'Placeholder 3'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Field3 : String(200);
    @sap.unicode : 'false'
    @sap.label : 'Placeholder 4'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Field4 : String(200);
    @sap.unicode : 'false'
    @sap.label : 'Placeholder 5'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Field5 : String(200);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity DisplayDocument {
    @sap.unicode : 'false'
    @sap.label : 'Reference Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Refno : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Item : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Doc. ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key DocId : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sales Document'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ContractNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Character 100'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FileName : String(100) not null;
    @sap.unicode : 'false'
    @sap.label : 'Text'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FileNameDisplay : String(100) not null;
    @sap.unicode : 'false'
    @sap.label : 'Char255'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Username : String(255) not null;
    @sap.unicode : 'false'
    @sap.label : 'Text'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UsernameDisplay : String(255) not null;
    @sap.display.format : 'Date'
    @sap.unicode : 'false'
    @sap.label : 'Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocDate : Date;
    @sap.unicode : 'false'
    @sap.label : 'Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocTime : Time;
    @sap.unicode : 'false'
    @sap.label : 'TRUE'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FinalFlag : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Display to Customer?'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IndFlag : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Char'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UploadType : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Char'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StorageType : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocType : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Object Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ObjectType : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Object ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocNumber : String(50) not null;
    @sap.unicode : 'false'
    @sap.label : 'User Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatedBy : String(12) not null;
    @sap.display.format : 'Date'
    @sap.unicode : 'false'
    @sap.label : 'Created Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatedDate : Date;
    @sap.unicode : 'false'
    @sap.label : 'Created Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatedTime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity DownloadDocument {
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key FileName : String not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key DocumentId : String(50) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key DocumentItem : String not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key DocumentNumber : String not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocumentPath : String not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocumentVersion : String not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocumentPart : String not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocumentType : String not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity UploadDocument {
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key DocName : String(10) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FileName : String(50) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocItem : String(6) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ContractNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocumentId : String(40) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UploadType : String(40) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StorageType : String(40) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Username : String(250) not null;
    @sap.unicode : 'false'
    @sap.label : 'Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MarkedAsFinal : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CustomerDisplay : Boolean not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Mimetype : String(100) not null;
    @Core.MediaType : 'application/octet-stream'
    blob : LargeBinary;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity SourceLocMap_distanceSet {
    @sap.unicode : 'false'
    @sap.label : 'Customer Location'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Clocation : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Source'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Source : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Withdraw PT'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Withdrawpt : String(50) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location name'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Clocationname : String(60);
    @sap.unicode : 'false'
    @sap.label : 'Interconnect Point'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    InterconnectPt : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Distance'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Distance : Decimal(8, 3);
    @sap.unicode : 'false'
    @sap.label : 'Entitle Tariff Zone'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EnTariffZone : String(4);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity LocPoint_MapSet {
    @sap.unicode : 'false'
    @sap.label : 'Location ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Locid : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Pblnr : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Pbltyp : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Trans system'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Tsyst : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Origin'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Delivery_Point : Boolean not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    isDeliveryPoint : String(3) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    isInterconnect : String(3) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    isRedeliveryPoint : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Blocking ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LocidBloind : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Deletion ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LocidDelind : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Location name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Locnam : String(60) not null;
    @sap.unicode : 'false'
    @sap.label : 'Blocked'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    oifspblBloind : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Will be Deleted'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    oifspblDelind : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Destination'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Redelivery_Point : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'TS name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tsnam : String(60) not null;
    @sap.unicode : 'false'
    @sap.label : 'Blocking ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TsystBloind : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Deletion ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TsystDelind : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Shipping Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vsart : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Intr. plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Werks : String(4) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity UnifiedEntryTypeSet {
    @sap.unicode : 'false'
    @sap.label : 'Trans system'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Tsyst : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location ID'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Locid : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'TS name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tsnam : String(60) not null;
    @sap.unicode : 'false'
    @sap.label : 'Source Code'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Zscode : String(3) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity MasterContractVHSet {
    @sap.unicode : 'false'
    @sap.label : 'Sales Document'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Vbeln : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ktext : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Master Contract'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VbelnGrp : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity poheadSet {
    @sap.unicode : 'false'
    @sap.label : 'Purchasing Doc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key PoNumber : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Company Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CompCode : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocType : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Del. Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DeleteInd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Status : String(1) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Created On'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatDate : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Created By'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatedBy : String(12) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item Interval'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ItemIntvl : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Supplier'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vendor : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Language'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Langu : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'ISO code f. lang.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LanguIso : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Pyt Terms'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Pmnttrms : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Payment in'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Dscnt1To : Decimal(3, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'Payment in'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Dscnt2To : Decimal(3, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'Payment in'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Dscnt3To : Decimal(3, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'CD Percentage 1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DsctPct1 : Decimal(5, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'CD Percentage 2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DsctPct2 : Decimal(5, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Purchasing Org.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PurchOrg : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Purch. Group'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PurGroup : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Currency'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'currency-code'
    Currency : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'ISO code crcy'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CurrencyIso : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Exchange Rate'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExchRate : Decimal(9, 5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Fixed Exch.Rate'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExRateFx : Boolean not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Document Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocDate : Timestamp;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Validity Start'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VperStart : Timestamp;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Validity End'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VperEnd : Timestamp;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Warranty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Warranty : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Quotation'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Quotation : String(10) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Quotation Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    QuotDate : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Your Reference'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ref1 : String(12) not null;
    @sap.unicode : 'false'
    @sap.label : 'Salesperson'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SalesPers : String(30) not null;
    @sap.unicode : 'false'
    @sap.label : 'Telephone'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Telephone : String(16) not null;
    @sap.unicode : 'false'
    @sap.label : 'Goods Supplier'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SupplVend : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Customer'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Customer : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Agreement'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Agreement : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'GR Message'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrMessage : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Supplying Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SupplPlnt : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Incoterms'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms1 : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Incoterms 2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms2 : String(28) not null;
    @sap.unicode : 'false'
    @sap.label : 'Collective No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CollectNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Invoicing Party'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DiffInv : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Our Reference'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OurRef : String(12) not null;
    @sap.unicode : 'false'
    @sap.label : 'Logical System'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Logsystem : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Subitem Interv.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Subitemint : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Release ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PoRelInd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Release State'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RelStatus : String(8) not null;
    @sap.unicode : 'false'
    @sap.label : 'CtryRgnSlsTxNo.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VatCntry : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'ISO C/R tax'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VatCntryIso : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reas. for Canc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ReasonCancel : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reason Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ReasonCode : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Retention'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RetentionType : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Retention %'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RetentionPercentage : Decimal(5, 2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Down Payment'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayType : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Down Payment Amt'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayAmount : Decimal(23, 4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Down Payment %'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayPercent : Decimal(5, 2) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Due Date for DP'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayDuedate : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Incomplete'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Memory : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Incompl. Cat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Memorytype : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Shipping Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Shiptype : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Handover Location'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Handoverloc : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Shipping Conditions'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Shipcond : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Inco. Version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incotermsv : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Inco. Location1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms2l : String(70) not null;
    @sap.unicode : 'false'
    @sap.label : 'Inco. Location2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms3l : String(70) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ext. Ref. System'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtSys : String(60) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ext. Reference ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtRef : String(70) not null;
    @sap.unicode : 'false'
    @sap.label : 'Intrastat rel.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IntrastatRel : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'exclude Intra'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IntrastatExcl : Boolean not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'External Revision'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtRevTmstmp : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Supplier Check Sts'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TotalStatusPcs : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Prod. Marktablty Sts'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TotalStatusPma : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Dangerous Goods Sts'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TotalStatusDg : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sfty Data Sheet Sts'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TotalStatusSds : String(1) not null;
    po_act : Association to many poAcntSet {  };
    po_cond : Association to many poCondSet {  };
    po_ret : Association to many returnpoSet {  };
    po_test : Association to TestRunSet {  };
    pohead_item : Association to many poitemSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity poitemSet {
    @sap.unicode : 'false'
    @sap.label : 'Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key PoItem : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Del. Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DeleteInd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Short Text'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ShortText : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Material : String(18) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MaterialExternal : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'GUID (External)'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MaterialGuid : String(32) not null;
    @sap.unicode : 'false'
    @sap.label : 'Version Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MaterialVersion : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ematerial : String(18) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EmaterialExternal : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'GUID (External)'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EmaterialGuid : String(32) not null;
    @sap.unicode : 'false'
    @sap.label : 'Version Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EmaterialVersion : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Plant : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StgeLoc : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Tracking Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Trackingno : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material Group'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MatlGroup : String(9) not null;
    @sap.unicode : 'false'
    @sap.label : 'Info Record'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    InfoRec : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Supp. Mat. No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VendMat : String(35) not null;
    @sap.unicode : 'false'
    @sap.unit : 'PoUnit'
    @sap.label : 'PO Quantity'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Quantity : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Order Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    PoUnit : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Order unit ISO'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PoUnitIso : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Order Price Un.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    OrderprUn : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'OPUn ISO'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OrderprUnIso : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Qty Conversion'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ConvNum1 : Decimal(5, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'Qty Conversion'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ConvDen1 : Decimal(5, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'Currency amount'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NetPrice : Decimal(28, 9) not null;
    @sap.unicode : 'false'
    @sap.label : 'Price Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PriceUnit : Decimal(5, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'GR proc. time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrPrTime : Decimal(3, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'Tax Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TaxCode : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sett. Group 1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BonGrp1 : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Stock Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    QualInsp : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'InfoUpdate'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    InfoUpd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Print Price'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PrntPrice : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Estimated Price'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EstPrice : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : '1st Rem./Exped.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Reminder1 : Decimal(3, 0) not null;
    @sap.unicode : 'false'
    @sap.label : '2nd Rem./Exped.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Reminder2 : Decimal(3, 0) not null;
    @sap.unicode : 'false'
    @sap.label : '3rd Rem./Exped.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Reminder3 : Decimal(3, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'Overdeliv. Tol.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OverDlvTol : Decimal(3, 1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Unlimited'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UnlimitedDlv : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Underdel. Tol.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UnderDlvTol : Decimal(3, 1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Valuation Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ValType : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Deliv. Compl.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NoMoreGr : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Final Invoice'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FinalInv : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Item Category'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ItemCat : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Acct Assgmt Cat'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Acctasscat : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Distribution'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Distrib : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Partial invoice'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PartInv : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Goods Receipt'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrInd : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'GR Non-Valuated'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrNonVal : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Invoice Receipt'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IrInd : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Free of Charge'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FreeItem : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'GR-Based IV'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrBasediv : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Acknowl. Reqd.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AcknReqd : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Order Acknowl.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AcknowlNo : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Agreement'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Agreement : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Agreement Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AgmtItem : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Shipping Instr.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Shipping : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Customer'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Customer : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Condition Group'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CondGroup : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'No Cash Disc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NoDisct : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Pl. Deliv. Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PlanDel : Decimal(3, 0) not null;
    @sap.unicode : 'false'
    @sap.unit : 'Weightunit'
    @sap.label : 'Net Weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NetWeight : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Unit of Weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Weightunit : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'ISO code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WeightunitIso : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Tax Jur.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Taxjurcode : String(15) not null;
    @sap.unicode : 'false'
    @sap.label : 'QM Control Key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CtrlKey : String(8) not null;
    @sap.unicode : 'false'
    @sap.label : 'Conf. Control'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ConfCtrl : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Revision Level'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RevLev : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Fund'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Fund : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Funds Center'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FundsCtr : String(16) not null;
    @sap.unicode : 'false'
    @sap.label : 'Commitment item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CmmtItem : String(24) not null;
    @sap.unicode : 'false'
    @sap.label : 'Pr. Date Cat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Pricedate : String(1) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Price Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PriceDate : Timestamp;
    @sap.unicode : 'false'
    @sap.unit : 'Weightunit'
    @sap.label : 'Gross Weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrossWt : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.unit : 'Volumeunit'
    @sap.label : 'Volume'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Volume : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Volume Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Volumeunit : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Volume unit ISO'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VolumeunitIso : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Incoterms'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms1 : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Incoterms 2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms2 : String(28) not null;
    @sap.unicode : 'false'
    @sap.label : 'Prior Supplier'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PreVendor : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Suppl. Subrange'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VendPart : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'H-Lev. Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    HlItem : String(5) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Latest GR Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrToDate : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Supplier'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SuppVendor : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'SC Supplier'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ScVendor : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Kanban Indicat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KanbanInd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'ERS'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ers : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Promotion'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RPromo : String(10) not null;
    @sap.unicode : 'false'
    @sap.unit : 'PointUnit'
    @sap.label : 'Points'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Points : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Points Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    PointUnit : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'ISO code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PointUnitIso : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Season'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Season : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Season Year'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SeasonYr : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sett. Group 2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BonGrp2 : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sett. Group 3'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BonGrp3 : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Settlement'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SettItem : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Rem. Shelf Life'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Minremlife : Decimal(4, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'RFQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RfqNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RfqItem : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Purchase Req.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PreqNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Requisn. item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PreqItem : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reference Doc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RefDoc : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reference item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RefItem : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Subitem Cat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SiCat : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Returns Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RetItem : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'AT-Relevant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AtRelev : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reason for Ord.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OrderReason : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'NCM Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BrasNbm : String(16) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material Usage'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MatlUsage : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material Origin'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MatOrigin : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Prod. in-house'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    InHouse : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Mat. category'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Indus3 : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Inflation index'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    InfIndex : String(5) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Index Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UntilDate : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Final Delivery'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DelivCompl : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Part. Del./Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PartDeliv : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Shipping block'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ShipBlocked : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Requisitioner'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PreqName : String(12) not null;
    @sap.unicode : 'false'
    @sap.label : 'Period Ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PeriodIndExpirationDate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Int. object no.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IntObjNo : String(18) not null;
    @sap.unicode : 'false'
    @sap.label : 'Package number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PckgNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Batch'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Batch : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Supplier Batch'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vendrbatch : String(15) not null;
    @sap.unicode : 'false'
    @sap.label : 'Pricing Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Calctype : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Grant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrantNbr : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Commitment Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CmmtItemLong : String(24) not null;
    @sap.unicode : 'false'
    @sap.label : 'Functional Area'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FuncAreaLong : String(16) not null;
    @sap.unicode : 'false'
    @sap.label : 'No Rounding'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NoRounding : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Price Adoption'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PoPrice : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Iss. Stor. Loc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SupplStloc : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Srv.-Based Inv. Ver.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SrvBasedIv : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Earmarked funds'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FundsRes : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ResItem : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Origin Accept.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OrigAccept : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Alloc. Table'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AllocTbl : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AllocTblItem : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Source Stock Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SrcStockType : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'RejectionReason'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ReasonRej : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'CRM Sales Order'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CrmSalesOrderNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'CRM Item No'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CrmSalesOrderItemNo : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'CRM Ref Order'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CrmRefSalesOrderNo : String(35) not null;
    @sap.unicode : 'false'
    @sap.label : 'CRM Rf Item No'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CrmRefSoItemNo : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reqmt Urgency'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PrioUrgency : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reqmt Priority'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PrioRequirement : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reason Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ReasonCode : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Fund'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FundLong : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Hierarchy Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LongItemNumber : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'External Sort No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExternalSortNumber : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ext.Hierarchy Cat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExternalHierarchyType : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Retention %'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RetentionPercentage : Decimal(5, 2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Down Payment'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayType : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Down Payment Amt'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayAmount : Decimal(23, 4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Down Payment %'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayPercent : Decimal(5, 2) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Due Date for DP'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayDuedate : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'External Document'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtRfxNumber : String(35) not null;
    @sap.unicode : 'false'
    @sap.label : 'External Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtRfxItem : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Logical System'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtRfxSystem : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Central Contract'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SrmContractId : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Cent. Contract Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SrmContractItm : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Budget Period'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BudgetPeriod : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Block Reason ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BlockReasonId : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Block Reas. Text'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BlockReasonText : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Bill. Relevance'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeCrmFkrel : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Fixed Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DateQtyFixed : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'GI-based GR'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GiBasedGr : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Shipping Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Shiptype : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Handover Location'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Handoverloc : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'TC Auto. Det.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TcAutDet : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Man. TC Reason'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ManualTcReason : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Tax Incent Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FiscalIncentive : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Incentive ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FiscalIncentiveId : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Tax Subj. to ST'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TaxSubjectSt : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reqmnt Segment'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ReqSegment : String(16) not null;
    @sap.unicode : 'false'
    @sap.label : 'Stock Segment'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StkSegment : String(16) not null;
    @sap.unicode : 'false'
    @sap.label : 'OrigJurCod'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SfTxjcd : String(15) not null;
    @sap.unicode : 'false'
    @sap.label : 'Inco. Location1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms2l : String(70) not null;
    @sap.unicode : 'false'
    @sap.label : 'Inco. Location2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms3l : String(70) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MaterialLong : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EmaterialLong : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Service Performer'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Serviceperformer : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Product Type Group'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Producttype : String(2) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Start Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Startdate : Timestamp;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'End Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Enddate : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Reqmnt Segment'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ReqSegLong : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Stock Segment'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StkSegLong : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Currency amount'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExpectedValue : Decimal(28, 9) not null;
    @sap.unicode : 'false'
    @sap.label : 'Currency amount'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LimitAmount : Decimal(28, 9) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ext. Reference ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtRef : String(70) not null;
    @sap.unicode : 'false'
    @sap.label : 'G/L Account'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GlAccount : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Cost Center'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Costcenter : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'WBS Element'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WbsElement : String(24) not null;
    @sap.unicode : 'false'
    @sap.label : 'Commodity Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CommodityCode : String(30) not null;
    @sap.unicode : 'false'
    @sap.label : 'Intrastat Srvc. Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IntrastatServiceCode : String(30) not null;
    @sap.unicode : 'false'
    @sap.label : 'Contract For Limit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ContractForLimit : String(10) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Tax Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Taxcalcdate : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Tax Ctry/Reg.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Taxcountry : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Supplier Check Sts'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StatusPcs : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Prod. Marktablty Sts'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StatusPma : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Dangerous Goods Sts'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StatusDg : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sfty Data Sheet Sts'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StatusSds : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Business Transaction'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TxsBusinessTransaction : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Usage Purpose'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TxsUsagePurpose : String(25) not null;
    @sap.unicode : 'false'
    @sap.label : 'Load./Unload. Pt'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LoadingPoint : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sub-items'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Subitems : String(1) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity poheadxSet {
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key PoNumber : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CompCode : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocType : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DeleteInd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Status : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatDate : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatedBy : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ItemIntvl : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vendor : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Langu : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LanguIso : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Pmnttrms : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Dscnt1To : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Dscnt2To : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Dscnt3To : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DsctPct1 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DsctPct2 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PurchOrg : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PurGroup : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Currency : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CurrencyIso : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExchRate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExRateFx : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocDate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VperStart : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VperEnd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Warranty : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Quotation : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    QuotDate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ref1 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SalesPers : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Telephone : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SupplVend : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Customer : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Agreement : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrMessage : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SupplPlnt : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms1 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms2 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CollectNo : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DiffInv : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OurRef : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Logsystem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Subitemint : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PoRelInd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RelStatus : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VatCntry : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VatCntryIso : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ReasonCancel : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ReasonCode : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RetentionType : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RetentionPercentage : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayType : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayAmount : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayPercent : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayDuedate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Memory : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Memorytype : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Shiptype : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Handoverloc : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Shipcond : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incotermsv : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms2l : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms3l : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtSys : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtRef : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IntrastatRel : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IntrastatExcl : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtRevTmstmp : String(1) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity poitemxSet {
    @sap.unicode : 'false'
    @sap.label : 'Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key PoItem : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PoItemx : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DeleteInd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ShortText : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Material : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MaterialExternal : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MaterialGuid : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MaterialVersion : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ematerial : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EmaterialExternal : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EmaterialGuid : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EmaterialVersion : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Plant : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StgeLoc : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Trackingno : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MatlGroup : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    InfoRec : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VendMat : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Quantity : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PoUnit : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PoUnitIso : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OrderprUn : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OrderprUnIso : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ConvNum1 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ConvDen1 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NetPrice : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PriceUnit : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrPrTime : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TaxCode : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BonGrp1 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    QualInsp : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    InfoUpd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PrntPrice : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EstPrice : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Reminder1 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Reminder2 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Reminder3 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OverDlvTol : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UnlimitedDlv : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UnderDlvTol : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ValType : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NoMoreGr : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FinalInv : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ItemCat : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Acctasscat : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Distrib : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PartInv : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrInd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrNonVal : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IrInd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FreeItem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrBasediv : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AcknReqd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AcknowlNo : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Agreement : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AgmtItem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Shipping : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Customer : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CondGroup : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NoDisct : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PlanDel : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NetWeight : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Weightunit : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WeightunitIso : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Taxjurcode : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CtrlKey : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ConfCtrl : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RevLev : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Fund : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FundsCtr : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CmmtItem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Pricedate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PriceDate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrossWt : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Volume : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Volumeunit : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VolumeunitIso : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms1 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms2 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PreVendor : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VendPart : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    HlItem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrToDate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SuppVendor : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ScVendor : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KanbanInd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ers : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RPromo : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Points : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PointUnit : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PointUnitIso : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Season : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SeasonYr : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BonGrp2 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BonGrp3 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SettItem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Minremlife : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RfqNo : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RfqItem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PreqNo : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PreqItem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RefDoc : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RefItem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SiCat : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RetItem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AtRelev : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OrderReason : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BrasNbm : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MatlUsage : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MatOrigin : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    InHouse : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Indus3 : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    InfIndex : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UntilDate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DelivCompl : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PartDeliv : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ShipBlocked : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PreqName : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PeriodIndExpirationDate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IntObjNo : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PckgNo : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Batch : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vendrbatch : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Calctype : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NoRounding : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PoPrice : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SupplStloc : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SrvBasedIv : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FundsRes : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ResItem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrantNbr : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FuncAreaLong : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OrigAccept : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AllocTbl : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AllocTblItem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SrcStockType : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ReasonRej : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CrmSalesOrderNo : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CrmSalesOrderItemNo : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CrmRefSalesOrderNo : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CrmRefSoItemNo : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PrioUrgency : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PrioRequirement : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ReasonCode : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LongItemNumber : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExternalSortNumber : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExternalHierarchyType : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RetentionPercentage : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayType : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayAmount : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayPercent : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DownpayDuedate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtRfxNumber : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtRfxItem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtRfxSystem : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SrmContractId : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SrmContractItm : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BudgetPeriod : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BlockReasonId : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BlockReasonText : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeCrmFkrel : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DateQtyFixed : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GiBasedGr : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Shiptype : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Handoverloc : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TcAutDet : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ManualTcReason : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FiscalIncentive : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FiscalIncentiveId : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TaxSubjectSt : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ReqSegment : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StkSegment : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SfTxjcd : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms2l : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incoterms3l : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MaterialLong : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EmaterialLong : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Serviceperformer : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Producttype : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Startdate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Enddate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ReqSegLong : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StkSegLong : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExpectedValue : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LimitAmount : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtRef : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GlAccount : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Costcenter : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WbsElement : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CommodityCode : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IntrastatServiceCode : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ContractForLimit : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Taxcalcdate : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Taxcountry : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TxsBusinessTransaction : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TxsUsagePurpose : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LoadingPoint : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updated Info'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Subitems : String(1) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity poAcntSet {
    @sap.unicode : 'false'
    @sap.label : 'Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key PoItem : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Account Assgmt No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SerialNo : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Deletion Ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DeleteInd : Boolean not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Created On'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatDate : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Quantity'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Quantity : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Distribution'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DistrPerc : Decimal(3, 1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Currency amount'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NetValue : Decimal(28, 9) not null;
    @sap.unicode : 'false'
    @sap.label : 'G/L Account'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GlAccount : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Business Area'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BusArea : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Cost Center'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Costcenter : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'SD Document'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SdDoc : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ItmNumber : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Schedule Line'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SchedLine : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Asset'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AssetNo : String(12) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sub-number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SubNumber : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Order'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Orderid : String(12) not null;
    @sap.unicode : 'false'
    @sap.label : 'Recipient'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrRcpt : String(12) not null;
    @sap.unicode : 'false'
    @sap.label : 'Unloading Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UnloadPt : String(25) not null;
    @sap.unicode : 'false'
    @sap.label : 'CO Area'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CoArea : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Cost Object'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Costobject : String(12) not null;
    @sap.unicode : 'false'
    @sap.label : 'Profit Center'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ProfitCtr : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'WBS Element'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WbsElement : String(24) not null;
    @sap.unicode : 'false'
    @sap.label : 'Network'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Network : String(12) not null;
    @sap.unicode : 'false'
    @sap.label : 'Real Estate Key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RlEstKey : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Partner'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PartAcct : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Commitment item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CmmtItem : String(24) not null;
    @sap.unicode : 'false'
    @sap.label : 'Recovery Ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RecInd : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Funds Center'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FundsCtr : String(16) not null;
    @sap.unicode : 'false'
    @sap.label : 'Fund'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Fund : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Functional Area'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FuncArea : String(4) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Reference date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RefDate : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Tax Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TaxCode : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Tax Jur.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Taxjurcode : String(15) not null;
    @sap.unicode : 'false'
    @sap.label : 'Currency amount'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NondItax : Decimal(28, 9) not null;
    @sap.unicode : 'false'
    @sap.label : 'Activity Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Acttype : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Business Process'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CoBusproc : String(12) not null;
    @sap.unicode : 'false'
    @sap.label : 'Earmarked Funds'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ResDoc : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ResItem : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Activity'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Activity : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Grant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GrantNbr : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Commitment Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CmmtItemLong : String(24) not null;
    @sap.unicode : 'false'
    @sap.label : 'Functional Area'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FuncAreaLong : String(16) not null;
    @sap.unicode : 'false'
    @sap.label : 'Budget Period'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BudgetPeriod : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Final AA'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FinalInd : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Final AA Reason'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FinalReason : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Service Document'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ServiceDoc : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Service Doc. Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ServiceItem : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Service Doc. Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ServiceDocType : String(4) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity poCondSet {
    @sap.unicode : 'false'
    @sap.label : 'Doc. Condition'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ConditionNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ItmNumber : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Step Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key CondStNo : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Counter'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key CondCount : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Condition Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key CondType : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Amount'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CondValue : Decimal(28, 9) not null;
    @sap.unicode : 'false'
    @sap.label : 'Currency'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'currency-code'
    Currency : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'ISO code crcy'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CurrencyIso : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Unit of Measure'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    CondUnit : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'ISO cond. UoM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CondUnitIso : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Pricing Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CondPUnt : Decimal(5, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'Application'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Applicatio : String(2) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'CndnPricingDate'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Conpricdat : Timestamp not null;
    @sap.unicode : 'false'
    @sap.label : 'Calculat.Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Calctypcon : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Cond.base value'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Conbaseval : Decimal(28, 9) not null;
    @sap.unicode : 'false'
    @sap.label : 'Cond.exch.rate'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Conexchrat : Decimal(9, 5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Numer.for Conv.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Numconvert : Decimal(5, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'Den. for Conv.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Denominato : Decimal(5, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'Condit.Category'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Condtype : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Statistical'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StatCon : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Scale Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Scaletype : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Accruals'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Accruals : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Inv.List Cond.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Coninvolst : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Condit.Origin'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Condorigin : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Group Condition'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Groupcond : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Condit. Update'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CondUpdat : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Access'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AccessSeq : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sequent. No. of Cond'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Condcount : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Cond.Control'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Condcntrl : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Inactive'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Condisacti : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Condition Class'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Condclass : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'CondFactor'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Factbasval : Double not null;
    @sap.unicode : 'false'
    @sap.label : 'Scale Base Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Scalebasin : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Scale base val.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Scalbasval : Decimal(28, 9) not null;
    @sap.unicode : 'false'
    @sap.label : 'Scale UoM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Unitmeasur : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'ISO Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UnitmeasurIso : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Scale Currency'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'currency-code'
    Currenckey : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'ISO code crcy'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CurrenckeyIso : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'IntcoBillCond'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Condincomp : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'UsedfVarConfig'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Condconfig : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Changed Manual.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Condchaman : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Cond.Record No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CondNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Change Ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChangeId : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Supplier'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VendorNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Access'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AccessSeqLong : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Counter'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CondCountLong : String(3) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity returnpoSet {
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
    Id : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Number : String(3) not null;
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
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity TestRunSet {
    @sap.unicode : 'false'
    @sap.label : 'Single-Character Flag'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Bapiflag : String(1) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity CreatepgiSet {
    @sap.unicode : 'false'
    @sap.label : 'Delivery'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key VbelnVl : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PosnrVl : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Cat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VbtypVl : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Quantity'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Pikmg : Decimal(15, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Post GM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Wabuc : Boolean not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Actual GI Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WadatIst : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UpdatePicking : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Synchron : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'No-block'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NichtSperren : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Delivery'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Delivery : String(10) not null;
    pgi_toitem : Association to many pgi_itemSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity pgi_itemSet {
    @sap.unicode : 'false'
    @sap.label : 'Delivery'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key VbelnVl : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ignore GM Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key IgnoreGoodsMvmtStatus : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PosnrVl : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Follow-on Doc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vbeln : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Subsequent Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Posnn : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Cat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VbtypN : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Matnr : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Batch'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Charg : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Werks : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Confirmation ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Taqui : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Net weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzntg : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Gross weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzbrg : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Volume'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzvol : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Change dely qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lianp : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Flag: delete delivery item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LipsDel : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Stock Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Insmk : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Stock Category'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Bestq : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'POD indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzpod : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Pick quantity'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PikmgWh : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Pick quantity'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PikmgWhBu : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Dest.diff.qty.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ndifm : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Original item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Orpos : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Quantity'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Pikmg : Decimal(15, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Special Stock'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Sobkz : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Spec.Stock No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Sonum : String(16) not null;
    @sap.unicode : 'false'
    @sap.label : 'Inv.Mgmt active'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzbef : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Pos./Negative'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Plmin : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Red. orig. item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ForceOrposReduction : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Delivery Qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lfimg : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Qty (stckp.unt)'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgmng : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Internal field/ Do not use / LFIMG in float / MUM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LfimgFlo : Double not null;
    @sap.unicode : 'false'
    @sap.label : 'Internal field/ Do not use / LGMNG in float / MUM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LgmngFlo : Double not null;
    @sap.unicode : 'false'
    @sap.label : 'Numerator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Umvkz : Decimal(5, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'Denominat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Umvkn : Decimal(5, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'ConversionFactr'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Umrev : Double not null;
    @sap.unicode : 'false'
    @sap.label : 'Current qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Akmng : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sales Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vrkme : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Base Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Meins : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Leading UoM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzfme : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Gross Weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Brgew : Decimal(15, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Net Weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ntgew : Decimal(15, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Unit of Weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Gewei : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Volume'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Volum : Decimal(15, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Volume Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Voleh : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Storage Bin'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgpla : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Storage Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgtyp : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Movement Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Bwlvs : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Copy WM-PP data'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Xwmpp : String(1) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'SLED/BBD'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vfdat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Exp. date ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzvfdat : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Qty to Book In'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EbumgBme : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reference Doc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WmsRfbel : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reference Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WmsRfpos : String(6) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Date of Manuf.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Hsdat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Confirm Date of Manufacture'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzhsdat : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Debit/Credit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeDiffPostIndicator : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Except.Code WH'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeExceptCode : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'RMA Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeAuthNumber : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'GR-Posted Qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeRetQtyPost : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Base Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeBaseUom : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'RMA No. Completed'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeAuthComplet : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeAuthCompletF : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Closing Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeRetClosingIndicator : Boolean not null;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Begin Valid. Period'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeExpDateExtB : DateTime;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'End Validity Period'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeExpDateExt : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Stock Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeMdiffInsmk : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'In Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeImwrkItm : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Update Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeImwrkItmF : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Original System Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeOrigSys : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'CQ Vendor'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeCumVend : Decimal(15, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'CQ In Transit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeCumItqs : Decimal(15, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'CQ Received for SA'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeCumSa : Decimal(15, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ext. ident.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeLifexpos2 : String(35) not null;
    @sap.unicode : 'false'
    @sap.label : 'DeliveryVsn'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeVersion : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Qty (stckp.unt)'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeDlvQtyFrom : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Maintain INMSK'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeInmskF : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Mtn SPE_LIFEXPOS2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeLifexpos2F : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'DeliveryItemUpdate'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeInbItmUpd : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Item Descr.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Arktx : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Staging Area'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgbzo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgort : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Stor. locations'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzlgo : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Ext. item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lifexpos : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'ConfExtItemNumber'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzlxp : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Valuation Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Bwtar : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'ConfValuationType'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzbwt : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Mat.Freight Grp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Mfrgr : String(8) not null;
    @sap.unicode : 'false'
    @sap.label : 'EAN/UPC'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ean11 : String(18) not null;
    @sap.unicode : 'false'
    @sap.label : 'Supp. Mat. No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Idnlf : String(35) not null;
    @sap.unicode : 'false'
    @sap.label : 'Customer Mat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kdmat : String(35) not null;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzKdmat : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'C/R of Origin'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeHerkl : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzSpeHerkl : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Reg. of Origin'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeHerkr : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzSpeHerkr : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Supplier Batch'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lichn : String(15) not null;
    @sap.unicode : 'false'
    @sap.label : 'Usage'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Abrvw : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'TextChanges'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kztxt : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Del Txt in All Lang'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TxtoldDelAllLang : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Movement Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffBwart : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reason for Mvmt'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffGrund : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffLgort : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'ConfSplitQuanDiffPro'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffAutoSplit : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Material Doc EWM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeMdnumEwm : String(16) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material Item EWM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeMditmEwm : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'OrgMaterial Doc EWM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeOmdnumEwm : String(16) not null;
    @sap.unicode : 'false'
    @sap.label : 'OrgMaterial Item EWM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeOmditmEwm : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Delivery Qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ormng : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'GTS Stock Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeGtsStockType : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'CQ Vendor'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeLieffz : Decimal(15, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Numerator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeApoQntyfac : Decimal(5, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'Denominator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeApoQntydiv : Decimal(5, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'Pick Denial'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpePickDenial : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'No Serial Number Upd'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NoSernrUpdate : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Indicator: Delete Serial Numbers'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SernrDel : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Docu. Batch'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FlagDocub : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'No conversion'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeXnocon : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Qty to Book In'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeEbumg : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Movement Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Bwart : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Upd. Ormng'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeForceOrmngUpdate : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Inspection GUID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    InspDocGuid : UUID not null;
    @sap.unicode : 'false'
    @sap.label : 'Req. Segment'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SgtRcat : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Stock Segment'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SgtScat : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzItmEmcst : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Embargo Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ItmEmcst : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzItmSlcst : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Screening Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ItmSlcst : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzItmLccst : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Legal Control Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ItmLccst : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzArcStatus : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'ET ARC Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ArcStatus : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Resource'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ResourceId : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzResourceId : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Receiv. Resource'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UmresourceId : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzUmresourceId : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Load./Unload. Pt'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LoadingPoint : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzLoadingPoint : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Dummy function in length 1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DummyDelitmInclEewPs : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Updt Extn Fields'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UpdateExtensionFields : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Ignore Distr Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IgnoreDistributionStatus : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LipsCre : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Reference Doc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vgbel : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reference Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vgpos : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Cat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vgtyp : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reference item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Rfpos : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Warehouse No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgnum : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Door for Whse'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgtor : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Higher-Lev.Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Uepos : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Usage HL Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Uepvw : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzuep : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Item Category'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Pstyv : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Compl Ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffCompl : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Do Not Adj. CRQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffFzgls : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Adjust Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffEtanp : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Dialog box'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffPopup : String(1) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity delivery_headerSet {
    @sap.unicode : 'false'
    @sap.label : 'Delivery'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key VbelnVl : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Cat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VbtypVl : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Picking request'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vbeln : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Warehouse No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgnum : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Dummy function in length 1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tanum : String(1);
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Pick Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kodat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kouhr : Time;
    @sap.unicode : 'false'
    @sap.label : 'Gross Weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Brgew : Decimal(15, 3);
    @sap.unicode : 'false'
    @sap.label : 'Gross weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzbrg : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Net weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzntg : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Net Weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ntgew : Decimal(15, 3);
    @sap.unicode : 'false'
    @sap.label : 'Unit of Weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Gewei : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Volume'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Volum : Decimal(15, 3);
    @sap.unicode : 'false'
    @sap.label : 'Volume'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzvol : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Volume Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Voleh : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Overwr.del.qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Komue : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Post GM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Wabuc : Boolean;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Actual GI Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WadatIst : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Confirm planned goods issue date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzwad : Boolean;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Goods Issue'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Wadat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'GI Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Wauhr : Time;
    @sap.unicode : 'false'
    @sap.label : 'Confirm delivery date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzlfd : Boolean;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Delivery date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lfdat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'TimeOfDelivery'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lfuhr : Time;
    @sap.unicode : 'false'
    @sap.label : 'Confirm gate'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kztor : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Door for Whse'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgtor : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Change delivery block'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzlsp : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Delivery Block'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lifsk : String(2);
    @sap.unicode : 'false'
    @sap.label : 'Flag: delete delivery'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LikpDel : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Update packing date before the change'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PackingRefresh : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Final round'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PackingFinal : Boolean;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'POD Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Podat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Confirm. Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Potim : Time;
    @sap.unicode : 'false'
    @sap.label : 'POD verif. ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzpod : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Ext. Delivery'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lifex : String(35);
    @sap.unicode : 'false'
    @sap.label : 'Bill of Lading'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Bolnr : String(35);
    @sap.unicode : 'false'
    @sap.label : 'Supply Area'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Prvbe : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Copy WM-PP data'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Xwmpp : String(1);
    @sap.unicode : 'false'
    @sap.label : 'MnsOfTrns Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Traty : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Mns of Trans.ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Traid : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Copy Pick Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzkodat : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Partial GR'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzebu : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Incoterms'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Inco1 : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Incoterms 2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Inco2 : String(28);
    @sap.unicode : 'false'
    @sap.label : 'Route'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Route : String(6);
    @sap.unicode : 'false'
    @sap.label : 'Delivery Prior.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lprio : String(2);
    @sap.unicode : 'false'
    @sap.label : 'Shipping Conditions'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vsbed : String(2);
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Loading Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lddat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Loading Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lduhr : Time;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'TranspPlngDate'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tddat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Tr. Plan. Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tduhr : Time;
    @sap.unicode : 'false'
    @sap.label : 'Unloading Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ablad : String(25);
    @sap.unicode : 'false'
    @sap.label : 'Change Incoterms 1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzinco1 : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Change Incoterms 2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzinco2 : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Change Route'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzroute : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Chge Delivery Prioty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzlprio : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Change Shipng Cond.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzvsbed : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Chnge Load. Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzlddat : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Transptn Plang Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kztddat : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Change Unload. Pnt'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzablad : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Change Ext. Del. ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzlifex : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Split Perfmd Dec.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Decspli : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Indicator: Switch Off Change Management for Document'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzchgoff : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'In Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Imwrk : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Indicator: Change ''In Plant'' Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzreg : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Verif. Stag.Ar.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzlgbzo : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Staging Area'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgbzo : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Original System Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeOrigSys : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Changer''s Sys.Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeChngSys : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Temp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeTmpid : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Deletion Indic.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeLoekz : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Consistency Check for HU - Suppress Inbound Delivery'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeNoHuConsCheck : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Logical System'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeLogsys : String(10);
    @sap.unicode : 'false'
    @sap.label : 'HU upd.request'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeRetHuUpdateRequest : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Process Ind'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeGenProcess : String(4);
    @sap.unicode : 'false'
    @sap.label : 'GI Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeWauhrIst : Time;
    @sap.unicode : 'false'
    @sap.label : 'Time Zone'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeWazoneIst : String(6);
    @sap.unicode : 'false'
    @sap.label : 'Location Seq.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeLocSeq : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Del.Conf.Stat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeAccAppSts : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeAccAppStsF : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Ship.Info.Stat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeShpInfSts : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeShpInfStsF : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Ret.ASN Canc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeRetCanc : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeRetCancF : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'QI Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeQiStatus : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeQiStatusF : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Georoute'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeGeoroute : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Chg Ind Route'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeGeorouteind : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Change Ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeCarrierInd : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Gds Traffic Ty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeGtsRel : String(2);
    @sap.unicode : 'false'
    @sap.label : 'GTSRouteCode'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeGtsRtCde : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Customs Ref No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GtsCusrefNo : String(35);
    @sap.unicode : 'false'
    @sap.label : 'ATP: Unique ID for relevant transaction in APO server'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BopGuid : UUID;
    @sap.unicode : 'false'
    @sap.label : 'Direct Billing'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeDirectBilling : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Billing Wait'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeBillingWait : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Print Profile'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpePrinterProf : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Change Route'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeKzgeoroute : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Chnge Route Ind'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeKzgeorouteind : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Chg Src IndCrr'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeKzcarrierInd : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Change GTS Rel.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeKzgtsRel : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'ChangeRouteCde'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeKzgtsRtCde : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Initiator ComCh'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeInitiatorProcess : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeResetVlstk : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeKztraid : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeKztraty : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'SPEIDProcessing'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeInbDlv : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'P.Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeDistProcCode : String(1);
    @sap.unicode : 'false'
    @sap.label : 'NoTextInitialization'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NoTextInit : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'NoMesssageInitial'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NoMessageInit : Boolean;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Document Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Bldat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'ConfDocumentDate'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzbld : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'No. of Packages'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Anzpk : String(5);
    @sap.unicode : 'false'
    @sap.label : 'ConfTotNoDlvry'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzapk : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'ConfActGoodsMovement'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BorgrKzwad : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'ConfUnlPoint'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BorgrKzabl : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Qty. Difference'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffBuch : String(1);
    @sap.unicode : 'false'
    @sap.label : 'ConfReversal'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffStorno : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'TextChanges'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kztxt : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Del Txt in All Lang'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TxtoldDelAllLang : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Material Doc EWM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeMdnumEwm : String(16);
    @sap.unicode : 'false'
    @sap.label : 'OrgMaterial Doc EWM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeOmdnumEwm : String(16);
    @sap.unicode : 'false'
    @sap.label : 'Rec. CD Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeCdPlant : String(4);
    @sap.unicode : 'false'
    @sap.label : 'ChngeCDPlant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeCdPlantf : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'PRO Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeProNumber : String(35);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeKzProNumber : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Redirected'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeRedInd : String(1);
    @sap.unicode : 'false'
    @sap.label : 'A.GR'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeAutoGr : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Scenario Logistic Ex'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeLeScenario : String(1);
    @sap.unicode : 'false'
    @sap.label : 'No. of Previous Doc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vornu : String(25);
    @sap.unicode : 'false'
    @sap.label : 'Type of Previous Doc'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vorpa : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Mode of Trans.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Expvz : String(1);
    @sap.unicode : 'false'
    @sap.label : 'NoInbndDlvCheck'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NoLfimgCheckMmli : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Stor.Loc.Change'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StgeLocChange : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeKzVornu : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeKzVorpa : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Transp.Plng Sts'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Trsta : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Chge Inco. Ver.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzincov : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Chge Inco. Loc1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzinco2L : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Chge Inco. Loc2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzinco3L : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'ChngeShippingT'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzvsart : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Shipping Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vsart : String(2);
    @sap.unicode : 'false'
    @sap.label : 'Warehouse Execution'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TmWhseExec : String(1);
    @sap.unicode : 'false'
    @sap.label : 'quan_no_check'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    QuanNoCheckTransient : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzTmWhseExec : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Legal Contrl License'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LglcLicInd : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzLglcLicInd : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Component Group Ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CompGrp : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzCompGrp : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Inco. Version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Incov : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Inco. Location1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Inco2L : String(70);
    @sap.unicode : 'false'
    @sap.label : 'Inco. Location2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Inco3L : String(70);
    @sap.unicode : 'false'
    @sap.label : 'Dummy function in length 1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DummyDeliveryInclEewPs : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Updt Extn Fields'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UpdateExtensionFields : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Ignore GM Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IgnoreGoodsMvmtStatus : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Ignore Distr Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IgnoreDistributionStatus : Boolean;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Ext. act. date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtActDateTocd : DateTime;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Ext. plan. date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtPlanDateTocd : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'ext.tz.tocd'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtTzoneTocd : String(6);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Int. act. date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IntActDateTocd : DateTime;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Int. plan. date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IntPlanDateTocd : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzIcoTocdUpdate : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'int.tz.tocd'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IntTzoneTocd : String(6);
    @sap.unicode : 'false'
    @sap.label : 'Change Act GM Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzwadatIst : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzCorrInd : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Qty. Corr. Adv. SR'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CorrInd : String(1);
    @sap.unicode : 'false'
    @sap.label : 'LE Update Caller'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LeUpdateCaller : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kztrx : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Current point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtCurEvtloc : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Arrival/Departure'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtCurEvtqua : String(1);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Curr tme stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtCurEvttst : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Base Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtCurEstloc : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Arrival/Departure'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtCurEstqua : String(1);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time estim. stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtCurEsttst : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Event / Estimation'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtCurWrkqua : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Base Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtRefEstloc : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Arrival/Departure'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtRefEstqua : String(1);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time estim. stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtRefEsttst : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Mode of entry'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtWrkqua3 : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Dely data updated'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtWrkqua4 : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Delivery date fixed'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtFirmLfdat : String(2);
    @sap.unicode : 'false'
    @sap.label : 'IDoc number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IdtDocnum : String(16);
    @sap.unicode : 'false'
    @sap.label : 'Inb. Dly Group'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BorgrGrp : String(35);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzgrp : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Warehouse No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BorgrLgnum : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BorgrKznum : Boolean;
    @sap.unicode : 'false'
    @sap.label : '(Auto) UnloadPt'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BorgrLgbzo : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BorgrKzbzo : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'no-block'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    nichtsperren : String(1);
    @sap.unicode : 'false'
    @sap.label : 'checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    updatepicking : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Check box'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    synchron : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BorgrKzpod : Boolean;
    delivery_itemSet : Association to many delivery_itemSet {  };
    prot_returnSet : Association to many prot_returnSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity delivery_itemSet {
    @sap.unicode : 'false'
    @sap.label : 'Delivery'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key VbelnVl : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key PosnrVl : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Follow-on Doc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vbeln : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Subsequent Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Posnn : String(6);
    @sap.unicode : 'false'
    @sap.label : 'Document Cat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VbtypN : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Matnr : String(40);
    @sap.unicode : 'false'
    @sap.label : 'Batch'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Charg : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Werks : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Confirmation ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Taqui : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Net weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzntg : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Gross weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzbrg : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Volume'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzvol : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Change dely qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lianp : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Flag: delete delivery item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LipsDel : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Stock Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Insmk : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Stock Category'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Bestq : String(1);
    @sap.unicode : 'false'
    @sap.label : 'POD indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzpod : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Pick quantity'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PikmgWh : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Pick quantity'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PikmgWhBu : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Dest.diff.qty.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ndifm : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Original item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Orpos : String(6);
    @sap.unicode : 'false'
    @sap.label : 'Quantity'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Pikmg : Decimal(15, 3);
    @sap.unicode : 'false'
    @sap.label : 'Special Stock'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Sobkz : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Spec.Stock No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Sonum : String(16);
    @sap.unicode : 'false'
    @sap.label : 'Inv.Mgmt active'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzbef : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Pos./Negative'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Plmin : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Red. orig. item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ForceOrposReduction : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Delivery Qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lfimg : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Qty (stckp.unt)'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgmng : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Internal field/ Do not use / LFIMG in float / MUM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LfimgFlo : Double;
    @sap.unicode : 'false'
    @sap.label : 'Internal field/ Do not use / LGMNG in float / MUM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LgmngFlo : Double;
    @sap.unicode : 'false'
    @sap.label : 'Numerator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Umvkz : Decimal(5, 0);
    @sap.unicode : 'false'
    @sap.label : 'Denominat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Umvkn : Decimal(5, 0);
    @sap.unicode : 'false'
    @sap.label : 'ConversionFactr'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Umrev : Double;
    @sap.unicode : 'false'
    @sap.label : 'Current qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Akmng : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Sales Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Vrkme : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Base Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Meins : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Leading UoM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzfme : String(1);
    @sap.unicode : 'false'
    @sap.unit : 'Gewei'
    @sap.label : 'Gross Weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Brgew : Decimal(15, 3);
    @sap.unicode : 'false'
    @sap.unit : 'Gewei'
    @sap.label : 'Net Weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ntgew : Decimal(15, 3);
    @sap.unicode : 'false'
    @sap.label : 'Unit of Weight'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Gewei : String(3);
    @sap.unicode : 'false'
    @sap.unit : 'Voleh'
    @sap.label : 'Volume'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Volum : Decimal(15, 3);
    @sap.unicode : 'false'
    @sap.label : 'Volume Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Voleh : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Storage Bin'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgpla : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Storage Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgtyp : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Movement Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Bwlvs : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Copy WM-PP data'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Xwmpp : String(1);
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'SLED/BBD'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vfdat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Exp. date ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzvfdat : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Qty to Book In'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EbumgBme : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Reference Doc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WmsRfbel : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Reference Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WmsRfpos : String(6);
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Date of Manuf.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Hsdat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Confirm Date of Manufacture'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzhsdat : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Debit/Credit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeDiffPostIndicator : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Except.Code WH'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeExceptCode : String(4);
    @sap.unicode : 'false'
    @sap.label : 'RMA Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeAuthNumber : String(20);
    @sap.unicode : 'false'
    @sap.unit : 'SpeBaseUom'
    @sap.label : 'GR-Posted Qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeRetQtyPost : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Base Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    SpeBaseUom : String(3);
    @sap.unicode : 'false'
    @sap.label : 'RMA No. Completed'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeAuthComplet : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeAuthCompletF : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Closing Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeRetClosingIndicator : Boolean;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Begin Valid. Period'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeExpDateExtB : DateTime;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'End Validity Period'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeExpDateExt : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Stock Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeMdiffInsmk : String(1);
    @sap.unicode : 'false'
    @sap.label : 'In Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeImwrkItm : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Update Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeImwrkItmF : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Original System Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeOrigSys : String(1);
    @sap.unicode : 'false'
    @sap.label : 'CQ Vendor'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeCumVend : Decimal(15, 3);
    @sap.unicode : 'false'
    @sap.label : 'CQ In Transit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeCumItqs : Decimal(15, 3);
    @sap.unicode : 'false'
    @sap.label : 'CQ Received for SA'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeCumSa : Decimal(15, 3);
    @sap.unicode : 'false'
    @sap.label : 'Ext. ident.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeLifexpos2 : String(35);
    @sap.unicode : 'false'
    @sap.label : 'DeliveryVsn'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeVersion : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Qty (stckp.unt)'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeDlvQtyFrom : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Maintain INMSK'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeInmskF : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Mtn SPE_LIFEXPOS2'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeLifexpos2F : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'DeliveryItemUpdate'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeInbItmUpd : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Item Descr.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Arktx : String(40);
    @sap.unicode : 'false'
    @sap.label : 'Staging Area'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgbzo : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Location'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgort : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Stor. locations'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzlgo : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Ext. item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lifexpos : String(6);
    @sap.unicode : 'false'
    @sap.label : 'ConfExtItemNumber'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzlxp : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Valuation Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Bwtar : String(10);
    @sap.unicode : 'false'
    @sap.label : 'ConfValuationType'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzbwt : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Mat.Freight Grp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Mfrgr : String(8);
    @sap.unicode : 'false'
    @sap.label : 'EAN/UPC'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ean11 : String(18);
    @sap.unicode : 'false'
    @sap.label : 'Supp. Mat. No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Idnlf : String(35);
    @sap.unicode : 'false'
    @sap.label : 'Customer Mat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kdmat : String(35);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzKdmat : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'C/R of Origin'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeHerkl : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzSpeHerkl : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Reg. of Origin'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeHerkr : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzSpeHerkr : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Supplier Batch'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lichn : String(15);
    @sap.unicode : 'false'
    @sap.label : 'Usage'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Abrvw : String(3);
    @sap.unicode : 'false'
    @sap.label : 'TextChanges'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kztxt : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Del Txt in All Lang'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TxtoldDelAllLang : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Movement Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffBwart : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Reason for Mvmt'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffGrund : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Location'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffLgort : String(4);
    @sap.unicode : 'false'
    @sap.label : 'ConfSplitQuanDiffPro'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffAutoSplit : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Material Doc EWM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeMdnumEwm : String(16);
    @sap.unicode : 'false'
    @sap.label : 'Material Item EWM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeMditmEwm : String(4);
    @sap.unicode : 'false'
    @sap.label : 'OrgMaterial Doc EWM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeOmdnumEwm : String(16);
    @sap.unicode : 'false'
    @sap.label : 'OrgMaterial Item EWM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeOmditmEwm : String(4);
    @sap.unicode : 'false'
    @sap.unit : 'Vrkme'
    @sap.label : 'Delivery Qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ormng : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'GTS Stock Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeGtsStockType : String(1);
    @sap.unicode : 'false'
    @sap.label : 'CQ Vendor'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeLieffz : Decimal(15, 3);
    @sap.unicode : 'false'
    @sap.label : 'Numerator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeApoQntyfac : Decimal(5, 0);
    @sap.unicode : 'false'
    @sap.label : 'Denominator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeApoQntydiv : Decimal(5, 0);
    @sap.unicode : 'false'
    @sap.label : 'Pick Denial'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpePickDenial : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'No Serial Number Upd'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NoSernrUpdate : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Indicator: Delete Serial Numbers'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SernrDel : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Docu. Batch'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FlagDocub : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'No conversion'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeXnocon : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Qty to Book In'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeEbumg : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Movement Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Bwart : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Upd. Ormng'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SpeForceOrmngUpdate : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Inspection GUID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    InspDocGuid : UUID;
    @sap.unicode : 'false'
    @sap.label : 'Req. Segment'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SgtRcat : String(40);
    @sap.unicode : 'false'
    @sap.label : 'Stock Segment'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SgtScat : String(40);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzItmEmcst : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Embargo Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ItmEmcst : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzItmSlcst : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Screening Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ItmSlcst : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzItmLccst : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Legal Control Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ItmLccst : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzArcStatus : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'ET ARC Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ArcStatus : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Resource'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ResourceId : String(40);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzResourceId : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Receiv. Resource'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UmresourceId : String(40);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzUmresourceId : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Load./Unload. Pt'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LoadingPoint : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KzLoadingPoint : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Dummy function in length 1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DummyDelitmInclEewPs : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Updt Extn Fields'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    UpdateExtensionFields : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Ignore GM Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IgnoreGoodsMvmtStatus : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Ignore Distr Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    IgnoreDistributionStatus : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LipsCre : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Reference Doc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vgbel : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Reference Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vgpos : String(6);
    @sap.unicode : 'false'
    @sap.label : 'Document Cat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vgtyp : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Reference item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Rfpos : String(6);
    @sap.unicode : 'false'
    @sap.label : 'Warehouse No.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgnum : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Door for Whse'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lgtor : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Higher-Lev.Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Uepos : String(6);
    @sap.unicode : 'false'
    @sap.label : 'Usage HL Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Uepvw : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Checkbox'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Kzuep : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Item Category'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Pstyv : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Compl Ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffCompl : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Do Not Adj. CRQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffFzgls : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Adjust Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffEtanp : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Dialog box'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MdiffPopup : String(1);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity prot_returnSet {
    @sap.unicode : 'false'
    @sap.label : 'Delivery'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Vbeln : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Posnr : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Matnr : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item Descr.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Arktx : String(40) not null;
    @sap.unicode : 'false'
    @sap.unit : 'Vrkme'
    @sap.label : 'Delivery Qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Lfimg : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sales Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Vrkme : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Batch'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Charg : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Msgno : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Msgty : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Msgid : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message var.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Msgv1 : String(50) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message var.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Msgv2 : String(50) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message var.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Msgv3 : String(50) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message var.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Msgv4 : String(50) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity LocPointDPTypeSet {
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Locid : String(10) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Locnam : String(60) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Loctype : String(4) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Loctypetext : String(15) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Loctypelongtext : String(60) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Transportsystem : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity GetMaterialValueSet {
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Material : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Plant : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'UOM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    key UOM : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Des : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Name 1'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PlantDesc : String(30) not null;
    @sap.unicode : 'false'
    @sap.label : 'Meas. Unit Text'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Msehl : String(30) not null;
    to_sloc : Association to many MARDViewSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity MARDViewSet {
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Material : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Plant : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key StorageLocation : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MaterialName : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MaterialType : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Mat.Type Desc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MaterialTypeName : String(25) not null;
    @sap.unicode : 'false'
    @sap.label : 'Storage Loc. Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StorageLocationName : String(16) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity FetchMaterialValue {
    @sap.unicode : 'false'
    @sap.label : 'Sales Org.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    key SalesOrg : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Distr. Channel'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    key DistrChannel : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Division'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    key Division : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material Group'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    key MaterialGroup : String(9) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    key MaterialType : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sold-to Party'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    key Customer : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    key Material : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    key Plant : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Unit of Measure'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.semantics : 'unit-of-measure'
    key UOM : String(3) not null;
    to_MaterialValue : Association to many GetMaterialValueSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity GETTEXTFIELDSet {
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TabName : String(15) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key FieldName : String(20) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity getDynamicTextSet {
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TxtTabName : String(20) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TxtFieldName : String(20) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KeyFldName : String(20) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    keyFldValue : String(20) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TextValue : String(50) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity CustomTableFieldDataSet {
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Tabname : String(30) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Fieldname : String(30) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key RowKey : String(255) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FieldValue : String not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity FetchExtensionStructures {
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Tabname : String(30) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Fieldname : String(30) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreateStructure : String(30) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreateStructureName : String(60) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChangeStructure : String(30) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChangeStructureName : String(60) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity GMSDaynamicHelpSet {
    @sap.unicode : 'false'
    @sap.label : 'Short text'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Fieldname : String(60) not null;
    @sap.unicode : 'false'
    @sap.label : 'Number of Hits'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Recordpos : Integer not null;
    @sap.unicode : 'false'
    @sap.label : 'Field content'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Fieldval : String(132) not null;
    @sap.unicode : 'false'
    @sap.label : 'Truth Value'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Isreturnfield : Boolean not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity GMSGetFilterDataSet {
    @sap.unicode : 'false'
    @sap.label : 'Table Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Tabname : String(30) not null;
    @sap.unicode : 'false'
    @sap.label : 'Field Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Fieldname : String(30) not null;
    GMSTableHelpNav : Association to many GMSDaynamicHelpSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Capacity Release Value Help'
  entity xGMSxCap_Rel_vh {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Locid : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Material : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    Tsyst : String(10);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    Locnam : String(60);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Location - Co. Code - Cont. Area'
  entity xGMSxCCODEAREALOC {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key LocationId : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    key TransportSystem : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Company Code'
    @sap.quickinfo : 'Company code of the sales organization'
    key CompanyCode : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Controlling Area'
    key ControllingArea : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location type'
    @sap.quickinfo : 'OIL-TSW: Location type'
    LocationType : String(4);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    LocationName : String(60);
    @sap.label : 'Company Name'
    @sap.quickinfo : 'Name of Company Code or Company'
    CompanyCodeName : String(25);
    @sap.label : 'Controlling Area Name'
    ControllingAreaName : String(25);
    to_locmat : Association to many I_OilLocMatlPlanning {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch Common Customer'
  entity xGMSxCommonCustomer {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer number of business partner'
    key Customer : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Partner Function'
    key PartnerFunction : String(2) not null;
    @sap.label : 'Name of Customer'
    CustomerName : String(80);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Condition Type'
  entity xGMSxCONDITIONTYPE {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Condition Type'
    key Condition_Type : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Application'
    key ConditionApplication : String(2) not null;
    @sap.label : 'Description'
    Condition_TypeName : String(30);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Value Help for Configuration'
  entity xGMSxCONFIGVH {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Document'
    key ContractNumber : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master Contract'
    @sap.quickinfo : 'Master Contract Number'
    key MasterContractNumber : String(10) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Customer Ref. Date'
    @sap.quickinfo : 'Customer Reference Date'
    CustRefDate : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Pricing Date'
    @sap.quickinfo : 'Date for Pricing and Exchange Rate'
    PriceDate : Date;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Order Reason'
    @sap.quickinfo : 'Order Reason (Reason for the Business Transaction)'
    OrderReason : String(3);
    @sap.label : 'Description'
    OrderReasonDescription : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Incoterms'
    @sap.quickinfo : 'Incoterms (Part 1)'
    Incoterms : String(3);
    @sap.label : 'Description'
    IncotermsDescription : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material Price Grp'
    @sap.quickinfo : 'Material Price Group'
    MaterialPricingGroup : String(2);
    @sap.label : 'Description'
    MaterialPricingGrpDescription : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group'
    CustomerGroup : String(2);
    @sap.label : 'Name'
    CustomerGroupDescription : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Storage Location'
    StorageLocation : String(4);
    @sap.label : 'Description'
    @sap.quickinfo : 'Description of Storage Location'
    StorageLocationDescription : String(16);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Price List Type'
    PriceListType : String(2);
    @sap.label : 'Description'
    @sap.quickinfo : 'Text (20 Characters)'
    PriceListTypeDescription : String(20);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract Type Value Help'
  entity xGMSxContractType {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Document Type'
    key Auart : String(4) not null;
    @sap.label : 'SD Document Category'
    key Doctyp : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Screen sequence grp.'
    @sap.quickinfo : 'Screen sequence group for document header & item'
    key Kopgr : String(4) not null;
    @sap.label : 'Description'
    @sap.quickinfo : 'Sales Document Type Description'
    Description : String(20);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract-Billing FLow'
  entity xGMSxCONT_BILLING_FLOW {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Document'
    key Contract_no : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Document'
    key Billing_no : String(10) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Billing Date'
    Billing_date : Date;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Type'
    Billing_type : String(4);
    @sap.label : 'SD Document Category'
    Billing_category : String(4);
    @sap.label : 'SD Document Category'
    Contract_type : String(4);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Currency Data'
  entity xGMSxCURRENCY {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Currency'
    @sap.quickinfo : 'Currency Key'
    @sap.semantics : 'currency-code'
    key Currency : String(5) not null;
    @sap.label : 'Description'
    CurrencyName : String(40);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Customer Group Value Help'
  entity xGMSxCUSTGRPVH {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group'
    key CustomerGroup : String(2) not null;
    @sap.label : 'Description'
    @sap.quickinfo : 'Name'
    Description : String(20);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch Data for DCQ Limit Contract Validation'
  entity xGMSxDCQLIMITDATA {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Contract'
    key ContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Office'
    key SalesOffice : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sold-to Party'
    key Customer : String(10) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid-From Date'
    @sap.quickinfo : 'Valid-From Date (Outline Agreements, Product Proposals)'
    ValidFrom : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Valid-To Date'
    @sap.quickinfo : 'Valid-To Date (Outline Agreements, Product Proposals)'
    ValidTo : Date;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Delivery Point'
  entity xGMSxDel_Pt {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Business location ID'
    @sap.quickinfo : 'Business location identifier (IS-Oil MRN)'
    key Pblnr : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    key Tsyst : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Locid : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Bus. Location Type'
    @sap.quickinfo : 'Business Location Type (IS-Oil MRN)'
    key Pbltyp : String(4) not null;
    @sap.label : 'Origin'
    @sap.quickinfo : 'OIL-TSW: Location is origin flag'
    Delivery_Point : Boolean;
    @sap.label : 'Destination'
    @sap.quickinfo : 'OIL-TSW: Location destination flag'
    Redelivery_Point : Boolean;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Distribution Channel'
  entity xGMSxDistribution {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Distribution Channel'
    key Vtweg : String(2) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Division'
  entity xGMSxDivision {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Division'
    key Spart : String(2) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch Document Type'
  entity xGMSxDOCUMENTTYPES {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purchasing Doc. Type'
    @sap.quickinfo : 'Purchasing Document Type'
    key DocumentType : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purch. Doc. Category'
    @sap.quickinfo : 'Purchasing Document Category'
    key DocumentCategory : String(1) not null;
    @sap.label : 'Doc. Type Descript.'
    @sap.quickinfo : 'Short Description of Purchasing Document Type'
    DocumentTypeText : String(20);
    @sap.label : 'Short Description'
    @sap.quickinfo : 'Short Text for Fixed Values'
    DocumentCategoryText : String(60);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Get Delivery Points'
  entity xGMSxDP_GET {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key DeliveryPoint : String(10) not null;
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    key DeliveryPointName : String(60) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Event for Nomination'
  entity xGMSxEvent_type {
    @sap.label : 'Language Key'
    key Lang : String(2) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'IS-Oil Event Type'
    @sap.quickinfo : 'TD - event type'
    key Type : String(4) not null;
    @sap.label : 'Event Type Text'
    @sap.quickinfo : 'TD - event type text'
    TypeText : String(40);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Exchange Types Value Help'
  entity xGMSxEXCHGTYPEVH {
    @sap.label : 'Language Key'
    key Spras : String(2) not null;
    @sap.display.format : 'UpperCase'
    @sap.text : 'Exgtxt'
    @sap.label : 'Exchange type'
    key Exgtyp : String(4) not null;
    @sap.label : 'Exchange type'
    @sap.quickinfo : 'Exchange type description'
    Exgtxt : String(30);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch Data for InterConnect Point'
  entity xGMSxFETCHINTERCONNECT_POINT {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key InterConnect_Point : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetching Redelivery for Customer'
  entity xGMSxFetchRedelivery {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer Number'
    key Customer : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Account Number of Supplier'
    key SupplierAccount : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    key Plant : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Storage Location'
    key StorageLocation : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Role partner type'
    @sap.quickinfo : 'OIL-TSW: Role partner type'
    OilPartnerRoleType : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    LocationId : String(10);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    LocationDesc : String(60);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Internal Consumption Monthly Avg.'
  entity xGMSxICMONTHAVGQTY {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key LocationId : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Scheduled material'
    key Material : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location type'
    @sap.quickinfo : 'OIL-TSW: Location type'
    LocationType : String(4);
    MonthYear : String(6);
    @sap.display.format : 'NonNegative'
    WeekBucket : String(1);
    @sap.display.format : 'NonNegative'
    FortnightBucket : String(1);
    @sap.unit : 'AvgActualScheduledQuantityUnit'
    @sap.label : 'Actual posted Qty'
    @sap.quickinfo : 'Actual posted quantity'
    AvgActualScheduledQty : Decimal(13, 3);
    @sap.label : 'Act. Unit of Measure'
    @sap.quickinfo : 'Actual posted quantity Unit of Measure'
    @sap.semantics : 'unit-of-measure'
    AvgActualScheduledQuantityUnit : String(3);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Incoterms Value Help'
  entity xGMSxINCO1VH {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Incoterms'
    @sap.quickinfo : 'Incoterms (Part 1)'
    key Incoterms : String(3) not null;
    @sap.label : 'Incoterms Description'
    @sap.quickinfo : 'Description'
    Description : String(30);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Interconnect'
  entity xGMSxInterconnect {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Business location ID'
    @sap.quickinfo : 'Business location identifier (IS-Oil MRN)'
    key Pblnr : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    key Tsyst : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Locid : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Bus. Location Type'
    @sap.quickinfo : 'Business Location Type (IS-Oil MRN)'
    key Pbltyp : String(4) not null;
    @sap.label : 'Origin'
    @sap.quickinfo : 'OIL-TSW: Location is origin flag'
    Delivery_Point : Boolean;
    @sap.label : 'Destination'
    @sap.quickinfo : 'OIL-TSW: Location destination flag'
    Redelivery_Point : Boolean;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch Data for InterConnect Point'
  entity xGMSxINTERCONNECT_TRANS {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key InterConnect_Point : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    Transport_System : String(10);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Location'
  entity xGMSxLocation {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Business location ID'
    @sap.quickinfo : 'Business location identifier (IS-Oil MRN)'
    key Pblnr : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Business loc. name'
    @sap.quickinfo : 'Internal name field'
    Name1 : String(35);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Location Material VH'
  entity xGMSxLocMatnr {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Locid : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Pmatnr : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    key Tsyst : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location type'
    @sap.quickinfo : 'OIL-TSW: Location type'
    Loctyp : String(4);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    Locnam : String(60);
    @sap.label : 'Planning UoM'
    @sap.quickinfo : 'OIL-TSW: Planning UoM'
    @sap.semantics : 'unit-of-measure'
    Pluom : String(3);
    @sap.label : 'Material Description'
    Pmatname : String(40);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Location Points'
  entity xGMSxLocPoint {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Locid : String(10) not null;
    @sap.label : 'Location Name'
    @sap.quickinfo : 'Location name (used by system owner)'
    Locnam : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location Type'
    @sap.quickinfo : 'OIL-TSW: Location type'
    Loctyp : String(4);
    @sap.label : 'Location Type Short Text'
    @sap.quickinfo : 'Short text'
    LoctypText : String(15);
    @sap.label : 'Location Type Long Text'
    @sap.quickinfo : 'OIL-TSW: Documentation text (with length 60 char)'
    LoctypLongText : String(60);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Location Points - DP'
  entity xGMSxLocPoint_DP {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Locid : String(10) not null;
    @sap.label : 'Location Name'
    @sap.quickinfo : 'Location name (used by system owner)'
    Locnam : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location Type'
    @sap.quickinfo : 'OIL-TSW: Location type'
    Loctyp : String(4);
    @sap.label : 'Location Type Short Text'
    @sap.quickinfo : 'Short text'
    LoctypText : String(15);
    @sap.label : 'Location Type Long Text'
    @sap.quickinfo : 'OIL-TSW: Documentation text (with length 60 char)'
    LoctypLongText : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport System'
    @sap.quickinfo : 'Transport system'
    TransportSystem : String(10);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Location Path Mapping Value Help'
  entity xGMSxLocPoint_Map {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Business location ID'
    @sap.quickinfo : 'Business location identifier (IS-Oil MRN)'
    key Pblnr : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    key Tsyst : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Locid : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Bus. Location Type'
    @sap.quickinfo : 'Business Location Type (IS-Oil MRN)'
    key Pbltyp : String(4) not null;
    @sap.label : 'System name'
    @sap.quickinfo : 'OIL-TSW: Transport system name'
    Tsnam : String(60);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    Locnam : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Shipping Type'
    Vsart : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'In-transit plant'
    @sap.quickinfo : 'Transport system In-transit Plant'
    Werks : String(4);
    @sap.label : 'Deletion indicator'
    TsystDelind : Boolean;
    @sap.label : 'Blocking Ind.'
    @sap.quickinfo : 'Blocking indicator'
    TsystBloind : Boolean;
    @sap.label : 'Deletion indicator'
    LocidDelind : Boolean;
    @sap.label : 'Blocking Ind.'
    @sap.quickinfo : 'Blocking indicator'
    LocidBloind : Boolean;
    @sap.label : 'Entry to Be Deleted'
    @sap.quickinfo : 'Deletion indicator'
    oifspblDelind : Boolean;
    @sap.label : 'Entry is Blocked'
    @sap.quickinfo : 'Block Indicator'
    oifspblBloind : Boolean;
    @sap.label : 'Origin'
    @sap.quickinfo : 'OIL-TSW: Location is origin flag'
    Delivery_Point : Boolean;
    @sap.label : 'Destination'
    @sap.quickinfo : 'OIL-TSW: Location destination flag'
    Redelivery_Point : Boolean;
    isDeliveryPoint : String(3);
    isRedeliveryPoint : String(3);
    isInterconnect : String(3);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Location Points - RDP'
  entity xGMSxLocPoint_RDP {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Locid : String(10) not null;
    @sap.label : 'Location Name'
    @sap.quickinfo : 'Location name (used by system owner)'
    Locnam : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location Type'
    @sap.quickinfo : 'OIL-TSW: Location type'
    Loctyp : String(4);
    @sap.label : 'Location Type Short Text'
    @sap.quickinfo : 'Short text'
    LoctypText : String(15);
    @sap.label : 'Location Type Long Text'
    @sap.quickinfo : 'OIL-TSW: Documentation text (with length 60 char)'
    LoctypLongText : String(60);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch Transport System Based On Location'
  entity xGMSxLOCTRANS {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Locid : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    Tsyst : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Business type'
    Bustyp : String(4);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Master Agreement Types'
  entity xGMSxMasterAgreementTypes {
    @sap.display.format : 'UpperCase'
    @sap.text : 'MasterAgreementTypeText'
    @sap.label : 'Maste Agreement Type'
    @sap.quickinfo : 'IGMS Contract Type'
    key MasterAgreementType : String(5) not null;
    @sap.label : 'iGMS Cont. Typ. Desc'
    @sap.quickinfo : 'iGMS Master Agreement Type description'
    MasterAgreementTypeText : String(50);
    @sap.label : 'One-Sided Agreement'
    @sap.quickinfo : 'One-sided Agreement'
    OneSided : Boolean;
    @sap.label : 'Two-Sided Agreement'
    @sap.quickinfo : 'One-sided Agreement'
    TwoSided : Boolean;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Material'
  entity xGMSxMaterial {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Matnr : String(40) not null;
    @sap.label : 'Base Unit of Measure'
    @sap.semantics : 'unit-of-measure'
    Meins : String(3);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Material Data MARA_MAKT'
  entity xGMSxMaterial_Data {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Material : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    key Plant : String(4) not null;
    @sap.label : 'Base UOM'
    @sap.semantics : 'unit-of-measure'
    key UOM : String(3) not null;
    @sap.label : 'Description'
    @sap.quickinfo : 'Material Description'
    Des : String(40);
    @sap.label : 'Plant Description'
    @sap.quickinfo : 'Name'
    PlantDesc : String(30);
    @sap.label : 'Unit of Measure Long Text'
    @sap.quickinfo : 'Unit of Measurement Text (Maximum 30 Characters)'
    Msehl : String(30);
    to_sloc : Association to many xgmsxmatplntsloc {  };
    to_valuation : Association to many I_ProductValuation {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'MARD View'
  entity xgmsxmatplntsloc {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Material : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    key Plant : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Storage Location'
    key StorageLocation : String(4) not null;
    @sap.label : 'Material Description'
    MaterialName : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material Type'
    MaterialType : String(4);
    @sap.label : 'Material Type Desc.'
    @sap.quickinfo : 'Description of Material Type'
    MaterialTypeName : String(25);
    @sap.label : 'Storage Loc. Name'
    @sap.quickinfo : 'Storage Location Name'
    StorageLocationName : String(16);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Material Pricing Group Value Help'
  entity xGMSxMATPRCGRPVH {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material Pricing Group'
    @sap.quickinfo : 'Material Price Group'
    key MaterialPricingGroup : String(2) not null;
    @sap.label : 'Description'
    Description : String(20);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Purchasing Contract Validity'
  entity xGMSxMMVALIDITY {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purchasing Document'
    @sap.quickinfo : 'Purchasing Document Number'
    key Purchasingdocument : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Supplier''s Account Number'
    Vendor : String(10);
    @sap.label : 'Name of Supplier'
    VendorName : String(80);
    @sap.display.format : 'Date'
    @sap.label : 'Validity Per. Start'
    @sap.quickinfo : 'Start of Validity Period'
    ValidityStartDate : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Validity Period End'
    @sap.quickinfo : 'End of Validity Period'
    ValidityEndDate : Date;
    ContractualDays : Integer;
    DaysFromExpiry : Integer;
    IsExpired : String(1);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Master Contract Number Value Help'
  entity xGMSxMSRTCONTRVH {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Number'
    @sap.quickinfo : 'Sales Document'
    key ContractNumber : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Non-Valuated Materials'
  entity xGMSxNVMATERIALS {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Material : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Valuation Type'
    key InventoryValuationType : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Valuation Area'
    key ValuationArea : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    key Plant : String(4) not null;
    @sap.label : 'Material Description'
    MaterialDesc : String(40);
    @sap.label : 'Plant Name'
    PlantDesc : String(30);
    to_sloc : Association to many xgmsxmatplntsloc {  };
    to_UoM : Association to many xGMSxMaterial_Data {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Order Reason Value Help'
  entity xGMSxORDRSN_VH {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Order Reason'
    @sap.quickinfo : 'Order Reason (Reason for the Business Transaction)'
    key OrderReason : String(3) not null;
    @sap.label : 'Description'
    Description : String(40);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Plant'
  entity xGMSxPlant {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Matnr : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    key Werks : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Company Code'
    CompanyCode : String(4);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Price List Value Help'
  entity xGMSxPRCLISTVH {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Price List'
    @sap.quickinfo : 'Price List Type'
    key PriceList : String(2) not null;
    @sap.label : 'Description'
    @sap.quickinfo : 'Text (20 Characters)'
    Description : String(20);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Price List Value Help'
  entity xGMSxPRICELISTVH {
    @sap.display.format : 'UpperCase'
    @sap.text : 'to_PriceListType/PriceListType_Text'
    @sap.label : 'Price List Type'
    @sap.value.list : 'standard'
    key PriceListType : String(2) not null;
    @sap.label : 'Language Key'
    key Language : String(2) not null;
    @sap.label : 'Description'
    @sap.quickinfo : 'Text (20 Characters)'
    PriceListTypeName : String(20);
    to_PriceListType : Association to I_PriceListType {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Get ReDelivery Points'
  entity xGMSxRDP_GET {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key ReDeliveryPoint : String(10) not null;
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    key ReDeliveryPointName : String(60) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Redelivery Point'
  entity xGMSxRd_Point {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Business location ID'
    @sap.quickinfo : 'Business location identifier (IS-Oil MRN)'
    key Pblnr : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    key Tsyst : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Locid : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Bus. Location Type'
    @sap.quickinfo : 'Business Location Type (IS-Oil MRN)'
    key Pbltyp : String(4) not null;
    @sap.label : 'Origin'
    @sap.quickinfo : 'OIL-TSW: Location is origin flag'
    Delivery_Point : Boolean;
    @sap.label : 'Destination'
    @sap.quickinfo : 'OIL-TSW: Location destination flag'
    Redelivery_Point : Boolean;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch Pricing Condition'
  entity xGMSxSALESPRICINGCONDITION {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Condition Type'
    key Condition_Type : String(4) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Sales Contract'
  entity xGMSxSales_Cont {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Document'
    key Vbeln : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Sales Organization'
  entity xGMSxSales_Org {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Organization'
    key Vkorg : String(4) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Sales Contract Validity'
  entity xGMSxSDVALIDITY {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Document'
    key SalesDocument : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sold-to Party'
    Customer : String(10);
    @sap.label : 'Name of Customer'
    CustomerName : String(80);
    @sap.display.format : 'Date'
    @sap.label : 'Valid-From Date'
    @sap.quickinfo : 'Valid-From Date (Outline Agreements, Product Proposals)'
    ValidityStartDate : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Valid-To Date'
    @sap.quickinfo : 'Valid-To Date (Outline Agreements, Product Proposals)'
    ValidityEndDate : Date;
    ContractualDays : Integer;
    DaysToExpiry : Integer;
    IsExpired : String(1);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Ship To Party'
  entity xGMSxShip_To_Party {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer Number'
    key Kunnr : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Organization'
    key Vkorg : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Distribution Channel'
    key Vtweg : String(2) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Division'
    key Spart : String(2) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Sold to Party'
  entity xGMSxSold_to_Party {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer Number'
    key Kunnr : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Storage Location Value Help'
  entity xGMSxSTRLOCVH {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Storage Location'
    key StorageLocation : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    key Plant : String(4) not null;
    @sap.label : 'Description'
    @sap.quickinfo : 'Description of Storage Location'
    Description : String(16);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Get Table Fields'
  entity xGMSxTABLEFIELDSDATA {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Table Name'
    key TableName : String(30) not null;
    @sap.label : 'Short Description'
    @sap.quickinfo : 'Short Description of Repository Objects'
    TableText : String(60);
    to_TBLFIELDSDATA : Association to many xGMSxTABLEFIELDSDATA1 {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Get Table Fields'
  entity xGMSxTABLEFIELDSDATA1 {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Table Name'
    key TabName : String(30) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Field Name'
    key FieldName : String(30) not null;
    FieldNameNoUnderscore : String(30);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Table position'
    @sap.quickinfo : 'Position of the field in the table'
    FieldPosition : String(4);
    @sap.label : 'Key field'
    @sap.quickinfo : 'Identifies a key field of a table'
    KeyFlag : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Type'
    @sap.quickinfo : 'Data Type in ABAP Dictionary'
    TableDataType : String(10);
    @sap.display.format : 'NonNegative'
    @sap.label : 'No. of Characters'
    @sap.quickinfo : 'Length (No. of Characters)'
    TableLength : String(6);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Decimal Places'
    @sap.quickinfo : 'Number of Decimal Places'
    TableDecimals : String(6);
    @sap.label : 'ABAP type'
    @sap.quickinfo : 'ABAP data type (C,D,N,...)'
    TableIntType : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference table'
    @sap.quickinfo : 'Reference Table for Field'
    RefTable : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ref. field'
    @sap.quickinfo : 'Reference Field for Currency and Quantity Fields'
    RefField : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Check table'
    @sap.quickinfo : 'Check table name of the foreign key'
    Checktable : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Element'
    @sap.quickinfo : 'Data Element (Semantic Domain)'
    TableDTEL : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Field Name'
    BAPIFieldName : String(30);
    @sap.label : 'Short Field Label'
    LabelShort : String(10);
    @sap.label : 'Medium Field Label'
    LabelMedium : String(20);
    @sap.label : 'Long field label'
    @sap.quickinfo : 'Long Field Label'
    LabelLong : String(40);
    @sap.label : 'Heading'
    Heading : String(55);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Transport'
  entity xGMSxTransport {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    key Tsyst : String(10) not null;
    @sap.label : 'System name'
    @sap.quickinfo : 'OIL-TSW: Transport system name'
    Tsnam : String(60);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Transport System Location'
  entity xGMSxTsystLoc {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    key Tsyst : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Locid : String(10) not null;
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    Locnam : String(60);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Uom'
  entity xGMSxUOM {
    @sap.label : 'Internal UoM'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    key Msehi : String(3) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Uom'
  entity xGMSxUOM_value {
    @sap.label : 'Unit of Measure'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    key Msehi : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Dimension Key'
    @sap.quickinfo : 'Dimension key'
    Dimid : String(6);
    @sap.label : 'Unit of Measure Short Text'
    @sap.quickinfo : 'Unit of Measurement Text (Maximum 10 Characters)'
    Mseht : String(10);
    @sap.label : 'Unit of Measure Long Text'
    @sap.quickinfo : 'Unit of Measurement Text (Maximum 30 Characters)'
    Msehl : String(30);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Projection for Utr Mapping table'
  entity xGMSxUTRMAPV {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    key Tsyst : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Locid : String(10) not null;
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    Locnam : String(60);
    @sap.label : 'System name'
    @sap.quickinfo : 'OIL-TSW: Transport system name'
    Tsnam : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Source Code'
    Zscode : String(3);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Vendor name and Description'
  entity xGMSxvendorportal {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Account Number of Supplier'
    key VendorNo : String(10) not null;
    @sap.label : 'Name'
    @sap.quickinfo : 'Name 1'
    VendorName : String(35);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Vendor, Purch Org'
  entity xGMSxVendPurchOrgCoVH {
    @sap.display.format : 'UpperCase'
    @sap.text : 'to_Supplier/SupplierName'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Supplier''s Account Number'
    @sap.value.list : 'standard'
    key Supplier : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.text : 'PurchasingOrganizationName'
    @sap.label : 'Purch. Organization'
    @sap.quickinfo : 'Purchasing Organization'
    key PurchasingOrganization : String(4) not null;
    @sap.label : 'Name of Supplier'
    SupplierName : String(80);
    @sap.label : 'Purch. Org. Name'
    @sap.quickinfo : 'Purchasing Organization Name'
    PurchasingOrganizationName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.text : 'PurchasingGroupName'
    @sap.label : 'Purchasing Group'
    PurchasingGroup : String(3);
    @sap.label : 'Purchasing Grp. Name'
    @sap.quickinfo : 'Purchasing Group Name'
    PurchasingGroupName : String(18);
    @sap.label : 'Planned Deliv. Time'
    @sap.quickinfo : 'Planned Delivery Time in Days'
    MaterialPlannedDeliveryDurn : Decimal(3, 0);
    @sap.label : 'Pur. block POrg'
    @sap.quickinfo : 'Purchasing block at purchasing organization level'
    PurchasingIsBlockedForSupplier : Boolean;
    @sap.label : 'Salesperson'
    @sap.quickinfo : 'Responsible Salesperson at Supplier''s Office'
    SupplierRespSalesPersonName : String(30);
    @sap.label : 'Telephone'
    @sap.quickinfo : 'Supplier''s Telephone Number'
    SupplierPhoneNumber : String(16);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Order currency'
    @sap.quickinfo : 'Purchase order currency'
    @sap.semantics : 'currency-code'
    PurchaseOrderCurrency : String(5);
    @sap.unit : 'PurchaseOrderCurrency'
    @sap.label : 'Minimum order value'
    MinimumOrderAmount : Decimal(14, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Schema Grp, Supplier'
    @sap.quickinfo : 'Group for Calculation Schema (Supplier)'
    CalculationSchemaGroupCode : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Terms of Payment'
    @sap.quickinfo : 'Terms of Payment Key'
    PaymentTerms : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Payment Terms Description'
    PaymentTermsDescription : String(1024);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Pricing Date Control'
    @sap.quickinfo : 'Price Determination (Pricing) Date Control'
    PricingDateControl : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'ABC indicator'
    SupplierABCClassificationCode : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Shipping Conditions'
    ShippingCondition : String(2);
    @sap.label : 'Automatic PO'
    @sap.quickinfo : 'Automatic Generation of Purchase Order Allowed'
    PurOrdAutoGenerationIsAllowed : Boolean;
    @sap.label : 'GR-Based Inv. Verif.'
    @sap.quickinfo : 'Indicator: GR-Based Invoice Verification'
    InvoiceIsGoodsReceiptBased : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.text : 'IncotermsClassificationName'
    @sap.label : 'Incoterms'
    @sap.quickinfo : 'Incoterms (Part 1)'
    IncotermsClassification : String(3);
    @sap.label : 'Incoterms Classification Desc'
    @sap.quickinfo : 'Incoterms Classification Description'
    IncotermsClassificationName : String(30);
    to_customer : Association to I_Customer {  };
    to_IncotermsClassfctnText : Association to C_IncotermsClassfctnTextVHTemp {  };
    to_PurgOrganization : Association to I_PurchasingOrganization {  };
    to_Supplier : Association to I_Supplier {  };
    to_supplierCompany : Association to many I_SupplierCompanyVH {  };
    to_supplierCompanyByPlant : Association to many I_SupplierCompanyByPlant {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Incoterms classfication value help text'
  entity C_IncotermsClassfctnTextVHTemp {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Incoterms'
    @sap.quickinfo : 'Incoterms (Part 1)'
    key IncotermsClassification : String(3) not null;
    @sap.label : 'Language Key'
    key Language : String(2) not null;
    @sap.label : 'Incoterms Classification Desc'
    @sap.quickinfo : 'Incoterms Classification Description'
    IncotermsClassificationName : String(30);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Address'
  entity I_Address {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Address Number'
    key AddressID : String(10) not null;
    @sap.label : 'Address UUID'
    @sap.quickinfo : 'UUID Used in the Address'
    AddressUUID : UUID;
    @sap.label : 'c/o'
    @sap.quickinfo : 'c/o name'
    CareOfName : String(40);
    @sap.label : 'Street 5'
    AdditionalStreetSuffixName : String(40);
    @sap.label : 'Language Key'
    CorrespondenceLanguage : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Comm. Method'
    @sap.quickinfo : 'Communication Method (Key) (Business Address Services)'
    PrfrdCommMediumType : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'PO Box'
    POBox : String(10);
    @sap.label : 'PO Box w/o No.'
    @sap.quickinfo : 'Flag: PO Box Without Number'
    POBoxIsWithoutNumber : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'PO Box Postal Code'
    POBoxPostalCode : String(10);
    @sap.label : 'PO Box Lobby'
    POBoxLobbyName : String(40);
    @sap.label : 'PO Box City'
    @sap.quickinfo : 'PO Box city'
    POBoxDeviatingCityName : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'PO Box Region'
    @sap.quickinfo : 'Region for PO Box (Country/Region, State, Province, ...)'
    POBoxDeviatingRegion : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'PO Box Ctry/Region'
    @sap.quickinfo : 'PO Box of Country/Region'
    POBoxDeviatingCountry : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delvry Serv Type'
    @sap.quickinfo : 'Type of Delivery Service'
    DeliveryServiceTypeCode : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivery Service No.'
    @sap.quickinfo : 'Number of Delivery Service'
    DeliveryServiceNumber : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Time Zone'
    @sap.quickinfo : 'Address Time Zone'
    AddressTimeZone : String(6);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Test stat./City file'
    @sap.quickinfo : 'City file test status'
    CityFileTestStatus : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Undeliverable'
    @sap.quickinfo : 'Street Address Undeliverable Flag'
    AddressStreetUnusable : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Undeliverable'
    @sap.quickinfo : 'PO Box Address Undeliverable Flag'
    AddressPostBoxUnusable : String(4);
    @sap.label : 'Full Name'
    @sap.quickinfo : 'Full name of a party (Bus. Partner, Org. Unit, Doc. address)'
    FullName : String(80);
    @sap.label : 'City'
    CityName : String(40);
    @sap.label : 'District'
    District : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'City Code'
    @sap.quickinfo : 'City code for city/street file'
    CityCode : String(12);
    @sap.label : 'Different City'
    @sap.quickinfo : 'City (different from postal city)'
    HomeCityName : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Postal Code'
    @sap.quickinfo : 'City postal code'
    PostalCode : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Company Postal Code'
    @sap.quickinfo : 'Company Postal Code (for Large Customers)'
    CompanyPostalCode : String(10);
    @sap.label : 'Street'
    StreetName : String(60);
    @sap.label : 'Street 2'
    StreetPrefixName : String(40);
    @sap.label : 'Street 3'
    AdditionalStreetPrefixName : String(40);
    @sap.label : 'Street 4'
    StreetSuffixName : String(40);
    @sap.label : 'House Number'
    HouseNumber : String(10);
    @sap.label : 'Supplement'
    @sap.quickinfo : 'House number supplement'
    HouseNumberSupplementText : String(10);
    @sap.label : 'Building Code'
    @sap.quickinfo : 'Building (Number or Code)'
    Building : String(20);
    @sap.label : 'Floor'
    @sap.quickinfo : 'Floor in building'
    Floor : String(10);
    @sap.label : 'Room Number'
    @sap.quickinfo : 'Room or Apartment Number'
    RoomNumber : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Country/Region Key'
    Country : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Region'
    @sap.quickinfo : 'Region (State, Province, County)'
    Region : String(3);
    @sap.label : 'County'
    County : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'County code'
    @sap.quickinfo : 'County code for county'
    CountyCode : String(8);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Township code'
    @sap.quickinfo : 'Township code for Township'
    TownshipCode : String(8);
    @sap.label : 'Township'
    TownshipName : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Title Key'
    @sap.quickinfo : 'Form-of-Address Key'
    FormOfAddress : String(4);
    @sap.label : 'Name'
    @sap.quickinfo : 'Name 1'
    BusinessPartnerName1 : String(40);
    @sap.label : 'Name 2'
    BusinessPartnerName2 : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Address Version'
    @sap.quickinfo : 'Version ID for International Addresses'
    Nation : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Telephone'
    @sap.quickinfo : 'First Telephone No.: Dialing Code + Number'
    PhoneNumber : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Fax'
    @sap.quickinfo : 'First Fax No.: Area Code + Number'
    FaxNumber : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Search Term 1'
    SearchTerm1 : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Search Term 2'
    SearchTerm2 : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Street'
    @sap.quickinfo : 'Street Name in Uppercase for Search Help'
    StreetSearch : String(25);
    @sap.display.format : 'UpperCase'
    @sap.label : 'City'
    @sap.quickinfo : 'City name in Uppercase for Search Help'
    CitySearch : String(25);
    @sap.label : 'Name 3'
    BusinessPartnerName3 : String(40);
    @sap.label : 'Name 4'
    BusinessPartnerName4 : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Jurisdiction'
    TaxJurisdiction : String(15);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transportation Zone'
    @sap.quickinfo : 'Transportation zone to or from which the goods are delivered'
    TransportZone : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'City Code'
    @sap.quickinfo : 'City PO box code (City file)'
    AddressCityPostBoxCode : String(12);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Person Number'
    Person : String(10);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Company Code'
  entity I_CompanyCode {
    @sap.display.format : 'UpperCase'
    @sap.text : 'CompanyCodeName'
    @sap.label : 'Company Code'
    key CompanyCode : String(4) not null;
    @sap.label : 'Company Name'
    @sap.quickinfo : 'Name of Company Code or Company'
    CompanyCodeName : String(25);
    @sap.label : 'City'
    CityName : String(25);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Country/Region Key'
    Country : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Currency'
    @sap.quickinfo : 'Currency Key'
    @sap.semantics : 'currency-code'
    Currency : String(5);
    @sap.label : 'Language Key'
    Language : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Chart of Accounts'
    ChartOfAccounts : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Fiscal Year Variant'
    FiscalYearVariant : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Company'
    Company : String(6);
    @sap.display.format : 'UpperCase'
    @sap.text : 'CreditControlArea_Text'
    @sap.label : 'Credit Control Area'
    @sap.value.list : 'standard'
    CreditControlArea : String(4);
    @sap.label : 'Description'
    @sap.quickinfo : 'Description of the credit control area'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    CreditControlArea_Text : String(35);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Alternative COA'
    @sap.quickinfo : 'Alternative Chart of Accounts'
    CountryChartOfAccounts : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'FM Area'
    @sap.quickinfo : 'Financial Management Area'
    FinancialManagementArea : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Address'
    AddressID : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Taxes on Sls/Purc.'
    @sap.quickinfo : 'Taxes on Sales/Purchases Group'
    TaxableEntity : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'VAT Registration No.'
    @sap.quickinfo : 'VAT Registration Number'
    VATRegistration : String(20);
    @sap.label : 'Extended WTax Active'
    @sap.quickinfo : 'Indicator: Extended Withholding Tax Active'
    ExtendedWhldgTaxIsActive : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.text : 'ControllingArea_Text'
    @sap.label : 'Controlling Area'
    @sap.value.list : 'standard'
    ControllingArea : String(4);
    @sap.label : 'Controlling Area Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    ControllingArea_Text : String(25);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Field status variant'
    @sap.quickinfo : 'Field Status Variant'
    FieldStatusVariant : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Output Tax Code'
    @sap.quickinfo : 'Output Tax Code for Non-Taxable Transactions'
    NonTaxableTransactionTaxCode : String(2);
    @sap.label : 'Tax Determ.with Doc.Date'
    @sap.quickinfo : 'Indicator: Document Date As the Basis for Tax Determination'
    DocDateIsUsedForTaxDetn : Boolean;
    @sap.label : 'Tax Date'
    @sap.quickinfo : 'Tax Reporting Date Active in Documents'
    TaxRptgDateIsActive : Boolean;
    @sap.label : 'Net Discount Base'
    @sap.quickinfo : 'Indicator: Discount base amount is the net value'
    CashDiscountBaseAmtIsNetAmt : Boolean;
    to_Address : Association to I_Address {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Company Code'
  @sap.value.list : 'true'
  entity I_CompanyCodeStdVH {
    @sap.display.format : 'UpperCase'
    @sap.text : 'CompanyCodeName'
    @sap.label : 'Company Code'
    key CompanyCode : String(4) not null;
    @sap.label : 'Company Name'
    @sap.quickinfo : 'Name of Company Code or Company'
    CompanyCodeName : String(25);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Controlling Area'
  @sap.value.list : 'true'
  entity I_ControllingAreaStdVH {
    @sap.display.format : 'UpperCase'
    @sap.text : 'ControllingAreaName'
    @sap.label : 'Controlling Area'
    key ControllingArea : String(4) not null;
    @sap.label : 'Controlling Area Name'
    ControllingAreaName : String(25);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Country/Region'
  entity I_Country {
    @sap.display.format : 'UpperCase'
    @sap.text : 'Country_Text'
    @sap.label : 'Country/Region Key'
    key Country : String(3) not null;
    @sap.label : 'Country/Region Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    Country_Text : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'ISO Code 3 Char'
    @sap.quickinfo : 'ISO Country/Region Code 3 Characters'
    CountryThreeLetterISOCode : String(3);
    @sap.display.format : 'NonNegative'
    @sap.label : 'ISO Code Num. 3'
    @sap.quickinfo : 'ISO Country/Region Code Numeric 3-Characters'
    CountryThreeDigitISOCode : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'ISO Code'
    @sap.quickinfo : 'ISO Code of the Country/Region'
    CountryISOCode : String(2);
    @sap.label : 'EU Member'
    @sap.quickinfo : 'Indicator: European Union Member?'
    IsEuropeanUnionMember : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Bank Key'
    @sap.quickinfo : 'Name of the bank key'
    BankAndBankInternalIDCheckRule : String(1);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Bank account number'
    @sap.quickinfo : 'Bank account number length'
    BankInternalIDLength : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Check rule for bank acct no.'
    @sap.quickinfo : 'Rule for checking bank account number field'
    BankInternalIDCheckRule : String(1);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Bank number'
    @sap.quickinfo : 'Bank number length'
    BankNumberLength : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Check rule for bank number'
    @sap.quickinfo : 'Rule for checking bank number field'
    BankCheckRule : String(1);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Bank Key Length'
    @sap.quickinfo : 'Length of Bank Key'
    BankAccountLength : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Check rule for bank key'
    @sap.quickinfo : 'Rule for checking bank key field'
    BankPostalCheckRule : String(1);
    @sap.label : 'Bank data'
    @sap.quickinfo : 'Indicator: Use check module for bank fields ?'
    BankDataCheckIsCountrySpecific : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reporting Currency'
    @sap.semantics : 'currency-code'
    CountryCurrency : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Index-Based Currency'
    @sap.quickinfo : 'Currency Key of the Index-Based Currency'
    @sap.semantics : 'currency-code'
    IndexBasedCurrency : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Hard Currency'
    @sap.quickinfo : 'Currency Key of the Hard Currency'
    @sap.semantics : 'currency-code'
    HardCurrency : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Procedure'
    @sap.quickinfo : 'Procedure (Pricing, Output Control, Acct. Det., Costing,...)'
    TaxCalculationProcedure : String(6);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Alternative Key'
    @sap.quickinfo : 'Alternative Country/Region Key'
    CountryAlternativeCode : String(3);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Country/Region - Text'
  entity I_CountryText {
    @sap.display.format : 'UpperCase'
    @sap.text : 'to_Country/Country_Text'
    @sap.label : 'Country/Region Key'
    @sap.value.list : 'standard'
    key Country : String(3) not null;
    @sap.text : 'to_Language/Language_Text'
    @sap.label : 'Language Key'
    @sap.value.list : 'standard'
    key Language : String(2) not null;
    @sap.label : 'Country/Region Name'
    CountryName : String(50);
    @sap.label : 'Nationality'
    NationalityName : String(15);
    @sap.label : 'Nationality (Long)'
    @sap.quickinfo : 'Nationality (Max. 50 Characters)'
    NationalityLongName : String(50);
    @sap.label : 'Country/Region Name'
    @sap.quickinfo : 'Name of Country/Region (Short)'
    CountryShortName : String(15);
    to_Country : Association to I_Country {  };
    to_Language : Association to I_Language {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Credit Control Area'
  @sap.value.list : 'true'
  entity I_CreditControlAreaStdVH {
    @sap.display.format : 'UpperCase'
    @sap.text : 'CreditControlArea_Text'
    @sap.label : 'Credit Control Area'
    key CreditControlArea : String(4) not null;
    @sap.label : 'Description'
    @sap.quickinfo : 'Description of the credit control area'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    CreditControlArea_Text : String(35);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Customer'
  entity I_Customer {
    @sap.display.format : 'UpperCase'
    @sap.text : 'CustomerName'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer Number'
    key Customer : String(10) not null;
    @sap.label : 'Name of Customer'
    CustomerName : String(80);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Name'
    @sap.quickinfo : 'Customer Full Name'
    CustomerFullName : String(220);
    @sap.label : 'Name of Customer'
    @sap.quickinfo : 'Customer Name'
    BPCustomerName : String(81);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Name'
    @sap.quickinfo : 'Customer Full Name'
    BPCustomerFullName : String(220);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created by'
    @sap.quickinfo : 'Name of Person who Created the Object'
    CreatedByUser : String(12);
    @sap.display.format : 'Date'
    @sap.label : 'Created On'
    @sap.quickinfo : 'Record Created On'
    CreationDate : Date;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Address'
    AddressID : String(10);
    @sap.display.format : 'UpperCase'
    @sap.text : 'CustomerClassification_Text'
    @sap.label : 'Customer Classific.'
    @sap.quickinfo : 'Customer Classification'
    CustomerClassification : String(2);
    @sap.label : 'Customer Classification Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    CustomerClassification_Text : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'VAT Registration No.'
    @sap.quickinfo : 'VAT Registration Number'
    VATRegistration : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Account group'
    @sap.quickinfo : 'Customer Account Group'
    CustomerAccountGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Authorization'
    @sap.quickinfo : 'Authorization Group'
    AuthorizationGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivery block'
    @sap.quickinfo : 'Central delivery block for the customer'
    DeliveryIsBlocked : String(2);
    @sap.label : 'Posting Block'
    @sap.quickinfo : 'Central posting block'
    PostingIsBlocked : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing block'
    @sap.quickinfo : 'Central billing block for customer'
    BillingIsBlockedForCustomer : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Order block'
    @sap.quickinfo : 'Central order block for customer'
    OrderIsBlockedForCustomer : String(2);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Int. location no. 1'
    @sap.quickinfo : 'International Location Number (Part 1)'
    InternationalLocationNumber1 : String(7);
    @sap.label : 'One-time account'
    @sap.quickinfo : 'Indicator: Is the account a one-time account?'
    IsOneTimeAccount : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Jurisdiction'
    TaxJurisdiction : String(15);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Industry'
    @sap.quickinfo : 'Industry Key'
    Industry : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax number type'
    @sap.quickinfo : 'Tax Number Type'
    TaxNumberType : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number 1'
    TaxNumber1 : String(16);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number 2'
    TaxNumber2 : String(11);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number 3'
    TaxNumber3 : String(18);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number 4'
    TaxNumber4 : String(18);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number 5'
    TaxNumber5 : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number 6'
    TaxNumber6 : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Group key'
    CustomerCorporateGroup : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Account Number of Supplier'
    Supplier : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nielsen indicator'
    @sap.quickinfo : 'Nielsen ID'
    NielsenRegion : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Industry code 1'
    IndustryCode1 : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Industry code 2'
    IndustryCode2 : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Industry code 3'
    IndustryCode3 : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Industry code 4'
    IndustryCode4 : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Industry code 5'
    IndustryCode5 : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Country/Region Key'
    Country : String(3);
    @sap.label : 'Name'
    @sap.quickinfo : 'Name 1'
    OrganizationBPName1 : String(35);
    @sap.label : 'Name 2'
    OrganizationBPName2 : String(35);
    @sap.label : 'City'
    CityName : String(35);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Postal Code'
    PostalCode : String(10);
    @sap.label : 'Street'
    @sap.quickinfo : 'Street and House Number'
    StreetName : String(35);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Search term'
    @sap.quickinfo : 'Sort field'
    SortField : String(10);
    @sap.label : 'Fax Number'
    FaxNumber : String(31);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Suframa Code'
    BR_SUFRAMACode : String(9);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Region'
    @sap.quickinfo : 'Region (State, Province, County)'
    Region : String(3);
    @sap.label : 'Telephone 1'
    @sap.quickinfo : 'First telephone number'
    TelephoneNumber1 : String(16);
    @sap.label : 'Telephone 2'
    @sap.quickinfo : 'Second telephone number'
    TelephoneNumber2 : String(16);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Alternative Payer'
    @sap.quickinfo : 'Account Number of an Alternative Payer'
    AlternativePayerAccount : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'DME Recipient Code'
    @sap.quickinfo : 'Recipient Code for Data Medium Exchange'
    DataMediumExchangeIndicator : String(1);
    @sap.label : 'Liable for VAT'
    VATLiability : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purpose Completed'
    @sap.quickinfo : 'Business Purpose Completed Flag'
    IsBusinessPurposeCompleted : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Type'
    ResponsibleType : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Fiscal address'
    @sap.quickinfo : 'Account number of the master record with the fiscal address'
    FiscalAddress : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Natural Person'
    NFPartnerIsNaturalPerson : String(1);
    @sap.label : 'Deletion Flag'
    @sap.quickinfo : 'Central Deletion Flag for Master Record'
    DeletionIndicator : Boolean;
    @sap.label : 'Language Key'
    Language : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Trading Partner No.'
    @sap.quickinfo : 'Company ID of Trading Partner'
    TradingPartner : String(6);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Deliv Date Rule'
    @sap.quickinfo : 'Delivery Date Rule'
    DeliveryDateTypeRule : String(1);
    @sap.label : 'Express station'
    @sap.quickinfo : 'Express train station'
    ExpressTrainStationName : String(25);
    @sap.label : 'Train station'
    TrainStationName : String(25);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Int. location no. 2'
    @sap.quickinfo : 'International Location Number (Part 2)'
    InternationalLocationNumber2 : String(5);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Check digit'
    @sap.quickinfo : 'Check digit for the international location number'
    InternationalLocationNumber3 : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'City Code'
    CityCode : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'County Code'
    County : String(3);
    @sap.label : 'Unloading points'
    @sap.quickinfo : 'Indicator: Unloading points exist'
    CustomerHasUnloadingPoint : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Working times'
    @sap.quickinfo : 'Working Time Calendar'
    CustomerWorkingTimeCalendar : String(2);
    @sap.label : 'Competitors'
    @sap.quickinfo : 'Indicator: Competitor'
    IsCompetitor : Boolean;
    @sap.label : 'Rep''s Name'
    @sap.quickinfo : 'Name of Representative'
    TaxInvoiceRepresentativeName : String(10);
    @sap.label : 'Type of Business'
    BusinessType : String(30);
    @sap.label : 'Type of Industry'
    IndustryType : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Consolidated Invoic.'
    @sap.quickinfo : 'Consolidated Invoicing for Taiwan'
    TW_CollvBillingIsSupported : String(1);
    @sap.label : 'Alt.payer in doc?'
    @sap.quickinfo : 'Indicator: Is an alternative payer allowed in document?'
    AlternativePayeeIsAllowed : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Attribute 1'
    FreeDefinedAttribute01 : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Attribute 2'
    FreeDefinedAttribute02 : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Attribute 3'
    FreeDefinedAttribute03 : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Attribute 4'
    FreeDefinedAttribute04 : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Attribute 5'
    FreeDefinedAttribute05 : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Attribute 6'
    FreeDefinedAttribute06 : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Attribute 7'
    FreeDefinedAttribute07 : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Attribute 8'
    FreeDefinedAttribute08 : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Attribute 9'
    FreeDefinedAttribute09 : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Attribute 10'
    FreeDefinedAttribute10 : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Payment Reason'
    PaymentReason : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Condition group 1'
    @sap.quickinfo : 'Customer condition group 1'
    CustomerConditionGroup1 : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Condition group 2'
    @sap.quickinfo : 'Customer condition group 2'
    CustomerConditionGroup2 : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Condition group 3'
    @sap.quickinfo : 'Customer condition group 3'
    CustomerConditionGroup3 : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Condition group 4'
    @sap.quickinfo : 'Customer condition group 4'
    CustomerConditionGroup4 : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Condition group 5'
    @sap.quickinfo : 'Customer condition group 5'
    CustomerConditionGroup5 : String(2);
    @sap.label : 'Prospect'
    @sap.quickinfo : 'Indicator: Sales prospect'
    IsSalesProspect : Boolean;
    @sap.label : 'Payment block'
    @sap.quickinfo : 'Payment Block'
    PaymentIsBlockedForCustomer : Boolean;
    @sap.label : 'Consumer'
    @sap.quickinfo : 'Indicator: Consumer'
    IsConsumer : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Ctrlr. Set'
    @sap.quickinfo : 'BP: Data Controller Set Flag'
    DataControllerSet : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController1 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController2 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController3 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController4 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController5 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController6 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController7 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController8 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController9 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController10 : String(30);
    @sap.label : 'Name'
    @sap.quickinfo : 'Name 1'
    BusinessPartnerName1 : String(40);
    @sap.label : 'Name 2'
    BusinessPartnerName2 : String(40);
    @sap.label : 'Name 3'
    BusinessPartnerName3 : String(40);
    @sap.label : 'Name 4'
    BusinessPartnerName4 : String(40);
    @sap.label : 'City'
    BPAddrCityName : String(40);
    @sap.label : 'Street'
    BPAddrStreetName : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Search Term 1'
    AddressSearchTerm1 : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Search Term 2'
    AddressSearchTerm2 : String(20);
    @sap.label : 'District'
    DistrictName : String(40);
    @sap.label : 'PO Box City'
    @sap.quickinfo : 'PO Box city'
    POBoxDeviatingCityName : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Title Key'
    @sap.quickinfo : 'Form-of-Address Key'
    BusinessPartnerFormOfAddress : String(4);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Language'
  entity I_Language {
    @sap.text : 'Language_Text'
    @sap.label : 'Language Key'
    key Language : String(2) not null;
    @sap.label : 'Name'
    @sap.quickinfo : 'Name of Language'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    Language_Text : String(16);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Language Code'
    @sap.quickinfo : '2-Character SAP Language Code'
    LanguageISOCode : String(2);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Material'
  entity I_Material {
    @sap.display.format : 'UpperCase'
    @sap.text : 'Material_Text'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Material : String(40) not null;
    @sap.label : 'Material Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    Material_Text : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material Type'
    MaterialType : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material Group'
    MaterialGroup : String(9);
    @sap.text : 'to_BaseUnit/UnitOfMeasure_Text'
    @sap.label : 'Base Unit of Measure'
    @sap.value.list : 'standard'
    @sap.semantics : 'unit-of-measure'
    MaterialBaseUnit : String(3);
    @sap.unit : 'MaterialWeightUnit'
    @sap.label : 'Gross Weight'
    MaterialGrossWeight : Decimal(13, 3);
    @sap.unit : 'MaterialWeightUnit'
    @sap.label : 'Net Weight'
    MaterialNetWeight : Decimal(13, 3);
    @sap.text : 'to_WeightUnit/UnitOfMeasure_Text'
    @sap.label : 'Unit of Weight'
    @sap.value.list : 'standard'
    @sap.semantics : 'unit-of-measure'
    MaterialWeightUnit : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Manufacturer'
    @sap.quickinfo : 'Number of a Manufacturer'
    MaterialManufacturerNumber : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Mfr Part Number'
    @sap.quickinfo : 'Manufacturer Part Number'
    MaterialManufacturerPartNumber : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Authorization Group'
    AuthorizationGroup : String(4);
    @sap.label : 'Batch Management'
    @sap.quickinfo : 'Batch Management Requirement Indicator'
    IsBatchManagementRequired : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Cross-plant CM'
    @sap.quickinfo : 'Cross-Plant Configurable Material'
    CrossPlantConfigurableProduct : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material Category'
    ProductCategory : String(2);
    @sap.label : 'Color'
    @sap.quickinfo : 'Characteristic Value for Colors of Variants'
    ProductCharacteristic1 : String(18);
    @sap.label : 'Main Size'
    @sap.quickinfo : 'Characteristic Value for Main Sizes of Variants'
    ProductCharacteristic2 : String(18);
    @sap.label : 'Second Size'
    @sap.quickinfo : 'Characteristic Value for Second Size for Variants'
    ProductCharacteristic3 : String(18);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Int. Char. Number'
    @sap.quickinfo : 'Internal Charactieristic Number for Color Characteristics'
    ProdCharc1InternalNumber : String(30);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Int. Char. Number'
    @sap.quickinfo : 'Internal Char. Number for Characteristics for Main Sizes'
    ProdCharc2InternalNumber : String(30);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Int. Char. Number'
    @sap.quickinfo : 'Internal Char. Number for Characteristics for Second Sizes'
    ProdCharc3InternalNumber : String(30);
    to_BaseUnit : Association to I_UnitOfMeasure {  };
    to_MaterialGroup : Association to I_MaterialGroup {  };
    to_MaterialPlant : Association to many I_MaterialPlant {  };
    to_MaterialType : Association to I_MaterialType {  };
    to_Text : Association to many I_MaterialText {  };
    to_WeightUnit : Association to I_UnitOfMeasure {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Material Group'
  entity I_MaterialGroup {
    @sap.display.format : 'UpperCase'
    @sap.text : 'MaterialGroup_Text'
    @sap.label : 'Product Group'
    key MaterialGroup : String(9) not null;
    @sap.label : 'Product Group Desc.'
    @sap.quickinfo : 'Product Group Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    MaterialGroup_Text : String(20);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Material Plant'
  entity I_MaterialPlant {
    @sap.display.format : 'UpperCase'
    @sap.text : 'Material_Text'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    @sap.value.list : 'standard'
    key Material : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    key Plant : String(4) not null;
    @sap.label : 'Material Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    Material_Text : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'MRP Controller'
    MRPController : String(3);
    @sap.label : 'Safety Stock'
    MaterialSafetyStockQty : Decimal(13, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Storage Location'
    @sap.quickinfo : 'Default Storage Location for External Procurement'
    DfltStorLocForExtProcmt : String(4);
    @sap.label : 'Repet. Manufacturing'
    @sap.quickinfo : 'Indicator: Repetitive Manufacturing Allowed'
    RptvMfgIsAllwd : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'ABC Indicator'
    MaterialABCClassification : String(1);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Material'
  @sap.value.list : 'true'
  entity I_MaterialStdVH {
    @sap.display.format : 'UpperCase'
    @sap.text : 'Material_Text'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Material : String(40) not null;
    @sap.label : 'Material Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    Material_Text : String(40);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Material Text'
  entity I_MaterialText {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Material : String(40) not null;
    @sap.label : 'Language Key'
    key Language : String(2) not null;
    @sap.label : 'Material Description'
    MaterialName : String(40);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Material Type'
  entity I_MaterialType {
    @sap.display.format : 'UpperCase'
    @sap.text : 'MaterialType_Text'
    @sap.label : 'Material Type'
    key MaterialType : String(4) not null;
    @sap.label : 'Material Type Desc.'
    @sap.quickinfo : 'Description of Material Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    MaterialType_Text : String(25);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Authorization group'
    @sap.quickinfo : 'Authorization group in the material master'
    AuthorizationGroup : String(4);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Movement Type Text Basic View'
  entity I_Movement_TypeText {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Movement Type'
    @sap.quickinfo : 'Movement Type (Inventory Management)'
    key MovementType : String(3) not null;
    @sap.label : 'Language Key'
    key Language : String(2) not null;
    @sap.label : 'Movement Type Text'
    @sap.quickinfo : 'Movement Type Text (Inventory Management)'
    MovementTypeDescription : String(20);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'View For OIJLOC and OIJLOCMAT'
  entity I_OilLocMatlPlanning {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key LocationId : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    Material : String(40);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    LocationName : String(60);
    @sap.label : 'Safety inventory'
    @sap.quickinfo : 'OIl-TSW: Planning safety inventory level'
    SafetyStock : Decimal(13, 3);
    @sap.label : 'Maximum inventory'
    @sap.quickinfo : 'OIL-TSW: Planning maximum inventory level'
    CapacityStock : Decimal(13, 3);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Responsible Purg Org for Plant'
  entity I_PlantPurchasingOrganization {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purch. Organization'
    @sap.quickinfo : 'Purchasing Organization'
    key PurchasingOrganization : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    key Plant : String(4) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Price List Type'
  entity I_PriceListType {
    @sap.display.format : 'UpperCase'
    @sap.text : 'PriceListType_Text'
    @sap.label : 'Price List Type'
    key PriceListType : String(2) not null;
    @sap.label : 'Description'
    @sap.quickinfo : 'Text (20 Characters)'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    PriceListType_Text : String(20);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Product Valuation'
  entity I_ProductValuation {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Product : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Valuation Area'
    key ValuationArea : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Valuation Type'
    key ValuationType : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.text : 'ValuationClass_Text'
    @sap.label : 'Valuation Class'
    ValuationClass : String(4);
    @sap.label : 'Description'
    @sap.quickinfo : 'Description of valuation class'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    ValuationClass_Text : String(25);
    @sap.display.format : 'UpperCase'
    @sap.text : 'PriceDeterminationControl_Text'
    @sap.label : 'Price Determ.'
    @sap.quickinfo : 'Material Price Determination: Control'
    PriceDeterminationControl : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Price Det. Descr.'
    @sap.quickinfo : 'Price Determination Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    PriceDeterminationControl_Text : String(60);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Current Period'
    @sap.quickinfo : 'Current period (posting period)'
    FiscalMonthCurrentPeriod : String(2);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Year Current Period'
    @sap.quickinfo : 'Fiscal Year of Current Period'
    FiscalYearCurrentPeriod : String(4);
    @sap.unit : 'Currency'
    @sap.label : 'Standard price'
    StandardPrice : Decimal(12, 3);
    @sap.label : 'Price unit'
    PriceUnitQty : Decimal(5, 0);
    @sap.display.format : 'UpperCase'
    @sap.text : 'InventoryValuationProcedure_Text'
    @sap.label : 'Price Control'
    InventoryValuationProcedure : String(1);
    @sap.label : 'Short Description'
    @sap.quickinfo : 'Short Text for Fixed Values'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    InventoryValuationProcedure_Text : String(60);
    @sap.label : 'Future Price'
    FutureEvaluatedAmountValue : Decimal(12, 3);
    @sap.display.format : 'Date'
    @sap.label : 'Valid from'
    @sap.quickinfo : 'Date as of which the price is valid'
    FuturePriceValidityStartDate : Date;
    @sap.unit : 'Currency'
    @sap.label : 'Previous Price'
    PrevInvtryPriceInCoCodeCrcy : Decimal(12, 3);
    @sap.unit : 'Currency'
    @sap.label : 'Moving price'
    @sap.quickinfo : 'Moving Average Price/Periodic Unit Price'
    MovingAveragePrice : Decimal(12, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Valuation Category'
    ValuationCategory : String(1);
    @sap.display.format : 'UpperCase'
    @sap.text : 'ProductUsageType_Text'
    @sap.label : 'Product Usage'
    @sap.quickinfo : 'Usage of the Product'
    ProductUsageType : String(1);
    @sap.label : 'Material Usage Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    ProductUsageType_Text : String(60);
    @sap.display.format : 'UpperCase'
    @sap.text : 'ProductOriginType_Text'
    @sap.label : 'Product Origin'
    @sap.quickinfo : 'Origin of the Product'
    ProductOriginType : String(1);
    @sap.label : 'Material Origin Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    ProductOriginType_Text : String(60);
    @sap.label : 'Produced in-house'
    IsProducedInhouse : Boolean;
    @sap.display.format : 'NonNegative'
    @sap.label : 'ProdCostEst.No.'
    @sap.quickinfo : 'Cost Estimate Number - Product Costing'
    ProdCostEstNumber : String(12);
    @sap.label : 'Del. flag val. type'
    @sap.quickinfo : 'Deletion flag for all material data of a valuation type'
    IsMarkedForDeletion : Boolean;
    @sap.label : 'Valuation Margin'
    @sap.quickinfo : 'Valuation margin'
    ValuationMargin : Decimal(6, 2);
    @sap.label : 'Is active'
    @sap.quickinfo : 'Draft - Indicator - Is active document'
    IsActiveEntity : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Company Code'
    CompanyCode : String(4);
    @sap.display.format : 'UpperCase'
    @sap.text : 'ValuationClassSalesOrderStock_Text'
    @sap.label : 'VC: Sales Order Stk'
    @sap.quickinfo : 'Valuation Class for Sales Order Stock'
    ValuationClassSalesOrderStock : String(4);
    @sap.label : 'Description'
    @sap.quickinfo : 'Description of valuation class'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    ValuationClassSalesOrderStock_Text : String(25);
    @sap.display.format : 'UpperCase'
    @sap.text : 'ProjectStockValuationClass_Text'
    @sap.label : 'Proj. stk val. class'
    @sap.quickinfo : 'Valuation Class for Project Stock'
    ProjectStockValuationClass : String(4);
    @sap.label : 'Description'
    @sap.quickinfo : 'Description of valuation class'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    ProjectStockValuationClass_Text : String(25);
    @sap.unit : 'Currency'
    @sap.label : 'Planned price 1'
    @sap.quickinfo : 'Future Planned Price 1'
    PlannedPrice1InCoCodeCrcy : Decimal(12, 3);
    @sap.unit : 'Currency'
    @sap.label : 'Planned price 2'
    @sap.quickinfo : 'Future Planned Price 2'
    PlannedPrice2InCoCodeCrcy : Decimal(12, 3);
    @sap.unit : 'Currency'
    @sap.label : 'Planned price 3'
    @sap.quickinfo : 'Future Planned Price 3'
    PlannedPrice3InCoCodeCrcy : Decimal(12, 3);
    @sap.display.format : 'Date'
    @sap.label : 'Planned price date 1'
    @sap.quickinfo : 'Date from Which Future Planned Price 1 Is Valid'
    FuturePlndPrice1ValdtyDate : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Planned price date 2'
    @sap.quickinfo : 'Date from Which Future Planned Price 2 Is Valid'
    FuturePlndPrice2ValdtyDate : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Planned price date 3'
    @sap.quickinfo : 'Date from Which Future Planned Price 3 Is Valid'
    FuturePlndPrice3ValdtyDate : Date;
    @sap.unit : 'BaseUnit'
    @sap.label : 'Price Unit'
    @sap.quickinfo : 'Price unit for valuation prices based on tax/commercial law'
    TaxBasedPricesPriceUnitQty : Decimal(5, 0);
    @sap.display.format : 'Date'
    @sap.label : 'Last Price Change'
    @sap.quickinfo : 'Date of Last Price Change'
    PriceLastChangeDate : Date;
    @sap.unit : 'Currency'
    @sap.label : 'Future Planned Price'
    PlannedPrice : Decimal(12, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Currency'
    @sap.quickinfo : 'Currency Key'
    @sap.semantics : 'currency-code'
    Currency : String(5);
    @sap.label : 'ML Act.'
    @sap.quickinfo : 'Material Ledger Activated at Material Level'
    MLIsActiveAtProductLevel : Boolean;
    @sap.label : 'Base Unit of Measure'
    @sap.semantics : 'unit-of-measure'
    BaseUnit : String(3);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Purchasing Group'
  entity I_PurchasingGroup {
    @sap.display.format : 'UpperCase'
    @sap.text : 'PurchasingGroupName'
    @sap.label : 'Purchasing Group'
    key PurchasingGroup : String(3) not null;
    @sap.label : 'Purchasing Grp. Name'
    @sap.quickinfo : 'Purchasing Group Name'
    PurchasingGroupName : String(18);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tel.No. Purch. Group'
    @sap.quickinfo : 'Telephone number of purchasing group (buyer group)'
    PurchasingGroupPhoneNumber : String(12);
    @sap.label : 'Fax Number'
    @sap.quickinfo : 'Fax number of purchasing (buyer) group'
    FaxNumber : String(31);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Telephone'
    @sap.quickinfo : 'Telephone No.: Dialing Code and Number'
    PhoneNumber : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Extension'
    @sap.quickinfo : 'Telephone no.: Extension'
    PhoneNumberExtension : String(10);
    @sap.label : 'E-Mail Address'
    EmailAddress : String(241);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Purchasing Organization'
  entity I_PurchasingOrganization {
    @sap.display.format : 'UpperCase'
    @sap.text : 'PurchasingOrganizationName'
    @sap.label : 'Purchasing Organization'
    key PurchasingOrganization : String(4) not null;
    @sap.label : 'Purch. Org. Name'
    @sap.quickinfo : 'Purchasing Organization Name'
    PurchasingOrganizationName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Company Code'
    CompanyCode : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Validity'
    @sap.quickinfo : 'Deprecated Entries'
    ConfigDeprecationCode : String(1);
    to_Plant : Association to many I_PlantPurchasingOrganization {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Region'
  entity I_Region {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Country/Region Key'
    key Country : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.text : 'Region_Text'
    @sap.label : 'Region'
    @sap.quickinfo : 'Region (State, Province, County)'
    key Region : String(3) not null;
    @sap.label : 'Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    Region_Text : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Provincial Tax Code'
    ProvincialTaxCode : String(3);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Region - Text'
  entity I_RegionText {
    @sap.display.format : 'UpperCase'
    @sap.text : 'to_Country/Country_Text'
    @sap.label : 'Country/Region Key'
    @sap.value.list : 'standard'
    key Country : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.text : 'to_Region/Region_Text'
    @sap.label : 'Region'
    @sap.quickinfo : 'Region (State, Province, County)'
    @sap.value.list : 'standard'
    key Region : String(3) not null;
    @sap.text : 'to_Language/Language_Text'
    @sap.label : 'Language Key'
    @sap.value.list : 'standard'
    key Language : String(2) not null;
    @sap.label : 'Description'
    RegionName : String(20);
    to_Country : Association to I_Country {  };
    to_Language : Association to I_Language {  };
    to_Region : Association to I_Region {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Supplier'
  entity I_Supplier {
    @sap.display.format : 'UpperCase'
    @sap.text : 'SupplierName'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Account Number of Supplier'
    key Supplier : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Account Group'
    @sap.quickinfo : 'Vendor account group'
    SupplierAccountGroup : String(4);
    @sap.label : 'Name of Supplier'
    SupplierName : String(80);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier Name'
    @sap.quickinfo : 'Supplier Full Name'
    SupplierFullName : String(220);
    @sap.label : 'Supplier Name'
    BPSupplierName : String(81);
    @sap.label : 'Supplier Name'
    @sap.quickinfo : 'Supplier Full Name'
    BPSupplierFullName : String(163);
    @sap.label : 'Name'
    @sap.quickinfo : 'Name 1'
    BusinessPartnerName1 : String(40);
    @sap.label : 'Name 2'
    BusinessPartnerName2 : String(40);
    @sap.label : 'Name 3'
    BusinessPartnerName3 : String(40);
    @sap.label : 'Name 4'
    BusinessPartnerName4 : String(40);
    @sap.label : 'City'
    BPAddrCityName : String(40);
    @sap.label : 'Street'
    BPAddrStreetName : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Search Term 1'
    AddressSearchTerm1 : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Search Term 2'
    AddressSearchTerm2 : String(20);
    @sap.label : 'District'
    DistrictName : String(40);
    @sap.label : 'PO Box City'
    @sap.quickinfo : 'PO Box city'
    POBoxDeviatingCityName : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Title Key'
    @sap.quickinfo : 'Form-of-Address Key'
    BusinessPartnerFormOfAddress : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purpose Completed'
    @sap.quickinfo : 'Business Purpose Completed Flag'
    IsBusinessPurposeCompleted : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    @sap.quickinfo : 'Name of Person who Created the Object'
    CreatedByUser : String(12);
    @sap.display.format : 'Date'
    @sap.label : 'Created On'
    @sap.quickinfo : 'Record Created On'
    CreationDate : Date;
    @sap.label : 'One-time account'
    @sap.quickinfo : 'Indicator: Is the account a one-time account?'
    IsOneTimeAccount : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Authorization'
    @sap.quickinfo : 'Authorization Group'
    AuthorizationGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'VAT Registration No.'
    @sap.quickinfo : 'VAT Registration Number'
    VATRegistration : String(20);
    @sap.label : 'Posting Block(Deprecated)'
    @sap.quickinfo : 'Central posting block'
    AccountIsBlockedForPosting : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Jurisdiction'
    TaxJurisdiction : String(15);
    @sap.display.format : 'UpperCase'
    @sap.label : 'SCAC'
    @sap.quickinfo : 'Standard carrier access code'
    SupplierStandardCarrierAccess : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Carrier freight grp'
    @sap.quickinfo : 'Forwarding agent freight group'
    SupplierFwdAgentFreightGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'ServAgntProcGrp'
    @sap.quickinfo : 'Service agent procedure group'
    SupplierAgentProcedureGroup : String(4);
    @sap.label : 'Social Insurance'
    @sap.quickinfo : 'Registered for Social Insurance'
    SupplIsSocialInsuranceRegtrd : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Social Ins. Code'
    @sap.quickinfo : 'Activity Code for Social Insurance'
    SocialInsuranceActivityCode : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Group Key'
    @sap.quickinfo : 'Group key'
    SupplierCorporateGroup : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer Number'
    Customer : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Industry'
    @sap.quickinfo : 'Industry Key'
    Industry : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number 1'
    TaxNumber1 : String(16);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number 2'
    TaxNumber2 : String(11);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number 3'
    TaxNumber3 : String(18);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number 4'
    TaxNumber4 : String(18);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number 5'
    TaxNumber5 : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number 6'
    TaxNumber6 : String(20);
    @sap.label : 'Posting Block'
    @sap.quickinfo : 'Central posting block'
    PostingIsBlocked : Boolean;
    @sap.label : 'Purch. Block'
    @sap.quickinfo : 'Centrally imposed purchasing block'
    PurchasingIsBlocked : Boolean;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Int. location no. 1'
    @sap.quickinfo : 'International Location Number (Part 1)'
    InternationalLocationNumber1 : String(7);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Int. location no. 2'
    @sap.quickinfo : 'International Location Number (Part 2)'
    InternationalLocationNumber2 : String(5);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Check Digit'
    @sap.quickinfo : 'Check digit for the international location number'
    InternationalLocationNumber3 : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Address'
    AddressID : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Region'
    @sap.quickinfo : 'Region (State, Province, County)'
    Region : String(3);
    @sap.label : 'Name'
    @sap.quickinfo : 'Name 1'
    OrganizationBPName1 : String(35);
    @sap.label : 'Name 2'
    OrganizationBPName2 : String(35);
    @sap.label : 'City'
    CityName : String(35);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Postal Code'
    PostalCode : String(10);
    @sap.label : 'Street'
    @sap.quickinfo : 'Street and House Number'
    StreetName : String(35);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Country/Region Key'
    Country : String(3);
    @sap.label : 'Int. Location No.'
    @sap.quickinfo : 'Cocatenated International Location Number'
    ConcatenatedInternationalLocNo : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Block Function'
    @sap.quickinfo : 'Function That Will Be Blocked'
    SupplierProcurementBlock : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Actual QM System'
    @sap.quickinfo : 'Supplier''s QM System'
    SuplrQualityManagementSystem : String(4);
    @sap.display.format : 'Date'
    @sap.label : 'QM System Valid To'
    @sap.quickinfo : 'Validity Date of Certification'
    SuplrQltyInProcmtCertfnValidTo : Date;
    @sap.label : 'Language Key'
    SupplierLanguage : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Alternative Payee'
    @sap.quickinfo : 'Account Number of the Alternative Payee'
    AlternativePayeeAccountNumber : String(10);
    @sap.label : 'Telephone 1'
    @sap.quickinfo : 'First telephone number'
    PhoneNumber1 : String(16);
    @sap.label : 'Fax Number'
    FaxNumber : String(31);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Natural Person'
    IsNaturalPerson : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number'
    @sap.quickinfo : 'Tax Number at Responsible Tax Authority'
    TaxNumberResponsible : String(18);
    @sap.label : 'Business Type'
    @sap.quickinfo : 'Subcontractor''s Business Type'
    UK_ContractorBusinessType : String(12);
    @sap.label : 'Prtnr''s Trading Name'
    @sap.quickinfo : 'Partner''s Trading Name'
    UK_PartnerTradingName : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Partner''s UTR'
    @sap.quickinfo : 'Partner''s Unique Tax Reference (UTR)'
    UK_PartnerTaxReference : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Verification Status'
    UK_VerificationStatus : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Verification Number'
    UK_VerificationNumber : String(20);
    @sap.label : 'Comp. House Reg. No.'
    @sap.quickinfo : 'Companies House Registration Number'
    UK_CompanyRegistrationNumber : String(8);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Status'
    @sap.quickinfo : 'Tax Status of the Verified Subcontractor'
    UK_VerifiedTaxStatus : String(1);
    @sap.label : 'Title'
    FormOfAddress : String(15);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Acct Group'
    @sap.quickinfo : 'Reference Account Group for One-Time Account (Vendor)'
    ReferenceAccountGroup : String(4);
    @sap.label : 'Liable for VAT'
    VATLiability : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Type'
    ResponsibleType : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Number Type'
    TaxNumberType : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Fiscal Address'
    @sap.quickinfo : 'Account number of the master record with fiscal address'
    FiscalAddress : String(10);
    @sap.label : 'Type of Business'
    BusinessType : String(30);
    @sap.display.format : 'Date'
    @sap.label : 'Date of Birth'
    @sap.quickinfo : 'Date of Birth of the Person Subject to Withholding Tax'
    BirthDate : Date;
    @sap.label : 'Payment Block'
    PaymentIsBlockedForSupplier : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Search Term'
    @sap.quickinfo : 'Sort field'
    SortField : String(10);
    @sap.label : 'Telephone 2'
    @sap.quickinfo : 'Second telephone number'
    PhoneNumber2 : String(16);
    @sap.label : 'Deletion Flag'
    @sap.quickinfo : 'Central Deletion Flag for Master Record'
    DeletionIndicator : Boolean;
    @sap.label : 'Rep''s Name'
    @sap.quickinfo : 'Name of Representative'
    TaxInvoiceRepresentativeName : String(10);
    @sap.label : 'Type of Industry'
    IndustryType : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'GST Ven Class.'
    @sap.quickinfo : 'Vendor Classification for GST'
    IN_GSTSupplierClassification : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Relevant for POD'
    @sap.quickinfo : 'Supplier indicator relevant for proof of delivery'
    SuplrProofOfDelivRlvtCode : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Trading Partner No.'
    @sap.quickinfo : 'Company ID of Trading Partner'
    TradingPartner : String(6);
    @sap.label : 'Tax Split'
    BR_TaxIsSplit : Boolean;
    @sap.label : 'Enterprise in AU'
    @sap.quickinfo : 'Is payer making payment in course of carrying on enterprise'
    AU_PayerIsPayingToCarryOnEnt : Boolean;
    @sap.label : 'Individual'
    @sap.quickinfo : 'Is an individual under 18 and payment does not exceed $350'
    AU_IndividualIsUnder18 : Boolean;
    @sap.label : 'Payment Does not Exc'
    @sap.quickinfo : 'The payment does not exceed $75, excl. GST'
    AU_PaymentIsExceeding75 : Boolean;
    @sap.label : 'Wholly Input Taxed'
    @sap.quickinfo : 'The supply that the payment relates to is wholly input taxed'
    AU_PaymentIsWhollyInputTaxed : Boolean;
    @sap.label : 'Individual w/o Gain'
    @sap.quickinfo : 'The supply is made by an individual without gain'
    AU_PartnerIsSupplyWithoutGain : Boolean;
    @sap.label : 'ABN Eligible'
    @sap.quickinfo : 'The supplier is not entitled to an ABN'
    AU_SupplierIsEntitledToABN : Boolean;
    @sap.label : 'Payment Exempt'
    @sap.quickinfo : 'The whole of the payment is exempt income.'
    AU_PaymentIsIncomeExempted : Boolean;
    @sap.label : 'Hobby'
    @sap.quickinfo : 'An activity done as a private recreational pursuit'
    AU_SupplyIsMadeAsPrivateHobby : Boolean;
    @sap.label : 'Domestic'
    @sap.quickinfo : 'wholly of a private or domestic nature'
    AU_SupplyMadeIsOfDmstcNature : Boolean;
    @sap.label : 'Origin Acceptance'
    @sap.quickinfo : 'Acceptance At Origin'
    IsToBeAcceptedAtOrigin : Boolean;
    @sap.label : 'Checkbox'
    @sap.heading : ''
    BPIsEqualizationTaxSubject : Boolean;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Tax Base'
    @sap.quickinfo : 'Tax Base in Percentage'
    BRSpcfcTaxBasePercentageCode : String(1);
    @sap.label : 'Profession'
    SupplierProfession : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ext. manufacturer'
    @sap.quickinfo : 'External manufacturer code name or number'
    SuplrManufacturerExternalName : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'DME Recipient Code'
    @sap.quickinfo : 'Recipient Code for Data Medium Exchange'
    DataMediumExchangeIndicator : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Instruction Key'
    @sap.quickinfo : 'Instruction Key for Data Medium Exchange'
    DataExchangeInstructionKey : String(2);
    @sap.label : 'VSR Relevant'
    @sap.quickinfo : 'Indicator: vendor sub-range relevant'
    SupplierIsSubRangeRelevant : Boolean;
    @sap.label : 'Train Station'
    @sap.quickinfo : 'Train station'
    TrainStationName : String(25);
    @sap.label : 'Payee in Document'
    @sap.quickinfo : 'Indicator: Alternative Payee in Document Allowed?'
    AlternativePayeeIsAllowed : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'PBC/ISR Number'
    @sap.quickinfo : 'ISR Subscriber Number'
    PaytSlipWthRefSubscriber : String(11);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Stat. Grp, Agent'
    @sap.quickinfo : 'Shipment: statistics group, transportation service agent'
    TranspServiceAgentStstcGrp : String(2);
    @sap.label : 'Plant Level Relevant'
    @sap.quickinfo : 'Indicator: plant level relevant'
    SupplierIsPlantRelevant : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Office'
    @sap.quickinfo : 'Account Number of Master Record of Tax Office Responsible'
    SuplrTaxAuthorityAccountNumber : String(10);
    @sap.label : 'Carrier confirmation'
    @sap.quickinfo : 'Carrier confirmation is expected'
    SuplrCarrierConfirmIsExpected : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    @sap.quickinfo : 'Plant (Own or External)'
    SupplierPlant : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Factory Calendar'
    @sap.quickinfo : 'Factory calendar key'
    FactoryCalendar : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Payment Reason'
    PaymentReason : String(4);
    @sap.label : 'Central Del. Block'
    @sap.quickinfo : 'Central deletion block for master record'
    SupplierCentralDeletionIsBlock : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Ctrlr. Set'
    @sap.quickinfo : 'BP: Data Controller Set Flag'
    DataControllerSet : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController1 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController2 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController3 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController4 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController5 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController6 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController7 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController8 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController9 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController10 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transportation Chain'
    SupplierTransportationChain : String(10);
    @sap.label : 'Staging Time'
    @sap.quickinfo : 'Staging Time in Days'
    SupplierStagingTimeInDays : Decimal(3, 0);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Scheduling Procedure'
    SupplierSchedulingProcedure : String(1);
    @sap.label : 'Rel. for Coll. No.'
    @sap.quickinfo : 'Cross Docking: Relevant for Collective Numbering'
    CollectiveNumberingIsRelevant : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'PAN'
    @sap.quickinfo : 'Permanent Account Number'
    BusinessPartnerPanNumber : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'PAN Reference Number'
    BPPanReferenceNumber : String(40);
    @sap.display.format : 'Date'
    @sap.label : 'PAN Valid From Date'
    BPPanValidFromDate : Date;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Supplier Company by Plant'
  entity I_SupplierCompanyByPlant {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    key Plant : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Account Number of Supplier'
    @sap.value.list : 'standard'
    key Supplier : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Valuation Area'
    ValuationArea : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Company Code'
    CompanyCode : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Authorization'
    @sap.quickinfo : 'Authorization Group'
    AuthorizationGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purpose Completed'
    @sap.quickinfo : 'Business Purpose Completed Flag'
    IsBusinessPurposeCompleted : String(1);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Supplier Company'
  entity I_SupplierCompanyVH {
    @sap.display.format : 'UpperCase'
    @sap.text : 'BPSupplierName'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Account Number of Supplier'
    @sap.value.list : 'standard'
    key Supplier : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.text : 'CompanyCodeName'
    @sap.label : 'Company Code'
    @sap.value.list : 'standard'
    key CompanyCode : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Country/Region Key'
    Country : String(3);
    @sap.label : 'Supplier Name'
    BPSupplierName : String(81);
    @sap.label : 'Company Name'
    @sap.quickinfo : 'Name of Company Code or Company'
    CompanyCodeName : String(25);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Supplier'
  @sap.value.list : 'true'
  entity I_Supplier_VH {
    @sap.display.format : 'UpperCase'
    @sap.text : 'BPSupplierName'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Account Number of Supplier'
    key Supplier : String(10) not null;
    @sap.label : 'Supplier Name1'
    @sap.quickinfo : 'Supplier Name'
    SupplierName : String(35);
    @sap.label : 'Business Partner Name1'
    BusinessPartnerName1 : String(40);
    @sap.label : 'Business Partner Supplier Name'
    @sap.quickinfo : 'Supplier Name'
    BPSupplierName : String(81);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Authorization'
    @sap.quickinfo : 'Authorization Group'
    AuthorizationGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Account group'
    @sap.quickinfo : 'Vendor account group'
    SupplierAccountGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purpose Completed'
    @sap.quickinfo : 'Business Purpose Completed Flag'
    IsBusinessPurposeCompleted : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Business Partner'
    @sap.quickinfo : 'Business Partner Number'
    BusinessPartner : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Business Partner Type'
    BusinessPartnerType : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Ctrlr. Set'
    @sap.quickinfo : 'BP: Data Controller Set Flag'
    DataControllerSet : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController1 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController2 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController3 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController4 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController5 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController6 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController7 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController8 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController9 : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Data Controller'
    @sap.quickinfo : 'BP: Data Controller (Internal Use Only)'
    DataController10 : String(30);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Unit of Measure'
  entity I_UnitOfMeasure {
    @sap.text : 'UnitOfMeasure_Text'
    @sap.label : 'Unit of Measure'
    @sap.semantics : 'unit-of-measure'
    key UnitOfMeasure : String(3) not null;
    @sap.label : 'Meas. Unit Text'
    @sap.quickinfo : 'Unit of Measurement Text (Maximum 30 Characters)'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    UnitOfMeasure_Text : String(30);
    @sap.label : 'Internal SAP Code'
    @sap.quickinfo : 'Unit of Measurement, Internal SAP Code (No Conversion)'
    UnitOfMeasureSAPCode : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'ISO Code'
    @sap.quickinfo : 'ISO Code for Unit of Measurement'
    UnitOfMeasureISOCode : String(3);
    @sap.label : 'Primary code'
    @sap.quickinfo : 'Selection field for conversion from ISO code to int. code'
    IsPrimaryUnitForISOCode : Boolean;
    @sap.label : 'Decimal Rounding'
    @sap.quickinfo : 'No. of decimal places for rounding'
    UnitOfMeasureNumberOfDecimals : Integer;
    @sap.label : 'Commercial Unit'
    @sap.quickinfo : 'Commercial measurement unit ID'
    UnitOfMeasureIsCommercial : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Dimension'
    @sap.quickinfo : 'Dimension key'
    UnitOfMeasureDimension : String(6);
    @sap.label : 'Numerator'
    @sap.quickinfo : 'Numerator for conversion to SI unit'
    SIUnitCnvrsnRateNumerator : Integer;
    @sap.label : 'Denominator'
    @sap.quickinfo : 'Denominator for conversion into SI unit'
    SIUnitCnvrsnRateDenominator : Integer;
    @sap.label : 'Exponent'
    @sap.quickinfo : 'base ten exponent for conversion to SI unit'
    SIUnitCnvrsnRateExponent : Integer;
    @sap.label : 'Additive constant'
    @sap.quickinfo : 'Additive constant for conversion to SI unit'
    SIUnitCnvrsnAdditiveValue : Decimal(9, 6);
    @sap.label : 'Exp. 10 Floating Pt'
    @sap.quickinfo : 'Exponent of 10 for Floating Point Format'
    UnitOfMeasureDspExponent : Integer;
    @sap.label : 'Decimal Places'
    @sap.quickinfo : 'Number of Decimal Places for Number Display'
    UnitOfMeasureDspNmbrOfDcmls : Integer;
    @sap.unit : 'UnitOfMeasureTemperatureUnit'
    @sap.label : 'Temperature'
    UnitOfMeasureTemperature : Double;
    @sap.label : 'Temperature unit'
    @sap.semantics : 'unit-of-measure'
    UnitOfMeasureTemperatureUnit : String(3);
    @sap.unit : 'UnitOfMeasurePressureUnit'
    @sap.label : 'Pressure Value'
    UnitOfMeasurePressure : Double;
    @sap.label : 'Unit of Pressure'
    @sap.semantics : 'unit-of-measure'
    UnitOfMeasurePressureUnit : String(3);
  };
};

