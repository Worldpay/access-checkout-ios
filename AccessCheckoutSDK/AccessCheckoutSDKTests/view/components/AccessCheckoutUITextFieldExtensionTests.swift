@testable import AccessCheckoutSDK
import Foundation
import XCTest

class AccessCheckoutUITextFieldExtensionTests: XCTestCase {
    func testBeginningOfDocumentDelegatesCallToUITextField() {
        let uiTextFieldMock = UITextFieldMock()
        let position = UITextPosition()
        uiTextFieldMock.setBeginningOfDocument(position)
        
        let textField = AccessCheckoutUITextField(uiTextFieldMock)
        
        XCTAssertTrue(textField.beginningOfDocument === position)
    }
    
    func testEndOfDocumentDelegatesCallToUITextField() {
        let uiTextFieldMock = UITextFieldMock()
        let position = UITextPosition()
        uiTextFieldMock.setEndOfDocument(position)
        
        let textField = AccessCheckoutUITextField(uiTextFieldMock)
        
        XCTAssertTrue(textField.endOfDocument === position)
    }
    
    func testOffsetDelegatesCallToUITextField() {
        let uiTextFieldMock = UITextFieldMock()
        let textField = AccessCheckoutUITextField(uiTextFieldMock)
        
        _ = textField.offset(from: UITextPosition(), to: UITextPosition())
        
        XCTAssertTrue(uiTextFieldMock.offsetCalled)
    }
    
    func testPositionDelegatesCallToUITextField() {
        let uiTextFieldMock = UITextFieldMock()
        let textField = AccessCheckoutUITextField(uiTextFieldMock)
        
        _ = textField.position(from: UITextPosition(), offset: 1)
        
        XCTAssertTrue(uiTextFieldMock.positionCalled)
    }
    
    func testTextRangeDelegatesCallToUITextField() {
        let uiTextFieldMock = UITextFieldMock()
        let textField = AccessCheckoutUITextField(uiTextFieldMock)
        
        _ = textField.textRange(from: UITextPosition(), to: UITextPosition())
        
        XCTAssertTrue(uiTextFieldMock.textRangeCalled)
    }
    
    func testSelectedTextRangeGetterReturnsUITextFieldSelectedTextRange() {
        let uiTextField = UITextFieldMock()
        let textField = AccessCheckoutUITextField(uiTextField)

        let selectedTextRange = UITextRange()
        uiTextField.selectedTextRange = selectedTextRange
        
        XCTAssertNotNil(textField.selectedTextRange)
        XCTAssertTrue(textField.selectedTextRange === selectedTextRange)
    }
    
    func testSelectedTextRangeSetterSetsUITextFieldSelectedTextRange() {
        let uiTextField = UITextFieldMock()
        let textField = AccessCheckoutUITextField(uiTextField)
        
        let selectedTextRange = UITextRange()
        textField.selectedTextRange = selectedTextRange

        XCTAssertNotNil(textField.uiTextField.selectedTextRange)
        XCTAssertTrue(textField.uiTextField.selectedTextRange === selectedTextRange)
    }
    
    func testAddTargetDelegatesCallToUITextField() {
        let uiTextFieldMock = UITextFieldMock()
        let textField = AccessCheckoutUITextField(uiTextFieldMock)
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingDidEnd)
        
        XCTAssertTrue(uiTextFieldMock.addTargetCalled)
    }
    
    func testRemoveTargetDelegatesCallToUITextField() {
        let uiTextFieldMock = UITextFieldMock()
        let textField = AccessCheckoutUITextField(uiTextFieldMock)
        
        textField.removeTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingDidEnd)
        
        XCTAssertTrue(uiTextFieldMock.removeTargetCalled)
    }
    
    @objc
    private func textFieldEditingChanged(_ textField: UITextField) {}
}
