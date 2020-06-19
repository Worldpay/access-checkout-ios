@testable import AccessCheckoutSDK

extension AccessCheckoutError: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)

        try container.encode(errorName, forKey: .errorName)
        try container.encode(message, forKey: .message)
        try container.encode(validationErrors, forKey: .validationErrors)
    }
}

extension AccessCheckoutError.ValidationError: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)

        try container.encodeIfPresent(errorName, forKey: .errorName)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(jsonPath, forKey: .jsonPath)
    }
}
