class VerifiedTokensRetrieveSessionHandler: RetrieveSessionHandler {
    private let apiClient: VerifiedTokensApiClient

    init(apiClient: VerifiedTokensApiClient) {
        self.apiClient = apiClient
    }

    func canHandle(sessionType: SessionType) -> Bool {
        return sessionType == SessionType.verifiedTokens
    }

    func retrieveSession(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Result<String, Error>) -> Void) {
        // ToDo - we should fail the process if we're trying to retrieve a session and the pan or expiry or CVV are empty
        apiClient.createSession(pan: cardDetails.pan!,
                                expiryMonth: UInt(cardDetails.expiryMonth!)!,
                                expiryYear: UInt(cardDetails.expiryYear!)!,
                                cvv: cardDetails.cvv!,
                                urlSession: URLSession.shared, completionHandler: completionHandler)
    }
}
