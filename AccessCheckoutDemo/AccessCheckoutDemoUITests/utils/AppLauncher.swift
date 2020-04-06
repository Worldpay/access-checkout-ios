import XCTest
@testable import AccessCheckoutDemo

class AppLauncher {
    private var discoveryStub:String?
    private var verifiedTokensSessionStub:String?
    private var verifiedTokensStub:String?
    
    private init() {
        
    }
    
    static func appLauncher() -> AppLauncher {
        return AppLauncher()
    }
    
    func launch() -> XCUIApplication {
        let app = XCUIApplication()
        
        if let resourceName = self.discoveryStub {
            app.launchArguments.append(contentsOf:["-\(LaunchArguments.DiscoveryStub)", resourceName])
        }
        if let resourceName = self.verifiedTokensSessionStub {
            app.launchArguments.append(contentsOf:["-\(LaunchArguments.VerifiedTokensSessionStub)", resourceName])
        }
        if let resourceName = self.verifiedTokensStub {
            app.launchArguments.append(contentsOf:["-\(LaunchArguments.VerifiedTokensStub)", resourceName])
        }
        app.launch()
        
        return app
    }
    
    func discoveryStub(respondsWith discoveryStub:String) -> AppLauncher {
        self.discoveryStub = discoveryStub
        return self
    }
    
    func verifiedTokensStub(respondsWith verifiedTokensStub:String) -> AppLauncher {
        self.verifiedTokensStub = verifiedTokensStub
        return self
    }
    
    func verifiedTokensSessionStub(respondsWith verifiedTokensSessionStub:String) -> AppLauncher {
        self.verifiedTokensSessionStub = verifiedTokensSessionStub
        return self
    }
}

