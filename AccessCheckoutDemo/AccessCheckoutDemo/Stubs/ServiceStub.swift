import Foundation
import Mockingjay

protocol ServiceStub {
    func start()
}

class DiscoveryStub : ServiceStub {
    let baseUri:String
    
    init(baseUri: String) {
        self.baseUri = baseUri
    }
    
    func start() {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.DiscoveryStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: self.baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.get, uri: self.baseUri), builder: jsonData(data))
    }
}

class VerifiedTokensStub : ServiceStub {
    let baseUri:String
    
    init(baseUri: String) {
        self.baseUri = baseUri
    }
    
    func start() {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.VerifiedTokensStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: self.baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.get, uri: "\(self.baseUri)/verifiedTokens"), builder: jsonData(data))
    }
}

class VerifiedTokensSessionStub : ServiceStub {
    let baseUri:String
    
    init(baseUri: String) {
        self.baseUri = baseUri
    }
    
    func start() {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.VerifiedTokensSessionStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: self.baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.post, uri: "\(self.baseUri)/verifiedTokens/sessions"), builder: jsonData(data))
    }
}

class CardConfigurationStub : ServiceStub {
    let baseUri:String
    let cardConfigurationUri:String
    
    init(baseUri: String, cardConfigurationUri: String) {
        self.baseUri = baseUri
        self.cardConfigurationUri = cardConfigurationUri
    }
    
    func start() {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.CardConfigurationStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: self.baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.get, uri: self.cardConfigurationUri), builder: jsonData(data))
    }
}

class SessionsStub : ServiceStub {
    let baseUri:String
    
    init(baseUri: String) {
        self.baseUri = baseUri
    }
    
    func start() {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.SessionsStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: self.baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.get, uri: "\(self.baseUri)/sessions"), builder: jsonData(data))
    }
}

class SessionsPaymentsCvcStub : ServiceStub {
    let baseUri:String
    
    init(baseUri: String) {
        self.baseUri = baseUri
    }
    
    func start() {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.SessionsPaymentsCvcStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: self.baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.post, uri: "\(self.baseUri)/sessions/payments/cvc"), builder: jsonData(data))
    }
}
