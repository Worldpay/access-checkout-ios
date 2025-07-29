import Foundation

internal struct CardBinApiClient {
    private var url: String
    private var checkoutId: String
    private var restClient: RestClient
    private let cacheManager = CardBinCacheManager()

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

        let urlRequestFactory = CardBinURLRequestFactory(url: url, checkoutId: checkoutId)
        let request = urlRequestFactory.create(cardNumber: cardNumber)
        restClient.send(
            urlSession: URLSession.shared, request: request, responseType: CardBinResponse.self
        ) { result, _ in
            switch result {
            case .success(let response):
                self.cacheManager.putInCache(key: cacheKey, response: response)
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
