@testable import AccessCheckoutSDK

class SessionsApiClientMock: SessionsApiClient {
    var createSessionCalled: Bool = false
    var sessionToReturn: String?
    var error: AccessCheckoutClientError?
    
    init(sessionToReturn: String?) {
        self.sessionToReturn = sessionToReturn
        super.init()
    }
    
    init(error: AccessCheckoutClientError?) {
        self.error = error
        super.init()
    }
    
    public override func createSession(baseUrl: String, merchantId: String, cvv: CVV, completionHandler: @escaping (Result<String, AccessCheckoutClientError>) -> Void) {
        createSessionCalled = true
        
        if let sessionToReturn = self.sessionToReturn {
            completionHandler(.success(sessionToReturn))
        } else if let error = self.error {
            completionHandler(.failure(error))
        }
    }
}
