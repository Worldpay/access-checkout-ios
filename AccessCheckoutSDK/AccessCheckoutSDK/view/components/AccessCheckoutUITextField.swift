import UIKit

@IBDesignable public class AccessCheckoutUITextField: UIView {
    @IBOutlet internal var uiTextField: UITextField!

    init() {
        super.init(frame: CGRect())
        initSubViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
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
    
    internal var text: String? {
        set { self.uiTextField.text = newValue }
        get { self.uiTextField.text }
    }
    
    internal var delegate: UITextFieldDelegate? {
        set { self.uiTextField.delegate = newValue }
        get { self.uiTextField.delegate }
    }
    
    public var placeholder: String? {
        set { self.uiTextField.placeholder = newValue }
        get { self.uiTextField.placeholder }
    }
    
    public var textColor: UIColor? {
        set { self.uiTextField.textColor = newValue }
        get { self.uiTextField.textColor }
    }
    
    public var selectedTextRange: UITextRange? {
        set { self.uiTextField.selectedTextRange = newValue }
        get { self.uiTextField.selectedTextRange }
    }
    
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.uiTextField.addTarget(target, action:action, for: controlEvents)
    }

    public func clear() {
        self.uiTextField.text = ""
    }
    
    public func offset(from: UITextPosition, to: UITextPosition) -> Int {
        return self.uiTextField.offset(from: from, to: to)
    }
    
    /* The end and beginning of the the text document. */
    @available(iOS 3.2, *)
    public var beginningOfDocument: UITextPosition {
        get { self.uiTextField.beginningOfDocument }
    }

    @available(iOS 3.2, *)
    public var endOfDocument: UITextPosition {
        get { self.uiTextField.endOfDocument }
    }
    
    /* Methods for creating ranges and positions. */
    @available(iOS 3.2, *)
    public func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
        return self.uiTextField.position(from: position, offset: offset)
    }

    @available(iOS 3.2, *)
    public func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? {
        return self.uiTextField.position(from: position, in:direction, offset: offset)
    }
    
    @available(iOS 3.2, *)
    public func textRange(from: UITextPosition, to: UITextPosition) -> UITextRange? {
        return self.uiTextField.textRange(from: from, to: to)
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
}
