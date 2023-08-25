import XCTest

class CardFlowViewPageObject {
    private let app: XCUIApplication

    var panField: XCUIElement {
        return app.textFields["pan"]
    }

    var panText: String? {
        return panField.value as? String
    }

    var expiryDateText: String? {
        return expiryDateField.value as? String
    }

    var expiryDateField: XCUIElement {
        return app.textFields["expiryDate"]
    }

    var cvcField: XCUIElement {
        return app.textFields["cvc"]
    }

    var cvcText: String? {
        return cvcField.value as? String
    }

    var cardBrandImage: XCUIElement {
        return app.images["cardBrandImage"]
    }

    var submitButton: XCUIElement {
        return app.buttons["Submit"]
    }

    var paymentsCvcSessionToggleLabel: XCUIElement {
        return app.staticTexts["paymentsCvcSessionToggleLabel"]
    }

    var paymentsCvcSessionToggleHintLabel: XCUIElement {
        return app.staticTexts["paymentsCvcSessionToggleHintLabel"]
    }

    var alert: AlertViewPageObject {
        return AlertViewPageObject(element: app.alerts.firstMatch)
    }

    var paymentsCvcSessionToggle: SwitchViewPageObject {
        return SwitchViewPageObject(element: app.switches["paymentsCvcSessionToggle"])
    }

    var panIsValidLabel: XCUIElement {
        return app.staticTexts["panIsValidLabel"]
    }

    var expiryDateIsValidLabel: XCUIElement {
        return app.staticTexts["expiryDateIsValidLabel"]
    }

    var cvcIsValidLabel: XCUIElement {
        return app.staticTexts["cvcIsValidLabel"]
    }

    init(_ app: XCUIApplication) {
        self.app = app
    }

    func typeTextIntoPan(_ text: String) {
        if !panField.isFocused {
            panField.tap()
        }
        panField.typeText(text)
    }

    func panCaretPosition() -> Int {
        let textField = app.textFields["getPanCaretPositionTextField"]
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
        let textField = app.textFields["setPanCaretPositionTextField"]
        textField.tap()
        textField.typeText("\(position)")

        let button = app.buttons["setPanCaretPositionButton"]
        button.tap()

        for character in text {
            panField.typeText(character)
        }
    }

    func selectPanAndTypeIn(position: Int, selectionLength: Int, text: [String]) {
        let textField = app.textFields["setPanCaretPositionTextField"]
        textField.tap()
        textField.typeText("\(position)|\(selectionLength)")

        let button = app.buttons["setPanCaretPositionButton"]
        button.tap()

        for character in text {
            panField.typeText(character)
        }
    }

    func typeTextIntoExpiryDate(_ text: String) {
        if !expiryDateField.isFocused {
            expiryDateField.tap()
        }
        expiryDateField.typeText(text)
    }

    func typeTextIntoCvc(_ text: String) {
        if !cvcField.isFocused {
            cvcField.tap()
        }
        cvcField.typeText(text)
    }

    func submit() {
        submitButton.tap()
    }

    func imageIs(_ brand: String) -> Bool {
        let brandAsLocalizedString = NSLocalizedString(brand, bundle: Bundle(for: type(of: self)), comment: "")

        return cardBrandImage.label == brandAsLocalizedString
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
