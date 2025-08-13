import PactConsumerSwift
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

    let sessionsMockService = MockService(
        provider: "sessions",
        consumer: "access-checkout-iOS-sdk")
    
    override func tearDown() {
        ServiceDiscoveryProvider.shared.clearCache()
    }
            

    // MARK: Service discovery
    
    func testCvcSessionEndPointServiceDiscovery() {
        let expectedCardSessionUrl = "\(baseURI)/sessions/card"
        let expectedPaymentsCvcSessionUrl = "\(baseURI)/sessions/payments/cvc"
        
        setUpSessionsDiscovery(forScenario: "GET request to /sessions to discover sessions endpoints - baseUri",
                               cardSessionUrl: expectedCardSessionUrl,
                               cvcSessionUrl: expectedPaymentsCvcSessionUrl)
        
        let service = startService()
        
        sessionsMockService.run(timeout: 10) { testComplete in
            ServiceDiscoveryProvider.discover(baseUrl: service.baseUrl) { result in
                switch result {
                case .success():
                    XCTAssertEqual(ServiceDiscoveryProvider.getSessionsCvcEndpoint(), expectedPaymentsCvcSessionUrl)
                case .failure:
                    XCTFail("Discovery should not have failed")
                }
                testComplete()
            }
        }
    }

    func testCardSessionEndPointServiceDiscovery() {
        let expectedCardSessionUrl = "\(baseURI)/sessions/card"
        let expectedPaymentsCvcSessionUrl = "\(baseURI)/sessions/payments/cvc"
        
        setUpSessionsDiscovery(forScenario: "GET request to /sessions to discover sessions endpoints - baseUri",
                               cardSessionUrl: expectedCardSessionUrl,
                               cvcSessionUrl: expectedPaymentsCvcSessionUrl)
        
        let service = startService()
        
        sessionsMockService.run(timeout: 10) { testComplete in
            ServiceDiscoveryProvider.discover(baseUrl: service.baseUrl) { result in
                switch result {
                case .success():
                    XCTAssertEqual(ServiceDiscoveryProvider.getSessionsCardEndpoint(), expectedCardSessionUrl)
                case .failure:
                    XCTFail("Discovery should not have failed")
                }
                testComplete()
            }
        }
    }

    // MARK: CVC session
    
    func testValidCvcSessionRequest_receivesCvcSession() {
        setUpSessionsDiscovery()
        
        let requestJson: [String: Any] = [
            "cvc": "1234",
            "identity": "identity",
        ]
        
        let expectedValue = "\(baseURI)/sessions/sessionURI"
        let sessionsJson = [
            "_links": [
                "sessions:session": [
                    "href": Matcher.term(
                        matcher: "https?://[^/]+/sessions/.+", generate: expectedValue)
                ]
            ]
        ]
        
        sessionsMockService
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
                body: sessionsJson)
        
        let sessionsClient = CvcSessionsApiClient()
        
        let service = startService()

        sessionsMockService.run(timeout: 10) { testComplete in
            ServiceDiscoveryProvider.discover(baseUrl: service.baseUrl) { result in
                switch result {
                case .success():
                    sessionsClient.createSession(baseUrl: "", checkoutId: "identity", cvc: "1234") {
                        result in
                        switch result {
                        case .success(let session):
                            XCTAssertEqual(session, expectedValue)
                        case .failure(let error):
                            XCTFail(error.localizedDescription)
                        }
                        testComplete()
                    }
                case .failure(let error):
                    XCTFail("Discovery should not have failed with error: \(error.localizedDescription)")
                }
                testComplete()
            }
        }
    }

    func testCvcSessionRequestWithInvalidCheckoutId_receives400() {
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
    }

    // MARK: Card session

    func testValidCardSessionRequest_receivesCardSession() {
        let requestJson: [String: Any] = [
            "cvc": "123",
            "identity": "identity",
            "cardNumber": "4111111111111111",
            "cardExpiryDate": [
                "month": 12,
                "year": 2099,
            ],
        ]

        let expectedValue = "\(baseURI)/sessions/sampleSessionID"
        let responseJson = [
            "_links": [
                "sessions:session": [
                    "href": Matcher.term(
                        matcher: "https?://[^/]+/sessions/.+", generate: expectedValue)
                ]
            ]
        ]

        sessionsMockService
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
        
        let service = startService()
        
        setUpSessionsDiscovery()

        let cardSessionClient = CardSessionsApiClient()

        sessionsMockService.run(timeout: 10) { testComplete in
            ServiceDiscoveryProvider.discover(baseUrl: service.baseUrl) { result in
                switch result {
                case .success():
                    cardSessionClient.createSession(
                        baseUrl: "", checkoutId: "identity", pan: "4111111111111111",
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
                case .failure(let error):
                    XCTFail("Discovery should not have failed with error: \(error.localizedDescription)")
                }
                testComplete()
            }
        }
    }

    func testCardSessionRequestWithInvalidCheckoutId_receives400() {
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
    }

    func testCardSessionRequestWithCardNumberThatFailsLuhnCheck_receives400() {
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
    }

    func testCardSessionRequestWithInvalidMonthInExpiryDate_receives400() {
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
    }

    func testCardSessionRequestWithCardNumberThatIsNotANumber_receives400() {
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
    }

    private struct PactCardSessionRequest {
        let identity: String
        let cvc: String
        let cardNumber: String
        let expiryMonth: UInt
        let expiryYear: UInt
    }

    private func performCardSessionTestCase(forScenario scenario: String,
                                            withRequest request: PactCardSessionRequest,
                                            andErrorResponse response: ExpectedPactErrorResponse) {
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

        sessionsMockService
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

        let service = startService()
        
        setUpSessionsDiscovery()

        let cardSessionClient = CardSessionsApiClient()

        sessionsMockService.run(timeout: 10) { testComplete in
            ServiceDiscoveryProvider.discover(baseUrl: service.baseUrl) { result in
                switch result {
                case .success():
                    cardSessionClient.createSession(
                        baseUrl: "", checkoutId: request.identity, pan: request.cardNumber,
                        expiryMonth: request.expiryMonth, expiryYear: request.expiryYear, cvc: request.cvc
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
                case .failure(let error):
                    XCTFail("Discovery should not have failed: \(error.localizedDescription)")
                    testComplete()
                }
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

        sessionsMockService
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
        
        let service = startService()

        setUpSessionsDiscovery()

        let sessionsClient = CvcSessionsApiClient()

        sessionsMockService.run(timeout: 10) { testComplete in
            ServiceDiscoveryProvider.discover(baseUrl: service.baseUrl) { result in
                switch result {
                case .success():
                    sessionsClient.createSession(
                        baseUrl: "", checkoutId: request.identity, cvc: request.cvc
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
                case .failure(let error):
                    XCTFail("Discovery should not have failed: \(error.localizedDescription)")
                    testComplete()
                }
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
    
    private func startService() -> ServiceStubs {
        let rootResponseJson = """
            {
                "_links": {
                    "service:sessions": {
                        "href": "\(sessionsMockService.baseUrl)/sessions"
                    }
                }
            }
            """
        let serviceStubs = ServiceStubs().get200(path: "", jsonResponse: rootResponseJson)
        serviceStubs.start()
        return serviceStubs
    }
    
    private func setUpSessionsDiscovery(forScenario scenario: String="GET request to /sessions to discover sessions endpoints",
                                        cardSessionUrl: String? = nil,
                                        cvcSessionUrl: String? = nil) {
        let cardUrl = cardSessionUrl ?? "\(sessionsMockService.baseUrl)/sessions/card"
        let cvcUrl = cvcSessionUrl ?? "\(sessionsMockService.baseUrl)/sessions/payments/cvc"
        
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
        
        sessionsMockService
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
