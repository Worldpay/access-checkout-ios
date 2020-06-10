class ExpiryDateViewPresenter {
    private let validationFlow: ExpiryDateValidationFlow
    private let validator: ExpiryDateValidator
    
    init(_ validationFlow: ExpiryDateValidationFlow, _ validator: ExpiryDateValidator) {
        self.validationFlow = validationFlow
        self.validator = validator
    }
    
    func onEditing(monthText: String, yearText: String) {
        validationFlow.validate(expiryMonth: monthText, expiryYear: yearText)
    }
    
    func onEditEnd(monthText: String, yearText: String) {
        validationFlow.validate(expiryMonth: monthText, expiryYear: yearText)
    }
    
    func canChangeMonthText(with text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        return validator.canValidateMonth(text)
    }
    
    func canChangeYearText(with text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        return validator.canValidateYear(text)
    }
}
