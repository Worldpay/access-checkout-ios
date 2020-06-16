class ExpiryDateViewPresenter: Presenter {
    private let validationFlow: ExpiryDateValidationFlow
    private let validator: ExpiryDateValidator
    
    init(_ validationFlow: ExpiryDateValidationFlow, _ validator: ExpiryDateValidator) {
        self.validationFlow = validationFlow
        self.validator = validator
    }
    
    func onEditing(text: String) {
        validationFlow.validate(expiryDate: text)
    }
    
    func onEditEnd(text: String) {
        validationFlow.validate(expiryDate: text)
    }
    
    func canChangeText(with text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        return validator.canValidate(text)
    }
}
