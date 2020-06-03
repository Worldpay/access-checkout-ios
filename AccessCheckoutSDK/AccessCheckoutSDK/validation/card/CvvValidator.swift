class CvvValidator {
    let lengthValidator = LengthValidator()

    func validate(cvv: CVV?, cvvRule: ValidationRule) -> Bool {
        guard let cvv = cvv else {
            return false
        }
                       
        return lengthValidator.validate(text: cvv, againstValidationRule: cvvRule)
    }
}
