class CvcOnlyValidationStateHandler {
    private(set) var merchantDelegate: AccessCheckoutCvcOnlyValidationDelegate
    private(set) var cvcIsValid = false
    private(set) var alreadyNotifiedMerchantOfCvcValidationState = false

    init(_ merchantDelegate: AccessCheckoutCvcOnlyValidationDelegate) {
        self.merchantDelegate = merchantDelegate
    }

    /**
     Convenience constructors used by unit tests
     */
    init(_ merchantDelegate: AccessCheckoutCvcOnlyValidationDelegate, cvcValidationState: Bool) {
        self.merchantDelegate = merchantDelegate
        self.cvcIsValid = cvcValidationState
    }
}

extension CvcOnlyValidationStateHandler: CvcValidationStateHandler {
    func handleCvcValidation(isValid: Bool) {
        if isValid != cvcIsValid {
            cvcIsValid = isValid
            notifyMerchantOfCvcValidationState()

            if cvcIsValid {
                merchantDelegate.validationSuccess()
            }
        }
    }

    func notifyMerchantOfCvcValidationState() {
        merchantDelegate.cvcValidChanged(isValid: cvcIsValid)
        alreadyNotifiedMerchantOfCvcValidationState = true
    }
}
