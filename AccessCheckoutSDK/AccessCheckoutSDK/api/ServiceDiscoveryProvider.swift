import Dispatch
import Foundation
import os

class ServiceDiscoveryProvider {
    private let baseUrl: String
    private let factory: ServiceDiscoveryResponseFactory
    private let apiResponseLinkLookup: ApiResponseLinkLookup

    private static let serialQueue = DispatchQueue(
        label: "com.worldpay.access.checkout.ServiceDiscoveryProvider",qos: .userInitiated
    )

    private static var baseDiscoveryResponse: ApiResponse?
    private static var sessionsCardEndpoint: String?
    private static var sessionsCvcEndpoint: String?

    init(
        baseUrl: String = "",
        _ factory: ServiceDiscoveryResponseFactory = ServiceDiscoveryResponseFactory(),
        _ apiResponseLinkLookup: ApiResponseLinkLookup = ApiResponseLinkLookup()
    ) {
        self.baseUrl = baseUrl
        self.factory = factory
        self.apiResponseLinkLookup = apiResponseLinkLookup
    }

    func getSessionsCardEndpoint() -> String? {
        ServiceDiscoveryProvider.serialQueue.sync {
            ServiceDiscoveryProvider.sessionsCardEndpoint
        }
    }

    func getSessionsCvcEndpoint() -> String? {
        ServiceDiscoveryProvider.serialQueue.sync {
            ServiceDiscoveryProvider.sessionsCvcEndpoint
        }
    }

    func clearCache() {
        ServiceDiscoveryProvider.serialQueue.sync {
            ServiceDiscoveryProvider.baseDiscoveryResponse = nil
            ServiceDiscoveryProvider.sessionsCardEndpoint = nil
            ServiceDiscoveryProvider.sessionsCvcEndpoint = nil
        }
    }
    
    static     func clearCache2() {
        ServiceDiscoveryProvider.serialQueue.sync {
            ServiceDiscoveryProvider.baseDiscoveryResponse = nil
            ServiceDiscoveryProvider.sessionsCardEndpoint = nil
            ServiceDiscoveryProvider.sessionsCvcEndpoint = nil
        }
    }

    func discover(completionHandler: @escaping (Result<Void, AccessCheckoutError>) -> Void) {
        ServiceDiscoveryProvider.serialQueue.async {
            self.fetchBaseDiscovery { result in
                switch result {
                case .success(let discoveryResponse):
                    ServiceDiscoveryProvider.baseDiscoveryResponse = discoveryResponse

                    self.sessionsDiscovery(baseDiscoveryResponse: discoveryResponse) {
                        sessionsResult in
                        switch sessionsResult {
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
    }

    private func fetchBaseDiscovery(
        completionHandler: @escaping (Result<ApiResponse, AccessCheckoutError>) -> Void
    ) {
        if ServiceDiscoveryProvider.baseDiscoveryResponse != nil {
            completionHandler(.success(ServiceDiscoveryProvider.baseDiscoveryResponse!))
            return
        }

        let discoveryRequest = baseDiscoveryRequest()

        factory.create(request: discoveryRequest) { response in
            guard let response = response else {
                completionHandler(
                    .failure(AccessCheckoutError.unexpectedApiError(message: "Unable to fetch base discovery response.")))
                return
            }

            completionHandler(.success(response))
        }
    }

    private func sessionsDiscovery(
        baseDiscoveryResponse: ApiResponse,
        completionHandler: @escaping ((Result<Void, AccessCheckoutError>)) -> Void
    ) {
        NSLog("\(ServiceDiscoveryProvider.sessionsCardEndpoint ?? "No Card Sessions Endpoint")")
        
        NSLog("\(self.getSessionsCardEndpoint() ?? "No Card Sessions Endpoint")")
        
        NSLog("\(ServiceDiscoveryProvider.sessionsCvcEndpoint ?? "No CVC Sessions Endpoint")")
        
        NSLog("\(self.getSessionsCvcEndpoint() ?? "No CVC Sessions Endpoint")")
        
        if self.getSessionsCardEndpoint() != nil,
           self.getSessionsCvcEndpoint() != nil
        {
            completionHandler(.success(()))
            return
        }

        guard
            let sessionsHref = apiResponseLinkLookup.lookup(
                link: ApiLinks.cardSessions.service, in: baseDiscoveryResponse)
        else {
            completionHandler(
                .failure(
                    (AccessCheckoutError.discoveryLinkNotFound(
                        linkName: ApiLinks.cardSessions.service))))
            return
        }

        let discoveryRequest = sessionsDiscoveryRequest(url: sessionsHref)

        factory.create(request: discoveryRequest) { response in
            guard let discoveryResponse = response else {
                completionHandler(
                    .failure(
                        AccessCheckoutError.unexpectedApiError(
                            message: "Unable to fetch sessions discovery response.")))
                return
            }

            ServiceDiscoveryProvider.sessionsCardEndpoint = self.apiResponseLinkLookup.lookup(
                link: ApiLinks.cardSessions.endpoint, in: discoveryResponse)
            

            ServiceDiscoveryProvider.sessionsCvcEndpoint = self.apiResponseLinkLookup.lookup(
                link: ApiLinks.cvcSessions.endpoint, in: discoveryResponse)
            
            completionHandler(.success(()))
        }
    }

    private func baseDiscoveryRequest() -> URLRequest {
        return URLRequest(url: URL(string: baseUrl)!)
    }

    private func sessionsDiscoveryRequest(url: String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "content-type")
        request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "accept")
        return request
    }
}
