public struct AccessCheckoutIllegalArgumentError: Error, Equatable {
    public let message: String
    
    init(message: String) {
        self.message = message
    }
    
    static func invalidExpiryDateFormat(expiryDate: String) -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(message: "Expected expiry date in format MM/YY or MMYY but found \(expiryDate)")
    }
    
    static func missingAccessBaseUrl() -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(message: "Expected base url to be provided but was not")
    }
    
    static func missingCvc() -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(message: "Expected cvc to be provided but was not")
    }
    
    static func missingExpiryDate() -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(message: "Expected expiry date to be provided but was not")
    }
    
    static func missingMerchantId() -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(message: "Expected merchant ID to be provided but was not")
    }
    
    static func missingPan() -> AccessCheckoutIllegalArgumentError {
        return AccessCheckoutIllegalArgumentError(message: "Expected pan to be provided but was not")
    }
}
