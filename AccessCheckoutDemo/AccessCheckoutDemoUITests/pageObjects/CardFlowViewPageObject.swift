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
        _ = selectAllMenu.waitForExistence(timeout: 2)
        selectAllMenu.tap()
        
        let cutMenu = app.menuItems["Cut"]
        _ = cutMenu.waitForExistence(timeout: 2)
        cutMenu.tap()
        wait(0.05)
    }

    private func wait(_ timeoutInSeconds: TimeInterval) {
        let exp = XCTestCase().expectation(description: "Waiting for \(timeoutInSeconds)")
        _ = XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }
}
