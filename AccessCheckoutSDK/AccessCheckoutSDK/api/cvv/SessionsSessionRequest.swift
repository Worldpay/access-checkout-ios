struct SessionsSessionRequest: Codable {
    enum Key: String, CodingKey {
        case cvc = "cvc"
        case identity = "identity"
    }

    var cvc: String
    var identity: String
}
