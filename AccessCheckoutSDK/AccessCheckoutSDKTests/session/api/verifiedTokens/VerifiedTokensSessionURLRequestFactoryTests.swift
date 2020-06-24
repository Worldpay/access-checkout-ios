@testable import AccessCheckoutSDK
import XCTest

class VerifiedTokensSessionURLRequestFactoryTests: XCTestCase {
    private let pan: String = "a-pan"
    private let expiryMonth: UInt = 12
    private let expiryYear: UInt = 24
    private let cvc: String = "123"
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
