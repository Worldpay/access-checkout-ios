@testable import AccessCheckoutSDK

class VerifiedTokensApiClientMock: VerifiedTokensApiClient {
    var createSessionCalled: Bool = false
    var sessionToReturn: String?
    var error: Error?
    
    init(sessionToReturn: String?) {
        self.sessionToReturn = sessionToReturn
        
        let discovery = ApiDiscoveryClient(baseUrl: URL(string: "http://localhost")!)
        let merchantId = ""
        super.init(discovery: discovery, merchantIdentifier: merchantId)
    }
    
    init(error: Error?) {
        self.error = error
        
        let discovery = ApiDiscoveryClient(baseUrl: URL(string: "")!)
        let merchantId = ""
        super.init(discovery: discovery, merchantIdentifier: merchantId)
    }
    
    public override func createSession(pan: PAN, expiryMonth: UInt, expiryYear: UInt, cvv: CVV, urlSession: URLSession, completionHandler: @escaping (Result<String, Error>) -> Void) {
        createSessionCalled = true
        
        if let sessionToReturn = self.sessionToReturn {
            completionHandler(.success(sessionToReturn))
        } else if let error = self.error {
            completionHandler(.failure(error))
        }
    }
}
