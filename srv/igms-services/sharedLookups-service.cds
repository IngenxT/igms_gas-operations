using {GMSVALUEHELP_SRV as GMSValueHelps} from '../external/GMSVALUEHELP_SRV.cds';
using {igmsConfigMetaData} from '../external/igmsConfigMetaData';
using {gasOpsService} from '../igms_service';

// Lookups used by the gas cockpit screens that live in shared services in igms-shipper
// (igmsValueHelp-service / igmsConfigData-service), copied here on their own.
extend service gasOpsService {

  entity materiallMaster as
    projection on GMSValueHelps.I_Material {
      key Material,
          Material_Text,
          MaterialType,
    };

  entity getBusinessRule as projection on igmsConfigMetaData.BusinessRules;

}
