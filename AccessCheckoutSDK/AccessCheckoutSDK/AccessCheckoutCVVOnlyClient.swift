import Foundation

public final class AccessCheckoutCVVOnlyClient {
    private var merchantIdentifier: String
    private var discovery: Discovery
    private var urlRequestFactory:CVVSessionURLRequestFactory
    private var restClient:RestClient

    public init(discovery: Discovery, merchantIdentifier: String) {
        self.discovery = discovery
        self.merchantIdentifier = merchantIdentifier
        self.urlRequestFactory = CVVSessionURLRequestFactory()
        self.restClient = RestClient()
    }

    init(discovery: Discovery, merchantIdentifier: String, urlRequestFactory: CVVSessionURLRequestFactory, restClient: RestClient) {
        self.discovery = discovery
        self.merchantIdentifier = merchantIdentifier
        self.urlRequestFactory = urlRequestFactory
        self.restClient = restClient
    }
    
    fileprivate func extractSession(from response:AccessCheckoutResponse) -> String? {
        return response.links.endpoints.mapValues({ $0.href })[DiscoverLinks.sessions.result]
    }
    
    public func createSession(cvv: CVV, urlSession: URLSession, completionHandler: @escaping (Result<String, AccessCheckoutClientError>) -> Void) {
        guard !cvv.isEmpty else {
            completionHandler(.failure(AccessCheckoutClientError.unknown(message: "CVV cannot be empty")))
            return
        }
        
        if let url = discovery.serviceEndpoint {
            let request = urlRequestFactory.create(url: url, cvv: cvv, merchantIdentity: merchantIdentifier, bundle: Bundle(for: AccessCheckoutCVVOnlyClient.self))
            restClient.send(urlSession: urlSession, request: request, responseType: AccessCheckoutResponse.self ) { result in
                switch result {
                    case .success(let response):
                        if let session = self.extractSession(from: response) {
                            completionHandler(.success(session))
                        } else {
                            completionHandler(.failure(AccessCheckoutClientError.endpointNotFound(message: "Endpoint not found in response")))
                        }
                    case .failure(let error):
                        completionHandler(.failure(error))
                }
            }
        } else {
            discovery.discover(serviceLinks: DiscoverLinks.sessions, urlSession: urlSession) {
                guard let url = self.discovery.serviceEndpoint else {
                    completionHandler(.failure(AccessCheckoutClientError.undiscoverable(message: "Unable to discover service")))
                    return
                }
                
                let request = self.urlRequestFactory.create(url: url, cvv: cvv, merchantIdentity: self.merchantIdentifier, bundle: Bundle(for: AccessCheckoutCVVOnlyClient.self))
                self.restClient.send(urlSession: urlSession, request: request, responseType: AccessCheckoutResponse.self) { result in
                    switch result {
                        case .success(let response):
                            if let session = self.extractSession(from: response) {
                                completionHandler(.success(session))
                            } else {
                                completionHandler(.failure(AccessCheckoutClientError.endpointNotFound(message: "Endpoint not found in response")))
                            }
                        case .failure(let error):
                            completionHandler(.failure(error))
                    }
                }
            }
        }
    }
}
