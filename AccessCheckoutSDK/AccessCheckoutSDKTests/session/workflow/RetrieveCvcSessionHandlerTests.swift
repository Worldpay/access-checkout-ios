@testable import AccessCheckoutSDK
import XCTest

class RetrieveCvcSessionHandlerTests: XCTestCase {
    func testCannotHandleCardSession() {
        let sessionHandler = RetrieveCvcSessionHandler(apiClient: SessionsApiClientMock(sessionToReturn: ""))

        XCTAssertFalse(sessionHandler.canHandle(sessionType: SessionType.card))
    }

    func testCanHandlePaymentsCvcSession() {
        let sessionHandler = RetrieveCvcSessionHandler(apiClient: SessionsApiClientMock(sessionToReturn: ""))

        XCTAssertTrue(sessionHandler.canHandle(sessionType: SessionType.cvc))
    }

    func testRetrievesAPaymentsCvcSession() throws {
        let expectationToFulfill = expectation(description: "")
        let apiClient = SessionsApiClientMock(sessionToReturn: "expected-session")
        let sessionHandler = RetrieveCvcSessionHandler(apiClient: apiClient)
        let cardDetails = try CardDetailsBuilder()
            .cvc(UIUtils.createAccessCheckoutUITextField(withText: "123"))
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
        let apiClient = SessionsApiClientMock(error: expectedError)
        let sessionHandler = RetrieveCvcSessionHandler(apiClient: apiClient)
        let cardDetails = try CardDetailsBuilder()
            .cvc(UIUtils.createAccessCheckoutUITextField(withText: "123"))
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
