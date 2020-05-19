@testable import AccessCheckoutSDK

class VerifiedTokensRetrieveSessionHandlerMock: VerifiedTokensRetrieveSessionHandler {
    private(set) var retrieveSessionCalled = false

    init() {
        super.init(apiClient: VerifiedTokensApiClientMock(sessionToReturn: ""))
    }

    override func handle(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Result<String, AccessCheckoutClientError>) -> Void) {
        retrieveSessionCalled = true
    }
}
