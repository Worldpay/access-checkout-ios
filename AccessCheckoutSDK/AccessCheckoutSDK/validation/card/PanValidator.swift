class PanValidator {
    private var lengthValidator: LengthValidator = LengthValidator()
    private var cardConfiguration: CardBrandsConfiguration
    
    init(cardConfiguration: CardBrandsConfiguration) {
        self.cardConfiguration = cardConfiguration
    }
    
    func validate(pan: PAN) -> PanValidationResult {
        let cardBrand = cardConfiguration.cardBrand(forPan: pan)
        let panRule = cardBrand?.panValidationRule ?? cardConfiguration.validationRulesDefaults.pan
        
        var isValid: Bool
        if lengthValidator.validate(text: pan, againstValidationRule: panRule) {
            isValid = pan.isValidLuhn()
        } else {
            isValid = false
        }
        
        return PanValidationResult(isValid, cardBrand)
    }
}
