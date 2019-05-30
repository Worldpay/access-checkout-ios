import UIKit

@IBDesignable public class ExpiryDateView: UIView {
    
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    weak public var cardViewDelegate: CardViewDelegate?
    
    public var month: ExpiryMonth? {
        guard let text = monthTextField.text else {
            return nil
        }
        guard !text.isEmpty else {
            return nil
        }
        return text
    }
    
    public var year: ExpiryYear? {
        guard let text = yearTextField.text else {
            return nil
        }
        guard !text.isEmpty else {
            return nil
        }
        return text
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewFromNib()
    }
    
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
        
        monthTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        yearTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        switch textField {
        case monthTextField:
            cardViewDelegate?.didUpdate(expiryMonth: text, expiryYear: nil)
        case yearTextField:
            cardViewDelegate?.didUpdate(expiryMonth: nil, expiryYear: text)
        default:
            return
        }
    }
}

extension ExpiryDateView: CardDateView {
    public func isValid(valid: Bool) {
        monthTextField.textColor = valid ? UIColor.black : UIColor.red
        yearTextField.textColor = valid ? UIColor.black : UIColor.red
    }
    
    
    public func clear() {
        monthTextField.text = nil
        yearTextField.text = nil
    }
    
    public func isEnabled(_ enabled: Bool) {
        monthTextField.isEnabled = enabled
        yearTextField.isEnabled = enabled
    }
}

extension ExpiryDateView: UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        switch textField {
        case monthTextField:
            cardViewDelegate?.didEndUpdate(expiryMonth: text, expiryYear: nil)
        case yearTextField:
            cardViewDelegate?.didEndUpdate(expiryMonth: nil, expiryYear: text)
        default:
            return
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case monthTextField:
            return cardViewDelegate?.canUpdate(expiryMonth: textField.text, withText: string, inRange: range) ?? true
        case yearTextField:
            return cardViewDelegate?.canUpdate(expiryYear: textField.text, withText: string, inRange: range) ?? true
        default:
            return false
        }
    }
}
