class PanViewPresenter: NSObject, Presenter {
    private let validationFlow: PanValidationFlow
    private let validator: PanValidator
    private let textChangeHandler:TextChangeHandler = TextChangeHandler()
    
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
    
    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let pan = textField.text else {
            return
        }
        onEditing(text: pan)
    }
}

extension PanViewPresenter: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let pan = textField.text else {
            return
        }
        
        return onEditEnd(text: pan)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let resultingText = textChangeHandler.change(originalText: textField.text, textChange: string, usingSelection: range)
        return canChangeText(with: resultingText)
    }
}
