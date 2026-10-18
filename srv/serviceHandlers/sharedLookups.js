const cds = require('@sap/cds');
const { errorHandler } = require('../errorHandlers/globalErrorHandler');

module.exports = async (srv) => {
  const GMSVALUEHELP_SRV = await cds.connect.to("GMSVALUEHELP_SRV");
  const igmsConfigMetaData = await cds.connect.to("igmsConfigMetaData");

  srv.on('READ', 'materiallMaster', req => GMSVALUEHELP_SRV.run(req.query));

  srv.on('READ', 'getBusinessRule', async (req) => {
    try {
      return await igmsConfigMetaData.run(req.query);
    } catch (error) {
      return errorHandler(req, error, "Error while reading getBusinessRule");
    }
  });
};
