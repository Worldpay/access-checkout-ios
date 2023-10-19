import UIKit

public extension AccessCheckoutUITextField {
    /* Properties related to positions and selection */
    @available(iOS 3.2, *)
    var beginningOfDocument: UITextPosition { self.uiTextField.beginningOfDocument }

    @available(iOS 3.2, *)
    var endOfDocument: UITextPosition { self.uiTextField.endOfDocument }

    /* Methods to create text ranges and positions */
    @available(iOS 3.2, *)
    func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
        return self.uiTextField.position(from: position, offset: offset)
    }

    @available(iOS 3.2, *)
    func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? {
        return self.uiTextField.position(from: position, in: direction, offset: offset)
    }

    @available(iOS 3.2, *)
    func textRange(from: UITextPosition, to: UITextPosition) -> UITextRange? {
        return self.uiTextField.textRange(from: from, to: to)
    }

    /* Methods relating to the content of the UITextField */
    @available(iOS 3.2, *)
    func offset(from: UITextPosition, to: UITextPosition) -> Int {
        return self.uiTextField.offset(from: from, to: to)
    }
}
