import Dispatch
import os

class ServiceDiscoveryProvider {
    private let baseUrl: String
    private let factory: ServiceDiscoveryFactory
    private let apiResponseLinkLookup: ApiResponseLinkLookup
    private let serialQueue = DispatchQueue(
        label: "com.worldpay.access.checkout.ServiceDiscoveryProvider"
    )

    private var baseDiscovery: ApiResponse?
    private var sessionsCardDiscovery: String?
    private var sessionsCvcDiscovery: String?

    init(
        baseUrl: String,
        _ factory: ServiceDiscoveryFactory = ServiceDiscoveryFactory(),
        _ apiResponseLinkLookup: ApiResponseLinkLookup = ApiResponseLinkLookup(),
    ) {
        self.baseUrl = baseUrl
        self.factory = factory
        self.apiResponseLinkLookup = apiResponseLinkLookup
    }

    func getBaseDiscovery() -> ApiResponse? {
        serialQueue.sync {
            baseDiscovery
        }
    }

    func getSessionsCardDiscovery() -> String? {
        serialQueue.sync {
            sessionsCardDiscovery
        }
    }

    func getSessionsCvcDiscovery() -> String? {
        serialQueue.sync {
            sessionsCvcDiscovery
        }
    }

    func discover() {
        fetchBaseDiscovery {
            self.sessionsDiscovery()
        }
    }

    private func fetchBaseDiscovery(completionHandler: @escaping () -> Void) {
        let discoveryRequest = URLRequest(url: URL(string: baseUrl)!)

        factory.getDiscovery(request: discoveryRequest) { [weak self] discoveryResponse in
            guard let self = self, discoveryResponse != nil else { return }

            self.baseDiscovery = discoveryResponse
            NSLog("Base discovery received")
            completionHandler()
        }
    }

    private func sessionsDiscovery() {
        guard baseDiscovery != nil else { return }

        guard
            let sessionsHref = apiResponseLinkLookup.lookup(
                link: ApiLinks.cardSessions.service, in: baseDiscovery!)
        else {
            return
        }

        let sessionsDiscoveryRequest = sessionsDiscoveryRequest(sessionsUrl: sessionsHref)

        factory.getDiscovery(request: sessionsDiscoveryRequest) { discoveryResponse in
            self.serialQueue.async {

                guard let sessionsDiscoveryResponse = discoveryResponse else {
                    return
                }

                self.sessionsCardDiscovery = self.apiResponseLinkLookup.lookup(
                    link: ApiLinks.cardSessions.endpoint, in: sessionsDiscoveryResponse)!

                self.sessionsCvcDiscovery = self.apiResponseLinkLookup.lookup(
                    link: ApiLinks.cvcSessions.endpoint, in: sessionsDiscoveryResponse)!

                NSLog("Sessions card: \(self.sessionsCardDiscovery!)")
                NSLog("Sessions cvc: \(self.sessionsCvcDiscovery!)")
            }
        }
    }

    private func sessionsDiscoveryRequest(sessionsUrl: String) -> URLRequest {
        var request = URLRequest(url: URL(string: sessionsUrl)!)
        request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "content-type")
        request.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "accept")
        return request
    }
}
