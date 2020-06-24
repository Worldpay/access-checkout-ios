@testable import AccessCheckoutSDK
import Mockingjay
import XCTest

class AccessCheckoutClientTests: XCTestCase {
    let baseUrl = "http://localhost"
    let verifiedTokensServicePath = "/verifiedTokens"
    let verifiedTokensServiceSessionsPath = "/verifiedTokens/sessions"
    let sessionsServicePath = "/sessions"
    let sessionsServicePaymentsCvcSessionPath = "/sessions/paymentsCvc"
    
    func testGeneratesAVerifiedTokensSession() throws {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient()
        let cardDetails = validCardDetails()
        
        stubServicesRootDiscoverySuccess()
        stubVerifiedTokensEndPointsDiscoverySuccess()
        stubVerifiedTokensSessionSuccess(session: "expected-verified-tokens-session")
        
        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.verifiedTokens]) { result in
            switch result {
                case .success(let sessions):
                    XCTAssertEqual("expected-verified-tokens-session", sessions[.verifiedTokens])
                case .failure:
                    XCTFail("got an error back from services")
            }
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testGeneratesAPaymentsCvcSession() throws {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient()
        let cardDetails = validCardDetails()
        
        stubServicesRootDiscoverySuccess()
        stubSessionsEndPointsDiscoverySuccess()
        stubSessionsPaymentsCvcSessionSuccess(session: "expected-payments-cvc-session")
        
        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.paymentsCvc]) { result in
            switch result {
                case .success(let sessions):
                    XCTAssertEqual("expected-payments-cvc-session", sessions[.paymentsCvc])
                case .failure:
                    XCTFail("got an error back from services")
            }
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testGeneratesAVerifiedTokensSessionAndAPaymentsCvcSession() throws {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient()
        let cardDetails = validCardDetails()
        
        stubServicesRootDiscoverySuccess()
        stubVerifiedTokensEndPointsDiscoverySuccess()
        stubVerifiedTokensSessionSuccess(session: "expected-verified-tokens-session")
        stubSessionsEndPointsDiscoverySuccess()
        stubSessionsPaymentsCvcSessionSuccess(session: "expected-payments-cvc-session")
        
        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.verifiedTokens, .paymentsCvc]) { result in
            switch result {
                case .success(let sessions):
                    XCTAssertEqual("expected-verified-tokens-session", sessions[.verifiedTokens])
                    XCTAssertEqual("expected-payments-cvc-session", sessions[.paymentsCvc])
                case .failure:
                    XCTFail("got an error back from services")
            }
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testSendsBackAnErrorWhenAttemptingToRetrieve2SessionsAndOneOfTheServicesResponsesWithAnError() throws {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient()
        let cardDetails = validCardDetails()
        let expectedError = StubUtils.createError(errorName: "unknown", message: "an error")
        
        stubServicesRootDiscoverySuccess()
        stubVerifiedTokensEndPointsDiscoverySuccess()
        stubVerifiedTokensSessionFailure(error: expectedError)
        stubSessionsEndPointsDiscoverySuccess()
        stubSessionsPaymentsCvcSessionSuccess(session: "expected-verified-tokens-session")
        
        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.verifiedTokens, .paymentsCvc]) { result in
            switch result {
                case .success:
                    XCTFail("Should have received an error but received sessions")
                case .failure(let error):
                    XCTAssertEqual(expectedError, error)
            }
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testSendsBackAnErrorWhenAttemptingToRetrieve2SessionsAndOneOfTheServicesIsNotReachable() throws {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient()
        let cardDetails = validCardDetails()
        let expectedError = StubUtils.createError(errorName: "unexpectedApiError", message: "Could not connect to the server.")
        
        stubServicesRootDiscoverySuccess()
        stubVerifiedTokensEndPointsDiscoverySuccess()
        stubVerifiedTokensSessionSuccess(session: "expected-verified-tokens-session")
        stubSessionsEndPointsDiscoverySuccess()
        // Payments Cvc Session end point is not stubbed to mimic the service not being reachable
        
        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.verifiedTokens, .paymentsCvc]) { result in
            switch result {
                case .success:
                    XCTFail("Should have received an error but received sessions")
                case .failure(let error):
                    XCTAssertEqual(expectedError, error)
            }
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testSendsBackAnErrorWhenAttemptingToRetrieve2SessionsAndAServiceDiscoveryResponsesWithAnError() throws {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient()
        let cardDetails = validCardDetails()
        let expectedError = StubUtils.createError(errorName: "unknown", message: "an error")
        
        stubServicesRootDiscoverySuccess()
        stubVerifiedTokensEndPointDiscoveryFailure(error: expectedError)
        stubVerifiedTokensSessionSuccess(session: "expected-verified-tokens-session")
        stubSessionsEndPointsDiscoverySuccess()
        stubSessionsPaymentsCvcSessionSuccess(session: "expected-payments-cvc-session")
        
        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.verifiedTokens, .paymentsCvc]) { result in
            switch result {
                case .success:
                    XCTFail("Should have received an error but received sessions")
                case .failure(let error):
                    XCTAssertEqual(expectedError, error)
            }
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testSendsBackAnErrorWhenAttemptingToRetrieve2SessionsAndBothServicesRespondWithAnError() throws {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient()
        let cardDetails = validCardDetails()
        let expectedError = StubUtils.createError(errorName: "unknown", message: "an error")
        
        stubServicesRootDiscoverySuccess()
        stubVerifiedTokensEndPointsDiscoverySuccess()
        stubVerifiedTokensSessionFailure(error: expectedError)
        stubSessionsEndPointsDiscoverySuccess()
        stubSessionsPaymentsCvcSessionFailure(error: expectedError)
        
        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.verifiedTokens, .paymentsCvc]) { result in
            switch result {
                case .success:
                    XCTFail("Should have received an error but received sessions")
                case .failure(let error):
                    XCTAssertEqual(expectedError, error)
            }
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testSendsBackAnErrorWhenAttemptingToRetrieve2SessionsAndAllDiscoveriesRespondWithAnError() throws {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient()
        let cardDetails = validCardDetails()
        let expectedError = StubUtils.createError(errorName: "unknown", message: "an error")
        
        stubServicesRootDiscoverySuccess()
        stubVerifiedTokensEndPointDiscoveryFailure(error: expectedError)
        stubVerifiedTokensSessionSuccess(session: "expected-verified-tokens-session")
        stubSessionsEndPointDiscoveryFailure(error: expectedError)
        stubSessionsPaymentsCvcSessionSuccess(session: "expected-payments-cvc-session")
        
        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.verifiedTokens, .paymentsCvc]) { result in
            switch result {
                case .success:
                    XCTFail("Should have received an error but received sessions")
                case .failure(let error):
                    XCTAssertEqual(expectedError, error)
            }
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testCanSendBackAnErrorWithValidationErrorDetails() throws {
        let validationError1 = StubUtils.createApiValidationError(errorName: "validation error 1", message: "error message 1", jsonPath: "field 1")
        let validationError2 = StubUtils.createApiValidationError(errorName: "validation error 2", message: "error message 2", jsonPath: "field 2")
        let expectedError = StubUtils.createApiError(errorName: "an error", message: "an error message", validationErrors: [validationError1, validationError2])
        
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient()
        let cardDetails = validCardDetails()
        
        stubServicesRootDiscoverySuccess()
        stubVerifiedTokensEndPointsDiscoverySuccess()
        stubVerifiedTokensSessionFailure(error: expectedError)
        stubSessionsEndPointsDiscoverySuccess()
        stubSessionsPaymentsCvcSessionSuccess(session: "expected-payments-cvc-session")
        
        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.verifiedTokens, .paymentsCvc]) { result in
            switch result {
                case .success:
                    XCTFail("Should have received an error but received sessions")
                case .failure(let error):
                    XCTAssertEqual("an error : an error message", error.message)
                    
                    XCTAssertEqual(2, error.validationErrors.count)
                    
                    XCTAssertEqual("validation error 1", error.validationErrors[0].errorName)
                    XCTAssertEqual("error message 1", error.validationErrors[0].message)
                    XCTAssertEqual("field 1", error.validationErrors[0].jsonPath)
                    
                    XCTAssertEqual("validation error 2", error.validationErrors[1].errorName)
                    XCTAssertEqual("error message 2", error.validationErrors[1].message)
                    XCTAssertEqual("field 2", error.validationErrors[1].jsonPath)
            }
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testDoesNotGenerateAnySessions_whenCardDetailsAreIncompleteForVerifiedTokensSession() throws {
        let expectedError = AccessCheckoutIllegalArgumentError(message: "Expected expiry date to be provided but was not")
        let client = createAccessCheckoutClient()
        let cardDetails = try CardDetailsBuilder().pan("pan")
            .cvc("123")
            .build()
        
        XCTAssertThrowsError(try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.paymentsCvc, .verifiedTokens]) { _ in }) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutIllegalArgumentError)
        }
    }
    
    func testDoesNotGenerateAnySessions_whenCardDetailsAreIncompleteForPaymentsCvcSession() throws {
        let expectedError = AccessCheckoutIllegalArgumentError(message: "Expected cvc to be provided but was not")
        let client = createAccessCheckoutClient()
        let cardDetails = try CardDetailsBuilder().build()
        
        XCTAssertThrowsError(try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.paymentsCvc]) { _ in }) { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutIllegalArgumentError)
        }
    }
    
    private func validCardDetails() -> CardDetails {
        return try! CardDetailsBuilder().pan("pan")
            .expiryDate("12/20")
            .cvc("123")
            .build()
    }
    
    private func createAccessCheckoutClient() -> AccessCheckoutClient {
        return try! AccessCheckoutClientBuilder().merchantId("a-merchant-id")
            .accessBaseUrl(baseUrl)
            .build()
    }
    
    private func stubServicesRootDiscoverySuccess() {
        stub(http(.get, uri: baseUrl), successfulDiscoveryResponse(baseUrl: baseUrl))
    }
    
    private func stubVerifiedTokensEndPointsDiscoverySuccess() {
        stub(http(.get, uri: "\(baseUrl)\(verifiedTokensServicePath)"), successfulDiscoveryResponse(baseUrl: baseUrl))
    }
    
    private func stubVerifiedTokensEndPointDiscoveryFailure(error: AccessCheckoutError) {
        stub(http(.get, uri: "\(baseUrl)\(verifiedTokensServicePath)"), failedResponse(error: error))
    }
    
    private func stubVerifiedTokensSessionSuccess(session: String) {
        stub(http(.post, uri: "\(baseUrl)\(verifiedTokensServiceSessionsPath)"), successfulVerifiedTokensSessionResponse(session: session))
    }
    
    private func stubVerifiedTokensSessionFailure(error: AccessCheckoutError) {
        stub(http(.post, uri: "\(baseUrl)\(verifiedTokensServiceSessionsPath)"), failedResponse(error: error))
    }
    
    private func stubSessionsEndPointsDiscoverySuccess() {
        stub(http(.get, uri: "\(baseUrl)\(sessionsServicePath)"), successfulDiscoveryResponse(baseUrl: baseUrl))
    }
    
    private func stubSessionsEndPointDiscoveryFailure(error: AccessCheckoutError) {
        stub(http(.get, uri: "\(baseUrl)\(sessionsServicePath)"), failedResponse(error: error))
    }
    
    private func stubSessionsPaymentsCvcSessionSuccess(session: String) {
        stub(http(.post, uri: "\(baseUrl)\(sessionsServicePaymentsCvcSessionPath)"), successfulPaymentsCvcSessionResponse(session: session))
    }
    
    private func stubSessionsPaymentsCvcSessionFailure(error: AccessCheckoutError) {
        stub(http(.post, uri: "\(baseUrl)\(sessionsServicePaymentsCvcSessionPath)"), failedResponse(error: error))
    }
    
    private func successfulDiscoveryResponse(baseUrl: String) -> (URLRequest) -> Response {
        return jsonData(toData("""
        {
            "_links": {
                "service:verifiedTokens": {
                    "href": "\(baseUrl)\(verifiedTokensServicePath)"
                },
                "verifiedTokens:sessions": {
                    "href": "\(baseUrl)\(verifiedTokensServiceSessionsPath)"
                },
                "service:sessions": {
                    "href": "\(baseUrl)\(sessionsServicePath)"
                },
                "sessions:paymentsCvc": {
                    "href": "\(baseUrl)\(sessionsServicePaymentsCvcSessionPath)"
                }
            }
        }
        """), status: 200)
    }
    
    private func successfulVerifiedTokensSessionResponse(session: String) -> (URLRequest) -> Response {
        return jsonData(toData("""
        {
            "_links": {
                "verifiedTokens:session": {
                    "href": "\(session)"
                }
            }
        }
        """), status: 201)
    }
    
    private func failedResponse(error: AccessCheckoutError) -> (URLRequest) -> Response {
        let errorAsData = try! JSONEncoder().encode(error)
        
        return jsonData(errorAsData, status: 400)
    }
    
    private func successfulPaymentsCvcSessionResponse(session: String) -> (URLRequest) -> Response {
        return jsonData(toData("""
        {
            "_links": {
                "sessions:session": {
                    "href": "\(session)"
                }
            }
        }
        """), status: 201)
    }
    
    private func toData(_ stringData: String) -> Data {
        return stringData.data(using: .utf8)!
    }
}
