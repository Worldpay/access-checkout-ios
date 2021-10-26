import XCTest
@testable import AccessCheckoutDemo

class AppLauncher {
    private var discoveryStub:String?
    private var sessionsPaymentsCvcStub:String?
    private var sessionsStub:String?
    private var verifiedTokensSessionStub:String?
    private var verifiedTokensStub:String?
    private var disableStubs:String?
    
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
        if let resourceName = self.sessionsPaymentsCvcStub {
            app.launchArguments.append(contentsOf:["-\(LaunchArguments.SessionsPaymentsCvcStub)", resourceName])
        }
        if let resourceName = self.sessionsStub {
            app.launchArguments.append(contentsOf:["-\(LaunchArguments.SessionsStub)", resourceName])
        }
        if let resourceName = self.verifiedTokensSessionStub {
            app.launchArguments.append(contentsOf:["-\(LaunchArguments.VerifiedTokensSessionStub)", resourceName])
        }
        if let resourceName = self.verifiedTokensStub {
            app.launchArguments.append(contentsOf:["-\(LaunchArguments.VerifiedTokensStub)", resourceName])
        }
        if let disableStubs = self.disableStubs {
            app.launchArguments.append(contentsOf:["-\(LaunchArguments.DisableStubs)", disableStubs])
        }
        app.launch()
        
        return app
    }
    
    func disableStubs(_ value:Bool) -> AppLauncher {
        self.disableStubs = value.description
        return self
    }
    
    func discoveryStub(respondsWith discoveryStub:String) -> AppLauncher {
        self.discoveryStub = discoveryStub
        return self
    }
    
    func sessionsStub(respondsWith sessionsStub:String) -> AppLauncher {
        self.sessionsStub = sessionsStub
        return self
    }
    
    func sessionsPaymentsCvcStub(respondsWith sessionsPaymentsCvcStub:String) -> AppLauncher {
        self.sessionsPaymentsCvcStub = sessionsPaymentsCvcStub
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
