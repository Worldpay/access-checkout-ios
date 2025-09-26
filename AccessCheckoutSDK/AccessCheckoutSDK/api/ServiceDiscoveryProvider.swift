import Dispatch
import Foundation
import os

class ServiceDiscoveryProvider {
    private let restClient: RetryRestClientDecorator<ApiResponse>
    private let apiResponseLinkLookup: ApiResponseLinkLookup

    private static let serialQueue = DispatchQueue(
        label: "com.worldpay.access.checkout.ServiceDiscoveryProvider", qos: .userInitiated
    )

    private var baseUrl: URL? = nil
    static var sharedInstance: ServiceDiscoveryProvider? = nil

    private static var _cachedResults: [UrlToDiscover: URL] = [:]
    static var cachedResults: [UrlToDiscover: URL] {
        get {
            ServiceDiscoveryProvider.serialQueue.sync {
                ServiceDiscoveryProvider._cachedResults
            }
        }
        set {
            ServiceDiscoveryProvider.serialQueue.sync {
                ServiceDiscoveryProvider._cachedResults = newValue
            }
        }
    }

    private static var _cachedResponses: [URL: ApiResponse] = [:]
    static var cachedResponses: [URL: ApiResponse] {
        get {
            ServiceDiscoveryProvider.serialQueue.sync {
                ServiceDiscoveryProvider._cachedResponses
            }
        }
        set {
            ServiceDiscoveryProvider.serialQueue.sync {
                ServiceDiscoveryProvider._cachedResponses = newValue
            }
        }
    }

    init(
        _ restClient: RetryRestClientDecorator<ApiResponse> = RetryRestClientDecorator(),
        _ apiResponseLinkLookup: ApiResponseLinkLookup = ApiResponseLinkLookup()
    ) {
        self.restClient = restClient
        self.apiResponseLinkLookup = apiResponseLinkLookup
    }

    private init(
        _ baseUrl: URL,
        _ restClient: RetryRestClientDecorator<ApiResponse> = RetryRestClientDecorator(),
        _ apiResponseLinkLookup: ApiResponseLinkLookup = ApiResponseLinkLookup()
    ) {
        self.baseUrl = baseUrl
        self.restClient = restClient
        self.apiResponseLinkLookup = apiResponseLinkLookup
    }

    static func initialise(
        _ baseUrl: String,
        _ restClient: RetryRestClientDecorator<ApiResponse> = RetryRestClientDecorator(),
        _ apiResponseLinkLookup: ApiResponseLinkLookup = ApiResponseLinkLookup()
    ) throws {
        guard let baseUrlAsUrl = URL(string: baseUrl) else {
            throw AccessCheckoutIllegalArgumentError.malformedAccessBaseUrl()
        }

        sharedInstance = ServiceDiscoveryProvider(baseUrlAsUrl, restClient, apiResponseLinkLookup)
    }

    public static func discoverAll(
        completionHandler: @escaping (Result<[UrlToDiscover: URL], AccessCheckoutError>) -> Void
    ) {
        guard sharedInstance != nil else {
            completionHandler(
                .failure(
                    AccessCheckoutError.internalError(
                        message: "Service discovery has not been initialised")))
            return
        }

        let urlsToDiscover = [
            UrlToDiscover.createCardSessions,
            UrlToDiscover.createCvcSessions,
            UrlToDiscover.cardBinDetails,
        ]

        var numberOfDiscoveriesCompleted = 0
        var errorToReturn: AccessCheckoutError? = nil

        for urlToDiscover in urlsToDiscover {
            ServiceDiscoveryProvider.discover(urlToDiscover) { result in
                numberOfDiscoveriesCompleted += 1

                if case .failure(let e) = result {
                    errorToReturn = e
                }

                if numberOfDiscoveriesCompleted == urlsToDiscover.count {
                    if let errorToReturn = errorToReturn {
                        completionHandler(.failure(errorToReturn))
                    } else {
                        completionHandler(.success(cachedResults))
                    }
                }
            }
        }
    }

    public static func discover(
        _ urlToDiscover: UrlToDiscover,
        _ completionHandler: @escaping (Result<URL, AccessCheckoutError>) -> Void
    ) {
        guard let instance = ServiceDiscoveryProvider.sharedInstance else {
            completionHandler(
                .failure(
                    AccessCheckoutError.internalError(
                        message: "Service discovery has not been initialised")))
            return
        }

        if let cachedUrl = ServiceDiscoveryProvider.cachedResults[urlToDiscover] {
            completionHandler(.success(cachedUrl))
        } else {
            instance.performDiscovery(urlToDiscover, completionHandler: completionHandler)
        }
    }

    private func performDiscovery(
        _ urlToDiscover: UrlToDiscover,
        completionHandler: @escaping (Result<URL, AccessCheckoutError>) -> Void
    ) {
        var allKeysToDiscover: [KeyToDiscover] = []
        for key in urlToDiscover.keys {
            allKeysToDiscover.append(key)
        }

        discoverUrlForKeys(nextRequestURL: baseUrl!, allKeysToDiscover: allKeysToDiscover) {
            result in
            switch result {
            case .success(let discoveredURL):
                if ServiceDiscoveryProvider.cachedResults[urlToDiscover] == nil {
                    ServiceDiscoveryProvider.cachedResults[urlToDiscover] = discoveredURL
                }

                completionHandler(.success(discoveredURL))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    private func discoverUrlForKeys(
        nextRequestURL: URL,
        allKeysToDiscover: [KeyToDiscover],
        completionHandler: @escaping (Result<URL, AccessCheckoutError>) -> Void
    ) {
        let keyToDiscover = allKeysToDiscover.first!

        discoverUrlForKey(nextRequestURL, keyToDiscover) { result in
            switch result {
            case .success(let discoveredURL):
                if keyToDiscover == allKeysToDiscover.last {
                    completionHandler(.success(discoveredURL))
                } else {
                    var keysLeftToDiscover: [KeyToDiscover] = []
                    for index in 1..<allKeysToDiscover.count {
                        keysLeftToDiscover.append(allKeysToDiscover[index])
                    }
                    self.discoverUrlForKeys(
                        nextRequestURL: discoveredURL,
                        allKeysToDiscover: keysLeftToDiscover,
                        completionHandler: completionHandler
                    )
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    private func discoverUrlForKey(
        _ requestURL: URL, _ keyToDiscover: KeyToDiscover,
        completionHandler: @escaping (Result<URL, AccessCheckoutError>) -> Void
    ) {
        if let apiResponse = ServiceDiscoveryProvider.cachedResponses[requestURL] {
            guard
                let discoveredURLAsString = self.apiResponseLinkLookup.lookup(
                    link: keyToDiscover.key, in: apiResponse)
            else {
                completionHandler(
                    .failure(
                        AccessCheckoutError.discoveryLinkNotFound(linkName: keyToDiscover.key)))
                return
            }

            completionHandler(.success(URL(string: discoveredURLAsString)!))
        } else {
            let request = createRequest(using: requestURL, for: keyToDiscover)
            _ = restClient.send(urlSession: URLSession.shared, request: request) { result, _ in
                switch result {
                case .success(let apiResponse):
                    guard
                        let discoveredURLAsString = self.apiResponseLinkLookup.lookup(
                            link: keyToDiscover.key, in: apiResponse),
                        let discoveredUrl = URL(string: discoveredURLAsString)
                    else {
                        completionHandler(
                            .failure(
                                AccessCheckoutError.discoveryLinkNotFound(
                                    linkName: keyToDiscover.key)))
                        return
                    }

                    ServiceDiscoveryProvider.cachedResponses[requestURL] = apiResponse
                    completionHandler(.success(discoveredUrl))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }

    private func createRequest(using url: URL, for keyToDiscover: KeyToDiscover) -> URLRequest {
        var request = URLRequest(url: url)
        for header in keyToDiscover.headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }

        return request
    }
}
