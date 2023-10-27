import XCTest

class RestrictedCardFlowNoCardNumberSpacingTests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)
    
    let app = XCUIApplication()
    var view: RestrictedCardFlowViewPageObject?
    
    override func setUp() {
        continueAfterFailure = false
        
        app.launch()
        view = NavigationViewPageObject(app).navigateToRestrictedCardFlow()
    }
    
    // MARK: Testing disabled PAN formatting
    
    func testDoesNotFormatPan() {
        view!.typeTextIntoPan("4111111111111111")
        
        XCTAssertEqual(view!.panText, "4111111111111111")
    }
    
    func testCanEnterOnlyDigitsInPan() {
        view!.typeTextIntoPan("4abc11111111   1111blahblah   111")
        
        XCTAssertEqual(view!.panText, "4111111111111111")
    }
    
    func testCanDeleteDigits() {
        view!.typeTextIntoPan("4111")
        XCTAssertEqual(view!.panText, "4111")
        
        view!.typeTextIntoPan(backspace)
        XCTAssertEqual(view!.panText, "411")
        view!.typeTextIntoPan(backspace)
        XCTAssertEqual(view!.panText, "41")
        view!.typeTextIntoPan(backspace)
        XCTAssertEqual(view!.panText, "4")
        view!.typeTextIntoPan(backspace)
        XCTAssertEqual(view!.panText, "Card Number")
    }
}
