/// Represents a missing argument or incorrect argument that was passed by the merchant as part of the set up of the `generate session` or `validation` feature.
public struct AccessCheckoutIllegalArgumentError: Error, Equatable {
    public let message: String

    private init(message: String) {
        self.message = message
    }

    static func invalidExpiryDateFormat(expiryDate: String) -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(
            message: "Expected expiry date in format MM/YY or MMYY but found \(expiryDate)"
        )
    }

    static func missingAccessBaseUrl() -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(
            message: "Expected base url to be provided but was not"
        )
    }

    static func malformedAccessBaseUrl() -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(
            message: "Expected base url is invalid"
        )
    }

    static func missingCvc() -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(
            message: "Expected cvc to be provided but was not"
        )
    }

    static func missingExpiryDate() -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(
            message: "Expected expiry date to be provided but was not"
        )
    }

    static func missingCheckoutId() -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(
            message: "Expected checkout ID to be provided but was not"
        )
    }

    static func missingPan() -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(
            message: "Expected pan to be provided but was not"
        )
    }

    static func missingValidationDelegate() -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(
            message: "Expected validation delegate to be provided but was not"
        )
    }
}
