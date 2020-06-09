@testable import AccessCheckoutSDK
import XCTest

class RetrieveSessionResultsCollatorTests: XCTestCase {
    func testCompletesWithAllResultsWhenAllSuccessfulResultsReceived() {
        let expectationToFulfill = expectation(description: "")
        let verifiedTokensSession: Result<String, AccessCheckoutClientError> = .success("session verified tokens")
        let paymentsCvcSession: Result<String, AccessCheckoutClientError> = .success("session payments cvc")
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
        let expectedError = AccessCheckoutClientError.unknown(message: "an error")
        let verifiedTokensSession: Result<String, AccessCheckoutClientError> = .success("session verified tokens")
        let paymentsCvcSession: Result<String, AccessCheckoutClientError> = .failure(expectedError)
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
        let expectedError = AccessCheckoutClientError.unknown(message: "an error")
        let otherError = AccessCheckoutClientError.unknown(message: "another error")
        let verifiedTokensSession: Result<String, AccessCheckoutClientError> = .failure(expectedError)
        let paymentsCvcSession: Result<String, AccessCheckoutClientError> = .failure(otherError)
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
