import UIKit

/**
 * This extension is NOT published via Cocoapods or SPM
 * It is solely designed to expose certain properties to the UI tests for this SDK
 */
public extension AccessCheckoutUITextField {
    // MARK: Methods related to caret position and selection
    var beginningOfDocument: UITextPosition { self.uiTextField.beginningOfDocument }

    var endOfDocument: UITextPosition { self.uiTextField.endOfDocument }

    func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
        return self.uiTextField.position(from: position, offset: offset)
    }

    func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? {
        return self.uiTextField.position(from: position, in: direction, offset: offset)
    }

    func textRange(from: UITextPosition, to: UITextPosition) -> UITextRange? {
        return self.uiTextField.textRange(from: from, to: to)
    }

    func offset(from: UITextPosition, to: UITextPosition) -> Int {
        return self.uiTextField.offset(from: from, to: to)
    }
    
    // MARK: Methods to add/remove event listeners
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.uiTextField.addTarget(target, action: action, for: controlEvents)
    }
    
    func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event) {
        self.uiTextField.removeTarget(target, action: action, for: controlEvents)
    }
}
