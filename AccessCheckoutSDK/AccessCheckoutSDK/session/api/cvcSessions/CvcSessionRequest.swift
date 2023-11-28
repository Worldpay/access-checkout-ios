struct CvcSessionRequest: Codable {
    enum Key: String, CodingKey {
        case cvc
        case identity
    }

    var cvc: String
    var identity: String
}
