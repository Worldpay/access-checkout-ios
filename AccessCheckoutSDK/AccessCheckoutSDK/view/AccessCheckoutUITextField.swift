import Foundation
import UIKit
import os

/// A UI component to capture the pan, expiry date or cvc of a payment card without being exposed to the text entered by the shopper.
/// This design is to allow merchants to reach the lowest level of compliance (SAQ-A)
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
        verticalPadding: 4
    )

    internal lazy var uiTextField = buildTextFieldWithDefaults()

    private var uiTextFieldConstraints: [NSLayoutConstraint] = []

    private var _horizontalPadding: CGFloat = defaults.horizontalPadding
    // Event Support
    internal var externalOnFocusChangedListener: ((AccessCheckoutUITextField, Bool) -> Void)?

    private var _inputAccessoryView: UIView?

    private func buildTextFieldWithDefaults() -> UITextField {
        let uiTextField = FocusAwareUITextField(owner: self)

        // Apply defaults to UITextField
        uiTextField.translatesAutoresizingMaskIntoConstraints = false
        uiTextField.adjustsFontSizeToFitWidth = false
        uiTextField.adjustsFontForContentSizeCategory = true
        uiTextField.keyboardType = AccessCheckoutUITextField.defaults.keyboardType

        addSubview(uiTextField)
        return uiTextField
    }

    private final class FocusAwareUITextField: UITextField {
        var owner: AccessCheckoutUITextField

        init(owner: AccessCheckoutUITextField) {
            self.owner = owner
            // .zero is used to set size via AutoLayout instead
            super.init(frame: .zero)
        }

        // Required initializer for UIKit support when loading from storyboards or XIBs (not supported in this case)
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func becomeFirstResponder() -> Bool {
            let result = super.becomeFirstResponder()
            // Pass view
            if result { self.owner.externalOnFocusChangedListener?(self.owner, true) }
            return result
        }

        override func resignFirstResponder() -> Bool {
            let result = super.resignFirstResponder()
            // Pass view
            if result { self.owner.externalOnFocusChangedListener?(self.owner, false) }
            return result
        }
    }

    /// Sets a listener to be invoked when the focus state of the `AccessCheckoutUITextField` changes.
    ///
    /// - Parameter listener: A closure that takes two parameters:
    ///   - textField: The `AccessCheckoutUITextField` instance whose focus state has changed.
    ///   - hasFocus: A Boolean indicating whether the `textField` currently has focus.
    ///
    /// This method allows you to customize the behavior of the `AccessCheckoutUITextField` when it gains or loses focus.
    /// You can use this listener to modify the appearance or perform any action based on the focus state.
    ///
    /// Example usage:
    /// ```swift
    /// myfield.setOnFocusChangedListener { textField, hasFocus in
    ///     textField.borderColor = hasFocus ? .systemBlue : .systemGray
    /// }
    /// ```
    /// In the example above, the border color of the `myfield` changes to `systemBlue` when it gains focus,
    /// and reverts to `systemGray` when it loses focus.
    public func setOnFocusChangedListener(
        _ listener: @escaping (AccessCheckoutUITextField, Bool) -> Void
    ) {
        self.externalOnFocusChangedListener = listener
    }

    // this constructor is used only for unit tests so we do not call setLayout()
    // as otherwise activating constraints fail and that fails the unit tests
    internal init(_ uiTextField: UITextField) {
        super.init(frame: CGRect())
        self.uiTextField = uiTextField
        self.setStyles()
    }

    internal init() {
        super.init(frame: CGRect())
        self.setStyles()
        self.setLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setStyles()
        self.setLayout()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setStyles()
        self.setLayout()
    }

    private func setLayout() {
        if !self.uiTextFieldConstraints.isEmpty {
            NSLayoutConstraint.deactivate(self.uiTextFieldConstraints)
        }

        self.uiTextFieldConstraints = [
            self.uiTextField.topAnchor.constraint(
                equalTo: topAnchor,
                constant: AccessCheckoutUITextField.defaults.verticalPadding
            ),
            self.uiTextField.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -AccessCheckoutUITextField.defaults.verticalPadding
            ),
            self.uiTextField.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: self.horizontalPadding
            ),
            self.uiTextField.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -self.horizontalPadding
            ),
        ]

        NSLayoutConstraint.activate(self.uiTextFieldConstraints)
    }

    override public var intrinsicContentSize: CGSize {
        let width = self.uiTextField.intrinsicContentSize.height
        let height =
            self.uiTextField.intrinsicContentSize.height
            + 2 * (self.borderWidth + AccessCheckoutUITextField.defaults.verticalPadding)

        return CGSize(width: width, height: height)
    }

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setStyles()
        self.setLayout()
        self.invalidateIntrinsicContentSize()
    }

    private func setStyles() {
        self.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        self.uiTextField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

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
            self.uiTextField.accessibilityIdentifier =
                newValue != nil ? "\(newValue!)-UITextField" : nil
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
    public var horizontalPadding: CGFloat {
        set {
            self._horizontalPadding = newValue
            self.setLayout()
        }
        get {
            self._horizontalPadding
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
     Default is nil
     */
    @IBInspectable
    public var font: UIFont? {
        didSet {
            self.uiTextField.font = self.font
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

    /**
     This property is used to improve keyboard suggestions and autofill behavior.
     Default is nil, which means no specific content type is set.
     */
    @IBInspectable
    public var textContentType: UITextContentType? {
        didSet { self.uiTextField.textContentType = self.textContentType }
    }

    /**
     The accessory view to attach to the keyboard when this component receives focus
     */
    public override var inputAccessoryView: UIView? {
        get {
            _inputAccessoryView
        }
        set {
            _inputAccessoryView = newValue
            self.uiTextField.inputAccessoryView = _inputAccessoryView
        }
    }

    /* Enabled properties */
    @IBInspectable
    public var isEnabled: Bool = true {
        didSet {
            self.uiTextField.isEnabled = self.isEnabled

            if !self.isEnabled
                && self.colorsAreEqual(
                    self.backgroundColor,
                    AccessCheckoutUITextField.defaults.backgroundColor
                )
            {
                self.backgroundColor = AccessCheckoutUITextField.defaults.disabledBackgroundColor
            } else if self.isEnabled
                && self.colorsAreEqual(
                    self.backgroundColor,
                    AccessCheckoutUITextField.defaults.disabledBackgroundColor
                )
            {
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
    let verticalPadding: CGFloat
}
