import XCTest

class CardFlowSystemCalendarValidationTests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)
    
    var view: CardFlowViewPageObject?

    override func setUp() {
        super.setUp()

        let app = AppLauncher.launch()
        view = CardFlowViewPageObject(app)
    }
   
    // MARK: Expiry Date validation

    func testExpiryDate_doesNotAccepteAlphabeticalCharacters() {
        view!.typeTextIntoExpiryDate("A")

        XCTAssertEqual(view!.expiryDateField.placeholderValue, view!.expiryDateText)
    }

    func testExpiryDate_canDeleteDigits() {
        view!.typeTextIntoExpiryDate("12/99")
        XCTAssertEqual(view!.expiryDateText, "12/99")

        view!.typeTextIntoExpiryDate(backspace)
        XCTAssertEqual(view!.expiryDateText, "12/9")
    }

    func testExpiryDate_isInvalidAfterAllTextIsCleared() {
        view!.typeTextIntoExpiryDate("12/99")
        XCTAssertEqual(view!.expiryDateIsValidLabel.label, "valid")

        view!.clearField(view!.expiryDateField)

        XCTAssertEqual(view!.expiryDateField.placeholderValue, view!.expiryDateText)
        XCTAssertEqual(view!.expiryDateIsValidLabel.label, "invalid")
    }

    func testExpiryDate_acceptsUpTo5Characters() {
        view!.typeTextIntoExpiryDate("12/999")

        XCTAssertEqual(view!.expiryDateText!, "12/99")
        XCTAssertEqual(view!.expiryDateText!.count, 5)
    }

    func testPartialExpiryDateIsInvalid() {
        view!.typeTextIntoExpiryDate("12")

        view!.panField.tap()  // we move the focus to another field so that the validation triggers

        XCTAssertEqual(view!.expiryDateIsValidLabel.label, "invalid")
    }

    func testCompleteExpiryDateIsValid() {
        view!.typeTextIntoExpiryDate("12/99")

        XCTAssertEqual(view!.expiryDateIsValidLabel.label, "valid")
    }


    // MARK: Submit button
    func testSubmit_isEnabledWhenCardDetailsAreValid() {
        XCTAssertFalse(view!.submitButton.isEnabled)

        view!.typeTextIntoPanCharByChar("4111111111111111")
        view!.typeTextIntoExpiryDate("01/34")
        view!.typeTextIntoCvc("123")

        // Valid state
        XCTAssertTrue(view!.submitButton.isEnabled)
    }
}
