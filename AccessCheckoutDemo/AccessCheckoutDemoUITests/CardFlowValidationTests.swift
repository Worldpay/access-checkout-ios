import XCTest

class CardFlowCardValidationTests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    var view: CardFlowViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        let app = AppLauncher.launch()
        view = CardFlowViewPageObject(app)
    }

    // MARK: PAN validation

    func testPAN_doesNotAccepteAlphabeticalCharacters() {
        view!.typeTextIntoPan("A")

        XCTAssertEqual(view!.panField.placeholderValue, view!.panText)
    }

    func testPAN_canDeleteDigits() {
        view!.typeTextIntoPan("1000")
        XCTAssertEqual(view!.panText, "1000")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        XCTAssertEqual(view!.panText, "1")
    }

    func testPAN_isInvalidAfterAllTextIsCleared() {
        let pan = "4444333322221111"
        view!.typeTextIntoPan(pan)
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")

        view!.clearField(view!.panField)

        XCTAssertEqual(view!.panField.placeholderValue, view!.panText)
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testPAN_acceptsUpTo19Characters_plusSpaces() {
        view!.typeTextIntoPan("111122223333444455556666")

        XCTAssertEqual(view!.panText!, "1111 2222 3333 4444 555")
        XCTAssertEqual(view!.panText!.count, 23)
    }

    func testPartialPanIsInvalid() {
        view!.typeTextIntoPan("4")
        view!.expiryDateField.tap()  // we move the focus to another field so that the validation triggers

        XCTAssertTrue(view!.imageIs("visa"))
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanIsValid() {
        view!.typeTextIntoPan("4444333322221111")

        XCTAssertTrue(view!.imageIs("visa"))
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }

    func test13DigitsVisaPanIsValid() {
        view!.typeTextIntoPan("4911830000000")

        XCTAssertTrue(view!.imageIs("visa"))
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
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

    // MARK: Cvc validation

    func testCvc_doesNotAccepteAlphabeticalCharacters() {
        view!.typeTextIntoCvc("A")

        XCTAssertEqual(view!.cvcField.placeholderValue, view!.cvcText)
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

        view!.clearField(view!.cvcField)

        XCTAssertEqual(view!.cvcField.placeholderValue, view!.cvcText)
        XCTAssertEqual(view!.cvcIsValidLabel.label, "invalid")
    }

    func testCvc_acceptsUpTo4CharactersByDefault() {
        view!.typeTextIntoCvc("123456")

        XCTAssertEqual(view!.cvcText!, "1234")
        XCTAssertEqual(view!.cvcText!.count, 4)
    }

    func testCvc_acceptsAsManyCharactersAsAllowedByCardBrand() {
        view!.typeTextIntoPan("4")
        view!.typeTextIntoCvc("1234")

        XCTAssertEqual(view!.cvcText!, "123")
    }

    func testPartialCvcIsInvalid() {
        view!.typeTextIntoCvc("12")
        
        view!.panField.tap()  // we move the focus to another field so that the validation triggers

        XCTAssertEqual(view!.cvcIsValidLabel.label, "invalid")
    }

    func testCompleteCvcIsValid() {
        view!.typeTextIntoCvc("123")

        XCTAssertEqual(view!.cvcIsValidLabel.label, "valid")
    }

    // MARK: Test Cvc validity changes if card brand does not allow that length of Cvc

    func testCvc_brandValidLength() {
        let cvc = "1234"
        view!.typeTextIntoCvc(cvc)
        XCTAssertEqual(view!.cvcIsValidLabel.label, "valid")

        // changes to visa which only acceptes 3 digits long Cvcs
        view!.typeTextIntoPan("4")
        XCTAssertEqual(view!.cvcIsValidLabel.label, "invalid")
    }

    // MARK: Submit button

    func testSubmit_isEnabledWhenCardDetailsAreValid() {
        XCTAssertFalse(view!.submitButton.isEnabled)

        view!.typeTextIntoPan("4111111111111111")
        view!.typeTextIntoExpiryDate("01/34")
        view!.typeTextIntoCvc("123")

        // Valid state
        XCTAssertTrue(view!.submitButton.isEnabled)

        view!.typeTextIntoCvc(backspace)

        // Invalid state
        XCTAssertFalse(view!.submitButton.isEnabled)
    }
}
