import Foundation

/// Representation of a payment card's brands, defaults and validation rules
public struct CardConfiguration: Decodable {
    
    var defaults: CardDefaults?
    var brands: [CardBrand]?
    
    /**
     Initialises a configuration from JSON at a specified location.
     
     - Parameter fromUrl: The `URL` of a JSON configuration file
     */
    public init?(fromURL url: URL) {
        guard let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Dictionary<String, Any>] else {
                return nil
            }
        var brandsFromJson: [CardBrand] = []
        for brand in json {
            guard let name = brand["name"],
                let matcher = brand["pattern"],
                let pans = brand["panLengths"]
                else {
                    return nil
                }

                brandsFromJson.append(
                    CardBrand(
                        name: name as! String,
                        images: getBrandImages(brand: brand),
                        matcher: matcher as! String,
                        cvv: brand["cvvLength"] as? Int,
                        pans: pans as! [Int]
                    )
                )
        }
        defaults = CardDefaults.baseDefaults()
        brands = brandsFromJson
    }

    init(defaults: CardDefaults?, brands: [CardBrand]?) {
        self.defaults = defaults
        self.brands = brands
    }
    
    func getBrandImages(brand: Dictionary<String, Any>) ->  [CardBrand.CardBrandImage]? {
        var brandImages: [CardBrand.CardBrandImage]? = []
        if let images = brand["images"] as? [[String: Any]] {
            for image in images {
                brandImages?.append(
                    CardBrand.CardBrandImage(
                        type: image["type"] as? String,
                        url: image["url"] as? String
                    )
                )
            }
        } else {
            brandImages = nil
        }
        return brandImages
    }
    
    func cardBrand(forPAN pan: PAN) -> CardBrand? {
        return brands?.first { $0.matcher.regexMatches(text: pan) == true }
    }
    
    struct CardValidationRule: Decodable, Equatable {
        var matcher: String?
        var validLengths: Array<Int> = [Int]()
    }
    
    public struct CardDefaults: Decodable {
        var pan: CardValidationRule?
        var cvv: CardValidationRule?
        var month: CardValidationRule?
        var year: CardValidationRule?
        
        public static func baseDefaults() -> CardDefaults {
            let panValidationRule = CardConfiguration.CardValidationRule(
                matcher: "^\\d{0,19}$",
                validLengths: [13,15,16,18,19]
            )
            let cvvValidationRule = CardConfiguration.CardValidationRule(
                matcher: "^\\d{0,4}$",
                validLengths: [3,4]
            )
            let monthValidationRule = CardConfiguration.CardValidationRule(
                matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                validLengths: [2]
            )
            let yearValidationRule = CardConfiguration.CardValidationRule(
                matcher: "^\\d{0,2}$",
                validLengths: [2]
            )
            return CardDefaults(pan: panValidationRule,
                                cvv: cvvValidationRule,
                                month: monthValidationRule,
                                year: yearValidationRule)
        }
    }
    
    /// The brand identity of a card, e.g Visa
    public struct CardBrand: Decodable, Equatable {
        
        public struct CardBrandImage: Decodable {
            public var type: String?
            public var url: String?
        }
        
        /// The brand name
        public let name: String
        
        /// The URL of the brand logo
        public var images: [CardBrandImage]?
        
        let matcher: String
        var cvv: Int?
        let pans: [Int]
        
        func cvvRule() -> CardValidationRule? {
            if cvv != nil {
                return CardValidationRule(matcher: nil, validLengths: [cvv!])
            } else {
                return nil
            }
        }
        
        func panValidationRule() -> CardValidationRule {
            return CardValidationRule(matcher: matcher, validLengths: pans)
        }
        
        /// Equatable operator
        public static func == (lhs: CardConfiguration.CardBrand, rhs: CardConfiguration.CardBrand) -> Bool {
            return lhs.name == rhs.name
        }
    }
}
