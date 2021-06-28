import Foundation

class PanViewPresenter: NSObject, Presenter {
    private let validationFlow: PanValidationFlow
    private let validator: PanValidator
    private let panTextChangeHandler: PanTextChangeHandler
    private let panFormatter: PanFormatter

    init(_ validationFlow: PanValidationFlow, _ panValidator: PanValidator, panFormattingEnabled: Bool) {
        self.validationFlow = validationFlow
        self.validator = panValidator
        self.panTextChangeHandler = PanTextChangeHandler(panFormattingEnabled: panFormattingEnabled)
        self.panFormatter = PanFormatter(cardSpacingEnabled: panFormattingEnabled)
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
        guard let text = textField.text else {
            return
        }

        let formattedPan = panFormatter.format(pan: text, brand: validationFlow.getCardBrand())
        if formattedPan != text {
            if let selectedTextRange = textField.selectedTextRange {
                let caretPosition = textField.offset(from: textField.beginningOfDocument, to: selectedTextRange.start)
                let newCaretPosition = findIndexOfNthDigit(text: formattedPan, nth: countNumberOfDigitsBeforeCaret(text, caretPosition))

                textField.text = formattedPan
                setCaretPosition(textField, newCaretPosition)
            } else {
                textField.text = formattedPan
            }
        }

        onEditing(text: formattedPan)
    }

    private func countNumberOfDigitsBeforeCaret(_ text: String, _ caretPosition: Int) -> Int {
        var numberOfDigits = 0
        for (index, character) in text.enumerated() {
            if index == caretPosition {
                break
            }

            if character.isNumber {
                numberOfDigits += 1
            }
        }

        return numberOfDigits
    }

    private func findIndexOfNthDigit(text: String, nth: Int) -> Int {
        var numberOfDigitsFound = 0
        var index = 0
        for character in text.enumerated() {
            if numberOfDigitsFound == nth {
                break
            } else if character.element.isNumber {
                numberOfDigitsFound += 1
            }

            index += 1
        }

        return index
    }

    private func setCaretPosition(_ textField: UITextField, _ newCaretPosition: Int) {
        DispatchQueue.main.async {
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: newCaretPosition) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
        }
    }
}

extension PanViewPresenter: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        onEditEnd()
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let replacementDigits = stripAllCharsButDigits(string)
        let caretPosition = range.location

        if !string.isEmpty, replacementDigits.isEmpty {
            setCaretPosition(textField, caretPosition)
            return false
        }

        let resultingText = panTextChangeHandler.change(originalText: textField.text ?? "", textChange: replacementDigits,
                                                        usingSelection: range, brand: validationFlow.getCardBrand())

        if canChangeText(with: resultingText) {
            let numberOfDigitsBeforeCaret = countNumberOfDigitsBeforeCaret(textField.text!, caretPosition)

            textField.text = resultingText
            onEditing(text: resultingText)

            let numberOfDigitsBeforeNewCaretPosition = numberOfDigitsBeforeCaret + replacementDigits.count
            let newCaretPosition = findIndexOfNthDigit(text: resultingText, nth: numberOfDigitsBeforeNewCaretPosition)
            setCaretPosition(textField, newCaretPosition)
            onEditEnd()
        }

        return false
    }

    private func stripAllCharsButDigits(_ string: String) -> String {
        return string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
}
