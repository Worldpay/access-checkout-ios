class RetrieveCvcSessionHandler: RetrieveSessionHandler {
    private let apiClient: CvcSessionsApiClient

    init(apiClient: CvcSessionsApiClient) {
        self.apiClient = apiClient
    }

    func canHandle(sessionType: SessionType) -> Bool {
        return sessionType == SessionType.cvc
    }

    func handle(_ checkoutId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Swift.Result<String, AccessCheckoutError>) -> Void) {
        apiClient.createSession(baseUrl: baseUrl, checkoutId: checkoutId, cvc: cardDetails.cvc!, completionHandler: completionHandler)
    }
}
