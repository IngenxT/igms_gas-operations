/* checksum : b865d47da836633c8aec56b463576775 */
@cds.external : true
@m.IsDefaultEntityContainer : 'true'
@sap.supported.formats : 'atom json xlsx'
service YGMS_LOCATIONID_VH_SRV {
  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.addressable : 'false'
  @sap.content.version : '1'
  entity locid4tsyst_vh_Set {
    @sap.unicode : 'false'
    @sap.label : 'Transport System'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    key TSYST : String(10) not null;
    @sap.unicode : 'false'
    @sap.label : 'Location ID'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LOCID : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Location Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    LOCNAME : String(60);
  };
};

