import XCTest

class CvcFlowCvcValidationTests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    var view: CvcFlowViewPageObject?
    var navigationView: NavigationViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        let app = AppLauncher.launch()
        self.navigationView = NavigationViewPageObject(app)

        view = self.navigationView!.navigateToCvcFlow()
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
        
        // we navigate to another view to force the focus to removed from the current field
        // so that the validation triggers
        _ = self.navigationView?.navigateToCardFlow()
        _ = self.navigationView?.navigateToCvcFlow()

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
