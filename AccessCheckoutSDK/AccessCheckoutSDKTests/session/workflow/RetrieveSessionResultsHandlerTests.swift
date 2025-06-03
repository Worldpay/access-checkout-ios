import XCTest

@testable import AccessCheckoutSDK

class RetrieveSessionResultsCollatorTests: XCTestCase {
    func testCompletesWithAllResultsWhenAllSuccessfulResultsReceived() {
        let expectationToFulfill = expectation(description: "")
        let cardSession: Result<String, AccessCheckoutError> = .success("card session")
        let paymentsCvcSession: Result<String, AccessCheckoutError> = .success("cvc session")
        let handler = RetrieveSessionResultsHandler(numberOfExpectedResults: 2) { result in
            switch result {
            case .success(let sessions):
                XCTAssertEqual(2, sessions.count)
                XCTAssertEqual("card session", sessions[.card])
                XCTAssertEqual("cvc session", sessions[.cvc])
            case .failure(let error):
                XCTFail("Expected successful result but got error \(error)")
            }

            expectationToFulfill.fulfill()
        }

        handler.handle(cardSession, for: SessionType.card)
        handler.handle(paymentsCvcSession, for: SessionType.cvc)

        wait(for: [expectationToFulfill], timeout: 1)
    }

    func testCompletesWithAnErrorWhenOneOfTheResultsIsAFailure() {
        let expectationToFulfill = expectation(description: "")
        let expectedError = StubUtils.createError(errorName: "an error", message: "a message")
        let cardSession: Result<String, AccessCheckoutError> = .success("card session")
        let paymentsCvcSession: Result<String, AccessCheckoutError> = .failure(expectedError)
        let handler = RetrieveSessionResultsHandler(numberOfExpectedResults: 2) { result in
            switch result {
            case .success:
                XCTFail("Expected a failure but got a success")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }

            expectationToFulfill.fulfill()
        }

        handler.handle(cardSession, for: SessionType.card)
        handler.handle(paymentsCvcSession, for: SessionType.cvc)

        wait(for: [expectationToFulfill], timeout: 1)
    }

    func testCompletesWithFirstErrorWhenAllResultsAreAFailure() {
        let expectationToFulfill = expectation(description: "")
        let expectedError = StubUtils.createError(errorName: "an error", message: "a message")
        let otherError = StubUtils.createError(
            errorName: "another error", message: "another message")
        let cardSession: Result<String, AccessCheckoutError> = .failure(expectedError)
        let paymentsCvcSession: Result<String, AccessCheckoutError> = .failure(otherError)
        let handler = RetrieveSessionResultsHandler(numberOfExpectedResults: 2) { result in
            switch result {
            case .success:
                XCTFail("Expected a failure but got a success")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }

            expectationToFulfill.fulfill()
        }

        handler.handle(cardSession, for: SessionType.card)
        handler.handle(paymentsCvcSession, for: SessionType.cvc)

        wait(for: [expectationToFulfill], timeout: 1)
    }
}
