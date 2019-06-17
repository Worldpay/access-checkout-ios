import Foundation

/// Describes an Access Checkout error
public enum AccessCheckoutClientError: Error, Equatable {
    
    // MARK: Client errors
    
    /// The body within the request is empty
    case bodyIsEmpty(message: String?)
    
    /// The body within the request is not valid json
    case bodyIsNotJson(message: String?)
    
    /// The json body provided does not match the expected schema
    case bodyDoesNotMatchSchema(message: String?, validationErrors: [AccessCheckoutClientValidationError]?)
    
    /// Requested resource was not found
    case resourceNotFound(message: String?)
    
    /// Requested endpoint was not found
    case endpointNotFound(message: String?)
    
    /// Requested method is not allowed
    case methodNotAllowed(message: String?)
    
    /// Accept header is not supported
    case unsupportedAcceptHeader(message: String?)
    
    /// Content-type header is not supported
    case unsupportedContentType(message: String?)
    
    // MARK: Other errors
    
    /// Session could not be found
    case sessionNotFound(message: String?)
    
    /// Too many tokens created for this namespace
    case tooManyTokensForNamespace(message: String?)
    
    /// The card brand is not recognized
    case unrecognizedCardBrand(message: String?)
    
    /// Token expiry exceeds maximum time range
    case tokenExpiryDateExceededMaximum(message: String?)
    
    /// Card brand is not supported
    case unsupportedCardBrand(message: String?)
    
    /// Reference must be a valid value
    case fieldHasInvalidValue(message: String?, jsonPath: String?)
    
    /// Verification currency is not supported
    case unsupportedVerificationCurrency(message: String?, jsonPath: String?)
    
    /// Maximum number of updates for this token exceeded
    case maximumUpdatesExceeded(message: String?)
    
    /// API rate limit exceeded
    case apiRateLimitExceeded(message: String?)
    
    // MARK: Auth errors
    
    /// Unauthorized
    case unauthorized(message: String?)
    
    /// Invalid authentication credentials
    case invalidCredentials(message: String?)
    
    /// Access to the requested resource has been denied
    case accessDenied(message: String?)
    
    // MARK: Server errors
    
    /// Internal server error
    case internalServerError(message: String?)
    
    /// Payment instrument cannot be tokenized
    case notTokenizable(message: String?)
    
    /// Internal error: token not created
    case internalErrorTokenNotCreated(message: String?)
    
    // MARK: Discovery
    
    /// Access Checkout services undiscoverable
    case undiscoverable(message: String?)
    
    /// Unknown error
    case unknown(message: String?)
}

extension AccessCheckoutClientError: Codable {
    
    /// The name of the error
    public var errorName: String {
        switch self {
        case .bodyIsEmpty:
            return "bodyIsEmpty"
        case .bodyIsNotJson:
            return "bodyIsNotJson"
        case .bodyDoesNotMatchSchema:
            return "bodyDoesNotMatchSchema"
        case .resourceNotFound:
            return "resourceNotFound"
        case .endpointNotFound:
            return "endpointNotFound"
        case .methodNotAllowed:
            return "methodNotAllowed"
        case .unsupportedAcceptHeader:
            return "unsupportedAcceptHeader"
        case .unsupportedContentType:
            return "unsupportedContentType"
        case .sessionNotFound:
            return "sessionNotFound"
        case .tooManyTokensForNamespace:
            return "tooManyTokensForNamespace"
        case .unrecognizedCardBrand:
            return "unrecognizedCardBrand"
        case .tokenExpiryDateExceededMaximum:
            return "tokenExpiryDateExceededMaximum"
        case .unsupportedCardBrand:
            return "unsupportedCardBrand"
        case .fieldHasInvalidValue:
            return "fieldHasInvalidValue"
        case .unsupportedVerificationCurrency:
            return "unsupportedVerificationCurrency"
        case .maximumUpdatesExceeded:
            return "maximumUpdatesExceeded"
        case .apiRateLimitExceeded:
            return "apiRateLimitExceeded"
        case .unauthorized:
            return "unauthorized"
        case .invalidCredentials:
            return "invalidCredentials"
        case .accessDenied:
            return "accessDenied"
        case .internalServerError:
            return "internalServerError"
        case .notTokenizable:
            return "notTokenizable"
        case .internalErrorTokenNotCreated:
            return "internalErrorTokenNotCreated"
        case .undiscoverable:
            return "undiscoverable"
        case .unknown:
            return "unknown"
        }
    }
    
    private enum Key: CodingKey {
        case errorName
        case message
        case jsonPath
        case validationErrors
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let errorName = try container.decodeIfPresent(String.self, forKey: .errorName)
        let message = try container.decodeIfPresent(String.self, forKey: .message)
        let jsonPath = try container.decodeIfPresent(String.self, forKey: .jsonPath)
        let validationErrors = try container.decodeIfPresent([AccessCheckoutClientValidationError].self, forKey: .validationErrors)
        
        switch errorName {
        case AccessCheckoutClientError.bodyIsEmpty(message: message).errorName:
            self = .bodyIsEmpty(message: message)
        case AccessCheckoutClientError.bodyIsNotJson(message: message).errorName:
            self = .bodyIsNotJson(message: message)
        case AccessCheckoutClientError.bodyDoesNotMatchSchema(message: message,
                                                              validationErrors: validationErrors).errorName:
            self = .bodyDoesNotMatchSchema(message: message , validationErrors: validationErrors)
        case AccessCheckoutClientError.resourceNotFound(message: message).errorName:
            self = .resourceNotFound(message: message)
        case AccessCheckoutClientError.endpointNotFound(message: message).errorName:
            self = .endpointNotFound(message: message)
        case AccessCheckoutClientError.methodNotAllowed(message: message).errorName:
            self = .methodNotAllowed(message: message)
        case AccessCheckoutClientError.unsupportedAcceptHeader(message: message).errorName:
            self = .unsupportedAcceptHeader(message: message)
        case AccessCheckoutClientError.unsupportedContentType(message: message).errorName:
            self = .unsupportedContentType(message: message)
        case AccessCheckoutClientError.sessionNotFound(message: message).errorName:
            self = .sessionNotFound(message: message)
        case AccessCheckoutClientError.tooManyTokensForNamespace(message: message).errorName:
            self = .tooManyTokensForNamespace(message: message)
        case AccessCheckoutClientError.unrecognizedCardBrand(message: message).errorName:
            self = .unrecognizedCardBrand(message: message)
        case AccessCheckoutClientError.tokenExpiryDateExceededMaximum(message: message).errorName:
            self = .tokenExpiryDateExceededMaximum(message: message)
        case AccessCheckoutClientError.unsupportedCardBrand(message: message).errorName:
            self = .unsupportedCardBrand(message: message)
        case AccessCheckoutClientError.fieldHasInvalidValue(message: message, jsonPath: jsonPath).errorName:
            self = .fieldHasInvalidValue(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientError.unsupportedVerificationCurrency(message: message, jsonPath: jsonPath).errorName:
            self = .unsupportedVerificationCurrency(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientError.maximumUpdatesExceeded(message: message).errorName:
            self = .maximumUpdatesExceeded(message: message)
        case AccessCheckoutClientError.apiRateLimitExceeded(message: message).errorName:
            self = .apiRateLimitExceeded(message: message)
        case AccessCheckoutClientError.unauthorized(message: message).errorName:
            self = .unauthorized(message: message)
        case AccessCheckoutClientError.invalidCredentials(message: message).errorName:
            self = .invalidCredentials(message: message)
        case AccessCheckoutClientError.accessDenied(message: message).errorName:
            self = .accessDenied(message: message)
        case AccessCheckoutClientError.internalServerError(message: message).errorName:
            self = .internalServerError(message: message)
        case AccessCheckoutClientError.notTokenizable(message: message).errorName:
            self = .notTokenizable(message: message)
        case AccessCheckoutClientError.internalErrorTokenNotCreated(message: message).errorName:
            self = .internalErrorTokenNotCreated(message: message)
        case AccessCheckoutClientError.undiscoverable(message: message).errorName:
            self = .undiscoverable(message: message)
        case AccessCheckoutClientError.unknown(message: message).errorName:
            self = .unknown(message: message)
        default:
            let validationDescription = validationErrors?.map({ $0.localizedDescription }).joined(separator: "\n") ?? ""
            self = .unknown(message: "Unrecognised error: \(errorName ?? "") Message: \(message ?? "") JsonPath: \(jsonPath ?? "") Validation: \(validationDescription)")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .bodyIsEmpty(let message):
            try container.encode(AccessCheckoutClientError.bodyIsEmpty(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .bodyIsNotJson(let message):
            try container.encode(AccessCheckoutClientError.bodyIsNotJson(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .bodyDoesNotMatchSchema(let message, let validationErrors):
            try container.encode(AccessCheckoutClientError.bodyDoesNotMatchSchema(message: message,
                                                                                  validationErrors: validationErrors).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
            try container.encode(validationErrors, forKey: .validationErrors)
        case .resourceNotFound(let message):
            try container.encode(AccessCheckoutClientError.resourceNotFound(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .endpointNotFound(let message):
            try container.encode(AccessCheckoutClientError.endpointNotFound(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .methodNotAllowed(let message):
            try container.encode(AccessCheckoutClientError.methodNotAllowed(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .unsupportedAcceptHeader(let message):
            try container.encode(AccessCheckoutClientError.unsupportedAcceptHeader(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .unsupportedContentType(let message):
            try container.encode(AccessCheckoutClientError.unsupportedContentType(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .sessionNotFound(let message):
            try container.encode(AccessCheckoutClientError.sessionNotFound(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .tooManyTokensForNamespace(let message):
            try container.encode(AccessCheckoutClientError.tooManyTokensForNamespace(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .unrecognizedCardBrand(let message):
            try container.encode(AccessCheckoutClientError.unrecognizedCardBrand(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .tokenExpiryDateExceededMaximum(let message):
            try container.encode(AccessCheckoutClientError.tokenExpiryDateExceededMaximum(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .unsupportedCardBrand(let message):
            try container.encode(AccessCheckoutClientError.unsupportedCardBrand(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .fieldHasInvalidValue(let message, let jsonPath):
            try container.encode(AccessCheckoutClientError.fieldHasInvalidValue(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .unsupportedVerificationCurrency(let message, let jsonPath):
            try container.encode(AccessCheckoutClientError.unsupportedVerificationCurrency(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
            try container.encode(jsonPath, forKey: .jsonPath)
        case .maximumUpdatesExceeded(let message):
            try container.encode(AccessCheckoutClientError.maximumUpdatesExceeded(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .apiRateLimitExceeded(let message):
            try container.encode(AccessCheckoutClientError.apiRateLimitExceeded(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .unauthorized(let message):
            try container.encode(AccessCheckoutClientError.unauthorized(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .invalidCredentials(let message):
            try container.encode(AccessCheckoutClientError.invalidCredentials(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .accessDenied(let message):
            try container.encode(AccessCheckoutClientError.accessDenied(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .internalServerError(let message):
            try container.encode(AccessCheckoutClientError.internalServerError(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .notTokenizable(let message):
            try container.encode(AccessCheckoutClientError.notTokenizable(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .internalErrorTokenNotCreated(let message):
            try container.encode(AccessCheckoutClientError.internalErrorTokenNotCreated(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .undiscoverable(let message):
            try container.encode(AccessCheckoutClientError.undiscoverable(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        case .unknown(let message):
            try container.encode(AccessCheckoutClientError.unknown(message: message).errorName, forKey: .errorName)
            try container.encode(message, forKey: .message)
        }
    }
}

extension AccessCheckoutClientError: LocalizedError {
    
    /// The error description
    public var errorDescription: String? {
        switch self {
        case .bodyIsEmpty(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .bodyIsNotJson(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .bodyDoesNotMatchSchema(let message, let validationErrors):
            let validationDescription = validationErrors?.map({ $0.localizedDescription }).joined(separator: "\n") ?? ""
            return "Error: \(errorName) Message: \(message ?? "") \n Validation: \(validationDescription)"
        case .resourceNotFound(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .endpointNotFound(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .methodNotAllowed(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .unsupportedAcceptHeader(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .unsupportedContentType(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .sessionNotFound(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .tooManyTokensForNamespace(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .unrecognizedCardBrand(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .tokenExpiryDateExceededMaximum(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .unsupportedCardBrand(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .fieldHasInvalidValue(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .unsupportedVerificationCurrency(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .maximumUpdatesExceeded(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .apiRateLimitExceeded(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .unauthorized(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .invalidCredentials(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .accessDenied(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .internalServerError(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .notTokenizable(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .internalErrorTokenNotCreated(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .undiscoverable(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        case .unknown(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        }
    }
}
