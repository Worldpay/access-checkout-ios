class AccessCheckoutClientImpl: AccessCheckoutClient {
    private let merchantId: String
    private let baseUrl: String
    
    init(merchantId: String, baseUrl: String) {
        self.merchantId = merchantId
        self.baseUrl = baseUrl
    }
    
    public func generateSession(cardDetails: CardDetails, sessionType: SessionType) {}
}
