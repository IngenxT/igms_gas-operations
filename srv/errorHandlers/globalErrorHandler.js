/**
 * Universal Production-Grade CAP Error Handler
 * Handles ALL error types: HANA Cloud, SQLite, S/4 HANA, OData, CAP Framework
 */

/**
 * Comprehensive Error Mapping - All CAP Ecosystem Errors
 */



const { logError: extractS4ErrorMessage } = require('../utils/s4Logger');

const UNIVERSAL_ERROR_MAPPINGS = {
  // ============================================
  // HANA CLOUD DATABASE ERRORS
  // ============================================

  
  // SQL Error Code 301 - Unique Constraint Violations
  '301': { 
    httpStatus: 409, 
    code: 'DUPLICATE_ENTRY', 
    retryable: false,
    pattern: /unique constraint violated/i
  },
  
  // SQL Error Code 402 - NOT NULL Constraint
  '402': { 
    httpStatus: 400, 
    code: 'REQUIRED_FIELD_MISSING', 
    retryable: false,
    pattern: /not null constraint/i
  },
  
  // SQL Error Code 403 - Foreign Key Constraint  
  '403': { 
    httpStatus: 400, 
    code: 'INVALID_REFERENCE', 
    retryable: false,
    pattern: /foreign key constraint/i
  },
  
  // ============================================
  // SQLITE DATABASE ERRORS (Development)
  // ============================================
  
  'SQLITE_CONSTRAINT_NOTNULL': { 
    httpStatus: 400, 
    code: 'REQUIRED_FIELD_MISSING', 
    retryable: false 
  },
  'SQLITE_CONSTRAINT_PRIMARYKEY': { 
    httpStatus: 409, 
    code: 'DUPLICATE_ENTRY', 
    retryable: false 
  },
  'SQLITE_CONSTRAINT_UNIQUE': { 
    httpStatus: 409, 
    code: 'DUPLICATE_ENTRY', 
    retryable: false 
  },
  'SQLITE_CONSTRAINT_FOREIGNKEY': { 
    httpStatus: 400, 
    code: 'INVALID_REFERENCE', 
    retryable: false 
  },
  'SQLITE_CONSTRAINT_CHECK': { 
    httpStatus: 400, 
    code: 'VALIDATION_ERROR', 
    retryable: false 
  },
  'SQLITE_BUSY': { 
    httpStatus: 503, 
    code: 'SERVICE_BUSY', 
    retryable: true 
  },

  // ============================================
  // CAP FRAMEWORK ERRORS
  // ============================================
  
  'BAD_REQUEST': { 
    httpStatus: 400, 
    code: 'INVALID_REQUEST', 
    retryable: false 
  },
  'UNAUTHORIZED': { 
    httpStatus: 401, 
    code: 'UNAUTHORIZED', 
    retryable: false 
  },
  'FORBIDDEN': { 
    httpStatus: 403, 
    code: 'FORBIDDEN', 
    retryable: false 
  },
  'NOT_FOUND': { 
    httpStatus: 404, 
    code: 'NOT_FOUND', 
    retryable: false 
  },
  'METHOD_NOT_ALLOWED': { 
    httpStatus: 405, 
    code: 'METHOD_NOT_ALLOWED', 
    retryable: false 
  },
  'NOT_ACCEPTABLE': { 
    httpStatus: 406, 
    code: 'NOT_ACCEPTABLE', 
    retryable: false 
  },
  'CONFLICT': { 
    httpStatus: 409, 
    code: 'CONFLICT', 
    retryable: false 
  },
  'PAYLOAD_TOO_LARGE': { 
    httpStatus: 413, 
    code: 'PAYLOAD_TOO_LARGE', 
    retryable: false 
  },
  'UNSUPPORTED_MEDIA_TYPE': { 
    httpStatus: 415, 
    code: 'UNSUPPORTED_MEDIA_TYPE', 
    retryable: false 
  },
  'TOO_MANY_REQUESTS': { 
    httpStatus: 429, 
    code: 'RATE_LIMITED', 
    retryable: true 
  },

  // ============================================
// CAP / AXIOS ERRORS
// ============================================

'ERR_BAD_REQUEST': {
  httpStatus: 400,
  code: 'VALIDATION_ERROR',
  retryable: false
},

  // ============================================
  // S/4 HANA INTEGRATION ERRORS
  // ============================================
  
  'REMOTE_SERVICE_ERROR': { 
    httpStatus: 502, 
    code: 'UPSTREAM_ERROR', 
    retryable: true 
  },
  'BAD_GATEWAY': { 
    httpStatus: 502, 
    code: 'UPSTREAM_ERROR', 
    retryable: true 
  },
  'SERVICE_UNAVAILABLE': { 
    httpStatus: 503, 
    code: 'SERVICE_UNAVAILABLE', 
    retryable: true 
  },
  'GATEWAY_TIMEOUT': { 
    httpStatus: 504, 
    code: 'TIMEOUT', 
    retryable: true 
  },

  'S4_BUSINESS_ERROR': {
  httpStatus: 400,
  code: 'VALIDATION_ERROR',
  retryable: false
  },

  'S4_TECHNICAL_ERROR': {
  httpStatus: 502,
  code: 'UPSTREAM_ERROR',
  retryable: true
  },

  // ============================================
  // NETWORK & CONNECTIVITY ERRORS
  // ============================================
  
  'EHDB_CONNECTION_FAILED': { 
    httpStatus: 503, 
    code: 'SERVICE_UNAVAILABLE', 
    retryable: true 
  },
  'ETIMEDOUT': { 
    httpStatus: 504, 
    code: 'TIMEOUT', 
    retryable: true 
  },
  'ECONNREFUSED': { 
    httpStatus: 503, 
    code: 'SERVICE_UNAVAILABLE', 
    retryable: true 
  },
  'ENOTFOUND': { 
    httpStatus: 503, 
    code: 'SERVICE_UNAVAILABLE', 
    retryable: true 
  },
  'CERTIFICATE_ERROR': { 
    httpStatus: 502, 
    code: 'UPSTREAM_ERROR', 
    retryable: false 
  },
  'CONNECTIVITY_ERROR': { 
    httpStatus: 503, 
    code: 'SERVICE_UNAVAILABLE', 
    retryable: true 
  },

  // ============================================
  // TRANSACTION & CONCURRENCY ERRORS
  // ============================================
  
  'DEADLOCK_DETECTED': { 
    httpStatus: 409, 
    code: 'CONFLICT', 
    retryable: true 
  },
  'TRANSACTION_ROLLBACK': { 
    httpStatus: 500, 
    code: 'INTERNAL_ERROR', 
    retryable: true 
  },
  'OPTIMISTIC_LOCK_FAILED': { 
    httpStatus: 409, 
    code: 'RESOURCE_MODIFIED', 
    retryable: false 
  },
  'PESSIMISTIC_LOCK_TIMEOUT': { 
    httpStatus: 423, 
    code: 'RESOURCE_LOCKED', 
    retryable: true 
  },

  // ============================================
  // SYSTEM RESOURCE ERRORS
  // ============================================
  
  'OUT_OF_MEMORY': { 
    httpStatus: 503, 
    code: 'SERVICE_UNAVAILABLE', 
    retryable: false 
  },
  'STACK_OVERFLOW': { 
    httpStatus: 500, 
    code: 'INTERNAL_ERROR', 
    retryable: false 
  },
  'EVENT_LOOP_BLOCKED': { 
    httpStatus: 503, 
    code: 'SERVICE_BUSY', 
    retryable: true 
  }
};

/**
 * User-friendly error messages
 */
const ERROR_MESSAGES = {
  'REQUIRED_FIELD_MISSING': 'Required information is missing. Please provide all mandatory fields.',
  'DUPLICATE_ENTRY': 'This record already exists. Please use different values.',
  'INVALID_REFERENCE': 'The referenced item does not exist or is no longer available.',
  'VALIDATION_ERROR': 'The provided data does not meet validation requirements.',
  'INVALID_REQUEST': 'The request contains invalid data.',
  'UNAUTHORIZED': 'Authentication required.',
  'FORBIDDEN': 'Access denied.',
  'NOT_FOUND': 'The requested resource was not found.',
  'METHOD_NOT_ALLOWED': 'This operation is not allowed.',
  'NOT_ACCEPTABLE': 'The request format is not acceptable.',
  'CONFLICT': 'The request conflicts with the current state.',
  'PAYLOAD_TOO_LARGE': 'The request is too large. Please reduce the data size.',
  'UNSUPPORTED_MEDIA_TYPE': 'The request format is not supported.',
  'RESOURCE_MODIFIED': 'The resource has been modified by another user. Please refresh and try again.',
  'RESOURCE_LOCKED': 'The resource is currently locked. Please try again later.',
  'RATE_LIMITED': 'Too many requests. Please try again later.',
  'UPSTREAM_ERROR': 'An external service error occurred. Please try again later.',
  'SERVICE_UNAVAILABLE': 'Service is temporarily unavailable. Please try again later.',
  'SERVICE_BUSY': 'Service is currently busy. Please try again shortly.',
  'TIMEOUT': 'Request timed out. Please try again.',
  'INTERNAL_ERROR': 'An internal error occurred. Please contact support if this persists.'
};

/**
 * Extract correlation ID from request headers
 */
function getCorrelationId(req) {
  return req.headers?.['x-correlation-id'] || 
         req.headers?.['x-request-id'] || 
         req.headers?.['correlation-id'] || 
         req.headers?.['request-id'] || 
         'missing-correlation-id';
}

/**
 * Intelligent Error Detection - Analyzes error patterns
 */
function detectErrorType(error, originalMessage) {

  // S/4 OData error structure
if (error?.response?.data?.error || error?.response?.body?.error) {

  const s4Error = error.response.data?.error || error.response.body?.error || error.reason?.response?.data?.error || error.reason?.response?.body?.error ;

  if (s4Error?.innererror?.errordetails?.length) {
    return {
      type: 'S4_BUSINESS_ERROR',
      httpStatus: 400,
      code: 'VALIDATION_ERROR'
    };
  }

  return {
    type: 'S4_TECHNICAL_ERROR',
    httpStatus: 502,
    code: 'UPSTREAM_ERROR'
  };

}

  if (!originalMessage || typeof originalMessage !== 'string') {
    return null;
  }

  const message = originalMessage.toLowerCase();

  // HANA Cloud Error Patterns
  if (message.includes('unique constraint violated') || 
      message.includes('unique constraint violation')) {
    return {
      type: 'HANA_UNIQUE_CONSTRAINT',
      httpStatus: 409,
      code: 'DUPLICATE_ENTRY'
    };
  }

  if (message.includes('not null constraint') || 
      message.includes('null value not allowed')) {
    return {
      type: 'HANA_NOT_NULL_CONSTRAINT',
      httpStatus: 400,
      code: 'REQUIRED_FIELD_MISSING'
    };
  }

  if (message.includes('foreign key constraint') ||
      message.includes('referential integrity')) {
    return {
      type: 'HANA_FOREIGN_KEY_CONSTRAINT',
      httpStatus: 400,
      code: 'INVALID_REFERENCE'
    };
  }

  // SQL Error Code Detection (HANA)
  const sqlErrorMatch = message.match(/\[sql-(\d+)\]|\[(\d+)\]/);
  if (sqlErrorMatch) {
    const errorCode = sqlErrorMatch[1] || sqlErrorMatch[2];
    if (UNIVERSAL_ERROR_MAPPINGS[errorCode]) {
      return {
        type: `HANA_SQL_${errorCode}`,
        ...UNIVERSAL_ERROR_MAPPINGS[errorCode]
      };
    }
  }

  // OData Error Patterns
  if (message.includes('content type') && message.includes('not part of accepted')) {
    return {
      type: 'ODATA_CONTENT_TYPE_ERROR',
      httpStatus: 406,
      code: 'NOT_ACCEPTABLE'
    };
  }

  if (message.includes('payload too large') || message.includes('request entity too large')) {
    return {
      type: 'ODATA_PAYLOAD_TOO_LARGE',
      httpStatus: 413,
      code: 'PAYLOAD_TOO_LARGE'
    };
  }

  // Connectivity Error Patterns
  if (message.includes('connection refused') || message.includes('econnrefused')) {
    return {
      type: 'CONNECTIVITY_REFUSED',
      httpStatus: 503,
      code: 'SERVICE_UNAVAILABLE'
    };
  }

  if (message.includes('timeout') || message.includes('etimedout')) {
    return {
      type: 'NETWORK_TIMEOUT',
      httpStatus: 504,
      code: 'TIMEOUT'
    };
  }

  if (message.includes('certificate') || message.includes('ssl') || message.includes('tls')) {
    return {
      type: 'CERTIFICATE_ERROR',
      httpStatus: 502,
      code: 'UPSTREAM_ERROR'
    };
  }

  // S/4 HANA Integration Patterns
  if (message.includes('destination') && message.includes('not found')) {
    return {
      type: 'DESTINATION_NOT_FOUND',
      httpStatus: 503,
      code: 'SERVICE_UNAVAILABLE'
    };
  }

  if (message.includes('unauthorized') || message.includes('authentication')) {
    return {
      type: 'AUTHENTICATION_ERROR',
      httpStatus: 401,
      code: 'UNAUTHORIZED'
    };
  }

  return null;
}

/**
 * Extract field name from error messages
 */
function extractFieldFromError(message) {
  if (!message || typeof message !== 'string') {
    return null;
  }

  // SQLite pattern: "constraint failed: TableName.fieldName"
  const sqliteMatch = message.match(/constraint failed: \w+\.(\w+)/i);
  if (sqliteMatch) {
    return sqliteMatch[1];
  }

  // HANA pattern: "key: FIELDNAME=value already exists"
  const hanaKeyMatch = message.match(/key:\s*(\w+)=/i);
  if (hanaKeyMatch) {
    return hanaKeyMatch[1];
  }

  // HANA table pattern: extract field from detailed error
  const hanaTableMatch = message.match(/constraint='([^']+)'/i);
  if (hanaTableMatch && hanaTableMatch[1] !== '$trexexternalkey$') {
    return hanaTableMatch[1];
  }

  return null;
}

/**
 * Create enhanced user message
 */
function createUserMessage(errorType, originalMessage, mapping) {


  // ✅ Always show S4 business messages
  if (originalMessage && originalMessage !== "Unknown error occurred" ) {
    return originalMessage;
  }

  if (!mapping) {
    return originalMessage || 
      'An unexpected error occurred. Please try again or contact support.';
  }

  const baseMessage = ERROR_MESSAGES[mapping.code];
  const field = extractFieldFromError(originalMessage);

   // Preserve S4 business messages
  if (errorType === 'S4_BUSINESS_ERROR' && originalMessage) {
    return originalMessage;
  } 

  // Enhance message with field information for constraint errors
  if (field && mapping.code === 'REQUIRED_FIELD_MISSING') {
    return `${field} is required and cannot be empty.`;
  }

  if (field && mapping.code === 'DUPLICATE_ENTRY') {
    return `${field} must be unique. This value already exists.`;
  }

  if (field && mapping.code === 'INVALID_REFERENCE') {
    return `Invalid ${field}. The referenced item does not exist.`;
  }

  return baseMessage || originalMessage || 'An unexpected error occurred.';
}

/**
 * Create secure log entry
 */
function createSecureLogEntry(error, req, mapping, errorType, originalMessage) {
  const correlationId = getCorrelationId(req);
  
  return {
    correlationId,
    errorType: errorType || 'UNKNOWN',
    errorCode: error.code || 'UNKNOWN_ERROR',
    httpStatus: mapping?.httpStatus || 500,
    timestamp: new Date().toISOString(),
    method: req.method,
    path: req.path?.replace(/\/[0-9a-f-]{36}/gi, '/{id}'),
    userId: req.user?.id || 'anonymous',
    tenant: req.tenant || 'unknown',
    remoteService: error?.response?.config?.url || error?.config?.url || 'unknown',
    originalMessage: originalMessage?.substring(0, 300), // Limit for security
    userAgent: req.headers?.['user-agent']?.substring(0, 100),
    sourceIP: req.ip || req.connection?.remoteAddress,
    ...(process.env.NODE_ENV === 'development' && { 
      stack: error.stack?.split('\n').slice(0, 5).join('\n')
    })
  };
}

/**
 * ****************************************************
 * MAIN ERROR HANDLER - Single Function Entry Point
 * ****************************************************
 * 
 * Usage: errorHandler(req, error)
 * 
 * @param {Object} req - CAP request object
 * @param {Error|Object} error - Any error from CAP ecosystem
 */
function errorHandler(req, error) {
  try {
    // Normalize error information
    let errorCode = error.code || error.response?.status || error.error?.code || 'UNKNOWN_ERROR';
    // const originalMessage = error.message || error.error?.message || 'Unknown error occurred';

    let originalMessage =
  error.message ||
  error.error?.message ||
  error.response?.data?.error?.message?.value ||
  error.response?.body?.error?.message?.value ||
  'Unknown error occurred';

// Try extracting S4 message using s4Logger
  try {
    const s4Message = extractS4ErrorMessage(error);
    if (s4Message && s4Message !== "Error during request to remote service") {
    originalMessage = s4Message;
    }
  } catch (e) {}
    
    // Ensure errorCode is a string for processing
    if (typeof errorCode !== 'string') {
      errorCode = String(errorCode || 'UNKNOWN_ERROR');
    }

    const correlationId = getCorrelationId(req);

    // First try direct mapping
    let mapping = UNIVERSAL_ERROR_MAPPINGS[errorCode];
    let errorType = errorCode;

    // If no direct mapping, use intelligent detection
    if (!mapping) {
      const detected = detectErrorType(error, originalMessage);
      if (detected) {
        mapping = {
          httpStatus: detected.httpStatus,
          code: detected.code,
          retryable: detected.retryable || false
        };
        errorType = detected.type;
      }
    }

    // Final fallback mapping
    if (!mapping) {
      // Try to infer from HTTP status codes
      if (typeof errorCode === 'string' && /^[0-9]+$/.test(errorCode)) {
        const statusCode = parseInt(errorCode, 10);
        if (statusCode >= 400 && statusCode < 500) {
          mapping = {
            httpStatus: statusCode,
            code: statusCode === 401 ? 'UNAUTHORIZED' : 
                  statusCode === 403 ? 'FORBIDDEN' :
                  statusCode === 404 ? 'NOT_FOUND' :
                  statusCode === 409 ? 'CONFLICT' : 'INVALID_REQUEST',
            retryable: false
          };
        } else if (statusCode >= 500) {
          mapping = {
            httpStatus: statusCode,
            code: 'INTERNAL_ERROR',
            retryable: true
          };
        }
      }
    }

    // Ultimate fallback
    if (!mapping) {
      mapping = {
        httpStatus: 500,
        code: 'INTERNAL_ERROR',
        retryable: false
      };
      errorType = 'UNHANDLED_ERROR';
    }

    // Create user-friendly message
const userMessage = originalMessage && originalMessage !== "Error during request to remote service"
    ? originalMessage
    : createUserMessage(errorType, originalMessage, mapping);

    // Determine log severity and category
    const isSecuritySensitive = ['UNAUTHORIZED', 'FORBIDDEN'].includes(mapping.code);
    const isSystemError = mapping.httpStatus >= 500;
    
    // Create secure log entry
    const logEntry = createSecureLogEntry(error, req, mapping, errorType, originalMessage);

    // Log based on error classification
    if (isSecuritySensitive) {
      console.error('[SECURITY_EVENT]', {
        ...logEntry,
        severity: 'HIGH',
        category: 'SECURITY'
      });
    } else if (isSystemError) {
      console.error('[SYSTEM_ERROR]', {
        ...logEntry,
        severity: 'HIGH',
        category: 'SYSTEM'
      });
    } else {
      console.warn('[APPLICATION_ERROR]', {
        ...logEntry,
        severity: 'LOW',
        category: 'APPLICATION'
      });
    }

    // Set security and operational headers
    if (req.res) {
      req.res.set({
        'X-Content-Type-Options': 'nosniff',
        'X-Frame-Options': 'DENY',
        'X-XSS-Protection': '1; mode=block',
        'X-Correlation-ID': correlationId
      });

      // Set retry-after header for retryable errors
      if (mapping.retryable) {
        const retryAfter = mapping.code === 'RATE_LIMITED' ? 60 : 
                          mapping.code === 'SERVICE_BUSY' ? 30 : 
                          mapping.code === 'SERVICE_UNAVAILABLE' ? 60 : 30;
        req.res.set('Retry-After', retryAfter);
      }
    }

    // Create CAP-compatible error object
    const capError = Object.assign(new Error(userMessage), {
      code: mapping.httpStatus,
      '@Common.numericSeverity': mapping.httpStatus >= 500 ? 4 : 3,
      _context: {
        originalCode: errorCode,
        errorType,
        correlationId,
        timestamp: new Date().toISOString(),
        retryable: mapping.retryable
      }
    });

    // Throw the error - CAP handles the response formatting
    throw capError;

  } catch (handlerError) {
    // If this is our intended error, re-throw it
    if (handlerError._context) {
      throw handlerError;
    }
    
    // Fallback error handling for unexpected errors in the handler
    const correlationId = getCorrelationId(req);
    
    console.error('[ERROR_HANDLER_FAILURE]', {
      originalError: error?.message || 'Unknown error',
      handlerError: handlerError.message,
      handlerStack: handlerError.stack,
      correlationId,
      timestamp: new Date().toISOString(),
      errorType: typeof error?.code,
      errorCodeValue: error?.code
    });
    
    // Create fallback CAP error
    const fallbackError = Object.assign(new Error('An unexpected error occurred. Please try again or contact support.'), {
      code: 500,
      '@Common.numericSeverity': 4,
      _context: {
        originalCode: 'ERROR_HANDLER_FAILURE',
        errorType: 'HANDLER_FAILURE',
        correlationId,
        timestamp: new Date().toISOString(),
        retryable: false
      }
    });
    
    throw fallbackError;
  }
}

/**
 * Health check helper for monitoring
 */
function getErrorHandlerStats() {
  return {
    version: '1.0.0',
    supportedDatabases: ['HANA Cloud', 'SQLite'],
    supportedIntegrations: ['S/4 HANA', 'OData V2/V4', 'CAP Framework'],
    totalErrorMappings: Object.keys(UNIVERSAL_ERROR_MAPPINGS).length,
    environment: process.env.NODE_ENV || 'development',
    timestamp: new Date().toISOString()
  };
}

module.exports = {
  errorHandler,
  getErrorHandlerStats,
  UNIVERSAL_ERROR_MAPPINGS,
  ERROR_MESSAGES,
  detectErrorType,
  extractFieldFromError
};