class RetrieveCardSessionHandler: RetrieveSessionHandler {
    private let apiClient: CardSessionsApiClient

    init(apiClient: CardSessionsApiClient) {
        self.apiClient = apiClient
    }

    func canHandle(sessionType: SessionType) -> Bool {
        return sessionType == SessionType.card
    }

    func handle(
        _ checkoutId: String,
        _ baseUrl: String,
        _ cardDetails: CardDetails,
        completionHandler: @escaping (Swift.Result<String, AccessCheckoutError>) -> Void
    ) {
        apiClient.createSession(
            baseUrl: baseUrl,
            checkoutId: checkoutId,
            pan: cardDetails.pan!,
            expiryMonth: cardDetails.expiryMonth!,
            expiryYear: cardDetails.expiryYear!,
            cvc: cardDetails.cvc!,
            completionHandler: completionHandler
        )
    }
}
