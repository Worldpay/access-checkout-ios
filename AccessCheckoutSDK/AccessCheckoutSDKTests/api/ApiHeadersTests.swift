@testable import AccessCheckoutSDK
import XCTest

class ApiHeadersTest: XCTestCase {
    func test_sessionsHeaderValue_pointsToSessionsV1() {
        XCTAssertEqual(ApiHeaders.sessionsHeaderValue, "application/vnd.worldpay.sessions-v1.hal+json")
    }
}
