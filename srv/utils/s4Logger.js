module.exports = {

  logSuccess(result, req) {

    let message = "Operation successful";

    // SAP annotation messages
    if (result?.["@SAP__Messages"]?.length) {
      message = result["@SAP__Messages"]
        .map(m => m.message)
        .join(" | ");
    }

    // sap-messages header
    if (req?._?.res?.headers?.["sap-messages"]) {
      try {
        const parsed = JSON.parse(req._.res.headers["sap-messages"]);
        message = parsed.map(m => m.message).join(" | ");
      } catch (e) { }
    }

    console.log(" S4 SUCCESS MESSAGE:");
    console.log(message);
    console.log("--------------------------------------------------");

    return message;
  },

  logError(error) {

    let finalMessage = "Error during request to remote service";

    try {

      const responseData =
        error?.response?.data ||
        error?.response?.body ||
        error?.reason?.response?.data ||
        error?.reason?.response?.body ||
        error?.data;


      // 👇 ADD THIS DEBUG LINE HERE
      console.log("RAW S4 ERROR BODY:");
      console.log(JSON.stringify(responseData, null, 2));
      console.log("--------------------------------------------------");


      const parsed =
        typeof responseData === "string"
          ? JSON.parse(responseData)
          : responseData;

      const details =
        parsed?.error?.innererror?.errordetails;

      if (details?.length) {
        finalMessage = details.map(d => d.message).join(" | ");
      } else if (parsed?.error?.message?.value) {
        finalMessage = parsed.error.message.value;
      } else if (error?.message) {
        finalMessage = error.message;
      }

    } catch (e) { }

    console.error(" S4 ERROR MESSAGE:");
    console.error(finalMessage);
    console.error("--------------------------------------------------");

    return finalMessage;
  }

};