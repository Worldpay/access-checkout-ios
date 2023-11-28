@testable import AccessCheckoutSDK
import XCTest

class ApiLinksTest: XCTestCase {
    func test_cardSession_discoversSessionServiceAndCardSessionEndPoint() {
        let links = ApiLinks.cardSessions

        XCTAssertEqual(links.service, "service:sessions")
        XCTAssertEqual(links.endpoint, "sessions:card")
        XCTAssertEqual(links.result, "sessions:session")
    }

    func test_cvcSession_discoversSessionServiceAndCvcSessionEndPoint() {
        let links = ApiLinks.cvcSessions

        XCTAssertEqual(links.service, "service:sessions")
        XCTAssertEqual(links.endpoint, "sessions:paymentsCvc")
        XCTAssertEqual(links.result, "sessions:session")
    }
}
