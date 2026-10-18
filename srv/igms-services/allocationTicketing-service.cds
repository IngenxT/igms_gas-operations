using {GMSCONFIRMNOM_SRV as CONFIRMNOMSRV} from '../external/GMSCONFIRMNOM_SRV.cds';
using {GMSVALUEHELP_SRV as GMSValueHelps} from '../external/GMSVALUEHELP_SRV.cds';
using {gasOpsService} from '../igms_service';
using {GMSTICKET_API_SRV as TICKETSRV} from '../external/GMSTICKET_API_SRV.cds';
using YGMS_GAS_ALLOCATION_SRV from '../external/YGMS_GAS_ALLOCATION_SRV.cds';

// ── Allocation & Ticketing tile ───────────────────────────────────────────────
// Entities/types/actions backing the allocationNTicketing screen only. Shares
// the GasDay/Quantity/UOM/GCV_NCV/BusinessLoc/ContractNo/Partner/RankType/
// Description scalar type aliases declared in ConfirmNomNAlloc_service.cds
// (both files extend the same gasOpsService, so they resolve unqualified).
extend service gasOpsService {

  type SCADAData {
    BusinessLocation  : gasOpsService.BusinessLoc;
    Gasday            : gasOpsService.GasDay;

    MeterReading      : gasOpsService.Quantity;
    MeterReadingUOM   : gasOpsService.UOM;

    AggreNominatedQty : gasOpsService.Quantity;
    AggreNominatedUOM : gasOpsService.UOM;

    AverageGCV        : gasOpsService.GCV_NCV;
    AverageNCV        : gasOpsService.GCV_NCV;
  }
  type MissingSCADALocation {
    TransportSystem      : String(10);
    TransportSystemName  : gasOpsService.Description;

    BusinessLocation     : String(10);
    BusinessLocationDesc : String(100);

    Message              : String(200);
    // Which meter this gap is against — OWN/PRIMARY/HYBRID share one physical OWN
    // meter, THIRDPARTY reads from a partner's own upload, NONE means no reading of
    // either kind has arrived yet. Disambiguates Message text for the frontend: a
    // GCV/NCV-only gap reads identically ("GCV/NCV missing") whichever meter it's
    // against, so the category label can't be derived from Message text alone.
    ReadingSource         : String(15);
    // Set only for a THIRDPARTY row that's incomplete/already-ticketed for one specific
    // partner at a shared connection point (Partner+Location grain) — blank for a
    // location-wide gap
    // (OWN/PRIMARY/HYBRID, or a THIRDPARTY location with no reading of any kind yet).
    // The frontend uses this to tell a self-contained per-partner gap (never excludes
    // the whole Location) apart from a genuine location-wide block.
    Partner               : String(10);
    PartnerName           : gasOpsService.Description;
  }
  // Pre-computed aggregates returned instead of the full ScheduledNomData array.
  // Keeps the function response tiny even for 1.5 lakh nomination items.
  type NomSummary {
    TotalCount        : Integer;
    AggrApprovedQty   : Decimal(15, 3);
    AggrUOM           : String(10);
    AggrApprovedQtyDP : Decimal(15, 3); // AggrApprovedQty for LocationType='DELIVERY' rows only
    AggrUOMDP         : String(10);
    AggrApprovedQtyRDP: Decimal(15, 3); // AggrApprovedQty for LocationType='REDELIVERY' rows only
    AggrUOMRDP        : String(10);
    AggrMeteredQty    : Decimal(15, 3);
    MeteredUOM        : String(10);
    AggrMeteredQtyDP  : Decimal(15, 3); // AggrMeteredQty for LocationType='DELIVERY' rows only
    MeteredUOMDP      : String(10);
    AggrMeteredQtyRDP : Decimal(15, 3); // AggrMeteredQty for LocationType='REDELIVERY' rows only
    MeteredUOMRDP     : String(10);
    AggrAllocatedQty   : Decimal(15, 3); // Σ (AllocatedQty + OverDrawlGSA)
    AllocatedUOM       : String(10);
    AggrAllocatedQtyDP : Decimal(15, 3); // AggrAllocatedQty for LocationType='DELIVERY' rows only
    AllocatedUOMDP     : String(10);
    AggrAllocatedQtyRDP: Decimal(15, 3); // AggrAllocatedQty for LocationType='REDELIVERY' rows only
    AllocatedUOMRDP    : String(10);
  }
  type BusinessLocationRef {
    Location    : String(10);
    LocationDesc: String(100);
  }
  type ScheduledNomItemsWithSCADA {
    SCADAData             : array of SCADAData;
    NomSummary            : NomSummary;
    // Every Business Location this Gas Day's fetch resolved (locMeta, server-side) —
    // the frontend's "how many eligible Locations remain after excluding every Data
    // Issue" check (allocationActions._checkDataIssuesGate) needs the FULL universe to
    // compare against; SCADAData above is legacy-empty (SCADA table removed) and can't
    // serve that purpose any more.
    AllBusinessLocations   : array of BusinessLocationRef;
    MissingSCADAReading   : array of MissingSCADALocation;
    ConversionFailures    : array of ConversionFailure;
    MissingRank           : array of MissingRankItem;
    // Location(s) where at least one Scheduled Item already carries a TicketKey (already
    // ticketed in TSW) — surfaced pre-run so Simulate/Allocate & Save/Ticketing can be
    // gated the same way as the other Data Issues, instead of silently re-processing an
    // already-ticketed location.
    AlreadyTicketedLocations : array of MissingSCADALocation;
    // A real SCADA/GDA Measurement exists (OWN Location, or a HYBRID/THIRDPARTY Partner+
    // Location dedicated reading) with NO corresponding nomination item at all — a data
    // integrity gap (someone measured gas nobody nominated), surfaced pre-run so
    // Simulate/Allocate & Save/Ticketing are gated the same way as the other Data Issues
    // instead of silently proceeding around it.
    OrphanReadingLocations   : array of MissingSCADALocation;
    // An Entry Point (ZGT1) GDA reading resolved a paired Delivery contract via
    // CorrespondingDocNo, but that contract hasn't reached its own Nomination
    // Confirmation yet — its quantity is deliberately excluded from allocation
    // netting (epQtyByLocation), surfaced here instead of a silently blank
    // Business Location on the Entry Point Measurement table.
    UnconfirmedEntryPointLinks : array of UnconfirmedEntryPointLink;
  }
  type UnconfirmedEntryPointLink {
    Vbeln                : String(10); // Entry Point SD Document == a ScheduledItems row's own Contract
    DeliveryContract      : String(10); // paired DeliveryPoint Contract (via CorrespondingDocNo), not yet confirmed
    BusinessLocation      : String(10);
    Message               : String(200);
  }
  // A ConversionRequest item that came back with MsgType != 'S' (or didn't come back
  // at all) — must not be silently treated as zero demand; surfaced to the UI instead.
  type ConversionFailure {
    BusinessLocation     : String(10);
    BusinessLocationDesc : String(100);
    NominationKey        : String(40);
    NominationItem       : String(10);
    Message              : String(220);
  }
  // A nomination item with Rank blank or 0 — RunAllocateSave/processTicketing block the
  // whole Location for these; surfaced at Go time so users see it before running.
  // Excludes ZGT1 @ Delivery Point (never Rank-dependent).
  type MissingRankItem {
    TransportSystem      : String(10);
    TransportSystemName  : gasOpsService.Description;

    BusinessLocation     : String(10);
    BusinessLocationDesc : String(100);

    NominationKey        : String(40);
    NominationItem       : String(10);
    Contract              : String(20);
    Partner               : String(10);
    PartnerName           : String(80);

    Message               : String(50);
  }
  type SCADAChange {
    BusinessLocation : String(20);
    Indicator        : String(20);
    OldMeterReading  : Decimal(15, 3);
    NewMeterReading  : Decimal(15, 3);
    OldGCV           : Decimal(15, 3);
    NewGCV           : Decimal(15, 3);
    OldNCV           : Decimal(15, 3);
    NewNCV           : Decimal(15, 3);
  }

  // checkNominationChanges result — a nomination deleted/added in S/4 since load
  type NominationChange {
    ChangeType     : String(10); // DELETED | ADDED
    NominationKey  : String(20);
    NominationItem : String(10);
    ContractNo     : String(20);
    Location       : String(20);
  }

  // ── Typed scope payload for RunAllocateSave/processTicketing ─────────────────
  // Replaces the old comma-joined Locations/ExcludeLocations strings (bare "C10551" or
  // "Partner__C10551" tokens) with proper structured arrays, matching
  // simulate-allocate-save-flow-spec.md Step 4's SegmentFilter/SelectionFilter payload.
  type SegmentEntryT {
    Location : String(20);
    Customer : String(10); // filled for THIRDPARTY and dedicated-meter HYBRID rows; blank
                            // otherwise (OWN/PRIMARY/fallback-HYBRID/ENTRYPOINT) — a blank
                            // Customer means whole-Location grain, matching every Partner there.
    Role     : String(10); // HYBRID array entries only: 'PRIMARY' or 'HYBRID' — authoritative
                            // over Customer for scope grain, since a PRIMARY
                            // row's own Customer can carry a display-only placeholder value
                            // that must never be mistaken for a real dedicated-meter Partner
                            // scope. Blank/absent for OWN/THIRDPARTY/ENTRYPOINT, which decide
                            // scope grain from Customer presence alone, same as before.
  }
  type SegmentFilterT {
    OWN        : array of SegmentEntryT;
    HYBRID     : array of SegmentEntryT;
    THIRDPARTY : array of SegmentEntryT;
    ENTRYPOINT : array of SegmentEntryT;
    // Pre-run Data Issues "Continue past these" skip-list — replaces ExcludeLocations.
    // Excluded from processing regardless of which of the 4 arrays above a match would
    // otherwise fall into.
    Excluded   : array of SegmentEntryT;
  }
  type SelectionFilterT {
    TransportSystem  : array of String;
    DeliveryPoints   : array of String;
    RedeliveryPoints : array of String;
  }

  // TransportSystem (optional, comma-separated): when LocationFilter is empty,
  // resolves to that TS's Delivery/Redelivery points server-side — same
  // Gasday/TransportSystem/DeliveryPoint/RedeliveryPoint scenario routing as
  // BNS's xGMSxNOMSOURCE READ (balancingScheduling-service.js). Ignored when
  // LocationFilter is already present — an explicit point selection is always
  // passed through directly, same as BNS's Scenario B.
  function getScheduledNomItemsWithSCADA(Gasday: String, LocationFilter: String, TransportSystem: String)  returns array of ScheduledNomItemsWithSCADA;

  // Returns pre-computed aggregates from the backend cache for a given Gas Day.
  // Pass a comma-separated list of Location IDs to scope the totals to a subset.
  // TransportSystem (optional, comma-separated): same routing as
  // getScheduledNomItemsWithSCADA above — resolved to that TS's Delivery/
  // Redelivery points (in-memory cache filter, no remote fetch needed here)
  // only when LocationFilter is empty; ignored otherwise.
  // PartnerFilter (optional, comma-separated "Partner__Location" pairs): narrows the
  // THIRD-PARTY-scoped Location(s) within LocationFilter down to the selected
  // Customer(s) only — OWN/HYBRID/ENTRYPOINT stay Location-based regardless, since
  // they carry no pair of their own (see nomCache.computeSummary's own doc comment).
  function getNomSummary(Gasday: String, LocationFilter: String, TransportSystem: String, PartnerFilter: String) returns NomSummary;

  type ProcessTicketingResult {
    JobId  : String(36);
    Status : String(20); // SUBMITTED | NOT_SUBMITTED | EMPTY
  }

  // Backend-driven Ticketing (processTicketing.js): resolves eligible items from the cache
  // against the same SelectionFilter/SegmentFilter scope as RunAllocateSave, drops
  // locations failing meter/Rank/ARI006/nomination-drift/GCV-NCV-drift/balance checks,
  // then posts the survivors to S/4 ActualizeTicket in a background job. Poll
  // getProcessTicketingJobStatus with the returned JobId.
  @requires: 'AllocTicketing-Ticketing-Button'
  action   processTicketing(Gasday: Date, SelectionFilter: SelectionFilterT, SegmentFilter: SegmentFilterT) returns ProcessTicketingResult;


  // ── Button-level authorization — Simulate / Allocate & Save / Ticketing ─────
  // Independent flags, not a role hierarchy — a user may hold any subset. Backed
  // by the same XSUAA scopes the @requires annotations above enforce server-side;
  // this is only the frontend's "what should I show" read, never the enforcement
  // itself — every mutating action above still checks @requires independently
  // regardless of what the UI displays.
  type AllocTicketingAuth {
    canSimulate     : Boolean;
    canAllocateSave : Boolean;
    canTicket       : Boolean;
  }
  function getAllocTicketingAuth()                                              returns AllocTicketingAuth;

  // Compares the live GDA meter reading against the cached one for this Gas Day.
  // Invalidates the cache and returns the
  // changed location(s) when a reading changed; empty array when nothing changed or
  // nothing was cached yet. Called by the SCADA Reading / Scheduled Items refresh buttons.
  action   checkGdaReadingChanges(Gasday: String, LocationFilter: String)       returns array of SCADAChange;
  action   checkNominationChanges(Gasday: String)                               returns array of NominationChange;
  entity getAllTransportSystem       as
    projection on GMSValueHelps.xGMSxLocPoint_Map {
      key Tsyst,
          Tsnam,
          Vsart
    };
  entity getAllDeliveryPoints        as
    projection on GMSValueHelps.xGMSxLocPoint_Map {
      key Pblnr,
      key Tsyst,
      key Locid,
      key Pbltyp,
          Tsnam,
          Locnam,
          Delivery_Point,
          isDeliveryPoint,
          isInterconnect
    };
  entity getAllRedDeliveryPoints     as
    projection on GMSValueHelps.xGMSxLocPoint_Map {
      key Pblnr,
      key Tsyst,
      key Locid,
      key Pbltyp,
          Tsnam,
          Locnam,
          Redelivery_Point,
          isRedeliveryPoint,
          isInterconnect
    };
  entity getAllInterconnectPoints    as
    projection on GMSValueHelps.xGMSxLocPoint_Map {
      key Pblnr,
      key Tsyst,
      key Locid,
      key Pbltyp,
          Tsnam,
          Locnam,
          isInterconnect
    };

  @restrict: [
    { grant: 'CREATE', to: 'AllocTicketing-Ticketing-Button' },
    { grant: ['READ', 'UPDATE', 'DELETE'], to: 'any' }
  ]
  entity ActualizeTicket             as
    projection on TICKETSRV.ActualizeTicket {
      key Actualize,
      key ActualizeIC,
          to_DocFlow,
          to_Success,
          to_Errors,
          Date,
          Matnr,
          Locid,
          Nomit,
          Tsyst,
          Nomnr,
          virtual MassProcess         : Boolean,
          // Business Locations selected in the SCADA Measurements Entry Point tab
          // (allocationActions._getEntryPointSaveScope on the frontend) — a Delivery
          // Point unit (LocationType='DELIVERY') is only ticketed when its own Business
          // Location is in this array; empty/missing excludes every Delivery unit from
          // this run. A plain array of String, not the full SegmentFilterT struct used
          // by RunAllocateSave/processTicketing — CAP can't cast a virtual element of a
          // structured type inside a query projection's own column list.
          virtual EntrypointLocations : array of String,
          // Present only on the MassProcess:true reply — lets the frontend poll
          // getActualizeTicketJobStatus for this run's own background progress,
          // including any ARI006 Business Rule skip reasons (see that action's
          // own doc comment).
          virtual JobId               : String(36)
    };

  type ActualizeTicketSkip {
    Location : String(20);
    Message  : String(500);
  }

  // Background progress for one ActualizeTicket MassProcess:true submission — job
  // state lives in an in-memory map, same
  // "instances:1 only" constraint as ConfirmNominationJobStatus's _confirmJobs.
  type ActualizeTicketJobStatus {
    jobId          : String(36);
    status         : String(20); // SUBMITTED | RUNNING | COMPLETED | FAILED | NOT_FOUND
    totalUnits     : Integer;
    succeededUnits : Integer;
    failedUnits    : Integer;
    blockedUnits   : Integer; // ARI006 Business Rule-blocked, skipped before posting to S/4
    blockedSamples : array of ActualizeTicketSkip;
    startedAt      : DateTime;
    completedAt    : DateTime;
  }

  // Polls the status of a background job started by an ActualizeTicket
  // MassProcess:true submission (see that entity's own JobId field).
  function getActualizeTicketJobStatus(jobId: String(36))                      returns ActualizeTicketJobStatus;

  @Capabilities.InsertRestrictions.Insertable: false
  @Capabilities.DeleteRestrictions.Deletable : false
  @cds.persistence.skip
  entity ScheduledNomItems {

    key Location                : String(20);
        TicketKey               : String(20);
        // TicketKey only when Full Actualized (1/00) or Full Reversed (5/00), else '' — bound by the table
        TicketKeyDisplay        : String(20);
        TicketItem              : String(6);
        // Sourced straight off xGMSxNOMSOURCE's own TicketVersion field (sits right
        // alongside TicketKey/TicketItem/TicketPurpose there) — the frontend's Ticket
        // Key click handler (ticketDetail.js) needs it as an "adjacent property" to
        // read TicketDetailSet by its own compound key (TicketKey+TicketItem+
        // TicketVersion+Purpose) in a single round trip, instead of resolving it via
        // an ExecId lookup first.
        TicketVersion           : String(3);
        TicketPurpose           : String(1);
        TicketStatus            : String(2);
        TicketItemSubStatus     : String(1);
    key NominationKey           : String(20);
    key NominationItem          : String(10);
        Gasday                  : Date;

        LocationDesc            : String(100);

        // Location == whichever of DeliveryPoint/RedeliveryPoint carries the GDA/SCADA
        // reading (see getScheduledNomItemsWithSCADA). These carry both raw codes so
        // callers can tell which one Location actually is.
        DeliveryPoint           : String(20);
        DeliveryPointName       : String(100);
        RedeliveryPoint         : String(20);
        RedeliveryPointName     : String(100);
        LocationType            : String(10); // 'DELIVERY' | 'REDELIVERY'

        Contract                : String(20);
        CorrespondingDocNo      : String(10);
        ContractType            : String(10);
        ServiceType             : String(50);
        Source                  : String(20);

        TransportSystem         : String(10);
        TransportSystemName     : String(60);

        Rank                    : Integer;

        Material                : String(20);
        MaterialName            : String(100);

        ProposedDNQ             : Decimal(15, 3);
        PrevProposedDNQ         : Decimal(15, 3);
        PostBalancingDNQ        : Decimal(15, 3);
        UOM                     : String(10);

        ConversionQty           : Decimal(15, 3);
        ConversionUOM           : String(10);

        SavedAllocatedQty       : Decimal(15, 3);
        SavedAllocatedQty2      : Decimal(15, 3);
        SavedAllocatedUOM       : String(10);

        AVG_WT_GCV              : Decimal(15, 5);
        AVG_WT_NCV              : Decimal(15, 5);

        AllocatedQty            : Decimal(15, 3);
        AllocUOM                : String(10);
        // AllocatedQty converted to MBG via CONFIRMNOM_SRV ConversionRequest (display only)
        AllocatedQtyMBG         : Decimal(15, 3);

        Partner                 : String(20);
        PartnerName             : String(80);
        CustomerKind            : String(35);
        // True on OWN rows (CustomerKind blank) whose Location also carries a PRIMARY
        // nomination — those two rows share one allocation pool (runAllocation Gate 6).
        IsOwnPrimaryConnected   : Boolean;
        // Server-computed Customer Type column text/ValueState — plain single-value
        // fields so the UI binds them directly with no formatter/composite binding.
        CustomerTypeDisplay     : String(20);
        CustomerTypeState       : String(15);

        OverDrawlGSA            : Decimal(15, 3);
        UnderDrawlGSA           : Decimal(15, 3);
        AuthOverrunGTA          : Decimal(15, 3);
        UnauthOverrunGTA        : Decimal(15, 3);
        UnauthOverDrawlGSA      : Decimal(15, 3);

        // Raw OIJNOMI fields with no dedicated visible column of their own — surfaced
        // as hidden columns, same as the block below, user-toggleable via the
        // Scheduled Items column settings dialog.
        AuthOverDrawlGSA        : Decimal(15, 3);
        OverrunGTA              : Decimal(15, 3);
        DImbQty                 : Decimal(15, 3);
        CNomQty                 : Decimal(15, 3);
        CNomUOM                 : String(3);
        OijStatus               : String(15);

        // Raw OIJNOMI imbalance/adjustment fields (yyoij_*) — surfaced as hidden
        // columns, user-toggleable via the Scheduled Items column settings dialog.
        DPIQty                  : Decimal(13, 3);
        DNIQty                  : Decimal(13, 3);
        CumImbQty               : Decimal(13, 3);
        ChrgImbQty              : Decimal(13, 3);
        PosCumImbQty            : Decimal(13, 3);
        NegCumImbQty            : Decimal(13, 3);
        LiqAdjustQty            : Decimal(13, 3);
        LiqDamDiscQty           : Decimal(13, 3);
        SellOrPayAdjQty         : Decimal(13, 3);
        SellOrPayDiscQty        : Decimal(13, 3);
        SellersSFAdjQty         : Decimal(13, 3);
        SSFDiscQty              : Decimal(13, 3);
        TakeOrPayAdjQty         : Decimal(13, 3);
        TakeOrPayDiscQty        : Decimal(13, 3);
        GTAAdjust               : Boolean;
        GSAAdjust               : Boolean;
        GujDNQQty               : Decimal(13, 3);
        GujDNQUOM               : String(3);
        DDSQty                  : Decimal(13, 3);
  }
  // ── Gas Day Allocation — server-side flattened result types ─────────────────

  type GDAOwnRow {
    Yycustomer    : String(10);
    YybusLocation : String(10);
    YydateGas     : DateTime;
    YycumVolCm    : Decimal(15, 3);
    YyavgGcvCm    : Decimal(10, 4);
    YyavgNcvCm    : Decimal(10, 4);
    YytimeCm      : String(8);
    YycdateCm     : DateTime;
  }

  type GDAHybridRow {
    _type         : String(10);
    Yycustomer    : String(10);
    YybusLocation : String(10);
    YydateGas     : DateTime;
    _scadaVol     : Decimal(15, 3);
    _scadaMeter   : Decimal(15, 3);
    _bifurQty     : Decimal(15, 3);
    _allocQty     : Decimal(15, 3);
    YyavgGcvCm    : Decimal(10, 4);
    YyavgNcvCm    : Decimal(10, 4);
    _balState     : String(5);
    _balDiff      : Decimal(15, 3);
    _showBalance  : Boolean;
  }

  type GDATPRow {
    Yycustomer           : String(10);
    YybusLocation        : String(10);
    YydateGas            : DateTime;
    YyallocQtyNongail    : Decimal(15, 3);
    YyallocUomNongail    : String(10);
    YyallocQtyNongailscm : Decimal(15, 3);
    YygcvNgail           : Decimal(10, 4);
    YyncvNgail           : Decimal(10, 4);
    YrnameNongail        : String(100);
    YrnameNagal          : String(100);
    YydateNongail        : DateTime;
  }

  type GDAEntryPointRow {
    Yycustomer   : String(10);
    YydateGas    : DateTime;
    YvbelnEp     : String(10);
    YdpalcqtyEp  : Decimal(13, 3);
    YqtyuomEp    : String(3);
    // Resolved via Redelivery.Contract(==YvbelnEp) → CorrespondingDocNo → Delivery.Location —
    // the reading itself carries no location field. Blank if unresolved.
    Location     : String(20);
    LocationDesc : String(100);
  }

  type GasAllocationData {
    ownRows    : array of GDAOwnRow;
    hybridRows : array of GDAHybridRow;
    tpRows     : array of GDATPRow;
    epRows     : array of GDAEntryPointRow;
  }

  // Returns fully transformed Gas Day Allocation data for a given Gasday.
  // Gasday: ISO date string (yyyy-MM-dd).
  // Locations: optional comma-separated business location IDs to filter results.
  // TransportSystem (optional, comma-separated): same routing as
  // getScheduledNomItemsWithSCADA/getNomSummary — resolved to that TS's
  // Delivery/Redelivery points only when Locations is empty, ignored otherwise.
  function getGasAllocationData(Gasday: String, Locations: String, TransportSystem: String) returns GasAllocationData;

  type RunAllocateSaveIssue {
    Location : String(20);
    Partner  : String(10);
    Segment  : String(20);
    Reason   : String(500);
  }
  type RunAllocateSavePair {
    Partner  : String(10);
    Location : String(20);
  }
  type RunAllocateSaveResult {
    Gasday                         : Date;
    Mode                           : String(60);
    AllocatedCount                 : Integer;
    PassthroughDeliveryCount       : Integer;
    SavedToS4Count                 : Integer;
    SaveSuccess                    : Boolean;
    SaveErrors                     : array of String(500);
    EligibleLocations              : array of String(20);
    EligibleThirdPartyPairs        : array of RunAllocateSavePair;
    SkippedDueToMissingMeters      : array of RunAllocateSaveIssue;
    OrphanMetersWithoutNominations : array of RunAllocateSaveIssue;
    BlockedByTicketOrRank          : array of RunAllocateSaveIssue;
  }

  @requires: 'AllocTicketing-AllocateSave-Button'
  action   RunAllocateSave(Gasday: Date, SelectionFilter: SelectionFilterT, SegmentFilter: SegmentFilterT) returns RunAllocateSaveResult;

  type ProcessTicketingJobItem {
    NominationKey  : String(20);
    NominationItem : String(10);
    Partner        : String(10); // THIRD-PARTY items only — sent as ActualizeTicket Conpat
  }
  // Only the submitting user gets their own job back; anyone else gets NOT_FOUND.
  type ProcessTicketingJobStatus {
    jobId          : String(36);
    status         : String(20); // SUBMITTED | RUNNING | COMPLETED | FAILED | NOT_FOUND
    error          : String(500);
    gasday         : String(10);
    startedAt      : Timestamp;
    completedAt    : Timestamp;
    processedItems : array of ProcessTicketingJobItem;
  }

  @requires: 'AllocTicketing-Ticketing-Button'
  function getProcessTicketingJobStatus(jobId: String(36)) returns ProcessTicketingJobStatus;
}
