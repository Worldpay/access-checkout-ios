public final class ApiLinks {
    var service: String
    var endpoint: String
    var result: String
    
    public static let verifiedTokens =  ApiLinks(service: "service:verifiedTokens", endpoint: "verifiedTokens:sessions", result: "verifiedTokens:session")
    public static let sessions =  ApiLinks(service: "service:sessions", endpoint: "sessions:paymentsCvc", result: "sessions:session")
    
    public init(service: String, endpoint: String, result: String) {
        self.service = service
        self.endpoint = endpoint
        self.result = result
    }
}
