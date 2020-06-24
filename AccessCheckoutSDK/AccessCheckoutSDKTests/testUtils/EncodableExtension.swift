@testable import AccessCheckoutSDK

extension AccessCheckoutError: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)

        let splitMessage = self.message.components(separatedBy: " : ")

        try container.encode(splitMessage[0], forKey: .errorName)
        try container.encode(splitMessage[1], forKey: .message)
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
