class PaymentsCvcRetrieveSessionHandler: RetrieveSessionHandler {
    private let apiClient: SessionsApiClient

    init(apiClient: SessionsApiClient) {
        self.apiClient = apiClient
    }

    func canHandle(sessionType: SessionType) -> Bool {
        return sessionType == SessionType.paymentsCvc
    }

    func handle(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Swift.Result<String, AccessCheckoutClientError>) -> Void) {
        apiClient.createSession(baseUrl: baseUrl, merchantId: merchantId, cvc: cardDetails.cvc!, completionHandler: completionHandler)
    }
}
