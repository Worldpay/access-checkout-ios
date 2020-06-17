protocol CvvValidationStateHandler {
    func handleCvvValidation(isValid: Bool)
    
    func notifyMerchantOfCvvValidationState()
    
    var alreadyNotifiedMerchantOfCvvValidationState: Bool { get }
}
