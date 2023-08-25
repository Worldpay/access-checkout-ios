import XCTest

class CvcFlowViewPageObject {
    private let app: XCUIApplication

    var cvcField: XCUIElement {
        return app.textFields["cvc"]
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
        return AlertViewPageObject(element: app.alerts.firstMatch)
    }

    init(_ app: XCUIApplication) {
        self.app = app
    }

    func typeTextIntoCvc(_ text: String) {
        cvcField.tap()
        cvcField.typeText(text)
        wait(0.2)
    }

    func submit() {
        submitButton.tap()
    }

    func clearCvc() {
        cvcField.press(forDuration: 2)
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
