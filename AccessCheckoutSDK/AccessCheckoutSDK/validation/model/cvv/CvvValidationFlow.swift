class CvvValidationFlow {
    private let cvvValidator: CvvValidator
    private let cvvValidationStateHandler: CvvValidationStateHandler
    private(set) var cvvRule: ValidationRule = ValidationRulesDefaults.instance().cvv
    private(set) var cvv: CVV?
    
    init(_ cvvValidator: CvvValidator, _ cvvValidationStateHandler: CvvValidationStateHandler) {
        self.cvvValidator = cvvValidator
        self.cvvValidationStateHandler = cvvValidationStateHandler
    }
    
    /**
     Convenience constructor used by unit tests
     */
    init(cvvValidator: CvvValidator, cvvValidationStateHandler: CvvValidationStateHandler, cvv: CVV) {
        self.cvvValidator = cvvValidator
        self.cvvValidationStateHandler = cvvValidationStateHandler
        self.cvv = cvv
    }
    
    init(cvvValidator: CvvValidator, cvvValidationStateHandler: CvvValidationStateHandler, cvvRule: ValidationRule) {
        self.cvvValidator = cvvValidator
        self.cvvValidationStateHandler = cvvValidationStateHandler
        self.cvvRule = cvvRule
    }
    
    func validate(cvv: CVV?, cvvRule: ValidationRule) {
        self.cvv = cvv
        let result = cvvValidator.validate(cvv: cvv, cvvRule: cvvRule)
        cvvValidationStateHandler.handleCvvValidation(isValid: result)
    }
    
    func reValidate(cvvRule: ValidationRule?) {
        self.cvvRule = cvvRule ?? ValidationRulesDefaults.instance().cvv
        validate(cvv: cvv, cvvRule: self.cvvRule)
    }
}
