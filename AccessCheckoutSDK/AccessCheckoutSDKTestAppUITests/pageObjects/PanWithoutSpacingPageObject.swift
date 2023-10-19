
import XCTest

struct PanWithoutSpacingPageObject {
    private let app: XCUIApplication

    var panWithoutSpacingField: XCUIElement {
        return app.textFields["panWithoutSpacing"]
    }

    var panText: String? {
        return panWithoutSpacingField.value as? String
    }
    
    init(_ app: XCUIApplication) {
        self.app = app
    }

    func typeTextIntoPan(_ text: String) {
        if !panWithoutSpacingField.hasFocus {
            panWithoutSpacingField.tap()
        }
        panWithoutSpacingField.typeText(text)
    }

    func panWithoutSpacingCaretPosition() -> Int {
        let textField = app.textFields["panWithoutSpacingCaretPositionTextField"]
        // Focusing the textfield triggers the editEnd event on the pan field (see production code)
        // There is a listener for this event which captures the position of the caret in the pan field
        // and updates the text in panCaretPositionTextField
        textField.tap()

        guard let text = textField.value else {
            return -1
        }

        return Int(text as! String)!
    }

    func setpanWithoutSpacingCaretAtAndTypeIn(position: Int, text: [String]) {
        let textField = app.textFields["setpanWithoutSpacingCaretPositionTextField"]
        textField.tap()
        textField.typeText("\(position)")

        let button = app.buttons["setpanWithoutSpacingCaretPositionButton"]
        button.tap()

        for character in text {
            panWithoutSpacingField.typeText(character)
        }
    }

    func selectpanWithoutSpacingAndTypeIn(position: Int, selectionLength: Int, text: [String]) {
        let textField = app.textFields["setpanWithoutSpacingCaretPositionTextField"]
        textField.tap()
        textField.typeText("\(position)|\(selectionLength)")

        let button = app.buttons["setpanWithoutSpacingCaretPositionButton"]
        button.tap()

        for character in text {
            panWithoutSpacingField.typeText(character)
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

