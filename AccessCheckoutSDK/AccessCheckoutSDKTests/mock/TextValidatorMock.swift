@testable import AccessCheckoutSDK

class TextValidatorMock : TextValidator {
    var textPassed:String?
    var validationRulePassed:CardConfiguration.CardValidationRule?
    var validateCalled:Bool = false
    var validationResultToReturn:ValidationResult?
    
    override func validate(text: String, againstValidationRule validationRule: CardConfiguration.CardValidationRule) -> ValidationResult {
        self.validateCalled = true
        self.textPassed = text
        self.validationRulePassed = validationRule
        
        return validationResultToReturn ?? ValidationResult(partial: true, complete: true)
    }
}
