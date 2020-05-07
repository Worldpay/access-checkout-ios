import PromiseKit

class VerifiedTokensApiClient {
    private let sessionNotFoundError = AccessCheckoutClientError.sessionNotFound(message: "Failed to find link \(ApiLinks.sessions.result) in response")

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

    func createSession(baseUrl: String, merchantId: String, pan: PAN, expiryMonth: UInt, expiryYear: UInt, cvc: CVV) -> Promise<String> {
        return Promise { seal in
            firstly {
                discovery.discover(baseUrl: baseUrl)
            }.then { endPointUrl in
                self.fireRequest(endPointUrl: endPointUrl,
                                 merchantId: merchantId,
                                 pan: pan, expiryMonth:
                                 expiryMonth, expiryYear:
                                 expiryYear,
                                 cvc: cvc)
            }.done { response in
                if let session = self.apiResponseLinkLookup.lookup(link: ApiLinks.verifiedTokens.result, in: response) {
                    seal.fulfill(session)
                } else {
                    seal.reject(self.sessionNotFoundError)
                }
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    private func fireRequest(endPointUrl: String, merchantId: String, pan: PAN, expiryMonth: UInt, expiryYear: UInt, cvc: CVV) -> Promise<ApiResponse> {
        let request = createRequest(endPointUrl: endPointUrl,
                                    merchantId: merchantId,
                                    pan: pan, expiryMonth:
                                    expiryMonth,
                                    expiryYear: expiryYear,
                                    cvc: cvc)
        return restClient.send(urlSession: URLSession.shared, request: request, responseType: ApiResponse.self)
    }

    private func createRequest(endPointUrl: String, merchantId: String, pan: PAN, expiryMonth: UInt, expiryYear: UInt, cvc: CVV) -> URLRequest {
        return urlRequestFactory.create(url: endPointUrl,
                                        merchantId: merchantId,
                                        pan: pan,
                                        expiryMonth: expiryMonth,
                                        expiryYear: expiryYear,
                                        cvc: cvc,
                                        bundle: Bundle(for: VerifiedTokensApiClient.self))
    }
}
