class PanViewPresenter: NSObject, Presenter {
    private let validationFlow: PanValidationFlow
    private let validator: PanValidator
    private let textChangeHandler:PanTextChangeHandler
    let panFormatter: PanFormatter

    
    init(_ validationFlow: PanValidationFlow, _ panValidator: PanValidator, _ disableFormatting: Bool) {
        self.validationFlow = validationFlow
        self.validator = panValidator
        self.textChangeHandler = PanTextChangeHandler(disableFormatting: disableFormatting)
        self.panFormatter = PanFormatter(disableFormatting: disableFormatting)
    }
    
    func onEditing(text: String) {
        validationFlow.validate(pan: text.replacingOccurrences(of: " ", with: ""))
    }
    
    func onEditEnd() {
        validationFlow.notifyMerchantIfNotAlreadyNotified()
    }
    
    func canChangeText(with text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        return true
    }
    
    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let pan = textField.text else {
            return
        }
        onEditing(text: pan)
//        textField.text = panFormatter.format(pan: pan, brand: validationFlow.getCardBrand())
    }
}

extension PanViewPresenter: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        onEditEnd()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//                let resultingText = textChangeHandler.change(originalText: textField.text, textChange: string, usingSelection: range, brand: validationFlow.getCardBrand())
//                if(canChangeText(with: resultingText)) {
//                    textField.text = resultingText
//                }
//                return true
            let resultingText = textChangeHandler.change(originalText: textField.text, textChange: string, usingSelection: range, brand: validationFlow.getCardBrand())
            return canChangeText(with: resultingText)
    }
}

