class PanValidator {
    private var lengthValidator: LengthValidator = LengthValidator()
    private var cardBrandsConfigurationProvider: CardBrandsConfigurationProvider
    
    init(_ cardBrandsConfigurationProvider: CardBrandsConfigurationProvider) {
        self.cardBrandsConfigurationProvider = cardBrandsConfigurationProvider
    }
    
    func validate(pan: PAN) -> PanValidationResult {
        let cardBrand = cardBrandsConfigurationProvider.get().cardBrand(forPan: pan)
        let panRule = cardBrand?.panValidationRule ?? cardBrandsConfigurationProvider.get().validationRulesDefaults.pan
        
        var isValid: Bool
        if lengthValidator.validate(text: pan, againstValidationRule: panRule) {
            isValid = pan.isValidLuhn()
        } else {
            isValid = false
        }
        
        return PanValidationResult(isValid, cardBrand)
    }
}
