import Dispatch
import Foundation
import os

class ServiceDiscoveryProvider {
    private let factory: ServiceDiscoveryResponseFactory
    private let apiResponseLinkLookup: ApiResponseLinkLookup

    private static let serialQueue = DispatchQueue(
        label: "com.worldpay.access.checkout.ServiceDiscoveryProvider", qos: .userInitiated
    )

    private static var static_accessRootResponse: ApiResponse?
    private static var static_sessionsServiceUrl: String?
    private static var static_sessionsCreateCardSessionUrl: String?
    private static var static_sessionsCreateCvcSessionUrl: String?

    static var shared: ServiceDiscoveryProvider = ServiceDiscoveryProvider()

    init(
        _ factory: ServiceDiscoveryResponseFactory = ServiceDiscoveryResponseFactory(),
        _ apiResponseLinkLookup: ApiResponseLinkLookup = ApiResponseLinkLookup()
    ) {
        self.factory = factory
        self.apiResponseLinkLookup = apiResponseLinkLookup
    }

    static func getSessionsCardEndpoint() -> String? {
        return shared.sessionsCreateCardSessionUrl
    }

    static func getSessionsCvcEndpoint() -> String? {
        return shared.sessionsCreateCvcSessionUrl
    }

    public static func discover(
        baseUrl: String, completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void
    ) {
        shared.performDiscovery(baseUrl, completionHandler)
    }

    private var hasDiscoveredAllUrls: Bool {
        return sessionsCreateCardSessionUrl != nil && sessionsCreateCvcSessionUrl != nil
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

    func clearCache() {
        ServiceDiscoveryProvider.serialQueue.sync {
            ServiceDiscoveryProvider.static_accessRootResponse = nil
            ServiceDiscoveryProvider.static_sessionsServiceUrl = nil
            ServiceDiscoveryProvider.static_sessionsCreateCardSessionUrl = nil
            ServiceDiscoveryProvider.static_sessionsCreateCvcSessionUrl = nil
        }
    }

    private func performDiscovery(
        _ baseUrl: String,
        _ completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void
    ) {
        if hasDiscoveredAllUrls {
            NSLog("All URLs already discovered")
            completionHandler(.success(()))
            return
        }

        performDiscoveryOnAccessRoot(baseUrl) { resultServices in
            switch resultServices {
            case .success:
                self.performDiscoveryOnSessionsService { resultSessions in
                    switch resultSessions {
                    case .success:
                        NSLog("Service discovery completed")
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
        _ baseUrl: String, completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void
    ) {
        if sessionsServiceUrl != nil {
            completionHandler(.success(()))
            return
        }

        NSLog("Discovering services and endpoint in Access Root")

        sendRequest(Requests.accessRoot(baseUrl)) { result in
            switch result {
            case .success(let apiResponse):
                if let url = self.apiResponseLinkLookup.lookup(
                    link: ApiLinks.cardSessions.service, in: apiResponse)
                {
                    self.sessionsServiceUrl = url
                    completionHandler(.success(()))
                } else {
                    completionHandler(
                        .failure(
                            AccessCheckoutError.discoveryLinkNotFound(
                                linkName: ApiLinks.cardSessions.service)))
                }
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

        NSLog("Discovering sessions services endpoint")

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
        self.factory.create(request: request) {
            result in
            completionHandler(result)
        }

    }

    private class Requests {
        fileprivate static func accessRoot(_ url: String) -> URLRequest {
            return URLRequest(url: URL(string: url)!)
        }

        fileprivate static func sessionsService(_ url: String) -> URLRequest {
            var request = URLRequest(url: URL(string: url)!)
            request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "content-type")
            request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "accept")
            return request
        }
    }
}
