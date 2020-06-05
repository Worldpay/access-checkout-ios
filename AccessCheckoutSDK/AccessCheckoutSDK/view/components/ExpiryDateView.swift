import UIKit

/// A view representing a card's expiry date
@IBDesignable public class ExpiryDateView: UIView {
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    /// The delegate to handle view events
    public weak var validationDelegate: ValidationDelegate?
    
    /// The expiry date month element
    public var month: ExpiryMonth? {
        guard let text = monthTextField.text else {
            return nil
        }
        guard !text.isEmpty else {
            return nil
        }
        return text
    }
    
    /// The expiry date year element
    public var year: ExpiryYear? {
        guard let text = yearTextField.text else {
            return nil
        }
        guard !text.isEmpty else {
            return nil
        }
        return text
    }
    
    var presenter: ExpiryDateViewPresenter?
    
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
        
        monthTextField.delegate = self
        yearTextField.delegate = self
        
        monthTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        yearTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        switch textField {
        case monthTextField:
            (validationDelegate as? ExpiryDateValidationDelegate)?.notifyPartialMatchValidation(forExpiryMonth: text, andExpiryYear: nil)
        case yearTextField:
            (validationDelegate as? ExpiryDateValidationDelegate)?.notifyPartialMatchValidation(forExpiryMonth: nil, andExpiryYear: text)
        default:
            return
        }
        
        // ToDo - should not force unwrap
        presenter?.onEditing(monthText: monthTextField.text!, yearText: yearTextField.text!)
    }
}

extension ExpiryDateView: AccessCheckoutDateView {
    public var isEnabled: Bool {
        get {
            return monthTextField.isEnabled && yearTextField.isEnabled
        }
        set {
            monthTextField.isEnabled = newValue
            yearTextField.isEnabled = newValue
        }
    }
    
    /**
     The validity of the expiry date has updated.
     
     - Parameters:
        - valid: View represents a valid expiry date
     */
    public func isValid(valid: Bool) {
        monthTextField.textColor = valid ? UIColor.black : UIColor.red
        yearTextField.textColor = valid ? UIColor.black : UIColor.red
    }
    
    /// Clears any text input.
    public func clear() {
        monthTextField.text = nil
        yearTextField.text = nil
    }
}

extension ExpiryDateView: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        switch textField {
        case monthTextField:
            (validationDelegate as? ExpiryDateValidationDelegate)?.notifyCompleteMatchValidation(forExpiryMonth: text, andExpiryYear: nil)
        case yearTextField:
            (validationDelegate as? ExpiryDateValidationDelegate)?.notifyCompleteMatchValidation(forExpiryMonth: nil, andExpiryYear: text)
        default:
            return
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case monthTextField:
            return (validationDelegate as? ExpiryDateValidationDelegate)?.canUpdate(expiryMonth: textField.text, withText: string, inRange: range) ?? true
        case yearTextField:
            return (validationDelegate as? ExpiryDateValidationDelegate)?.canUpdate(expiryYear: textField.text, withText: string, inRange: range) ?? true
        default:
            return false
        }
    }
}
