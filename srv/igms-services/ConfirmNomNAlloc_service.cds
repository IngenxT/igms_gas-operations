using {igmsConfigMetaData} from '../external/igmsConfigMetaData';
using {GMSCONFIRMNOM_SRV as CONFIRMNOMSRV} from '../external/GMSCONFIRMNOM_SRV.cds';
using {GMSVALUEHELP_SRV as GMSValueHelps} from '../external/GMSVALUEHELP_SRV.cds';
using {gasOpsService} from '../igms_service';
using {GMSSCADAAPI_SRV as SCADASRV} from '../external/GMSSCADAAPI_SRV.cds';
using {GMSTICKET_API_SRV as TICKETSRV} from '../external/GMSTICKET_API_SRV';
using YGMS_GAS_ALLOCATION_SRV from '../external/YGMS_GAS_ALLOCATION_SRV.cds';
using YGMS_TRANSPORT_VALUEHELP_SRV from '../external/YGMS_TRANSPORT_VALUEHELP_SRV.cds';
using YGMS_LOCATIONID_VH_SRV from '../external/YGMS_LOCATIONID_VH_SRV.cds';


extend service gasOpsService {

  // ── Types ────────────────────────────────────────────────────

  type GasDay      : String(10);
  type Quantity    : Decimal(15, 3);
  type UOM         : String(10);
  type GCV_NCV     : Decimal(10, 4);
  type BusinessLoc : String(10);
  type ContractNo  : String(20);
  type Partner     : String(20);
  type RankType    : Integer;
  type Description : String(100);


  type ScheduledNomData {
    Gasday               : GasDay;
    ContractNo           : ContractNo;

    BusinessLocation     : BusinessLoc;
    BusinessLocationDesc : Description;

    NominationKey        : String(40);
    NominationItem       : String(10);

    ContractType         : String(10);
    ContractTypeName     : Description;

    MasterContractNo     : String(20);

    Partner              : Partner;
    PartnerName          : Description;

    TransportSystem      : String(10);
    TransportSystemName  : Description;

    DeliveryPoint        : String(20);
    DeliveryPointName    : Description;

    RedeliveryPoint      : String(20);
    RedeliveryPointName  : Description;

    Material             : String(20);
    MaterialName         : Description;

    Rank                 : RankType;

    DeliveryDCQ          : Quantity;
    RedeliveryDCQ        : Quantity;

    ApprovedDNQ          : Quantity;
    UOM                  : UOM;

    ApprovedQtySM        : Quantity;
    ConversionUOM        : UOM;

    AVG_WT_GCV           : GCV_NCV;
    AVG_WT_NCV           : GCV_NCV;

    SavedAllocatedQty    : Quantity;
    SavedAllocatedUOM    : UOM;
    AllocatedQty         : Quantity;
  }


  type BNSDocumentType {
    documentType     : String;
    documentTypeDesc : String;
  };


  // Server-side ProposedDNQ aggregate per UOM — avoids loading 1.5L BNS rows to browser.
  type BNSUomAgg {
    UOM      : String(10);
    TotalDNQ : Decimal(15, 3);
  }

  // Allocation rule violation returned by checkTechBalancingRules.
  type TechBalancingViolation {
    Location     : String(20);
    LocationDesc : String(100);
    AllocRule    : String(100);
    Reason       : String(300);
  }


  @description: 'Fetches distinct Document Types for Balancing & Scheduling — filtered by SHIPPER indicator'
  function getBalancingDocumentTypes()                                           returns array of BNSDocumentType;

  // Loads the full BNS dataset into the backend cache for one Gas Day or a date range.
  // Single day: GasdayTo = GasdayFrom (or empty); TransportSystems optional.
  // Date range : GasdayTo > GasdayFrom; TransportSystems required (applied at S4 level).
  // Returns the count of loaded rows. Clears any previously cached BNS data.
  action   warmBNSData(GasdayFrom: String(10),
                       GasdayTo: String(10),
                       TransportSystems: String(2000))                           returns Integer;

  // Server-side ProposedDNQ aggregation for BNS table — served from cache when warm,
  // falls back to paginated S4 query otherwise.
  // GasdayFrom/GasdayTo support both single-day and date-range modes.
  function getBNSAggQty(GasdayFrom: String(10),
                        GasdayTo: String(10),
                        ContractType: String(4),
                        TransportSystems: String(2000),
                        DeliveryPoints: String(2000),
                        RedeliveryPoints: String(2000),
                        Materials: String(2000),
                        HasNomKey: Integer)                                      returns array of BNSUomAgg;

  // Confirmed/NotConfirmed row counts from backend cache — field-to-field comparison
  // (ApprovedDNQ eq/ne ProposedDNQ) cannot be expressed via OData $filter in CAP.
  type BNSStatusCounts {
    confirmed    : Integer;
    notConfirmed : Integer;
    total        : Integer;
  }

  function getBNSStatusCounts(GasdayFrom: String(10),
                              GasdayTo: String(10),
                              ContractType: String(4),
                              TransportSystems: String(2000),
                              DeliveryPoints: String(2000),
                              RedeliveryPoints: String(2000),
                              Materials: String(2000))                           returns BNSStatusCounts;

  // Checks that every Business Location in the filtered BNS data has a valid
  // "Label Wise Ranking" rule for "Technical Balancing" on the given Gas Day.
  // Returns violations: locations with a different rule or no rule at all.
  function checkTechBalancingRules(Gasday: String(10),
                                   ContractType: String(4),
                                   TransportSystems: String(2000),
                                   DeliveryPoints: String(2000),
                                   RedeliveryPoints: String(2000),
                                   Materials: String(2000),
                                   HasNomKey: Integer)                           returns array of TechBalancingViolation;

  // ── Confirm Nomination — unified selected-rows job (any size) ─────────────
  // The frontend always sends the exact selected line items; the server
  // resolves them fresh from S/4, applies ARI004 rules automatically (no
  // client pre-flight dialog), and posts to S/4 one row per call, strictly
  // sequential — S/4 TSW does not support parallel nomination creation. Job
  // state lives in an in-memory map — safe only while this module runs at
  // instances:1 (see mta.yaml); revisit with a persisted store before any
  // horizontal scale-out.

  type ConfirmSample {
    ContractNo : String(20);
    Message    : String(500);
  }

  type ConfirmReturnMsg {
    ContractNo : String(20);
    Type       : String(10);
    Message    : String(500);
  }

  type ConfirmNominationJobStatus {
    jobId                : String(36);
    status               : String(20); // SUBMITTED | RUNNING | COMPLETED | FAILED | NOT_FOUND
    requestedItems       : Integer; // length of the client's SelectedKeys list
    totalItems           : Integer;
    totalContracts       : Integer;
    processedItems       : Integer;
    processedContracts   : Integer;
    confirmedItems       : Integer;
    rejectedItems        : Integer;
    failedItems          : Integer;
    cappedItems          : Integer;
    rtcItems             : Integer; // GTA legs adjusted by Right to Cure (srv/utils/gtaRightToCure.js)
    linkedPendingItems   : Integer;
    staleSkippedItems    : Integer;
    lockedItems          : Integer; // same-row concurrency guard — see _claimRows
    preConfirmedItems    : Integer; // fresh S/4 recheck right before POST found row already confirmed
    startedAt            : DateTime;
    completedAt          : DateTime;
    errorMessage         : String(500);
    rejectedSamples      : array of ConfirmSample;
    s4ErrorSamples       : array of ConfirmSample;
    linkedPendingSamples : array of ConfirmSample;
    staleSkippedSamples  : array of ConfirmSample;
    cappedSamples        : array of ConfirmSample; // "field capped to X by rule R"
    rtcSamples           : array of ConfirmSample; // per adjusted/skipped GTA pair: scenario, DP/RDP demand → approved
    lockedSamples        : array of ConfirmSample;
    preConfirmedSamples  : array of ConfirmSample;
    toReturn             : array of ConfirmReturnMsg;
  }

  // Confirms exactly the rows identified by SelectedKeys — sent by the client
  // from its actual current table selection. SelectedKeys is a comma-separated
  // list of 'Gasday|ContractNo|Item|Versn|NominationItem' composite keys
  // (pipe-delimited, matching this file's existing dateKey|... convention).
  // Below CONFIRM_SYNC_THRESHOLD resolved rows this runs inline and returns the
  // final COMPLETED status; at/above it, returns a SUBMITTED jobId to poll via
  // getConfirmNominationJobStatus.
  // TEMP (demo): @requires: 'BalancingScheduling-ConfirmNomination-Button'
  action   confirmNominationSelected(SelectedKeys: String)                       returns ConfirmNominationJobStatus;

  // Polls the status of a job started by confirmNominationSelected.
  function getConfirmNominationJobStatus(jobId: String(36))                      returns ConfirmNominationJobStatus;

  // ── Button-level authorization — Confirm Nomination ─────────────────────────
  // Display-only read of the same scope confirmNominationSelected's @requires
  // enforces server-side; the frontend uses it to show/hide the button, never
  // to substitute for the backend check itself.
  type ConfirmNominationAuth {
    canConfirmNomination : Boolean;
  }

  function getConfirmNominationAuth()                                            returns ConfirmNominationAuth;

  entity getAllocationRule           as projection on igmsConfigMetaData.AllocationLocationRule;


  // Returns distinct (Tsyst, Tsnam) pairs matching the optional search term.
  // Used by the frontend Select All / Deselect All actions so the browser
  // never needs to load the full dataset to compute a key set.
  function getAllTransportSystemKeys(search: String)                             returns array of {
    Tsyst : String(10);
    Tsnam : String(60);
  };

  // Location key functions — used by VH Select All / Deselect All.
  // transportSystems: comma-separated Tsyst values to pre-filter; empty = no filter.
  function getAllDeliveryPointKeys(search: String, transportSystems: String)     returns array of {
    Locid  : String(10);
    Locnam : String(60);
    Tsyst  : String(10);
  };

  function getAllRedeliveryPointKeys(search: String, transportSystems: String)   returns array of {
    Locid  : String(10);
    Locnam : String(60);
    Tsyst  : String(10);
  };

  function getAllInterconnectPointKeys(search: String, transportSystems: String) returns array of {
    Locid  : String(10);
    Locnam : String(60);
    Tsyst  : String(10);
  };

  entity I_TicketErrorLog            as
    projection on TICKETSRV.I_TicketErrorLog {
      key NominationTicketKey,
      key NominationTicketItem,
      key NominationTicketVersion,
      key NominationTicketPurpose,
      key TicketSequenceNumber,
          SourceDocumentItem,
          NominationExtNumber,
          NominationReferenceDocument,
          TicketHasError,
          TicketMessageType,
          TicketNumber,
          SystemMessageText,
          NominationDoc,
          NominationDocItem,
          NominationDocIsBlocked,
          NominationTicketIsBlocked,
          NominationTicketType,
          DocumentCategoryText,
          SDDocumentCategoryName,
          MaterialDocumentYear
    };

  entity SaveTicketData              as
    projection on TICKETSRV.SaveTicket {
      key Save,
          toTicketItems,
          toCVParams
    };

  entity CVParamsSet                 as
    projection on TICKETSRV.CVParamsSet {
      key Nomtk,
      key Nomit,
          GCV,
          NCV
    };

  entity TicketHeaderSet             as
    projection on TICKETSRV.TicketHeaderSet {
      key TicketItem,
      key TicketKey,
          TicketVersion,
          TicketPurpose,
          EventNr,
          Type,
          DocType,
          EvSeq,
          DocNumber,
          Shitem,
          Status,
          Actualstartfrom,
          Actualstartto,
          Actualendfrom,
          Actualendto,
          CreName,
          Creation,
          ChaName,
          Modification,
          VehNr,
          Tsrfo,
          Delind,
          Updkz
    };

  entity TicketItemsSet              as
    projection on TICKETSRV.TicketItemsSet {
      key TicketKey,
      key TicketItem,
          TicketVersion,
          TicketPurpose,
          ExtPosnr,
          Status,
          Substatus,
          Sityp,
          Tktsubrc,
          Mvscenario,
          Nomnr,
          Nomtk,
          Nomit,
          Receiver,
          Locid,
          Tanknr,
          Vehicle,
          Menge,
          Grosquan,
          Meins,
          Matnr,
          Tankage,
          Supplier,
          Consigne,
          AgreedQty,
          AgreedQtyUom,
          ShipQty,
          ShipQtyUom,
          Mttmp,
          Mtteh,
          OApiGrav,
          ApiGrtD,
          Tstmp,
          Tsteh,
          Tdich,
          Erdat,
          Erzeit,
          Ernam,
          Aedat,
          Aezeit,
          Aenam,
          Bloind,
          Delind,
          Tktselect,
          Budat,
          CloseNomit,
          Eventtype,
          EventDate,
          Gmmnr,
          OItmstm,
          OMetev,
          CItmstm,
          CMetev,
          Stoprdg,
          StmQuantity,
          StmUom,
          Socnr,
          ODipRead,
          ODipReadUom,
          OEtmstm,
          OSocev,
          CDipRead,
          CDipReadUom,
          CEtmstm,
          CSocev,
          Stopdip,
          StopdipUom,
          StpGauQuan,
          StpGauUom,
          GauQuantity,
          GauUom,
          Shtype,
          Vstel,
          ChargO,
          WerksO,
          LgortO,
          ChargD,
          WerksD,
          LgortD,
          TimeStLoadSta,
          TimeStLoadEnd,
          TimeStLedOt,
          ChargDCreate,
          OibBltime,
          ChargL,
          ChargLCreate,
          Shtyp,
          MengePar,
          UnitIPar,
          Railcarqty,
          DummyTktitmInclEewPs,
          Ldplt,
          Itplt,
          Itstlc,
          Itbtch,
          Updkz
    };


  entity DocFlowSet                  as
    projection on TICKETSRV.DocFlowSet {
      key TicketKey,
      key TicketItem,
      key TicketVersion,
          Purpose,
          SequenceNo,
          Nomtk,
          Nomit,
          Return,
          RefDoc,
          MatYear,
          RefDocItem,
          DocCategory,
          DocDescription,
          RevDoc
    };

  @readonly
  entity ErrorLogSet                 as
    projection on TICKETSRV.ErrorLogSet {
      key TicketKey,
      key TicketItem,
      key TicketVersion,
          Purpose,
          SequenceNo,
          Nomtk,
          Nomit,
          MvScenario,
          Return,
          RefDoc,
          MatYear,
          RefDocItem,
          DocCategory,
          DocDescription,
          TSWDate,
          MsgId,
          MsgTyp,
          MsgStatus,
          MsgNo,
          RevDoc,
          ErrorDescription
    };

  // ── Ticket Execution Detail — single-execution-record read ───────────────────
  // Keyed by TicketKey+TicketItem+TicketVersion+Purpose (the SAME four fields
  // ScheduledNomItems now also carries — see that entity's own TicketVersion doc
  // comment, allocationTicketing-service.cds). Lets the Allocation & Ticketing
  // Scheduled Items table's Ticket Key click (ticketDetail.js) read the ONE
  // execution record behind that row directly, by key, in a single round trip —
  // no ExecId resolution via xGMSxTKT_EXEC_TICKETS, no TktlogDetailHeadSet deep
  // expand, no grouping of raw diagnostic lines: TicketDetailSet's own row already
  // IS that one execution, with TO_DOCFLOW/TO_ERRLOG attached directly.
  // Nomtk/Nomit stay $filter-able server-side (confirmed live — see the
  // "filterable:false" annotations on the remote entity's own fields, which the
  // backend does not actually enforce for this service) for callers that only
  // know the nomination, not a specific ticket key/version/purpose yet.
  @readonly
  entity TicketDetailSet             as
    projection on TICKETSRV.TicketDetailSet {
      key TicketItem,
      key TicketKey,
      key TicketVersion,
      key Purpose,
          TicketNumber,
          Nomtk,
          Nomit,
          ProcessStatus,
          MessageSummary,
          HasDocs,
          HasErrors,
          CreatedDate,
          CreatedTime,
          CreatedBy,
          ChangedDate,
          ChangedTime,
          ChangedBy,
          TO_ERRLOG,
          TO_DOCFLOW
    };

  @readonly
  entity TktlogDetailHeadSet         as
    projection on TICKETSRV.TktlogDetailHeadSet {
          CompletedAt,
          CreatedAt,
          ErrorCount,
          ErrorMessage,
          ExecDate,
      key ExecId,
          ExecStatus,
          ExecTime,
          ExecUser,
          Gasday,
          ICIndicator,
          ParametersJson,
          ProcessingTime,
          SuccessCount,
          SystemError,
          TotalItems,
          Tsyst,
          WarningCount,
          to_logtkts
    };

  @readonly
  entity TktlogDetailSet             as
    projection on TICKETSRV.TktlogDetailSet {
      key ExecId,
          HasDocs,
          HasErrors,
      key Logitm,
          MessageSummary,
      key Nomit,
      key Nomtk,
          ProcessStatus,
      key TicketItem,
      key TicketKey,
      key TicketVersion,
      key Purpose,
          TicketNumber,
      CreatedDate,
      CreatedTime,
          CreatedBy,
      ChangedDate,
      ChangedTime,
          ChangedBy,
          TO_ERRLOG,
          TO_DOCFLOW
    };

  entity returnSet                   as
    projection on TICKETSRV.returnSet {
      key Type,
      key Id,
      key Number,
          Message,
          LogNo,
          LogMsgNo,
          MessageV1,
          MessageV2,
          MessageV3,
          MessageV4,
          Parameter,
          Row,
          Field,
          System
    };

  entity xGMSxNOMTICKET              as
    projection on TICKETSRV.xGMSxNOMTICKET {
      key ContractNo,
      key Gasday,
      key Item,
      key TicketKey,
      key TicketItem,
          Versn,
          Mastercontno,
          CustomerName,
          NominationItem,
          SoldToParty,
          Vendor,
          Customer,
          DeliveryPoint,
          RedelivryPoint,
          ValidTo,
          ValidFrom,
          Zstat,
          Material,
          NominationKey,
          DocumentType,
          TransportSystem,
          DeliveryDcq,
          RedeliveryDcq,
          Uom,
          ProposedDnq,
          Event,
          ApprovedDnq,
          RepublishDnq,
          Remarks,
          Flag,
          Action,
          Path,
          Source,
          CustGrp,
          Timestamp,
          ServiceProfile,
          SalesPurchInd,
          AllocatedQty,
          AllocatedUom
    };

  entity ticketLogs                  as
    projection on TICKETSRV.TktlogDetailHeadSet {
      key ExecId,
          ExecDate,
          ExecTime,
          ExecUser,
          ExecStatus,
          Gasday,
          Tsyst,
          ICIndicator,
          ParametersJson,
          TotalItems,
          SuccessCount,
          ErrorCount,
          WarningCount,
          SystemError,
          ErrorMessage,
          CreatedAt,
          CompletedAt,
          ProcessingTime,
          to_logtkts,

          // ── CAP-local computed fields — not real S/4 columns, hence `virtual` ──
          // TktlogDetailHeadSet is execution-level; the READ handler
          // (srv/serviceHandlers/ConfirmNomNAlloc_service.js) fills these from the
          // row's own expanded to_logtkts (TktlogDetailSet) lines.
          virtual TicketKey  : String(20),
          virtual TicketItem : String(6),
          virtual Nomtk      : String(20),
          virtual Nomit      : String(10)
    };

  entity xGMSxTKTDATA                as
    projection on TICKETSRV.xGMSxTKTDATA {
      key TicketKey,
      key TicketItem,
      key TicketVersion,
      key TicketPurpose,
          TicketPurposeDescription,
          NominationNumber,
          NominationKey,
          NominationItem,
          LocationId,
          LocationName,
          Quantity,
          UOM,
          Material,
          MaterialName,
          CreatedDate,
          CreatedTime,
          CreatedBy,
          ChangedDate,
          ChangedTime,
          ChangedBy,
          BlockingIndicator,
          DeletionIndicator,
          DocumentDate,
          BillingNumber,
          BillingDate,
          to_bill,
          to_flow
    };

  entity TicketedDocuments           as
    projection on TICKETSRV.xGMSxTKTDETAILS02 {
      key TicketKey,
      key TicketItem,
      key TicketVersion,
      key TicketPurpose,
      key SeqNmbr,
          TransactionCode,
          Returncode,
          DocumentNumber,
          DocumentYear,
          ItemNo,
          DocumentCategory,
          DocumentCategoryText,
          ReversalDocumentIndicator
    };

  entity xGMSxTKT_EXEC_TICKETS       as
    projection on TICKETSRV.xGMSxTKT_EXEC_TICKETS {
      key ExecId,
      key TicketKey,
      key TicketItem,
      key Nomtk,
      key Nomit,
      key Logitm,
          ProcessStatus,
          HasErrors,
          HasDocs,
          MessageSummary,
          to_docflow,
          to_errlog
    };

  entity xGMSxTKTDETAILS03           as
    projection on TICKETSRV.xGMSxTKTDETAILS03 {
      key TicketKey,
      key TicketItem,
      key TicketVersion,
      key TicketPurpose,
          TicketPurposeDescription,
          NominationNumber,
          NominationKey,
          NominationItem,
          LocationId,
          LocationName,
          Quantity,
          UOM,
          Material,
          MaterialName,
          CreatedDate,
          CreatedTime,
          CreatedBy,
          ChangedDate,
          ChangedTime,
          ChangedBy,
          BlockingIndicator,
          DeletionIndicator,
          DocumentDate,
          BillingNumber,
          BillingDate,
          ScheduledQuantity,
          ScheduledQuantityUOM,
          Customer,
          ContractNo,
          DocumentType
    };


  @readonly
  entity ActualErrorSet              as
    projection on TICKETSRV.ActualErrorSet {
      key TicketKey,
      key TicketItem,
      key Nomtk,
      key Nomit,
      key Locid,
      key Menge,
      key Meins,
      key Msgty,
          Message
    };

  @readonly
  entity ActualLocidSet              as
    projection on TICKETSRV.ActualLocidSet {
      key Locid
    };

  @readonly
  entity ActualMatnrSet              as
    projection on TICKETSRV.ActualMatnrSet {
      key Matnr
    };

  @readonly
  entity ActualNomitSet              as
    projection on TICKETSRV.ActualNomitSet {
      key Nomit
    };

  @readonly
  entity ActualNomnrSet              as
    projection on TICKETSRV.ActualNomnrSet {
      key Nomnr
    };

  @readonly
  entity ActualSuccessFlowSet        as
    projection on TICKETSRV.ActualSuccessFlowSet {
      key TicketKey,
      key TicketItem,
      key SeqNmbr,
      key Docnr,
      key Mjahr,
      key Posnr,
          DocCat,
          DocCatText,
          Revdoc
    };

  @readonly
  entity ActualSuccessSet            as
    projection on TICKETSRV.ActualSuccessSet {
      key TicketKey,
      key TicketItem,
      key Nomtk,
      key Nomit,
      key Locid,
      key Menge,
      key Meins,
      key Msgty,
          Message
    };

  @readonly
  entity ActualTsystSet              as
    projection on TICKETSRV.ActualTsystSet {
      key Tsyst
    };


  entity createConfirmNom            as
    projection on CONFIRMNOMSRV.Conf_nomiSet {
      key Gasday,
          nom_configSet,
          GmsConfNomiNav
    };

  entity Conf_nomi_subSet            as
    projection on CONFIRMNOMSRV.Conf_nomi_subSet {
          ContractNo,
          Mastercontno,
          Icindicator,
      key Gasday,
          IcAllocQty,
          Item,
          NominationItem,
          IcAllocUom,
          Customer,
          Source,
          NominationKey,
          SoldToParty,
          Vendor,
          DocumentType,
          TransportSystem,
          Zstat,
          DeliveryDcq,
          RedeliveryDcq,
          Uom,
          Versn,
          DeliveryPoint,
          ProposedDnq,
          ApprovedDnq,
          RedelivryPoint,
          RepublishDnq,
          ValidTo,
          ServiceProfile,
          ValidFrom,
          Material,
          SalesPurchInd,
          Timestamp,
          Event,
          Remarks,
          Flag,
          Action,
          Path,
          CustGrp,
          Createdby,
          Createddate,
          Createdtime,
          Changedby,
          Changeddate,
          Changedtime
    };

  entity nom_configSet               as
    projection on CONFIRMNOMSRV.nom_configSet {
      key Docind,
      key Doctype,
      key schtype,
      key nomtype,
      key OL_OC
    };

  entity toReturnSet                 as
    projection on CONFIRMNOMSRV.toReturnSet {
      key Gasday,
      key Vbeln,
      key Type,
      key Id,
      key Number,
          Message,
          LogNo,
          LogMsgNo,
          MessageV1,
          MessageV2,
          MessageV3,
          MessageV4,
          Parameter,
          Row,
          Field,
          System
    };

  entity scheduledNomData            as
    projection on CONFIRMNOMSRV.xGMSxNOMSOURCE {
      key Gasday,
      key ContractNo,
      key Item,
      key Versn,
      key NominationItem,
          NominationKey,
          Event,
          ContractType,
          ContractTypeName,
          MasterContractNo,
          Partner,
          PartnerName,
          TransportSystem,
          TransportSystemName,
          DeliveryPoint,
          DeliveryPointName,
          RedeliveryPoint,
          RedeliveryPointName,
          Material,
          MaterialName,
          Rank,
          DeliveryDCQ,
          RedeliveryDCQ,
          ProposedDNQ,
          PrevProposedDNQ,
          PostBalancingDNQ,
          RepublishDNQ,
          ApprovedDNQ,
          SavedAllocatedQty,
          SavedAllocatedUOM,
          ScheduledQty,
          ScheduledUoM,
          ProposedScheduledDiff,
          ProposedScheduledDiffUoM,
          isConfirmRequired,
          MaxRedeliveryDCQ,
          MinRedeliveryDCQ,
          MaxDeliveryDCQ,
          MinDeliveryDCQ,
          UOM,
          Avggcv,
          Avgncv,
          GA_ID,
          GA_ID_DCQ,
          GA_ID_PDNQ,
          GA_ID_SDNQ,
          GA_ID_LOCDNQ,
          NominationStatus,
          Source,
          ServiceType,
          CustomerInd,
          CustomerIndId,
          CorrespondingDocNo,
          LinkContexist,
          MonthlyConsumptionQty,
          MonthlyConsumptionUom,
          MonthlyContractualQty,
          MonthlyContractualUom,
          MonthlyRemainingQty,
          MonthlyRemainingUom,
          AddressNumber,
          CustomerKind,
          yyoij_od_qty,
          yyoij_un_qty,
          yyoij_aod_qty,
          yyoij_unaod_qty,
          yyoij_ovr_qty,
          yyoij_aovr_qty,
          yyoij_unaovr_qty,
          yyoij_dimb_qty,
          yyoij_cnom_qty,
          yyoij_cnom_uom,
          yyoij_status,
          yyoij_dpimb_qty,
          yyoij_dnimb_qty,
          yyoij_cumimb_qty,
          yyoij_crgimb_qty,
          yyoij_pos_cumimb,
          yyoij_neg_cumimb,
          yyoij_ld_a_qty,
          yyoij_ld_d_qty,
          yyoij_sop_a_qty,
          yyoij_sop_d_qty,
          yyoij_ssf_a_qty,
          yyoij_ssf_d_qty,
          yyoij_top_a_qty,
          yyoij_top_d_qty,
          yyoij_gta_adjust,
          yyoij_gsa_adjust,
          yyoij_gujdnq,
          yyoij_gujdnq_uom,
          yyoij_dds_qty,
          SavedAllocatedQty2,
          IsPrimaryContract
    };

  entity ConversionItem              as
    projection on CONFIRMNOMSRV.ConversionItem {
      key NominationKey,
      key NominationItem,
          NCV,
          GCV,
          ScheduledQty,
          ScheduledUoM,
          TargetUoM,
          TargetQty,
          MsgType,
          Message
    };

  entity quantityConversion          as
    projection on CONFIRMNOMSRV.ConversionRequest {
      key RequestId,
          ToItems
    };

  @readonly
  @cds.persistence.skip
  entity fetchSCADAData {
    key Streamid         : String(7);
    key Customer         : String(10);
    key Businesslocation : String(10);
        Relativehumidity : Decimal(15, 3);
    key Gasday           : Date;
        Streamflow       : String(1);
        Meterreading     : Decimal(15, 3);
        Actualgcv        : Decimal(15, 3);
        Actualncv        : Decimal(15, 3);
        AverageWtgcv     : Decimal(15, 5);
        AverageWtncv     : Decimal(15, 5);
        Schedulematerial : String(40);
        Unit             : String(3);
        Floatingtemp     : Decimal(10, 3);
        Pressure         : Decimal(10, 3);
  }

  @readonly
  entity SCADAReadings               as
    projection on SCADASRV.xGMSxscada_api {
      key Versn,
      key Streamid,
      key Businesslocation,
      key Gasday,
      key Customer,
          Actualgcv,
          Actualncv,
          Averagegcv,
          Averagencv,
          Schedulematerial,
          Unit,
          Floatingtemp,
          Pressure,
          Relativehumidity,
          Streamflow,
          Meterreading
    };

  entity readSCADAData               as
    projection on SCADASRV.xGMSxscada_api {
      key Streamid,
      key Businesslocation,
      key Gasday,
      key Customer,
          Actualgcv,
          Actualncv,
          Averagegcv,
          Averagencv,
          Schedulematerial,
          Unit,
          Floatingtemp,
          Pressure,
          Relativehumidity,
          Streamflow,
          Meterreading
    };

  entity ScadaFieldSet               as
    projection on SCADASRV.ScadaFieldSet {
      key Versn,
          Customer,
          Meterreading,
      key Streamid,
      key Businesslocation,
          Relativehumidity,
      key Gasday,
          Streamflow,
          Actualgcv,
          Actualncv,
          Averagegcv,
          Averagencv,
          Schedulematerial,
          Unit,
          Floatingtemp,
          Pressure,
          Createddate,
          Createdtime,
          Createdby,
          Changedby,
          Changeddate,
          Changedtime
    };

  entity uploadSCADAReading          as
    projection on SCADASRV.ScadaUploadSet {
      key scadaupload,
          to_scadaitems
    };

  @cds.persistence.skip
  entity SCADABalancing {
    key Streamid         : String(20);
    key Businesslocation : String(20);
        Gasday           : Date;
        Actualquanty     : Decimal(15, 3);
        ReadingUOM       : String(10);
        Actualgcv        : Decimal(15, 3);
        ActualNCV        : Decimal(15, 3);
        AggrNomQty       : Decimal(15, 3);
        NomUOM           : String(5);

        Schedulematerial : String(20);
        Unit             : String(5);

        Floatingtemp     : Decimal(10, 3);
        Pressure         : Decimal(10, 3);
        ScadaMissing     : Boolean;

  }


  entity YGMS_ALLOCATION_GAS_DATASet as
    projection on YGMS_GAS_ALLOCATION_SRV.YGMS_ALLOCATION_GAS_DATASet {
          YvbelnEp,
          YyallocQtyNongailscm,
          YsdqtyEp,
          Yycustomer,
          YqtyuomEp,
      key Yytimestamp,
          YdpalcqtyEp,
          Yy_Indicator,
          YdpalcuomEp,
          YyallocUomNongailscm,
          YalcsqtyEp,
          YytimeCm,
          YalcsqtyUomEp,
          YybusLocation,
          YupdFlagEp,
      key YydateGas,
          YycdateCm,
          YycumVolCm,
          YyavgGcvCm,
          YyavgNcvCm,
          YytimeCase2,
          YydateCase2,
          YyvolSm3Case2,
          YyspcodeCase2,
          YydateNgail,
          YytimeNgail,
          YygcvNgail,
          YyncvNgail,
          YrnameNagal,
          YydateNongail,
          YytimeNongail,
          YyallocQtyNongail,
          YyallocUomNongail,
          YrnameNongail
    };

  entity TransportSystem             as
    projection on YGMS_TRANSPORT_VALUEHELP_SRV.TransportSystemValueEntitySet {
      key Tsyst,
          Vsart,
          TSNAM
    };

  entity BusinessLocations           as
    projection on YGMS_LOCATIONID_VH_SRV.locid4tsyst_vh_Set {
      key LOCID,
          TSYST,
          LOCNAME
    };

}
