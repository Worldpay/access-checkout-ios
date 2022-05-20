import Foundation
import UIKit

class PanViewPresenter: NSObject, Presenter {
    private let validationFlow: PanValidationFlow
    private let validator: PanValidator
    private let panTextChangeHandler: PanTextChangeHandler
    private let panFormatter: PanFormatter

    init(_ validationFlow: PanValidationFlow, _ panValidator: PanValidator, panFormattingEnabled: Bool) {
        self.validationFlow = validationFlow
        self.validator = panValidator
        self.panTextChangeHandler = PanTextChangeHandler(panValidator, panFormattingEnabled: panFormattingEnabled)
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
        guard let pan = textField.text else {
            return
        }

        onEditing(text: pan)
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

    fileprivate func newRangeWithPreviousDigit(originalRange range: NSRange) -> NSRange {
        return NSRange(location: range.location - 1, length: range.length + 1)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let digitsOnly = stripAllCharsButDigits(string)
        if digitsOnly.isEmpty, !string.isEmpty {
            setCaretPosition(textField, range.location)
            return false
        }

        let originalText = textField.text ?? ""
        let selection: NSRange
        let caretPosition: Int

        if isDeletingSpace(originalText: originalText, replacementString: string, selection: range) {
            selection = newRangeWithPreviousDigit(originalRange: range)
            caretPosition = range.location - 1
        } else {
            selection = range
            caretPosition = range.location
        }

        let resultingText = panTextChangeHandler.change(originalText: originalText,
                                                        textChange: digitsOnly,
                                                        usingSelection: selection)

        if canChangeText(with: resultingText) {
            textField.text = resultingText
            onEditing(text: resultingText)

            let numberOfDigitsBeforeNewCaretPosition = countNumberOfDigitsBeforeCaret(originalText, caretPosition) + digitsOnly.count
            var newCaretPosition = findIndexOfNthDigit(text: resultingText, nth: numberOfDigitsBeforeNewCaretPosition)

            if hasDeletedDigitThatWasAfterSpace(originalText: originalText, originalSelection: range, originalCaretPosition: range.location, replacementString: string) {
                newCaretPosition = newCaretPosition + 1
            } else if hasInsertedTextJustBeforeSpace(text: resultingText, digitsInserted: digitsOnly, caretPosition: newCaretPosition) {
                newCaretPosition = newCaretPosition + 1
            }

            setCaretPosition(textField, newCaretPosition)
            textField.sendActions(for: UIControl.Event.editingChanged)
            onEditEnd()
        } else {
            setCaretPosition(textField, range.location)
        }

        return false
    }

    private func isDeletingSpace(originalText: String, replacementString: String, selection: NSRange) -> Bool {
        return replacementString.isEmpty
            && isSpace(originalText, start: selection.lowerBound, end: selection.upperBound)
    }

    private func hasDeletedDigitThatWasAfterSpace(originalText: String, originalSelection: NSRange, originalCaretPosition: Int, replacementString: String) -> Bool {
        if !replacementString.isEmpty || originalSelection.length > 1 || originalCaretPosition == 0 {
            return false
        }
        return isSpace(originalText, start: originalCaretPosition - 1, end: originalCaretPosition)
    }

    private func hasInsertedTextJustBeforeSpace(text: String, digitsInserted: String, caretPosition: Int) -> Bool {
        return !digitsInserted.isEmpty
            && caretPosition < text.count - 1
            && isSpace(text, start: caretPosition, end: caretPosition + 1)
    }

    private func isSpace(_ text: String, start: Int, end: Int) -> Bool {
        let start = text.index(text.startIndex, offsetBy: start)
        let end = text.index(text.startIndex, offsetBy: end)
        return text[start..<end] == " "
    }

    private func stripAllCharsButDigits(_ string: String) -> String {
        return string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
}
