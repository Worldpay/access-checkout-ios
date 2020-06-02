import Foundation

class PanValidator {
    private var lengthValidator: LengthValidator = LengthValidator()
    private var cardConfiguration: AccessCardConfiguration
    
    init(cardConfiguration: AccessCardConfiguration) {
        self.cardConfiguration = cardConfiguration
    }
    
    func validate(pan: PAN) -> PanValidationResult {
        let cardBrand = cardConfiguration.cardBrand(forPAN: pan)
        let panRule = cardBrand?.panValidationRule() ?? cardConfiguration.defaults.pan
        
        var isValid: Bool
        if lengthValidator.validate(text: pan, againstValidationRule: panRule) {
            isValid = pan.isValidLuhn()
        } else {
            isValid = false
        }
        
        return PanValidationResult(isValid, cardBrand)
    }
}
