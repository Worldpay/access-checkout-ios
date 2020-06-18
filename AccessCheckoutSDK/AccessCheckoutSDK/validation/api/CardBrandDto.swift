struct CardBrandDto: Decodable {
    let name: String
    let pattern: String
    let panLengths: [Int]
    let cvcLength: Int
    let images: [CardBrandImageDto]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        pattern = try container.decodeIfPresent(String.self, forKey: .pattern) ?? ""
        panLengths = try container.decodeIfPresent([Int].self, forKey: .panLengths) ?? []
        cvcLength = try container.decodeIfPresent(Int.self, forKey: .cvvLength) ?? 0
        images = try container.decodeIfPresent([CardBrandImageDto].self, forKey: .images) ?? []
    }
    
    private enum Key: CodingKey {
        case name
        case pattern
        case panLengths
        case cvvLength
        case images
     }
}

struct CardBrandImageDto: Decodable {
    let type: String
    let url: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
    }
    
    private enum Key: CodingKey {
       case type
       case url
    }
}
