import XCTest

class RestrictedCardFlowNoCardNumberSpacingTests: BaseUITest {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)
    var view: RestrictedCardFlowViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        let app = AppLauncher.launch()
        view = NavigationViewPageObject(app).navigateToRestrictedCardFlow()
    }

    // MARK: Testing disabled PAN formatting

    func testDoesNotFormatPan() {
        view!.typeTextIntoPanCharByChar("4111111111111111")

        XCTAssertEqual(view!.panText, "4111111111111111")
    }

    func testCanEnterOnlyDigitsInPan() {
        view!.typeTextIntoPanCharByChar("4abc11111111   1111blahblah   111")

        XCTAssertEqual(view!.panText, "4111111111111111")
    }

    func testCanDeleteDigits() {
        view!.typeTextIntoPanCharByChar("4111")
        XCTAssertEqual(view!.panText, "4111")

        view!.typeTextIntoPan(backspace)
        XCTAssertEqual(view!.panText, "411")
        view!.typeTextIntoPan(backspace)
        XCTAssertEqual(view!.panText, "41")
        view!.typeTextIntoPan(backspace)
        XCTAssertEqual(view!.panText, "4")
        view!.typeTextIntoPan(backspace)
        XCTAssertEqual(view!.panText, "Card Number")
    }
}
