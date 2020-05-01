protocol RetrieveSessionHandler {
    func canHandle(sessionType: SessionType) -> Bool

    func retrieveSession(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Result<String, Error>) -> Void)
}
