@testable import AccessCheckoutSDK

class PaymentsCvcRetrieveSessionHandlerMock: RetrieveCvcSessionHandler {
    private(set) var retrieveSessionCalled = false

    init() {
        super.init(apiClient: SessionsApiClientMock(sessionToReturn: ""))
    }

    override func handle(
        _ checkoutId: String, _ cardDetails: CardDetails,
        completionHandler: @escaping (Result<String, AccessCheckoutError>) -> Void
    ) {
        retrieveSessionCalled = true
    }
}
