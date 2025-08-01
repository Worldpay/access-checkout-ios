import Dispatch
import Foundation
import os

class ServiceDiscoveryProvider {
    private let baseUrl: String
    private let factory: ServiceDiscoveryResponseFactory
    private let apiResponseLinkLookup: ApiResponseLinkLookup

    private static let serialQueue = DispatchQueue(
        label: "com.worldpay.access.checkout.ServiceDiscoveryProvider"
    )

    private static var baseDiscoveryResponse: ApiResponse?
    private static var sessionsCardEndpoint: String?
    private static var sessionsCvcEndpoint: String?

    init(
        baseUrl: String,
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

    func discover(completionHandler: @escaping () -> Void) {
        ServiceDiscoveryProvider.serialQueue.async {
            self.fetchBaseDiscovery { response in
                guard let discoveryResponse = response else { return }

                ServiceDiscoveryProvider.baseDiscoveryResponse = discoveryResponse

                self.sessionsDiscovery(baseDiscoveryResponse: discoveryResponse)
            }
            completionHandler()
        }
    }

    private func fetchBaseDiscovery(completionHandler: @escaping (ApiResponse?) -> Void) {
        if ServiceDiscoveryProvider.baseDiscoveryResponse != nil {
            completionHandler(ServiceDiscoveryProvider.baseDiscoveryResponse)
            return
        }

        let discoveryRequest = baseDiscoveryRequest()

        factory.create(request: discoveryRequest) { response in
            completionHandler(response)
        }
    }

    private func sessionsDiscovery(baseDiscoveryResponse: ApiResponse) {
        if ServiceDiscoveryProvider.sessionsCardEndpoint != nil,
            ServiceDiscoveryProvider.sessionsCvcEndpoint != nil
        {
            return
        }

        guard
            let sessionsHref = apiResponseLinkLookup.lookup(
                link: ApiLinks.cardSessions.service, in: baseDiscoveryResponse)
        else { return }

        let discoveryRequest = sessionsDiscoveryRequest(url: sessionsHref)

        factory.create(request: discoveryRequest) { response in
            guard let discoveryResponse = response else { return }

            ServiceDiscoveryProvider.sessionsCardEndpoint = self.apiResponseLinkLookup.lookup(
                link: ApiLinks.cardSessions.endpoint, in: discoveryResponse)

            ServiceDiscoveryProvider.sessionsCvcEndpoint = self.apiResponseLinkLookup.lookup(
                link: ApiLinks.cvcSessions.endpoint, in: discoveryResponse)
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
