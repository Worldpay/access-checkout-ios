@testable import AccessCheckoutSDK

class PaymentsCvcRetrieveSessionHandlerMock: PaymentsCvcRetrieveSessionHandler {
    private(set) var retrieveSessionCalled = false

    init() {
        super.init(apiClient: SessionsApiClientMock(sessionToReturn: ""))
    }

    override func retrieveSession(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Result<String, AccessCheckoutClientError>) -> Void) {
        retrieveSessionCalled = true
    }
}
