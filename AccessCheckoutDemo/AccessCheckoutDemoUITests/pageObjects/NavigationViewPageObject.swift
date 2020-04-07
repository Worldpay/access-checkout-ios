import XCTest

class NavigationViewPageObject {
    private let app:XCUIApplication
    
    var cvvOnlyFlowNavigationButton:XCUIElement {
        get {
            return app.tabBars.buttons["Cvv-only flow"]
        }
    }
    
    var cardPaymentFlowNavigationButton:XCUIElement {
        get {
            return app.tabBars.buttons["Card payment flow"]
        }
    }
    
    init(_ app:XCUIApplication) {
        self.app = app
    }
    
    func cardPaymentFlow() -> CardPaymentFlowViewPageObject {
        cardPaymentFlowNavigationButton.tap()
        
        return CardPaymentFlowViewPageObject(app)
    }
    
    func navigateToCvvOnlyFlow() -> CvvOnlyFlowViewPageObject {
        cvvOnlyFlowNavigationButton.tap()
        
        return CvvOnlyFlowViewPageObject(app)
    }
}
