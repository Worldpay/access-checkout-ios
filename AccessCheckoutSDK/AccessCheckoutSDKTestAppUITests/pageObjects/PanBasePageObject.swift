import XCTest

class PanBasePageObject {
    private let app: XCUIApplication

    private var panFieldIdentifier: String = ""
    private var panCaretPositionTextFieldIdentifier: String = ""
    private var setPanCaretPositionTextFieldIdentifier: String = ""
    private var setPanCaretPositionButtonIdentifier: String = ""

    init(
        app: XCUIApplication,
        panFieldIdentifier: String,
        panCaretPositionTextFieldIdentifier: String,
        setPanCaretPositionTextFieldIdentifier: String,
        setPanCaretPositionButtonIdentifier: String
    ) {
        self.app = app
        self.panFieldIdentifier = panFieldIdentifier
        self.panCaretPositionTextFieldIdentifier = panCaretPositionTextFieldIdentifier
        self.setPanCaretPositionTextFieldIdentifier = setPanCaretPositionTextFieldIdentifier
        self.setPanCaretPositionButtonIdentifier = setPanCaretPositionButtonIdentifier
    }

    var panField: XCUIElement {
        return app.otherElements[panFieldIdentifier].textFields.firstMatch
    }

    var panCaretPositionTextField: XCUIElement {
        return app.textFields[panCaretPositionTextFieldIdentifier]
    }

    var setPanCaretPositionTextField: XCUIElement {
        return app.textFields[setPanCaretPositionTextFieldIdentifier]
    }

    var setPanCaretPositionButton: XCUIElement {
        return app.buttons[setPanCaretPositionButtonIdentifier]
    }

    var panText: String? {
        return panField.value as? String
    }

    func typeTextIntoPan(_ text: String) {
        if !panField.hasFocus {
            panField.tap()
        }
        panField.typeText(text)
    }

    func panCaretPosition() -> Int {
        let textField = panCaretPositionTextField
        // Focusing the textfield triggers the editEnd event on the pan field (see production code)
        // There is a listener for this event which captures the position of the caret in the pan field
        // and updates the text in panCaretPositionTextField
        textField.tap()

        guard let text = textField.value else {
            return -1
        }

        return Int(text as! String)!
    }

    func setPanCaretAtAndTypeIn(position: Int, text: [String]) {
        let textField = setPanCaretPositionTextField
        textField.tap()
        textField.typeText("\(position)")

        let button = setPanCaretPositionButton
        button.tap()

        for character in text {
            panField.typeText(character)
        }
    }

    func selectPanAndTypeIn(position: Int, selectionLength: Int, text: [String]) {
        let textField = setPanCaretPositionTextField
        textField.tap()
        textField.typeText("\(position)|\(selectionLength)")

        let button = setPanCaretPositionButton
        button.tap()

        for character in text {
            panField.typeText(character)
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
