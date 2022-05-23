import Foundation
import UIKit

class ExpiryDateViewPresenter: NSObject, Presenter {
    private let validationFlow: ExpiryDateValidationFlow
    private let validator: ExpiryDateValidator
    private let textChangeHandler:TextChangeHandler = TextChangeHandler()
    
    private var expiryDateFormatter = ExpiryDateFormatter()
    private var textBeforeEditingChanged = ""

    init(_ validationFlow: ExpiryDateValidationFlow, _ validator: ExpiryDateValidator) {
        self.validationFlow = validationFlow
        self.validator = validator
    }
    
    func onEditing(text: String) {
        validationFlow.validate(expiryDate: text)
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
        var text = textField.text ?? ""
        
        if !text.isEmpty {
            let isNotDeletingSeparator = !attemptingToDeleteSeparator(textBefore: textBeforeEditingChanged, textAfter: text)
            let hasNoSeparator = !text.contains(expiryDateFormatter.separator)
            
            if hasNoSeparator, isNotDeletingSeparator {
                let newText = expiryDateFormatter.format(text)
                if text != newText {
                    updateText(textField, with: newText)
                    text = newText
                    textField.sendActions(for: .editingChanged)
                    return
                }
            }
        }
        
        onEditing(text: text)
    }
    
    private func attemptingToDeleteSeparator(textBefore: String, textAfter: String) -> Bool {
        if textBefore.hasSuffix(expiryDateFormatter.separator), !textAfter.hasSuffix(expiryDateFormatter.separator) {
            return textAfter + expiryDateFormatter.separator == textBefore
        }
        
        return false
    }
    
}

extension ExpiryDateViewPresenter: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
       let text = textField.text ?? ""
       
      onEditEnd(text: text)
   }
   
   public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
       textBeforeEditingChanged = textField.text ?? ""
       
       let resultingText = textChangeHandler.change(originalText: textField.text, textChange: string, usingSelection: range)
       return canChangeText(with: resultingText)
   }
   
    private func updateText(_ textField: UITextField, with text: String) {
        textField.text = text
        textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
    }
}
