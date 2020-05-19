class CVVValidator {
    private var textValidator:TextValidator
    
    init(){
        self.textValidator = TextValidator()
    }
    
    init(_ textValidator:TextValidator){
        self.textValidator = textValidator
    }
    
    func validate(cvv:CVV?) -> ValidationResult {
        guard let cvv = cvv, !cvv.isEmpty else {
            return ValidationResult(partial: true, complete: false)
        }
        
        let validationRule = CardConfiguration.CardDefaults.baseDefaults().cvv!
        if let matcher = validationRule.matcher, matcher.regexMatches(text: cvv) == false {
            return ValidationResult(partial: false, complete: false)
        }
        
        let partiallyValid = cvv.count <= validationRule.maxLength!
        let completelyValid = cvv.count >= validationRule.minLength! && cvv.count <= validationRule.maxLength!
        
        return ValidationResult(partial: partiallyValid, complete: completelyValid)
    }
    
    func validate(cvv:CVV, againstValidationRule validationRule: CardConfiguration.CardValidationRule) -> ValidationResult {
        return textValidator.validate(text: cvv, againstValidationRule: validationRule)
    }
}
