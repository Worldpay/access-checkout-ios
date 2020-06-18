class PanViewPresenter: Presenter {
    private let validationFlow: PanValidationFlow
    private let validator: PanValidator
    
    init(_ validationFlow: PanValidationFlow, _ panValidator: PanValidator) {
        self.validationFlow = validationFlow
        self.validator = panValidator
    }
    
    func onEditing(text: String) {
        validationFlow.validate(pan: text)
    }
    
    func onEditEnd(text: String) {
        validationFlow.notifyMerchantIfNotAlreadyNotified()
    }
    
    func canChangeText(with text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        return validator.canValidate(text)
    }
}
