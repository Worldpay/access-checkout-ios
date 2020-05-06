import PromiseKit

class VerifiedTokensApiDiscovery {
    private var discoveryFactory: SingleLinkDiscoveryFactory
    
    init(discoveryFactory: SingleLinkDiscoveryFactory) {
        self.discoveryFactory = discoveryFactory
    }
    
    func discover(baseUrl: String) -> Promise<String> {
        return firstly {
            discoveryFactory.create(toFindLink: ApiLinks.verifiedTokens.service, usingRequest: requestToFindService(baseUrl)).discover()
        }.then { serviceUrl in
            self.discoveryFactory.create(toFindLink: ApiLinks.verifiedTokens.endpoint, usingRequest: self.requestToFindEndPoint(serviceUrl)).discover()
        }.then { endPointUrl -> Promise<String> in
            .value(endPointUrl)
        }
    }
    
    private func requestToFindService(_ baseUrl: String) -> URLRequest{
        return URLRequest(url: URL(string: baseUrl)!)
    }
    
    private func requestToFindEndPoint(_ serviceUrl: String) -> URLRequest{
        var request = URLRequest(url: URL(string: serviceUrl)!)
        request.addValue(ApiHeaders.verifiedTokensHeaderValue, forHTTPHeaderField: "content-type")
        
        return request
    }
}

