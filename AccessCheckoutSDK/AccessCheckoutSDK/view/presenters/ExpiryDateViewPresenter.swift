class ExpiryDateViewPresenter {
    private let validationFlow: ExpiryDateValidationFlow
    
    init(_ validationFlow: ExpiryDateValidationFlow) {
        self.validationFlow = validationFlow
    }
    
    func onEditing(monthText: String, yearText: String) {
        validationFlow.validate(expiryMonth: monthText, expiryYear: yearText)
    }
    
    func onEditEnd(text: String?) {}
    
    func canChangeText(text: String?, with: String, using range: NSRange) {}
}
