public protocol AccessCheckoutClient {
    func generateSessions(cardDetails: CardDetails, sessionTypes: Set<SessionType>, completionHandler: @escaping (Result<[SessionType: String], AccessCheckoutClientError>) -> Void) throws
}
