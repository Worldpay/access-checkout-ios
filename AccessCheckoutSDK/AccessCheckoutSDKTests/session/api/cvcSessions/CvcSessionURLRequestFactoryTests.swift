@testable import AccessCheckoutSDK
import XCTest

class CvcSessionURLRequestFactoryTests: XCTestCase {
    private let urlRequestFactory = CvcSessionURLRequestFactory()
    private let cvc: String = "123"
    private let sdkVersion = WpSdkHeader.sdkVersion
    private let expectedBodyAsString = "{\"cvc\":\"123\",\"identity\":\"some-identity\"}"
    private let expectedMethod = "POST"

    func testCreatesACvcSessionRequest() {
        let expectedHttpBody: Data = expectedBodyAsString.data(using: .utf8)!
        let expectedHeaderFields = ["Accept": ApiHeaders.sessionsHeaderValue,
                                    "Content-Type": ApiHeaders.sessionsHeaderValue,
                                    "X-WP-SDK": "access-checkout-ios/\(sdkVersion)"]
        var expectedRequest = URLRequest(url: URL(string: "some-url")!)
        expectedRequest.httpBody = expectedHttpBody
        expectedRequest.httpMethod = expectedMethod
        expectedRequest.allHTTPHeaderFields = expectedHeaderFields

        let request = urlRequestFactory.create(url: "some-url", cvc: cvc, checkoutId: "some-identity")

        XCTAssertEqual(request, expectedRequest)
    }

    func testHttpMethodIsPost() {
        let request = urlRequestFactory.create(url: "some-url", cvc: cvc, checkoutId: "some-identity")

        XCTAssertEqual(request.httpMethod, expectedMethod)
    }

    func testHeadersAreSetCorrectly() {
        let expectedHeaderFields = ["Accept": ApiHeaders.sessionsHeaderValue, "Content-Type": ApiHeaders.sessionsHeaderValue, "X-WP-SDK": "access-checkout-ios/\(sdkVersion)"]

        let request = urlRequestFactory.create(url: "some-url", cvc: cvc, checkoutId: "some-identity")

        XCTAssertEqual(request.allHTTPHeaderFields, expectedHeaderFields)
    }
}
