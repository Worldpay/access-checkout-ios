
import XCTest

struct PanWithSpacingPageObject {
    private let app: XCUIApplication

    var panWithSpacingField: XCUIElement {
        return app.textFields["panWithSpacing"]
    }
    
    var panWithSpacingCaretPositionTextField: XCUIElement {
        return app.textFields["panWithSpacingCaretPositionTextField"]
    }
    
    var setPanWithSpacingCaretPositionTextField: XCUIElement {
        return app.textFields["setPanWithSpacingCaretPositionTextField"]
    }
    
    var setPanWithSpacingCaretPositionButton: XCUIElement {
        return app.buttons["setPanWithSpacingCaretPositionButton"]
    }
    
    var panText: String? {
        return panWithSpacingField.value as? String
    }
    
    init(_ app: XCUIApplication) {
        self.app = app
    }

    func typeTextIntoPan(_ text: String) {
        if !panWithSpacingField.hasFocus {
            panWithSpacingField.tap()
        }
        panWithSpacingField.typeText(text)
    }

    func panWithSpacingCaretPosition() -> Int {
        let textField = app.textFields["panWithSpacingCaretPositionTextField"]
        // Focusing the textfield triggers the editEnd event on the pan field (see production code)
        // There is a listener for this event which captures the position of the caret in the pan field
        // and updates the text in panCaretPositionTextField
        textField.tap()

        guard let text = textField.value else {
            return -1
        }

        return Int(text as! String)!
    }

    func setPanWithSpacingCaretAtAndTypeIn(position: Int, text: [String]) {
        let textField = app.textFields["setPanWithSpacingCaretPositionTextField"]
        textField.tap()
        textField.typeText("\(position)")

        let button = app.buttons["setPanWithSpacingCaretPositionButton"]
        button.tap()

        for character in text {
            panWithSpacingField.typeText(character)
        }
    }

    func selectPanWithSpacingAndTypeIn(position: Int, selectionLength: Int, text: [String]) {
        let textField = app.textFields["setPanWithSpacingCaretPositionTextField"]
        textField.tap()
        textField.typeText("\(position)|\(selectionLength)")

        let button = app.buttons["setPanWithSpacingCaretPositionButton"]
        button.tap()

        for character in text {
            panWithSpacingField.typeText(character)
        }
    }

    func clearField(_ field: XCUIElement) {
        field.press(forDuration: 2)
        let selectAllMenu = app.menuItems["Select All"]
        _ = selectAllMenu.waitForExistence(timeout: 3)
        selectAllMenu.tap()

        let cutMenu = app.menuItems["Cut"]
        _ = cutMenu.waitForExistence(timeout: 3)
        cutMenu.tap()
        wait(1)
    }

    private func wait(_ timeoutInSeconds: TimeInterval) {
        let exp = XCTestCase().expectation(description: "Waiting for \(timeoutInSeconds)")
        _ = XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }
}

