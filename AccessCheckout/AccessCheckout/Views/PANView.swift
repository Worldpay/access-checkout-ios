import UIKit

/// A view representing a card's Primary Account Number
@IBDesignable public class PANView: UIView {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet public weak var imageView: UIImageView!
    
    /// The delegate to handle view events
    weak public var cardViewDelegate: CardViewDelegate?
    
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
    
    /// Initialize PANView from storyboard
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewFromNib()
    }
    
    /// Initializer override
    override public init(frame: CGRect) {
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
        if let pan = textField.text {
            cardViewDelegate?.didEndUpdate(pan: pan)
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return cardViewDelegate?.canUpdate(pan: textField.text, withText: string, inRange: range) ?? false
    }
}
