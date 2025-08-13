import XCTest

@testable import AccessCheckoutSDK

class AccessCheckoutClientTests: XCTestCase {
    private var serviceStubs: ServiceStubs?

    override func setUp() {
        serviceStubs = ServiceStubs()
    }

    override func tearDown() {
        serviceStubs?.stop()
        ServiceDiscoveryProvider.shared.clearCache()
    }

    func testGeneratesACardSession() throws {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient(baseUrl: serviceStubs!.baseUrl)
        let cardDetails = validCardDetails()

        serviceStubs!.servicesRootDiscoverySuccess()
            .sessionsEndPointsDiscoverySuccess()
            .cardSessionSuccess(session: "expected-card-session")
            .start()

        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.card]) { result in
            switch result {
            case .success(let sessions):
                XCTAssertEqual("expected-card-session", sessions[.card])
            case .failure(let error):
                XCTFail(
                    "got an error back from services: \(String(describing: error.errorDescription))"
                )
            }
            expectationToFulfill.fulfill()
        }

        wait(for: [expectationToFulfill], timeout: 5)
    }

    func testGeneratesAPaymentsCvcSession() throws {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient(baseUrl: serviceStubs!.baseUrl)
        let cardDetails = validCardDetails()

        serviceStubs!.servicesRootDiscoverySuccess()
            .sessionsEndPointsDiscoverySuccess()
            .sessionsPaymentsCvcSessionSuccess(session: "expected-cvc-session")
            .start()

        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.cvc]) { result in
            switch result {
            case .success(let sessions):
                XCTAssertEqual("expected-cvc-session", sessions[.cvc])
            case .failure(let error):
                XCTFail(
                    "got an error back from services: \(String(describing: error.errorDescription))"
                )
            }
            expectationToFulfill.fulfill()
        }

        wait(for: [expectationToFulfill], timeout: 5)
    }

    func testGeneratesACardSessionAndACvcSession() throws {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient(baseUrl: serviceStubs!.baseUrl)
        let cardDetails = validCardDetails()

        serviceStubs!.servicesRootDiscoverySuccess()
            .sessionsEndPointsDiscoverySuccess()
            .cardSessionSuccess(session: "expected-card-session")
            .sessionsPaymentsCvcSessionSuccess(session: "expected-cvc-session")
            .start()

        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.card, .cvc]) {
            result in
            switch result {
            case .success(let sessions):
                XCTAssertEqual("expected-card-session", sessions[.card])
                XCTAssertEqual("expected-cvc-session", sessions[.cvc])
            case .failure(let error):
                XCTFail(
                    "got an error back from services: \(String(describing: error.errorDescription))"
                )
            }
            expectationToFulfill.fulfill()
        }

        wait(for: [expectationToFulfill], timeout: 5)
    }

    func
        testSendsBackAnErrorWhenAttemptingToRetrieve2SessionsAndOneOfTheServicesResponsesWithAnError()
        throws
    {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient(baseUrl: serviceStubs!.baseUrl)
        let cardDetails = validCardDetails()
        let expectedError = StubUtils.createError(errorName: "unknown", message: "an error")

        serviceStubs!.servicesRootDiscoverySuccess()
            .sessionsEndPointsDiscoverySuccess()
            .cardSessionFailure(error: expectedError)
            .sessionsPaymentsCvcSessionSuccess(session: "expected-card-session")
            .start()

        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.card, .cvc]) {
            result in
            switch result {
            case .success:
                XCTFail("Should have received an error but received sessions")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }
            expectationToFulfill.fulfill()
        }

        wait(for: [expectationToFulfill], timeout: 5)
    }

    func testSendsBackAnErrorWhenAttemptingToRetrieve2SessionsAndBothServicesRespondWithAnError()
        throws
    {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient(baseUrl: serviceStubs!.baseUrl)
        let cardDetails = validCardDetails()
        let expectedError = StubUtils.createError(errorName: "unknown", message: "an error")

        serviceStubs!.servicesRootDiscoverySuccess()
            .sessionsEndPointsDiscoverySuccess()
            .cardSessionFailure(error: expectedError)
            .sessionsPaymentsCvcSessionFailure(error: expectedError)
            .start()

        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.card, .cvc]) {
            result in
            switch result {
            case .success:
                XCTFail("Should have received an error but received sessions")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }
            expectationToFulfill.fulfill()
        }

        wait(for: [expectationToFulfill], timeout: 5)
    }

    func
        testSendsBackAnErrorWhenAttemptingToRetrieve2SessionsAndServiceDiscoveryRespondsWithAnError()
        throws
    {
        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient(baseUrl: serviceStubs!.baseUrl)
        let cardDetails = validCardDetails()
        let expectedError = StubUtils.createError(errorName: "unknown", message: "an error")

        serviceStubs!.servicesRootDiscoverySuccess()
            .sessionsEndPointDiscoveryFailure(error: expectedError)
            .cardSessionSuccess(session: "expected-card-session")
            .sessionsPaymentsCvcSessionSuccess(session: "expected-cvc-session")
            .start()

        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.card, .cvc]) {
            result in
            switch result {
            case .success:
                XCTFail("Should have received an error but received sessions")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }
            expectationToFulfill.fulfill()
        }

        wait(for: [expectationToFulfill], timeout: 5)
    }

    func testCanSendBackAnErrorWithValidationErrorDetails() throws {
        let validationError1 = StubUtils.createApiValidationError(
            errorName: "validation error 1", message: "error message 1", jsonPath: "field 1")
        let validationError2 = StubUtils.createApiValidationError(
            errorName: "validation error 2", message: "error message 2", jsonPath: "field 2")
        let expectedError = StubUtils.createApiError(
            errorName: "an error", message: "an error message",
            validationErrors: [validationError1, validationError2])

        let expectationToFulfill = expectation(description: "Session retrieved")
        let client = createAccessCheckoutClient(baseUrl: serviceStubs!.baseUrl)
        let cardDetails = validCardDetails()

        serviceStubs!.servicesRootDiscoverySuccess()
            .sessionsEndPointsDiscoverySuccess()
            .cardSessionFailure(error: expectedError)
            .sessionsPaymentsCvcSessionSuccess(session: "expected-cvc-session")
            .start()

        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.card, .cvc]) {
            result in
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

        wait(for: [expectationToFulfill], timeout: 5)
    }

    func testDoesNotGenerateAnySessions_whenCardDetailsAreIncompleteForCardSession() throws {
        let expectedMessage = "Expected expiry date to be provided but was not"
        let client = createAccessCheckoutClient(baseUrl: serviceStubs!.baseUrl)
        let cardDetails = try CardDetailsBuilder()
            .pan(UIUtils.createAccessCheckoutUITextField(withText: "pan"))
            .cvc(UIUtils.createAccessCheckoutUITextField(withText: "123"))
            .build()

        XCTAssertThrowsError(
            try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.cvc, .card]) {
                _ in
            }
        ) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testDoesNotGenerateAnySessions_whenCardDetailsAreIncompleteForPaymentsCvcSession() throws {
        let expectedMessage = "Expected cvc to be provided but was not"
        let client = createAccessCheckoutClient(baseUrl: serviceStubs!.baseUrl)
        let cardDetails = try CardDetailsBuilder().build()

        XCTAssertThrowsError(
            try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.cvc]) { _ in }
        ) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testShouldSendBackAnErrorWhenAnErrorOccursDuringDiscovery() throws {
        let expectationToFulfill = expectation(description: "Error successfully retrieved")
        let client = createAccessCheckoutClient(baseUrl: serviceStubs!.baseUrl)
        let expectedError = StubUtils.createError(errorName: "unknown", message: "an error message")
        let cardDetails = validCardDetails()

        serviceStubs!.servicesRootDiscoveryFailure(error: expectedError)
            .start()


        try client.generateSessions(cardDetails: cardDetails, sessionTypes: [.card, .cvc]) {
            result in
            switch result {
            case .success:
                XCTFail("Should have failed to discover services")
            case .failure(let error):
                XCTAssertEqual("unknown : an error message", error.message)
            }
            expectationToFulfill.fulfill()
        }

        wait(for: [expectationToFulfill], timeout: 5)
    }

    private func validCardDetails() -> CardDetails {
        return try! CardDetailsBuilder()
            .pan(UIUtils.createAccessCheckoutUITextField(withText: "pan"))
            .expiryDate(UIUtils.createAccessCheckoutUITextField(withText: "12/20"))
            .cvc(UIUtils.createAccessCheckoutUITextField(withText: "123"))
            .build()
    }

    private func createAccessCheckoutClient(baseUrl: String) -> AccessCheckoutClient {
        return try! AccessCheckoutClientBuilder().checkoutId("a-checkout-id")
            .accessBaseUrl(baseUrl)
            .build()
    }
}
