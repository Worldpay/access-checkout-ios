public enum AccessCheckoutClientInitialisationError: Error, Equatable {
    static let incompleteCardDetails_VTSession_PanIsMandatory = AccessCheckoutClientInitialisationError.incompleteCardDetails(message: "Card number is mandatory to retrieve a Verified Tokens session")
    static let incompleteCardDetails_VTSession_ExpiryMonthIsMandatory = AccessCheckoutClientInitialisationError.incompleteCardDetails(message: "Expiry Month is mandatory to retrieve a Verified Tokens session")
    static let incompleteCardDetails_VTSession_ExpiryYearIsMandatory = AccessCheckoutClientInitialisationError.incompleteCardDetails(message: "Expiry Year is mandatory to retrieve a Verified Tokens session")
    static let incompleteCardDetails_VTSession_CvcIsMandatory = AccessCheckoutClientInitialisationError.incompleteCardDetails(message: "Cvc is mandatory to retrieve a Verified Tokens session")
    static let incompleteCardDetails_CvcSession_CvcIsMandatory = AccessCheckoutClientInitialisationError.incompleteCardDetails(message: "Cvc is mandatory to retrieve a Payments Cvc session")
    
    case missingMerchantId
    case missingAccessBaseUrl
    case incompleteCardDetails(message: String)
}
