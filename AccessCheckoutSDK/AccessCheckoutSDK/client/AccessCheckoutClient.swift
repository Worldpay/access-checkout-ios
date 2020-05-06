public protocol AccessCheckoutClient {
    func generateSession(cardDetails: CardDetails, sessionType: SessionType, completionHandler: @escaping (Result<String, AccessCheckoutClientError>) -> Void) throws
}