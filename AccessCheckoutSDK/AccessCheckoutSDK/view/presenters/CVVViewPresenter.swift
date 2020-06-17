class CVVViewPresenter: Presenter {
    private let validationFlow: CvvValidationFlow
    private let validator: CvvValidator
    
    init(_ validationFlow: CvvValidationFlow, _ validator: CvvValidator) {
        self.validationFlow = validationFlow
        self.validator = validator
    }
    
    func onEditing(text: String?) {
        validationFlow.validate(cvv: text)
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
