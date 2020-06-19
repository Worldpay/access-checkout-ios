import Foundation

/// Describes an Access Checkout error
public struct AccessCheckoutError: Error, Equatable {
    public let errorName: String
    public let message: String
    public let validationErrors: [ValidationError]

    init(errorName: String, message: String, validationErrors:[ValidationError]) {
        self.errorName = errorName
        self.message = message
        self.validationErrors = validationErrors
    }

    init(errorName: String, message: String) {
        self.errorName = errorName
        self.message = message
        self.validationErrors = []
    }

    static func sessionLinkNotFound(linkName: String) -> AccessCheckoutError {
        return AccessCheckoutError(errorName: "sessionLinkNotFound", message: "Failed to find link \(linkName) in response")
    }

    static func discoveryLinkNotFound(linkName: String) -> AccessCheckoutError {
        return AccessCheckoutError(errorName: "discoveryLinkNotFound", message: "Failed to find link \(linkName) in response")
    }

    static func responseDecodingFailed() -> AccessCheckoutError {
        return AccessCheckoutError(errorName: "responseDecodingFailed", message: "Failed to decode response data")
    }

    static func unexpectedApiError(message: String) -> AccessCheckoutError {
        return AccessCheckoutError(errorName: "unexpectedApiError", message: message)
    }

    public struct ValidationError: Error, Equatable {
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

        self.errorName = try container.decodeIfPresent(String.self, forKey: .errorName) ?? ""
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.validationErrors = try container.decodeIfPresent([ValidationError].self, forKey: .validationErrors) ?? [ValidationError]()
    }
}

extension AccessCheckoutError: LocalizedError {
    public var errorDescription: String? {
        let validationErrorsDescription = validationErrors.map { $0.localizedDescription }
            .joined(separator: "\n")

        return "Error: \(errorName) Message: \(message) \n Validation: \(validationErrorsDescription)"
    }
}

extension AccessCheckoutError.ValidationError: Decodable {
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

extension AccessCheckoutError.ValidationError: LocalizedError {
    public var errorDescription: String? {
        return "Error: \(errorName) Message: \(message) JsonPath: \(jsonPath)"
    }
}
