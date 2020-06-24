class CvcViewPresenter: Presenter {
    private let validationFlow: CvcValidationFlow
    private let validator: CvcValidator
    
    init(_ validationFlow: CvcValidationFlow, _ validator: CvcValidator) {
        self.validationFlow = validationFlow
        self.validator = validator
    }
    
    func onEditing(text: String?) {
        validationFlow.validate(cvc: text)
    }
    
    func onEditEnd(text: String?) {
        validationFlow.notifyMerchantIfNotAlreadyNotified()
    }
    
    func canChangeText(with text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        
        return validator.canValidate(text, using: validationFlow.validationRule)
    }
}
