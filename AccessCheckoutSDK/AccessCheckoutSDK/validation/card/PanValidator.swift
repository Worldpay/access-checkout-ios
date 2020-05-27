import Foundation

struct PanValidator {
    
    private var lengthValidator:LengthValidator = LengthValidator()
    private var cardConfiguration: AccessCardConfiguration
    
    public init(cardConfiguration: AccessCardConfiguration) {
        self.cardConfiguration = cardConfiguration
    }
      
    
    func validatePan(pan: PAN) -> (isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?) {
        
        let cardBrand = cardConfiguration.cardBrand(forPAN: pan)
        let panRule = cardBrand?.panValidationRule() ?? cardConfiguration.defaults.pan
        
        var result: Bool
        if lengthValidator.validate(text: pan, againstValidationRule: panRule) {
            result = pan.isValidLuhn()
        } else {
            result = false
        }
        
        return (isValid: result, cardBrand: cardBrand)
    }
}
