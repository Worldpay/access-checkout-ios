struct VerifiedTokensSessionRequest: Codable {
    
    enum Key: String, CodingKey {
        case cardExpiryDate = "cardExpiryDate"
        case cardNumber = "cardNumber"
        case cvc = "cvc"
        case identity = "identity"
    }
    
    struct CardExpiryDate: Codable {
        enum Key: String, CodingKey {
            case month = "month"
            case year = "year"
        }
        var month: UInt
        var year: UInt
    }
    var cardNumber: String
    var cardExpiryDate: CardExpiryDate
    var cvc: String
    var identity: String
}
