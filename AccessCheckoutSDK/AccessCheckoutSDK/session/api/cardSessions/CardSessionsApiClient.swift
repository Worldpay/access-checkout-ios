import Foundation

class CardSessionsApiClient {
    private let sessionNotFoundError = AccessCheckoutError.sessionLinkNotFound(
        linkName: ApiLinks.cvcSessions.result
    )

    private var urlRequestFactory: CardSessionURLRequestFactory
    private var restClient: RestClient<ApiResponse>
    private var apiResponseLinkLookup: ApiResponseLinkLookup

    init() {
        self.urlRequestFactory = CardSessionURLRequestFactory()
        self.restClient = RestClient()
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }

    init(
        urlRequestFactory: CardSessionURLRequestFactory,
        restClient: RestClient<ApiResponse>
    ) {
        self.urlRequestFactory = urlRequestFactory
        self.restClient = restClient
        self.apiResponseLinkLookup = ApiResponseLinkLookup()
    }

    func createSession(
        checkoutId: String,
        pan: String,
        expiryMonth: UInt,
        expiryYear: UInt,
        cvc: String,
        completionHandler: @escaping (Result<String, AccessCheckoutError>) -> Void
    ) {
        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(let createCardSessionsUrl):
                self.fireRequest(
                    endPointUrl: createCardSessionsUrl.absoluteString,
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
        _ = restClient.send(
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
