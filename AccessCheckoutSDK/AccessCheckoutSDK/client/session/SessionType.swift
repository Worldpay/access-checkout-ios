/**
 An enum containing possible session types that can be requested
 */
public enum SessionType {
    /**
     Verified token session type that represents a card session
     This token can be further used with the Worldpay verified token service.
     */
    case verifiedTokens

    /**
     Payments cvc session type that represents a cvc session
     This token can be further used with the Worldpay payments service.
     */
    case paymentsCvc
}
