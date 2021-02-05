@testable import AccessCheckoutSDK
import Foundation
import XCTest

class CardFlowCardValidationTests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    let app = XCUIApplication()
    var view: CardFlowViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        app.launch()
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

    func testPAN_acceptsUpTo19Characters() {
        view!.typeTextIntoPan("111122223333444455556666")

        XCTAssertEqual(view!.panText!, "1111222233334444555")
        XCTAssertEqual(view!.panText!.count, 19)
    }

    func testPartialPanIsInvalid() {
        view!.typeTextIntoPan("4")

        XCTAssertTrue(view!.imageIs("visa"))
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanIsValid() {
        view!.typeTextIntoPan("4444333322221111")

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
        view!.typeTextIntoCvc(backspace)
        view!.typeTextIntoCvc(backspace)
        XCTAssertEqual(view!.cvcText, "1")
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

    // MARK: Test displays card brand images

    func testDisplaysBrandImageFor_amex() {
        view!.typeTextIntoPan("34")

        XCTAssertTrue(view!.imageIs("amex"))
    }

    func testDisplaysBrandImageFor_diners() {
        view!.typeTextIntoPan("36")

        XCTAssertTrue(view!.imageIs("diners"))
    }

    func testDisplaysBrandImageFor_discover() {
        view!.typeTextIntoPan("65")

        XCTAssertTrue(view!.imageIs("discover"))
    }

    func testDisplaysBrandImageFor_jcb() {
        view!.typeTextIntoPan("352")

        XCTAssertTrue(view!.imageIs("jcb"))
    }

    func testDisplaysBrandImageFor_maestro() {
        view!.typeTextIntoPan("67")

        XCTAssertTrue(view!.imageIs("maestro"))
    }

    func testDisplaysBrandImageFor_mastercard() {
        view!.typeTextIntoPan("55")

        XCTAssertTrue(view!.imageIs("mastercard"))
    }

    func testDisplaysBrandImageFor_visa() {
        view!.typeTextIntoPan("4")

        XCTAssertTrue(view!.imageIs("visa"))
    }

    func testDisplaysBrandImageFor_unknownCardBrand() {
        view!.typeTextIntoPan("0")

        XCTAssertTrue(view!.imageIs("unknown_card_brand"))
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
