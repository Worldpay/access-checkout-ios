protocol CvcValidationStateHandler {
    func handleCvcValidation(isValid: Bool)
    
    func notifyMerchantOfCvcValidationState()
    
    var alreadyNotifiedMerchantOfCvcValidationState: Bool { get }
}
