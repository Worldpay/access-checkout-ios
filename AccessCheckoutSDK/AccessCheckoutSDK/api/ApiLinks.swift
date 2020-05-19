struct ApiLinks {
    static let verifiedTokens =  ApiLinks(service: "service:verifiedTokens", endpoint: "verifiedTokens:sessions", result: "verifiedTokens:session")
    static let sessions =  ApiLinks(service: "service:sessions", endpoint: "sessions:paymentsCvc", result: "sessions:session")
    
    let service: String
    let endpoint: String
    let result: String
    
    init(service: String, endpoint: String, result: String) {
        self.service = service
        self.endpoint = endpoint
        self.result = result
    }
}
