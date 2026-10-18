const cds = require('@sap/cds');

const confirmNomNAllocHandler = require('./serviceHandlers/ConfirmNomNAlloc_service');
const allocationTicketingHandler = require('./serviceHandlers/allocationTicketing');
const nominationSchedulingConfirm = require('./serviceHandlers/balancingScheduling-service');
const sharedLookupsHandler = require('./serviceHandlers/sharedLookups');

module.exports = cds.service.impl(async (srv) => {
        await confirmNomNAllocHandler(srv);
        await allocationTicketingHandler(srv);
        await nominationSchedulingConfirm(srv);
        await sharedLookupsHandler(srv);
})
