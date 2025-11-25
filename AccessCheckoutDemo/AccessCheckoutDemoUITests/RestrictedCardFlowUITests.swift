import XCTest

class RestrictedCardFlowUITests: BaseUITest {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    var view: RestrictedCardFlowViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        let app = AppLauncher.launch()
        view = NavigationViewPageObject(app).navigateToRestrictedCardFlow()
    }

    func testCardNumberTextField_exists() {
        XCTAssertTrue(view!.panField.exists)
    }

    func testCardBrandImageView_exists() {
        XCTAssertTrue(view!.cardBrandImage.exists)
    }

    func testRestrictedCardBrandsLabel_exists() {
        XCTAssertTrue(view!.restrictedCardBrandsLabel.exists)
    }

    func testPanIsValidLabel_exists() {
        XCTAssertTrue(view!.panIsValidLabel.exists)
    }
}
