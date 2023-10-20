import Foundation
import UIKit

class UITextFieldMock: UITextField {
    public private(set) var becomeFirstResponderCalled: Bool = false
    public private(set) var resignFirstResponderCalled: Bool = false
    public private(set) var offsetCalled: Bool = false
    public private(set) var positionCalled: Bool = false
    public private(set) var textRangeCalled: Bool = false
    public private(set) var addTargetCalled: Bool = false
    public private(set) var removeTargetCalled: Bool = false
    
    private var _beginningOfDocument: UITextPosition?
    override var beginningOfDocument: UITextPosition {
        if let mockValue = _beginningOfDocument {
            return mockValue
        } else {
            return super.beginningOfDocument
        }
    }

    public func setBeginningOfDocument(_ uiTextPosition: UITextPosition) {
        self._beginningOfDocument = uiTextPosition
    }
    
    private var _endOfDocument: UITextPosition?
    override var endOfDocument: UITextPosition {
        if let mockValue = _endOfDocument {
            return mockValue
        } else {
            return super.endOfDocument
        }
    }

    public func setEndOfDocument(_ uiTextPosition: UITextPosition) {
        self._endOfDocument = uiTextPosition
    }
    
    private var _selectedTextRange: UITextRange?
    override var selectedTextRange: UITextRange? {
        set { _selectedTextRange = newValue }
        get { _selectedTextRange }
    }
    
    override public func becomeFirstResponder() -> Bool {
        self.becomeFirstResponderCalled = true
        return true
    }
   
    override public func resignFirstResponder() -> Bool {
        self.resignFirstResponderCalled = true
        return true
    }
    
    override public func offset(from: UITextPosition, to: UITextPosition) -> Int {
        offsetCalled = true
        return 0
    }
    
    override public func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
        positionCalled = true
        return nil
    }
    
    override public func textRange(from: UITextPosition, to: UITextPosition) -> UITextRange? {
        textRangeCalled = true
        return nil
    }
    
    override public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        addTargetCalled = true
    }
    
    override public func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event) {
        removeTargetCalled = true
    }
}
