import Foundation

public struct CardConfiguration: Decodable {
    
    var defaults: CardDefaults?
    var brands: [CardBrand]?
    
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
    
    public struct CardBrand: Decodable, Equatable {
        
        public let name: String
        public var imageUrl: String?
        var cvv: CardValidationRule?
        let pans: [CardValidationRule]
        
        func cardValidationRule(forPAN pan: PAN) -> CardValidationRule? {
            let panRule = pans.first { $0.matcher?.regexMatches(text: pan) == true }
            let subPanRule = panRule?.subRules?.first { $0.matcher?.regexMatches(text: pan) == true }
            return subPanRule ?? panRule
        }
        
        public static func == (lhs: CardConfiguration.CardBrand, rhs: CardConfiguration.CardBrand) -> Bool {
            return lhs.name == rhs.name
        }
    }
}
