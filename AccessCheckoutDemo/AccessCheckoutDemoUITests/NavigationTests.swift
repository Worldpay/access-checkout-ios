import XCTest
@testable import AccessCheckoutSDK

class NavigationTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testHasButtonsToNavigateToCvvOnlyFlow() {
        let element:XCUIElement = app.tabBars.buttons["Cvv-only flow"]
        
        XCTAssertTrue(element.exists)
    }
    
    func testHasButtonToNavigateToStandardFlow() {
        let element:XCUIElement = app.tabBars.buttons["Card payment flow"]
        
        XCTAssertTrue(element.exists)
    }
}

