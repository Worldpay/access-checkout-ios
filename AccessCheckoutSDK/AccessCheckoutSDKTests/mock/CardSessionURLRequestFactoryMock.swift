@testable import AccessCheckoutSDK

class CardSessionURLRequestFactoryMock: CardSessionURLRequestFactory {
    private(set) var createCalled = false
    private(set) var urlPassed: String?
    private(set) var panPassed: String?
    private(set) var expiryMonthPassed: UInt?
    private(set) var expiryYearPassed: UInt?
    private(set) var cvcPassed: String?
    private var requestToReturn: URLRequest?

    override func create(
        url: String, checkoutId: String, pan: String, expiryMonth: UInt, expiryYear: UInt,
        cvc: String
    ) -> URLRequest {
        createCalled = true
        urlPassed = url
        panPassed = pan
        expiryMonthPassed = expiryMonth
        expiryYearPassed = expiryYear
        cvcPassed = cvc
        if requestToReturn != nil {
            return requestToReturn!
        } else {
            return URLRequest(url: URL(string: url)!)
        }
    }

    func willReturn(_ urlRequest: URLRequest) {
        requestToReturn = urlRequest
    }
}
