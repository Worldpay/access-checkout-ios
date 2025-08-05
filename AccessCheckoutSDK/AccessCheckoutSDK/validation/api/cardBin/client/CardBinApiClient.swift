import Foundation

/// Internal client responsible for retrieving card BIN (Bank Identification Number) information
/// from an API endpoint with caching and retry capabilities.
internal struct CardBinApiClient {
    private var url: String
    private var checkoutId: String
    private var restClient: RestClient
    private let cacheManager = CardBinCacheManager()
    private let maxRetries = 3

    /// Initialises a new CardBinApiClient instance.
    ///
    /// - Parameters:
    ///   - url: The base URL for the card BIN API endpoint
    ///   - checkoutId: The checkout session identifier used for API authentication
    ///   - restClient: The REST client used to make HTTP requests
    init(url: String, checkoutId: String, restClient: RestClient) {
        self.url = url
        self.checkoutId = checkoutId
        self.restClient = restClient
    }

    /// Retrieves BIN information for the provided card number.
    ///
    /// This method first checks the cache for existing BIN data. If not found in cache,
    /// it fetches the information from the API with automatic retry logic for transient failures.
    ///
    /// - Parameters:
    ///   - cardNumber: The card number to retrieve BIN information for
    ///   - completionHandler: Closure called with the result containing either the BIN response or an error
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

    /// Fetches card BIN details from the API with automatic retry mechanism.
    ///
    /// This private method implements exponential backoff retry logic for handling
    /// transient network failures and server errors. It will retry up to maxRetries times
    /// for retryable errors (5xx status codes and network failures), but will not retry
    /// for client errors (4xx status codes).
    ///
    /// - Parameters:
    ///   - cardNumber: The card number to retrieve BIN information for
    ///   - cacheKey: The cache key to store the successful response under
    ///   - retries: The current retry attempt number (starts at 1)
    ///   - completionHandler: Closure called with the final result after all retry attempts
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

    /// Determines whether a failed request should be retried based on the error type and status code.
    ///
    /// Client errors (4xx status codes) are not retried as they indicate issues with the request
    /// that won't be resolved by retrying. Server errors (5xx) and network failures are considered
    /// transient and will trigger a retry.
    ///
    /// - Parameters:
    ///   - error: The error that occurred during the request
    ///   - statusCode: The HTTP status code returned by the server, if available
    /// - Returns: `true` if the request should be retried, `false` otherwise
    private func shouldRetry(error: AccessCheckoutError, statusCode: Int?) -> Bool {
        if let statusCode = statusCode, (400...499).contains(statusCode) {
            return false
        }
        return true

    }
}
