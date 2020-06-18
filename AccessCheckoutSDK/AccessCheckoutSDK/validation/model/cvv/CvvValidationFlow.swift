class CvvValidationFlow {
    private let cvvValidator: CvvValidator
    private let cvvValidationStateHandler: CvvValidationStateHandler
    
    private(set) var validationRule: ValidationRule = ValidationRulesDefaults.instance().cvv
    private(set) var cvv: String?
    
    init(_ cvvValidator: CvvValidator, _ cvvValidationStateHandler: CvvValidationStateHandler) {
        self.cvvValidator = cvvValidator
        self.cvvValidationStateHandler = cvvValidationStateHandler
    }
    
    /**
     Convenience constructor used by unit tests
     */
    init(cvvValidator: CvvValidator, cvvValidationStateHandler: CvvValidationStateHandler, validationRule: ValidationRule) {
        self.cvvValidator = cvvValidator
        self.cvvValidationStateHandler = cvvValidationStateHandler
        self.validationRule = validationRule
    }
    
    init(cvvValidator: CvvValidator, cvvValidationStateHandler: CvvValidationStateHandler, cvv: String, validationRule: ValidationRule) {
        self.cvvValidator = cvvValidator
        self.cvvValidationStateHandler = cvvValidationStateHandler
        self.cvv = cvv
        self.validationRule = validationRule
    }
    
    func validate(cvv: String?) {
        self.cvv = cvv
        let result = cvvValidator.validate(cvv: cvv, validationRule: validationRule)
        cvvValidationStateHandler.handleCvvValidation(isValid: result)
    }
    
    func resetValidationRule() {
        validationRule = ValidationRulesDefaults.instance().cvv
    }
    
    func revalidate() {
        let result = cvvValidator.validate(cvv: cvv, validationRule: validationRule)
        cvvValidationStateHandler.handleCvvValidation(isValid: result)
    }
    
    func updateValidationRule(with rule: ValidationRule) {
        validationRule = rule
    }
    
    func notifyMerchantIfNotAlreadyNotified() {
        if !cvvValidationStateHandler.alreadyNotifiedMerchantOfCvvValidationState {
            cvvValidationStateHandler.notifyMerchantOfCvvValidationState()
        }
    }
}
