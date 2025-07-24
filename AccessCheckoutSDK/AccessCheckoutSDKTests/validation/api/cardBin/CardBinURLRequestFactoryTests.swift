import XCTest

@testable import AccessCheckoutSDK

class CardBinURLRequestFactoryTests: XCTestCase {
    
    func testRequestCreatedContainsExpectedHeadersMethodAndBody() {
        let expectedRequest = createExpectedRequest()
        let urlRequestFactory = CardBinURLRequestFactory(
            url: "https://live.staging.hpp.worldpay.com/public/card/bindetails",
            checkoutId: "some-checkout-id")

        let actualRequest = urlRequestFactory.create(cardNumber: "444433332222")
        
        XCTAssertEqual(actualRequest, expectedRequest)
    }
    
    private func createExpectedRequest() -> URLRequest {
        let expectedBodyAsString = #"{""checkoutId"": ""some-checkout-id"", ""cardNumber"": ""444433332222""}"#
        let expectedHttpBody: Data = expectedBodyAsString.data(using: .utf8)!
        
        let expectedHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "WP-CallerId": "checkoutios",
            "WP-Api-Version": "1"
        ]
        let expectedUrl = "https://live.staging.hpp.worldpay.com/public/card/bindetails"
        let expectedMethod = "POST"
        
        var expectedRequest = URLRequest(url: URL(string: expectedUrl)!)
        expectedRequest.httpBody = expectedHttpBody
        expectedRequest.httpMethod = expectedMethod
        expectedRequest.allHTTPHeaderFields = expectedHeaderFields
        return expectedRequest
    }
}
