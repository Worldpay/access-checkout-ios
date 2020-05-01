@testable import AccessCheckoutSDK
import XCTest

class VerifiedTokensRetrieveSessionHandlerTests: XCTestCase {
    let sessionHandler = VerifiedTokensRetrieveSessionHandler()

    func testCanHandleVerifiedTokensSession() {
        XCTAssertTrue(sessionHandler.canHandle(sessionType: SessionType.verifiedTokens))
    }

    func testCannotHandlePaymentsCvcSession() {
        XCTAssertFalse(sessionHandler.canHandle(sessionType: SessionType.paymentsCvc))
    }
}
