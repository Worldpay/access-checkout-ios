protocol RetrieveSessionHandler {
    func canHandle(sessionType: SessionType) -> Bool

    func handle(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Result<String, AccessCheckoutError>) -> Void)
}
