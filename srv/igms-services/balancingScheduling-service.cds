using {gasOpsService} from '../igms_service';
using {GMSCONFIRMNOM_SRV as GMSCONFIRMNOMSRV} from '../external/GMSCONFIRMNOM_SRV';
using {GMSNOMLOG_SRV as GMSNOMLOGSRV} from '../external/GMSNOMLOG_SRV';
using {GMSVALUEHELP_SRV as GMSValueHelps} from '../external/GMSVALUEHELP_SRV';

extend service gasOpsService {

    entity Conf_nomiSet       as
        projection on GMSCONFIRMNOMSRV.Conf_nomiSet {
            key Gasday
        };


    // entity ConfNomiSubset  as
    //     projection on GMSCONFIRMNOMSRV.Conf_nomi_subSet {
    //             Avggcv,
    //         key ContractNo,
    //             Mastercontno,
    //             Avgncv,
    //         key Gasday,
    //             Icindicator,
    //             GA_ID,
    //             IcAllocQty,
    //         key Item,
    //             GA_ID_DCQ,
    //             IcAllocUom,
    //         key NominationItem,
    //             Customer,
    //             GA_ID_PDNQ,
    //             GA_ID_SDNQ,
    //             Source,
    //             GA_ID_LOCDNQ,
    //             NominationKey,
    //             SoldToParty,
    //             Vendor,
    //             DocumentType,
    //             TransportSystem,
    //             Zstat,
    //             DeliveryDcq,
    //             RedeliveryDcq,
    //             Uom,
    //         key Versn,
    //         key DeliveryPoint,
    //             ProposedDnq,
    //             ApprovedDnq,
    //         key RedelivryPoint,
    //             RepublishDnq,
    //             ValidTo,
    //             ServiceProfile,
    //             ValidFrom,
    //             Material,
    //             SalesPurchInd,
    //             Timestamp,
    //             Event,
    //             Remarks,
    //             Flag,
    //             Action,
    //             Path,
    //             CustGrp,
    //             Createdby,
    //             Createddate,
    //             Createdtime,
    //             Changedby,
    //             Changeddate,
    //             Changedtime
    //     };


    // entity NomConversionItem    as
    //     projection on GMSCONFIRMNOM_SRV.ConversionItem {
    //             GCV,
    //             NCV,
    //         key NominationKey,
    //         key NominationItem,
    //             ScheduledQty,
    //             ScheduledUoM,
    //             TargetUoM,
    //             TargetQty,
    //             MsgType,
    //             Message
    //     };


    entity ConversionRequest  as
        projection on GMSCONFIRMNOMSRV.ConversionRequest {
            key RequestId
        };


    // entity NomiConfigurationSet     as
    //     projection on GMSCONFIRMNOMSRV.nom_configSet {
    //         key Docind,
    //         key Doctype,
    //         key schtype,
    //         key nomtype,
    //         key OL_OC
    //     };


    entity ConfirmNomReturns  as
        projection on GMSCONFIRMNOMSRV.toReturnSet {
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


    entity xGMSxNOMSOURCE     as
        projection on GMSCONFIRMNOMSRV.xGMSxNOMSOURCE {
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
                IsPrimaryContract,

                // ── CAP-local computed fields — not real S/4 columns, hence `virtual` ──
                // Populated by the READ handler (srv/serviceHandlers/balancingScheduling-service.js)
                // from the same ARI004 evaluation the confirm action uses (srv/utils/ari004Rules.js) —
                // a live preview of what this row would be approved at if confirmed right now.
                // Estimated as of the last table refresh; the confirm action always recomputes
                // fresh at posting time and is the only authoritative result.
                virtual ProjectedApprovedQty : Decimal(15, 3),
                virtual ProjectedCapRuleId   : String(40),
                virtual ProjectedStatus      : String(20), // OK | CAPPED | WOULD_REJECT
                // Unbundled CT — leg linked to an unbundled GSA: the GSA's DCQ & limits
                // used for Right to Cure in place of the leg's own (gtaRightToCure.js).
                virtual LinkedGsaNo          : String(10),
                virtual LinkedGsaDcq         : Decimal(15, 3),
                virtual LinkedGsaMinDcq      : Decimal(15, 3),
                virtual LinkedGsaMaxDcq      : Decimal(15, 3)
        };

    entity getLinkedContracts as
        projection on GMSCONFIRMNOMSRV.xGMSxLINKCONT_NOMSOURCE_JOIN {
            key ITEM,
            key LINKCONT,
                Contract_NO,
                linkcont_flag
        };

    entity ConfNomiLogSet     as
        projection on GMSNOMLOGSRV.ConfNomiLogSet {
            key Gasday,
            key ContractNo
        };

    @readonly
    entity GetNominationLogs  as
        projection on GMSNOMLOGSRV.xGMSxCONFIRMNOM_LOGS {
            key Gasday,
            key ContractNo,
            key NominationItem,
            key Timestamp,
            key MsgIndicator,
            key LogItem,
                DocumentType,
                NominationKey,
                Material,
                DeliveryPoint,
                RedelivryPoint,
                TransportSystem,
                Source,
                ProposedDnq,
                ApprovedDnq,
                Uom,
                Message,
                Createdby,
                Createddate,
                Createdtime
        };

    // ── Transport / Delivery / Redelivery value help — CSN Transport VH cascade ──
    // Delivery/Redelivery stay backed by LocPoint_MapSet. Transport System itself is
    // back on xGMSxLocPoint_Map — the SAME source Allocation & Ticketing's own
    // getAllTransportSystem already uses (ConfirmNomNAlloc_service.js) — because
    // unlike LocPoint_MapSet, xGMSxLocPoint_Map actually honors a server-side Vsart
    // filter, so the handler needs no local re-filter/full-table-scan workaround.
    @readonly
    entity CSNTransportSystem as
        projection on GMSValueHelps.xGMSxLocPoint_Map {
            key Tsyst,
                Tsnam,
                Vsart
        };

    @readonly
    entity CSNDeliveryPoint   as
        projection on GMSValueHelps.LocPoint_MapSet {
            key Pblnr,
            key Tsyst,
            key Locid,
            key Pbltyp,
                Tsnam,
                Locnam,
                isDeliveryPoint
        };

    @readonly
    entity CSNRedeliveryPoint as
        projection on GMSValueHelps.LocPoint_MapSet {
            key Pblnr,
            key Tsyst,
            key Locid,
            key Pbltyp,
                Tsnam,
                Locnam,
                isRedeliveryPoint
        };
}
