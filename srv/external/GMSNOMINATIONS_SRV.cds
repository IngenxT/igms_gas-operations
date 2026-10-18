/* checksum : abe5ea06095e720b908ccaf7cbf7d2c1 */
@cds.external : true
@m.IsDefaultEntityContainer : 'true'
@sap.message.scope.supported : 'true'
@sap.supported.formats : 'atom json xlsx'
service GMSNOMINATIONS_SRV {
  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity nomi_SaveSet {
    @sap.unicode : 'false'
    @sap.label : 'DocumentNo'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ContractNo : String(10) not null;
    @sap.display.format : 'Date'
    @sap.unicode : 'false'
    @sap.label : 'Gas Day'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Gasday : Date not null;
    @sap.unicode : 'false'
    @sap.label : 'Maste Agrmt. No'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Mastercontno : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Int. Consump. Flag'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Icindicator : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Source'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Source : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Item : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Zstat : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nom. key item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NominationItem : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Customer'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Customer : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nomination key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NominationKey : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sold-to Party'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SoldToParty : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocumentType : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Trans system'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TransportSystem : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Versn : String(3);
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'Daily ContractQty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DeliveryDcq : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Delivery Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DeliveryPoint : String(10);
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'RDCQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RedeliveryDcq : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Redelivery Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RedeliveryPoint : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Unit of Measure'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3) not null;
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ProposedDnq : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Vendor'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vendor : String(10);
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'Approved DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ApprovedDnq : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Time To'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ValidTo : Time;
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'RePublish DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RepublishDnq : Decimal(13, 3) not null;
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
    @sap.label : 'Service Profile'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ServiceProfile : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sales Purchase Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SalesPurchInd : String(1) not null;
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
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity Nom_DetailSet {
    @sap.unicode : 'false'
    @sap.label : 'DocumentNo'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ContractNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Redelivery Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key RedeliveryPoint : String(10) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Valid From'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ValidFrom : Timestamp not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Valid To'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ValidTo : Timestamp not null;
    @sap.unicode : 'false'
    @sap.label : 'Sold To Party'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SoldToParty : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Material : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DpDnq : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'UOM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Uom : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RpDnq : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Delivery Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DeliveryPoint : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Event'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Event : String(100) not null;
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
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity SaveBatch {
    @sap.unicode : 'false'
    @sap.label : 'Save Batch'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Save : String(1) not null;
    to_Items : Association to many nomi_SaveSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity Znom_saveSet {
    @sap.display.format : 'Date'
    @sap.unicode : 'false'
    @sap.label : 'Gas Day'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Gasday : Date not null;
    @sap.unicode : 'false'
    @sap.label : 'DocumentNo'
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
    @sap.unicode : 'false'
    @sap.label : 'Document Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Item : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Versn : String(3) not null;
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
    RedeliveryPoint : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Customer'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Customer : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Supplier'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vendor : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Time To'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ValidTo : Time not null;
    @sap.unicode : 'false'
    @sap.label : 'Time From'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ValidFrom : Time not null;
    @sap.unicode : 'false'
    @sap.label : 'Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Zstat : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Material : String(40) not null;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Timestamp : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Nomination key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NominationKey : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sold-to Party'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SoldToParty : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocumentType : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Trans system'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TransportSystem : String(10) not null;
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'Daily ContractQty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DeliveryDcq : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'RDCQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RedeliveryDcq : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Unit of Measure'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3) not null;
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ProposedDnq : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Event Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Event : String(40) not null;
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'Approved DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ApprovedDnq : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'RePublish DNQ'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RepublishDnq : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Long comment'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Remarks : String(255) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nom. Flag'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Flag : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Action'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Action : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Path'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Path : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Source'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Source : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Customer Group'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CustGrp : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Service Profile'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ServiceProfile : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sales Purchase Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SalesPurchInd : String(1) not null;
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
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity nom_headSet {
    @sap.unicode : 'false'
    @sap.label : 'DocumentNo'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ContractNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Int. Consump. Flag'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Icindicator : String(1) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Gas Day'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Gasday : Timestamp;
    nomi_toitem : Association to many nomi_SaveSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Contract Approval'
  entity xGMSxCONTAPPROVAL {
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key Contractno : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Version'
    key Versn : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Indicator'
    key ContIndicator : String(1) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'AR Level'
    @sap.heading : ''
    key ArLevel : String(2) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    Refno : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'AR Indicator'
    ArIndicator : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ar Email'
    @sap.quickinfo : 'AR Email'
    ArEmail : String(30);
    @sap.display.format : 'Date'
    @sap.label : 'AR Date'
    ArDate : Date;
    @sap.label : 'AR TIME'
    @sap.quickinfo : 'AR Time'
    ArTime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Remark'
    @sap.quickinfo : 'Remarks'
    Remark : String(50);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Contract History'
  entity xGMSxCONTHISTORY {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Indicator'
    key ContIndicator : String(1) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Counter'
    key Counter : String(5) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Table Name'
    key TableName : String(20) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'KeyId'
    @sap.quickinfo : 'Unique key id for DCQ'
    key KeyId : String(100) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Field Name'
    key FieldName : String(35) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Old Value'
    OldValue : String(15);
    @sap.display.format : 'UpperCase'
    @sap.label : 'New Value'
    NewValue : String(15);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    ChangedBy : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    ChangedOn : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    ChangedTime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch Contract Based On Master Contract'
  entity xGMSxCONTMAPPING {
    @sap.display.format : 'UpperCase'
    @sap.label : 'SD Document'
    @sap.quickinfo : 'Sales and Distribution Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key RefNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    Material : String(40);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    Item : String(6);
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    ValidFrom : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    ValidTo : Date;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master ContractRefNo'
    @sap.quickinfo : 'Master Agreement Ref No'
    Refmastercontno : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    Mastercontno : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agreement Type'
    @sap.quickinfo : 'IGMS Contract Type'
    Contyp : String(5);
    @sap.label : 'SD Document Category'
    DocumentCategory : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Document Type'
    DocumentType : String(4);
    @sap.label : 'Primary Indicator'
    @sap.quickinfo : 'Primary Contract Indicator'
    IsPrimaryContract : Boolean;
    @sap.label : 'Deletion Indicator'
    Loekz : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    Plant : String(4);
    @sap.label : 'UOM'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Storage Location'
    StorageLoc : String(4);
    @sap.label : 'RDP ACC DCQ'
    @sap.quickinfo : 'Redelivery Point Accumulated DCQ'
    RdpAnnualQty : Integer;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sold-to Party'
    SoldToParty : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ship-to Party'
    ShipToParty : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Bill To Party'
    @sap.quickinfo : 'Bill to Party'
    BillToParty : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Payer'
    Payer : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Organization'
    SalesOrg : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Distribution Channel'
    DistributionChannel : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Division'
    Division : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Profile'
    ServiceProfile : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'MasterContractStatus'
    @sap.quickinfo : 'Master Contract Status'
    Constat : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    PurchaseContractNo : String(10);
    to_contbillsch : Association to many xGMSxCONTRACT_BSV {  };
    to_contmq : Association to many xGMSxFETCHMONTHLYQTY {  };
    to_contprice : Association to many xGMSxCONTRACTPRICING {  };
    to_contractcf : Association to many xGMSxCONTRACT_CFV {  };
    to_contractcl : Association to many xGMSxCONTRACT_CLV {  };
    to_contractdq : Association to many xGMSxCONTRACT_DQV {  };
    to_contractsp : Association to many xGMSxCONTRACT_SPV {  };
    to_srvcontclause : Association to many xGMSxSRVCONTCLAUSE {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Contract Monthly Quantity'
  entity xGMSxCONTMONTHQTY {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master ContractRefNo'
    @sap.quickinfo : 'Master Agreement Ref No'
    key Refmastercontno : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Sales Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Material : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer No'
    key Customer : String(10) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    key StartDate : Date not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    key EndDate : Date not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Version'
    key Versn : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Capacity Type'
    @sap.heading : ''
    key CapacityType : String(5) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Capacity Type Id'
    @sap.quickinfo : 'Capacity type id'
    key CapacityTypeId : String(10) not null;
    key KeyId : String(26) not null;
    @sap.unit : 'Uom'
    @sap.label : 'ACQ'
    @sap.quickinfo : 'Create Contract ACQ'
    Acq : Decimal(13, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    Mastercontno : String(10);
    AsTableName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    ContractNo : String(10);
    @sap.label : 'UOM'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Jan : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Jan2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Feb : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Feb2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Mar : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Mar2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Apr : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Apr2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    May : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    May2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Jun : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Jun2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Jul : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Jul2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Aug : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Aug2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Sep : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Sep2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Oct : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Oct2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Nov : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Nov2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Dece : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Dece2 : Decimal(13, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Purchase Side'
  entity xGMSxCONTPURCHASE {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Material : String(40) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    key KeyId : String(20) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    key ValidFrom : Date not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    key ValidTo : Date not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master ContractRefNo'
    @sap.quickinfo : 'Master Agreement Ref No'
    Refmastercontno : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    Mastercontno : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agreement Type'
    @sap.quickinfo : 'IGMS Contract Type'
    Contyp : String(5);
    AsTableName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Desc'
    @sap.quickinfo : 'Contract Description'
    ContractDesc : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Contract Sale'
    @sap.heading : ''
    ServiceCont : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    SalesRefno : String(10);
    @sap.label : 'Material Description'
    MaterialTxt : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purch. Doc. Category'
    @sap.quickinfo : 'Purchasing Document Category'
    DocumentCategory : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Order Type'
    @sap.quickinfo : 'Order Type (Purchasing)'
    DocumentType : String(4);
    @sap.label : 'Deletion Indicator'
    Loekz : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    Plant : String(4);
    @sap.label : 'Plant Name'
    PlantTxt : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Invoice Bill EXP'
    @sap.quickinfo : 'Invoice Billing Exception'
    InvoiceBillingExp : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Invoice Frequency'
    InvoiceFreq : String(2);
    @sap.label : 'UOM'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Storage Location'
    StorageLoc : String(4);
    @sap.label : 'Storage Loc. Name'
    @sap.quickinfo : 'Storage Location Name'
    StorageLocTxt : String(16);
    @sap.label : 'DP ACC DCQ'
    @sap.quickinfo : 'Delivery Point Accumulated DCQ'
    DpAnnualQty : Integer;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Vendor No'
    Vendor : String(10);
    @sap.label : 'Name of Supplier'
    VendorText : String(80);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Profile'
    ServiceProfile : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purch. Organization'
    @sap.quickinfo : 'Purchasing Organization'
    PurchaseOrg : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purchasing Group'
    PurchaseGrp : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'MasterContractStatus'
    @sap.quickinfo : 'Master Contract Status'
    Constat : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
    to_contapproval : Association to many xGMSxCONTAPPROVAL {  };
    to_contbillsch : Association to many xGMSxCONTRACT_BSV {  };
    to_contmq : Association to many xGMSxFETCHMONTHLYQTY {  };
    to_contprice : Association to many xGMSxCONTRACTPRICING {  };
    to_contractcf : Association to many xGMSxCONTRACT_CFV {  };
    to_contractcl : Association to many xGMSxCONTRACT_CLV {  };
    to_contractdq : Association to many xGMSxCONTRACT_DQV {  };
    to_contractsp : Association to many xGMSxCONTRACT_SPV {  };
    to_history : Association to many xGMSxCONTHISTORY {  };
    to_linkedcont : Association to many xGMSxLINKCONTRACT {  };
    to_refapproval : Association to many xGMSxREFAPPROVAL {  };
    to_srvcontclause : Association to many xGMSxSRVCONTCLAUSE {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Master Contract Clause'
  entity xGMSxCONTRACTPRICING {
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Version'
    key Versn : String(3) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Condition Seq Num'
    @sap.quickinfo : 'Condition Sequential Number'
    key ConditionSeqNum : String(2) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    key ValidFrom : Date not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    key ValidTo : Date not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Condition Table'
    key ConditionTable : String(5) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Condition Type'
    key ConditionType : String(4) not null;
    key KeyId : String(20) not null;
    AsTableName : String(20);
    @sap.label : 'Amount'
    @sap.quickinfo : 'Pricing Amount'
    Amount : Integer;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Pricing Comp Name'
    @sap.quickinfo : 'Pricing Component Name'
    PriceCompName : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Currency'
    Currency : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Per'
    Per : String(10);
    @sap.label : 'Unit of Measure'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Type'
    Billingtype : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Pricing Pro Name'
    @sap.quickinfo : 'Pricing Profile Name'
    Pricingprofilename : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Condition Value'
    ConditionValue : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract Billing & Scheduling'
  entity xGMSxCONTRACT_BSV {
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Clause Code'
    key FinancialParameterId : String(20) not null;
    key KeyId : String(36) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Frequency'
    key FrequencyCode : String(2) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Exception'
    key ExceptionCode : String(3) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Billing Cycle'
    key Cycle : String(5) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    key ValidTo : Date not null;
    @sap.display.format : 'Date'
    PeriodStart : Date;
    @sap.display.format : 'Date'
    PeriodEnd : Date;
    @sap.display.format : 'Date'
    BillingDate : Date;
    @sap.display.format : 'Date'
    EffectiveBillingDate : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    ValidFrom : Date;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Clause Description'
    @sap.quickinfo : 'Clause Code Description'
    FinancialParameterDesc : String(50);
    AsTableName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Projection for Contract CF'
  entity xGMSxCONTRACT_CFV {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Field'
    @sap.quickinfo : 'Contract Field ID'
    key ContractFieldId : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Field'
    key KeyId : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Field'
    ContractField : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Field Level'
    FieldLevel : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Field Value'
    @sap.quickinfo : 'Contract Field Value'
    FieldValue : String(50);
    AsTableName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    CreatedBy : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    CreatedDate : Date;
    @sap.label : 'Created Time'
    CreatedTime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    ChangedBy : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    ChangedDate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    ChangedTime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract Clause Code Projection'
  entity xGMSxCONTRACT_CLV {
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'F.Parameter Id'
    @sap.quickinfo : 'Financial Parameter Id'
    key QuantityParamId : String(8) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    key ValidFrom : Date not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    key ValidTo : Date not null;
    key KeyId : String(24) not null;
    @sap.label : 'Threshold Perc'
    @sap.quickinfo : 'Threshold Percentage'
    ThresholdPer : Decimal(3, 0);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Clause Description'
    @sap.quickinfo : 'Clause Code Description'
    QuantityParamDesc : String(50);
    @sap.label : 'Threshold Value'
    ThresholdValue : Decimal(13, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Threshold Reference'
    ThresholdRef : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Threshold Desc'
    @sap.quickinfo : 'Threshold Description'
    ThresholdDesc : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Clause Remark'
    ClauseRemark : String(50);
    AsTableName : String(20);
    @sap.label : 'Truth Value'
    @sap.quickinfo : 'Truth Value: True/False'
    isExpired : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    ChangedBy : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    ChangedDate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    ChangedTime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    CreatedBy : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    CreatedDate : Date;
    @sap.label : 'Created Time'
    CreatedTime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch DCQ data for iGMS'
  entity xGMSxCONTRACT_DQV {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    key KeyId : String(16) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    ValidFrom : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    ValidTo : Date;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivery Point'
    DeliveryPoint : String(10);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    DeliveryTxt : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Redelivery Point'
    RedeliveryPoint : String(10);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    RedeliveryTxt : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    ContractNo : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Interconnect Point'
    @sap.quickinfo : 'Interconnect Location ID'
    Interconnect_Pt : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'UTR Number'
    UTRNumber : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Unified Entry Pt'
    @sap.quickinfo : 'Unified Entry Point'
    Unient_Pt : String(10);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    UnientPtTxt : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Unified Exit Pt'
    @sap.quickinfo : 'Unified Exit Point'
    Uniext_Pt : String(10);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    UniextPtTxt : String(60);
    @sap.unit : 'Uom'
    @sap.label : 'Delivery DCQ'
    DeliveryDcq : Decimal(13, 3);
    @sap.unit : 'Uom'
    @sap.label : 'Redelivery DCQ'
    RedeliveryDcq : Decimal(13, 3);
    @sap.label : 'UOM'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Source'
    Source : String(10);
    AsTableName : String(20);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    SourceTxt : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Path'
    @sap.quickinfo : 'Delivery Redelivery Path'
    GasRoute : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tariff Category'
    TariffCategory : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Grid Name'
    GridName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Pipeline Network'
    PipelineNetwork : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Zone'
    Zones : String(15);
    @sap.label : 'Truth Value'
    @sap.quickinfo : 'Truth Value: True/False'
    isExpired : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Projection for COntract SP'
  entity xGMSxCONTRACT_SPV {
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Sales Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Parameter Id'
    key ServiceParameterId : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Version'
    key Versn : String(3) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    key ValidFrom : Date not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    key ValidTo : Date not null;
    key KeyId : String(26) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Parameter Desc'
    @sap.quickinfo : 'Clause Code Description'
    ServiceParameterDesc : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Parameter Type'
    @sap.quickinfo : 'Service Parameter Type'
    ServiceParameterType : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Parameter Value'
    @sap.quickinfo : 'Service Parameter Value'
    ServiceParameterValue : String(50);
    AsTableName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Sale Side'
  entity xGMSxCONTSALE {
    @sap.display.format : 'UpperCase'
    @sap.label : 'SD Document'
    @sap.quickinfo : 'Sales and Distribution Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    key KeyId : String(20) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    Material : String(40);
    @sap.label : 'Product Description'
    MaterialText : String(40);
    AsTableName : String(20);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    Item : String(6);
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    ValidFrom : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    ValidTo : Date;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master ContractRefNo'
    @sap.quickinfo : 'Master Agreement Ref No'
    Refmastercontno : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    Mastercontno : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Desc'
    @sap.quickinfo : 'Contract Description'
    ContractDesc : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agreement Type'
    @sap.quickinfo : 'IGMS Contract Type'
    Contyp : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Contract Purchase'
    @sap.heading : ''
    ServiceCont : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    PurchRefno : String(10);
    @sap.label : 'SD Document Category'
    DocumentCategory : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Document Type'
    DocumentType : String(4);
    @sap.label : 'Primary Indicator'
    @sap.quickinfo : 'Primary Contract Indicator'
    IsPrimaryContract : Boolean;
    @sap.label : 'Deletion Indicator'
    Loekz : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    Plant : String(4);
    @sap.label : 'Plant Name'
    PlantText : String(30);
    @sap.label : 'UOM'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Storage Location'
    StorageLoc : String(4);
    @sap.label : 'RDP ACC DCQ'
    @sap.quickinfo : 'Redelivery Point Accumulated DCQ'
    RdpAnnualQty : Integer;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Invoice Bill EXP'
    @sap.quickinfo : 'Invoice Billing Exception'
    InvoiceBillingExp : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Invoice Frequency'
    InvoiceFreq : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sold-to Party'
    SoldToParty : String(10);
    @sap.label : 'Name of Customer'
    SoldToPartyText : String(80);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ship-to Party'
    ShipToParty : String(10);
    ShipToPartyText : String(80);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Bill To Party'
    @sap.quickinfo : 'Bill to Party'
    BillToParty : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Payer'
    Payer : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Organization'
    SalesOrg : String(4);
    @sap.label : 'Sales Organization Description'
    SalesOrgText : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Distribution Channel'
    DistributionCh : String(2);
    @sap.label : 'Distribution Channel Description'
    DistributionChTxt : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Division'
    Division : String(2);
    @sap.label : 'Division Description'
    DivisionText : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Profile'
    ServiceProfile : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'MasterContractStatus'
    @sap.quickinfo : 'Master Contract Status'
    Constat : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
    to_contapproval : Association to many xGMSxCONTAPPROVAL {  };
    to_contbillsch : Association to many xGMSxCONTRACT_BSV {  };
    to_contmq : Association to many xGMSxFETCHMONTHLYQTY {  };
    to_contprice : Association to many xGMSxCONTRACTPRICING {  };
    to_contractcf : Association to many xGMSxCONTRACT_CFV {  };
    to_contractcl : Association to many xGMSxCONTRACT_CLV {  };
    to_contractdq : Association to many xGMSxCONTRACT_DQV {  };
    to_contractsp : Association to many xGMSxCONTRACT_SPV {  };
    to_history : Association to many xGMSxCONTHISTORY {  };
    to_linkedcont : Association to many xGMSxLINKCONTRACT {  };
    to_refapproval : Association to many xGMSxREFAPPROVAL {  };
    to_srvcontclause : Association to many xGMSxSRVCONTCLAUSE {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Create Nomination Data'
  entity xGMSxCREATENOMINATION {
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Gas Day'
    @sap.quickinfo : 'Gas Day Date'
    key Gasday : Date not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'NonNegative'
    Versn : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    Mastercontno : String(10);
    @sap.label : 'Name of Supplier'
    CustomerName : String(80);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer No'
    Customer : String(10);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Nomination key item'
    @sap.quickinfo : 'Nomination Key Item'
    NominationItem : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sold-to Party'
    SoldToParty : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Account Number of Supplier'
    Vendor : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivery Point'
    DeliveryPoint : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Redelivery Point'
    @sap.quickinfo : 'Re-Delivery Ponit'
    RedeliveryPoint : String(20);
    @sap.label : 'Time To'
    @sap.quickinfo : 'Nomination Time'
    ValidTo : Time;
    @sap.label : 'Time From'
    @sap.heading : ''
    ValidFrom : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Status'
    Zstat : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    Material : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination key'
    @sap.quickinfo : 'Nomination (technical) Key'
    NominationKey : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document Type'
    DocumentType : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    TransportSystem : String(10);
    @sap.label : 'Daily ContractQty'
    @sap.quickinfo : 'Daily Contractual Quantity'
    DeliveryDcq : Decimal(13, 3);
    @sap.label : 'RDCQ'
    @sap.heading : ''
    RedeliveryDcq : Decimal(13, 3);
    @sap.label : 'Unit of Measure'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    UOM : String(3);
    @sap.label : 'DNQ'
    @sap.quickinfo : 'daily nomination Quantity'
    ProposedDnq : Decimal(13, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Event Type'
    @sap.quickinfo : 'Nomination Event'
    Event : String(40);
    @sap.label : 'Approved DNQ'
    ApprovedDnq : Decimal(13, 3);
    @sap.label : 'RePublish DNQ'
    @sap.quickinfo : 'Re-Publish DNQ'
    RepublishDnq : Decimal(13, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Long comment'
    @sap.quickinfo : 'iSeries: Long comment of a table, view or table field'
    Remarks : String(255);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination Flag'
    @sap.quickinfo : 'flag for customer nomination'
    Flag : String(6);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Action'
    Action : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Path'
    Path : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Source'
    Source : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group'
    CustGrp : String(10);
    @odata.Type : 'Edm.DateTimeOffset'
    @sap.label : 'Short Time Stamp'
    @sap.quickinfo : 'UTC Time Stamp in Short Form (YYYYMMDDhhmmss)'
    Timestamp : DateTime;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Profile'
    ServiceProfile : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Purchase Indicator'
    @sap.heading : ''
    SalesPurchInd : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    CorrespondingDocNo : String(10);
    to_clausecode : Association to many xGMSxCONTRACT_CLV {  };
    to_GtaNomdata : Association to many xGMSxGTA_NOMDATA {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch Custumer and Supplier'
  entity xGMSxFETCHCUSTSUP {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sold-to Party'
    key SoldToParty : String(10) not null;
    @sap.label : 'Name of Customer'
    CustomerName : String(80);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch Monthly Qty'
  entity xGMSxFETCHMONTHLYQTY {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Sales Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Material : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer No'
    key Customer : String(10) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    key StartDate : Date not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    key EndDate : Date not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Version'
    key Versn : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Capacity Type Id'
    @sap.quickinfo : 'Capacity type id'
    key CapacityTypeId : String(10) not null;
    key KeyId : String(76) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Capacity Type'
    @sap.heading : ''
    CapacityType : String(5);
    @sap.unit : 'Uom'
    @sap.label : 'ACQ'
    @sap.quickinfo : 'Create Contract ACQ'
    Acq : Decimal(13, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    ContractNo : String(10);
    AsTableName : String(20);
    @sap.label : 'UOM'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Jan : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Jan2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Feb : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Feb2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Mar : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Mar2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Apr : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Apr2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    May : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    May2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Jun : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Jun2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Jul : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Jul2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Aug : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Aug2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Sep : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Sep2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Oct : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Oct2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Nov : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Nov2 : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Dece : Decimal(13, 3);
    @sap.label : 'Monthly QTY'
    @sap.quickinfo : 'Monthly Quantity'
    Dece2 : Decimal(13, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch Purchase Vendor and Name'
  entity xGMSxFetchPurcVendor {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier'
    key Vendor : String(10) not null;
    @sap.label : 'Name of Supplier'
    VendorName : String(80);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Nomination Data (GTA Specific)'
  entity xGMSxGTA_NOMDATA {
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Gas Day'
    @sap.quickinfo : 'Gas Day Date'
    key GasDay : Date not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'NonNegative'
    Versn : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer No'
    Customer : String(10);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Nomination key item'
    @sap.quickinfo : 'Nomination Key Item'
    NominationItem : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Account Number of Supplier'
    Vendor : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sold-to Party'
    SoldToParty : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivery Point'
    DeliveryPoint : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Redelivery Point'
    @sap.quickinfo : 'Re-Delivery Ponit'
    RedelivryPoint : String(20);
    @sap.label : 'Time To'
    @sap.quickinfo : 'Nomination Time'
    ValidTo : Time;
    @sap.label : 'Time From'
    @sap.heading : ''
    ValidFrom : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Status'
    Zstat : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    Material : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination key'
    @sap.quickinfo : 'Nomination (technical) Key'
    NominationKey : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document Type'
    DocumentType : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    TransportSystem : String(10);
    @sap.label : 'Daily ContractQty'
    @sap.quickinfo : 'Daily Contractual Quantity'
    DeliveryDcq : Decimal(13, 3);
    @sap.label : 'RDCQ'
    @sap.heading : ''
    RedeliveryDcq : Decimal(13, 3);
    @sap.label : 'Unit of Measure'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.label : 'DNQ'
    @sap.quickinfo : 'daily nomination Quantity'
    ProposedDnq : Decimal(13, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Event Type'
    @sap.quickinfo : 'Nomination Event'
    Event : String(40);
    @sap.label : 'Approved DNQ'
    ApprovedDnq : Decimal(13, 3);
    @sap.label : 'RePublish DNQ'
    @sap.quickinfo : 'Re-Publish DNQ'
    RepublishDnq : Decimal(13, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Long comment'
    @sap.quickinfo : 'iSeries: Long comment of a table, view or table field'
    Remarks : String(255);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination Flag'
    @sap.quickinfo : 'flag for customer nomination'
    Flag : String(6);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Action'
    Action : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Path'
    Path : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Source'
    Source : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group'
    CustGrp : String(10);
    @odata.Type : 'Edm.DateTimeOffset'
    @sap.label : 'Short Time Stamp'
    @sap.quickinfo : 'UTC Time Stamp in Short Form (YYYYMMDDhhmmss)'
    Timestamp : DateTime;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Profile'
    ServiceProfile : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Purchase Indicator'
    @sap.heading : ''
    SalesPurchInd : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    CorrespondingDocNo : String(10);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - link Contract'
  entity xGMSxLINKCONTRACT {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Link Contract'
    key Linkcont : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    ContractNo : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Master Contract'
  entity xGMSxMASTERCONT {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    key Mastercontno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master ContractRefNo'
    @sap.quickinfo : 'Master Agreement Ref No'
    key Refmastercontno : String(10) not null;
    key KeyId : String(20) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agreement Type'
    @sap.quickinfo : 'IGMS Contract Type'
    Contyp : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sold To Party'
    @sap.quickinfo : 'Contract Customer'
    SoldToParty : String(10);
    AsTableName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Common Customer'
    CommonCustomer : String(10);
    @sap.label : 'Name of Customer'
    CommonCustomerName : String(80);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Cardinality'
    Cardin : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Mat.posting'
    @sap.quickinfo : 'Material Posting Rule'
    Matpst : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Fee posting'
    @sap.quickinfo : 'Fee Posting Rule'
    Feepst : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'GTA Renewal Rule'
    Gtarenewrule : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'CT Renewal Rule'
    Ctrenewrule : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Imbalance Curing Rul'
    @sap.quickinfo : 'Imbalance Curing Rule'
    ImbalanceCrule : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Alert Notif Profile'
    @sap.quickinfo : 'Alert Notification Profile'
    Alertprofile : String(5);
    @sap.label : 'Cash-in/Cash OutFlag'
    @sap.quickinfo : 'Indicator: Trigger Cash-in/ Cash-out'
    Cashinoutind : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Cash-in/out AlertRul'
    @sap.quickinfo : 'Cash-in/Cash-out Alert Rule'
    Cashinoutrule : String(5);
    @sap.label : 'Trig.Park/Loan Alert'
    @sap.quickinfo : 'Indicator: Trigger Park/Loan Alert'
    Parkloanind : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Park/Loan Alert Rule'
    Parkloanrule : String(5);
    @sap.label : 'Indicator:CashSettle'
    @sap.quickinfo : 'Indicator: Trigger Cash-in/ Cash-out Settlement'
    Cashsettleind : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Cash Settle AlertRul'
    @sap.quickinfo : 'Cash Settlement Alert Rule'
    Cashsettlerule : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'HowTo Split SchedQty'
    @sap.quickinfo : 'How to Split Schedule Quantity'
    Qssplit : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'MasterContractStatus'
    @sap.quickinfo : 'Master Contract Status'
    Constat : String(1);
    @sap.display.format : 'Date'
    @sap.label : 'Agreement Start Date'
    Begda : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Agreement End Date'
    Endda : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Agreement ReviewDate'
    @sap.quickinfo : 'Agreement Review Date'
    Revda : Date;
    @sap.label : 'Notice Period'
    Notper : Decimal(3, 0);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ship-to Party'
    ShipToParty : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Organization'
    SalesOrg : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Distribution Channel'
    DistributionCh : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Division'
    Division : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Profile'
    ServiceProfile : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purch. Organization'
    @sap.quickinfo : 'Purchasing Organization'
    PurchaseOrg : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purchasing Group'
    PruchaseGrp : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
    to_contcl : Association to many xGMSxMCONTRACTCLAUSE {  };
    to_contclqty : Association to many xGMSxMCONTRACTCL_QTY {  };
    to_contpur : Association to many xGMSxCONTPURCHASE {  };
    to_contsal : Association to many xGMSxCONTSALE {  };
    to_mastercontapproval : Association to many xGMSxCONTAPPROVAL {  };
    to_masterdcq : Association to many xGMSxMDCQ {  };
    to_mastermq : Association to many xGMSxCONTMONTHQTY {  };
    to_masterrefapproval : Association to many xGMSxREFAPPROVAL {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Master Contract Clause'
  entity xGMSxMCONTRACTCLAUSE {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master ContractRefNo'
    @sap.quickinfo : 'Master Agreement Ref No'
    key Refmastercontno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    key Mastercontno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agreement Type'
    @sap.quickinfo : 'IGMS Contract Type'
    key Contyp : String(5) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'F.Parameter Id'
    @sap.quickinfo : 'Financial Parameter Id'
    key FinancialParamId : String(8) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    key ValidFrom : Date not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    key ValidTo : Date not null;
    key KeyId : String(24) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Clause Description'
    @sap.quickinfo : 'Clause Code Description'
    FinancialParamDesc : String(50);
    @sap.label : 'Threshold Perc'
    @sap.quickinfo : 'Threshold Percentage'
    ThresholdPer : Decimal(3, 0);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Threshold Reference'
    ThresholdRef : String(20);
    AsTableName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Threshold Desc'
    @sap.quickinfo : 'Threshold Description'
    ThresholdDesc : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Exception'
    BillingException : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Calculated Value'
    CalculatedValue : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Frequency'
    BillingFreq : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document Of Charge'
    @sap.quickinfo : 'Document of Charge'
    DocumentOfCharge : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Calculation Freq'
    @sap.quickinfo : 'Calculation Frequency'
    CalculationFreq : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Credit & Debit'
    CreditDebit : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Clause Remark'
    ClauseRemark : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Master Contract Clause Qty'
  entity xGMSxMCONTRACTCL_QTY {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master ContractRefNo'
    @sap.quickinfo : 'Master Agreement Ref No'
    key Refmastercontno : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'F.Parameter Id'
    @sap.quickinfo : 'Financial Parameter Id'
    key QuantityParamId : String(8) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    key ValidFrom : Date not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    key ValidTo : Date not null;
    key KeyId : String(24) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    Mastercontno : String(10);
    AsTableName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Clause Description'
    @sap.quickinfo : 'Clause Code Description'
    QuantityParamDesc : String(50);
    @sap.label : 'Threshold Perc'
    @sap.quickinfo : 'Threshold Percentage'
    ThresholdPer : Decimal(3, 0);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Threshold Reference'
    ThresholdRef : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Threshold Desc'
    @sap.quickinfo : 'Threshold Description'
    ThresholdDesc : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Clause Remark'
    ClauseRemark : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Master DCQ'
  entity xGMSxMDCQ {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master ContractRefNo'
    @sap.quickinfo : 'Master Agreement Ref No'
    key Refmastercontno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    key Mastercontno : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.unit : 'Uom'
    @sap.label : 'DCQ'
    @sap.heading : ''
    key Dcq : Decimal(13, 3) not null;
    key KeyId : String(16) not null;
    @sap.label : 'UOM'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    ValidFrom : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    ValidTo : Date;
    AsTableName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Past nom for new nomdata table'
  entity xGMSxNEWPAST_NOM {
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Gas Day'
    @sap.quickinfo : 'Gas Day Date'
    key Gasday : Date not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'NonNegative'
    Versn : String(3);
    @sap.label : 'Approved DNQ'
    ApprovedDnq : Decimal(13, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination key'
    @sap.quickinfo : 'Nomination (technical) Key'
    NominationKey : String(20);
    @sap.label : 'Unit of Measure'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    UOM : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Event Type'
    @sap.quickinfo : 'Nomination Event'
    Event : String(40);
    @sap.display.format : 'UpperCase'
    @sap.text : 'Material_Description'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    Material : String(40);
    @sap.label : 'Material Description'
    Material_Description : String(40);
    @sap.label : 'RePublish DNQ'
    @sap.quickinfo : 'Re-Publish DNQ'
    RepublishDnq : Decimal(13, 3);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch for Nom Detail API'
  entity xGMSxNOMDETAILS {
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Redelivery Point'
    key RedeliveryPoint : String(10) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    key ValidFrom : Date not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    key ValidTo : Date not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sold To Party'
    SoldToParty : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    Material : String(40);
    @sap.unit : 'Uom'
    @sap.label : 'DNQ'
    @sap.quickinfo : 'daily nomination Quantity'
    DpDnq : Decimal(13, 3);
    @sap.label : 'UOM'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.unit : 'Uom'
    @sap.label : 'DNQ'
    @sap.quickinfo : 'daily nomination Quantity'
    RpDnq : Decimal(13, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivery Point'
    DeliveryPoint : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Event'
    @sap.quickinfo : 'Capasity Release Event'
    Event : String(100);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetching the Org Details'
  entity xGMSxOrgDetails_Final {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Contract'
    key ContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Company Code'
    @sap.quickinfo : 'Company code of the sales organization'
    key CompanyCode : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'In-transit plant'
    @sap.quickinfo : 'Transport system In-transit Plant'
    key Plant : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'In-transit S.Loc.'
    @sap.quickinfo : 'Transport system In-transit Storage Location'
    key StorageLocation : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    key TransportSystem : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Organization'
    key SalesOrg : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sold-to Party'
    key SoldToParty : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Contract Type'
    key DocType : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Distribution Channel'
    key DistributionChannel : String(2) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Division'
    key Division : String(2) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid-To Date'
    @sap.quickinfo : 'Valid-To Date (Outline Agreements, Product Proposals)'
    key ValidTo : Date not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purch. Organization'
    @sap.quickinfo : 'Purchasing Organization'
    key PurchOrg : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purchasing Group'
    key PurchGrp : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier'
    key Supplier : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Field'
    key ContractField : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Field Value'
    @sap.quickinfo : 'Contract Field Value'
    FieldValue : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivery Point'
    Delivery_Point : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Redelivery Point'
    Redelivery_Point : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivery DCQ'
    Delivery_Dcq : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'ReDelivery DCQ'
    @sap.quickinfo : 'Redelivery DCQ'
    Redelivery_Dcq : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Profile'
    Profile : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    Material : String(40);
    @sap.label : 'Name of Supplier'
    SupplierText : String(80);
    @sap.label : 'Purchasing Grp. Name'
    @sap.quickinfo : 'Purchasing Group Name'
    PurchGrpText : String(18);
    @sap.label : 'Purch. Org. Name'
    @sap.quickinfo : 'Purchasing Organization Name'
    PurchOrgText : String(20);
    @sap.label : 'Name'
    DivisionText : String(20);
    @sap.label : 'Distribution Channel Description'
    DistributionChannelText : String(20);
    @sap.label : 'Name'
    @sap.quickinfo : 'Name 1'
    SoldToPartyText : String(35);
    @sap.label : 'Name'
    SalesOrgText : String(20);
    @sap.label : 'Company Name'
    @sap.quickinfo : 'Name of Company Code or Company'
    CompanyCodeText : String(25);
    @sap.display.format : 'Date'
    @sap.label : 'Valid-From Date'
    @sap.quickinfo : 'Valid-From Date (Outline Agreements, Product Proposals)'
    ValidFrom : Date;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Approval with RefNo'
  entity xGMSxREFAPPROVAL {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Version'
    key Versn : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Indicator'
    key ContIndicator : String(1) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'AR Level'
    @sap.heading : ''
    key ArLevel : String(2) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ar Email'
    @sap.quickinfo : 'AR Email'
    key ArEmail : String(30) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    Contractno : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'AR Indicator'
    ArIndicator : String(1);
    @sap.display.format : 'Date'
    @sap.label : 'AR Date'
    ArDate : Date;
    @sap.label : 'AR TIME'
    @sap.quickinfo : 'AR Time'
    ArTime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Remark'
    @sap.quickinfo : 'Remarks'
    Remark : String(50);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'CDS for Service profile'
  entity xGMSxSERVPROFILE {
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Sales Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Parameter Id'
    key ServiceParameterId : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Version'
    key Versn : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Parameter Desc'
    @sap.quickinfo : 'Clause Code Description'
    key ServiceParameterDesc : String(50) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Parameter Type'
    @sap.quickinfo : 'Service Parameter Type'
    ServiceParameterType : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Parameter Value'
    @sap.quickinfo : 'Service Parameter Value'
    ServiceParameterValue : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Service Catalog Clause'
  entity xGMSxSRVCONTCLAUSE {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'F.Parameter Id'
    @sap.quickinfo : 'Financial Parameter Id'
    key FinancialParamId : String(8) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    key KeyId : String(24) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    key ValidFrom : Date not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    key ValidTo : Date not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    ContractNo : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Clause Description'
    @sap.quickinfo : 'Clause Code Description'
    FinancialParamDesc : String(50);
    AsTableName : String(20);
    @sap.label : 'Threshold Perc'
    @sap.quickinfo : 'Threshold Percentage'
    ThresholdPer : Decimal(3, 0);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Threshold Reference'
    ThresholdRef : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Threshold Desc'
    @sap.quickinfo : 'Threshold Description'
    ThresholdDesc : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Exception'
    BillingException : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Calculated Value'
    CalculatedValue : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Frequency'
    BillingFreq : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document Of Charge'
    @sap.quickinfo : 'Document of Charge'
    DocumentOfCharge : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Calculation Freq'
    @sap.quickinfo : 'Calculation Frequency'
    CalculationFreq : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Credit & Debit'
    CreditDebit : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Clause Remark'
    ClauseRemark : String(50);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    Createdby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Created Date'
    Createddate : Date;
    @sap.label : 'Created Time'
    Createdtime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    Changedby : String(15);
    @sap.display.format : 'Date'
    @sap.label : 'Change Date'
    @sap.quickinfo : 'Changed Date'
    Changeddate : Date;
    @sap.label : 'Change Time'
    @sap.quickinfo : 'Changed Time'
    Changedtime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Business Area'
  entity I_BusinessAreaStdVH {
    @sap.display.format : 'UpperCase'
    @sap.text : 'BusinessArea_Text'
    @sap.label : 'Business Area'
    key BusinessArea : String(4) not null;
    @sap.label : 'Business Area Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    BusinessArea_Text : String(30);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Company Code'
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
  @sap.label : 'Credit Control Area'
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
  @sap.searchable : 'true'
  @sap.content.version : '1'
  @sap.label : 'Customer'
  entity I_Customer_VH {
    @sap.display.format : 'UpperCase'
    @sap.text : 'BPCustomerName'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer Number'
    key Customer : String(10) not null;
    @sap.label : 'Customer Name 1'
    @sap.quickinfo : 'Name 1'
    OrganizationBPName1 : String(35);
    @sap.label : 'Business Partner Name 1'
    @sap.quickinfo : 'Name 1'
    BusinessPartnerName1 : String(40);
    @sap.label : 'Customer Name 2'
    @sap.quickinfo : 'Name 2'
    OrganizationBPName2 : String(35);
    @sap.label : 'Business Partner Name 2'
    @sap.quickinfo : 'Name 2'
    BusinessPartnerName2 : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Country/Region'
    @sap.quickinfo : 'Country/Region Key'
    Country : String(3);
    @sap.label : 'City'
    CityName : String(35);
    @sap.label : 'Business Partner Address City'
    @sap.quickinfo : 'City'
    BPAddrCityName : String(40);
    @sap.label : 'Street'
    @sap.quickinfo : 'Street and House Number'
    StreetName : String(35);
    @sap.label : 'Business Partner Address Street'
    @sap.quickinfo : 'Street'
    BPAddrStreetName : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Postal Code'
    PostalCode : String(10);
    @sap.label : 'Customer Name'
    @sap.quickinfo : 'Name of Customer'
    CustomerName : String(80);
    @sap.label : 'Business Partner Customer Name'
    @sap.quickinfo : 'Customer Name'
    BPCustomerName : String(81);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Account group'
    @sap.quickinfo : 'Customer Account Group'
    CustomerAccountGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Authorization'
    @sap.quickinfo : 'Authorization Group'
    AuthorizationGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purpose Complete Flag'
    @sap.quickinfo : 'Business Purpose Completed Flag'
    IsBusinessPurposeCompleted : String(1);
    @sap.label : 'Competitors'
    @sap.quickinfo : 'Indicator: Competitor'
    IsCompetitor : Boolean;
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
};

