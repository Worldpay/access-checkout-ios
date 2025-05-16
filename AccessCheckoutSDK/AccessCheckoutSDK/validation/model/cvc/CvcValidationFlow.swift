class CvcValidationFlow {
    private let cvcValidator: CvcValidator
    private let cvcValidationStateHandler: CvcValidationStateHandler

    private(set) var validationRule: ValidationRule = ValidationRulesDefaults.instance().cvc
    private(set) var cvc: String?

    init(_ cvcValidator: CvcValidator, _ cvcValidationStateHandler: CvcValidationStateHandler) {
        self.cvcValidator = cvcValidator
        self.cvcValidationStateHandler = cvcValidationStateHandler
    }

    /**
     Convenience constructor used by unit tests
     */
    init(
        cvcValidator: CvcValidator,
        cvcValidationStateHandler: CvcValidationStateHandler,
        validationRule: ValidationRule
    ) {
        self.cvcValidator = cvcValidator
        self.cvcValidationStateHandler = cvcValidationStateHandler
        self.validationRule = validationRule
    }

    init(
        cvcValidator: CvcValidator,
        cvcValidationStateHandler: CvcValidationStateHandler,
        cvc: String,
        validationRule: ValidationRule
    ) {
        self.cvcValidator = cvcValidator
        self.cvcValidationStateHandler = cvcValidationStateHandler
        self.cvc = cvc
        self.validationRule = validationRule
    }

    func validate(cvc: String?) {
        self.cvc = cvc
        let result = cvcValidator.validate(cvc: cvc, validationRule: validationRule)
        cvcValidationStateHandler.handleCvcValidation(isValid: result)
    }

    func resetValidationRule() {
        validationRule = ValidationRulesDefaults.instance().cvc
    }

    func revalidate() {
        let result = cvcValidator.validate(cvc: cvc, validationRule: validationRule)
        cvcValidationStateHandler.handleCvcValidation(isValid: result)
    }

    func updateValidationRule(with rule: ValidationRule) {
        validationRule = rule
    }

    func notifyMerchant() {
        cvcValidationStateHandler.notifyMerchantOfCvcValidationState()
    }
}
