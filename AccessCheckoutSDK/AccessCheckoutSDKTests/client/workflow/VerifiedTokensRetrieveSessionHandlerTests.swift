@testable import AccessCheckoutSDK
import XCTest

class VerifiedTokensRetrieveSessionHandlerTests: XCTestCase {
    func testCanHandleVerifiedTokensSession() {
        let sessionHandler = VerifiedTokensRetrieveSessionHandler(apiClient: VerifiedTokensApiClientMock(sessionToReturn: ""))

        XCTAssertTrue(sessionHandler.canHandle(sessionType: SessionType.verifiedTokens))
    }

    func testCannotHandlePaymentsCvcSession() {
        let sessionHandler = VerifiedTokensRetrieveSessionHandler(apiClient: VerifiedTokensApiClientMock(sessionToReturn: ""))

        XCTAssertFalse(sessionHandler.canHandle(sessionType: SessionType.paymentsCvc))
    }

    func testRetrievesAVerifiedTokensSession() {
        let apiClient = VerifiedTokensApiClientMock(sessionToReturn: "expected-session")
        let sessionHandler = VerifiedTokensRetrieveSessionHandler(apiClient: apiClient)
        let cardDetails = CardDetails.builder().pan("pan")
            .expiryMonth("12")
            .expiryYear("20")
            .cvv("123")
            .build()
        let expectationToFulfill = expectation(description: "session retrieved")

        sessionHandler.retrieveSession("a-merchant-id", "some-url", cardDetails) { result in
            switch result {
                case .success(let session):
                    XCTAssertEqual("expected-session", session)
                    expectationToFulfill.fulfill()
                case .failure:
                    XCTFail("should not have failed to retrieve a session")
            }
        }

        wait(for: [expectationToFulfill], timeout: 1)
    }
}
