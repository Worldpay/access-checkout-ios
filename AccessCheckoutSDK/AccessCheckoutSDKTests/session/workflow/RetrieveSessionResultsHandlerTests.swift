@testable import AccessCheckoutSDK
import XCTest

class RetrieveSessionResultsCollatorTests: XCTestCase {
    func testCompletesWithAllResultsWhenAllSuccessfulResultsReceived() {
        let expectationToFulfill = expectation(description: "")
        let verifiedTokensSession: Result<String, AccessCheckoutError> = .success("session verified tokens")
        let paymentsCvcSession: Result<String, AccessCheckoutError> = .success("session payments cvc")
        let handler = RetrieveSessionResultsHandler(numberOfExpectedResults: 2) { result in
            switch result {
            case .success(let sessions):
                XCTAssertEqual(2, sessions.count)
                XCTAssertEqual("session verified tokens", sessions[.verifiedTokens])
                XCTAssertEqual("session payments cvc", sessions[.paymentsCvc])
            case .failure(let error):
                XCTFail("Expected successful result but got error \(error)")
            }
            
            expectationToFulfill.fulfill()
        }
        
        handler.handle(verifiedTokensSession, for: SessionType.verifiedTokens)
        handler.handle(paymentsCvcSession, for: SessionType.paymentsCvc)
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testCompletesWithAnErrorWhenOneOfTheResultsIsAFailure() {
        let expectationToFulfill = expectation(description: "")
        let expectedError = StubUtils.createError(errorName: "an error", message: "a message")
        let verifiedTokensSession: Result<String, AccessCheckoutError> = .success("session verified tokens")
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
        
        handler.handle(verifiedTokensSession, for: SessionType.verifiedTokens)
        handler.handle(paymentsCvcSession, for: SessionType.paymentsCvc)
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testCompletesWithFirstErrorWhenAllResultsAreAFailure() {
        let expectationToFulfill = expectation(description: "")
        let expectedError = StubUtils.createError(errorName: "an error", message: "a message")
        let otherError = StubUtils.createError(errorName: "another error", message: "another message")
        let verifiedTokensSession: Result<String, AccessCheckoutError> = .failure(expectedError)
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
        
        handler.handle(verifiedTokensSession, for: SessionType.verifiedTokens)
        handler.handle(paymentsCvcSession, for: SessionType.paymentsCvc)
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
}
