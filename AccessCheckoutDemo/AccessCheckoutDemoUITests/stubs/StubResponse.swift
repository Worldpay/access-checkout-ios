enum StubResponse:String {
    case cardConfiguration = "CardConfiguration"
    case discoverySuccess = "Discovery-success"
    
    case verifiedTokensRootSuccess = "VerifiedTokens-success"
    case verifiedTokensSessionsPanFailedLuhnCheck = "VerifiedTokens-bodyDoesNotMatchSchema-panFailedLuhnCheck"
    case verifiedTokensSessionSuccess = "VerifiedTokensSession-success"
    
    case sessionsRootSuccess = "Sessions-success"
    case sessionsPaymentsCvcError = "Sessions-paymentsCvc-error"
    case sessionsPaymentsCvcSuccess = "Sessions-paymentsCvc-success"
}
