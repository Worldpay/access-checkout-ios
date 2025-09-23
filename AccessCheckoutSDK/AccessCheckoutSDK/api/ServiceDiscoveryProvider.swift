import Dispatch
import Foundation
import os

class ServiceDiscoveryProvider {
    private let restClient: RetryRestClientDecorator<ApiResponse>
    private let apiResponseLinkLookup: ApiResponseLinkLookup

    private static let serialQueue = DispatchQueue(
        label: "com.worldpay.access.checkout.ServiceDiscoveryProvider", qos: .userInitiated
    )

    private static var static_accessRootResponse: ApiResponse?
    private static var static_sessionsServiceUrl: String?
    private static var static_sessionsCreateCardSessionUrl: String?
    private static var static_sessionsCreateCvcSessionUrl: String?
    private static var static_cardBinUrl: String?

    private var baseUrl: URL? = nil

    static var sharedInstance: ServiceDiscoveryProvider? = nil

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
        sharedInstance = ServiceDiscoveryProvider()

        guard let baseUrlAsUrl = URL(string: baseUrl) else {
            throw AccessCheckoutIllegalArgumentError.malformedAccessBaseUrl()
        }

        sharedInstance = ServiceDiscoveryProvider(baseUrlAsUrl, restClient, apiResponseLinkLookup)
    }

    internal static var isInitialised: Bool {
        return sharedInstance != nil
    }

    static func getSessionsCardEndpoint() -> String? {
        return sharedInstance!.sessionsCreateCardSessionUrl
    }

    static func getSessionsCvcEndpoint() -> String? {
        return sharedInstance!.sessionsCreateCvcSessionUrl
    }

    static func getCardBinEndpoint() -> String? {
        return sharedInstance!.cardBinUrl
    }

    public static func discover(
        completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void
    ) {
        guard let instance = sharedInstance else {
            completionHandler(
                .failure(
                    AccessCheckoutError.internalError(
                        message: "Service discovery has not been initialised")))
            return
        }

        instance.performDiscovery(completionHandler)
    }

    private var hasDiscoveredAllUrls: Bool {
        return sessionsCreateCardSessionUrl != nil && sessionsCreateCvcSessionUrl != nil
            && cardBinUrl != nil

    }

    private var sessionsCreateCardSessionUrl: String? {
        get {
            ServiceDiscoveryProvider.serialQueue.sync {
                ServiceDiscoveryProvider.static_sessionsCreateCardSessionUrl
            }
        }
        set {
            ServiceDiscoveryProvider.serialQueue.sync {
                ServiceDiscoveryProvider.static_sessionsCreateCardSessionUrl = newValue
            }
        }
    }

    private var sessionsCreateCvcSessionUrl: String? {
        get {
            ServiceDiscoveryProvider.serialQueue.sync {
                ServiceDiscoveryProvider.static_sessionsCreateCvcSessionUrl
            }
        }
        set {
            ServiceDiscoveryProvider.serialQueue.sync {
                ServiceDiscoveryProvider.static_sessionsCreateCvcSessionUrl = newValue
            }
        }
    }

    private var sessionsServiceUrl: String? {
        get {
            ServiceDiscoveryProvider.serialQueue.sync {
                return ServiceDiscoveryProvider.static_sessionsServiceUrl
            }
        }
        set {
            ServiceDiscoveryProvider.serialQueue.sync {
                ServiceDiscoveryProvider.static_sessionsServiceUrl = newValue
            }
        }
    }

    private var cardBinUrl: String? {
        get {
            ServiceDiscoveryProvider.serialQueue.sync {
                return ServiceDiscoveryProvider.static_cardBinUrl
            }
        }
        set {
            ServiceDiscoveryProvider.serialQueue.sync {
                ServiceDiscoveryProvider.static_cardBinUrl = newValue
            }
        }
    }

    func clearCache() {
        ServiceDiscoveryProvider.serialQueue.sync {
            ServiceDiscoveryProvider.static_accessRootResponse = nil
            ServiceDiscoveryProvider.static_sessionsServiceUrl = nil
            ServiceDiscoveryProvider.static_sessionsCreateCardSessionUrl = nil
            ServiceDiscoveryProvider.static_sessionsCreateCvcSessionUrl = nil
            ServiceDiscoveryProvider.static_cardBinUrl = nil
        }
    }

    private func performDiscovery(
        _ completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void
    ) {
        self.performDiscovery(self.baseUrl!, completionHandler)
    }

    private func performDiscovery(
        _ baseUrl: URL,
        _ completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void
    ) {
        if hasDiscoveredAllUrls {
            completionHandler(.success(()))
            return
        }

        performDiscoveryOnAccessRoot(baseUrl) { resultServices in
            switch resultServices {
            case .success:
                self.performDiscoveryOnSessionsService { resultSessions in
                    switch resultSessions {
                    case .success:
                        completionHandler(.success(()))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    private func performDiscoveryOnAccessRoot(
        _ baseUrl: URL, completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void
    ) {
        if sessionsServiceUrl != nil {
            completionHandler(.success(()))
            return
        }

        sendRequest(Requests.accessRoot(baseUrl)) { result in
            switch result {
            case .success(let apiResponse):
                guard
                    let sessionsServiceUrl = self.apiResponseLinkLookup.lookup(
                        link: ApiLinks.cardSessions.service, in: apiResponse)
                else {
                    completionHandler(
                        .failure(
                            AccessCheckoutError.discoveryLinkNotFound(
                                linkName: ApiLinks.cardSessions.service)))
                    return
                }

                guard
                    let cardBinServiceUrl = self.apiResponseLinkLookup.lookup(
                        link: ApiLinks.cardBin.service, in: apiResponse)
                else {
                    completionHandler(
                        .failure(
                            AccessCheckoutError.discoveryLinkNotFound(
                                linkName: ApiLinks.cardBin.service)))
                    return
                }

                self.sessionsServiceUrl = sessionsServiceUrl
                self.cardBinUrl = cardBinServiceUrl
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    private func performDiscoveryOnSessionsService(
        completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void
    ) {
        if self.hasDiscoveredAllUrls {
            completionHandler(.success(()))
            return
        }

        let request = Requests.sessionsService(sessionsServiceUrl!)
        sendRequest(request) { result in
            switch result {
            case .success(let apiResponse):
                guard
                    let cardSessionsEndpoint = self.apiResponseLinkLookup.lookup(
                        link: ApiLinks.cardSessions.endpoint, in: apiResponse)
                else {
                    completionHandler(
                        .failure(
                            AccessCheckoutError.discoveryLinkNotFound(
                                linkName: ApiLinks.cardSessions.endpoint)))
                    return
                }
                guard
                    let cvcSessionsEndpoint = self.apiResponseLinkLookup.lookup(
                        link: ApiLinks.cvcSessions.endpoint, in: apiResponse)
                else {
                    completionHandler(
                        .failure(
                            AccessCheckoutError.discoveryLinkNotFound(
                                linkName: ApiLinks.cvcSessions.endpoint)))
                    return
                }

                self.sessionsCreateCardSessionUrl = cardSessionsEndpoint
                self.sessionsCreateCvcSessionUrl = cvcSessionsEndpoint
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    private func sendRequest(
        _ request: URLRequest,
        completionHandler: @escaping (Result<ApiResponse, AccessCheckoutError>) -> Void
    ) {
        _ = restClient.send(urlSession: URLSession.shared, request: request) { result, _ in
            completionHandler(result)
        }
    }

    private class Requests {
        fileprivate static func accessRoot(_ url: URL) -> URLRequest {
            return URLRequest(url: url)
        }

        fileprivate static func sessionsService(_ url: String) -> URLRequest {
            var request = URLRequest(url: URL(string: url)!)
            request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "content-type")
            request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "accept")
            return request
        }
    }
}
