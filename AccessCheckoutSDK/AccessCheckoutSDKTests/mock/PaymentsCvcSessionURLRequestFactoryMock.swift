@testable import AccessCheckoutSDK

class PaymentsCvcSessionURLRequestFactoryMock: PaymentsCvcSessionURLRequestFactory {
    var createCalled = false
    var urlPassed = URL(string: "")
    var urlStringPassed:String?
    var cvcPassed = ""
    private var requestToReturn:URLRequest?
    
    override func create(url: String, cvc: String, merchantIdentity: String, bundle: Bundle) -> URLRequest {
        createCalled = true
        urlStringPassed = url
        cvcPassed = cvc
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
