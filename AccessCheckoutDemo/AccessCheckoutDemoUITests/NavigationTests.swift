import XCTest

class NavigationTests: BaseUITest {
    var view: NavigationViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        let app = AppLauncher.launch()
        view = NavigationViewPageObject(app)
    }

    func testHasButtonToNavigateToCardFlow() {
        XCTAssertTrue(view!.cardFlowNavigationButton.exists)
    }

    func testHasButtonToNavigateToRestrictedCardFlow() {
        XCTAssertTrue(view!.restrictedCardFlowNavigationButton.exists)
    }

    func testHasButtonsToNavigateToCvcFlow() {
        XCTAssertTrue(view!.cvcFlowNavigationButton.exists)
    }
}
