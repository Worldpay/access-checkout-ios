@testable import AccessCheckoutSDK

public class VerifiedTokensApiClientMock: VerifiedTokensApiClient {
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
    
    public override func createSession(baseUrl: String, merchantId: String, pan: String, expiryMonth: UInt, expiryYear: UInt, cvc: String,
                                       completionHandler: @escaping (Result<String, AccessCheckoutClientError>) -> Void) {
        createSessionCalled = true
        
        if let sessionToReturn = self.sessionToReturn {
            completionHandler(.success(sessionToReturn))
        } else if let error = self.error {
            completionHandler(.failure(error))
        }
    }
}
