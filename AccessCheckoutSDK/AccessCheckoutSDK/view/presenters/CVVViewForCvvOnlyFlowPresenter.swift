class CVVViewForCvvOnlyFlowPresenter: CVVViewPresenter {
    private let validationFlow: CvvValidationFlow
    
    // TODO: tidy up in various initialisers
    init(_ validationFlow: CvvValidationFlow) {
        self.validationFlow = validationFlow
    }
    
    func onEditing(text: String?) {
        // TODO: we will need to change this so that it does not care about which validation rule to use. Could that be a problem with the change of configuration?
        validationFlow.validate(cvv: text, cvvRule: ValidationRulesDefaults.instance().cvv)
    }
    
    func onEditEnd(text: String?) {}
    
    func canChangeText(text: String?, with: String, using range: NSRange) {}
}
