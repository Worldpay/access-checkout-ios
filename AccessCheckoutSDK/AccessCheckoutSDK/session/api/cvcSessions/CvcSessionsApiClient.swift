import Foundation

class CvcSessionsApiClient {
    private let sessionNotFoundError = AccessCheckoutError.sessionLinkNotFound(linkName: ApiLinks.cvcSessions.result)

    private var discovery: CvcSessionsApiDiscovery
    private var urlRequestFactory: CvcSessionURLRequestFactory
    private var restClient: RestClient
    private var apiResponseLinkLookup: ApiResponseLinkLookup

    init() {
        self.discovery = CvcSessionsApiDiscovery()
        self.urlRequestFactory = CvcSessionURLRequestFactory()
        self.restClient = RestClient()
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }

    init(discovery: CvcSessionsApiDiscovery) {
        self.discovery = discovery
        self.urlRequestFactory = CvcSessionURLRequestFactory()
        self.restClient = RestClient()
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }

    init(discovery: CvcSessionsApiDiscovery, urlRequestFactory: CvcSessionURLRequestFactory, restClient: RestClient) {
        self.discovery = discovery
        self.urlRequestFactory = urlRequestFactory
        self.restClient = restClient
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }

    func createSession(baseUrl: String, checkoutId: String, cvc: String, completionHandler: @escaping (Result<String, AccessCheckoutError>) -> Void) {
        discovery.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success(let endPointUrl):
                self.fireRequest(endPointUrl: endPointUrl, checkoutId: checkoutId, cvc: cvc) { result in
                    switch result {
                    case .success(let response):
                        if let session = self.apiResponseLinkLookup.lookup(link: ApiLinks.cvcSessions.result, in: response) {
                            completionHandler(.success(session))
                        } else {
                            completionHandler(.failure(self.sessionNotFoundError))
                        }
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    private func fireRequest(endPointUrl: String, checkoutId: String, cvc: String, completionHandler: @escaping (Swift.Result<ApiResponse, AccessCheckoutError>) -> Void) {
        let request = createRequest(endPointUrl: endPointUrl, checkoutId: checkoutId, cvc: cvc)

        restClient.send(urlSession: URLSession.shared, request: request, responseType: ApiResponse.self) { result in
            completionHandler(result)
        }
    }

    private func createRequest(endPointUrl: String, checkoutId: String, cvc: String) -> URLRequest {
        return urlRequestFactory.create(url: endPointUrl, cvc: cvc, checkoutId: checkoutId)
    }
}
