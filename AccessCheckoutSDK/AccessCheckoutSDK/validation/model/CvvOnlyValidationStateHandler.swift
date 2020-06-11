class CvvOnlyValidationStateHandler: CvvValidationStateHandler {
    private(set) var merchantDelegate: AccessCheckoutCvvOnlyValidationDelegate
    private(set) var cvvIsValid = false

    init(_ merchantDelegate: AccessCheckoutCvvOnlyValidationDelegate) {
        self.merchantDelegate = merchantDelegate
    }

    /**
     Convenience constructors used by unit tests
     */
    init(_ merchantDelegate: AccessCheckoutCvvOnlyValidationDelegate, cvvValidationState: Bool) {
        self.merchantDelegate = merchantDelegate
        self.cvvIsValid = cvvValidationState
    }

    func handleCvvValidation(isValid: Bool) {
        if isValid != cvvIsValid {
            cvvIsValid = isValid
            merchantDelegate.cvvValidChanged(isValid: isValid)

            if cvvIsValid {
                merchantDelegate.validationSuccess()
            }
        }
    }
}
