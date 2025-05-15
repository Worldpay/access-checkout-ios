class CvcValidator {
    func validate(cvc: String?, validationRule: ValidationRule) -> Bool {
        guard let cvc = cvc else {
            return false
        }

        return validationRule.validate(text: cvc)
    }

    func canValidate(_ text: String, using validationRule: ValidationRule) -> Bool {
        return validationRule.textIsMatched(text)
            && validationRule.textIsShorterOrAsLongAsMaxLength(text)
    }
}
