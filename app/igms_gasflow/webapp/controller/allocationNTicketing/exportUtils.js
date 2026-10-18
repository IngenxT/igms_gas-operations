sap.ui.define([
    "sap/m/MessageBox",
    "com/ingenx/igmsgasflow/utils/XLSXLoader"
], (MessageBox, XLSXLoader) => {
    "use strict";

    // ── Allocation & Ticketing — Excel export ──────────────────────────────────
    // Single responsibility: export the SCADA Measurement tabs (client-side
    // SheetJS) and the Scheduled Items table, main or Expand-dialog variant
    // (sap.ui.export.Spreadsheet), to .xlsx.
    return {
        /** File-name part for exports: "2026-10-14", or "2026-10-14_2026-10-16" for a range. */
        _getExportGasDayLabel: function () {
            const aDays = this._currentGasDays || [];
            if (!aDays.length) return "export";
            const sFirst = aDays[0];
            const sLast = aDays[aDays.length - 1];
            return sFirst === sLast ? sFirst : sFirst + "_" + sLast;
        },

        onExportScada: async function () {
            const sGasDay = this._getExportGasDayLabel();

            // ── Column maps: { label, property, isNumber } ────────────────────
            const ownCols = [
                { label: "Customer",              property: "Yycustomer"        },
                { label: "Business Location",     property: "YybusLocation"     },
                { label: "Gas Day",               property: "_gasDay",          isDate: true },
                { label: "Meter Reading (SM3)",   property: "YycumVolCm",       isNum: true  },
                { label: "Qty to Allocate (SM3)", property: "YycumVolCm",       isNum: true  },
                { label: "Avg Wt GCV",            property: "YyavgGcvCm",       isNum: true  },
                { label: "Avg Wt NCV",            property: "YyavgNcvCm",       isNum: true  },
                { label: "Meter Reading DT",      property: "YycdateCm",        isDate: true }
            ];
            const hybridCols = [
                { label: "Customer",              property: "Yycustomer"        },
                { label: "Business Location",     property: "YybusLocation"     },
                { label: "Gas Day",               property: "_gasDay",          isDate: true },
                { label: "Role",                  property: "_type",            transform: v => v === "SECONDARY" ? "HYBRID" : v },
                { label: "Meter Reading (SM3)",   property: "_scadaMeter",      isNum: true  },
                { label: "Customer Qty (SM3)",    property: "_bifurQty",        isNum: true  },
                { label: "Qty to Allocate (SM3)", property: "_allocQty",        isNum: true  },
                { label: "Avg Wt GCV",            property: "YyavgGcvCm",       isNum: true  },
                { label: "Avg Wt NCV",            property: "YyavgNcvCm",       isNum: true  }
            ];
            const tpCols = [
                { label: "Customer",              property: "Yycustomer"        },
                { label: "Business Location",     property: "YybusLocation"     },
                { label: "Entity Name",           property: "YrnameNongail"     },
                { label: "Gas Day",               property: "_gasDay",          isDate: true },
                { label: "Customer Qty (SM3)",    property: "YyallocQtyNongail",isNum: true  },
                { label: "Qty to Allocate (SM3)", property: "YyallocQtyNongailscm",isNum: true  },
                { label: "Avg Wt GCV",            property: "YygcvNgail",       isNum: true  },
                { label: "Avg Wt NCV",            property: "YyncvNgail",       isNum: true  },
                { label: "UOM",                   property: "YyallocUomNongail" },
                { label: "Alloc DT",              property: "YydateNongail",    isDate: true }
            ];
            const epCols = [
                { label: "Gas Day",               property: "_gasDay",          isDate: true },
                { label: "Customer",              property: "Yycustomer"        },
                { label: "Business Location",     property: "Location"          },
                { label: "Location Desc.",        property: "LocationDesc"      },
                { label: "Contract No",           property: "YvbelnEp"          },
                { label: "Allocated Qty (SM3)",   property: "YalcsqtyEp",      isNum: true  }
            ];

            // ── Convert a raw model array into flat row objects keyed by label ─
            const fmtDate = this.fmtDate.bind(this);
            const _toRows = (aRaw, aCols) => aRaw.map(r => {
                const row = {};
                for (const col of aCols) {
                    const val = r[col.property];
                    let out;
                    if (col.isNum) {
                        out = parseFloat(val) || 0;
                    } else if (col.isDate) {
                        out = val == null ? "" : val instanceof Date ? fmtDate(val) : String(val);
                    } else {
                        out = val == null ? "" : String(val);
                    }
                    row[col.label] = col.transform ? col.transform(out) : out;
                }
                return row;
            });

            const ownData    = _toRows(this.getView().getModel("ownModel").getData()    || [], ownCols);
            const hybridData = _toRows(
                (this.getView().getModel("hybridModel").getData() || []).filter(r => r._type !== "GROUP"),
                hybridCols
            );
            const tpData     = _toRows(this.getView().getModel("tpModel").getData()     || [], tpCols);
            const epData     = _toRows(
                (this.getView().getModel("epModel").getData() || []).filter(r => r._type !== "GROUP"),
                epCols
            );

            if (!ownData.length && !hybridData.length && !tpData.length && !epData.length) {
                MessageBox.information("No SCADA data to export. Please select a Gas Day and press Go.");
                return;
            }

            // ── Build workbook using SheetJS (already bundled in libs/) ────────
            try {
                await XLSXLoader.load();
                const wb = XLSX.utils.book_new();
                XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(ownData),    "Own Pipeline");
                XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(hybridData), "Hybrid");
                XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(tpData),     "Third Party");
                XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(epData),     "Entry Point");
                XLSX.writeFile(wb, "SCADA_ALL_" + sGasDay + ".xlsx");
            } catch (e) {
                MessageBox.error("Export failed: " + (e?.message || "Please try again."));
            }
        },

        onExportScheduledItems: function () {
            this._exportNomItems("IdANTTicketItemTbl");
        },

        onExportScheduledItemsExpand: function () {
            this._exportNomItems("IdTicketExpandTable");
        },

        _exportNomItems: async function (sTableId) {
            const oTable   = this.byId(sTableId);
            const oBinding = oTable?.getBinding("rows");
            const nLen     = oBinding?.getLength?.() ?? 0;

            if (!oBinding || !nLen) {
                MessageBox.information("No data to export.");
                return;
            }

            this._showBusy("Preparing export...");
            try {
                const sGasDay = this._getExportGasDayLabel();

                // Fetch all rows so formatters can be applied before writing to Excel
                const aContexts = await oBinding.requestContexts(0, nLen);
                const aData = aContexts.map(ctx => {
                    const d = ctx.getObject();
                    return Object.assign({}, d, {
                        GasDayDisplay:       this.formatDate(d.Gasday),
                        GTAAdjustDisplay:    d.GTAAdjust ? "Yes" : "No",
                        GSAAdjustDisplay:    d.GSAAdjust ? "Yes" : "No"
                    });
                });

                await new Promise((resolve, reject) => {
                    sap.ui.require(["sap/ui/export/Spreadsheet", "sap/ui/export/EdmType"], (Spreadsheet, EdmType) => {
                        const oSettings = {
                            workbook: {
                                columns: [
                                    { label: "Gas Day",              property: "GasDayDisplay",        type: EdmType.String           },
                                    { label: "Customer Type",        property: "CustomerTypeDisplay",  type: EdmType.String           },
                                    { label: "Partner",              property: "Partner",              type: EdmType.String           },
                                    { label: "Partner Desc.",        property: "PartnerName",          type: EdmType.String           },
                                    { label: "Location",             property: "Location",             type: EdmType.String           },
                                    { label: "Location Desc.",       property: "LocationDesc",         type: EdmType.String           },
                                    { label: "Contract No.",         property: "Contract",             type: EdmType.String           },
                                    { label: "Contract Type",        property: "ContractType",         type: EdmType.String           },
                                    { label: "Rank",                 property: "Rank",                 type: EdmType.String           },
                                    { label: "Service Type",         property: "ServiceType",          type: EdmType.String           },
                                    { label: "Transport System",     property: "TransportSystem",      type: EdmType.String           },
                                    { label: "Transport Desc.",      property: "TransportSystemName",  type: EdmType.String           },
                                    { label: "Nom Key",              property: "NominationKey",        type: EdmType.String           },
                                    { label: "Material",             property: "Material",             type: EdmType.String           },
                                    { label: "Material Name",        property: "MaterialName",         type: EdmType.String           },
                                    { label: "Proposed DNQ Qty",     property: "ProposedDNQ",          type: EdmType.Number, scale: 3 },
                                    { label: "UOM",                  property: "UOM",                  type: EdmType.String           },
                                    { label: "DNQ in Meter UOM",     property: "ConversionQty",        type: EdmType.Number, scale: 3 },
                                    { label: "Conv. UOM",            property: "ConversionUOM",        type: EdmType.String           },
                                    { label: "Saved Alloc Qty",      property: "SavedAllocatedQty",    type: EdmType.Number, scale: 3 },
                                    { label: "Saved Qty UOM",        property: "SavedAllocatedUOM",    type: EdmType.String           },
                                    { label: "Allocated Qty",        property: "AllocatedQty",         type: EdmType.Number, scale: 3 },
                                    { label: "Alloc. UOM",           property: "AllocUOM",             type: EdmType.String           },
                                    { label: "MBG Conversion Qty",   property: "AllocatedQtyMBG",      type: EdmType.Number, scale: 3 },
                                    { label: "Over Drawl (GSA)",     property: "OverDrawlGSA",         type: EdmType.Number, scale: 3 },
                                    { label: "Authorized Over draw", property: "AuthOverDrawlGSA",     type: EdmType.Number, scale: 3 },
                                    { label: "Under Drawl (GSA)",    property: "UnderDrawlGSA",        type: EdmType.Number, scale: 3 },
                                    { label: "Auth. Overrun (GTA)",  property: "AuthOverrunGTA",       type: EdmType.Number, scale: 3 },
                                    { label: "Unauth. Overrun (GTA)",property: "UnauthOverrunGTA",     type: EdmType.Number, scale: 3 },
                                    { label: "Unauth. Over Drawl (GSA)", property: "UnauthOverDrawlGSA", type: EdmType.Number, scale: 3 },
                                    { label: "Avg Wt GCV",           property: "AVG_WT_GCV",           type: EdmType.Number, scale: 3 },
                                    { label: "Avg Wt NCV",           property: "AVG_WT_NCV",           type: EdmType.Number, scale: 3 },
                                    { label: "Overrun(GTA)",         property: "OverrunGTA",           type: EdmType.Number, scale: 3 },
                                    { label: "Daily Imbalance(GTA)", property: "DImbQty",              type: EdmType.Number, scale: 3 },
                                    { label: "Contractual Nominate", property: "CNomQty",              type: EdmType.Number, scale: 3 },
                                    { label: "Cont Nom. UOM",        property: "CNomUOM",              type: EdmType.String           },
                                    { label: "Status",               property: "OijStatus",            type: EdmType.String           },
                                    { label: "DPI Quantity",         property: "DPIQty",               type: EdmType.Number, scale: 3 },
                                    { label: "DNI Quantity",         property: "DNIQty",               type: EdmType.Number, scale: 3 },
                                    { label: "Cumulative Imb Qty",   property: "CumImbQty",            type: EdmType.Number, scale: 3 },
                                    { label: "Chrg Imb Qty",         property: "ChrgImbQty",           type: EdmType.Number, scale: 3 },
                                    { label: "Cum +ve Imb Qty",      property: "PosCumImbQty",         type: EdmType.Number, scale: 3 },
                                    { label: "Cum -ve Imb Qty",      property: "NegCumImbQty",         type: EdmType.Number, scale: 3 },
                                    { label: "Liq. Adjust Qty",      property: "LiqAdjustQty",         type: EdmType.Number, scale: 3 },
                                    { label: "Liq. Dam. Disc Qty",   property: "LiqDamDiscQty",        type: EdmType.Number, scale: 3 },
                                    { label: "Sell or Pay Adj Qty",  property: "SellOrPayAdjQty",      type: EdmType.Number, scale: 3 },
                                    { label: "Sell or Pay Disc qty", property: "SellOrPayDiscQty",     type: EdmType.Number, scale: 3 },
                                    { label: "Sellers SF Adj Qty",   property: "SellersSFAdjQty",      type: EdmType.Number, scale: 3 },
                                    { label: "SSF disc",             property: "SSFDiscQty",           type: EdmType.Number, scale: 3 },
                                    { label: "Take or Pay Adj Qty",  property: "TakeOrPayAdjQty",      type: EdmType.Number, scale: 3 },
                                    { label: "Take or Pay Disc qty", property: "TakeOrPayDiscQty",     type: EdmType.Number, scale: 3 },
                                    { label: "SOP/LD adjusted",      property: "GTAAdjustDisplay",     type: EdmType.String           },
                                    { label: "TOP/SSF Adjusted",     property: "GSAAdjustDisplay",     type: EdmType.String           },
                                    { label: "Qty for Gujrat DNQ",   property: "GujDNQQty",            type: EdmType.Number, scale: 3 },
                                    { label: "UOM for Gujrat DNQ",   property: "GujDNQUOM",            type: EdmType.String           },
                                    { label: "DDS Qty",              property: "DDSQty",               type: EdmType.Number, scale: 3 }
                                ]
                            },
                            dataSource: aData,
                            fileName: "ScheduledItems_" + sGasDay + ".xlsx"
                        };
                        const oSpreadsheet = new Spreadsheet(oSettings);
                        oSpreadsheet.build().then(resolve).catch(reject).finally(() => oSpreadsheet.destroy());
                    });
                });
            } catch (e) {
                MessageBox.error("Export failed. Please try again.");
            } finally {
                this._hideBusy();
            }
        },
    };
});
