/* checksum : 56756e95ffb1dc61f3229306b2803a68 */
@cds.external : true
@m.IsDefaultEntityContainer : 'true'
@sap.message.scope.supported : 'true'
@sap.supported.formats : 'atom json xlsx'
service GMSSCADAAPI_SRV {
  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity ScadaUploadSet {
    @sap.unicode : 'false'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key scadaupload : String(1) not null;
    to_scadaitems : Association to many ScadaFieldSet {  };
  };

  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity ScadaFieldSet {
    @sap.unicode : 'false'
    @sap.label : 'Version'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Versn : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Stream ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Streamid : String(7) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    key Businesslocation : String(10) not null;
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
    @sap.label : 'Customer'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Customer : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Meter Reading'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Meterreading : Double not null;
    @sap.unicode : 'false'
    @sap.label : 'Relative Humidity'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Relativehumidity : Double not null;
    @sap.unicode : 'false'
    @sap.label : 'Stream Flow'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Streamflow : String(1) not null;
    @sap.unicode : 'false'
    @sap.label : 'Actual GCV'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Actualgcv : Double not null;
    @sap.unicode : 'false'
    @sap.label : 'Actual NCV'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Actualncv : Double not null;
    @sap.unicode : 'false'
    @sap.label : 'Average Gas CV'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Averagegcv : Double not null;
    @sap.unicode : 'false'
    @sap.label : 'Average Net CV'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Averagencv : Double not null;
    @sap.unicode : 'false'
    @sap.label : 'Sched.Material'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Schedulematerial : String(40) not null;
    @sap.unicode : 'false'
    @sap.label : 'Unit'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    @sap.semantics : 'unit-of-measure'
    Unit : String(3) not null;
    @sap.unicode : 'false'
    @sap.label : 'Temperature'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Floatingtemp : Double not null;
    @sap.unicode : 'false'
    @sap.label : 'Pressure'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Pressure : Double not null;
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
    @sap.label : 'Created By'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Createdby : String(15) not null;
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
  @sap.content.version : '1'
  @sap.label : 'GMS Scada type'
  entity xGMSxscada_api {
    @sap.display.format : 'UpperCase'
    @sap.label : 'Stream ID'
    key Streamid : String(7) not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Location ID'
    key Businesslocation : String(10) not null;
    @sap.display.format : 'Date'
    @sap.label : 'Gas Day'
    @sap.quickinfo : 'Gas Day Date'
    key Gasday : Date not null;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Customer'
    @sap.quickinfo : 'Customer No'
    key Customer : String(10) not null;
    @sap.display.format : 'NonNegative'
    @sap.label : 'Version'
    key Versn : String(3) not null;
    @sap.label : 'Actual GCV'
    Actualgcv : Double;
    @sap.label : 'Actual NCV'
    Actualncv : Double;
    @sap.label : 'Average Gas CV'
    @sap.quickinfo : 'Average GCV'
    Averagegcv : Double;
    @sap.label : 'Average Net CV'
    @sap.quickinfo : 'Average NCV'
    Averagencv : Double;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Scheduled material'
    Schedulematerial : String(40);
    @sap.label : 'UOM'
    @sap.quickinfo : 'Unit of Measurement'
    @sap.semantics : 'unit-of-measure'
    Unit : String(3);
    @sap.label : 'Temperature'
    Floatingtemp : Double;
    @sap.label : 'Pressure'
    Pressure : Double;
    @sap.label : 'Relative Humidity'
    Relativehumidity : Double;
    @sap.display.format : 'UpperCase'
    @sap.label : 'Stream Flow'
    @sap.quickinfo : 'Stream Direction Flow'
    Streamflow : String(1);
    @sap.label : 'Meter Reading'
    @sap.quickinfo : 'Scada Meter Reading'
    Meterreading : Double;
  };
};

