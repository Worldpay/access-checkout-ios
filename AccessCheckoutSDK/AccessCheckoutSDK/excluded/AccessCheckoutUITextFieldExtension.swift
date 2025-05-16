import UIKit

/// This extension is NOT published via Cocoapods or SPM
/// It is solely designed to expose certain properties used in the UI tests of this SDK
extension AccessCheckoutUITextField {
    // MARK: Methods related to caret position and selection

    public var beginningOfDocument: UITextPosition { self.uiTextField.beginningOfDocument }

    public var endOfDocument: UITextPosition { self.uiTextField.endOfDocument }

    public func offset(from: UITextPosition, to: UITextPosition) -> Int {
        return self.uiTextField.offset(from: from, to: to)
    }

    public func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
        return self.uiTextField.position(from: position, offset: offset)
    }

    public func textRange(from: UITextPosition, to: UITextPosition) -> UITextRange? {
        return self.uiTextField.textRange(from: from, to: to)
    }

    public var selectedTextRange: UITextRange? {
        set { self.uiTextField.selectedTextRange = newValue }
        get { self.uiTextField.selectedTextRange }
    }

    // MARK: Methods to add/remove event listeners

    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.uiTextField.addTarget(target, action: action, for: controlEvents)
    }

    public func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event)
    {
        self.uiTextField.removeTarget(target, action: action, for: controlEvents)
    }
}
