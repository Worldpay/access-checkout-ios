import XCTest

class AccessCheckoutSDKTestAppUITests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)
    
    let app = XCUIApplication()
    var view: PanWithSpacingPageObject?
    
    override func setUp() {
        continueAfterFailure = false
        
        app.launch()
        view = PanWithSpacingPageObject(app)
    }
    
    func testCardNumberTextField_exists() {
        XCTAssertTrue(view!.panWithSpacingField.exists)
    }
    
    func testTextFieldToReadCardNumberCaretPosition_exists() {
        XCTAssertTrue(view!.panWithSpacingCaretPositionTextField.exists)
    }
    
    func testTextFieldToSetCardNumberCaretPosition_exists() {
        XCTAssertTrue(view!.setPanWithSpacingCaretPositionTextField.exists)
    }
    
    func testButtonToSetCardNumberCaretPosition_exists() {
        XCTAssertTrue(view!.setPanWithSpacingCaretPositionButton.exists)
    }
}
