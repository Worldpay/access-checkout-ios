import XCTest
@testable import AccessCheckoutDemo

class AppLauncher {
    private init() {
        
    }
    
    static func appLauncher() -> AppLauncher {
        return AppLauncher()
    }
    
    func launch(enableStubs: Bool? = nil) -> XCUIApplication {
        let app = XCUIApplication()
        
        if let enableStubs = enableStubs {
            app.launchArguments.append(contentsOf:["-\(LaunchArguments.EnableStubs)", enableStubs.description])
        }
        app.launch()
        
        return app
    }
}
