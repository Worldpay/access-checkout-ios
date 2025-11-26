import XCTest

class RestrictedCardFlowValidationTests: BaseUITest {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    var view: RestrictedCardFlowViewPageObject?
    
    override var customLaunchArguments: [String: String] {
        return ["displayDismissKeyboardButton": "true"]
    }

    override func setUp() {
        super.setUp()
        let navigationView = NavigationViewPageObject(app)
        view = navigationView.navigateToRestrictedCardFlow()
    }

    // MARK: Testing always displays card brand images independently of brand being accepted

    func testDisplaysAcceptedBrand_visa() {
        view!.typeTextIntoPanCharByChar("4")

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "visa")
    }

    func testDisplaysAcceptedBrand_mastercard() {
        view!.typeTextIntoPanCharByChar("55")

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "mastercard")
    }

    func testDisplaysAcceptedBrand_amex() {
        view!.typeTextIntoPanCharByChar("34")

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "amex")
    }

    func testDisplaysNonAcceptedBrand_jcb() {
        view!.typeTextIntoPanCharByChar("352")

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "jcb")
    }

    func testDisplaysUnknownBrand() {
        view!.typeTextIntoPanCharByChar("0")

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "unknown_card_brand")
    }

    // MARK: Testing accepted cards

    func testPartialPanIsInvalid_visa() {
        view!.typeTextIntoPanCharByChar("4")
        view!.dismissKeyboard()  // removes focus from Pan

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "visa")
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanIsValid_visa() {
        view!.typeTextIntoPanCharByChar("4444333322221111")

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "visa")
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }

    func testPartialPanIsInvalid_mastercard() {
        view!.typeTextIntoPanCharByChar("55")
        view!.dismissKeyboard()  // removes focus from Pan

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "mastercard")
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanIsValid_mastercard() {
        view!.typeTextIntoPanCharByChar("5555555555554444")

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "mastercard")
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }

    func testPartialPanIsInvalid_amex() {
        view!.typeTextIntoPanCharByChar("34")
        view!.dismissKeyboard()  // removes focus from Pan

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "amex")
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanIsValid_amex() {
        view!.typeTextIntoPanCharByChar("343434343434343")

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "amex")
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }

    // MARK: Testing cards that are not accepted due to SDK initialised to accept only visa, mastercard, amex

    func testPartialPanForCardThatIsNotAcceptedIsInvalid() {
        view!.typeTextIntoPanCharByChar("352")
        view!.dismissKeyboard()  // removes focus from Pan

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "jcb")
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }

    func testCompletePanForCardThatIsNotAcceptedIsInvalid() {
        view!.typeTextIntoPanCharByChar("3528000700000000")
        view!.dismissKeyboard()  // removes focus from Pan

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "jcb")
        XCTAssertEqual(view!.panIsValidLabel.label, "invalid")
    }
}
