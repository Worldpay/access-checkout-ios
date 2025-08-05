import Foundation

internal struct CardBinApiClient {
    private var url: String
    private var checkoutId: String
    private var restClient: RestClient
    private let cacheManager = CardBinCacheManager()

    private let maxRetries = 3

    init(url: String, checkoutId: String, restClient: RestClient) {
        self.url = url
        self.checkoutId = checkoutId
        self.restClient = restClient
    }

    func retrieveBinInfo(
        cardNumber: String,
        completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void
    ) {
        let cacheKey = cacheManager.getCacheKey(from: cardNumber)

        if let cachedResponse = cacheManager.getCachedResponse(for: cacheKey) {
            completionHandler(.success(cachedResponse))
            return
        }

        fetchCardBinResponseWithRetry(
            cardNumber: cardNumber,
            cacheKey: cacheKey,
            retries: 1,
            completionHandler: completionHandler
        )
    }

    //Fetched card BIN details with retry mechanism
    // max retries is set to 3
    private func fetchCardBinResponseWithRetry(
        cardNumber: String,
        cacheKey: String,
        retries: Int,
        completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void
    ) {
        let urlRequestFactory = CardBinURLRequestFactory(url: url, checkoutId: checkoutId)
        let request = urlRequestFactory.create(cardNumber: cardNumber)

        restClient.send(
            urlSession: URLSession.shared, request: request, responseType: CardBinResponse.self
        ) { result, statusCode in
            switch result {
            case .success(let response):
                self.cacheManager.putInCache(key: cacheKey, response: response)
                completionHandler(.success(response))

            case .failure(let error):
                let shouldRetry = self.shouldRetry(error: error, statusCode: statusCode)

                if retries < self.maxRetries && shouldRetry {

                    self.fetchCardBinResponseWithRetry(
                        cardNumber: cardNumber,
                        cacheKey: cacheKey,
                        retries: retries + 1,
                        completionHandler: completionHandler
                    )

                } else {
                    let maxRetriesReached = AccessCheckoutError.unexpectedApiError(
                        message: "Failed after \(self.maxRetries)")

                    completionHandler(.failure(maxRetriesReached))
                }

            }
        }

    }

    private func shouldRetry(error: AccessCheckoutError, statusCode: Int?) -> Bool {
        if let statusCode = statusCode, (400...499).contains(statusCode) {
            return false
        }
        // returns true for other errors (5xx) as true so will retry
        return true

    }
}
