@testable import AccessCheckoutSDK
import XCTest

class VerifiedTokensSessionURLRequestFactoryTests: XCTestCase {
    private let pan: PAN = "a-pan"
    private let expiryMonth: UInt = 12
    private let expiryYear: UInt = 24
    private let cvc: CVV = "123"
    private let merchantId: String = "a-merchant-id"

    private let urlRequestFactory = VerifiedTokensSessionURLRequestFactory()
    private let bundle = BundleMock()
    private let appVersion = BundleMock.appVersion
    private let expectedBodyAsString = "{\"cvc\":\"123\",\"identity\":\"some-identity\"}"
    private let expectedMethod = "POST"

    func testCreatesAVerifiedTokensSessionRequest() {
        let expectedHttpBody: Data = expectedBodyAsString.data(using: .utf8)!
        let expectedHeaderFields = ["Content-Type": ApiHeaders.verifiedTokensHeaderValue,
                                    "X-WP-SDK": "access-checkout-ios/\(appVersion)"]
        var expectedRequest = URLRequest(url: URL(string: "some-url")!)
        expectedRequest.httpBody = expectedHttpBody
        expectedRequest.httpMethod = expectedMethod
        expectedRequest.allHTTPHeaderFields = expectedHeaderFields

        let request = urlRequestFactory.create(url: "some-url",
                                               merchantId: merchantId,
                                               pan: pan,
                                               expiryMonth: expiryMonth,
                                               expiryYear: expiryYear,
                                               cvc: cvc,
                                               bundle: bundle)

        XCTAssertEqual(expectedRequest, request)
    }

    func testHttpMethodIsPost() {
        let request = urlRequestFactory.create(url: "some-url",
                                               merchantId: merchantId,
                                               pan: pan,
                                               expiryMonth: expiryMonth,
                                               expiryYear: expiryYear,
                                               cvc: cvc,
                                               bundle: bundle)

        XCTAssertEqual(expectedMethod, request.httpMethod)
    }

    func testHeadersAreSetCorrectly() {
        let expectedHeaderFields = ["Content-Type": ApiHeaders.verifiedTokensHeaderValue,
                                    "X-WP-SDK": "access-checkout-ios/\(appVersion)"]

        let request = urlRequestFactory.create(url: "some-url",
                                               merchantId: merchantId,
                                               pan: pan,
                                               expiryMonth: expiryMonth,
                                               expiryYear: expiryYear,
                                               cvc: cvc,
                                               bundle: bundle)

        XCTAssertEqual(expectedHeaderFields, request.allHTTPHeaderFields)
    }
}

//
// private func buildRequest(url: URL,
//                          bundle: Bundle,
//                          pan: PAN,
//                          expiryMonth: UInt,
//                          expiryYear: UInt,
//                          cvv: CVV) throws -> URLRequest {
//    var request = URLRequest(url: url)
//    request.addValue(ApiHeaders.verifiedTokensHeaderValue, forHTTPHeaderField: "content-type")
//    request.httpMethod = "POST"
//    let tokenRequest = VerifiedTokensSessionRequest(cardNumber: pan,
//                                                    cardExpiryDate: VerifiedTokensSessionRequest.CardExpiryDate(month: expiryMonth,
//                                                                                                                year: expiryYear),
//                                                    cvc: cvv,
//                                                    identity: merchantIdentifier)
//    request.httpBody = try JSONEncoder().encode(tokenRequest)
//
//    // Add user-agent header
//    let userAgent = UserAgent(bundle: bundle)
//    request.addValue(userAgent.headerValue, forHTTPHeaderField: UserAgent.headerName)
//
//    return request
// }
