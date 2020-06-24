@testable import AccessCheckoutSDK

class PaymentsCvcRetrieveSessionHandlerMock: PaymentsCvcRetrieveSessionHandler {
    private(set) var retrieveSessionCalled = false

    init() {
        super.init(apiClient: SessionsApiClientMock(sessionToReturn: ""))
    }

    override func handle(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Result<String, AccessCheckoutError>) -> Void) {
        retrieveSessionCalled = true
    }
}
