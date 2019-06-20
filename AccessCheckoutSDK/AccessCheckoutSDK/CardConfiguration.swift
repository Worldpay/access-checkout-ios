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
            let cardConfiguration = try? JSONDecoder().decode(CardConfiguration.self, from: data) else {
                return nil
        }
        defaults = cardConfiguration.defaults
        brands = cardConfiguration.brands
    }

    init(defaults: CardDefaults?, brands: [CardBrand]?) {
        self.defaults = defaults
        self.brands = brands
    }
    
    func cardBrand(forPAN pan: PAN) -> CardBrand? {
        return brands?.first { $0.cardValidationRule(forPAN: pan) != nil }
    }
    
    struct CardValidationRule: Decodable, Equatable {
        var matcher: String?
        var minLength: Int?
        var maxLength: Int?
        var validLength: Int?
        var subRules: [CardValidationRule]?
    }
    
    struct CardDefaults: Decodable {
        var pan: CardValidationRule?
        var cvv: CardValidationRule?
        var month: CardValidationRule?
        var year: CardValidationRule?
    }
    
    /// The brand identity of a card, e.g Visa
    public struct CardBrand: Decodable, Equatable {
        
        /// The brand name
        public let name: String
        
        /// The URL of the brand logo
        public var imageUrl: String?
        
        var cvv: CardValidationRule?
        let pans: [CardValidationRule]
        
        func cardValidationRule(forPAN pan: PAN) -> CardValidationRule? {
            let panRule = pans.first { $0.matcher?.regexMatches(text: pan) == true }
            let subPanRule = panRule?.subRules?.first { $0.matcher?.regexMatches(text: pan) == true }
            return subPanRule ?? panRule
        }
        
        /// Equatable operator
        public static func == (lhs: CardConfiguration.CardBrand, rhs: CardConfiguration.CardBrand) -> Bool {
            return lhs.name == rhs.name
        }
    }
}
