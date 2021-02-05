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
    }

    func submit() {
        submitButton.tap()
    }

    func clearCvc() {
        cvcField.tap()
        wait(0.5)
        app.menuItems["Select All"].tap()
        wait(0.05)
        app.menuItems["Cut"].tap()
        wait(0.05)
    }

    private func wait(_ timeoutInSeconds: TimeInterval) {
        let exp = XCTestCase().expectation(description: "Waiting for \(timeoutInSeconds)")
        _ = XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }
}
