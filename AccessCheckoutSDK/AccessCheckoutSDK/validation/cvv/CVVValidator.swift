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

        let validLengths = validationRule.validLengths

        if validLengths.isEmpty {
            return ValidationResult(partial: true, complete: true)
        }
        
        let partiallyValid = cvv.count <= validLengths.max()!
        let completelyValid = validLengths.contains(cvv.count)
      
        return ValidationResult(partial: partiallyValid, complete: completelyValid)
    }
    
    func validate(cvv:CVV, againstValidationRule validationRule: CardConfiguration.CardValidationRule) -> ValidationResult {
        return textValidator.validate(text: cvv, againstValidationRule: validationRule)
    }
}
