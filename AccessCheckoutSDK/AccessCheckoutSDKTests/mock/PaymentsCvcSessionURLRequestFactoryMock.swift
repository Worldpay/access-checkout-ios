@testable import AccessCheckoutSDK

class PaymentsCvcSessionURLRequestFactoryMock: PaymentsCvcSessionURLRequestFactory {
    var createCalled = false
    var urlPassed = URL(string: "")
    var urlStringPassed:String?
    var cvvPassed = ""
    private var requestToReturn:URLRequest?
    
    override func create(url: String, cvv: String, merchantIdentity: String, bundle: Bundle) -> URLRequest {
        createCalled = true
        urlStringPassed = url
        cvvPassed = cvv
        if requestToReturn != nil {
            return requestToReturn!
        } else {
            return URLRequest(url: URL(string: url)!)
        }
    }
    
    func willReturn(_ urlRequest:URLRequest) {
        self.requestToReturn = urlRequest
    }
}
