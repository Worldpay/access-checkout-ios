import UIKit

/**
 Deprecated
 
 A view representing a card's Card Verification value Code
 - text: `String` representing the CVC entered by the end user
 - isEnabled: `Boolean` allowing to enable or disable editing
 - textColor: `UIColor?` allowing to set the colour of the text displayed in the textinput
 - clear(): clears the text that was entered by the end user
 */
@available(*, deprecated, message: "This component is deprecated and will be removed in future major versions of the SDK. A standard `UITextField` should be used instead.")
@IBDesignable public class CvcView: UIView {
    @IBOutlet weak var textField: UITextField!
    
    var presenter: Presenter?
    
    private let textChangeHandler: TextChangeHandler = TextChangeHandler()
    
    /// Initialize CvcView from storyboard
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewFromNib()
    }
    
    /// Initializer override
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewFromNib()
    }
    
    private func setupViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let cvc = textField.text else {
            return
        }
        (presenter as? CvcViewPresenter)?.onEditing(text: cvc)
    }
}

extension CvcView: AccessCheckoutTextView {
    /**
     `String` representing the CVC entered by the end user
     */
    public var text: String {
        guard let text = textField.text else {
            return ""
        }
        
        return text
    }
    
    /**
     `Boolean` allowing to enable or disable editing
     */
    public var isEnabled: Bool {
        get {
            return textField.isEnabled
        }
        set {
            textField.isEnabled = newValue
        }
    }
    
    /**
     `UIColor?` allowing to get or change the colour of the text displayed in the textinput
     */
    public var textColor: UIColor? {
        get {
            return textField.textColor
        }
        set {
            textField.textColor = newValue
        }
    }
    
    /**
     Clears the text that was entered by the end user
     */
    public func clear() {
        textField.text = ""
        (presenter as? CvcViewPresenter)?.onEditing(text: "")
    }
}

extension CvcView: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cvc = textField.text else {
            return
        }
        
        (presenter as? CvcViewPresenter)?.onEditEnd(text: cvc)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let presenter = presenter as? CvcViewPresenter else {
            return true
        }
        
        let resultingText = textChangeHandler.change(originalText: textField.text, textChange: string, usingSelection: range)
        return presenter.canChangeText(with: resultingText)
    }
}
