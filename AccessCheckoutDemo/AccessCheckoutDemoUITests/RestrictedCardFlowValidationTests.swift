import XCTest

class RestrictedCardFlowValidationTests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    var view: RestrictedCardFlowViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        let app = AppLauncher.launch(displayDismissKeyboardButton: true)
        let navigationView = NavigationViewPageObject(app)

        view = navigationView.navigateToRestrictedCardFlow()
    }

    // MARK: Testing always displays card brand images independently of brand being accepted

    func testDisplaysAcceptedBrand_visa() {
        view!.typeTextIntoPanCharByChar("4")

        XCTAssertTrue(view!.imageIs("visa"))
    }

    func testDisplaysAcceptedBrand_mastercard() {
        view!.typeTextIntoPanCharByChar("55")

        XCTAssertTrue(view!.imageIs("mastercard"))
    }

    func testDisplaysAcceptedBrand_amex() {
        view!.typeTextIntoPanCharByChar("34")

        XCTAssertTrue(view!.imageIs("amex"))
    }

    func testDisplaysNonAcceptedBrand_jcb() {
        view!.typeTextIntoPanCharByChar("352")

        XCTAssertTrue(view!.imageIs("jcb"))
    }

    func testDisplaysUnknownBrand() {
        view!.typeTextIntoPanCharByChar("0")

        XCTAssertTrue(view!.imageIs("unknown_card_brand"))
    }

    // MARK: Testing accepted cards

    func testPartialPanIsInvalid_visa() {
        view!.typeTextIntoPanCharByChar("4")
        view!.dismissKeyboard()  // removes focus from Pan

        XCTAssertTrue(view!.imageIs("visa"))
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanIsValid_visa() {
        view!.typeTextIntoPanCharByChar("4444333322221111")

        XCTAssertTrue(view!.imageIs("visa"))
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }

    func testPartialPanIsInvalid_mastercard() {
        view!.typeTextIntoPanCharByChar("55")
        view!.dismissKeyboard()  // removes focus from Pan

        XCTAssertTrue(view!.imageIs("mastercard"))
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanIsValid_mastercard() {
        view!.typeTextIntoPanCharByChar("5555555555554444")

        XCTAssertTrue(view!.imageIs("mastercard"))
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }

    func testPartialPanIsInvalid_amex() {
        view!.typeTextIntoPanCharByChar("34")
        view!.dismissKeyboard()  // removes focus from Pan

        XCTAssertTrue(view!.imageIs("amex"))
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanIsValid_amex() {
        view!.typeTextIntoPanCharByChar("343434343434343")

        XCTAssertTrue(view!.imageIs("amex"))
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }

    // MARK: Testing cards that are not accepted due to SDK initialised to accept only visa, mastercard, amex

    func testPartialPanForCardThatIsNotAcceptedIsInvalid() {
        view!.typeTextIntoPanCharByChar("352")
        view!.dismissKeyboard()  // removes focus from Pan

        XCTAssertTrue(view!.imageIs("jcb"))
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanForCardThatIsNotAcceptedIsInvalid() {
        view!.typeTextIntoPanCharByChar("3528000700000000")
        view!.dismissKeyboard()  // removes focus from Pan

        XCTAssertTrue(view!.imageIs("jcb"))
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }
}
