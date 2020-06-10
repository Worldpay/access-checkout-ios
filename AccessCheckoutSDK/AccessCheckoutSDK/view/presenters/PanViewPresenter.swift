class PanViewPresenter {
    private let validationFlow: PanValidationFlow
    private let validator: PanValidator
    
    init(_ validationFlow: PanValidationFlow, _ panValidator: PanValidator) {
        self.validationFlow = validationFlow
        self.validator = panValidator
    }
    
    // TODO: - what do we do when text is null or empty?
    func onEditing(text: String?) {
        validationFlow.validate(pan: text!)
    }
    
    func onEditEnd(text: String?) {
        validationFlow.validate(pan: text!)
    }
    
    func canChangeText(with text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        return validator.canValidate(pan: text)
    }
}
