class AccessCheckoutClientImpl: AccessCheckoutClient {
    private let merchantId: String
    private let baseUrl: String
    private let retrieveSessionHandlerDispatcher: RetrieveSessionHandlerDispatcher
    
    init(merchantId: String, baseUrl: String, retrieveSessionHandlerDispatcher: RetrieveSessionHandlerDispatcher) {
        self.merchantId = merchantId
        self.baseUrl = baseUrl
        self.retrieveSessionHandlerDispatcher = retrieveSessionHandlerDispatcher
    }
    
    public func generateSession(cardDetails: CardDetails, sessionType: SessionType, completionHandler: @escaping (Result<String, AccessCheckoutClientError>) -> Void) {
        retrieveSessionHandlerDispatcher.dispatch(merchantId, baseUrl, cardDetails, sessionType, completionHandler: completionHandler)
    }
}
