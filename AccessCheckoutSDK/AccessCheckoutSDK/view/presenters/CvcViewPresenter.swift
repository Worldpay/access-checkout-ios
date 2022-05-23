import Foundation
import UIKit

class CvcViewPresenter: NSObject, Presenter {
    private let validationFlow: CvcValidationFlow
    private let validator: CvcValidator
    private let textChangeHandler = TextChangeHandler()
    
    init(_ validationFlow: CvcValidationFlow, _ validator: CvcValidator) {
        self.validationFlow = validationFlow
        self.validator = validator
    }
    
    func onEditing(text: String?) {
        validationFlow.validate(cvc: text)
    }
    
    func onEditEnd(text: String?) {
        validationFlow.notifyMerchantIfNotAlreadyNotified()
    }
    
    func canChangeText(with text: String) -> Bool {
        if text.isEmpty {
            return true
        }
        
        return validator.canValidate(text, using: validationFlow.validationRule)
    }
    
    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let cvc = textField.text else {
            return
        }
        onEditing(text: cvc)
    }
}

extension CvcViewPresenter: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cvc = textField.text else {
            return
        }
        
        onEditEnd(text: cvc)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let resultingText = textChangeHandler.change(originalText: textField.text, textChange: string, usingSelection: range)
        return canChangeText(with: resultingText)
    }
}
