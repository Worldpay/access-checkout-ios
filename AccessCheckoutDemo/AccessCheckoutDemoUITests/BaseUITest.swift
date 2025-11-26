import XCTest

class BaseUITest: XCTestCase {
    var app: XCUIApplication!
    
    var customLaunchArguments: [String: String] {
        return [:]
    }
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launchArguments.append("DISABLE_ANIMATIONS")
        

        for (key, value) in customLaunchArguments {
            app.launchArguments.append("-\(key)")
            app.launchArguments.append(value)
        }
        
        app.launchEnvironment["UIViewAnimationDuration"] = "0"
        app.launch()
    }
}
