import UIKit

@IBDesignable
public final class AccessCheckoutUITextField: UIView {
    internal lazy var uiTextField: UITextField! = {
           return build();
       }()

    private func build() -> UITextField {
           let uiTextField = UITextField();
           uiTextField.keyboardType = .asciiCapableNumberPad
           return uiTextField;
       }
    internal init(_ uiTextField: UITextField) {
        super.init(frame: CGRect())
        self.uiTextField = uiTextField
        self.setStyles()
    }
    
    internal init() {
        super.init(frame: CGRect())
        self.addSubViews()
        self.setStyles()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addSubViews()
        self.setStyles()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews()
        self.setStyles()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setStyles()
    }
    
    private func addSubViews() {
        uiTextField.frame = bounds
        uiTextField.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        
        addSubview(uiTextField)
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
    
    override public var accessibilityHint: String? {
        set { self.uiTextField.accessibilityHint = newValue }
        get { nil }
    }
    
    override public var accessibilityIdentifier: String? {
        set {
            super.accessibilityIdentifier = newValue
            self.uiTextField.accessibilityIdentifier = newValue != nil ? "\(newValue!)-UITextField" : nil
        }
        get {
            super.accessibilityIdentifier
        }
    }
    
    override public var accessibilityLabel: String? {
        set { self.uiTextField.accessibilityLabel = newValue }
        get { nil }
    }
    
    override public var accessibilityLanguage: String? {
        set { self.uiTextField.accessibilityLanguage = newValue }
        get { nil }
    }
    
    /* Border properties */
    @IBInspectable
    public var cornerRadius: CGFloat = 5 {
        didSet { self.layer.cornerRadius = self.cornerRadius }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 0.15 {
        didSet { self.layer.borderWidth = self.borderWidth }
    }
    
    @IBInspectable
    public var borderColor: UIColor = .gray {
        didSet { self.layer.borderColor = self.borderColor.cgColor }
    }
    
    /* Text properties */
    @IBInspectable
    public var textColor: UIColor? { // default is nil. use opaque black
        didSet { self.uiTextField.textColor = self.textColor }
    }
    
    @IBInspectable
    public var font: UIFont? { // default is nil. use system font 12 pt
        didSet { self.uiTextField.font = self.font }
    }
    
    @IBInspectable
    public var textAlignment: NSTextAlignment = .left {
        didSet { self.uiTextField.textAlignment = self.textAlignment }
    }
    
    /* Placeholder properties */
    @IBInspectable
    public var placeholder: String? {
        didSet { self.uiTextField.placeholder = self.placeholder }
    }
    
    @available(iOS 6.0, *)
    public var attributedPlaceholder: NSAttributedString? {
        didSet { self.uiTextField.attributedPlaceholder = self.attributedPlaceholder }
    }
    
    /* Keyboard properties */
    public var keyboardType: UIKeyboardType = .numberPad {
        didSet { self.uiTextField.keyboardType = self.keyboardType }
    }

    public var keyboardAppearance: UIKeyboardAppearance = .default {
        didSet { self.uiTextField.keyboardAppearance = self.keyboardAppearance }
    }
    
    // MARK: Public methods

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
