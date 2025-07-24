struct CardBinRequest: Codable {
    enum Key: String, CodingKey {
        case cardNumber
        case checkoutId
    }

    var cardNumber: String
    var checkoutId: String
}
