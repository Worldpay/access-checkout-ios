class RetrieveSessionHandlerDispatcher {
    private let retrieveSessionHandlers: [RetrieveSessionHandler]

    init(retrieveSessionHandlers: [RetrieveSessionHandler]) {
        self.retrieveSessionHandlers = retrieveSessionHandlers
    }

    func dispatch(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, _ sessionType: SessionType, completionHandler: @escaping (Result<String, AccessCheckoutError>) -> Void) {
        for handler in retrieveSessionHandlers {
            if handler.canHandle(sessionType: sessionType) {
                handler.handle(merchantId, baseUrl, cardDetails, completionHandler: completionHandler)
            }
        }
    }
}
