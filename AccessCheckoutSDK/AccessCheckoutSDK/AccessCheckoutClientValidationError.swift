import Foundation

/// Describes an Access Checkout validation error
public enum AccessCheckoutClientValidationError: Error, Equatable {
    /// Field is not recognized
    case unrecognizedField(message: String?, jsonPath: String?)
    
    /// Reference must be a valid value
    case fieldHasInvalidValue(message: String?, jsonPath: String?)
    
    /// Mandatory field is missing
    case fieldIsMissing(message: String?, jsonPath: String?)
    
    /// String is too short
    case stringIsTooShort(message: String?, jsonPath: String?)
    
    /// String is too long
    case stringIsTooLong(message: String?, jsonPath: String?)
    
    /// The identified field contains a PAN that has failed the Luhn check
    case panFailedLuhnCheck(message: String?, jsonPath: String?)
    
    /// Field must be an integer
    case fieldMustBeInteger(message: String?, jsonPath: String?)
    
    /// Integer is too small
    case integerIsTooSmall(message: String?, jsonPath: String?)
    
    /// Integer is too large
    case integerIsTooLarge(message: String?, jsonPath: String?)
    
    /// Field must be numeric
    case fieldMustBeNumber(message: String?, jsonPath: String?)
    
    /// String failed regex
    case stringFailedRegexCheck(message: String?, jsonPath: String?)
    
    /// Date format invalid
    case dateHasInvalidFormat(message: String?, jsonPath: String?)
    
    /// Unknown error
    case unknown(message: String?)
}

extension AccessCheckoutClientValidationError: Codable {
    
    /// The name of the error
    public var errorName: String {
        switch self {
        case .unrecognizedField:
            return "unrecognizedField"
        case .fieldHasInvalidValue:
            return "fieldHasInvalidValue"
        case .fieldIsMissing:
            return "fieldIsMissing"
        case .stringIsTooShort:
            return "stringIsTooShort"
        case .stringIsTooLong:
            return "stringIsTooLong"
        case .panFailedLuhnCheck:
            return "panFailedLuhnCheck"
        case .fieldMustBeInteger:
            return "fieldMustBeInteger"
        case .integerIsTooSmall:
            return "integerIsTooSmall"
        case .integerIsTooLarge:
            return "integerIsTooLarge"
        case .fieldMustBeNumber:
            return "fieldMustBeNumber"
        case .stringFailedRegexCheck:
            return "stringFailedRegexCheck"
        case .dateHasInvalidFormat:
            return "dateHasInvalidFormat"
        case .unknown:
            return "unknown"
        }
    }
    
    private enum Key: CodingKey {
        case errorName
        case message
        case jsonPath
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let errorName = try container.decodeIfPresent(String.self, forKey: .errorName)
        let message = try container.decodeIfPresent(String.self, forKey: .message)
        let jsonPath = try container.decodeIfPresent(String.self, forKey: .jsonPath)
        
        switch errorName {
        case AccessCheckoutClientValidationError.unrecognizedField(message: message, jsonPath: jsonPath).errorName:
            self = .unrecognizedField(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientValidationError.fieldHasInvalidValue(message: message, jsonPath: jsonPath).errorName:
            self = .fieldHasInvalidValue(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientValidationError.fieldIsMissing(message: message, jsonPath: jsonPath).errorName:
            self = .fieldIsMissing(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientValidationError.stringIsTooShort(message: message, jsonPath: jsonPath).errorName:
            self = .stringIsTooShort(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientValidationError.stringIsTooLong(message: message, jsonPath: jsonPath).errorName:
            self = .stringIsTooLong(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientValidationError.panFailedLuhnCheck(message: message, jsonPath: jsonPath).errorName:
            self = .panFailedLuhnCheck(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientValidationError.fieldMustBeInteger(message: message, jsonPath: jsonPath).errorName:
            self = .fieldMustBeInteger(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientValidationError.integerIsTooSmall(message: message, jsonPath: jsonPath).errorName:
            self = .integerIsTooSmall(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientValidationError.integerIsTooLarge(message: message, jsonPath: jsonPath).errorName:
            self = .integerIsTooLarge(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientValidationError.fieldMustBeNumber(message: message, jsonPath: jsonPath).errorName:
            self = .fieldMustBeNumber(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientValidationError.stringFailedRegexCheck(message: message, jsonPath: jsonPath).errorName:
            self = .stringFailedRegexCheck(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientValidationError.dateHasInvalidFormat(message: message, jsonPath: jsonPath).errorName:
            self = .dateHasInvalidFormat(message: message, jsonPath: jsonPath)
        case AccessCheckoutClientValidationError.unknown(message: message).errorName:
            self = .unknown(message: message)
        default:
            self = .unknown(message: "Unrecognised error: \(errorName ?? "") Message: \(message ?? "") JsonPath: \(jsonPath ?? "")")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .unrecognizedField(let message, let jsonPath):
            try container.encode(AccessCheckoutClientValidationError.unrecognizedField(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encodeIfPresent(message, forKey: .message)
            try container.encodeIfPresent(jsonPath, forKey: .jsonPath)
        case .fieldHasInvalidValue(let message, let jsonPath):
            try container.encode(AccessCheckoutClientValidationError.fieldHasInvalidValue(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encodeIfPresent(message, forKey: .message)
            try container.encodeIfPresent(jsonPath, forKey: .jsonPath)
        case .fieldIsMissing(let message, let jsonPath):
            try container.encode(AccessCheckoutClientValidationError.fieldIsMissing(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encodeIfPresent(message, forKey: .message)
            try container.encodeIfPresent(jsonPath, forKey: .jsonPath)
        case .stringIsTooShort(let message, let jsonPath):
            try container.encode(AccessCheckoutClientValidationError.stringIsTooShort(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encodeIfPresent(message, forKey: .message)
            try container.encodeIfPresent(jsonPath, forKey: .jsonPath)
        case .stringIsTooLong(let message, let jsonPath):
            try container.encode(AccessCheckoutClientValidationError.stringIsTooLong(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encodeIfPresent(message, forKey: .message)
            try container.encodeIfPresent(jsonPath, forKey: .jsonPath)
        case .panFailedLuhnCheck(let message, let jsonPath):
            try container.encode(AccessCheckoutClientValidationError.panFailedLuhnCheck(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encodeIfPresent(message, forKey: .message)
            try container.encodeIfPresent(jsonPath, forKey: .jsonPath)
        case .fieldMustBeInteger(let message, let jsonPath):
            try container.encode(AccessCheckoutClientValidationError.fieldMustBeInteger(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encodeIfPresent(message, forKey: .message)
            try container.encodeIfPresent(jsonPath, forKey: .jsonPath)
        case .integerIsTooSmall(let message, let jsonPath):
            try container.encode(AccessCheckoutClientValidationError.integerIsTooSmall(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encodeIfPresent(message, forKey: .message)
            try container.encodeIfPresent(jsonPath, forKey: .jsonPath)
        case .integerIsTooLarge(let message, let jsonPath):
            try container.encode(AccessCheckoutClientValidationError.integerIsTooLarge(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encodeIfPresent(message, forKey: .message)
            try container.encodeIfPresent(jsonPath, forKey: .jsonPath)
        case .fieldMustBeNumber(let message, let jsonPath):
            try container.encode(AccessCheckoutClientValidationError.fieldMustBeNumber(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encodeIfPresent(message, forKey: .message)
            try container.encodeIfPresent(jsonPath, forKey: .jsonPath)
        case .stringFailedRegexCheck(let message, let jsonPath):
            try container.encode(AccessCheckoutClientValidationError.stringFailedRegexCheck(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encodeIfPresent(message, forKey: .message)
            try container.encodeIfPresent(jsonPath, forKey: .jsonPath)
        case .dateHasInvalidFormat(let message, let jsonPath):
            try container.encode(AccessCheckoutClientValidationError.dateHasInvalidFormat(message: message, jsonPath: jsonPath).errorName, forKey: .errorName)
            try container.encodeIfPresent(message, forKey: .message)
            try container.encodeIfPresent(jsonPath, forKey: .jsonPath)
        case .unknown(let message):
            try container.encode(AccessCheckoutClientValidationError.unknown(message: message).errorName, forKey: .errorName)
            try container.encodeIfPresent(message, forKey: .message)
        }
    }
}

extension AccessCheckoutClientValidationError: LocalizedError {
    /// The error description
    public var errorDescription: String? {
        switch self {
        case .unrecognizedField(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .fieldHasInvalidValue(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .fieldIsMissing(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .stringIsTooShort(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .stringIsTooLong(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .panFailedLuhnCheck(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .fieldMustBeInteger(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .integerIsTooSmall(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .integerIsTooLarge(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .fieldMustBeNumber(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .stringFailedRegexCheck(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .dateHasInvalidFormat(let message, let jsonPath):
            return "Error: \(errorName) Message: \(message ?? "") JsonPath: \(jsonPath ?? "")"
        case .unknown(let message):
            return "Error: \(errorName) Message: \(message ?? "")"
        }
    }
}
