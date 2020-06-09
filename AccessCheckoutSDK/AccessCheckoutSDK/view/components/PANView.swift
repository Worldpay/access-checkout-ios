import UIKit

/// A view representing a card's Primary Account Number
@IBDesignable public class PANView: UIView {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet public weak var imageView: UIImageView!
    
    /// The delegate to handle view events
    public weak var validationDelegate: ValidationDelegate?
    
    /// The card number represented by the view
    public var text: PAN? {
        guard let text = textField.text else {
            return nil
        }
        guard !text.isEmpty else {
            return nil
        }
        return text
    }
    
    var presenter: PanViewPresenter?
    
    private var textChangeHandler = TextChangeHandler()
    
    /// Initialize PANView from storyboard
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewFromNib()
    }
    
    /// Initializer override
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewFromNib()
    }
    
    /// Constructor for tests
    init(_ textChangeHandler:TextChangeHandler, _ presenter:PanViewPresenter) {
        super.init(frame: CGRect())
        setupViewFromNib()
        self.textChangeHandler = textChangeHandler
        self.presenter = presenter
    }
    
    func setupViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        
        textField.placeholder = NSLocalizedString("card_number_placeholder", comment: "")
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let pan = textField.text else {
            return
        }
        presenter?.onEditing(text: textField.text)
        (validationDelegate as? PANValidationDelegate)?.notifyPartialMatchValidation(forPan: pan)
    }
}

extension PANView: AccessCheckoutTextView {
    /// View is enabled for editing
    public var isEnabled: Bool {
        get {
            return textField.isEnabled
        }
        set {
            textField.isEnabled = newValue
        }
    }
    
    /**
     The validity of the PAN has updated.
     
     - Parameters:
        - valid: View represents a valid card number
     */
    public func isValid(valid: Bool) {
        textField.textColor = valid ? UIColor.black : UIColor.red
    }
    
    /// Clears any text input.
    public func clear() {
        textField.text = nil
    }
}

extension PANView: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let pan = textField.text else {
            return
        }
        
        (validationDelegate as? PANValidationDelegate)?.notifyCompleteMatchValidation(forPan: pan)
        presenter?.onEditEnd(text: pan)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let presenter = self.presenter {
            let resultingText = textChangeHandler.change(originalText: textField.text, textChange: string, usingSelection: range)
            return presenter.canChangeText(with: resultingText)
        }
        
        return (validationDelegate as? PANValidationDelegate)?.canUpdate(pan: textField.text, withText: string, inRange: range) ?? false
    }
}
