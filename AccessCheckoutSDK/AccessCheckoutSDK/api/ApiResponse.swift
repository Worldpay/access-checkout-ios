import Foundation

struct ApiResponse: Decodable {
    let links: Links
    
    private enum CodingKeys: String, CodingKey {
        case links = "_links"
    }
    
    struct Links: Decodable {
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
    
    struct Link: Decodable {
        let href: String
    }
    
    struct Curie: Decodable {
        let href: String
        let name: String
        let templated: Bool
    }
}
