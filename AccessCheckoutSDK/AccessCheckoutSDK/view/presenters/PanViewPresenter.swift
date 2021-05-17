import Foundation

class PanViewPresenter: NSObject, Presenter {
    private let validationFlow: PanValidationFlow
    private let validator: PanValidator
    private let panTextChangeHandler:PanTextChangeHandler

    init(_ validationFlow: PanValidationFlow, _ panValidator: PanValidator, _ disableFormatting: Bool) {
        self.validationFlow = validationFlow
        self.validator = panValidator
        self.panTextChangeHandler = PanTextChangeHandler(disableFormatting: disableFormatting)
    }
    
    func onEditing(text: String) {
        validationFlow.validate(pan: text)
    }
    
    func onEditEnd() {
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
        onEditEnd()
    }
        
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cursorPosition = range.location
        let originalText = textField.text ?? ""
        let resultingText = panTextChangeHandler.change(originalText: originalText, textChange: string, usingSelection: range, brand: validationFlow.getCardBrand())

        if canChangeText(with: resultingText) {
            
            textField.text = resultingText
            onEditing(text: resultingText)
            
            setCursorPosition(cursorPosition, originalText, resultingText, string, textField)
            onEditEnd()
        }
        return false
    }
    
    private func setCursorPosition(_ cursorPosition: Int, _ originalText: String, _ resultingText: String, _ string: String, _ textField: UITextField) {
        
        let newCursorPosition = calculateCusrorPosition(currentPosition: cursorPosition, originalText: originalText, resultingText: resultingText, changeLength: string.count)
        
        DispatchQueue.main.async {
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: newCursorPosition) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    private func calculateCusrorPosition(currentPosition: Int, originalText: String, resultingText: String, changeLength: Int) -> Int {
        var offset = resultingText.count - originalText.count
        if(offset < 0){
            return currentPosition
        }
        
        let originalSpacesToLeft = spacesToLeft(string: originalText, limit: currentPosition)
        let newSpacesToLeft = spacesToLeft(string: resultingText, limit: (currentPosition + offset))
        offset = changeLength + newSpacesToLeft - originalSpacesToLeft

        return currentPosition + offset
    }
    
    private func spacesToLeft(string: String, limit: Int)-> Int {
        var spacesToLeft = 0
        let substr = String(string.prefix(limit))
        for(_ , character) in substr.enumerated() {
            if(character == " ") {
                spacesToLeft += 1
            }
        }
        return spacesToLeft
    }
}

