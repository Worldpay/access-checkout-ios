class CVVViewPresenter {
    private let validationFlow: CvvValidationFlow
    
    // TODO: tidy up in various initialisers
    init(_ validationFlow: CvvValidationFlow) {
        self.validationFlow = validationFlow
    }
    
    func onEditing(text: String?) {
        validationFlow.validate(cvv: text)
    }
    
    func onEditEnd(text: String?) {
        validationFlow.validate(cvv: text)
    }
    
    func canChangeText(text: String?, with: String, using range: NSRange) {}
}
