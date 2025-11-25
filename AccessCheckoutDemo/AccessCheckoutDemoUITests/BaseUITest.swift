import XCTest

class BaseUITest: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launchArguments.append("DISABLE_ANIMATIONS")
        app.launchEnvironment["UIViewAnimationDuration"] = "0"
        app.launch()
    }
}
