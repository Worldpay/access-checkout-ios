@testable import AccessCheckoutSDK

class CardSessionsApiDiscoveryMock: CardSessionsApiDiscovery {
    private var discoveredUrl: String

    init(discoveredUrl: String) {
        self.discoveredUrl = discoveredUrl
        super.init()
    }

    override func discover(
        baseUrl: String,
        completionHandler: @escaping (Swift.Result<String, AccessCheckoutError>) -> Void
    ) {
        completionHandler(.success(discoveredUrl))
    }
}
