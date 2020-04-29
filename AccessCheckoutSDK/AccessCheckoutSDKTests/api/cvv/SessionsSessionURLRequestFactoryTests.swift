import Foundation
import Mockingjay
import XCTest
@testable import AccessCheckoutSDK

class SessionsSessionURLRequestFactoryTests: XCTestCase {

    private let urlRequestFactory = SessionsSessionURLRequestFactory()
    private let cvv: CVV = "123"
    private let bundle = BundleMock()
    private let appVersion = BundleMock.appVersion
    private let url: URL = URL(string: "url")!
    private let expectedBodyAsString = "{\"cvc\":\"123\",\"identity\":\"some-identity\"}"
    private let expectedMethod = "POST"

    func testCreatesACvvSessionRequest() {
        let expectedHttpBody: Data = expectedBodyAsString.data(using: .utf8)!
        let expectedHeaderFields = ["Accept": ApiHeaders.sessionsHeaderValue, "Content-Type": ApiHeaders.sessionsHeaderValue, "X-WP-SDK": "access-checkout-ios/\(appVersion)"]
        var expectedRequest = URLRequest(url: url)
        expectedRequest.httpBody = expectedHttpBody
        expectedRequest.httpMethod = expectedMethod
        expectedRequest.allHTTPHeaderFields = expectedHeaderFields

        let request = urlRequestFactory.create(url: url, cvv: cvv, merchantIdentity: "some-identity", bundle: bundle)

        XCTAssertEqual(request, expectedRequest)
    }

    func testHttpMethodIsPost() {
        let request = urlRequestFactory.create(url: url, cvv: cvv, merchantIdentity: "some-identity", bundle: bundle)

        XCTAssertEqual(request.httpMethod, expectedMethod)
    }

    func testHeadersAreSetCorrectly() {
        let expectedHeaderFields = ["Accept": ApiHeaders.sessionsHeaderValue, "Content-Type": ApiHeaders.sessionsHeaderValue, "X-WP-SDK": "access-checkout-ios/\(appVersion)"]

        let request = urlRequestFactory.create(url: url, cvv: cvv, merchantIdentity: "some-identity", bundle: bundle)

        XCTAssertEqual(request.allHTTPHeaderFields, expectedHeaderFields)
    }
}
