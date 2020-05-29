
struct CardBrandsConfiguration {
    let brands: [CardBrand2]
    let validationRulesDefaults: ValidationRulesDefaults
    
    init(_ brands: [CardBrand2], _ validationRulesDefaults: ValidationRulesDefaults) {
        self.brands = brands
        self.validationRulesDefaults = validationRulesDefaults
    }
    
    func cardBrand(of pan: PAN) -> CardBrand2? {
        if brands.isEmpty {
            return nil
        }
        
        return brands.first { $0.panValidationRule.matcher?.regexMatches(text: pan) == true }
    }
    
    func panValidationRule(using cardBrand: CardBrand2?) -> ValidationRule? {
        return cardBrand != nil ? cardBrand?.panValidationRule : validationRulesDefaults.pan
    }
}
