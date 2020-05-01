public protocol AccessCheckoutClient {
    func generateSession(cardDetails: CardDetails, sessionType: SessionType)
}
