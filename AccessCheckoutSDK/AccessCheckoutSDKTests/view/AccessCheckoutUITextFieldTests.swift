import Foundation
import XCTest

@testable import AccessCheckoutSDK

class AccessCheckoutUITextFieldTests: XCTestCase {
    // MARK: constructors tests
    func testCGRectConstructorInitialiasesTextFieldWithDefaultStyles() {
        let textField = AccessCheckoutUITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 20))

        // UITextField is initialised in subview
        XCTAssertNotNil(textField.subviews[0])

        // Styles set on the view itself
        XCTAssertEqual(5, textField.layer.cornerRadius)
        XCTAssertTrue(
            colorsAreEqual(
                UIColor(cgColor: textField.layer.borderColor!),
                AccessCheckoutUITextField.defaults.borderColor))
        XCTAssertEqual(1, textField.layer.borderWidth)

        // Styles set on the uiTextField
        XCTAssertEqual(
            UIKeyboardType.asciiCapableNumberPad.rawValue,
            textField.uiTextField.keyboardType.rawValue)
    }

    func testDefaultConstructorInitialiasesTextFieldWithDefaultStyles() {
        let textField = AccessCheckoutUITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        // UITextField is initialised in subview
        XCTAssertNotNil(textField.subviews[0])
        // Styles set on the view itself
        XCTAssertEqual(5, textField.layer.cornerRadius)
        XCTAssertTrue(
            colorsAreEqual(
                UIColor(cgColor: textField.layer.borderColor!),
                AccessCheckoutUITextField.defaults.borderColor))
        XCTAssertEqual(1, textField.layer.borderWidth)

        // Styles set on the uiTextField
        XCTAssertEqual(
            UIKeyboardType.asciiCapableNumberPad.rawValue,
            textField.uiTextField.keyboardType.rawValue)
    }

    func testCGRectConstructorPositionsInternalTextFieldUsingConstraints() {
        let textField = AccessCheckoutUITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 20))

        XCTAssertEqual(4, textField.constraints.count)

        assertConstraints(
            textField,
            top: AccessCheckoutUITextField.defaults.verticalPadding,
            bottom: -AccessCheckoutUITextField.defaults.verticalPadding,
            leading: AccessCheckoutUITextField.defaults.horizontalPadding,
            trailing: -AccessCheckoutUITextField.defaults.horizontalPadding)
    }

    func testDefaultConstructorPositionsInternalTextFieldUsingConstraints() {
        let textField = AccessCheckoutUITextField()

        XCTAssertEqual(4, textField.constraints.count)

        assertConstraints(
            textField,
            top: AccessCheckoutUITextField.defaults.verticalPadding,
            bottom: -AccessCheckoutUITextField.defaults.verticalPadding,
            leading: AccessCheckoutUITextField.defaults.horizontalPadding,
            trailing: -AccessCheckoutUITextField.defaults.horizontalPadding)
    }

    // MARK: default styles values

    func testDefaultStylesValues() {
        XCTAssertTrue(colorsAreEqual(.white, AccessCheckoutUITextField.defaults.backgroundColor))
        XCTAssertTrue(
            colorsAreEqual(
                toUIColor(hexadecimal: 0xFBFBFB),
                AccessCheckoutUITextField.defaults.disabledBackgroundColor))
        XCTAssertTrue(
            colorsAreEqual(
                toUIColor(hexadecimal: 0xE9E9E9), AccessCheckoutUITextField.defaults.borderColor))
        XCTAssertEqual(AccessCheckoutUITextField.defaults.borderWidth, 1)
        XCTAssertEqual(AccessCheckoutUITextField.defaults.cornerRadius, 5)
        XCTAssertEqual(AccessCheckoutUITextField.defaults.textAlignment, .left)
        XCTAssertEqual(AccessCheckoutUITextField.defaults.keyboardType, .asciiCapableNumberPad)
        XCTAssertEqual(AccessCheckoutUITextField.defaults.keyboardAppearance, .default)
        XCTAssertEqual(AccessCheckoutUITextField.defaults.horizontalPadding, 6)
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
        XCTAssertEqual(
            UIKeyboardType.namePhonePad.rawValue, textField.uiTextField.keyboardType.rawValue)
        XCTAssertEqual("some placeholder", textField.uiTextField.placeholder)
        XCTAssertEqual(UIColor.yellow, textField.uiTextField.textColor)
    }

    // MARK: Accessibility properties tests

    // isAccessibilityElement
    func testIsAccessibilityElementGetterAlwaysReturnsFalse() {
        let textField = createTextField()
        XCTAssertFalse(textField.isAccessibilityElement)

        textField.isAccessibilityElement = true
        XCTAssertFalse(textField.isAccessibilityElement)
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
    func testAccessibilityIdentifierGetterReturnsId() {
        let textField = createTextField()
        XCTAssertNil(textField.accessibilityIdentifier)

        textField.accessibilityIdentifier = "something"
        XCTAssertEqual("something", textField.accessibilityIdentifier)
    }

    func testAccessibilityIdentifierSetterSetsIdAndUITextFieldIdUsingANamingConvention() {
        let textField = createTextField()
        XCTAssertNil(textField.accessibilityIdentifier)

        textField.accessibilityIdentifier = "something"
        XCTAssertEqual("something", textField.accessibilityIdentifier)
        XCTAssertEqual("something-UITextField", textField.uiTextField.accessibilityIdentifier)
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

    // MARK: Padding properties tests

    // horizontalPadding
    func testHorizontalPaddingModifiesTheLayoutAccordingly() {
        let textField = createTextField()

        // Asserts padding is default padding to start with
        assertConstraints(
            textField,
            top: AccessCheckoutUITextField.defaults.verticalPadding,
            bottom: -AccessCheckoutUITextField.defaults.verticalPadding,
            leading: AccessCheckoutUITextField.defaults.horizontalPadding,
            trailing: -AccessCheckoutUITextField.defaults.horizontalPadding)

        textField.horizontalPadding = 20

        assertConstraints(
            textField,
            top: AccessCheckoutUITextField.defaults.verticalPadding,
            bottom: -AccessCheckoutUITextField.defaults.verticalPadding,
            leading: 20,
            trailing: -20)
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

        XCTAssertEqual(1.0, textField.borderWidth)
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
    func testBorderColorHasADefaultValue() {
        let textField = createTextField()

        XCTAssertTrue(
            colorsAreEqual(textField.borderColor, AccessCheckoutUITextField.defaults.borderColor))
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
    func testFontGetterReturnsValueSet() {
        let textField = createTextField()
        let expected = UIFont.preferredFont(forTextStyle: .body)

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

        XCTAssertEqual(UIKeyboardType.asciiCapableNumberPad, textField.keyboardType)
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

    func testtextContentTypeByDefaultIsNil() {
        let textField = createTextField()
        XCTAssertEqual(nil, textField.uiTextField.textContentType)
    }

    func testtextContentTypeSetterSetsUITextFieldProperty() {
        let textField = createTextField()

        textField.textContentType = UITextContentType.creditCardNumber

        XCTAssertEqual(UITextContentType.creditCardNumber, textField.uiTextField.textContentType)
    }

    // inputAccessoryView (used to customise the keyboard displayed when the component receives the focus)
    func testInputAccessoryViewIsNilByDefault() {
        let textField = createTextField()

        XCTAssertNil(textField.inputAccessoryView)
    }

    func testInputAccessoryViewGetterReturnsValueSet() {
        let textField = createTextField()
        let expected = UILabel()

        textField.inputAccessoryView = expected

        XCTAssertEqual(expected, textField.inputAccessoryView)
    }

    func testInputAccessoryViewSetterSetsUITextFieldProperty() {
        let textField = createTextField()
        let expected = UILabel()

        textField.inputAccessoryView = expected

        XCTAssertEqual(expected, textField.uiTextField.inputAccessoryView)
    }

    // MARK: enabled properties

    func testIsEnabledIsTrueByDefault() {
        let textField = createTextField()

        XCTAssertTrue(textField.isEnabled)
    }

    func testIsEnabledSetterSetsIsEnabledProperty() {
        let textField = createTextField()

        textField.isEnabled = false
        XCTAssertFalse(textField.isEnabled)
    }

    func testIsEnabled_whenToggled_changesBackgroundColor_whenBackgroundColorIsDefault() {
        let textField = createTextField()
        textField.backgroundColor = AccessCheckoutUITextField.defaults.backgroundColor

        textField.isEnabled = false
        XCTAssertTrue(
            colorsAreEqual(
                textField.backgroundColor,
                AccessCheckoutUITextField.defaults.disabledBackgroundColor))

        textField.isEnabled = true
        XCTAssertTrue(
            colorsAreEqual(
                textField.backgroundColor, AccessCheckoutUITextField.defaults.backgroundColor))
    }

    func testIsEnabled_whenToggled_doesNotChangeBackgroundColor_wWhenBackgroundColorIsNotDefault() {
        let textField = createTextField()
        textField.backgroundColor = UIColor.red

        textField.isEnabled = false
        XCTAssertTrue(colorsAreEqual(textField.backgroundColor, UIColor.red))

        textField.isEnabled = true
        XCTAssertTrue(colorsAreEqual(textField.backgroundColor, UIColor.red))

        textField.isEnabled = false
        XCTAssertTrue(colorsAreEqual(textField.backgroundColor, UIColor.red))
    }

    // MARK: methods properties

    func testClearClearsUITextFieldText_andDispatchesAnEditingChangedEvent() {
        let uiTextFieldMock = UITextFieldMock()
        let textField = AccessCheckoutUITextField(uiTextFieldMock)
        textField.uiTextField.text = "something"
        XCTAssertEqual("something", textField.uiTextField.text)

        textField.clear()

        XCTAssertEqual("", textField.uiTextField.text)
        XCTAssertTrue(uiTextFieldMock.sendActionsCalled)
        XCTAssertEqual(.editingChanged, uiTextFieldMock.sendActionsEvents)
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

    func testSetOnFocusChangedListenerAssignsValueToVariable() {
        let textField = AccessCheckoutUITextField()

        XCTAssertNil(textField.externalOnFocusChangedListener)

        //Set
        textField.setOnFocusChangedListener { view, isFocused in
            //do something
        }

        XCTAssertNotNil(textField.externalOnFocusChangedListener)
    }

    func testSetOnFocusChangedListener() {
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

    private func toUIColor(hexadecimal: Int) -> UIColor {
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

    private func assertConstraints(
        _ textField: AccessCheckoutUITextField,
        top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat
    ) {
        XCTAssertEqual(4, textField.constraints.count)

        let topConstraint = textField.constraints[0]
        XCTAssertEqual(topConstraint.firstItem as? UITextField, textField.uiTextField)
        XCTAssertEqual(topConstraint.firstAnchor, textField.uiTextField.topAnchor)
        XCTAssertEqual(topConstraint.secondItem as? AccessCheckoutUITextField, textField)
        XCTAssertEqual(topConstraint.secondAnchor, textField.topAnchor)
        XCTAssertEqual(topConstraint.constant, top)

        let bottomConstraint = textField.constraints[1]
        XCTAssertEqual(bottomConstraint.firstItem as? UITextField, textField.uiTextField)
        XCTAssertEqual(bottomConstraint.firstAnchor, textField.uiTextField.bottomAnchor)
        XCTAssertEqual(bottomConstraint.secondItem as? AccessCheckoutUITextField, textField)
        XCTAssertEqual(bottomConstraint.secondAnchor, textField.bottomAnchor)
        XCTAssertEqual(bottomConstraint.constant, bottom)

        let leadingConstraint = textField.constraints[2]
        XCTAssertEqual(leadingConstraint.firstItem as? UITextField, textField.uiTextField)
        XCTAssertEqual(leadingConstraint.firstAnchor, textField.uiTextField.leadingAnchor)
        XCTAssertEqual(leadingConstraint.secondItem as? AccessCheckoutUITextField, textField)
        XCTAssertEqual(leadingConstraint.secondAnchor, textField.leadingAnchor)
        XCTAssertEqual(leadingConstraint.constant, leading)

        let trailingConstraint = textField.constraints[3]
        XCTAssertEqual(trailingConstraint.firstItem as? UITextField, textField.uiTextField)
        XCTAssertEqual(trailingConstraint.firstAnchor, textField.uiTextField.trailingAnchor)
        XCTAssertEqual(trailingConstraint.secondItem as? AccessCheckoutUITextField, textField)
        XCTAssertEqual(trailingConstraint.secondAnchor, textField.trailingAnchor)
        XCTAssertEqual(trailingConstraint.constant, trailing)
    }
}

private class UITextFieldDelegateMock: NSObject {}

extension UITextFieldDelegateMock: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {}

    public func textField(
        _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return false
    }
}
