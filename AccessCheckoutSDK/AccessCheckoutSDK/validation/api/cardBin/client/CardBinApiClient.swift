import Foundation

/// Internal client responsible for retrieving card BIN (Bank Identification Number) information
/// from an API endpoint with caching and retry capabilities.
internal class CardBinApiClient {
    private let url: String
    private let restClient: RestClient<CardBinResponse>
    private let cacheManager: CardBinCacheManager
    private let maxAttempts = 3

    /// Initialises a new CardBinApiClient instance.
    ///
    /// - Parameters:
    ///   - url: The base URL for the card BIN API endpoint
    ///   - restClient: The REST client used to make HTTP requests
    init(
        url: String,
        restClient: RestClient<CardBinResponse> = RestClient<CardBinResponse>(),
        cacheManager: CardBinCacheManager = CardBinCacheManager()
    ) {
        self.url = url
        self.restClient = restClient
        self.cacheManager = cacheManager
    }

    /// Retrieves BIN information for the provided card number.
    ///
    /// This method first checks the cache for existing BIN data. If not found in cache,
    /// it fetches the information from the API with automatic retry logic for transient failures.
    ///
    /// - Parameters:
    ///   - cardNumber: The card number for retrieving the BIN information
    ///   - checkoutId: The checkoutId
    ///   - completionHandler: Closure called with the result containing either the BIN response or an error
    func retrieveBinInfo(
        cardNumber: String,
        checkoutId: String,
        completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void
    ) {
        let cacheKey = cacheManager.getCacheKey(from: cardNumber)

        if let cachedResponse = cacheManager.getCachedResponse(for: cacheKey) {
            completionHandler(.success(cachedResponse))
            return
        }

        fetchCardBinResponseWithRetry(
            cardNumber: cardNumber,
            checkoutId: checkoutId,
            cacheKey: cacheKey,
            attempt: 1,
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
        checkoutId: String,
        cacheKey: String,
        attempt: UInt,
        completionHandler: @escaping (Result<CardBinResponse, AccessCheckoutError>) -> Void
    ) {
        let urlRequestFactory = CardBinURLRequestFactory(url: url, checkoutId: checkoutId)
        let request = urlRequestFactory.create(cardNumber: cardNumber)

        restClient.send(
            urlSession: URLSession.shared, request: request
        ) { result, statusCode in
            switch result {
            case .success(let response):
                self.cacheManager.putInCache(key: cacheKey, response: response)
                completionHandler(.success(response))

            case .failure(let error):
                let nextAttempt = attempt + 1
                if self.shouldRetry(attempt: nextAttempt, statusCode: statusCode) {
                    self.fetchCardBinResponseWithRetry(
                        cardNumber: cardNumber,
                        checkoutId: checkoutId,
                        cacheKey: cacheKey,
                        attempt: nextAttempt,
                        completionHandler: completionHandler
                    )
                } else {
                    let maxRetriesReachedError = AccessCheckoutError.unexpectedApiError(
                        message:
                            "Failed after \(attempt) attempt(s) with error \(String(error.errorDescription!))"
                    )

                    completionHandler(.failure(maxRetriesReachedError))
                }

            }
        }

    }

    /// Determines whether a failed request should be retried based on the error type, status code and number of attempts
    ///
    /// Client errors (4xx status codes) are not retried as they indicate issues with the request
    /// that won't be resolved by retrying. Server errors (5xx) and network failures are considered
    /// transient and will trigger a retry.
    ///  A maximum of 3 attempts are done
    ///
    /// - Parameters:
    ///   - statusCode: The HTTP status code returned by the server, if available
    /// - Returns: `true` if the request should be retried, `false` otherwise
    private func shouldRetry(attempt: UInt, statusCode: Int?) -> Bool {
        if attempt > self.maxAttempts {
            return false
        } else if let statusCode = statusCode, (400...499).contains(statusCode) {
            return false
        }
        return true

    }
}
