@testable import AccessCheckoutSDK

class RetrieveCardSessionHandlerMock: RetrieveCardSessionHandler {
    private(set) var retrieveSessionCalled = false

    init() {
        super.init(apiClient: CardSessionsApiClientMock(sessionToReturn: ""))
    }

    override func handle(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Result<String, AccessCheckoutError>) -> Void) {
        retrieveSessionCalled = true
    }
}
