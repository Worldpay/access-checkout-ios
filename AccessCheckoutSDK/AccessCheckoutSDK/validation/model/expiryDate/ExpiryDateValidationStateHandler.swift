protocol ExpiryDateValidationStateHandler {
    func handleExpiryDateValidation(isValid: Bool)
    
    func notifyMerchantOfExpiryDateValidationState()
}
