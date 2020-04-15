import XCTest
@testable import AccessCheckoutSDK

class NavigationTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testHasButtonsToNavigateToCvvFlow() {
        let element:XCUIElement = NavigationViewPageObject(app).cvvFlowNavigationButton
        
        XCTAssertTrue(element.exists)
    }
    
    func testHasButtonToNavigateToCardFlow() {
        let element:XCUIElement = NavigationViewPageObject(app).cardFlowNavigationButton
        
        XCTAssertTrue(element.exists)
    }
}

