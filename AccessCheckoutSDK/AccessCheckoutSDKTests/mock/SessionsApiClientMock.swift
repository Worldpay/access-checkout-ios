@testable import AccessCheckoutSDK

class SessionsApiClientMock: CvcSessionsApiClient {
    var createSessionCalled: Bool = false
    var sessionToReturn: String?
    var error: AccessCheckoutError?

    init(sessionToReturn: String?) {
        self.sessionToReturn = sessionToReturn
        super.init()
    }

    init(error: AccessCheckoutError?) {
        self.error = error
        super.init()
    }

    override func createSession(
        baseUrl: String, checkoutId: String, cvc: String,
        completionHandler: @escaping (Result<String, AccessCheckoutError>) -> Void
    ) {
        createSessionCalled = true

        if let sessionToReturn = sessionToReturn {
            completionHandler(.success(sessionToReturn))
        } else if let error = error {
            completionHandler(.failure(error))
        }
    }
}
