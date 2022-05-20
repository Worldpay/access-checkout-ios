import Foundation
import UIKit

@objc
protocol Presenter : UITextFieldDelegate {
    func textFieldEditingChanged(_ textField: UITextField)
}
