struct ApiLinks {
    static let cardSessions = ApiLinks(
        service: "service:sessions",
        endpoint: "sessions:card",
        result: "sessions:session"
    )
    static let cvcSessions = ApiLinks(
        service: "service:sessions",
        endpoint: "sessions:paymentsCvc",
        result: "sessions:session"
    )

    static let cardBin = ApiLinks(
        service: "cardBinPublic:binDetails",
        endpoint: "cardBinPublic:binDetails",
        result: "cardBinPublic:binDetails"
    )

    let service: String
    let endpoint: String
    let result: String

    init(service: String, endpoint: String, result: String) {
        self.service = service
        self.endpoint = endpoint
        self.result = result
    }
}
