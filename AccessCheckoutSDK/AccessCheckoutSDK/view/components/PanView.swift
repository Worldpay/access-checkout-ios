import UIKit

/**
 A view representing a card's Card Number
 - text: `String` representing the Card Number entered by the end user
 - isEnabled: `Boolean` allowing to enable or disable editing
 - textColor: `UIColor?` allowing to set the colour of the text displayed in the textinput
 - imageView: A `UIImageView`  to display the image of the card brand that was detected by the SDK using the Card Number entered in the textinput by the end user
 - clear(): clears the text that was entered by the end user
 */
@IBDesignable public class PanView: UIView {
    @IBOutlet weak var textField: UITextField!
    
    /**
     A `UIImageView`  to display the image of the card brand that was detected by the SDK using th Card Number entered in the textinput by the end user
     */
    @IBOutlet weak public var imageView: UIImageView!
    
    var presenter: Presenter?
    
    private var textChangeHandler = TextChangeHandler()
    
    /// Initialize PanView from storyboard
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
        
        textField.placeholder = NSLocalizedString("card_number_placeholder", comment: "")
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let pan = textField.text else {
            return
        }
        (presenter as? PanViewPresenter)?.onEditing(text: pan)
    }
}

extension PanView: AccessCheckoutTextView {
    /**
     `String` representing the Card Number entered by the end user
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
        (presenter as? PanViewPresenter)?.onEditing(text: "")
    }
}

extension PanView: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let pan = textField.text else {
            return
        }
        (presenter as? PanViewPresenter)?.onEditEnd(text: pan)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let presenter = (presenter as? PanViewPresenter) else {
            return true
        }
        
        let resultingText = textChangeHandler.change(originalText: textField.text, textChange: string, usingSelection: range)
        return presenter.canChangeText(with: resultingText)
    }
}
