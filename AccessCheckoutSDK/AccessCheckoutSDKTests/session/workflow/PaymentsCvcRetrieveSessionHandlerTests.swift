@testable import AccessCheckoutSDK
import XCTest

class PaymentsCvcRetrieveSessionHandlerTests: XCTestCase {
    func testCannotHandleVerifiedTokensSession() {
        let sessionHandler = PaymentsCvcRetrieveSessionHandler(apiClient: SessionsApiClientMock(sessionToReturn: ""))

        XCTAssertFalse(sessionHandler.canHandle(sessionType: SessionType.verifiedTokens))
    }

    func testCanHandlePaymentsCvcSession() {
        let sessionHandler = PaymentsCvcRetrieveSessionHandler(apiClient: SessionsApiClientMock(sessionToReturn: ""))

        XCTAssertTrue(sessionHandler.canHandle(sessionType: SessionType.paymentsCvc))
    }

    func testRetrievesAPaymentsCvcSession() throws {
        let expectationToFulfill = expectation(description: "")
        let apiClient = SessionsApiClientMock(sessionToReturn: "expected-session")
        let sessionHandler = PaymentsCvcRetrieveSessionHandler(apiClient: apiClient)
        let cardDetails = try CardDetailsBuilder().cvv("123")
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
        let expectedError: AccessCheckoutClientError = AccessCheckoutClientError.unknown(message: "an-error")
        let apiClient = SessionsApiClientMock(error: expectedError)
        let sessionHandler = PaymentsCvcRetrieveSessionHandler(apiClient: apiClient)
        let cardDetails = try CardDetailsBuilder().cvv("123")
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
