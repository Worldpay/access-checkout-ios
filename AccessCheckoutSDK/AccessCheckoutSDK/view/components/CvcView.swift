import UIKit

/// A view representing a card's Card Verification Value
@IBDesignable public class CvcView: UIView {
    @IBOutlet weak var textField: UITextField!
    
    /// The delegate to handle view events
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
    /// The Cvc represented by the view
    public var text: String? {
        guard let text = textField.text else {
            return nil
        }
        guard !text.isEmpty else {
            return nil
        }
        return text
    }
    
    /// View is enabled for editing
    public var isEnabled: Bool {
        get {
            return textField.isEnabled
        }
        set {
            textField.isEnabled = newValue
        }
    }
    
    /// Colour of the text displayed in the textField
    public var textColor: UIColor? {
        get {
            return textField.textColor
        }
        set {
            textField.textColor = newValue
        }
    }
    
    /// Clears any text input.
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