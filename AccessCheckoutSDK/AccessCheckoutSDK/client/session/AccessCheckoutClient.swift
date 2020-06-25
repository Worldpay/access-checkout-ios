public struct AccessCheckoutClient {
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
    
    public func generateSessions(cardDetails: CardDetails, sessionTypes: Set<SessionType>, completionHandler: @escaping (Result<[SessionType: String], AccessCheckoutError>) -> Void) throws {
        try sessionTypes.forEach {
            try cardDetailsForSessionTypeValidator.validate(cardDetails: cardDetails, for: $0)
        }
        
        let resultsHandler: RetrieveSessionResultsHandler = RetrieveSessionResultsHandler(numberOfExpectedResults: sessionTypes.count, completeWith: completionHandler)
        sessionTypes.forEach { sessionType in
            retrieveSessionHandlerDispatcher.dispatch(merchantId, baseUrl, cardDetails, sessionType) { result in
                resultsHandler.handle(result, for: sessionType)
            }
        }
    }
}
