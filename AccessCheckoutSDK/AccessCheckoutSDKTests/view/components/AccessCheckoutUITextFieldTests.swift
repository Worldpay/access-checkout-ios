@testable import AccessCheckoutSDK
import Foundation
import XCTest

class AccessCheckoutUITextFieldTests: XCTestCase {
    // MARK: constructors tests

    func testCGRectConstructorInitialiasesTextFieldWithDefaultStyles() {
        let textField = AccessCheckoutUITextField(frame: CGRect())
        
        // Styles set on the view itself
        XCTAssertEqual(5, textField.layer.cornerRadius)
        XCTAssertEqual(UIColor.gray.cgColor, textField.layer.borderColor)
        XCTAssertEqual(0.15, textField.layer.borderWidth)
        
        // Styles set on the uiTextField
        XCTAssertEqual(UIKeyboardType.numberPad.rawValue, textField.uiTextField.keyboardType.rawValue)
    }
    
    // MARK: interface builder support

    func testPrepareForInterfaceBuilderSetsStyles() {
        let textField = AccessCheckoutUITextField(frame: CGRect())
        textField.cornerRadius = 10
        textField.borderColor = UIColor.green
        textField.borderWidth = 2
        textField.keyboardType = .namePhonePad
        textField.placeholder = "some placeholder"
        textField.textColor = UIColor.yellow
        
        textField.prepareForInterfaceBuilder()
        
        // Styles set on the view itself
        XCTAssertEqual(10, textField.layer.cornerRadius)
        XCTAssertEqual(UIColor.green.cgColor, textField.layer.borderColor)
        XCTAssertEqual(2, textField.layer.borderWidth)
        
        // Styles set on the uiTextField
        XCTAssertEqual(UIKeyboardType.namePhonePad.rawValue, textField.uiTextField.keyboardType.rawValue)
        XCTAssertEqual("some placeholder", textField.uiTextField.placeholder)
        XCTAssertEqual(UIColor.yellow, textField.uiTextField.textColor)
        
        // TODO: add support for other properties
    }
    
    // MARK: Accessibility properties tests

    // isAccessibilityElement
    func testIsAccessibilityElementGetterAlwaysReturnsTrue() {
        let textField = createTextField()
        XCTAssertTrue(textField.isAccessibilityElement)
        
        textField.isAccessibilityElement = false
        XCTAssertTrue(textField.isAccessibilityElement)
    }
    
    func testIsAccessibilityElementSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        XCTAssertFalse(textField.uiTextField.isAccessibilityElement)
        
        textField.isAccessibilityElement = true
        XCTAssertTrue(textField.uiTextField.isAccessibilityElement)
    }
    
    // accessibilityHint
    func testAccessibilityHintGetterAlwaysReturnsNil() {
        let textField = createTextField()
        XCTAssertNil(textField.accessibilityHint)
        
        textField.accessibilityHint = "something"
        XCTAssertNil(textField.accessibilityHint)
    }
    
    func testAccessibilityHintSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        XCTAssertNil(textField.uiTextField.accessibilityHint)
        
        textField.accessibilityHint = "something"
        XCTAssertEqual("something", textField.uiTextField.accessibilityHint)
    }
    
    // accessibilityIdentifier
    func testAccessibilityIdentifierGetterAlwaysReturnsNil() {
        let textField = createTextField()
        XCTAssertNil(textField.accessibilityIdentifier)
         
        textField.accessibilityHint = "something"
        XCTAssertNil(textField.accessibilityIdentifier)
    }
     
    func testAccessibilityIdentifierSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        XCTAssertNil(textField.uiTextField.accessibilityIdentifier)
         
        textField.accessibilityIdentifier = "something"
        XCTAssertEqual("something", textField.uiTextField.accessibilityIdentifier)
    }
    
    // accessibilityLabel
    func testAccessibilityLabelGetterAlwaysReturnsNil() {
        let textField = createTextField()
        XCTAssertNil(textField.accessibilityLabel)
         
        textField.accessibilityLabel = "something"
        XCTAssertNil(textField.accessibilityLabel)
    }
     
    func testAccessibilityLabelSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        XCTAssertNil(textField.uiTextField.accessibilityLabel)
         
        textField.accessibilityLabel = "something"
        XCTAssertEqual("something", textField.uiTextField.accessibilityLabel)
    }
    
    // accessibilityLanguage
    func testAccessibilityLanguageGetterAlwaysReturnsNil() {
        let textField = createTextField()
        XCTAssertNil(textField.accessibilityLanguage)
         
        textField.accessibilityLabel = "something"
        XCTAssertNil(textField.accessibilityLanguage)
    }
     
    func testAccessibilityLanguageSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        XCTAssertNil(textField.uiTextField.accessibilityLanguage)
         
        textField.accessibilityLanguage = "something"
        XCTAssertEqual("something", textField.uiTextField.accessibilityLanguage)
    }

    // MARK: Border properties tests
    
    // cornerRadius
    func testCornerRadiusIs5ByDefault() {
        let textField = createTextField()

        XCTAssertEqual(5, textField.cornerRadius)
    }

    func testCornerRadiusGetterReturnsValueSet() {
        let textField = createTextField()
        let expected: CGFloat = 3
        
        textField.cornerRadius = expected
        
        XCTAssertEqual(expected, textField.cornerRadius)
    }
       
    func testCornerRadiusSetterSetsLayerProperty() {
        let textField = createTextField()
        let expected: CGFloat = 3
        
        textField.cornerRadius = expected
         
        XCTAssertEqual(expected, textField.layer.cornerRadius)
    }
    
    // borderWidth
    func testBorderWidthIs0Point15ByDefault() {
        let textField = createTextField()

        XCTAssertEqual(0.15, textField.borderWidth)
    }

    func testBorderWidthGetterReturnsValueSet() {
        let textField = createTextField()
        let expected: CGFloat = 3
        
        textField.borderWidth = expected
        
        XCTAssertEqual(expected, textField.borderWidth)
    }
       
    func testBorderWidthSetterSetsLayerProperty() {
        let textField = createTextField()
        let expected: CGFloat = 3
        
        textField.borderWidth = expected
         
        XCTAssertEqual(expected, textField.layer.borderWidth)
    }
    
    // borderColor
    func testBorderColorIsGrayByDefault() {
        let textField = createTextField()

        XCTAssertEqual(.gray, textField.borderColor)
    }

    func testBorderColorGetterReturnsValueSet() {
        let textField = createTextField()
        let expected = UIColor.green
        
        textField.borderColor = expected

        XCTAssertEqual(expected, textField.borderColor)
    }
       
    func testBorderColorSetterSetsLayerProperty() {
        let textField = createTextField()
        let expected = UIColor.green
        
        textField.borderColor = expected
         
        XCTAssertEqual(expected.cgColor, textField.layer.borderColor)
    }
    
    // MARK: Text properties
    
    // textColor
    func testTextColorIsNilByDefault() {
        let textField = createTextField()

        XCTAssertNil(textField.textColor)
    }

    func testTextColorGetterReturnsValueSet() {
        let textField = createTextField()
        let expected = UIColor.green
        
        textField.textColor = expected

        XCTAssertEqual(expected, textField.uiTextField.textColor)
    }
       
    func testTextColorSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        let expected = UIColor.green
        
        textField.textColor = expected
         
        XCTAssertEqual(expected, textField.uiTextField.textColor)
    }
    
    // font
    func testFontIsNilByDefault() {
        let textField = createTextField()

        XCTAssertNil(textField.font)
    }

    func testFontGetterReturnsValueSet() {
        let textField = createTextField()
        let expected = UIFont.boldSystemFont(ofSize: 3)

        textField.font = expected

        XCTAssertEqual(expected, textField.font)
    }
       
    func testFontSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        let expected = UIFont.boldSystemFont(ofSize: 3)
        
        textField.font = expected
         
        XCTAssertEqual(expected, textField.uiTextField.font)
    }
    
    // textAlignment
    func testTextAlignmentIsLeftByDefault() {
        let textField = createTextField()

        XCTAssertEqual(NSTextAlignment.left, textField.textAlignment)
    }

    func testTextAlignmentGetterReturnsValueSet() {
        let textField = createTextField()
        let expected = NSTextAlignment.right

        textField.textAlignment = expected

        XCTAssertEqual(expected, textField.textAlignment)
    }
       
    func testTextAlignmentSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        let expected = NSTextAlignment.right
        
        textField.textAlignment = expected
         
        XCTAssertEqual(expected, textField.uiTextField.textAlignment)
    }
    
    // MARK: Placeholder properties

    // textAlignment
    func testPlacholderIsNilByDefault() {
        let textField = createTextField()

        XCTAssertNil(textField.placeholder)
    }

    func testPlacholderGetterReturnsValueSet() {
        let textField = createTextField()
        let expected = "something"

        textField.placeholder = expected

        XCTAssertEqual(expected, textField.placeholder)
    }
       
    func testPlacholderSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        let expected = "something"
        
        textField.placeholder = expected
         
        XCTAssertEqual(expected, textField.uiTextField.placeholder)
    }
    
    // attributedPlacholder
    func testAttributedPlacholderIsNilByDefault() {
        let textField = createTextField()

        XCTAssertNil(textField.attributedPlaceholder)
    }

    func testAttributedPlacholderGetterReturnsValueSet() {
        let textField = createTextField()
        let expected = NSAttributedString(string: "something")

        textField.attributedPlaceholder = expected

        XCTAssertEqual(expected, textField.attributedPlaceholder)
    }
       
    func testAttributedPlacholderSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        let expected = NSAttributedString(string: "something")
        
        textField.attributedPlaceholder = expected
         
        XCTAssertEqual(expected, textField.uiTextField.attributedPlaceholder)
    }
    
    // MARK: keyboard properties
    
    // keyboardType
    func testKeyboardTypeIsDefaultByDefault() {
        let textField = createTextField()

        XCTAssertEqual(UIKeyboardType.numberPad, textField.keyboardType)
    }

    func testKeyboardTypeGetterReturnsValueSet() {
        let textField = createTextField()
        let expected = UIKeyboardType.namePhonePad

        textField.keyboardType = expected

        XCTAssertEqual(expected, textField.keyboardType)
    }
       
    func testKeyboardTypeSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        let expected = UIKeyboardType.namePhonePad
        
        textField.keyboardType = expected
         
        XCTAssertEqual(expected, textField.uiTextField.keyboardType)
    }
    
    // keyboardAppearance
    func testKeyboardAppearanceIsDefaultByDefault() {
        let textField = createTextField()

        XCTAssertEqual(UIKeyboardAppearance.default, textField.keyboardAppearance)
    }

    func testKeyboardAppearanceGetterReturnsValueSet() {
        let textField = createTextField()
        let expected = UIKeyboardAppearance.dark

        textField.keyboardAppearance = expected

        XCTAssertEqual(expected, textField.keyboardAppearance)
    }
       
    func testKeyboardAppearanceSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        let expected = UIKeyboardAppearance.dark
        
        textField.keyboardAppearance = expected
         
        XCTAssertEqual(expected, textField.uiTextField.keyboardAppearance)
    }
    
    // MARK: methods properties

    func testClearClearsUITextFieldtext() {
        let textField = createTextField()
        textField.uiTextField.text = "something"
        XCTAssertEqual("something", textField.uiTextField.text)
        
        textField.clear()
        
        XCTAssertEqual("", textField.uiTextField.text)
    }
    
    func testBecomeFirstResponderDelegatesCallToUITextField() {
        let uiTextFieldMock = UITextFieldMock()
        let textField = AccessCheckoutUITextField(uiTextFieldMock)
        
        _ = textField.becomeFirstResponder()
        
        XCTAssertTrue(uiTextFieldMock.becomeFirstResponderCalled)
    }
    
    func testResignFirstResponderDelegatesCallToUITextField() {
        let uiTextFieldMock = UITextFieldMock()
        let textField = AccessCheckoutUITextField(uiTextFieldMock)
        
        _ = textField.resignFirstResponder()
        
        XCTAssertTrue(uiTextFieldMock.resignFirstResponderCalled)
    }
    
    // MARK: Internal properties
    
    // text
    func testTextGetterReturnsUITextFieldText() {
        let textField = createTextField()
        let expected = "something"
        XCTAssertEqual("", textField.uiTextField.text)
        
        textField.uiTextField.text = expected

        XCTAssertEqual(expected, textField.text)
    }
       
    func testTextSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        let expected = "something"
        
        textField.text = expected
         
        XCTAssertEqual(expected, textField.text)
    }
    
    // delegate
    func testDelegateGetterReturnsUITextFieldDelegate() {
        let textField = createTextField()
        let expected = UITextFieldDelegateMock()
        textField.uiTextField.delegate = expected
        
        XCTAssertTrue(textField.delegate === expected)
    }

    func testDelegateSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        let expected = UITextFieldDelegateMock()

        textField.delegate = expected

        XCTAssertTrue(textField.delegate === expected)
    }
    
    private func createTextField() -> AccessCheckoutUITextField {
        return AccessCheckoutUITextField()
    }
}

private class NSCoderStub: NSCoder {
    override init() {}
    
    override var allowsKeyedCoding: Bool {
        return true
    }
    
    override func decodeObject(forKey key: String) -> Any? {
        return nil
    }
    
    override func decodeBool(forKey key: String) -> Bool {
        return false
    }

    override func encodeValue(ofObjCType type: UnsafePointer<CChar>, at addr: UnsafeRawPointer) {}
    
    override func encode(_ data: Data) {}
    
    override func decodeData() -> Data? {
        return nil
    }
    
    override func version(forClassName className: String) -> Int {
        return 0
    }
    
    override func containsValue(forKey key: String) -> Bool {
        return false
    }
}

private class UITextFieldDelegateMock: NSObject {}

extension UITextFieldDelegateMock: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {}
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
