import Foundation

/**
 Represents an error that occurred while attempting to retrieve one or multiple sessions

 - message: `String` containing a description of the error that occured
 - validationErrors: an `Array` of `AccessCheckoutValidationError` containing more details about the error that occurred
 */
public struct AccessCheckoutError: Error, Equatable {
    let errorName: String
    public let message: String
    public let validationErrors: [AccessCheckoutValidationError]

    private init(errorName: String, details: String) {
        self.errorName = errorName
        self.message = "\(errorName) : \(details)"
        self.validationErrors = []
    }

    static func sessionLinkNotFound(linkName: String) -> AccessCheckoutError {
        return AccessCheckoutError(errorName: "sessionLinkNotFound", details: "Failed to find link \(linkName) in response")
    }

    static func discoveryLinkNotFound(linkName: String) -> AccessCheckoutError {
        return AccessCheckoutError(errorName: "discoveryLinkNotFound", details: "Failed to find link \(linkName) in response")
    }

    static func responseDecodingFailed() -> AccessCheckoutError {
        return AccessCheckoutError(errorName: "responseDecodingFailed", details: "Failed to decode response data")
    }

    static func unexpectedApiError(message: String) -> AccessCheckoutError {
        return AccessCheckoutError(errorName: "unexpectedApiError", details: message)
    }

    public struct AccessCheckoutValidationError: Error, Equatable {
        public let errorName: String
        public let message: String
        public let jsonPath: String
    }
}

extension AccessCheckoutError: Decodable {
    enum Key: CodingKey {
        case errorName
        case message
        case validationErrors
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        let errorName = try container.decodeIfPresent(String.self, forKey: .errorName) ?? ""
        let message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""

        self.errorName = errorName
        self.message = "\(errorName) : \(message)"
        self.validationErrors = try container.decodeIfPresent([AccessCheckoutValidationError].self, forKey: .validationErrors) ?? [AccessCheckoutValidationError]()
    }
}

extension AccessCheckoutError: LocalizedError {
    public var errorDescription: String? {
        let validationErrorsDescription = validationErrors.map { $0.localizedDescription }
            .joined(separator: "\n")

        return "Message: \(message)\n Validation: \(validationErrorsDescription)"
    }
}

/**
 Represents the details of the failure of a validation in Worldpay API services

 - errorName: `String` containing a descriptive name for an error as per Worldpay's internal API services implementation
 - message: `String` containing more details about the error that occurred
 - jsonPath: `String` that contains the field that provoked the validation failure
 */
extension AccessCheckoutError.AccessCheckoutValidationError: Decodable {
    enum Key: CodingKey {
        case errorName
        case message
        case jsonPath
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        self.errorName = try container.decodeIfPresent(String.self, forKey: .errorName) ?? ""
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.jsonPath = try container.decodeIfPresent(String.self, forKey: .jsonPath) ?? ""
    }
}

extension AccessCheckoutError.AccessCheckoutValidationError: LocalizedError {
    public var errorDescription: String? {
        return "Error: \(errorName) Message: \(message) JsonPath: \(jsonPath)"
    }
}
