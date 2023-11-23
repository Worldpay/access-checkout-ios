import XCTest

class CvcFlowViewPageObject {
    private let waitForExistenceTimeoutInSeconds: TimeInterval = 10
    private let app: XCUIApplication

    var cvcField: XCUIElement {
        return app.otherElements["cvc"].textFields.firstMatch
    }

    var cvcText: String? {
        return cvcField.value as? String
    }

    var cvcIsValidLabel: XCUIElement {
        return app.staticTexts["cvcIsValidLabel"]
    }

    var submitButton: XCUIElement {
        return app.buttons["Submit"]
    }

    var alert: AlertViewPageObject {
        let element = app.alerts.firstMatch
        XCTAssertTrue(element.waitForExistence(timeout: waitForExistenceTimeoutInSeconds))

        return AlertViewPageObject(element: element)
    }

    init(_ app: XCUIApplication) {
        self.app = app
    }

    func typeTextIntoCvc(_ text: String) {
        cvcField.tap()
        cvcField.typeText(text)
        TestUtils.wait(seconds: 0.2)
    }

    func submit() {
        submitButton.tap()
    }

    func clearCvc() {
        cvcField.press(forDuration: 2)
        let selectAllMenu = app.menuItems["Select All"]
        _ = selectAllMenu.waitForExistence(timeout: waitForExistenceTimeoutInSeconds)
        selectAllMenu.tap()

        let cutMenu = app.menuItems["Cut"]
        _ = cutMenu.waitForExistence(timeout: waitForExistenceTimeoutInSeconds)
        cutMenu.tap()
        TestUtils.wait(seconds: 1)
    }
}
