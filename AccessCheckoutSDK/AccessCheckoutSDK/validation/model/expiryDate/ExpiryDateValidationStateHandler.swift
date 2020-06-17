protocol ExpiryDateValidationStateHandler {
    func handleExpiryDateValidation(isValid: Bool)
    
    func notifyMerchantOfExpiryDateValidationState()
    
    var alreadyNotifiedMerchantOfExpiryDateValidationState: Bool { get }
}
