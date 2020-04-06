import Foundation
import Mockingjay

protocol ServiceStub {
    func start(baseUri:String)
}

class DiscoveryStub : ServiceStub {
    func start(baseUri:String) {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.DiscoveryStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.get, uri: baseUri), builder: jsonData(data))
    }
}

class VerifiedTokensStub : ServiceStub {
    func start(baseUri:String) {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.VerifiedTokensStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.get, uri: "\(baseUri)/verifiedTokens"), builder: jsonData(data))
    }
}

class VerifiedTokensSessionStub : ServiceStub {
    func start(baseUri:String) {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.VerifiedTokensSessionStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.post, uri: "\(baseUri)/verifiedTokens/sessions"), builder: jsonData(data))
    }
}

class CardConfigurationStub : ServiceStub {
    func start(baseUri:String) {
        guard let resourceName = LaunchArguments.valueOf(LaunchArguments.CardConfigurationStub),
            let data = JsonStubbedResponse(resourceName).toData(usingBaseUri: baseUri) else {
                return
        }
            
        MockingjayProtocol.addStub(matcher: http(.get, uri: baseUri), builder: jsonData(data))
    }
}
