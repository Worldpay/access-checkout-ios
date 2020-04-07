import XCTest
import PactConsumerSwift
import Mockingjay
@testable import AccessCheckoutSDK

class AccessCheckoutSDKtoVTPactTests: XCTestCase {

    let baseURI: String = Bundle(for: AccessCheckoutSDKtoVTPactTests.self).infoDictionary?["ACCESS_CHECKOUT_BASE_URI"] as? String ?? "http://pacttest"
    
    let requestHeaders:  [String: Any] = ["content-type": ApiHeaders.verifiedTokensHeaderValue]
    let responseHeaders: [String: Any] = ["Content-Type": ApiHeaders.verifiedTokensHeaderValue]
    
    let verifiedTokensMockService = MockService(provider: "verified-tokens",
                                                consumer: "access-checkout-iOS-sdk")

    class MockDiscovery: Discovery {
        var serviceEndpoint: URL?
        
        /// Starts discovery of services
        let baseURI: String
        init(baseURI: String) {
            self.baseURI = baseURI
        }
        
        func discover(serviceLinks: ApiLinks, urlSession: URLSession, onComplete: (() -> Void)?){
            serviceEndpoint = URL(string: "\(baseURI)/verifiedTokens/sessions")
            onComplete?()
        }
    }

func testServiceDiscoveryOnServiceRoot(){
        
        let expectedValue = "\(baseURI)/verifiedTokens/sessions"
        let responseJson = [
            "_links": [
                "verifiedTokens:sessions": [
                    "href": Matcher.term(matcher: "https?://[^/]+/verifiedTokens/sessions", generate: expectedValue)
                ],
            ]
        ]

        verifiedTokensMockService
            .uponReceiving("a GET request to the VT service root")
            .withRequest(
                method: .GET,
                path: "/verifiedTokens")
            .willRespondWith(
                status: 200,
                headers: responseHeaders,
                body: responseJson
        )
        
        let rootResponseJson = """
             {
                 "_links": {
                     "service:verifiedTokens": {
                         "href": "\(verifiedTokensMockService.baseUrl)/verifiedTokens"
                     }
                 }
             }
             """
        
        let rootResponse = rootResponseJson.data(using: .utf8)!
        stub(http(.get, uri: "https://root"), jsonData(rootResponse))
        
        let discovery = AccessCheckoutDiscovery(baseUrl: URL(string: "https://root")!)
        let serviceEndpointKeys = ApiLinks.verifiedTokens
        
        
        verifiedTokensMockService.run(timeout: 3) {testComplete in
            discovery.discover(serviceLinks: serviceEndpointKeys, urlSession: URLSession.shared) {
                XCTAssertEqual(discovery.serviceEndpoint?.absoluteString, expectedValue)
                testComplete();
            }
        }
    }

    func testRequestCreatesTokenWithValidRequest() {
        
        let requestJson : [String: Any] = [
            "cvc": "123",
            "identity": "identity",
            "cardNumber": "4111111111111111",
            "cardExpiryDate": [
                "month": 12,
                "year": 2099
            ]
        ]
        
        let expectedValue = "\(baseURI)/verifiedTokens/sessions/sampleSessionID"
        let responseJson = [
            "_links": [
                "verifiedTokens:session": [
                    "href": Matcher.term(matcher: "https?://[^/]+/verifiedTokens/sessions/.+", generate: expectedValue)
                ],
            ]
        ]
        
        verifiedTokensMockService
            .uponReceiving("a valid request to VT")
            .withRequest(
                method: .POST,
                path: "/verifiedTokens/sessions",
                headers: requestHeaders,
                body: requestJson)
            .willRespondWith(status: 201,
                             headers: responseHeaders,
                             body: responseJson)
        
        let mockDiscovery = MockDiscovery(baseURI: verifiedTokensMockService.baseUrl)
        let verifiedTokensClient = AccessCheckoutClient(discovery: mockDiscovery, merchantIdentifier: "identity")
        
        verifiedTokensMockService.run(timeout: 10) { testComplete in
            verifiedTokensClient.createSession(pan: "4111111111111111",
                                               expiryMonth: 12,
                                               expiryYear: 2099,
                                               cvv: "123",
                                               urlSession: URLSession.shared) { result in
                                                switch result {
                                                case let .success(sessionState):
                                                    XCTAssertEqual(sessionState, expectedValue)
                                                case let .failure(error):
                                                    XCTFail(error.localizedDescription)
                                                }
                                                testComplete()
            }
        }
    }
    
    func testRequestFailsWhenAnIncorrectMerchantIdIsProvided() {
        
        let request = PactRequest(
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
        
        performTestCase(forScenario: "a request with an invalid identity to VT", withRequest: request, andErrorResponse: expectedErrorResponse)
    }
    
    func testRequestFailsWhenCardNumberFailsLuhnCheck() {
        
        let request = PactRequest(
            identity: "identity",
            cvc: "123",
            cardNumber: "4111111111111110",
            expiryMonth: 12,
            expiryYear: 2099)
        
        let expectedErrorResponse = ExpectedPactErrorResponse(
            mainErrorName: "bodyDoesNotMatchSchema",
            mainErrorMessage: "The json body provided does not match the expected schema",
            validationErrorName: "panFailedLuhnCheck",
            validationErrorMessage: "The identified field contains a PAN that has failed the Luhn check.",
            validationJsonPath: "$.cardNumber")
        
        performTestCase(forScenario: "a request with a PAN that does not pass Luhn check", withRequest: request, andErrorResponse: expectedErrorResponse)
    }
    
    func testRequestFailsWhenMonthIsSetToThirteen() {
        
        let request = PactRequest(
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
        
        performTestCase(forScenario: "a request with a month number that is too large", withRequest: request, andErrorResponse: expectedErrorResponse)
    }
    
    func testRequestFailsWhenPANHasLetters() {
        
        let request = PactRequest(
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
        
        performTestCase(forScenario: "a request with a PAN containing letters", withRequest: request, andErrorResponse: expectedErrorResponse)
    }
    
    private struct PactRequest {
        let identity: String
        let cvc: String
        let cardNumber: String
        let expiryMonth: UInt
        let expiryYear: UInt
    }
    
    private struct ExpectedPactErrorResponse {
        let mainErrorName: String
        let mainErrorMessage: String
        let validationErrorName: String
        let validationErrorMessage: String
        let validationJsonPath: String
    }
    
    private func performTestCase(
        forScenario scenario: String,
        withRequest request: PactRequest,
        andErrorResponse response: ExpectedPactErrorResponse) {
        
        let requestJson : [String: Any] = [
            "cvc": request.cvc,
            "identity": request.identity,
            "cardNumber": request.cardNumber,
            "cardExpiryDate": [
                "month": request.expiryMonth,
                "year": request.expiryYear
            ]
        ]
        
        let responseJson : [String : Any] = [
            "errorName": response.mainErrorName,
            "message": Matcher.somethingLike(response.mainErrorMessage),
            "validationErrors": [
                [
                    "errorName": response.validationErrorName,
                    "message": Matcher.somethingLike(response.validationErrorMessage),
                    "jsonPath": response.validationJsonPath
                ]
            ]
        ]
        
        verifiedTokensMockService
            .uponReceiving(scenario)
            .withRequest(method: .POST,
                         path: "/verifiedTokens/sessions",
                         headers: requestHeaders,
                         body: requestJson)
            .willRespondWith(status: 400,
                             headers: responseHeaders,
                             body: responseJson)
        
        let mockDiscovery = MockDiscovery(baseURI: verifiedTokensMockService.baseUrl)
        let verifiedTokensClient = AccessCheckoutClient(discovery: mockDiscovery, merchantIdentifier: request.identity)
        
        verifiedTokensMockService.run(timeout: 10) { testComplete in
            verifiedTokensClient.createSession(pan: request.cardNumber,
                                               expiryMonth: request.expiryMonth,
                                               expiryYear: request.expiryYear,
                                               cvv: request.cvc,
                                               urlSession: URLSession.shared) { result in
                                                switch result {
                                                case .success(_):
                                                    XCTFail("Service response expected to be unsuccessful")
                                                case let .failure(error):
                                                    print(error)
                                                    XCTAssertTrue(error.localizedDescription.contains(response.mainErrorName), "Error msg must contain general error code")
                                                    XCTAssertTrue(error.localizedDescription.contains(response.validationErrorName), "Error msg must contain specific validation error code")
                                                    XCTAssertTrue(error.localizedDescription.contains(response.validationJsonPath), "Error msg must contain path to error value")
                                                }
                                                testComplete()
            }
        }
    }
}
