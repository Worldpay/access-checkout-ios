import UIKit

@IBDesignable public class PANView: UIView {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet public weak var imageView: UIImageView!
    
    weak public var cardViewDelegate: CardViewDelegate?
    
    public var text: PAN? {
        guard let text = textField.text else {
            return nil
        }
        guard !text.isEmpty else {
            return nil
        }
        return text
    }
    
    public required init?(coder aDecoder: NSCoder) {
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
        
        textField.placeholder = NSLocalizedString("card_number_placeholder", comment: "")
        textField.delegate = self
        textField.addTarget(self, action: #selector(cardNumberTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc
    private func cardNumberTextFieldDidChange(_ textField: UITextField) {
        guard let pan = textField.text else {
            return
        }
        cardViewDelegate?.didUpdate(pan: pan)
    }
}

extension PANView: CardTextView {
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

extension PANView: UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let pan = textField.text {
            cardViewDelegate?.didEndUpdate(pan: pan)
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return cardViewDelegate?.canUpdate(pan: textField.text, withText: string, inRange: range) ?? false
    }
}
