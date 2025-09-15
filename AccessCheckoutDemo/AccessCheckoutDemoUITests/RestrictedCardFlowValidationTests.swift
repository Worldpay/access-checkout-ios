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
        view!.typeTextIntoPan("4")

        view!.assertCardBrandIs("visa")
    }

    func testDisplaysAcceptedBrand_mastercard() {
        view!.typeTextIntoPan("55")

        view!.assertCardBrandIs("mastercard")
    }

    func testDisplaysAcceptedBrand_amex() {
        view!.typeTextIntoPan("34")

        view!.assertCardBrandIs("amex")
    }

    func testDisplaysNonAcceptedBrand_jcb() {
        view!.typeTextIntoPan("352")

        view!.assertCardBrandIs("jcb")
    }

    func testDisplaysUnknownBrand() {
        view!.typeTextIntoPan("0")

        view!.assertCardBrandIs("unknown_card_brand")
    }

    // MARK: Testing accepted cards

    func testPartialPanIsInvalid_visa() {
        view!.typeTextIntoPan("4")
        view!.dismissKeyboard()  // removes focus from Pan

        view!.assertCardBrandIs("visa")
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanIsValid_visa() {
        view!.typeTextIntoPan("4444333322221111")

        view!.assertCardBrandIs("visa")
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }

    func testPartialPanIsInvalid_mastercard() {
        view!.typeTextIntoPan("55")
        view!.dismissKeyboard()  // removes focus from Pan

        view!.assertCardBrandIs("mastercard")
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanIsValid_mastercard() {
        view!.typeTextIntoPan("5555555555554444")

        view!.assertCardBrandIs("mastercard")
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }

    func testPartialPanIsInvalid_amex() {
        view!.typeTextIntoPan("34")
        view!.dismissKeyboard()  // removes focus from Pan

        view!.assertCardBrandIs("amex")
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanIsValid_amex() {
        view!.typeTextIntoPan("343434343434343")

        view!.assertCardBrandIs("amex")
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }

    // MARK: Testing cards that are not accepted due to SDK initialised to accept only visa, mastercard, amex

    func testPartialPanForCardThatIsNotAcceptedIsInvalid() {
        view!.typeTextIntoPan("352")
        view!.dismissKeyboard()  // removes focus from Pan

        view!.assertCardBrandIs("jcb")
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanForCardThatIsNotAcceptedIsInvalid() {
        view!.typeTextIntoPan("3528000700000000")
        view!.dismissKeyboard()  // removes focus from Pan

        view!.assertCardBrandIs("jcb")
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }
}
