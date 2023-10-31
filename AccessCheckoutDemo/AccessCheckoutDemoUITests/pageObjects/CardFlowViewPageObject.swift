import XCTest

class CardFlowViewPageObject {
    private let waitForExistenceTimeoutInSeconds: TimeInterval = 10

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
        let element = app.alerts.firstMatch
        XCTAssertTrue(element.waitForExistence(timeout: waitForExistenceTimeoutInSeconds))

        return AlertViewPageObject(element: element)
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
        if !TestUtils.isFocused(panField) {
            panField.tap()
        }
        panField.typeText(text)
    }

    func typeTextIntoExpiryDate(_ text: String) {
        if !TestUtils.isFocused(expiryDateField) {
            expiryDateField.tap()
        }
        expiryDateField.typeText(text)
    }

    func typeTextIntoCvc(_ text: String) {
        if !TestUtils.isFocused(cvcField) {
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
        _ = selectAllMenu.waitForExistence(timeout: waitForExistenceTimeoutInSeconds)
        selectAllMenu.tap()

        let cutMenu = app.menuItems["Cut"]
        _ = cutMenu.waitForExistence(timeout: waitForExistenceTimeoutInSeconds)
        cutMenu.tap()
        TestUtils.wait(seconds: 1)
    }
}
