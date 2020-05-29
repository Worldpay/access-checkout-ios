class CardBrandDto: Decodable {
    let name: String
    let pattern: String
    let panLengths: [Int]
    let cvvLength: Int
    let images: [CardBrandImageDto]

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        pattern = try container.decodeIfPresent(String.self, forKey: .pattern) ?? ""
        panLengths = try container.decodeIfPresent([Int].self, forKey: .panLengths) ?? []
        cvvLength = try container.decodeIfPresent(Int.self, forKey: .cvvLength) ?? 0
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

class CardBrandImageDto: Decodable {
    let type: String
    let url: String
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
    }
    
    private enum Key: CodingKey {
       case type
       case url
    }
}

// let name:String
// let pattern:String
// let panLengths: [Int]
// let cvvLength: Int
// let images:[CardBrandImage]
//
// public init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: Key.self)
//
//    self.name = try! container.decodeIfPresent(String.self, forKey: .name) ?? ""
//    self.pattern = try! container.decodeIfPresent(String.self, forKey: .pattern) ?? ""
//    self.panLengths = try container.decodeIfPresent([Int].self, forKey: .panLengths) ?? []
//    self.cvvLength = (try container.decodeIfPresent(Int.self, forKey: .name))!
//    self.images = try container.decodeIfPresent([CardBrandImage].self, forKey: .name) ?? []
// }
//
// private enum Key: CodingKey {
//    case name
//    case pattern
//    case panLengths
// }
