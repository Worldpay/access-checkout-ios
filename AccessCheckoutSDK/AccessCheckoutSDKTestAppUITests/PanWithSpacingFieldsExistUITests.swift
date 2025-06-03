import XCTest

class PanWithSpacingFieldsExistUITests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    let app = XCUIApplication()
    var view: PanWithSpacingPageObject?

    override func setUp() {
        continueAfterFailure = false

        app.launch()
        view = PanWithSpacingPageObject(app)
    }

    func testCardNumberTextField_exists() {
        XCTAssertTrue(view!.panField.exists)
    }

    func testTextFieldToReadCardNumberCaretPosition_exists() {
        XCTAssertTrue(view!.panCaretPositionTextField.exists)
    }

    func testTextFieldToSetCardNumberCaretPosition_exists() {
        XCTAssertTrue(view!.setPanCaretPositionTextField.exists)
    }

    func testButtonToSetCardNumberCaretPosition_exists() {
        XCTAssertTrue(view!.setPanCaretPositionButton.exists)
    }
}
