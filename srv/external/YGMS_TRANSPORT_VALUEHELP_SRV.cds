/* checksum : 4ff701152853d31fbd546e0c5d96bb89 */
@cds.external : true
@m.IsDefaultEntityContainer : 'true'
@sap.supported.formats : 'atom json xlsx'
service YGMS_TRANSPORT_VALUEHELP_SRV{
  @cds.external : true
  @cds.persistence.skip : true
  @sap.creatable : 'false'
  @sap.updatable : 'false'
  @sap.deletable : 'false'
  @sap.pageable : 'false'
  @sap.content.version : '1'
  entity TransportSystemValueEntitySet {
    @sap.unicode : 'false'
    @sap.label : 'Shipping Type'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    key Vsart : String(2) not null;
    @sap.unicode : 'false'
    @sap.label : 'Trans system'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    Tsyst : String(10);
    @sap.unicode : 'false'
    @sap.label : 'Transport System Name'
    @sap.creatable : 'false'
    @sap.updatable : 'false'
    @sap.sortable : 'false'
    @sap.filterable : 'false'
    TSNAM : String(60);
  };
};