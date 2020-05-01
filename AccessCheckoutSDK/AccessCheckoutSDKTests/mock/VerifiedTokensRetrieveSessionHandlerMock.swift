@testable import AccessCheckoutSDK

class VerifiedTokensRetrieveSessionHandlerMock: VerifiedTokensRetrieveSessionHandler {
    private(set) var retrieveSessionCalled = false

    override func retrieveSession(_ merchantId: String, _ baseUrl: String, _ cardDetails: CardDetails, completionHandler: @escaping (Result<String, Error>) -> Void) {
        retrieveSessionCalled = true
    }
}
