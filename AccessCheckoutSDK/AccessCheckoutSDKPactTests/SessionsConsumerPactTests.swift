import PactConsumerSwift
import Swifter
import XCTest

@testable import AccessCheckoutSDK

class SessionsConsumerPactTests: XCTestCase {
    let baseURI: String =
        Bundle(for: SessionsConsumerPactTests.self).infoDictionary?["ACCESS_CHECKOUT_BASE_URI"]
        as? String ?? "http://pacttest"

    let requestHeaders: [String: Any] = [
        "Accept": ApiHeaders.sessionsHeaderValue, "content-type": ApiHeaders.sessionsHeaderValue,
    ]
    let responseHeaders: [String: Any] = ["Content-Type": ApiHeaders.sessionsHeaderValue]

    let pactServer = MockService(
        provider: "sessions",
        consumer: "access-checkout-iOS-sdk")

    func testDiscoveryOfSessionsEndPoints() {
        ServiceDiscoveryProvider.shared.clearCache()
        let accessRootStub = ServiceStubs().get200(
            path: "", jsonResponse: accessRootJsonResponse(sessionsBaseUrl: pactServer.baseUrl))
        accessRootStub.start()

        let expectedCardSessionsEndpoint = "\(pactServer.baseUrl)/sessions/card"
        let expectedCvcSessionsEndpoint = "\(pactServer.baseUrl)/sessions/payments/cvc"
        let responseJson = [
            "_links": [
                "sessions:card": [
                    "href": Matcher.term(
                        matcher: "https?://[^/]+/sessions/card",
                        generate: expectedCardSessionsEndpoint)
                ],
                "sessions:paymentsCvc": [
                    "href": Matcher.term(
                        matcher: "https?://[^/]+/sessions/payments/cvc",
                        generate: expectedCvcSessionsEndpoint)
                ],
            ]
        ]

        pactServer
            .uponReceiving("GET request to /sessions to discover sessions endpoints")
            .withRequest(
                method: .GET,
                path: "/sessions",
                headers: requestHeaders
            )
            .willRespondWith(
                status: 200,
                headers: responseHeaders,
                body: responseJson)

        pactServer.run(timeout: 10) { testComplete in
            ServiceDiscoveryProvider.discover(baseUrl: accessRootStub.baseUrl) { result in
                switch result {
                case .success():
                    XCTAssertEqual(
                        ServiceDiscoveryProvider.getSessionsCardEndpoint(),
                        expectedCardSessionsEndpoint)
                    XCTAssertEqual(
                        ServiceDiscoveryProvider.getSessionsCvcEndpoint(),
                        expectedCvcSessionsEndpoint)
                case .failure:
                    XCTFail("Discovery should not have failed")
                }
                testComplete()
            }
        }

        accessRootStub.stop()
    }

    // MARK: CVC session
    func testValidCvcSessionRequest_receivesCvcSession() {
        let serviceDiscoveryStub = stubServiceDiscovery()

        let requestJson: [String: Any] = [
            "cvc": "1234",
            "identity": "identity",
        ]

        let expectedValue = "\(pactServer.baseUrl)/sessions/sessionURI"
        let responseJson = [
            "_links": [
                "sessions:session": [
                    "href": Matcher.term(
                        matcher: "https?://[^/]+/sessions/.+", generate: expectedValue)
                ]
            ]
        ]

        pactServer
            .uponReceiving("POST request to /sessions/payments/cvc with valid body")
            .withRequest(
                method: .POST,
                path: "/sessions/payments/cvc",
                headers: requestHeaders,
                body: requestJson
            )
            .willRespondWith(
                status: 201,
                headers: responseHeaders,
                body: responseJson)

        let sessionsClient = CvcSessionsApiClient()

        pactServer.run(timeout: 10) { testComplete in
            sessionsClient.createSession(
                checkoutId: "identity", cvc: "1234"
            ) {
                result in
                switch result {
                case .success(let session):
                    XCTAssertEqual(session, expectedValue)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                testComplete()
            }
        }

        serviceDiscoveryStub?.stop()
    }

    func testCvcSessionRequestWithInvalidCheckoutId_receives400() {
        let serviceDiscoveryStub = stubServiceDiscovery()

        let request = PactCvcSessionRequest(
            identity: "incorrectValue",
            cvc: "123")

        let expectedErrorResponse = ExpectedPactErrorResponse(
            mainErrorName: "bodyDoesNotMatchSchema",
            mainErrorMessage: "The json body provided does not match the expected schema",
            validationErrorName: "fieldHasInvalidValue",
            validationErrorMessage: "Identity is invalid",
            validationJsonPath: "$.identity")

        performCvcSessionTestCase(
            forScenario: "POST request to /sessions/payments/cvc with invalid identity in body",
            withRequest: request, andErrorResponse: expectedErrorResponse)

        serviceDiscoveryStub?.stop()
    }

    // MARK: Card session
    func testValidCardSessionRequest_receivesCardSession() {
        let serviceDiscoveryStub = stubServiceDiscovery()

        let requestJson: [String: Any] = [
            "cvc": "123",
            "identity": "identity",
            "cardNumber": "4111111111111111",
            "cardExpiryDate": [
                "month": 12,
                "year": 2099,
            ],
        ]

        let expectedValue = "\(pactServer.baseUrl)/sessions/sampleSessionID"
        let responseJson = [
            "_links": [
                "sessions:session": [
                    "href": Matcher.term(
                        matcher: "https?://[^/]+/sessions/.+", generate: expectedValue)
                ]
            ]
        ]

        pactServer
            .uponReceiving("POST request to /sessions/card with valid body")
            .withRequest(
                method: .POST,
                path: "/sessions/card",
                headers: requestHeaders,
                body: requestJson
            )
            .willRespondWith(
                status: 201,
                headers: responseHeaders,
                body: responseJson)

        let cardSessionClient = CardSessionsApiClient()

        pactServer.run(timeout: 10) { testComplete in
            cardSessionClient.createSession(
                checkoutId: "identity", pan: "4111111111111111",
                expiryMonth: 12, expiryYear: 2099, cvc: "123"
            ) { result in
                switch result {
                case .success(let session):
                    XCTAssertEqual(session, expectedValue)
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
                testComplete()
            }
        }

        serviceDiscoveryStub?.stop()
    }

    func testCardSessionRequestWithInvalidCheckoutId_receives400() {
        let serviceDiscoveryStub = stubServiceDiscovery()

        let request = PactCardSessionRequest(
            identity: "incorrectValue",
            cvc: "123",
            cardNumber: "4111111111111111",
            expiryMonth: 12,
            expiryYear: 2099)

        let expectedErrorResponse = ExpectedPactErrorResponse(
            mainErrorName: "bodyDoesNotMatchSchema",
            mainErrorMessage: "The json body provided does not match the expected schema",
            validationErrorName: "fieldHasInvalidValue",
            validationErrorMessage: "Identity is invalid",
            validationJsonPath: "$.identity")

        performCardSessionTestCase(
            forScenario: "POST request to /sessions/card with invalid identity in body",
            withRequest: request, andErrorResponse: expectedErrorResponse)

        serviceDiscoveryStub?.stop()
    }

    func testCardSessionRequestWithCardNumberThatFailsLuhnCheck_receives400() {
        let serviceDiscoveryStub = stubServiceDiscovery()

        let request = PactCardSessionRequest(
            identity: "identity",
            cvc: "123",
            cardNumber: "4111111111111110",
            expiryMonth: 12,
            expiryYear: 2099)

        let expectedErrorResponse = ExpectedPactErrorResponse(
            mainErrorName: "bodyDoesNotMatchSchema",
            mainErrorMessage: "The json body provided does not match the expected schema",
            validationErrorName: "panFailedLuhnCheck",
            validationErrorMessage:
                "The identified field contains a PAN that has failed the Luhn check.",
            validationJsonPath: "$.cardNumber")

        performCardSessionTestCase(
            forScenario: "POST request to /sessions/card with PAN that does not pass Luhn check",
            withRequest: request, andErrorResponse: expectedErrorResponse)

        serviceDiscoveryStub?.stop()
    }

    func testCardSessionRequestWithInvalidMonthInExpiryDate_receives400() {
        let serviceDiscoveryStub = stubServiceDiscovery()

        let request = PactCardSessionRequest(
            identity: "identity",
            cvc: "123",
            cardNumber: "4111111111111111",
            expiryMonth: 13,
            expiryYear: 2099)

        let expectedErrorResponse = ExpectedPactErrorResponse(
            mainErrorName: "bodyDoesNotMatchSchema",
            mainErrorMessage: "The json body provided does not match the expected schema",
            validationErrorName: "integerIsTooLarge",
            validationErrorMessage: "Card expiry month is too large - must be between 1 & 12",
            validationJsonPath: "$.cardExpiryDate.month")

        performCardSessionTestCase(
            forScenario: "POST request to /sessions/card with expiry date month that is too large",
            withRequest: request, andErrorResponse: expectedErrorResponse)

        serviceDiscoveryStub?.stop()
    }

    func testCardSessionRequestWithCardNumberThatIsNotANumber_receives400() {
        let serviceDiscoveryStub = stubServiceDiscovery()

        let request = PactCardSessionRequest(
            identity: "identity",
            cvc: "123",
            cardNumber: "notACardNumber",
            expiryMonth: 1,
            expiryYear: 2099)

        let expectedErrorResponse = ExpectedPactErrorResponse(
            mainErrorName: "bodyDoesNotMatchSchema",
            mainErrorMessage: "The json body provided does not match the expected schema",
            validationErrorName: "fieldHasInvalidValue",
            validationErrorMessage: "Card number must be numeric",
            validationJsonPath: "$.cardNumber")

        performCardSessionTestCase(
            forScenario: "POST request to /sessions/card with PAN containing letters",
            withRequest: request, andErrorResponse: expectedErrorResponse)

        serviceDiscoveryStub?.stop()
    }

    private struct PactCardSessionRequest {
        let identity: String
        let cvc: String
        let cardNumber: String
        let expiryMonth: UInt
        let expiryYear: UInt
    }

    private func performCardSessionTestCase(
        forScenario scenario: String,
        withRequest request: PactCardSessionRequest,
        andErrorResponse response: ExpectedPactErrorResponse
    ) {
        let requestJson: [String: Any] = [
            "cvc": request.cvc,
            "identity": request.identity,
            "cardNumber": request.cardNumber,
            "cardExpiryDate": [
                "month": request.expiryMonth,
                "year": request.expiryYear,
            ],
        ]

        let responseJson: [String: Any] = [
            "errorName": response.mainErrorName,
            "message": Matcher.somethingLike(response.mainErrorMessage),
            "validationErrors": [
                [
                    "errorName": response.validationErrorName,
                    "message": Matcher.somethingLike(response.validationErrorMessage),
                    "jsonPath": response.validationJsonPath,
                ]
            ],
        ]

        pactServer
            .uponReceiving(scenario)
            .withRequest(
                method: .POST,
                path: "/sessions/card",
                headers: requestHeaders,
                body: requestJson
            )
            .willRespondWith(
                status: 400,
                headers: responseHeaders,
                body: responseJson)

        pactServer.run(timeout: 10) { testComplete in
            CardSessionsApiClient().createSession(
                checkoutId: request.identity, pan: request.cardNumber,
                expiryMonth: request.expiryMonth, expiryYear: request.expiryYear,
                cvc: request.cvc
            ) { result in
                switch result {
                case .success:
                    XCTFail("Service response expected to be unsuccessful")
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(
                        error.localizedDescription.contains(response.mainErrorName),
                        "Error msg must contain general error code")
                    XCTAssertTrue(
                        error.localizedDescription.contains(response.validationErrorName),
                        "Error msg must contain specific validation error code")
                    XCTAssertTrue(
                        error.localizedDescription.contains(response.validationJsonPath),
                        "Error msg must contain path to error value")
                }
                testComplete()
            }
        }
    }

    private struct PactCvcSessionRequest {
        let identity: String
        let cvc: String
    }

    private func performCvcSessionTestCase(
        forScenario scenario: String,
        withRequest request: PactCvcSessionRequest,
        andErrorResponse response: ExpectedPactErrorResponse
    ) {
        let requestJson: [String: Any] = [
            "cvc": request.cvc,
            "identity": request.identity,
        ]

        let responseJson: [String: Any] = [
            "errorName": response.mainErrorName,
            "message": Matcher.somethingLike(response.mainErrorMessage),
            "validationErrors": [
                [
                    "errorName": response.validationErrorName,
                    "message": Matcher.somethingLike(response.validationErrorMessage),
                    "jsonPath": response.validationJsonPath,
                ]
            ],
        ]

        pactServer
            .uponReceiving(scenario)
            .withRequest(
                method: .POST,
                path: "/sessions/payments/cvc",
                headers: requestHeaders,
                body: requestJson
            )
            .willRespondWith(
                status: 400,
                headers: responseHeaders,
                body: responseJson)

        pactServer.run(timeout: 10) { testComplete in
            CvcSessionsApiClient().createSession(
                checkoutId: request.identity, cvc: request.cvc
            ) { result in
                switch result {
                case .success:
                    XCTFail("Service response expected to be unsuccessful")
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(
                        error.localizedDescription.contains(response.mainErrorName),
                        "Error msg must contain general error code")
                    XCTAssertTrue(
                        error.localizedDescription.contains(response.validationErrorName),
                        "Error msg must contain specific validation error code")
                    XCTAssertTrue(
                        error.localizedDescription.contains(response.validationJsonPath),
                        "Error msg must contain path to error value")
                }
                testComplete()
            }
        }
    }

    private struct ExpectedPactErrorResponse {
        let mainErrorName: String
        let mainErrorMessage: String
        let validationErrorName: String
        let validationErrorMessage: String
        let validationJsonPath: String
    }

    private func stubServiceDiscovery() -> ServiceStubs? {
        let serviceStub = ServiceStubs()
        _ =
            serviceStub
            .get200(
                path: "", jsonResponse: accessRootJsonResponse(sessionsBaseUrl: serviceStub.baseUrl)
            )
            .get200(
                path: "/sessions",
                jsonResponse: sessionsRootJsonResponse(baseUrl: pactServer.baseUrl))
        serviceStub.start()

        ServiceDiscoveryProvider.shared.clearCache()
        ServiceDiscoveryProvider.discover(baseUrl: serviceStub.baseUrl) { _ in }

        let maxAttempts = 10
        var attempts = 0

        while attempts < maxAttempts {
            if ServiceDiscoveryProvider.getSessionsCardEndpoint() != nil
                && ServiceDiscoveryProvider.getSessionsCvcEndpoint() != nil
            {
                return serviceStub
            }
            Thread.sleep(forTimeInterval: 0.1)

            attempts += 1
        }

        NSLog("Failed to completed service discovery")
        return nil
    }

    private func accessRootJsonResponse(sessionsBaseUrl: String) -> String {
        return """
            {
                "_links": {
                    "service:sessions": {
                        "href": "\(sessionsBaseUrl)/sessions"
                    }
                }
            }
            """
    }

    private func sessionsRootJsonResponse(baseUrl: String) -> String {
        return """
            {
                "_links": { 
                    "sessions:card": {
                        "href": "\(baseUrl)/sessions/card"
                    },
                    "sessions:paymentsCvc": {
                        "href": "\(baseUrl)/sessions/payments/cvc"
                    }
                }
            }
            """
    }

    private func setUpSessionsDiscovery(
        forScenario scenario: String = "GET request to /sessions to discover sessions endpoints",
        cardSessionUrl: String? = nil,
        cvcSessionUrl: String? = nil
    ) {
        let cardUrl = cardSessionUrl ?? "\(pactServer.baseUrl)/sessions/card"
        let cvcUrl = cvcSessionUrl ?? "\(pactServer.baseUrl)/sessions/payments/cvc"

        let responseJson = [
            "_links": [
                "sessions:card": [
                    "href": Matcher.term(
                        matcher: "https?://[^/]+/sessions/card",
                        generate: cardUrl)
                ],
                "sessions:paymentsCvc": [
                    "href": Matcher.term(
                        matcher: "https?://[^/]+/sessions/payments/cvc",
                        generate: cvcUrl)
                ],
            ]
        ]

        pactServer
            .uponReceiving(scenario)
            .withRequest(
                method: .GET,
                path: "/sessions",
                headers: requestHeaders
            )
            .willRespondWith(
                status: 200,
                headers: responseHeaders,
                body: responseJson)
    }
}
