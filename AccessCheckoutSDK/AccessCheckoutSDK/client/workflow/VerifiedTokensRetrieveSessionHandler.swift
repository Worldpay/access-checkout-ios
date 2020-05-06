class VerifiedTokensRetrieveSessionHandler: RetrieveSessionHandler {
    private let apiClient: VerifiedTokensApiClient

    init(apiClient: VerifiedTokensApiClient) {
        self.apiClient = apiClient
    }

    func canHandle(sessionType: SessionType) -> Bool {
        return sessionType == SessionType.verifiedTokens
    }

    func retrieveSession(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Result<String, AccessCheckoutClientError>) -> Void) {
        apiClient.createSession(pan: cardDetails.pan!,
                                expiryMonth: cardDetails.expiryMonth!,
                                expiryYear: cardDetails.expiryYear!,
                                cvv: cardDetails.cvv!,
                                urlSession: URLSession.shared, completionHandler: completionHandler)
    }
}
