@testable import AccessCheckoutSDK

class CvvValidationFlowMock: CvvValidationFlow {
    private(set) var validateCalled = false
    private(set) var cvvPassed: CVV?
    private(set) var expiryYearPassed: ExpiryYear?
    private(set) var cvvRulePassed: ValidationRule?

    init() {
        let validator = MockCvvValidator()
        let validationStateHandler = MockCvvValidationStateHandler()

        super.init(validator, validationStateHandler)
    }

    override func validate(cvv: CVV?, cvvRule: ValidationRule) {
        validateCalled = true
        cvvPassed = cvv
        cvvRulePassed = cvvRule
    }
}
