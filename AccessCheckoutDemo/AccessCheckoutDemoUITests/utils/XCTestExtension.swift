import XCTest

extension XCTest {
    func appLauncher() -> AppLauncher {
        return AppLauncher.appLauncher()
    }

    func clearTextField(app: XCUIApplication, field: XCUIElement) {
        // The Select All menu does not appear when just tapping on the field. For it to be correctly displayed we need to tap at another location in the field than where we're at. I have not found out why.
        let otherLocationOnField = field.coordinate(withNormalizedOffset: CGVector(dx: 1, dy: 1))
        otherLocationOnField.tap()
        wait(0.5)
        app.menuItems["Select All"].tap()
        wait(0.5)
        app.menuItems["Cut"].tap()
        wait(0.05)
    }

    private func wait(_ timeoutInSeconds: TimeInterval) {
        let exp = XCTestCase().expectation(description: "Waiting for \(timeoutInSeconds)")
        _ = XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }
}
