@testable import AccessCheckoutSDK
import PromiseKit

class RestClientMock<T: Decodable>: RestClient {
    private(set) var sendMethodCalled = false
    private(set) var expectedRequestSent = false
    private(set) var requestSent:URLRequest?
    private var response:T?
    private var error:AccessCheckoutClientError?

    init (replyWith response:T) {
        self.response = response
    }
    
    init (errorWith error:AccessCheckoutClientError) {
        self.error = error
    }
    
    override func send<T: Decodable>(urlSession: URLSession, request: URLRequest, responseType: T.Type) -> Promise<T>  {
        sendMethodCalled = true
        requestSent = request
        
        return Promise { seal in
            if(response != nil) {
                seal.fulfill(response as! T)
            } else if (error != nil) {
                seal.reject(error!)
            }
        }
    }
}
