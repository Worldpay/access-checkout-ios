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
        let expectationToFulfill = expectation(description: "session retrieved")
        let apiClient = VerifiedTokensApiClientMock(sessionToReturn: "expected-session")
        let sessionHandler = VerifiedTokensRetrieveSessionHandler(apiClient: apiClient)
        let cardDetails = CardDetails.builder().pan("pan")
            .expiryMonth("12")
            .expiryYear("20")
            .cvv("123")
            .build()
        
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
    
    func testReturnsErrorWhenApiCallErrorsOut() {
        let expectationToFulfill = expectation(description: "")
        let expectedError: AccessCheckoutClientError = AccessCheckoutClientError.unknown(message: "an-error")
        let apiClient = VerifiedTokensApiClientMock(error: expectedError)
        let sessionHandler = VerifiedTokensRetrieveSessionHandler(apiClient: apiClient)
        let cardDetails = CardDetails.builder().pan("pan")
            .expiryMonth("12")
            .expiryYear("20")
            .cvv("123")
            .build()

        sessionHandler.retrieveSession("a-merchant-id", "some-url", cardDetails) { result in
            switch result {
                case .success(_):
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
