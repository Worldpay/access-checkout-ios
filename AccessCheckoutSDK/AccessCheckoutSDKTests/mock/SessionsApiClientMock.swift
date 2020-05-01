@testable import AccessCheckoutSDK

class SessionsApiClientMock: SessionsApiClient {
    var createSessionCalled: Bool = false
    var sessionToReturn: String?
    var error: AccessCheckoutClientError?
    
    init(sessionToReturn: String?) {
        self.sessionToReturn = sessionToReturn
        
        let discovery = ApiDiscoveryClient(baseUrl: URL(string: "http://localhost")!)
        let merchantId = ""
        super.init(discovery: discovery, merchantIdentifier: merchantId)
    }
    
    init(error: AccessCheckoutClientError?) {
        self.error = error
        
        let discovery = ApiDiscoveryClient(baseUrl: URL(string: "")!)
        let merchantId = ""
        super.init(discovery: discovery, merchantIdentifier: merchantId)
    }
    
    public override func createSession(cvv: CVV, urlSession: URLSession, completionHandler: @escaping (Result<String, AccessCheckoutClientError>) -> Void) {
        createSessionCalled = true
        
        if let sessionToReturn = self.sessionToReturn {
            completionHandler(.success(sessionToReturn))
        } else if let error = self.error {
            completionHandler(.failure(error))
        }
    }
}
