import UIKit

@IBDesignable
public final class AccessCheckoutUITextField: UIView {
    @IBOutlet internal var uiTextField: UITextField!

    internal init(_ uiTextField: UITextField) {
        super.init(frame: CGRect())
        self.uiTextField = uiTextField
        self.setStyles()
    }
    
    init() {
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
        self.setStyles()
    }
    
    private func addSubViews() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        
        addSubview(view)
    }
    
    private func setStyles() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = self.borderWidth
        self.uiTextField.keyboardType = self.keyboardType
    }
    
    // MARK: Public properties

    /* Accessibility properties */
    override public var isAccessibilityElement: Bool {
        set { self.uiTextField.isAccessibilityElement = newValue }
        get { false }
    }
    
    override public var accessibilityHint: String? {
        set { self.uiTextField.accessibilityHint = newValue }
        get { nil }
    }
    
    override public var accessibilityIdentifier: String? {
        set { self.uiTextField.accessibilityIdentifier = newValue }
        get { nil }
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
        didSet { self.layer.cornerRadius = self.cornerRadius }
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
    @available(iOS 6.0, *)
    public var attributedPlaceholder: NSAttributedString? {
        didSet { self.uiTextField.attributedPlaceholder = self.attributedPlaceholder }
    }
    
    @IBInspectable
    public var placeholder: String? {
        didSet { self.uiTextField.placeholder = self.placeholder }
    }
    
    /* Properties related to keyboard appearance */
    public var keyboardAppearance: UIKeyboardAppearance = .default {
        didSet { self.uiTextField.keyboardAppearance = self.keyboardAppearance }
    }
    
    public var keyboardType: UIKeyboardType = .numberPad {
        didSet { self.uiTextField.keyboardType = self.keyboardType }
    }

    // MARK: Public methods

    public func clear() {
        self.uiTextField.text = ""
    }
    
    public func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        self.uiTextField.sendAction(action, to: target, for: event)
    }
    
    @available(iOS 14.0, *)
    public func sendAction(_ action: UIAction) {
        self.uiTextField.sendAction(action)
    }
    
    public func sendActions(for controlEvents: UIControl.Event) {
        self.uiTextField.sendActions(for: controlEvents)
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
