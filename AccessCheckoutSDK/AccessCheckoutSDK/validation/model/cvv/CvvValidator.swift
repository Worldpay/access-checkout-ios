class CvvValidator {
    func validate(cvv: CVV?, validationRule: ValidationRule) -> Bool {
        guard let cvv = cvv else {
            return false
        }
        
        return validationRule.validate(text: cvv)
    }
    
    func canValidate(_ text: String, using validationRule: ValidationRule) -> Bool {
        return validationRule.textIsMatched(text)
            && validationRule.textIsShorterOrAsLongAsMaxLength(text)
    }
}
