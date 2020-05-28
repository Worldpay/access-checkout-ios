import Foundation

/// Representation of a payment card's brands, defaults and validation rules
public struct AccessCardConfiguration {
    
    var defaults: CardDefaults
    var brands: [CardBrand] = []
    
    /**
     Initialises a configuration from JSON at a specified location.
     
     - Parameter fromUrl: The `URL` of a JSON configuration file
     */
    public init?(fromURL url: URL) {
        defaults = CardDefaults.baseDefaults()

        if let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [Dictionary<String, Any>] {
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
            brands = brandsFromJson
        }
        
    }

    init(defaults: CardDefaults, brands: [CardBrand]) {
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
        if brands.isEmpty {
            return nil
        } else {
            return brands.first { $0.matcher.regexMatches(text: pan) == true }
        }
    }
    
    struct CardValidationRule: Decodable, Equatable {
        var matcher: String?
        var validLengths: Array<Int> = [Int]()
    }
    
    struct CardDefaults: Decodable {
        var pan: CardValidationRule
        var cvv: CardValidationRule
        var month: CardValidationRule
        var year: CardValidationRule
        
        public static func baseDefaults() -> CardDefaults {
            let panValidationRule = AccessCardConfiguration.CardValidationRule(
                matcher: "^\\d{0,19}$",
                validLengths: [12,13,14,15,16,17,18,19]
            )
            let cvvValidationRule = AccessCardConfiguration.CardValidationRule(
                matcher: "^\\d{0,4}$",
                validLengths: [3,4]
            )
            let monthValidationRule = AccessCardConfiguration.CardValidationRule(
                matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                validLengths: [2]
            )
            let yearValidationRule = AccessCardConfiguration.CardValidationRule(
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
    struct CardBrand: Equatable {
        
        public struct CardBrandImage {
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
        public static func == (lhs: AccessCardConfiguration.CardBrand, rhs: AccessCardConfiguration.CardBrand) -> Bool {
            return lhs.name == rhs.name
        }
    }
}
