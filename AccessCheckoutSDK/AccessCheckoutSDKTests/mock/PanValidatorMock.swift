@testable import AccessCheckoutSDK

class PanValidatorMock : PanValidator {
    var validationCalled: Bool = false
    var isValid: Bool
    var cardBrand: AccessCardConfiguration.CardBrand?
    var validationResult: (isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?)?
    
    init(cardConfiguration: AccessCardConfiguration, isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?) {
        self.cardBrand = cardBrand
        self.isValid = isValid
        
        super.init(cardConfiguration: cardConfiguration)
    }
    
    override func validate(pan: PAN) -> (isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?) {
        let result:(isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?) = (isValid: isValid, cardBrand: cardBrand)
        self.validationResult = result
        validationCalled = true
        return result
    }
}
