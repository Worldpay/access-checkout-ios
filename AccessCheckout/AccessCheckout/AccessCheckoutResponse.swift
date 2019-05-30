import Foundation

struct AccessCheckoutResponse: Codable {
    
    enum CodingKeys: String, CodingKey {
        case links = "_links"
    }
    
    public struct Links: Codable {
        
        var curies: [Curie]?
        var endpoints: [String: Link]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            var endpoints = [String: Link]()
            for codingKeys in container.allKeys.compactMap({ CodingKeys(stringValue: $0.stringValue) }) {
                switch codingKeys.stringValue {
                case "curies":
                    curies = try container.decode([Curie]?.self, forKey: codingKeys)
                default:
                    let link = try container.decode(Link.self, forKey: codingKeys)
                    endpoints[codingKeys.stringValue] = link
                }
            }
            
            self.endpoints = endpoints
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(curies, forKey: CodingKeys(stringValue: "curies")!)
            try endpoints.forEach { (key, value) in
                if let codingKeys = CodingKeys(stringValue: key) {
                    try container.encode(value, forKey: codingKeys)
                }
            }
        }
        
        private struct CodingKeys: CodingKey {
            var stringValue: String
            
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            
            var intValue: Int?
            
            init?(intValue: Int) {
                self.intValue = intValue
                self.stringValue = "\(intValue)"
            }
            
            static func make(key: String) -> CodingKeys? {
                return CodingKeys(stringValue: key)
            }
        }
    }
    public struct Link: Codable {
        var href: String
    }
    public struct Curie: Codable {
        var href: String
        var name: String
        var templated: Bool
    }
    var links: Links
}
