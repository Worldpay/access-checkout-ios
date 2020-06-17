class ExpiryDateValidationFlow {
    private var expiryDateValidator: ExpiryDateValidator
    private var expiryValidationStateHandler: ExpiryDateValidationStateHandler

    init(_ expiryDateValidator: ExpiryDateValidator, _ expiryValidationStateHandler: ExpiryDateValidationStateHandler) {
        self.expiryDateValidator = expiryDateValidator
        self.expiryValidationStateHandler = expiryValidationStateHandler
    }

    func validate(expiryDate: String) {
        let result = expiryDateValidator.validate(expiryDate)
        expiryValidationStateHandler.handleExpiryDateValidation(isValid: result)
    }

    func notifyMerchantIfNotAlreadyNotified() {
        if !expiryValidationStateHandler.alreadyNotifiedMerchantOfExpiryDateValidationState {
            expiryValidationStateHandler.notifyMerchantOfExpiryDateValidationState()
        }
    }
}
