@testable import AccessCheckoutSDK

class SessionsApiDiscoveryMock: SessionsApiDiscovery {
    private var url: String?
    private var error: AccessCheckoutError?
    
    override func discover(baseUrl: String, completionHandler: @escaping (Swift.Result<String, AccessCheckoutError>) -> Void) {
        if let url = url {
            completionHandler(.success(url))
        } else if let error = error {
            completionHandler(.failure(error))
        }
    }
    
    func willComplete(with url: String) {
        self.url = url
    }
    
    func willComplete(with error: AccessCheckoutError) {
        self.error = error
    }
}
