/* checksum : d02522fa11a5875936820494e7181906 */
@cds.external : true
@m.IsDefaultEntityContainer : 'true'
@sap.message.scope.supported : 'true'
@sap.supported.formats : 'atom json xlsx'
service GMSTICKET_API_SRV {
  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity CreateTicket {
    @sap.unicode : 'false'
    @sap.label : 'Save'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Save : Boolean not null;
    toTicketHeader : Association to many TicketHeaderSet {  };
    toTicketItems : Association to many TicketItemsSet {  };
    toReturn : Association to many returnSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity TicketHeaderSet {
    @sap.unicode : 'false'
    @sap.label : 'Item number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketItem : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ticket key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketKey : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ticket version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TicketVersion : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Ticket Purpose'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TicketPurpose : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Event number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EventNr : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Event type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Type : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Document type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocType : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Seq. number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EvSeq : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Document no.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocNumber : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Shipment item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Shitem : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Event status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Status : String(1);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Actualstartfrom : DateTime;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Actualstartto : DateTime;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Actualendfrom : DateTime;
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Actualendto : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Created by'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreName : String(12);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Creation : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Changed by'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChaName : String(12);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Modification : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Vehicle Seq. No'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    VehNr : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Seq.stage'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tsrfo : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Deletion ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Delind : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Update indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Updkz : String(1);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity TicketItemsSet {
    @sap.unicode : 'false'
    @sap.label : 'Ticket key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketKey : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketItem : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ticket version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TicketVersion : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Ticket Purpose'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TicketPurpose : String(1);
    @sap.unicode : 'false'
    @sap.label : 'External pos.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExtPosnr : String(6);
    @sap.unicode : 'false'
    @sap.label : 'Item status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Status : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Item sub-status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Substatus : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Sched.type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Sityp : String(2);
    @sap.unicode : 'false'
    @sap.label : 'Return code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tktsubrc : String(2);
    @sap.unicode : 'false'
    @sap.label : 'Mvmt.scenario'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Mvscenario : String(2);
    @sap.unicode : 'false'
    @sap.label : 'Nomination no.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Nomnr : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Nomination key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Nomtk : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Nom. key item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Nomit : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Loc.partner'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Receiver : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Location ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Locid : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Tank seq. no.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tanknr : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Vehicle Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vehicle : String(10);
    @sap.unicode : 'false'
    @sap.unit : 'Meins'
    @sap.label : 'SchedQty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Menge : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.unit : 'Meins'
    @sap.label : 'SchedQty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Grosquan : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Base Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Meins : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Matnr : String(40);
    @sap.unicode : 'false'
    @sap.label : 'Tankage partner'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tankage : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Loc.partner'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Supplier : String(10);
    @sap.unicode : 'false'
    @sap.label : 'ConsigneePartnr'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Consigne : String(10);
    @sap.unicode : 'false'
    @sap.unit : 'AgreedQtyUom'
    @sap.label : 'Agreed Qty.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    AgreedQty : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'LD Matrl. UOM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    AgreedQtyUom : String(3);
    @sap.unicode : 'false'
    @sap.unit : 'ShipQtyUom'
    @sap.label : 'Ship Qty.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ShipQty : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'LD Matrl. UOM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    ShipQtyUom : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Mat.Temperature'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Mttmp : Double;
    @sap.unicode : 'false'
    @sap.label : 'Mat.Temp.Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Mtteh : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Test Density'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OApiGrav : Double;
    @sap.unicode : 'false'
    @sap.label : 'Test Density'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ApiGrtD : Double;
    @sap.unicode : 'false'
    @sap.label : 'Test Temp.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tstmp : Double;
    @sap.unicode : 'false'
    @sap.label : 'Test Temp.Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Tsteh : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Test Density'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tdich : Double;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Created on'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Erdat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Created'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Erzeit : Time;
    @sap.unicode : 'false'
    @sap.label : 'Created by'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ernam : String(12);
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Changed On'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Aedat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Changed'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Aezeit : Time;
    @sap.unicode : 'false'
    @sap.label : 'Changed by'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Aenam : String(12);
    @sap.unicode : 'false'
    @sap.label : 'Blocking ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Bloind : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Deletion ind.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Delind : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Flag to Select Tkt'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tktselect : Boolean;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Posting Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Budat : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Close nomination itm'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CloseNomit : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Event date type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Eventtype : String(16);
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Event date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    EventDate : Timestamp;
    @sap.unicode : 'false'
    @sap.label : 'Gen. meter no.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Gmmnr : String(20);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OItmstm : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Met. event type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OMetev : String(2);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CItmstm : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Met. event type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CMetev : String(2);
    @sap.unicode : 'false'
    @sap.label : 'End reading'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Stoprdg : String(12);
    @sap.unicode : 'false'
    @sap.unit : 'StmUom'
    @sap.label : 'St.mt.Qty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StmQuantity : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Stm.Uom'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    StmUom : String(3);
    @sap.unicode : 'false'
    @sap.label : 'SOCSEG number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Socnr : String(20);
    @sap.unicode : 'false'
    @sap.unit : 'ODipReadUom'
    @sap.label : 'Open Dip'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ODipRead : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Length UoM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    ODipReadUom : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Dip timestamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OEtmstm : String(14);
    @sap.unicode : 'false'
    @sap.label : 'Event key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OSocev : String(2);
    @sap.unicode : 'false'
    @sap.unit : 'CDipReadUom'
    @sap.label : 'CloseDip'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CDipRead : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Length UoM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    CDipReadUom : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Dip timestamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CEtmstm : String(14);
    @sap.unicode : 'false'
    @sap.label : 'Event key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CSocev : String(2);
    @sap.unicode : 'false'
    @sap.unit : 'StopdipUom'
    @sap.label : 'Total height'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Stopdip : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Length UoM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    StopdipUom : String(3);
    @sap.unicode : 'false'
    @sap.unit : 'StpGauUom'
    @sap.label : 'Stp.GaugeQty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    StpGauQuan : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'Stp.Gau.Uom'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    StpGauUom : String(3);
    @sap.unicode : 'false'
    @sap.unit : 'GauUom'
    @sap.label : 'GaugeQty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GauQuantity : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'GaugeUoM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    GauUom : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Bulk shipm.type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Shtype : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Shipping Point'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Vstel : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Batch orig'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChargO : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WerksO : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Stor. Loc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LgortO : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Batch dest.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChargD : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WerksD : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Stor. Loc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LgortD : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Creation Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TimeStLoadSta : String(14);
    @sap.unicode : 'false'
    @sap.label : 'Creation Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TimeStLoadEnd : String(14);
    @sap.unicode : 'false'
    @sap.label : 'Creation Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TimeStLedOt : String(14);
    @sap.unicode : 'false'
    @sap.label : 'Batch create'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChargDCreate : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Posting time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    OibBltime : Time;
    @sap.unicode : 'false'
    @sap.label : 'Batch load'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChargL : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Ld. Btch create'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChargLCreate : Boolean;
    @sap.unicode : 'false'
    @sap.label : 'Shipment Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Shtyp : String(4);
    @sap.unicode : 'false'
    @sap.unit : 'UnitIPar'
    @sap.label : 'SchedParQty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MengePar : Decimal(13, 3);
    @sap.unicode : 'false'
    @sap.label : 'PUoM'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    UnitIPar : String(3);
    @sap.unicode : 'false'
    @sap.label : 'No. of Railcars'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Railcarqty : Integer;
    @sap.unicode : 'false'
    @sap.label : 'Extension Field'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DummyTktitmInclEewPs : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Loading plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Ldplt : String(4);
    @sap.unicode : 'false'
    @sap.label : 'In-Trans. Plant'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Itplt : String(4);
    @sap.unicode : 'false'
    @sap.label : 'In-Trans. SLoc'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Itstlc : String(4);
    @sap.unicode : 'false'
    @sap.label : 'In-Trans. Batch'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Itbtch : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Update indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Updkz : String(1);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity returnSet {
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
    Message : String(220);
    @sap.unicode : 'false'
    @sap.label : 'Log number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LogNo : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Message no.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LogMsgNo : String(6);
    @sap.unicode : 'false'
    @sap.label : 'Message Variable'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MessageV1 : String(50);
    @sap.unicode : 'false'
    @sap.label : 'Message Variable'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MessageV2 : String(50);
    @sap.unicode : 'false'
    @sap.label : 'Message Variable'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MessageV3 : String(50);
    @sap.unicode : 'false'
    @sap.label : 'Message Variable'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MessageV4 : String(50);
    @sap.unicode : 'false'
    @sap.label : 'Parameter Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Parameter : String(32);
    @sap.unicode : 'false'
    @sap.label : 'Parameter line'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Row : Integer;
    @sap.unicode : 'false'
    @sap.label : 'Field name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Field : String(30);
    @sap.unicode : 'false'
    @sap.label : 'Logical system'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    System : String(10);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity TktlogDetailHeadSet {
    @sap.unicode : 'false'
    @sap.label : 'UUID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ExecId : UUID not null;
    @odata.Type : 'Edm.DateTime'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CompletedAt : Timestamp;
    @odata.Type : 'Edm.DateTimeOffset'
    @odata.Precision : 7
    @sap.unicode : 'false'
    @sap.label : 'Time Stamp'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatedAt : Timestamp;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ErrorCount : Integer;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ErrorMessage : String(220);
    @sap.display.format : 'Date'
    @sap.unicode : 'false'
    @sap.label : 'Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExecDate : Date;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExecStatus : String(1);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExecTime : Time;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ExecUser : String(12);
    @sap.display.format : 'Date'
    @sap.unicode : 'false'
    @sap.label : 'Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Gasday : Date;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ICIndicator : String(1);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ParametersJson : String(2000);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ProcessingTime : Decimal(10, 3);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SuccessCount : Integer;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    SystemError : String(1);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TotalItems : Integer;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tsyst : String(10);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    WarningCount : Integer;
    to_logtkts : Association to many TktlogDetailSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ActualNomnrNomitSet {
    @sap.unicode : 'false'
    @sap.label : 'Nomination key'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomnr : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nom. key item'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomit : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ActualConpatSet {
    @sap.unicode : 'false'
    @sap.label : 'ContrPartner'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Conpat : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ActualInputSet {
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Gas Day'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Gasday : DateTime not null;
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
    @sap.label : 'Nomination key'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomtk : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nom. key item'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomit : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'ContrPartner'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Conpat : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sched.Material'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Matnr : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Process Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ProcessIndicator : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Scenario'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Scenario : String(50) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity TicketDetailSet {
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketItem : String(6) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketKey : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketVersion : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Purpose'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Purpose : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TicketNumber : String(20);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Nomtk : String(20);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Nomit : String(10);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ProcessStatus : String(1);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MessageSummary : String(255);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    HasDocs : String(1);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    HasErrors : String(1);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Ticket Created Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatedDate : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Created Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatedTime : Time;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Created By'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatedBy : String(12);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Ticket Changed Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChangedDate : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Changed Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChangedTime : Time;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Changed By'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChangedBy : String(12);
    TO_ERRLOG : Association to many ErrorLogSet {  };
    TO_DOCFLOW : Association to many DocFlowSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity TktlogDetailSet {
    @sap.unicode : 'false'
    @sap.label : 'UUID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ExecId : UUID not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Logitm : String(4) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomit : String(10) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomtk : String(20) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketItem : String(6) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketKey : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketVersion : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Purpose'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Purpose : String(1) not null;
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    HasDocs : String(1);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    HasErrors : String(1);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MessageSummary : String(255);
    @sap.unicode : 'false'
    @sap.label : 'Ticket Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TicketNumber : String(20);
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ProcessStatus : String(1);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Ticket Created Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatedDate : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Created Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatedTime : Time;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Created By'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    CreatedBy : String(12);
    @odata.Type : 'Edm.DateTime'
    @sap.unicode : 'false'
    @sap.label : 'Ticket Changed Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChangedDate : DateTime;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Changed Time'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChangedTime : Time;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Changed By'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ChangedBy : String(12);
    TO_DOCFLOW : Association to many DocFlowSet {  };
    TO_ERRLOG : Association to many ErrorLogSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ErrorLogSet {
    @sap.unicode : 'false'
    @sap.label : 'Ticket key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketKey : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketItem : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketVersion : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Purpose'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Purpose : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'SeqNo'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key SequenceNo : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TicketNumber : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Nomination key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Nomtk : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Nom. key item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Nomit : String(10);
    @sap.unicode : 'false'
    @sap.label : 'MV Scenario'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MvScenario : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Return Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Return : String(4);
    @sap.unicode : 'false'
    @sap.label : 'SchedQty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RefDoc : String(10);
    @sap.unicode : 'false'
    @sap.label : 'MatYear'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MatYear : String(4);
    @sap.unicode : 'false'
    @sap.label : 'RefDocItem'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RefDocItem : String(6);
    @sap.unicode : 'false'
    @sap.label : 'Doc Category'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocCategory : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Document Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocDescription : String(100);
    @sap.display.format : 'Date'
    @sap.unicode : 'false'
    @sap.label : 'TSW Date'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TSWDate : Date;
    @sap.unicode : 'false'
    @sap.label : 'Message Id'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MsgId : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Message Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MsgTyp : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Message Status'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MsgStatus : String(32);
    @sap.unicode : 'false'
    @sap.label : 'Message No'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MsgNo : String(3);
    @sap.unicode : 'false'
    @sap.label : 'Rev Doc'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RevDoc : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Message Text'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ErrorDescription : String(255);
    @sap.unicode : 'false'
    @sap.label : 'Source'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Source : String(50);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity DocFlowSet {
    @sap.unicode : 'false'
    @sap.label : 'Ticket key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketKey : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketItem : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketVersion : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Purpose'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Purpose : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'SeqNo'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key SequenceNo : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ticket Number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TicketNumber : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Nomination key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Nomtk : String(20);
    @sap.unicode : 'false'
    @sap.label : 'Nom. key item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Nomit : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Return Code'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Return : String(4);
    @sap.unicode : 'false'
    @sap.label : 'SchedQty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RefDoc : String(10);
    @sap.unicode : 'false'
    @sap.label : 'MatYear'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    MatYear : String(4);
    @sap.unicode : 'false'
    @sap.label : 'RefDocItem'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RefDocItem : String(6);
    @sap.unicode : 'false'
    @sap.label : 'Doc Category'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocCategory : String(4);
    @sap.unicode : 'false'
    @sap.label : 'Rev Doc'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    RevDoc : String(1);
    @sap.unicode : 'false'
    @sap.label : 'Document Description'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocDescription : String(100);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ActualDateSet {
    @sap.display.format : 'Date'
    @sap.unicode : 'false'
    @sap.label : 'SchedDate'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Date : Date not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ActualErrorSet {
    @sap.unicode : 'false'
    @sap.label : 'Ticket key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketKey : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketItem : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nomination key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomtk : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nom. key item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomit : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Locid : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'SchedQty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Menge : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Base Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    key Meins : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Msgty : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Text'
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
  entity ActualLocidSet {
    @sap.unicode : 'false'
    @sap.label : 'Location ID'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Locid : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ActualMatnrSet {
    @sap.unicode : 'false'
    @sap.label : 'Sched.Material'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Matnr : String(40) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ActualNomitSet {
    @sap.unicode : 'false'
    @sap.label : 'Nom. key item'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomit : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ActualNomnrSet {
    @sap.unicode : 'false'
    @sap.label : 'Nomination no.'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomnr : String(20) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ActualSuccessSet {
    @sap.unicode : 'false'
    @sap.label : 'Ticket key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketKey : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketItem : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nomination key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomtk : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nom. key item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomit : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Locid : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'SchedQty'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Menge : Decimal(13, 3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Base Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    key Meins : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Msgty : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Message Text'
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
  entity ActualSuccessFlowSet {
    @sap.unicode : 'false'
    @sap.label : 'Ticket key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketKey : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Item number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key TicketItem : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Sequence number'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key SeqNmbr : String(5) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ref. doc.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Docnr : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Mat. Doc. Year'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Mjahr : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Ref.Doc.Item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Posnr : String(6) not null;
    @sap.unicode : 'false'
    @sap.label : 'Document Cat.'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocCat : String(4) not null;
    @sap.unicode : 'false'
    @sap.label : 'Short text'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    DocCatText : String(60) not null;
    @sap.unicode : 'false'
    @sap.label : 'RevDoc'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Revdoc : Boolean not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ActualTsystSet {
    @sap.unicode : 'false'
    @sap.label : 'Trans system'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Tsyst : String(10) not null;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ActualizeTicket {
    @sap.unicode : 'false'
    @sap.label : 'Save'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Actualize : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'ActualizeIC'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key ActualizeIC : Boolean not null;
    @sap.unicode : 'false'
    @sap.label : 'Process Indicator'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    ProcessIndicator : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Scenario'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Scenario : String(50) not null;
    Nomnr : Association to many ActualNomnrSet {  };
    Tsyst : Association to many ActualTsystSet {  };
    Nomit : Association to many ActualNomitSet {  };
    Locid : Association to many ActualLocidSet {  };
    Matnr : Association to many ActualMatnrSet {  };
    Date : Association to many ActualDateSet {  };
    to_Errors : Association to many ActualErrorSet {  };
    to_Success : Association to many ActualSuccessSet {  };
    to_DocFlow : Association to many ActualSuccessFlowSet {  };
    Inputs : Association to many ActualInputSet {  };
    Conpat : Association to many ActualConpatSet {  };
    NomnrNomit : Association to many ActualNomnrNomitSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity SaveTicket {
    @sap.unicode : 'false'
    @sap.label : 'Indicator'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Save : Boolean not null;
    to_return : Association to many returnSet {  };
    toTicketItems : Association to many TicketItemsSet {  };
    toCVParams : Association to many CVParamsSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity CVParamsSet {
    @sap.unicode : 'false'
    @sap.label : 'Nomination key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomtk : String(20) not null;
    @sap.unicode : 'false'
    @sap.label : 'Nom. key item'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Nomit : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Average GCV'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    GCV : Double;
    @sap.unicode : 'false'
    @sap.label : 'Average NCV'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    NCV : Double;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Flow For Nom Ticket'
  entity xGMSxDOCFLOW {
    @sap.display.format : 'UpperCase'
    @sap.label : 'SD Document'
    @sap.quickinfo : 'Sales and Distribution Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Subsequent Document'
    @sap.quickinfo : 'Subsequent Sales and Distribution Document'
    OrderNumber : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Subsequent Document'
    @sap.quickinfo : 'Subsequent Sales and Distribution Document'
    DeliveryNumber : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket key'
    @sap.quickinfo : 'OIL-TSW: Ticket key'
    TicketKey : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Subsequent Document'
    @sap.quickinfo : 'Subsequent Sales and Distribution Document'
    GMNumber : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Document'
    BillingNumber : String(10);
    @sap.display.format : 'Date'
    @sap.label : 'Billing Date'
    BillingDate : Date;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Sold-to Party'
    Customer : String(10);
    @sap.label : 'Name of Customer'
    CustomerName : String(80);
    @sap.label : 'Invoiced Quantity'
    @sap.quickinfo : 'Actual Invoiced Quantity'
    Quantity : Decimal(13, 3);
    @sap.label : 'Sales Unit'
    @sap.semantics : 'unit-of-measure'
    UOM : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    Material : String(40);
    @sap.label : 'Material Description'
    MaterialName : String(40);
    @sap.label : 'Net Weight'
    price : Decimal(15, 3);
    @sap.display.format : 'Date'
    @sap.label : 'Pricing Date'
    @sap.quickinfo : 'Date for Pricing and Exchange Rate'
    pricing_dt : Date;
    @sap.display.format : 'Date'
    BillDueDate : Date;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Ticketing For Nomination'
  entity xGMSxNOMTICKET {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document No'
    @sap.quickinfo : 'Document Number'
    key ContractNo : String(10) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Gas Day'
    @sap.quickinfo : 'Gas Day Date'
    key Gasday : Date not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Document Item'
    key Item : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket key'
    @sap.quickinfo : 'OIL-TSW: Ticket key'
    key TicketKey : String(20) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Item number'
    @sap.quickinfo : 'OIL-TSW: Ticket item number'
    key TicketItem : String(6) not null;
    @sap.display.format : 'NonNegative'
    Versn : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Maste Agrmt. No'
    @sap.quickinfo : 'Master Agreement No'
    Mastercontno : String(10);
    @sap.label : 'Name of Supplier'
    CustomerName : String(80);
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
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer No'
    Customer : String(10);
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
    @sap.label : 'Allocated Qty'
    @sap.quickinfo : 'Allocated Quantity'
    AllocatedQty : Decimal(13, 3);
    @sap.label : 'Allocated qty UOM'
    @sap.quickinfo : 'Unit of Measure for Allocated Quantity Field'
    @sap.semantics : 'unit-of-measure'
    AllocatedUom : String(3);
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Ticket Logs'
  entity xGMSxTICKET_LOGS {
    @sap.display.format : 'UpperCase'
    @sap.label : 'UUID'
    @sap.quickinfo : '16-byte UID in 32 chars (hexadecimal)'
    key ExecId : UUID not null;
    @sap.display.format : 'Date'
    ExecDate : Date;
    ExecTime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'User Name'
    ExecUser : String(12);
    ExecStatus : String(1);
    @sap.display.format : 'Date'
    @sap.label : 'TSW: Date'
    Gasday : Date;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transport system'
    Tsyst : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Int. Consump. Flag'
    @sap.quickinfo : 'Internal Consumption Flag'
    ICIndicator : String(1);
    ParametersJson : String(2000);
    TotalItems : Integer;
    SuccessCount : Integer;
    ErrorCount : Integer;
    WarningCount : Integer;
    SystemError : String(1);
    ErrorMessage : String(220);
    @odata.Type : 'Edm.DateTimeOffset'
    @odata.Precision : 7
    @sap.label : 'Time Stamp'
    @sap.quickinfo : 'UTC Time Stamp in Long Form (YYYYMMDDhhmmssmmmuuun)'
    CreatedAt : Timestamp;
    @odata.Type : 'Edm.DateTimeOffset'
    @odata.Precision : 7
    @sap.label : 'Time Stamp'
    @sap.quickinfo : 'UTC Time Stamp in Long Form (YYYYMMDDhhmmssmmmuuun)'
    CompletedAt : Timestamp;
    ProcessingTime : Decimal(10, 3);
    to_logtkts : Association to many xGMSxTKT_EXEC_TICKETS {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'DATA For Ticket'
  entity xGMSxTKTDATA {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket key'
    @sap.quickinfo : 'OIL-TSW: Ticket key'
    key TicketKey : String(20) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Item number'
    @sap.quickinfo : 'OIL-TSW: Ticket item number'
    key TicketItem : String(6) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Ticket version'
    @sap.quickinfo : 'OIL-TSW: Ticket version'
    key TicketVersion : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.text : 'TicketPurposeDescription'
    @sap.label : 'Ticket Purpose'
    @sap.quickinfo : 'OIL-TSW: Ticket Purpose'
    key TicketPurpose : String(1) not null;
    @sap.label : 'Short Description'
    @sap.quickinfo : 'Short Text for Fixed Values'
    TicketPurposeDescription : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination number'
    NominationNumber : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination key'
    @sap.quickinfo : 'Nomination (technical) Key'
    NominationKey : String(20);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Nomination key item'
    @sap.quickinfo : 'Nomination Key Item'
    NominationItem : String(10);
    @sap.display.format : 'UpperCase'
    @sap.text : 'LocationName'
    @sap.label : 'Location ID'
    LocationId : String(10);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    LocationName : String(60);
    @sap.label : 'Scheduled qty'
    Quantity : Decimal(13, 3);
    @sap.label : 'Base Unit of Measure'
    @sap.semantics : 'unit-of-measure'
    UOM : String(3);
    @sap.display.format : 'UpperCase'
    @sap.text : 'MaterialName'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    Material : String(40);
    @sap.label : 'Material Description'
    MaterialName : String(40);
    @sap.display.format : 'Date'
    @sap.label : 'Created On'
    @sap.quickinfo : 'Record Creation Date'
    CreatedDate : Date;
    @sap.label : 'Created'
    @sap.quickinfo : 'Time of creation'
    CreatedTime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    @sap.quickinfo : 'Name of Person Responsible for Creating the Object'
    CreatedBy : String(12);
    @sap.display.format : 'Date'
    @sap.label : 'Changed On'
    @sap.quickinfo : 'Last Changed On'
    ChangedDate : Date;
    @sap.label : 'Changed'
    @sap.quickinfo : 'Time of day the record was changed'
    ChangedTime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    @sap.quickinfo : 'Name of Person Who Changed Object'
    ChangedBy : String(12);
    @sap.label : 'Blocking Ind.'
    @sap.quickinfo : 'Blocking indicator'
    BlockingIndicator : Boolean;
    @sap.label : 'Deletion indicator'
    DeletionIndicator : Boolean;
    @sap.display.format : 'Date'
    @sap.label : 'Posting Date'
    @sap.quickinfo : 'Posting Date in the Document'
    DocumentDate : Date;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Document'
    BillingNumber : String(10);
    @sap.display.format : 'Date'
    @sap.label : 'Billing Date'
    BillingDate : Date;
    to_bill : Association to xGMSxDOCFLOW {  };
    to_flow : Association to many xGMSxTKTDETAILS02 {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Nomination Ticket Details (Doc Flow)'
  entity xGMSxTKTDETAILS02 {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket key'
    @sap.quickinfo : 'OIL-TSW: Ticket key'
    key TicketKey : String(20) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Item number'
    @sap.quickinfo : 'OIL-TSW: Ticket item number'
    key TicketItem : String(6) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Ticket version'
    @sap.quickinfo : 'OIL-TSW: Ticket version'
    key TicketVersion : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket Purpose'
    @sap.quickinfo : 'OIL-TSW: Ticket Purpose'
    key TicketPurpose : String(1) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Sequence number'
    @sap.quickinfo : 'TSW: Sequence number'
    key SeqNmbr : String(5) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Transaction Code'
    TransactionCode : String(20);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Return code'
    Returncode : String(4);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference document'
    @sap.quickinfo : 'Nomination Reference Document'
    DocumentNumber : String(10);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Material Doc. Year'
    @sap.quickinfo : 'Material Document Year'
    DocumentYear : String(4);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Reference Doc. Item'
    @sap.quickinfo : 'Nomination Reference Document Item'
    ItemNo : String(6);
    @sap.label : 'SD Document Category'
    DocumentCategory : String(4);
    @sap.label : 'SD Document Category Description'
    DocumentCategoryText : String(60);
    @sap.label : 'RevDoc'
    @sap.quickinfo : 'Indicator ''Reversal Document'''
    ReversalDocumentIndicator : Boolean;
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Nomination Ticket Details'
  entity xGMSxTKTDETAILS03 {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket key'
    @sap.quickinfo : 'OIL-TSW: Ticket key'
    key TicketKey : String(20) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Item number'
    @sap.quickinfo : 'OIL-TSW: Ticket item number'
    key TicketItem : String(6) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Ticket version'
    @sap.quickinfo : 'OIL-TSW: Ticket version'
    key TicketVersion : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket Purpose'
    @sap.quickinfo : 'OIL-TSW: Ticket Purpose'
    key TicketPurpose : String(1) not null;
    @sap.label : 'Short Description'
    @sap.quickinfo : 'Short Text for Fixed Values'
    TicketPurposeDescription : String(60);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination number'
    NominationNumber : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination key'
    @sap.quickinfo : 'Nomination (technical) Key'
    NominationKey : String(20);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Nomination key item'
    @sap.quickinfo : 'Nomination Key Item'
    NominationItem : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    LocationId : String(10);
    @sap.label : 'Location name'
    @sap.quickinfo : 'Location name (used by system owner)'
    LocationName : String(60);
    @sap.label : 'Scheduled qty'
    Quantity : Decimal(13, 3);
    @sap.label : 'Base Unit of Measure'
    @sap.semantics : 'unit-of-measure'
    UOM : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Material'
    @sap.quickinfo : 'Material Number'
    Material : String(40);
    @sap.label : 'Material Description'
    MaterialName : String(40);
    @sap.display.format : 'Date'
    @sap.label : 'Created On'
    @sap.quickinfo : 'Record Creation Date'
    CreatedDate : Date;
    @sap.label : 'Created'
    @sap.quickinfo : 'Time of creation'
    CreatedTime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Created By'
    @sap.quickinfo : 'Name of Person Responsible for Creating the Object'
    CreatedBy : String(12);
    @sap.display.format : 'Date'
    @sap.label : 'Changed On'
    @sap.quickinfo : 'Last Changed On'
    ChangedDate : Date;
    @sap.label : 'Changed'
    @sap.quickinfo : 'Time of day the record was changed'
    ChangedTime : Time;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Changed By'
    @sap.quickinfo : 'Name of Person Who Changed Object'
    ChangedBy : String(12);
    @sap.label : 'Blocking Ind.'
    @sap.quickinfo : 'Blocking indicator'
    BlockingIndicator : Boolean;
    @sap.label : 'Deletion indicator'
    DeletionIndicator : Boolean;
    @sap.display.format : 'Date'
    @sap.label : 'Posting Date'
    @sap.quickinfo : 'Posting Date in the Document'
    DocumentDate : Date;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Billing Document'
    BillingNumber : String(10);
    @sap.display.format : 'Date'
    @sap.label : 'Billing Date'
    BillingDate : Date;
    ScheduledQuantity : Decimal(13, 3);
    @sap.label : 'SchedUoM'
    @sap.quickinfo : 'Scheduled UoM'
    @sap.semantics : 'unit-of-measure'
    ScheduledQuantityUOM : String(3);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer No'
    Customer : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document No'
    @sap.quickinfo : 'Document Number'
    ContractNo : String(10);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Document Type'
    DocumentType : String(4);
    to_flow : Association to many xGMSxTKTDETAILS02 {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'iGMS - Ticket Execution Tickets Log'
  entity xGMSxTKT_EXEC_TICKETS {
    @sap.display.format : 'UpperCase'
    @sap.label : 'UUID'
    @sap.quickinfo : '16-byte UID in 32 chars (hexadecimal)'
    key ExecId : UUID not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket key'
    @sap.quickinfo : 'OIL-TSW: Ticket key'
    key TicketKey : String(20) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Item number'
    @sap.quickinfo : 'OIL-TSW: Ticket item number'
    key TicketItem : String(6) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination key'
    @sap.quickinfo : 'Nomination (technical) Key'
    key Nomtk : String(20) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Nomination key item'
    @sap.quickinfo : 'Nomination Key Item'
    key Nomit : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Counter'
    @sap.quickinfo : 'Count parameters'
    key Logitm : String(4) not null;
    ProcessStatus : String(1);
    HasErrors : String(1);
    HasDocs : String(1);
    MessageSummary : String(255);
    to_docflow : Association to many xGMSxTKTDETAILS02 {  };
    to_errlog : Association to many I_TicketErrorLog {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.content.version : '1'
  @sap.label : 'Nomination Ticket Error Log'
  entity I_TicketErrorLog {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket key'
    @sap.quickinfo : 'OIL-TSW: Ticket key'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    key NominationTicketKey : String(20) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Item number'
    @sap.quickinfo : 'OIL-TSW: Ticket item number'
    key NominationTicketItem : String(6) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Ticket version'
    @sap.quickinfo : 'OIL-TSW: Ticket version'
    key NominationTicketVersion : String(3) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket Purpose'
    @sap.quickinfo : 'OIL-TSW: Ticket Purpose'
    key NominationTicketPurpose : String(1) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Sequence number'
    @sap.quickinfo : 'TSW: Sequence number'
    key TicketSequenceNumber : String(5) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Reference Doc. Item'
    @sap.quickinfo : 'Nomination Reference Document Item'
    SourceDocumentItem : String(6);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination number'
    NominationExtNumber : String(20);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Reference document'
    @sap.quickinfo : 'Nomination Reference Document'
    NominationReferenceDocument : String(10);
    TicketHasError : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Message Type'
    TicketMessageType : String(1);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket external no.'
    @sap.quickinfo : 'OIL-TSW: External ticket number'
    TicketNumber : String(20);
    SystemMessageText : String(200);
    @sap.display.format : 'UpperCase'
    @sap.label : 'Nomination key'
    @sap.quickinfo : 'Nomination (technical) Key'
    NominationDoc : String(20);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Nomination key item'
    @sap.quickinfo : 'Nomination Key Item'
    NominationDocItem : String(10);
    @sap.label : 'Flag to Select Nom'
    @sap.quickinfo : 'Flag to Set Nomination Selectable'
    NominationDocIsBlocked : Boolean;
    @sap.label : 'Flag to Select Tkt'
    @sap.quickinfo : 'Flag to Set Tickets Selectable'
    NominationTicketIsBlocked : Boolean;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Ticket Type'
    @sap.quickinfo : 'OIL-TSW: Ticket type'
    NominationTicketType : String(3);
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    DocumentCategoryText : String(60);
    @sap.label : 'SD Document Category'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    SDDocumentCategoryName : String(4);
    @sap.display.format : 'NonNegative'
    @sap.label : 'Material Doc. Year'
    @sap.quickinfo : 'Material Document Year'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    MaterialDocumentYear : String(4);
  };
};

