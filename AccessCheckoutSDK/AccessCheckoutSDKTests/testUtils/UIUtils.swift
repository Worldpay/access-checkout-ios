@testable import AccessCheckoutSDK
import UIKit

struct UIUtils {
    static func createAccessCheckoutUITextField(withText text: String) -> AccessCheckoutUITextField {
        let uiTextField = UITextField()
        uiTextField.text = text
        return AccessCheckoutUITextField(uiTextField)
    }
}
