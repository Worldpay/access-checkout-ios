@testable import AccessCheckoutSDK
import PromiseKit

public class VerifiedTokensApiClientMock : VerifiedTokensApiClient {
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
    
    public override func createSession(baseUrl: String, merchantId: String, pan: PAN, expiryMonth: UInt, expiryYear: UInt, cvv: CVV) -> Promise<String> {
        createSessionCalled = true
        
        return Promise { seal in
            if let sessionToReturn = self.sessionToReturn {
                seal.fulfill(sessionToReturn)
            } else if let error = self.error {
                seal.reject(error)
            }
        }
    }
}
