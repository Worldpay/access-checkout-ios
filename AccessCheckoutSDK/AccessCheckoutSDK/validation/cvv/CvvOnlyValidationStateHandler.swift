class CvvOnlyValidationStateHandler: CvvValidationStateHandler {
    private(set) var accessCvvOnlyDelegate: AccessCvvOnlyDelegate
    private(set) var cvvValidationState = false

    init(_ merchantDelegate: AccessCvvOnlyDelegate) {
        self.accessCvvOnlyDelegate = merchantDelegate
    }

    /**
     Convenience constructors used by unit tests
     */
    init(accessCvvOnlyDelegate: AccessCvvOnlyDelegate, cvvValidationState: Bool) {
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
