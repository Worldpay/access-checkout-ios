class PanValidator {
    private var cardBrandsConfigurationProvider: CardBrandsConfigurationProvider
    
    init(_ cardBrandsConfigurationProvider: CardBrandsConfigurationProvider) {
        self.cardBrandsConfigurationProvider = cardBrandsConfigurationProvider
    }
    
    func validate(pan: PAN) -> PanValidationResult {
        let cardBrand = cardBrandsConfigurationProvider.get().cardBrand(forPan: pan)
        let validationRule = cardBrand?.panValidationRule ?? ValidationRulesDefaults.instance().pan
        
        var isValid: Bool
        if validationRule.validate(text: pan) {
            isValid = pan.isValidLuhn()
        } else {
            isValid = false
        }
        
        return PanValidationResult(isValid, cardBrand)
    }
}
