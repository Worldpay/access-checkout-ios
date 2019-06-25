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
    
    public struct CardDefaults: Decodable {
        var pan: CardValidationRule?
        var cvv: CardValidationRule?
        var month: CardValidationRule?
        var year: CardValidationRule?
        
        public static func baseDefaults() -> CardDefaults {
            let panValidationRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,19}$",
                                                                         minLength: 13,
                                                                         maxLength: 19,
                                                                         validLength: nil,
                                                                         subRules: nil)
            let cvvValidationRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,4}$",
                                                                         minLength: 3,
                                                                         maxLength: 4,
                                                                         validLength: nil,
                                                                         subRules: nil)
            let monthValidationRule = CardConfiguration.CardValidationRule(matcher: "^0[1-9]{0,1}$|^1[0-2]{0,1}$",
                                                                           minLength: 2,
                                                                           maxLength: 2,
                                                                           validLength: nil,
                                                                           subRules: nil)
            let yearValidationRule = CardConfiguration.CardValidationRule(matcher: "^\\d{0,2}$",
                                                                          minLength: 2,
                                                                          maxLength: 2,
                                                                          validLength: nil,
                                                                          subRules: nil)
            return CardDefaults(pan: panValidationRule,
                                cvv: cvvValidationRule,
                                month: monthValidationRule,
                                year: yearValidationRule)
        }
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
