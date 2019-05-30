import UIKit

@IBDesignable public class CVVView: UIView {

    @IBOutlet weak var textField: UITextField!
    
    weak public var cardViewDelegate: CardViewDelegate?
    
    public var text: CVV? {
        guard let text = textField.text else {
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
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let cvv = textField.text else {
            return
        }
        cardViewDelegate?.didUpdate(cvv: cvv)
    }
}

extension CVVView: CardTextView {
    public func isValid(valid: Bool) {
        textField.textColor = valid ? UIColor.black : UIColor.red
    }
    
    public func clear() {
        textField.text = nil
    }
    
    public func isEnabled(_ enabled: Bool) {
        textField.isEnabled = enabled
    }
}

extension CVVView: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let cvv = textField.text {
            cardViewDelegate?.didEndUpdate(cvv: cvv)
        }
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return cardViewDelegate?.canUpdate(cvv: textField.text, withText: string, inRange: range) ?? false
    }
}
