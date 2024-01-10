@testable import AccessCheckoutSDK
import XCTest

class CardSessionsSessionURLRequestFactoryTests: XCTestCase {
    private let pan: String = "a-pan"
    private let expiryMonth: UInt = 12
    private let expiryYear: UInt = 24
    private let cvc: String = "123"
    private let checkoutId: String = "a-checkout-id"

    private let urlRequestFactory = CardSessionURLRequestFactory()
    private let sdkVersion = WpSdkHeader.sdkVersion
    private let expectedMethod = "POST"

    func testCreatesACardSessionRequest() {
        let expectedHeaderFields = ["Accept": ApiHeaders.sessionsHeaderValue,
                                    "Content-Type": ApiHeaders.sessionsHeaderValue,
                                    "X-WP-SDK": "access-checkout-ios/\(sdkVersion)"]
        let expectedURL = URLRequest(url: URL(string: "some-url")!)

        let request = urlRequestFactory.create(url: "some-url",
                                               checkoutId: checkoutId,
                                               pan: pan,
                                               expiryMonth: expiryMonth,
                                               expiryYear: expiryYear,
                                               cvc: cvc)

        XCTAssertEqual(expectedURL.url, request.url)
        XCTAssertEqual(expectedMethod, request.httpMethod)
        XCTAssertEqual(expectedHeaderFields, request.allHTTPHeaderFields)

        // the body fields arein random order in the URL request so we cannot test the body against the expected body using =
        // we just test that expected parts appear in it
        let body = String(decoding: request.httpBody!, as: UTF8.self)
        XCTAssertTrue(body.contains("\"identity\":\"a-checkout-id\""))
        XCTAssertTrue(body.contains("\"cardNumber\":\"a-pan\""))
        XCTAssertTrue(body.contains("\"cardExpiryDate\":{\"month\":12,\"year\":24}")
            || body.contains("\"cardExpiryDate\":{\"year\":24,\"month\":12}"))
        XCTAssertTrue(body.contains("\"cvc\":\"123\""))
    }

    func testHttpMethodIsPost() {
        let request = urlRequestFactory.create(url: "some-url",
                                               checkoutId: checkoutId,
                                               pan: pan,
                                               expiryMonth: expiryMonth,
                                               expiryYear: expiryYear,
                                               cvc: cvc)

        XCTAssertEqual(expectedMethod, request.httpMethod)
    }

    func testHeadersAreSetCorrectly() {
        let expectedHeaderFields = ["Accept": ApiHeaders.sessionsHeaderValue,
                                    "Content-Type": ApiHeaders.sessionsHeaderValue,
                                    "X-WP-SDK": "access-checkout-ios/\(sdkVersion)"]

        let request = urlRequestFactory.create(url: "some-url",
                                               checkoutId: checkoutId,
                                               pan: pan,
                                               expiryMonth: expiryMonth,
                                               expiryYear: expiryYear,
                                               cvc: cvc)

        XCTAssertEqual(expectedHeaderFields, request.allHTTPHeaderFields)
    }
}
