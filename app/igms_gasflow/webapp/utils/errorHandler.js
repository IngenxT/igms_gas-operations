sap.ui.define([
    "sap/m/MessageBox",
    "sap/m/MessageToast",
    "sap/ui/core/Fragment"
], function (MessageBox, MessageToast, Fragment) {
    "use strict";

    /**
     * Error Handler Utility Class
     * Centralized error handling for the application
     */
    const ErrorHandler = {

        /**
         * Error severity levels
         */
        SEVERITY: {
            ERROR: "error",
            WARNING: "warning",
            INFO: "info",
            SUCCESS: "success"
        },

        /**
         * Error types for categorization
         */
        ERROR_TYPES: {
            VALIDATION: "validation",
            NETWORK: "network",
            BUSINESS_LOGIC: "business_logic",
            SYSTEM: "system",
            USER_ACTION: "user_action"
        },

        /**
         * Handle errors with different severity levels
         * @param {string} message - Error message to display
         * @param {Error|string} error - Error object or error string
         * @param {string} severity - Error severity (error, warning, info, success)
         * @param {boolean} showToUser - Whether to show error to user
         * @param {string} errorType - Type of error for logging
         * @param {Object} context - Additional context information
         */
        handleError: function (message, error, severity = "error", showToUser = true, errorType = "system", context = {}) {
            const errorMessage = error?.message || error || "";
            const fullMessage = (message && errorMessage && message !== errorMessage)
                ? `${message}: ${errorMessage}`
                : message || errorMessage || "Unknown error";

            // Log error with context
            this._logError(fullMessage, error, errorType, context);

            // Show to user if requested
            if (showToUser) {
                this._showUserMessage(fullMessage, severity);
            }
        },

        /**
         * Handle validation errors
         * @param {string} fieldName - Name of the field that failed validation
         * @param {string} validationMessage - Specific validation message
         * @param {boolean} showToUser - Whether to show to user
         */
        handleValidationError: function (fieldName, validationMessage, showToUser = true) {
            const message = `Validation failed for ${fieldName}: ${validationMessage}`;
            this.handleError(message, null, this.SEVERITY.WARNING, showToUser, this.ERROR_TYPES.VALIDATION, {
                fieldName: fieldName
            });
            this._logError(message, null, this.ERROR_TYPES.VALIDATION, { fieldName });
        },

        /**
         * Handle network/API errors
         */
        handleNetworkError: function (operation, error, showToUser = true) {
            const message = `Failed to ${operation}`;
            this.handleError(message, error, this.SEVERITY.ERROR, showToUser, this.ERROR_TYPES.NETWORK, { operation });
        },


        // Handle Backend Messages helper Start (Nikhil)

        handleBackendMessages: function (headerText = "Operation failed due to the following errors") {

            const oMessageManager = sap.ui.getCore().getMessageManager();
            const aMessages = oMessageManager.getMessageModel().getData();

            if (!aMessages.length) {
                MessageBox.error(headerText);
                return;
            }

            const uniqueMessages = new Set();

            aMessages.forEach(msg => {

                if (msg.message) {

                    msg.message.split("|").forEach(m => {

                        const clean = m.trim();

                        if (
                            clean &&
                            !clean.includes("Exception raised without specific error")
                        ) {
                            uniqueMessages.add(clean);
                        }

                    });

                }

            });

            const message =
                headerText +
                "\n\n• " +
                [...uniqueMessages].join("\n• ");

            MessageBox.error(message);

        },

        clearBackendMessages: function () {
            sap.ui.getCore().getMessageManager().removeAllMessages();
        },

        // Handle Backend Messages helper End

        /**
         * Handle business logic errors
         */
        handleBusinessError: function (operation, error, showToUser = true) {
            const message = `Business operation failed: ${operation}`;
            this.handleError(message, error, this.SEVERITY.ERROR, showToUser, this.ERROR_TYPES.BUSINESS_LOGIC, { operation });
        },

        /**
         * Handle user action errors
         */
        handleUserActionError: function (action, reason, showToUser = true) {
            const message = `Action failed: ${action}. ${reason}`;
            this.handleError(message, null, this.SEVERITY.WARNING, showToUser, this.ERROR_TYPES.USER_ACTION, { action, reason });
        },

        /**
         * Show success message
         */
        showSuccess: function (message) {
            MessageToast.show(message);
        },

        /**
         * Show information message
         */
        showInfo: function (message) {
            MessageBox.information(message);
        },

        /**
         * Show warning message
         */
        showWarning: function (message) {
            MessageBox.warning(message);
        },

        /**
         * Show confirmation dialog
         */
        showConfirmation: function (message, onConfirm, onCancel) {
            MessageBox.confirm(message, {
                onClose: function (action) {
                    if (action === MessageBox.Action.OK) {
                        if (onConfirm) onConfirm();
                    } else {
                        if (onCancel) onCancel();
                    }
                }
            });
        },

        /**
         * Create a simple message dialog
         */
        createMessageDialog: function (title, message, type = "Message") {
            const oDialog = new sap.m.Dialog({
                title: title,
                type: type,
                content: new sap.m.Text({ text: message }),
                beginButton: new sap.m.Button({
                    text: "Close",
                    press: function () { oDialog.close(); }
                }),
                afterClose: function () { oDialog.destroy(); }
            });
            oDialog.open();
            return oDialog;
        },

        /**
         * Handle async operations with error handling
         */
        handleAsyncOperation: function (asyncFunction, errorMessage, showToUser = true) {
            return asyncFunction().catch(error => {
                this.handleError(errorMessage, error, this.SEVERITY.ERROR, showToUser);
                throw error; // Re-throw to allow caller to handle if needed
            });
        },

        /**
         * Validate required fields
         */
        validateRequiredFields: function (fields, showToUser = true) {
            const missingFields = [];

            for (const [fieldName, value] of Object.entries(fields)) {
                if (!value || (typeof value === "string" && value.trim() === "")) {
                    missingFields.push(fieldName);
                }
            }

            if (missingFields.length > 0) {
                const message = `Please fill all mandatory fields: ${missingFields.join(", ")}`;

                // ✅ Use toast instead of blocking MessageBox
                if (showToUser) {
                    MessageToast.show(message);
                }

                // Log internally
                this._logError(message, null, this.ERROR_TYPES.VALIDATION, { missingFields });
                return false;
            }

            return true;
        },

        /**
         * Private method to log errors
         */
        _logError: function (message, error, errorType, context) {
            const timestamp = new Date().toISOString();
            const logEntry = {
                timestamp,
                message,
                errorType,
                context,
                stack: error?.stack,
                name: error?.name
            };

            console.error("Error Handler Log:", logEntry);
            // Optionally forward to external logging service
        },

        /**
         * Private method to show user messages
         */
        _showUserMessage: function (message, severity) {
            switch (severity) {
                case this.SEVERITY.ERROR:
                    MessageBox.error(message);
                    break;
                case this.SEVERITY.WARNING:
                    MessageBox.warning(message);
                    break;
                case this.SEVERITY.INFO:
                    MessageBox.information(message);
                    break;
                case this.SEVERITY.SUCCESS:
                    MessageToast.show(message);
                    break;
                default:
                    MessageBox.error(message);
            }
        }
    };

    return ErrorHandler;
});
