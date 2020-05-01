@testable import AccessCheckoutSDK
import XCTest

class PaymentsCvcRetrieveSessionHandlerTests: XCTestCase {
    let sessionHandler = PaymentsCvcRetrieveSessionHandler()

    func testCannotHandleVerifiedTokensSession() {
        XCTAssertFalse(sessionHandler.canHandle(sessionType: SessionType.verifiedTokens))
    }

    func testCanHandlePaymentsCvcSession() {
        XCTAssertTrue(sessionHandler.canHandle(sessionType: SessionType.paymentsCvc))
    }
}
