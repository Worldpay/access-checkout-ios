/// An enum containing possible session types that can be requested
public enum SessionType {
    /**
     Session type that represents a session that represents the card details
     This token can be further used with the Worldpay payments service.
     */
    case card

    /**
     Session type that represents a session that represents the cvc details
     This token can be further used with the Worldpay payments service.
     */
    case cvc
}
