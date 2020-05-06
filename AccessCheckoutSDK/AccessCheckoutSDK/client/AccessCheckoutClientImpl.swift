class AccessCheckoutClientImpl: AccessCheckoutClient {
    private let merchantId: String
    private let baseUrl: String
    private let cardDetailsForSessionTypeValidator: CardDetailsForSessionTypeValidator
    private let retrieveSessionHandlerDispatcher: RetrieveSessionHandlerDispatcher
    
    init(merchantId: String, baseUrl: String, _ cardDetailsForSessionTypeValidator: CardDetailsForSessionTypeValidator,
         _ retrieveSessionHandlerDispatcher: RetrieveSessionHandlerDispatcher) {
        self.merchantId = merchantId
        self.baseUrl = baseUrl
        self.cardDetailsForSessionTypeValidator = cardDetailsForSessionTypeValidator
        self.retrieveSessionHandlerDispatcher = retrieveSessionHandlerDispatcher
    }
    
    public func generateSession(cardDetails: CardDetails, sessionType: SessionType, completionHandler: @escaping (Result<String, AccessCheckoutClientError>) -> Void) throws {
        try cardDetailsForSessionTypeValidator.validate(cardDetails: cardDetails, for: sessionType)
        
        retrieveSessionHandlerDispatcher.dispatch(merchantId, baseUrl, cardDetails, sessionType, completionHandler: completionHandler)
    }
}
