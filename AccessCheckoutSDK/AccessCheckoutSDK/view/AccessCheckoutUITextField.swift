import UIKit

/**
 A UI component to capture the pan, expiry date or cvc of a payment card without being exposed to the text entered by the shopper.
 This design is to allow merchants to reach the lowest level of compliance (SAQ-A)
 */
@IBDesignable
public final class AccessCheckoutUITextField: UIView {
    internal static let defaults = AccessCheckoutUITextFieldDefaults(
        backgroundColor: .white,
        disabledBackgroundColor: toUIColor(hexadecimal: 0xFBFBFB),
        borderColor: toUIColor(hexadecimal: 0xE9E9E9),
        borderWidth: 1,
        cornerRadius: 5,
        textAlignment: .left,
        keyboardType: .asciiCapableNumberPad,
        keyboardAppearance: .default,
        horizontalPadding: 6,
        font: .preferredFont(forTextStyle: .caption1)
    )
    
    internal lazy var uiTextField = buildTextField()
    
    private func buildTextField() -> UITextField {
        return self.buildTextFieldWithDefaults(textField: UITextField())
    }
    
    private func buildTextFieldWithDefaults(textField: UITextField) -> UITextField {
        let uiTextField = UITextField()
        
        // UITextField defaults
        uiTextField.keyboardType = AccessCheckoutUITextField.defaults.keyboardType
        
        uiTextField.frame = bounds.insetBy(dx: AccessCheckoutUITextField.defaults.horizontalPadding, dy: 0)
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
        self.uiTextField.font = self.font
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
    
    /* Padding properties */
    
    /**
     A value that represents the padding between the border and the text
     */
    @IBInspectable
    public var horizontalPadding: CGFloat = defaults.horizontalPadding {
        didSet {
            self.uiTextField.frame = bounds.insetBy(dx: horizontalPadding, dy: 0)
            self.setNeedsLayout()
        }
    }
    
    /* Border properties */
    
    /**
     When positive, the border of this component will be drawn with rounded corners
     */
    @IBInspectable
    public var cornerRadius: CGFloat = defaults.cornerRadius {
        didSet { self.layer.cornerRadius = self.cornerRadius }
    }

    /**
     The width of the border to be displayed
     */
    @IBInspectable
    public var borderWidth: CGFloat = defaults.borderWidth {
        didSet { self.layer.borderWidth = self.borderWidth }
    }
    
    /**
     The color of the border to be displayed
     */
    @IBInspectable
    public var borderColor: UIColor = defaults.borderColor {
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
    public var font: UIFont = defaults.font {
        didSet {
            self.uiTextField.font = self.font
            self.uiTextField.adjustsFontForContentSizeCategory = true
        }
    }
    
    /**
     The alignement of the text displayed in this component
     */
    @IBInspectable
    public var textAlignment: NSTextAlignment = defaults.textAlignment {
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
    public var keyboardType: UIKeyboardType = defaults.keyboardType {
        didSet { self.uiTextField.keyboardType = self.keyboardType }
    }
    
    /**
     The appearance of the keyboard displayed to the shopper
     */
    public var keyboardAppearance: UIKeyboardAppearance = defaults.keyboardAppearance {
        didSet { self.uiTextField.keyboardAppearance = self.keyboardAppearance }
    }

    /* Enabled properties */
    @IBInspectable
    public var isEnabled: Bool = true {
        didSet {
            self.uiTextField.isEnabled = self.isEnabled
            
            if !self.isEnabled && self.colorsAreEqual(self.backgroundColor, AccessCheckoutUITextField.defaults.backgroundColor) {
                self.backgroundColor = AccessCheckoutUITextField.defaults.disabledBackgroundColor
            } else if self.isEnabled && self.colorsAreEqual(self.backgroundColor, AccessCheckoutUITextField.defaults.disabledBackgroundColor) {
                self.backgroundColor = AccessCheckoutUITextField.defaults.backgroundColor
            }
        }
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
    
    private static func toUIColor(hexadecimal: Int) -> UIColor {
        let red = Double((hexadecimal & 0xFF0000) >> 16) / 255.0
        let green = Double((hexadecimal & 0xFF00) >> 8) / 255.0
        let blue = Double(hexadecimal & 0xFF) / 255.0
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
    }
    
    private func colorsAreEqual(_ color1: UIColor?, _ color2: UIColor?) -> Bool {
        if color1 == nil && color2 == nil {
            return true
        } else if color1 == nil {
            return false
        } else if color2 == nil {
            return false
        }
        
        var lhsR: CGFloat = 0
        var lhsG: CGFloat = 0
        var lhsB: CGFloat = 0
        var lhsA: CGFloat = 0
        color1!.getRed(&lhsR, green: &lhsG, blue: &lhsB, alpha: &lhsA)
        
        var rhsR: CGFloat = 0
        var rhsG: CGFloat = 0
        var rhsB: CGFloat = 0
        var rhsA: CGFloat = 0
        color2!.getRed(&rhsR, green: &rhsG, blue: &rhsB, alpha: &rhsA)
        
        return lhsR == rhsR
            && lhsG == rhsG
            && lhsB == rhsB
            && lhsA == rhsA
    }
}

struct AccessCheckoutUITextFieldDefaults {
    let backgroundColor: UIColor
    let disabledBackgroundColor: UIColor
    let borderColor: UIColor
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    let textAlignment: NSTextAlignment
    let keyboardType: UIKeyboardType
    let keyboardAppearance: UIKeyboardAppearance
    let horizontalPadding: CGFloat
    let font: UIFont
}
