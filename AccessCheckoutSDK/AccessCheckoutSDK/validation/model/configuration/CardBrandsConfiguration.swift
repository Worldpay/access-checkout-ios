struct CardBrandsConfiguration {
    let brands: [CardBrandModel]
    let validationRulesDefaults: ValidationRulesDefaults
    
    init(_ brands: [CardBrandModel], _ validationRulesDefaults: ValidationRulesDefaults) {
        self.brands = brands
        self.validationRulesDefaults = validationRulesDefaults
    }
    
    func cardBrand(forPan pan: PAN) -> CardBrandModel? {
        if brands.isEmpty {
            return nil
        }
        
        return brands.first { $0.panValidationRule.matcher?.regexMatches(text: pan) == true }
    }
    
    func panValidationRule(using cardBrand: CardBrandModel?) -> ValidationRule {
        guard let cardBrand = cardBrand else {
            return validationRulesDefaults.pan
        }
        
        return cardBrand.panValidationRule
    }
}
