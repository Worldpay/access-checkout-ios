import XCTest

class RestrictedCardFlowUITests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)
    
    let app = XCUIApplication()
    var view: RestrictedCardFlowViewPageObject?
    
    override func setUp() {
        continueAfterFailure = false
        
        app.launch()
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
