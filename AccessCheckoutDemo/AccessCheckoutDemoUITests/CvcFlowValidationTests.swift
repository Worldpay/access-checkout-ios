@testable import AccessCheckoutSDK
import XCTest

class CvcFlowCvcValidationTests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    let app = XCUIApplication()
    var view: CvcFlowViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        app.launch()

        view = NavigationViewPageObject(app).navigateToCvcFlow()
    }

    func testCannotTypeAlphabeticalCharactersInCvc() {
        view!.typeTextIntoCvc("A")

        XCTAssertEqual(view!.cvcField.placeholderValue, view!.cvcText)
    }

    func testCanEnterNumericalCharactersInCvc() {
        view!.typeTextIntoCvc("1")

        XCTAssertEqual("1", view!.cvcText)
    }

    func testCanEnterValidCvcOf3Characters() {
        view!.typeTextIntoCvc("123")

        XCTAssertEqual("123", view!.cvcText)
    }

    func testCanEnterValidCvcOf4Characters() {
        view!.typeTextIntoCvc("1234")

        XCTAssertEqual("1234", view!.cvcText)
    }

    func testCanEnterUpTo4NumericalCharactersInCvc() {
        view!.typeTextIntoCvc("123456")

        XCTAssertEqual("1234", view!.cvcText)
    }

    func testCvc_canDeleteDigits() {
        view!.typeTextIntoCvc("1234")
        XCTAssertEqual(view!.cvcText, "1234")

        view!.typeTextIntoCvc(backspace)
        XCTAssertEqual(view!.cvcText, "123")
    }

    func testCvc_isInvalidAfterAllTextIsCleared() {
        view!.typeTextIntoCvc("123")
        XCTAssertEqual(view!.cvcIsValidLabel.label, "valid")

        view!.clearCvc()

        XCTAssertEqual(view!.cvcField.placeholderValue, view!.cvcText)
        XCTAssertEqual(view!.cvcIsValidLabel.label, "invalid")
    }

    func testPartialCvcIsInvalid() {
        view!.typeTextIntoCvc("12")

        XCTAssertEqual(view!.cvcIsValidLabel.label, "invalid")
    }

    func testComplete3DigitsLongCvcIsValid() {
        view!.typeTextIntoCvc("123")

        XCTAssertEqual(view!.cvcIsValidLabel.label, "valid")
    }

    func testComplete4DigitsLongCvcIsValid() {
        view!.typeTextIntoCvc("1234")

        XCTAssertEqual(view!.cvcIsValidLabel.label, "valid")
    }

    func testSubmitButtonIsDisabledByDefault() {
        XCTAssertFalse(view!.submitButton.isEnabled)
    }

    func testSubmitButtonRemainsDisabledWhenIncompleteCvcIsEntered() {
        view!.typeTextIntoCvc("12")

        XCTAssertFalse(view!.submitButton.isEnabled)
    }

    func testSubmitButtonIsEnabledWhenValidCvcIsEntered() {
        view!.typeTextIntoCvc("123")

        XCTAssertTrue(view!.submitButton.isEnabled)
    }
}
