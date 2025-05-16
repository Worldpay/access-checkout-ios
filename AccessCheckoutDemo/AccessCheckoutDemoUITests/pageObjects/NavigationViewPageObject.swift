import XCTest

class NavigationViewPageObject {
    private let app: XCUIApplication

    var cvcFlowNavigationButton: XCUIElement {
        return app.tabBars.buttons["CVC Flow"]
    }

    var cardFlowNavigationButton: XCUIElement {
        return app.tabBars.buttons["Card Flow"]
    }

    var restrictedCardFlowNavigationButton: XCUIElement {
        return app.tabBars.buttons["Restricted Card Flow"]
    }

    init(_ app: XCUIApplication) {
        self.app = app
    }

    func navigateToCardFlow() -> CardFlowViewPageObject {
        cardFlowNavigationButton.tap()

        return CardFlowViewPageObject(app)
    }

    func navigateToRestrictedCardFlow() -> RestrictedCardFlowViewPageObject {
        restrictedCardFlowNavigationButton.tap()

        return RestrictedCardFlowViewPageObject(app)
    }

    func navigateToCvcFlow() -> CvcFlowViewPageObject {
        cvcFlowNavigationButton.tap()

        return CvcFlowViewPageObject(app)
    }
}
