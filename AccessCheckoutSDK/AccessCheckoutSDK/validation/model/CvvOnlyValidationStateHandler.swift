class CvvOnlyValidationStateHandler {
    private(set) var merchantDelegate: AccessCheckoutCvvOnlyValidationDelegate
    private(set) var cvvIsValid = false
    private(set) var alreadyNotifiedMerchantOfCvvValidationState = false

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
}

extension CvvOnlyValidationStateHandler: CvvValidationStateHandler {
    func handleCvvValidation(isValid: Bool) {
        if isValid != cvvIsValid {
            cvvIsValid = isValid
            notifyMerchantOfCvvValidationState()

            if cvvIsValid {
                merchantDelegate.validationSuccess()
            }
        }
    }

    func notifyMerchantOfCvvValidationState() {
        merchantDelegate.cvvValidChanged(isValid: cvvIsValid)
        alreadyNotifiedMerchantOfCvvValidationState = true
    }
}
