import XCTest

class NavigationViewPageObject {
    private let app:XCUIApplication
    
    var cvvFlowNavigationButton:XCUIElement {
        get {
            return app.tabBars.buttons["CVV flow"]
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
    
    func navigateToCvvFlow() -> CvvOnlyFlowViewPageObject {
        cvvFlowNavigationButton.tap()
        
        return CvvOnlyFlowViewPageObject(app)
    }
}
