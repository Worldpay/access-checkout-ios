// ToDo - This should be renamed into PaymentsCvcSessionRequest since this is what the end point is about really)
struct SessionsSessionRequest: Codable {
    enum Key: String, CodingKey {
        case cvc = "cvc"
        case identity = "identity"
    }

    var cvc: String
    var identity: String
}
