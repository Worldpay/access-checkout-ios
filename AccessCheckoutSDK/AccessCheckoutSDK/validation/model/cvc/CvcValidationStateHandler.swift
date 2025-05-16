protocol CvcValidationStateHandler {
    func handleCvcValidation(isValid: Bool)

    func notifyMerchantOfCvcValidationState()
}
