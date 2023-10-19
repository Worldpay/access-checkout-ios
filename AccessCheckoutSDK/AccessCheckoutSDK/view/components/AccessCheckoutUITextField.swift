import UIKit

@IBDesignable public final class AccessCheckoutUITextField: UIView {
    @IBOutlet internal var uiTextField: UITextField!

    internal init(_ uiTextField: UITextField) {
        super.init(frame: CGRect())
        self.uiTextField = uiTextField
    }
    
    init() {
        super.init(frame: CGRect())
        self.initSubViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initSubViews()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubViews()
    }
    
    private func initSubViews() {
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
    
    /* Properties relating to accessibility */
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
    
    /* Properties related to the text */
    internal var text: String? {
        set { self.uiTextField.text = newValue }
        get { self.uiTextField.text }
    }
    
    public var textColor: UIColor? {
        set { self.uiTextField.textColor = newValue }
        get { self.uiTextField.textColor }
    }
    
    public var font: UIFont? { // default is nil. use system font 12 pt
        set { self.uiTextField.font = newValue }
        get { self.uiTextField.font }
    }
    
    public var textAlignment: NSTextAlignment { // default is NSLeftTextAlignment
        set { self.uiTextField.textAlignment = newValue }
        get { self.uiTextField.textAlignment }
    }
    
    public var placeholder: String? {
        set { self.uiTextField.placeholder = newValue }
        get { self.uiTextField.placeholder }
    }
    
    @available(iOS 6.0, *)
    public var attributedPlaceholder: NSAttributedString? {
        set { self.uiTextField.attributedPlaceholder = newValue }
        get { self.uiTextField.attributedPlaceholder }
    }
    
    internal var delegate: UITextFieldDelegate? {
        set { self.uiTextField.delegate = newValue }
        get { self.uiTextField.delegate }
    }
    
    @available(iOS 3.2, *)
    public var selectedTextRange: UITextRange? {
        set { self.uiTextField.selectedTextRange = newValue }
        get { self.uiTextField.selectedTextRange }
    }
    
    public func clear() {
        self.uiTextField.text = ""
    }
    
    /* Properties related to keyboard appearance */
    public var keyboardAppearance: UIKeyboardAppearance { // default is UIKeyboardAppearanceDefault
        set { self.uiTextField.keyboardAppearance = newValue }
        get { self.uiTextField.keyboardAppearance }
    }
    
    public var keyboardType: UIKeyboardType { // default is UIKeyboardTypeDefault
        set { self.uiTextField.keyboardType = newValue }
        get { self.uiTextField.keyboardType }
    }

    /* Methods to send actions */
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
    
    /* Methods to add/remove event listeners */
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.uiTextField.addTarget(target, action: action, for: controlEvents)
    }
    
    public func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event) {
        self.uiTextField.removeTarget(target, action: action, for: controlEvents)
    }
    
    /* Methods related to first responder */
    override public func becomeFirstResponder() -> Bool {
        self.uiTextField.becomeFirstResponder()
    }
    
    override public func resignFirstResponder() -> Bool {
        self.uiTextField.resignFirstResponder()
    }
}
