@testable import AccessCheckoutSDK
import XCTest

class RetrieveCardSessionHandlerTests: XCTestCase {
    func testCanHandleCardSession() {
        let sessionHandler = RetrieveCardSessionHandler(apiClient: CardSessionsApiClientMock(sessionToReturn: ""))

        XCTAssertTrue(sessionHandler.canHandle(sessionType: SessionType.card))
    }

    func testCannotHandlePaymentsCvcSession() {
        let sessionHandler = RetrieveCardSessionHandler(apiClient: CardSessionsApiClientMock(sessionToReturn: ""))

        XCTAssertFalse(sessionHandler.canHandle(sessionType: SessionType.cvc))
    }

    func testRetrievesACardSession() throws {
        let expectationToFulfill = expectation(description: "session retrieved")
        let apiClient = CardSessionsApiClientMock(sessionToReturn: "expected-session")
        let sessionHandler = RetrieveCardSessionHandler(apiClient: apiClient)
        let cardDetails = try CardDetailsBuilder().pan("pan")
            .expiryDate("12/20")
            .cvc("123")
            .build()

        sessionHandler.handle("a-checkout-id", "some-url", cardDetails) { result in
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
        let expectedError = StubUtils.createError(errorName: "an error", message: "a message")
        let apiClient = CardSessionsApiClientMock(error: expectedError)
        let sessionHandler = RetrieveCardSessionHandler(apiClient: apiClient)
        let cardDetails = try CardDetailsBuilder().pan("pan")
            .expiryDate("12/20")
            .cvc("123")
            .build()

        sessionHandler.handle("a-checkout-id", "some-url", cardDetails) { result in
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
