@testable import AccessCheckoutSDK

class CVVSessionURLRequestFactoryMock: CVVSessionURLRequestFactory {
    var createCalled = false
    var urlPassed = URL(string: "")
    var cvvPassed = ""
    var requestToReturn:URLRequest?

    override func create(url: URL, cvv: CVV, merchantIdentity: String, bundle: Bundle) -> URLRequest {
        createCalled = true
        urlPassed = url
        cvvPassed = cvv
        if requestToReturn != nil {
            return requestToReturn!
        } else {
            return URLRequest(url: url)
        }
    }
}
