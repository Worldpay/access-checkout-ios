class VerifiedTokensRetrieveSessionHandler: RetrieveSessionHandler {
    private let apiClient: VerifiedTokensApiClient

    init(apiClient: VerifiedTokensApiClient) {
        self.apiClient = apiClient
    }

    func canHandle(sessionType: SessionType) -> Bool {
        return sessionType == SessionType.verifiedTokens
    }

    func handle(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Swift.Result<String, AccessCheckoutClientError>) -> Void) {
        apiClient.createSession(baseUrl: baseUrl,
                                merchantId: merchantId,
                                pan: cardDetails.pan!,
                                expiryMonth: cardDetails.expiryMonth!,
                                expiryYear: cardDetails.expiryYear!,
                                cvc: cardDetails.cvc!,
                                completionHandler: completionHandler)
    }
}
