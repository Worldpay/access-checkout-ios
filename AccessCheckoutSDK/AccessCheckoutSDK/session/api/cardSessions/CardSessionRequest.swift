struct CardSessionRequest: Codable {
    enum Key: String, CodingKey {
        case cardExpiryDate
        case cardNumber
        case cvc
        case identity
    }
    
    struct CardExpiryDate: Codable {
        enum Key: String, CodingKey {
            case month
            case year
        }

        var month: UInt
        var year: UInt
    }

    var cardNumber: String
    var cardExpiryDate: CardExpiryDate
    var cvc: String
    var identity: String
}
