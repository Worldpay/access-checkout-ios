class PANViewPresenter: Presenter {
    private let validationFlow: PanValidationFlow
    
    init(_ validationFlow: PanValidationFlow) {
        self.validationFlow = validationFlow
    }
    
    func onEditing(text: String?) {
        validationFlow.validate(pan: text!)
    }
    
    func onEditEnd(text: String?) {}
    
    func canChangeText(text: String?, with: String, using range: NSRange) {}
}
