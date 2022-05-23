import UIKit

/// A view representing a text field
protocol AccessCheckoutTextView {
    /**
     `Boolean` allowing to enable or disable editing
     */
    var isEnabled: Bool { get set }

    /**
     `UIColor?` allowing to set the colour of the text displayed in the textinput
     */
    var textColor: UIColor? { get set }

    /**
     clears the text that was entered by the end user
     */
    func clear()

    /**
     Presentation layer used by the view to interact with the validation feature
     */
    var presenter: Presenter? { get set }

    /**
     `String` representing the CVC entered by the end user
     */
    var text: String { get }
}
