@testable import AccessCheckoutSDK

class DiscoveryMock: Discovery {
    var serviceEndpoint: URL?
    var failDiscovery = false;
    var discoverCalled:Bool = false;
    
    func discover(serviceLinks: ApiLinks, urlSession: URLSession, onComplete: (() -> Void)?) {
        discoverCalled = true
        if !failDiscovery {
            serviceEndpoint = URL(string: "url")
        }
        onComplete?()
    }
}
