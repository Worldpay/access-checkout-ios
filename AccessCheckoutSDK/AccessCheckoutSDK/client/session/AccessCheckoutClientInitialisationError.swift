public enum AccessCheckoutClientInitialisationError: Error, Equatable {
    static let incompleteCardDetails_VTSession_PanIsMandatory = AccessCheckoutClientInitialisationError.incompleteCardDetails(message: "Card number is mandatory to retrieve a Verified Tokens session")
    static let incompleteCardDetails_VTSession_ExpiryDateIsMandatory = AccessCheckoutClientInitialisationError.incompleteCardDetails(message: "Expiry Date is mandatory to retrieve a Verified Tokens session")
    static let incompleteCardDetails_VTSession_CvcIsMandatory = AccessCheckoutClientInitialisationError.incompleteCardDetails(message: "Cvc is mandatory to retrieve a Verified Tokens session")
    static let incompleteCardDetails_CvcSession_CvcIsMandatory = AccessCheckoutClientInitialisationError.incompleteCardDetails(message: "Cvc is mandatory to retrieve a Payments Cvc session")
    static let invalidExpiryDateFormat_message = AccessCheckoutClientInitialisationError.invalidExpiryDateFormat(message: "Expiry date format is invalid. Formats supported are MM/YY or MMYY")

    case missingMerchantId
    case missingAccessBaseUrl
    case incompleteCardDetails(message: String)
    case invalidExpiryDateFormat(message: String)
}
