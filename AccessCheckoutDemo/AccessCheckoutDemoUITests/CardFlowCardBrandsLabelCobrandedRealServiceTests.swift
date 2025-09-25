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
        view!.typeTextIntoPan("41505809965")
        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa")

        view!.typeTextIntoPan("1")
        TestUtils.wait(seconds: 1.0)

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa, cartesBancaires")
    }

    // MARK: Full Card Number Cobranded Two Notifications

    func testDelegateNotification_fullCardNumberCobrandedCard_twoNotifications() {
        view!.typeTextIntoPan("41505809965")
        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa")

        view!.typeTextIntoPan("17927")

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa, cartesBancaires")
    }

    // MARK: Pasted Card Number Returns Notifications

    func testCardBrands_whenCardNumberPastedWith12Digits_showsCobrandedCards() {
        view!.simulatePasteIntoPan("415058099651")

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa, cartesBancaires")
    }

    func testCardBrands_whenCardNumberPastedWithMoreThan12Digits_showsCobrandedCards() {
        view!.simulatePasteIntoPan("4150580996517927")

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa, cartesBancaires")
    }

    // MARK: Remove Digit from Twelve Two Notifications

    func testDelegateNotification_remove1DigitFrom12_twoNotifications() {
        view!.typeTextIntoPan("415058099651")
        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa")
        TestUtils.wait(seconds: 1.0)

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa, cartesBancaires")

        view!.typeTextIntoPan(backspace)

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa")
    }

    // MARK: Clear Full Card Three Notifications

    func testDelegateNotification_clearFullCard_threeNotifications() {
        view!.typeTextIntoPan("415058099651")
        view!.typeTextIntoPan("7927")

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa")
        TestUtils.wait(seconds: 1.0)

        TestUtils.assertLabelText(of: view!.cardBrandsLabel, equals: "visa, cartesBancaires")

        view!.clearField(view!.panField)
        TestUtils.wait(seconds: 1.0)

        // asserting that the label does not exist (i.e. empty) as it is removed from UI if it is empty
        XCTAssertFalse(view!.cardBrandsLabel.waitForExistence(timeout: 1))
    }
}
