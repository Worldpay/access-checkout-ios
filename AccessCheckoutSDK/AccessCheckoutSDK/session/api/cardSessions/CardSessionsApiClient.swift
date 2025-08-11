import Foundation

class CardSessionsApiClient {
    private let sessionNotFoundError = AccessCheckoutError.sessionLinkNotFound(
        linkName: ApiLinks.cvcSessions.result
    )

    private var discovery: ServiceDiscoveryProvider
    private var urlRequestFactory: CardSessionURLRequestFactory
    private var restClient: RestClient<ApiResponse>
    private var apiResponseLinkLookup: ApiResponseLinkLookup

    init() {
        self.discovery = ServiceDiscoveryProvider()
        self.urlRequestFactory = CardSessionURLRequestFactory()
        self.restClient = RestClient()
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }

    init(discovery: ServiceDiscoveryProvider) {
        self.discovery = discovery
        self.urlRequestFactory = CardSessionURLRequestFactory()
        self.restClient = RestClient()
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }

    init(
        discovery: ServiceDiscoveryProvider,
        urlRequestFactory: CardSessionURLRequestFactory,
        restClient: RestClient<ApiResponse>
    ) {
        self.discovery = discovery
        self.urlRequestFactory = urlRequestFactory
        self.restClient = restClient
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }

    func createSession(
        baseUrl: String,
        checkoutId: String,
        pan: String,
        expiryMonth: UInt,
        expiryYear: UInt,
        cvc: String,
        completionHandler: @escaping (Result<String, AccessCheckoutError>) -> Void
    ) {
        guard let endPointUrl = ServiceDiscoveryProvider.getSessionsCardEndpoint() else {
            completionHandler(
                .failure(
                    AccessCheckoutError.discoveryLinkNotFound(
                        linkName: ApiLinks.cardSessions.endpoint)))
            return
        }

        self.fireRequest(
            endPointUrl: endPointUrl,
            checkoutId: checkoutId,
            pan: pan,
            expiryMonth: expiryMonth,
            expiryYear: expiryYear,
            cvc: cvc
        ) { result in
            switch result {
            case .success(let response):
                if let session = self.apiResponseLinkLookup.lookup(
                    link: ApiLinks.cardSessions.result,
                    in: response
                ) {
                    completionHandler(.success(session))
                } else {
                    completionHandler(.failure(self.sessionNotFoundError))
                }
            case .failure(let error):
                completionHandler(.failure(error))

            }
        }
    }

    private func fireRequest(
        endPointUrl: String,
        checkoutId: String,
        pan: String,
        expiryMonth: UInt,
        expiryYear: UInt,
        cvc: String,
        completionHandler: @escaping (Swift.Result<ApiResponse, AccessCheckoutError>) -> Void
    ) {
        let request = createRequest(
            endPointUrl: endPointUrl,
            checkoutId: checkoutId,
            pan: pan,
            expiryMonth:
                expiryMonth,
            expiryYear: expiryYear,
            cvc: cvc
        )
        restClient.send(
            urlSession: URLSession.shared,
            request: request
        ) { result, _ in
            completionHandler(result)
        }
    }

    private func createRequest(
        endPointUrl: String,
        checkoutId: String,
        pan: String,
        expiryMonth: UInt,
        expiryYear: UInt,
        cvc: String
    ) -> URLRequest {
        return urlRequestFactory.create(
            url: endPointUrl,
            checkoutId: checkoutId,
            pan: pan,
            expiryMonth: expiryMonth,
            expiryYear: expiryYear,
            cvc: cvc
        )
    }
}
