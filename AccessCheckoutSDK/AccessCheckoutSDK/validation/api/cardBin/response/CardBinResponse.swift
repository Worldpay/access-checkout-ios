internal struct CardBinResponse: Codable {
    enum Key: String, CodingKey {
        case brand
        case fundingType
        case luhnCompliant
    }

    var brand: [String]
    var fundingType: String
    var luhnCompliant: Bool
}
