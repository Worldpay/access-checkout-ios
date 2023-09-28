import UIKit

@IBDesignable public class AccessCheckoutUITextField: UIView {
    @IBOutlet internal var uiTextField: UITextField! = UITextField()

    internal var text: String? {
        set { self.uiTextField.text = newValue }
        get { self.uiTextField.text }
    }
    
    internal var delegate: UITextFieldDelegate? {
        set { self.uiTextField.delegate = newValue }
        get { self.uiTextField.delegate }
    }
}
