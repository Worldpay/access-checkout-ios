class CvcOnlyValidationStateHandler {
    private(set) var merchantDelegate: AccessCheckoutCvcOnlyValidationDelegate
    private(set) var cvcIsValid = false

    private var notifyMerchantOfCvcValidationChangeIsPending = false
    private var merchantNeverNotifiedOfCvcValidationChange = true

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
            notifyMerchantOfCvcValidationChangeIsPending = true
            notifyMerchantOfCvcValidationState()

            if cvcIsValid {
                merchantDelegate.validationSuccess()
            }
        }
    }

    func notifyMerchantOfCvcValidationState() {
        if notifyMerchantOfCvcValidationChangeIsPending
            || merchantNeverNotifiedOfCvcValidationChange
        {

            merchantNeverNotifiedOfCvcValidationChange = false
            notifyMerchantOfCvcValidationChangeIsPending = false

            merchantDelegate.cvcValidChanged(isValid: cvcIsValid)
        }
    }
}
