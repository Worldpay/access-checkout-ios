class CvvOnlyValidationStateHandler: CvvValidationStateHandler {
    private(set) var accessCvvOnlyDelegate: AccessCheckoutCvvOnlyValidationDelegate
    private(set) var cvvValidationState = false

    init(_ merchantDelegate: AccessCheckoutCvvOnlyValidationDelegate) {
        self.accessCvvOnlyDelegate = merchantDelegate
    }

    /**
     Convenience constructors used by unit tests
     */
    init(accessCvvOnlyDelegate: AccessCheckoutCvvOnlyValidationDelegate, cvvValidationState: Bool) {
        self.accessCvvOnlyDelegate = accessCvvOnlyDelegate
        self.cvvValidationState = cvvValidationState
    }

    func handleCvvValidation(isValid: Bool) {
        if isValid != cvvValidationState {
            cvvValidationState = isValid
            accessCvvOnlyDelegate.handleCvvValidationChange(isValid: isValid)
        }
    }
}
