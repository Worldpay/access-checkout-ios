import XCTest

class NavigationViewPageObject {
    private let app:XCUIApplication
    
    var cvcFlowNavigationButton:XCUIElement {
        get {
            return app.tabBars.buttons["CVC flow"]
        }
    }
    
    var cardFlowNavigationButton:XCUIElement {
        get {
            return app.tabBars.buttons["Card flow"]
        }
    }
    
    init(_ app:XCUIApplication) {
        self.app = app
    }
    
    func navigateToCardFlow() -> CardPaymentFlowViewPageObject {
        cardFlowNavigationButton.tap()
        
        return CardPaymentFlowViewPageObject(app)
    }
    
    func navigateToCvcFlow() -> CvcFlowViewPageObject {
        cvcFlowNavigationButton.tap()
        
        return CvcFlowViewPageObject(app)
    }
}
