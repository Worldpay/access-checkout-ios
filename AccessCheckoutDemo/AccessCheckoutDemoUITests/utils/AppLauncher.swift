@testable import AccessCheckoutDemo
import XCTest

class AppLauncher {
    private init() {}
    
    static func appLauncher() -> AppLauncher {
        return AppLauncher()
    }
    
    static func launch(enableStubs: Bool? = nil) -> XCUIApplication {
        return AppLauncher().launch(enableStubs: enableStubs)
    }
    
    private func launch(enableStubs: Bool? = nil) -> XCUIApplication {
        let app = XCUIApplication()
        
        if let enableStubs = enableStubs {
            app.launchArguments.append(contentsOf: ["-\(LaunchArguments.EnableStubs)", enableStubs.description])
        }
        app.launch()
        
        return app
    }
}
