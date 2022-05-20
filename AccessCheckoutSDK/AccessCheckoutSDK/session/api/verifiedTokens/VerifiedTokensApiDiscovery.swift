import Foundation

class VerifiedTokensApiDiscovery {
    private var discoveryFactory: SingleLinkDiscoveryFactory
    
    init() {
        self.discoveryFactory = SingleLinkDiscoveryFactory()
    }
    
    init(discoveryFactory: SingleLinkDiscoveryFactory) {
        self.discoveryFactory = discoveryFactory
    }
    
    func discover(baseUrl: String, completionHandler: @escaping (Result<String, AccessCheckoutError>) -> Void) {
        createServiceDiscovery(baseUrl).discover { result in
            switch result {
                case .success(let serviceUrl):
                    self.createEndPointDiscovery(serviceUrl).discover { result in
                        switch result {
                            case .success(let endPointUrl):
                                completionHandler(.success(endPointUrl))
                            case .failure(let error):
                                completionHandler(.failure(error))
                        }
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
    
    private func createServiceDiscovery(_ baseUrl: String) -> SingleLinkDiscovery {
        let request = URLRequest(url: URL(string: baseUrl)!)
        
        return discoveryFactory.create(toFindLink: ApiLinks.verifiedTokens.service, usingRequest: request)
    }
    
    private func createEndPointDiscovery(_ serviceUrl: String) -> SingleLinkDiscovery {
        var request = URLRequest(url: URL(string: serviceUrl)!)
        request.addValue(ApiHeaders.verifiedTokensHeaderValue, forHTTPHeaderField: "content-type")
        
        return discoveryFactory.create(toFindLink: ApiLinks.verifiedTokens.endpoint, usingRequest: request)
    }
}
