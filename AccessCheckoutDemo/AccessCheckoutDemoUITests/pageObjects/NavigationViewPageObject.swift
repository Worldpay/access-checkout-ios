import XCTest

class NavigationViewPageObject {
    private let app: XCUIApplication
    
    private let tabBarIdentifier = "tabBar"
    private let tabBarItemIdentifier = "tabBarItem"

    var cvcFlowNavigationButton: XCUIElement {
        return app.buttons["\(tabBarItemIdentifier)_2"].firstMatch
    }

    var cardFlowNavigationButton: XCUIElement {
        return app.buttons["\(tabBarItemIdentifier)_0"].firstMatch
    }

    var restrictedCardFlowNavigationButton: XCUIElement {
        return app.buttons["\(tabBarItemIdentifier)_1"].firstMatch
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
