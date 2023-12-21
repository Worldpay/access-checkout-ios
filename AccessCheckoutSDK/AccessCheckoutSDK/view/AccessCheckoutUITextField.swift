import UIKit

/**
 A UI component to capture the pan, expiry date or cvc of a payment card without being exposed to the text entered by the shopper.
 This design is to allow merchants to reach the lowest level of compliance (SAQ-A)
 */
@IBDesignable
public final class AccessCheckoutUITextField: UIView {
    internal lazy var uiTextField = buildTextField()
    
    private func buildTextField() -> UITextField {
        return self.buildTextFieldWithDefaults(textField: UITextField())
    }
    
    private func buildTextFieldWithDefaults(textField: UITextField) -> UITextField {
        let uiTextField = UITextField()
        
        // UITextField defaults
        uiTextField.keyboardType = .asciiCapableNumberPad
        
        uiTextField.frame = bounds
        uiTextField.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        
        addSubview(uiTextField)
        return uiTextField
    }
    
    internal init(_ uiTextField: UITextField) {
        super.init(frame: CGRect())
        self.uiTextField = uiTextField
        self.setStyles()
    }
    
    internal init() {
        super.init(frame: CGRect())
        self.setStyles()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setStyles()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setStyles()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setStyles()
    }
    
    private func setStyles() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = self.borderWidth
        
        self.uiTextField.keyboardType = self.keyboardType
        self.uiTextField.textColor = self.textColor
        self.uiTextField.placeholder = self.placeholder
    }
    
    // MARK: Public properties
    
    /* Accessibility properties */
    override public var isAccessibilityElement: Bool {
        set {
            self.uiTextField.isAccessibilityElement = newValue
        }
        get {
            false
        }
    }
    
    /**
     A hint that would typically be read by a screen reader when text is empty
     */
    override public var accessibilityHint: String? {
        set { self.uiTextField.accessibilityHint = newValue }
        get { nil }
    }
    
    /**
     An id that uniquely identifies an instance of this UI component
     */
    override public var accessibilityIdentifier: String? {
        set {
            super.accessibilityIdentifier = newValue
            self.uiTextField.accessibilityIdentifier = newValue != nil ? "\(newValue!)-UITextField" : nil
        }
        get {
            super.accessibilityIdentifier
        }
    }
    /**
     A label that represents this element and that may be used by a screen reader
     */
    override public var accessibilityLabel: String? {
        set { self.uiTextField.accessibilityLabel = newValue }
        get { nil }
    }
    /**
     The language ISO code that the element's label, value and hint should be spoken in.
     */
    override public var accessibilityLanguage: String? {
        set { self.uiTextField.accessibilityLanguage = newValue }
        get { nil }
    }
    
    /* Border properties */
    
    /**
     When positive, the border of this component will be drawn with rounded corners
     */
    @IBInspectable
    public var cornerRadius: CGFloat = 5 {
        didSet { self.layer.cornerRadius = self.cornerRadius }
    }
    /**
     The width of the border to be displayed
     */
    @IBInspectable
    public var borderWidth: CGFloat = 0.15 {
        didSet { self.layer.borderWidth = self.borderWidth }
    }
    
    /**
     The color of the border to be displayed
     */
    @IBInspectable
    public var borderColor: UIColor = .gray {
        didSet { self.layer.borderColor = self.borderColor.cgColor }
    }
    
    /* Text properties */
    
    /**
     The color of the text displayed in this component
     Default is nil and uses opaque black
     */
    @IBInspectable
    public var textColor: UIColor? {
        didSet { self.uiTextField.textColor = self.textColor }
    }
    
    /**
     The font of the text displayed in this component
     Default is nil and uses system font 12 pt
     */
    @IBInspectable
    public var font: UIFont? {
        didSet { self.uiTextField.font = self.font }
    }
    
    /**
     The alignement of the text displayed in this component
     */
    @IBInspectable
    public var textAlignment: NSTextAlignment = .left {
        didSet { self.uiTextField.textAlignment = self.textAlignment }
    }
    
    /* Placeholder properties */
    
    /**
     A hint that will be displayed when text is empty
     It usually describes the result of performing an action on the element
     */
    @IBInspectable
    public var placeholder: String? {
        didSet { self.uiTextField.placeholder = self.placeholder }
    }
    
    /**
     A rich text enabled hint that will be displayed when text is empty
     */
    @available(iOS 6.0, *)
    public var attributedPlaceholder: NSAttributedString? {
        didSet { self.uiTextField.attributedPlaceholder = self.attributedPlaceholder }
    }
    
    /* Keyboard properties */
    
    /**
     The type of the keyboard used by the shopper to type in their card details
     By default, this property is a numeric keypad
     */
    public var keyboardType: UIKeyboardType = .numberPad {
        didSet { self.uiTextField.keyboardType = self.keyboardType }
    }
    
    /**
     The appearance of the keyboard displayed to the shopper
     */
    public var keyboardAppearance: UIKeyboardAppearance = .default {
        didSet { self.uiTextField.keyboardAppearance = self.keyboardAppearance }
    }
    
    // MARK: Public methods
    
    /**
     Clears the text entered by the shopper
     */
    public func clear() {
        self.uiTextField.text = ""
        self.uiTextField.sendActions(for: .editingChanged)
    }
    
    override public func becomeFirstResponder() -> Bool {
        self.uiTextField.becomeFirstResponder()
    }
    
    override public func resignFirstResponder() -> Bool {
        self.uiTextField.resignFirstResponder()
    }
    
    // MARK: Internal properties
    
    internal var text: String? {
        get { self.uiTextField.text }
        set { self.uiTextField.text = newValue }
    }
    
    internal var delegate: UITextFieldDelegate? {
        get { self.uiTextField.delegate }
        set { self.uiTextField.delegate = newValue }
    }
}
