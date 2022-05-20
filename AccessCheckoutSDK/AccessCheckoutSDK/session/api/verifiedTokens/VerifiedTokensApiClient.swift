import Foundation

class VerifiedTokensApiClient {
    private let sessionNotFoundError = AccessCheckoutError.sessionLinkNotFound(linkName: ApiLinks.sessions.result)

    private var discovery: VerifiedTokensApiDiscovery
    private var urlRequestFactory: VerifiedTokensSessionURLRequestFactory
    private var restClient: RestClient
    private var apiResponseLinkLookup: ApiResponseLinkLookup

    init() {
        self.discovery = VerifiedTokensApiDiscovery()
        self.urlRequestFactory = VerifiedTokensSessionURLRequestFactory()
        self.restClient = RestClient()
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }

    init(discovery: VerifiedTokensApiDiscovery) {
        self.discovery = discovery
        self.urlRequestFactory = VerifiedTokensSessionURLRequestFactory()
        self.restClient = RestClient()
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }

    init(discovery: VerifiedTokensApiDiscovery, urlRequestFactory: VerifiedTokensSessionURLRequestFactory, restClient: RestClient) {
        self.discovery = discovery
        self.urlRequestFactory = urlRequestFactory
        self.restClient = restClient
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }

    func createSession(baseUrl: String, merchantId: String, pan: String, expiryMonth: UInt, expiryYear: UInt, cvc: String,
                       completionHandler: @escaping (Result<String, AccessCheckoutError>) -> Void) {
        discovery.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success(let endPointUrl):
                self.fireRequest(endPointUrl: endPointUrl,
                                 merchantId: merchantId,
                                 pan: pan,
                                 expiryMonth: expiryMonth,
                                 expiryYear: expiryYear,
                                 cvc: cvc) { result in
                    switch result {
                    case .success(let response):
                        if let session = self.apiResponseLinkLookup.lookup(link: ApiLinks.verifiedTokens.result, in: response) {
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

    private func fireRequest(endPointUrl: String, merchantId: String, pan: String, expiryMonth: UInt, expiryYear: UInt, cvc: String,
                             completionHandler: @escaping (Swift.Result<ApiResponse, AccessCheckoutError>) -> Void) {
        let request = createRequest(endPointUrl: endPointUrl,
                                    merchantId: merchantId,
                                    pan: pan, expiryMonth:
                                    expiryMonth,
                                    expiryYear: expiryYear,
                                    cvc: cvc)
        restClient.send(urlSession: URLSession.shared, request: request, responseType: ApiResponse.self) { result in
            completionHandler(result)
        }
    }

    private func createRequest(endPointUrl: String, merchantId: String, pan: String, expiryMonth: UInt, expiryYear: UInt, cvc: String) -> URLRequest {
        return urlRequestFactory.create(url: endPointUrl,
                                        merchantId: merchantId,
                                        pan: pan,
                                        expiryMonth: expiryMonth,
                                        expiryYear: expiryYear,
                                        cvc: cvc)
    }
}
