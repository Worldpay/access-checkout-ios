@testable import AccessCheckoutSDK

class VerifiedTokensSessionURLRequestFactoryMock: VerifiedTokensSessionURLRequestFactory {
    private(set) var createCalled = false
    private(set) var urlPassed:String?
    private(set) var panPassed:String?
    private(set) var expiryMonthPassed:UInt?
    private(set) var expiryYearPassed:UInt?
    private(set) var cvvPassed:String?
    private var requestToReturn:URLRequest?
    
    override func create(url: String, merchantId: String, pan: PAN, expiryMonth: UInt, expiryYear: UInt, cvv: CVV, bundle: Bundle) -> URLRequest {
        createCalled = true
        urlPassed = url
        panPassed = pan
        expiryMonthPassed = expiryMonth
        expiryYearPassed = expiryYear
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
