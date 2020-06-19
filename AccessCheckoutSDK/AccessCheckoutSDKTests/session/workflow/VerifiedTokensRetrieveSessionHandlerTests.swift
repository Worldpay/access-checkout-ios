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

    func testRetrievesAVerifiedTokensSession() throws {
        let expectationToFulfill = expectation(description: "session retrieved")
        let apiClient = VerifiedTokensApiClientMock(sessionToReturn: "expected-session")
        let sessionHandler = VerifiedTokensRetrieveSessionHandler(apiClient: apiClient)
        let cardDetails = try CardDetailsBuilder().pan("pan")
            .expiryDate("12/20")
            .cvc("123")
            .build()

        sessionHandler.handle("a-merchant-id", "some-url", cardDetails) { result in
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

    func testReturnsErrorWhenApiCallErrorsOut() throws {
        let expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutError(errorName: "an error", message: "a message")
        let apiClient = VerifiedTokensApiClientMock(error: expectedError)
        let sessionHandler = VerifiedTokensRetrieveSessionHandler(apiClient: apiClient)
        let cardDetails = try CardDetailsBuilder().pan("pan")
            .expiryDate("12/20")
            .cvc("123")
            .build()

        sessionHandler.handle("a-merchant-id", "some-url", cardDetails) { result in
            switch result {
                case .success:
                    XCTFail("should have failed to retrieve a session")
                    expectationToFulfill.fulfill()
                case .failure(let error):
                    XCTAssertEqual(expectedError, error)
                    expectationToFulfill.fulfill()
            }
        }

        wait(for: [expectationToFulfill], timeout: 1)
    }
}
