enum StubResponse:String {
    case cardConfiguration = "CardConfiguration"
    case accessServicesRootSuccess = "Access-services-root-success"
    
    case sessionsRootSuccess = "Sessions-success"
    
    case cardSessionsPanFailedLuhnCheck = "Sessions-card-bodyDoesNotMatchSchema-panFailedLuhnCheck"
    case cardSessionSuccess = "Sessions-card-success"
    
    case cvcSessionError = "Sessions-paymentsCvc-error"
    case cvcSessionSuccess = "Sessions-paymentsCvc-success"
}
