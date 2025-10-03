import XCTest

class CardFlowCardBrandsLabelCobrandedRealServiceTests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    var view: CardFlowViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        let app = AppLauncher.launch()
        view = CardFlowViewPageObject(app)
    }

    // MARK: Single and Multiple Digits Show Global Brand

    func testDelegateNotification_singleDigitShowsGlobalBrand() {
        view!.typeTextIntoPan("4")

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa")
    }

    func testDelegateNotification_multipleDigitsShowsGlobalBrand() {
        view!.typeTextIntoPan("41505809")

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa")
    }

    // MARK: Twelve Digits Cobranded Card Two Notifications

    func testDelegateNotification_12DigitsCobrandedCard_twoNotifications() {
        view!.typeTextIntoPanCharByChar("41505809965")
        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa")

        view!.typeTextIntoPanCharByChar("1")

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa, cartesBancaires")
    }

    // MARK: Full Card Number Cobranded Two Notifications

    func testDelegateNotification_fullCardNumberCobrandedCard_twoNotifications() {
        view!.typeTextIntoPanCharByChar("41505809965")
        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa")

        view!.typeTextIntoPanCharByChar("17927")

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa, cartesBancaires")
    }

    // MARK: Pasted Card Number Returns Notifications

    // wait added as test occasionally times out
    func testCardBrands_whenCardNumberPastedWith12Digits_showsCobrandedCards() {
        view!.simulatePasteIntoPan("415058099651")

        TestUtils.wait(seconds: 0.2)

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa, cartesBancaires")
    }

    func testCardBrands_whenCardNumberPastedWithMoreThan12Digits_showsCobrandedCards() {
        view!.simulatePasteIntoPan("4150580996517927")

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa, cartesBancaires")
    }

    // MARK: Remove Digit from Twelve Two Notifications

    // wait added as test occasionally times out
    func testDelegateNotification_remove1DigitFrom12_twoNotifications() {
        view!.typeTextIntoPanCharByChar("41505809965")
        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa")

        view!.typeTextIntoPanCharByChar("1")

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa, cartesBancaires")

        view!.typeTextIntoPan(backspace)

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa")
    }

    // MARK: Clear Full Card Three Notifications

    // wait added as test occasionally times out
    func testDelegateNotification_clearFullCard_threeNotifications() {
        view!.typeTextIntoPanCharByChar("41505809965")

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa")

        view!.typeTextIntoPanCharByChar("17927")

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa, cartesBancaires")

        view!.clearField(view!.panField)

        // asserting that the label does not exist (i.e. empty) as it is removed from UI if it is empty
        XCTAssertFalse(view!.cardBrandsLabel.waitForExistence(timeout: 1))
    }
}
