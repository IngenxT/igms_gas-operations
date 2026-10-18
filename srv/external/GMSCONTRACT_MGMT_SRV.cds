/* checksum : f29166a403137e1b22042d510d08d62f */
@cds.external : true
@m.IsDefaultEntityContainer : 'true'
@sap.message.scope.supported : 'true'
@sap.supported.formats : 'atom json xlsx'
service GMSCONTRACT_MGMT_SRV {
  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity UpdateTrfsubpathSet {
    @sap.unicode : 'false'
    @sap.label : 'Reference Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Refno : String(10) not null;
    to_trfsubpath : Association to many TrfsubpathItemSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity TrfsubpathItemSet {
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
    @sap.label : 'Sub Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Subitem : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key FromPoint : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ToPoint : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Tariff Path'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Subpath : String(130) not null;
    @sap.unicode : 'false'
    @sap.label : 'Third Party Ent. Ind'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ThrdPrtyEntInd : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Withdraw PT'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Withdrawpt : String(50) not null;
    @sap.unicode : 'false'
    @sap.label : 'Distance'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Distance : Decimal(8, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Entitle Tariff Zone'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EnTariffZone : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Trans system'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TransportSystm : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Own : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'DocumentNo'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ContractNo : String(10) not null;
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
  @sap.content.version : '1'
  entity MessageCollection {
    @sap.unicode : 'false'
    @sap.label : 'Return Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Type : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Return Message'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Msg : String(220) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity createLongText {
    @sap.unicode : 'false'
    @sap.label : 'Reference Number'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Refno : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'DocumentNo'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Contractno : String(10) not null;
    to_longtexts : Association to many ContractLongTextItemSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ContractLongTextItemSet {
    @sap.unicode : 'false'
    @sap.label : 'Reference Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Refno : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Digital id'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key DigitalId : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'DocumentNo'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Contractno : String(10) not null;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Timestamp : DateTime not null;
    @sap.unicode : 'false'
    @sap.label : 'Header Text ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Hdr_Txtid : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Child Text ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Child_Txtid : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Contract Text'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Contracttext : String not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity CreateBillingSchSet {
    @sap.unicode : 'false'
    @sap.label : 'Reference Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Refno : String(10) not null;
    BllingSchAsso : Association to many BllingSchedulingSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity BllingSchedulingSet {
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
    @sap.label : 'Clause Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key FinancialParameterId : String(20) not null;
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
    @sap.label : 'Billing Frequency'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key FrequencyCode : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Billing Exception'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ExceptionCode : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Billing Cycle'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Cycle : String(5) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Period Start'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PeriodStart : Timestamp not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Period End'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    PeriodEnd : Timestamp not null;
    @sap.unicode : 'false'
    @sap.label : 'DocumentNo'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ContractNo : String(10) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Billing Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    BillingDate : Timestamp not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Effective Bill Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EffectiveBillingDate : Timestamp not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Valid From'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ValidFrom : Timestamp not null;
    @sap.unicode : 'false'
    @sap.label : 'Clause Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    FinancialParameterDesc : String(50) not null;
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
    @sap.unicode : 'false'
    @sap.label : 'Changed By'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Changedby : String(15) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Change Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Changeddate : Timestamp not null;
    @sap.unicode : 'false'
    @sap.label : 'Change Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Changedtime : Time not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity CreateApprPlanSet {
    @sap.unicode : 'false'
    @sap.label : 'Customer'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Customer : String(10) not null;
    to_ApprPlanMaint : Association to many ApprPlanMaintSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity ApprPlanMaintSet {
    @sap.unicode : 'false'
    @sap.label : 'Reference Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Refno : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'DocumentNo'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Contractno : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Versn : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ContIndicator : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'AR Level'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ArLevel : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ar Email'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ArEmail : String(30) not null;
    @sap.unicode : 'false'
    @sap.label : 'AR Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ArIndicator : String(1) not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'AR Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ArDate : Timestamp not null;
    @sap.unicode : 'false'
    @sap.label : 'AR TIME'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ArTime : Time not null;
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
    @sap.unicode : 'false'
    @sap.label : 'Remark'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Remark : String(50) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity contHistorySet {
    @sap.unicode : 'false'
    @sap.label : 'Reference Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Refno : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'DocumentNo'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ContractNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Item : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ContIndicator : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Counter'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Counter : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Field Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key FieldName : String(35) not null;
    @sap.unicode : 'false'
    @sap.label : 'KeyId'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    KeyId : String(100) not null;
    @sap.unicode : 'false'
    @sap.label : 'Old Value'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OldValue : String(250) not null;
    @sap.unicode : 'false'
    @sap.label : 'New Value'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NewValue : String(250) not null;
    @sap.unicode : 'false'
    @sap.label : 'Table Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TableName : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'ChangeHistory'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChangeHistory : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Changed By'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChangedBy : String(15);
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Change Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChangedOn : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Change Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChangedTime : Time;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity createHistorySet {
    @sap.unicode : 'false'
    @sap.label : 'Reference Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Refno : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'DocumentNo'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ContractNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'ArEmail'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ArEmail : String(30) not null;
    @sap.unicode : 'false'
    @sap.label : 'ArLevel'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ArLevel : String(2) not null;
    to_item : Association to many contHistorySet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity RefNoSet {
    @sap.unicode : 'false'
    @sap.label : 'REFNO'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Refno : String(10) not null;
  } actions {
    function GenerateRefNo(
      @sap.label : 'Maste Agreement Type'
      ContType : String(5),
      Type : String(1)
    ) returns RefNoSet;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity uploadDcqSet {
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key FileName : String(20) not null;
    to_dcqitem : Association to many dcqFieldSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity dcqFieldSet {
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key SalesOffice : String not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key CustomerCode : String not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ContractNo : String not null;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Valid From'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ValidFrom : DateTime not null;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Valid To'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ValidTo : DateTime not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DCQ : Decimal(12, 3) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MaxDcqId : String not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MinDcqId : String not null;
    @sap.unicode : 'false'
    @sap.label : 'Threshold Perc'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MaxDcqPer : Decimal(3, 0) not null;
    @sap.unicode : 'false'
    @sap.label : 'Threshold Perc'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MinDcqPer : Decimal(3, 0) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity custPlannedSet {
    @sap.unicode : 'false'
    @sap.label : 'Version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Versn : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'DocumentNo'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ContractNo : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reference Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Refno : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Customer'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Customer : String(10) not null;
    @sap.display.format : 'Date'
    @sap.unicode : 'false'
    @sap.label : 'Valid From'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ValidFrom : Date not null;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Valid To'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ValidTo : DateTime not null;
    @sap.unicode : 'false'
    @sap.label : 'Order Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key DocumentType : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'UOM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3) not null;
    @sap.unicode : 'false'
    @sap.unit : 'Uom'
    @sap.label : 'Planned Dcq'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Dcq : String(30) not null;
    @sap.unicode : 'false'
    @sap.label : 'Reason Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ReasonCode : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Clause Remark'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Remarks : String(50) not null;
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
  entity createPlannedSet {
    @sap.unicode : 'false'
    @sap.label : 'Customer'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Customer : String(10) not null;
    to_planned : Association to many custPlannedSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity FormulaRepoSet {
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Forid : String(10) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ForDesc : String(40) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ShippingPointSet {
    @sap.unicode : 'false'
    @sap.label : 'Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Werks : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Matnr : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Customer'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Kunnr : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sales Org.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Vkorg : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Distr. Channel'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Vtweg : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sales Doc. Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Auart : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Shipping Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vstel : String(4) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Sap Calendar'
  entity xGMSxCALENDAR {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    key Plant : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Factory Calendar'
    @sap.quickinfo : 'Factory calendar key'
    fabkl : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Holiday Calendar ID'
    @sap.quickinfo : 'Public Holiday Calendar'
    Hocid : String(2);
    @sap.display.format : 'Date'
    @sap.label : 'Date'
    Dates : Date;
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
    @sap.label : 'Text'
    @sap.quickinfo : 'Text for translation'
    Reason : String(200);
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
    OldValue : String(250);
    @sap.display.format : 'UpperCase'
    @sap.label : 'New Value'
    NewValue : String(250);
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
    @sap.display.format : 'Date'
    @sap.label : 'Valid-From Date'
    @sap.quickinfo : 'Valid-From Date (Outline Agreements, Product Proposals)'
    ActualValidFrom : Date;
    @sap.display.format : 'Date'
    @sap.label : 'Valid-To Date'
    @sap.quickinfo : 'Valid-To Date (Outline Agreements, Product Proposals)'
    ActualValidTo : Date;
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
    key KeyId : String(11) not null;
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
    ContractDesc : String(35);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Contract Sale'
    @sap.heading : ''
    ServiceCont : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Document'
    SaleCont : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Document'
    SalesCont : String(10);
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
    @sap.label : 'Batch'
    @sap.quickinfo : 'Batch Number'
    Batch : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Prop. Shipping Point'
    @sap.quickinfo : 'Proposed Shipping Point'
    ShippingPoint : String(4);
    @sap.label : 'Description'
    ShippingPointTxt : String(30);
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
    @sap.label : 'Invoice Bill EXP'
    @sap.quickinfo : 'Invoice Billing Exception'
    InvoiceBilling : String(3);
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
    @sap.label : 'Purch. Org. Name'
    @sap.quickinfo : 'Purchasing Organization Name'
    PurchaseOrgTxt : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purchasing Group'
    PurchaseGrp : String(3);
    @sap.label : 'Purchasing Grp. Name'
    @sap.quickinfo : 'Purchasing Group Name'
    PurchaseGrpTxt : String(18);
    @sap.display.format : 'UpperCase'
    @sap.label : 'MasterContractStatus'
    @sap.quickinfo : 'Master Contract Status'
    Constat : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Company Code'
    CompanyCode : String(4);
    @sap.label : 'Company Name'
    @sap.quickinfo : 'Name of Company Code or Company'
    CompanyCodeTxt : String(25);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Process Sta'
    @sap.quickinfo : 'Contract Process Status'
    ProcessStatus : String(1);
    @sap.label : 'E-Mail Address'
    CreatedByEmail : String(241);
    @sap.label : 'E-Mail Address'
    ChangedByEmail : String(241);
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
    to_trfsubpath : Association to many xGMSxTARIFF_SUBPATH {  };
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
    @sap.label : 'IsManual'
    @sap.quickinfo : 'Is Manual Indicator'
    IsManual : Boolean;
    @sap.label : 'Amount'
    @sap.quickinfo : 'Pricing Amount'
    Amount : Decimal(24, 9);
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
    @sap.label : 'Formula Repos. ID'
    @sap.quickinfo : 'Formula repository ID'
    PriceformId : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Type'
    Billingtype : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Pricing Pro Name'
    @sap.quickinfo : 'Pricing Profile Name'
    Pricingprofilename : String(20);
    @sap.unit : 'Waerk'
    @sap.label : 'Condition Value'
    ConditionValue : Decimal(16, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document Currency'
    @sap.quickinfo : 'SD Document Currency'
    @sap.semantics : 'currency-code'
    Waerk : String(5);
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
    @sap.display.format : 'NonNegative'
    @sap.label : 'Version'
    key Versn : String(3) not null;
    key KeyId : String(20) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Field'
    @sap.quickinfo : 'Contract Field ID'
    ContractFldId : String(10);
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
    @sap.label : 'Deviation'
    Deviation : Boolean;
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
    key KeyId : String(46) not null;
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
    @sap.display.format : 'UpperCase'
    @sap.label : 'Entitle Tariff Zone'
    @sap.quickinfo : 'Entitlement Tariff Zone'
    EnTariffZone : String(4);
    @sap.label : 'Distance'
    Distance : Decimal(8, 3);
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
    DeliveryDcq : Decimal(13, 3);
    @sap.unit : 'Uom'
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
    GasRoute : String(250);
    @sap.display.format : 'UpperCase'
    @sap.label : 'PNGRB Tariff Path'
    @sap.quickinfo : 'iGMS: PNGRB Tariff Path'
    PngrbPath : String(130);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tariff Category'
    TariffCategory : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    DeliveryTsyst : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    RedeliveryTsyst : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    UniEntryTsyst : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    UniExitTsyst : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tariff Code'
    TariffCode : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Grid Name'
    GridName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Pipeline Network'
    PipelineNetwork : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Zone'
    Zones : String(15);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Destination'
    Destination : String(50);
    @sap.label : 'Truth Value'
    @sap.quickinfo : 'Truth Value: True/False'
    isExpired : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Withdraw PT'
    @sap.quickinfo : 'Withdraw Point'
    WithdrawPt : String(50);
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
    @sap.label : 'Deviation'
    Deviation : Boolean;
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
  @sap.label : 'iGMS - Contract Texts View'
  entity xGMSxCONTRACT_TXV {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key Contractno : String(10) not null;
    @odata.Type : 'Edm.DateTimeOffset'
    @sap.label : 'Time Stamp'
    @sap.quickinfo : 'UTC Time Stamp in Short Form (YYYYMMDDhhmmss)'
    key Timestamp : DateTime not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Header Text ID'
    @sap.quickinfo : 'Contract Texts - Header Text ID'
    key Hdr_Txtid : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Child Text ID'
    @sap.quickinfo : 'Contract Texts - Child Text ID'
    key Child_Txtid : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Text'
    @sap.quickinfo : 'iGMS - Contract Text'
    Contracttext : String;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Digital id'
    @sap.quickinfo : 'Digital Id'
    DigitalId : String(10);
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
    key KeyId : String(11) not null;
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
    ContractDesc : String(35);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agreement Type'
    @sap.quickinfo : 'IGMS Contract Type'
    Contyp : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Contract Purchase'
    @sap.heading : ''
    ServiceCont : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purchasing Document'
    @sap.quickinfo : 'Purchasing Document Number'
    PurchCont : String(10);
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
    @sap.label : 'Primary Indicator'
    @sap.quickinfo : 'Primary Contract Indicator'
    IsPrimary : Boolean;
    @sap.label : 'Deletion Indicator'
    Loekz : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Batch'
    @sap.quickinfo : 'Batch Number'
    Batch : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Prop. Shipping Point'
    @sap.quickinfo : 'Proposed Shipping Point'
    ShippingPoint : String(4);
    @sap.label : 'Description'
    ShippingPointTxt : String(30);
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
    @sap.label : 'Invoice Bill EXP'
    @sap.quickinfo : 'Invoice Billing Exception'
    InvoiceBilling : String(3);
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
    @sap.label : 'Differ.Refer.Code'
    @sap.quickinfo : 'Differential Reference Code (DRC)'
    Drc : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Department'
    @sap.quickinfo : 'Department number'
    CentralPlant : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'MasterContractStatus'
    @sap.quickinfo : 'Master Contract Status'
    Constat : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Process Sta'
    @sap.quickinfo : 'Contract Process Status'
    ProcessStatus : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'SD Document'
    @sap.quickinfo : 'Sales and Distribution Document Number'
    CtReference : String(10);
    @sap.label : 'E-Mail Address'
    CreatedByEmail : String(241);
    @sap.label : 'E-Mail Address'
    ChangedByEmail : String(241);
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
    to_trfsubpath : Association to many xGMSxTARIFF_SUBPATH {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract Customer Grp 1'
  entity xGMSxCUSTGRP1 {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group 1'
    key CustomerGrp1 : String(3) not null;
    @sap.label : 'Description'
    Description : String(20);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract Customer Grp 2'
  entity xGMSxCUSTGRP2 {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group 2'
    key CustomerGrp2 : String(3) not null;
    @sap.label : 'Description'
    Description : String(20);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract Customer Grp 3'
  entity xGMSxCUSTGRP3 {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group 3'
    key CustomerGrp3 : String(3) not null;
    @sap.label : 'Description'
    Decsription : String(20);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract Customer Grp 4'
  entity xGMSxCUSTGRP4 {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group 4'
    key CustomerGrp4 : String(3) not null;
    @sap.label : 'Description'
    Description : String(20);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract Customer Grp 5'
  entity xGMSxCUSTGRP5 {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group 5'
    key CustomerGrp5 : String(3) not null;
    @sap.label : 'Description'
    Description : String(20);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Customer Master Data'
  entity xGMSxCustomer_Master {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer Number'
    key Customer : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Name'
    @sap.quickinfo : 'Customer Full Name'
    CustomerFullName : String(220);
    @sap.label : 'Name of Customer'
    CustomerName : String(80);
    @sap.label : 'E-Mail Address'
    CustomerEmail : String(241);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Authorization'
    @sap.quickinfo : 'Authorization Group'
    AuthorizationGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing block'
    @sap.quickinfo : 'Central billing block for customer'
    BillingIsBlockedForCustomer : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created by'
    @sap.quickinfo : 'Name of Person who Created the Object'
    CreatedByUser : String(12);
    @sap.display.format : 'Date'
    @sap.label : 'Created On'
    @sap.quickinfo : 'Record Created On'
    CreationDate : Date;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Account group'
    @sap.quickinfo : 'Customer Account Group'
    CustomerAccountGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Classific.'
    @sap.quickinfo : 'Customer Classification'
    CustomerClassification : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivery block'
    @sap.quickinfo : 'Central delivery block for the customer'
    DeliveryIsBlocked : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Natural Person'
    NFPartnerIsNaturalPerson : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Order block'
    @sap.quickinfo : 'Central order block for customer'
    OrderIsBlockedForCustomer : String(2);
    @sap.label : 'Posting Block'
    @sap.quickinfo : 'Central posting block'
    PostingIsBlocked : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Account Number of Supplier'
    Supplier : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Group Key'
    CustomerCorporateGroup : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Fiscal address'
    @sap.quickinfo : 'Account number of the master record with the fiscal address'
    FiscalAddress : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Industry'
    @sap.quickinfo : 'Industry Key'
    Industry : String(4);
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
    @sap.display.format : 'NonNegative'
    @sap.label : 'Int. location no. 1'
    @sap.quickinfo : 'International location number (part 1)'
    InternationalLocationNumber1 : String(7);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nielsen indicator'
    @sap.quickinfo : 'Nielsen ID'
    NielsenRegion : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tax Type'
    ResponsibleType : String(2);
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
    @sap.label : 'Tax number type'
    @sap.quickinfo : 'Tax Number Type'
    TaxNumberType : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'VAT Registration No.'
    @sap.quickinfo : 'VAT Registration Number'
    VATRegistration : String(20);
    @sap.label : 'Deletion Flag'
    @sap.quickinfo : 'Central Deletion Flag for Master Record'
    DeletionIndicator : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purpose Completed'
    @sap.quickinfo : 'Business Purpose Completed Flag'
    IsBusinessPurposeCompleted : String(1);
    to_CustomerCompany : Association to many A_CustomerCompany {  };
    to_CustomerSalesArea : Association to many A_CustomerSalesArea {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Document Type Billing Logic'
  entity xGMSxDocType_Billing {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Type'
    key DocType : String(4) not null;
    @sap.label : 'SD Document Category'
    Ind : String(4);
    @sap.label : 'Description'
    Description : String(40);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Entity Code view'
  entity xGMSxENTITYCDVIEW {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    key Entity : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Entity Code'
    Code : String(5);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract Data Fetch'
  entity xGMSxFETCHCONTRACTDATA {
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key Material : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivery Point'
    key DeliveryPoint : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Redelivery Point'
    key RedeliveryPoint : String(10) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    key ValidForm : Date not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    key ValidTo : Date not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Version'
    key Versn : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document Type'
    DocumentType : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Profile'
    ServiceProfile : String(40);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivery DCQ'
    DeliveryDcq : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'ReDelivery DCQ'
    @sap.quickinfo : 'Redelivery DCQ'
    RedeliveryDcq : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'MONTHY DCQ'
    @sap.quickinfo : 'Monthly DCQ'
    MonthlyDcq : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Path'
    @sap.quickinfo : 'Delivery Redelivery Path'
    GasRoute : String(250);
    @sap.label : 'Fuel%'
    @sap.quickinfo : 'Fuel Percentage'
    FuelPercentage : Decimal(5, 2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Fuel Location'
    FuelLocation : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Imbalance Transfer?'
    @sap.quickinfo : 'Imbalance Transfer Indicator (X = True, blank = false)'
    ImbalanceTransfer : String(1);
    @sap.label : 'Tariff'
    Tariff : Integer;
    @sap.label : 'Entitled Tariff'
    EntitleTariff : Decimal(5, 4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Zone'
    Zonepf : String(15);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Purchase Indicator'
    @sap.heading : ''
    SalesPurchInd : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sector Type'
    @sap.quickinfo : 'Type of sector (Industry/CGD).'
    SectorType : String(15);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Grid Name'
    Grid : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Pipeline Network'
    PipelineNetwork : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Desc'
    @sap.quickinfo : 'Contract Description'
    ContractDesc : String(35);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Plant'
    Plant : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    TransportSystem : String(10);
    @sap.label : 'System name'
    @sap.quickinfo : 'OIL-TSW: Transport system name'
    TransportSystemName : String(60);
    to_contcfv : Association to many xGMSxCONTRACT_CFV {  };
    to_contcl : Association to many xGMSxCONTRACT_CLV {  };
    to_contspv : Association to many xGMSxCONTRACT_SPV {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch Contract No'
  entity xGMSxFETCHCONTRACTNO {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'SD Document'
    @sap.quickinfo : 'Sales and Distribution Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    key Mastercontno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master ContractRefNo'
    @sap.quickinfo : 'Master Agreement Ref No'
    key RefMasterContNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key PurchaseContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key PurchaseRefNo : String(10) not null;
    @sap.display.format : 'NonNegative'
    key PurchaseContractItem : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agreement Type'
    @sap.quickinfo : 'IGMS Contract Type'
    MasterContType : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Desc'
    @sap.quickinfo : 'Contract Description'
    ContractDesc : String(35);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Document Type'
    DocumentType : String(4);
    PurchaseDocumentType : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ship-to Party'
    ShipToParty : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sold-to Party'
    SoldToParty : String(10);
    Vendor : String(10);
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
    @sap.label : 'AACQ'
    @sap.quickinfo : 'Adjusted Annual Contractual Quantity'
    Aacq : Decimal(13, 3);
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
  @sap.label : 'Fetching Purchase Ref No and Contract No'
  entity xGMSxFETCHPURHREF {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key PurchRefno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master ContractRefNo'
    @sap.quickinfo : 'Master Agreement Ref No'
    RefMasterNo : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master ContractRefNo'
    @sap.quickinfo : 'Master Agreement Ref No'
    Refmastercontno : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    SalesRefno : String(10);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch Service Contract data'
  entity xGMSxFETCHSERVICECONT {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master ContractRefNo'
    @sap.quickinfo : 'Master Agreement Ref No'
    Refmastercontno : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Desc'
    @sap.quickinfo : 'Contract Description'
    ContractDesc : String(35);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Vendor No'
    Vendor : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    Mastercontno : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    serviceRefInd : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agreement Type'
    @sap.quickinfo : 'IGMS Contract Type'
    Contyp : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    ContractNo : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Service Contract Sale'
    @sap.heading : ''
    ServiceCont : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    SalesRefno : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purch. Doc. Category'
    @sap.quickinfo : 'Purchasing Document Category'
    DocumentCategory : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Order Type'
    @sap.quickinfo : 'Order Type (Purchasing)'
    DocumentType : String(4);
    ServiceContInd : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Purchase Contract'
    @sap.quickinfo : 'Purchasing Contract Header'
    ServiceContract : String(10);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Formula Repository IDs'
  entity xGMSxformrepvh {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Formula Repository ID'
    @sap.quickinfo : 'Formula repository ID'
    key FormulaRepositoryID : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Formula Description'
    @sap.quickinfo : 'Formula description'
    FormulaDescription : String(40);
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
    LinkDocType : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    ContractNo : String(10);
    ContDocType : String(4);
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
  @sap.label : 'Link CT'
  entity xGMSxLINKCTVIEW {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Link Contract'
    key Linkcont : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Indicator'
    key Ctindicator : String(3) not null;
    key KeyId : String(20) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    ContractNo : String(10);
    AsTableName : String(20);
    @sap.unit : 'Uom'
    @sap.label : 'Quantity'
    Quantity : Decimal(13, 3);
    @sap.label : 'UOM'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.label : 'Deletion Indicator'
    Deleteind : Boolean;
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
  @sap.label : 'Location to source distance mapping'
  entity xGMSxLOC_SOURCE_MAP {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Location'
    @sap.quickinfo : 'Cutomer Location'
    key Clocation : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Source'
    key Source : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Withdraw PT'
    @sap.quickinfo : 'Withdraw Point'
    key Withdrawpt : String(50) not null;
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    Clocationname : String(60);
    @sap.label : 'Distance'
    Distance : Decimal(8, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Entitle Tariff Zone'
    @sap.quickinfo : 'Entitlement Tariff Zone'
    EntitlementTariffZone : String(4);
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
    @sap.label : 'Customer / Supplier'
    @sap.quickinfo : 'Contract Customer / Supplier'
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
    to_contcf : Association to many xGMSxMCONT_CFV {  };
    to_contcl : Association to many xGMSxMCONTRACTCLAUSE {  };
    to_contclqty : Association to many xGMSxMCONTRACTCL_QTY {  };
    to_contpur : Association to many xGMSxCONTPURCHASE {  };
    to_contsal : Association to many xGMSxCONTSALE {  };
    to_history : Association to many xGMSxCONTHISTORY {  };
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
  @sap.label : 'Contract Material Grp 1'
  entity xGMSxMATGRP1 {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material Group 1'
    key MaterialGrp1 : String(3) not null;
    @sap.label : 'Description'
    Description : String(40);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract Material Grp 2'
  entity xGMSxMATGRP2 {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material Group 2'
    key MaterialGrp2 : String(3) not null;
    @sap.label : 'Description'
    Description : String(40);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract Material Grp 3'
  entity xGMSxMATGRP3 {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material Group 3'
    key MaterialGrp3 : String(3) not null;
    @sap.label : 'Description'
    Description : String(40);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract Material Grp 4'
  entity xGMSxMATGRP4 {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material Group 4'
    key MaterialGrp4 : String(3) not null;
    @sap.label : 'Description'
    Description : String(40);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Contract Material Grp 5'
  entity xGMSxMATGRP5 {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material Group 5'
    key MaterialGrp5 : String(3) not null;
    @sap.label : 'Description'
    Description : String(40);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch storage location basis of material'
  entity xGMSxMAT_LOC {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    key material : String(40) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    locid : String(10);
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
  @sap.label : 'Master Contract Dynamic field'
  entity xGMSxMCONT_CFV {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Master ContractRefNo'
    @sap.quickinfo : 'Master Agreement Ref No'
    key Refmastercontno : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Field'
    @sap.quickinfo : 'Contract Field ID'
    key ContractFldId : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Version'
    key Versn : String(3) not null;
    key KeyId : String(20) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Contract Field'
    ContractField : String(40);
    AsTableName : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    Mastercontno : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Field Level'
    FieldLevel : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Field Value'
    @sap.quickinfo : 'Contract Field Value'
    FieldValue : String(50);
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
  @sap.label : 'Projection for Planned Maintanense'
  entity xGMSxPlannedMaint {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key RefNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer Number'
    key Customer : String(10) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid From'
    key ValidFrom : Date not null;
    @sap.display.format : 'Date'
    @sap.label : 'Valid To'
    key ValidTo : Date not null;
    @sap.display.format : 'NonNegative'
    key Versn : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Order Type'
    @sap.quickinfo : 'Order Type (Purchasing)'
    DocumentType : String(4);
    @sap.unit : 'Uom'
    @sap.label : 'Planned Dcq'
    Dcq : Decimal(13, 3);
    @sap.label : 'UOM'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Uom : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'AR Indicator'
    Status : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reason Code'
    ReasonCode : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Clause Remark'
    Remarks : String(50);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Receiving Point'
  entity xGMSxRECEIVINGPT {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key LocationId : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Get Customer for Redelivery Point'
  entity xGMSxRedelivery_Cust {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key LocationId : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer Number'
    Customer : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Name'
    @sap.quickinfo : 'Customer Full Name'
    CustomerName : String(220);
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
    @sap.label : 'Text'
    @sap.quickinfo : 'Text for translation'
    Reason : String(200);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Fetch sales area with document'
  entity xGMSxSALESAREADOC {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Organization'
    key SalesOrg : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Distribution Channel'
    key DistributionCh : String(2) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Division'
    key Division : String(2) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Document Type'
    key DocumentType : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Screen sequence grp.'
    @sap.quickinfo : 'Screen sequence group for document header & item'
    Kopgr : String(4);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Source Code view'
  entity xGMSxSOURCECDVIEW {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Entity : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Source Code'
    Code : String(5);
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
  @sap.content.version : '1'
  @sap.label : 'Fetch iGMS Suppliers List'
  entity xGMSxSUPPLIERS {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Account Number of Supplier'
    key Customer : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer Number'
    key CorrespondingCustomer : String(10) not null;
    @sap.label : 'Name of Supplier'
    CustomerName : String(80);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier Name'
    @sap.quickinfo : 'Supplier Full Name'
    CustomerFullName : String(220);
    @sap.label : 'Name of Customer'
    CorrespondingCustomerName : String(80);
    @sap.label : 'E-Mail Address'
    CustomerEmail : String(241);
    to_vendpurchorg : Association to many xGMSxVendPurchOrgCo {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Tariff Sub Path'
  entity xGMSxTARIFF_SUBPATH {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference Number'
    key Refno : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Sub Item'
    @sap.quickinfo : 'SUB Item'
    key Subitem : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key FromPoint : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key ToPoint : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'PNGRB Tariff Path'
    @sap.quickinfo : 'iGMS: PNGRB Tariff Path'
    key Subpath : String(130) not null;
    key KeyId : String(26) not null;
    AsTableName : String(20);
    @sap.label : 'Distance'
    Distance : Decimal(8, 3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Entitle Tariff Zone'
    @sap.quickinfo : 'Entitlement Tariff Zone'
    EnTariffZone : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    TransportSystm : String(10);
    @sap.label : 'Indicator'
    Own : Boolean;
    @sap.label : 'Third Party Ent. Ind'
    @sap.quickinfo : 'Third Party Entitlement Indicator'
    ThrdPrtyEntInd : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'DocumentNo'
    @sap.quickinfo : 'Document Number'
    ContractNo : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Withdraw PT'
    @sap.quickinfo : 'Withdraw Point'
    Withdrawpt : String(50);
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
  @sap.label : 'Vendor, POrg, and Comp Code'
  entity xGMSxVendPurchOrgCo {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Supplier'
    @sap.quickinfo : 'Supplier''s Account Number'
    @sap.value.list : 'standard'
    key Supplier : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.text : 'PurchasingOrganizationName'
    @sap.label : 'Purch. Organization'
    @sap.quickinfo : 'Purchasing Organization'
    key PurchasingOrganization : String(4) not null;
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
    @sap.display.format : 'UpperCase'
    @sap.label : 'Company Code'
    CompanyCode : String(4);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Customer Company'
  entity A_CustomerCompany {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer Number'
    key Customer : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Company Code'
    key CompanyCode : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Tolerance Group'
    @sap.quickinfo : 'Tolerance Group for Business Partner/G/L Account'
    APARToleranceGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Account at customer'
    @sap.quickinfo : 'Our account number at customer'
    AccountByCustomer : String(12);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Clerk Abbrev.'
    @sap.quickinfo : 'Accounting Clerk Abbreviation'
    AccountingClerk : String(2);
    @sap.label : 'Acctg clerk''s fax'
    @sap.quickinfo : 'Accounting clerk''s fax number at the customer/vendor'
    AccountingClerkFaxNumber : String(31);
    @sap.label : 'Clrk''s internet add.'
    @sap.quickinfo : 'Internet address of partner company clerk'
    AccountingClerkInternetAddress : String(130);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Acct.clerks tel.no.'
    @sap.quickinfo : 'Accounting clerk''s telephone number at business partner'
    AccountingClerkPhoneNumber : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Alternative payer'
    @sap.quickinfo : 'Account number of an alternative payer'
    AlternativePayerAccount : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Authorization'
    @sap.quickinfo : 'Authorization Group'
    AuthorizationGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Coll.Invoice Variant'
    @sap.quickinfo : 'Collective Invoice Variant'
    CollectiveInvoiceVariant : String(1);
    @sap.label : 'Account Memo'
    @sap.quickinfo : 'Memo'
    CustomerAccountNote : String(30);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Head Office'
    @sap.quickinfo : 'Head Office Account Number (in branch accounts)'
    CustomerHeadOffice : String(10);
    @sap.label : 'Clearing with vendor'
    @sap.quickinfo : 'Indicator: Clearing between customer and vendor ?'
    CustomerSupplierClearingIsUsed : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'House Bank'
    @sap.quickinfo : 'Short Key for a House Bank'
    HouseBank : String(5);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Interest Indicator'
    InterestCalculationCode : String(2);
    @sap.display.format : 'Date'
    @sap.label : 'Last Key Date'
    @sap.quickinfo : 'Key Date of Last Interest Calculation'
    InterestCalculationDate : Date;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Int.Calc.Freq.'
    @sap.quickinfo : 'Interest Calculation Frequency in Months'
    IntrstCalcFrequencyInMonths : String(2);
    @sap.label : 'Local Processing'
    @sap.quickinfo : 'Indicator: Local Processing?'
    IsToBeLocallyProcessed : Boolean;
    @sap.label : 'Individual Payment'
    @sap.quickinfo : 'Indicator: Pay All Items Separately?'
    ItemIsToBePaidSeparately : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sort key'
    @sap.quickinfo : 'Key for sorting according to assignment numbers'
    LayoutSortingRule : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Payment Block'
    @sap.quickinfo : 'Block Key for Payment'
    PaymentBlockingReason : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Payment Methods'
    @sap.quickinfo : 'List of Respected Payment Methods'
    PaymentMethodsList : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Payment Reason'
    PaymentReason : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Terms of Payment'
    @sap.quickinfo : 'Terms of Payment Key'
    PaymentTerms : String(4);
    @sap.label : 'Pmnt advice by EDI'
    @sap.quickinfo : 'Indicator: Send Payment Advices by EDI'
    PaytAdviceIsSentbyEDI : Boolean;
    @sap.label : 'Co.code post.block'
    @sap.quickinfo : 'Posting block for company code'
    PhysicalInventoryBlockInd : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reconciliation acct'
    @sap.quickinfo : 'Reconciliation Account in General Ledger'
    ReconciliationAccount : String(10);
    @sap.label : 'Record pmnt history'
    @sap.quickinfo : 'Indicator: Record Payment History ?'
    RecordPaymentHistoryIndicator : Boolean;
    @sap.label : 'User at customer'
    UserAtCustomer : String(15);
    @sap.label : 'Co.Cde Deletion Flag'
    @sap.quickinfo : 'Deletion Flag for Master Record (Company Code Level)'
    DeletionIndicator : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Planning Group'
    CashPlanningGroup : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Known/Negotiat.Leave'
    @sap.quickinfo : 'Short Key for Known/Negotiated Leave'
    KnownOrNegotiatedLeave : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Value Adjustment'
    @sap.quickinfo : 'Value Adjustment Key'
    ValueAdjustmentKey : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Account group'
    @sap.quickinfo : 'Customer Account Group'
    CustomerAccountGroup : String(4);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Sales Area'
  entity A_CustomerSalesArea {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer Number'
    key Customer : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Organization'
    key SalesOrganization : String(4) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Distribution Channel'
    key DistributionChannel : String(2) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Division'
    key Division : String(2) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Account at Customer'
    @sap.quickinfo : 'Shipper''s (Our) Account Number at the Customer or Vendor'
    AccountByCustomer : String(12);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Authorization Group'
    AuthorizationGroup : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'BBlock for SlsA'
    @sap.quickinfo : 'Billing block for customer (sales and distribution)'
    BillingIsBlockedForCustomer : String(2);
    @sap.label : 'Complete Delivery'
    @sap.quickinfo : 'Complete Delivery Defined for Each Sales Order'
    CompleteDeliveryIsDefined : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Credit Control Area'
    CreditControlArea : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Currency'
    @sap.semantics : 'currency-code'
    Currency : String(5);
    @sap.label : 'Settlement Mgmt.'
    @sap.quickinfo : 'Indicator: Relevant for Settlement Management'
    CustIsRlvtForSettlmtMgmt : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'ABC Classification'
    @sap.quickinfo : 'Customer classification (ABC analysis)'
    CustomerABCClassification : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Acct Assmt Grp Cust.'
    @sap.quickinfo : 'Account Assignment Group for Customer'
    CustomerAccountAssignmentGroup : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group'
    CustomerGroup : String(2);
    @sap.label : 'Rebate'
    @sap.quickinfo : 'Indicator: Customer Is Rebate-Relevant'
    CustomerIsRebateRelevant : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Terms of Payment'
    @sap.quickinfo : 'Terms of Payment Key'
    CustomerPaymentTerms : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Price Group'
    CustomerPriceGroup : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Cust.Pric.Procedure'
    @sap.quickinfo : 'Customer Classification for Pricing Procedure Determination'
    CustomerPricingProcedure : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'PP customer proced.'
    @sap.quickinfo : 'Customer procedure for product proposal'
    CustProdProposalProcedure : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'DelBlckSalesAr.'
    @sap.quickinfo : 'Customer delivery block (sales area)'
    DeliveryIsBlockedForCustomer : String(2);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Delivery Priority'
    DeliveryPriority : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Incoterms'
    @sap.quickinfo : 'Incoterms (Part 1)'
    IncotermsClassification : String(3);
    @sap.label : 'Incoterms Location 2'
    IncotermsLocation2 : String(70);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Incoterms Version'
    IncotermsVersion : String(4);
    @sap.label : 'Incoterms Location 1'
    IncotermsLocation1 : String(70);
    @sap.label : 'Location UUID'
    IncotermsSupChnLoc1AddlUUID : UUID;
    @sap.label : 'Location UUID'
    IncotermsSupChnLoc2AddlUUID : UUID;
    @sap.label : 'Location UUID'
    IncotermsSupChnDvtgLocAddlUUID : UUID;
    @sap.label : 'Del.ID SlsArea'
    @sap.quickinfo : 'Deletion flag for customer (sales level)'
    DeletionIndicator : Boolean;
    @sap.label : 'Incoterms (Part 2)'
    IncotermsTransferLocation : String(28);
    @sap.label : 'Price determination'
    @sap.quickinfo : 'Relevant for price determination ID'
    InspSbstHasNoTimeOrQuantity : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Invoicing Dates'
    @sap.quickinfo : 'Invoice Dates (Calendar Identification)'
    InvoiceDate : String(2);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Order Probability'
    @sap.quickinfo : 'Order Probability of the Item'
    ItemOrderProbabilityInPercent : String(3);
    @sap.label : 'Man. Invoice Maint.'
    @sap.quickinfo : 'Manual Invoice Maintenance'
    ManualInvoiceMaintIsRelevant : Boolean;
    @sap.label : 'Max.Part.Deliveries'
    @sap.quickinfo : 'Maximum Number of Partial Deliveries Allowed Per Item'
    MaxNmbrOfPartialDelivery : Decimal(1, 0);
    @sap.label : 'Order Combination'
    @sap.quickinfo : 'Order Combination Indicator'
    OrderCombinationIsAllowed : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ord.blk:sls ar.'
    @sap.quickinfo : 'Customer order block (sales area)'
    OrderIsBlockedForCustomer : String(2);
    @sap.label : 'Overdeliv. Tolerance'
    @sap.quickinfo : 'Overdelivery Tolerance'
    OverdelivTolrtdLmtRatioInPct : Decimal(3, 1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Part.dlv./item'
    @sap.quickinfo : 'Partial delivery at item level'
    PartialDeliveryIsAllowed : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Price List Type'
    PriceListType : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Unit of Measure Grp'
    @sap.quickinfo : 'Unit of Measure Group'
    ProductUnitGroup : String(4);
    @sap.label : 'POD timeframe'
    @sap.quickinfo : 'Timeframe for Confirmation of POD'
    ProofOfDeliveryTimeValue : Decimal(6, 2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Group'
    SalesGroup : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Item proposal'
    SalesItemProposal : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales Office'
    SalesOffice : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Shipping Conditions'
    ShippingCondition : String(2);
    @sap.label : 'Relevant for POD'
    @sap.quickinfo : 'Relevant for POD processing'
    SlsDocIsRlvtForProofOfDeliv : Boolean;
    @sap.label : 'Unlimited Tolerance'
    @sap.quickinfo : 'Unlimited Overdelivery Allowed'
    SlsUnlmtdOvrdelivIsAllwd : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Delivering Plant'
    @sap.quickinfo : 'Delivering Plant (Own or External)'
    SupplyingPlant : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sales District'
    SalesDistrict : String(6);
    @sap.label : 'Underdel. Tolerance'
    @sap.quickinfo : 'Underdelivery Tolerance'
    UnderdelivTolrtdLmtRatioInPct : Decimal(3, 1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Invoice List Sched.'
    @sap.quickinfo : 'Invoice List Schedule (calendar identification)'
    InvoiceListSchedule : String(2);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Exchange Rate Type'
    ExchangeRateType : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group 1'
    AdditionalCustomerGroup1 : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group 2'
    AdditionalCustomerGroup2 : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group 3'
    AdditionalCustomerGroup3 : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group 4'
    AdditionalCustomerGroup4 : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer Group 5'
    AdditionalCustomerGroup5 : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Paymt guarant. proc.'
    @sap.quickinfo : 'Customer payment guarantee procedure'
    PaymentGuaranteeProcedure : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Account group'
    @sap.quickinfo : 'Customer Account Group'
    CustomerAccountGroup : String(4);
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
  function AmendContract(
    @sap.label : 'Indicator'
    ContractInd : String(1),
    @sap.label : 'DocumentNo'
    ContractNo : String(10),
    @sap.label : 'Reference Number'
    Refno : String(10)
  ) returns MessageCollection;
};

