@testable import AccessCheckoutSDK
import XCTest

class PaymentsCvcSessionURLRequestFactoryTests: XCTestCase {
    private let urlRequestFactory = PaymentsCvcSessionURLRequestFactory()
    private let cvc: String = "123"
    private let bundle = BundleMock()
    private let appVersion = BundleMock.appVersion
    private let expectedBodyAsString = "{\"cvc\":\"123\",\"identity\":\"some-identity\"}"
    private let expectedMethod = "POST"

    func testCreatesAPaymentsCvcSessionRequest() {
        let expectedHttpBody: Data = expectedBodyAsString.data(using: .utf8)!
        let expectedHeaderFields = ["Accept": ApiHeaders.sessionsHeaderValue,
                                    "Content-Type": ApiHeaders.sessionsHeaderValue,
                                    "X-WP-SDK": "access-checkout-ios/\(appVersion)"]
        var expectedRequest = URLRequest(url: URL(string: "some-url")!)
        expectedRequest.httpBody = expectedHttpBody
        expectedRequest.httpMethod = expectedMethod
        expectedRequest.allHTTPHeaderFields = expectedHeaderFields

        let request = urlRequestFactory.create(url: "some-url", cvc: cvc, merchantIdentity: "some-identity", bundle: bundle)

        XCTAssertEqual(request, expectedRequest)
    }

    func testHttpMethodIsPost() {
        let request = urlRequestFactory.create(url: "some-url", cvc: cvc, merchantIdentity: "some-identity", bundle: bundle)

        XCTAssertEqual(request.httpMethod, expectedMethod)
    }

    func testHeadersAreSetCorrectly() {
        let expectedHeaderFields = ["Accept": ApiHeaders.sessionsHeaderValue, "Content-Type": ApiHeaders.sessionsHeaderValue, "X-WP-SDK": "access-checkout-ios/\(appVersion)"]

        let request = urlRequestFactory.create(url: "some-url", cvc: cvc, merchantIdentity: "some-identity", bundle: bundle)

        XCTAssertEqual(request.allHTTPHeaderFields, expectedHeaderFields)
    }
}
