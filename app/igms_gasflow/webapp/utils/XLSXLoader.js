sap.ui.define([], function () {
  "use strict";

  let _loadPromise = null;

  return {
    /**
     * Lazily loads libs/xlsx.full.min.js from the app's local libs folder.
     * Safe to call multiple times — the script is injected only once.
     * @returns {Promise<void>}
     */
    load() {
      if (_loadPromise) return _loadPromise;

      if (typeof XLSX !== "undefined") {
        _loadPromise = Promise.resolve();
        return _loadPromise;
      }

      const sUrl = sap.ui.require.toUrl("com/ingenx/igmsgasflow/libs/xlsx.full.min.js");

      _loadPromise = new Promise((resolve, reject) => {
        const oScript = document.createElement("script");
        oScript.src = sUrl;
        oScript.onload = resolve;
        oScript.onerror = () => reject(new Error("XLSXLoader: failed to load " + sUrl));
        document.head.appendChild(oScript);
      });

      return _loadPromise;
    }
  };
});
