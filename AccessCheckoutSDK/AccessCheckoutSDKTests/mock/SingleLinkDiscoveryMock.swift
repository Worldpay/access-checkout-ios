@testable import AccessCheckoutSDK

class SingleLinkDiscoveryMock: SingleLinkDiscovery {
    private var url: String?
    private var error: AccessCheckoutClientError?
    
    init() {
        super.init(linkToFind: "", urlRequest: URLRequest(url: URL(string: "http://localhost")!))
    }
    
    override func discover(completionHandler: @escaping (Result<String, AccessCheckoutClientError>) -> Void) {
        if let url = url {
            completionHandler(.success(url))
        } else if let error = error {
            completionHandler(.failure(error))
        }
    }
    
    func willComplete(with url: String) {
        self.url = url
    }
    
    func willComplete(with error: AccessCheckoutClientError) {
        self.error = error
    }
}
