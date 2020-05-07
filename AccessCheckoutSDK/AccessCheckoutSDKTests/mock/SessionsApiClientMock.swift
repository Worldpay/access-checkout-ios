@testable import AccessCheckoutSDK
import PromiseKit

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
    
    public override func createSession(baseUrl: String, merchantId:String, cvv: CVV) -> Promise<String> {
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
