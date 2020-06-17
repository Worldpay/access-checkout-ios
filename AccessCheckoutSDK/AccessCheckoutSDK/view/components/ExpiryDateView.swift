import UIKit

/// A view representing a card's expiry date
@IBDesignable public class ExpiryDateView: UIView {
    @IBOutlet weak var textField: UITextField!
    
    /// The delegate to handle view events
    var presenter: Presenter?
    
    private var textChangeHandler = TextChangeHandler()
    
    private var textBeforeEditingChanged = ""
    
    private var expiryDateFormatter = ExpiryDateFormatter()
    
    /// Initialize ExpiryDateView from storyboard
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
        var text = textField.text ?? ""
        
        if !text.isEmpty {
            let isNotDeletingSeparator = !attemptingToDeleteSeparator(textBefore: textBeforeEditingChanged, textAfter: text)
            let hasNoSeparator = !text.contains(expiryDateFormatter.separator)
            
            if hasNoSeparator, isNotDeletingSeparator {
                let newText = expiryDateFormatter.format(text)
                if text != newText {
                    updateText(with: newText)
                    text = newText
                }
            }
        }
        
        (presenter as? ExpiryDateViewPresenter)?.onEditing(text: text)
    }
    
    private func attemptingToDeleteSeparator(textBefore: String, textAfter: String) -> Bool {
        if textBefore.hasSuffix(expiryDateFormatter.separator), !textAfter.hasSuffix(expiryDateFormatter.separator) {
            return textAfter + expiryDateFormatter.separator == textBefore
        }
        
        return false
    }
    
    private func updateText(with text: String) {
        textField.text = text
        textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
    }
}

extension ExpiryDateView: AccessCheckoutTextView {
    /// The Expiry Date represented by the view
    public var text: String? {
        guard let text = textField.text else {
            return nil
        }
        guard !text.isEmpty else {
            return nil
        }
        return text
    }
    
    public var isEnabled: Bool {
        get {
            return textField.isEnabled
        }
        set {
            textField.isEnabled = newValue
        }
    }
    
    /// Colour of the text displayed in the textFields
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
        
        (presenter as? ExpiryDateViewPresenter)?.onEditing(text: "")
    }
}

extension ExpiryDateView: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        
        (presenter as? ExpiryDateViewPresenter)?.onEditEnd(text: text)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let presenter = presenter as? ExpiryDateViewPresenter else {
            return true
        }
        
        textBeforeEditingChanged = textField.text ?? ""
        
        let resultingText = textChangeHandler.change(originalText: textField.text, textChange: string, usingSelection: range)
        return presenter.canChangeText(with: resultingText)
    }
}
