class VerifiedTokensRetrieveSessionHandler: RetrieveSessionHandler {
    func canHandle(sessionType: SessionType) -> Bool {
        return sessionType == SessionType.verifiedTokens
    }

    func retrieveSession(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Result<String, Error>) -> Void) {
        completionHandler(.success("a-session"))
    }
}
