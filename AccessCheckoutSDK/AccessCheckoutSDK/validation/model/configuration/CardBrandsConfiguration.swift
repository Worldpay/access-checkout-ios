struct CardBrandsConfiguration {
    let brands: [CardBrandModel]
    
    init(_ brands: [CardBrandModel]) {
        self.brands = brands
    }
    
    func cardBrand(forPan pan: String) -> CardBrandModel? {
        if brands.isEmpty {
            return nil
        }
        
        return brands.first { $0.panValidationRule.textIsMatched(pan) == true }
    }
    
    func panValidationRule(using cardBrand: CardBrandModel?) -> ValidationRule {
        guard let cardBrand = cardBrand else {
            return ValidationRulesDefaults.instance().pan
        }
        
        return cardBrand.panValidationRule
    }
}
