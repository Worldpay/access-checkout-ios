import PromiseKit

class SessionsApiClient {
    private let sessionNotFoundError = AccessCheckoutClientError.sessionNotFound(message: "Failed to find link \(ApiLinks.sessions.result) in response")
    
    private var discovery: SessionsApiDiscovery
    private var urlRequestFactory: PaymentsCvcSessionURLRequestFactory
    private var restClient: RestClient
    private var apiResponseLinkLookup:ApiResponseLinkLookup

    init() {
        self.discovery = SessionsApiDiscovery()
        self.urlRequestFactory = PaymentsCvcSessionURLRequestFactory()
        self.restClient = RestClient()
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }
    
    init(discovery:SessionsApiDiscovery) {
        self.discovery = discovery
        self.urlRequestFactory = PaymentsCvcSessionURLRequestFactory()
        self.restClient = RestClient()
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }

    init(discovery: SessionsApiDiscovery, urlRequestFactory: PaymentsCvcSessionURLRequestFactory, restClient: RestClient) {
        self.discovery = discovery
        self.urlRequestFactory = urlRequestFactory
        self.restClient = restClient
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }

    func createSession(baseUrl: String, merchantId: String, cvv: CVV) -> Promise<String> {
        return Promise { seal in
            firstly {
                discovery.discover(baseUrl: baseUrl)
            }.then { endPointUrl in
                self.fireRequest(endPointUrl: endPointUrl, merchantId: merchantId, cvv: cvv)
            }.done { response in
                if let session = self.apiResponseLinkLookup.lookup(link: ApiLinks.sessions.result, in: response) {
                    seal.fulfill(session)
                } else {
                    seal.reject(self.sessionNotFoundError)
                }
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    private func fireRequest(endPointUrl: String, merchantId: String, cvv: CVV) -> Promise<ApiResponse> {
        let request = createRequest(endPointUrl: endPointUrl, merchantId: merchantId, cvv: cvv)
        return restClient.send(urlSession: URLSession.shared, request: request, responseType: ApiResponse.self)
    }
    
    private func createRequest(endPointUrl: String, merchantId:String, cvv: CVV) -> URLRequest {
        return urlRequestFactory.create(url: endPointUrl, cvv: cvv, merchantIdentity: merchantId, bundle: Bundle(for: SessionsApiClient.self))

    }
}
