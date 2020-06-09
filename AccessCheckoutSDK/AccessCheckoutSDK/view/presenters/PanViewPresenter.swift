class PanViewPresenter {
    private let validationFlow: PanValidationFlow
    
    init(_ validationFlow: PanValidationFlow) {
        self.validationFlow = validationFlow
    }
    
    // TODO - what do we do when text is null?
    func onEditing(text: String?) {
        validationFlow.validate(pan: text!)
    }
    
    func onEditEnd(text: String?) {
        validationFlow.validate(pan: text!)
    }
    
    func canChangeText(text: String?, with: String, using range: NSRange) {}
}
