class PaymentsCvcRetrieveSessionHandler: RetrieveSessionHandler {
    private let apiClient: SessionsApiClient

    init(apiClient: SessionsApiClient) {
        self.apiClient = apiClient
    }

    func canHandle(sessionType: SessionType) -> Bool {
        return sessionType == SessionType.cvc
    }

    func handle(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Swift.Result<String, AccessCheckoutError>) -> Void) {
        apiClient.createSession(baseUrl: baseUrl, merchantId: merchantId, cvc: cardDetails.cvc!, completionHandler: completionHandler)
    }
}
