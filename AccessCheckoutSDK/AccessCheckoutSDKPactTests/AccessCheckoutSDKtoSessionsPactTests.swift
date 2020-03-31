import XCTest
import PactConsumerSwift
import Mockingjay
@testable import AccessCheckoutSDK

class AccessCheckoutSDKtoSessionsPactTests: XCTestCase {

    let baseURI: String = Bundle(for: AccessCheckoutSDKtoSessionsPactTests.self).infoDictionary?["ACCESS_CHECKOUT_BASE_URI"] as? String ?? "http://access.worldpay.com"
    
    let requestHeaders:  [String: Any] = ["Accept": "application/vnd.worldpay.sessions-v1.hal+json", "content-type": "application/vnd.worldpay.sessions-v1.hal+json"]
    let responseHeaders: [String: Any] = ["Content-Type": "application/vnd.worldpay.sessions-v1.hal+json"]
    
    let sessionsMockService = MockService(provider: "sessions",
                                                consumer: "access-checkout-iOS-sdk")

    class MockDiscovery: Discovery {
        var serviceEndpoint: URL?
        
        /// Starts discovery of services
        let baseURI: String
        init(baseURI: String) {
            self.baseURI = baseURI
        }
        
        func discover(serviceLinks: DiscoverLinks, urlSession: URLSession, onComplete: (() -> Void)?){
            serviceEndpoint = URL(string: "\(baseURI)/sessions/payments/cvc")
            onComplete?()
        }
    }

    func testServiceDiscoveryOnServiceRoot(){
        
        let expectedValue = "\(baseURI)/sessions/payments/cvc"
        let responseJson = [
            "_links": [
                "sessions:paymentsCvc": [
                    "href": Matcher.term(matcher: "https?://[^/]+/sessions/payments/cvc", generate: expectedValue)
                ],
            ]
        ]

        sessionsMockService
            .uponReceiving("a GET request to the service root")
            .withRequest(
                method: .GET,
                path: "/sessions")
            .willRespondWith(
                status: 200,
                headers: responseHeaders,
                body: responseJson
        )
        
        let rootResponseJson = """
             {
                 "_links": {
                     "service:sessions": {
                         "href": "\(sessionsMockService.baseUrl)/sessions"
                     }
                 }
             }
             """
        
        let rootResponse = rootResponseJson.data(using: .utf8)!
        stub(http(.get, uri: "https://root"), jsonData(rootResponse))
        
        let discovery = AccessCheckoutDiscovery(baseUrl: URL(string: "https://root")!)
        let serviceEndpointKeys = DiscoverLinks.sessions
        
        
        sessionsMockService.run(timeout: 3) {testComplete in
            discovery.discover(serviceLinks: serviceEndpointKeys, urlSession: URLSession.shared) {
                XCTAssertEqual(discovery.serviceEndpoint?.absoluteString, expectedValue)
                testComplete();
            }
        }
    }

    func testRequestCreatesTokenWithValidRequest() {
        
        let requestJson : [String: Any] = [
            "cvc": "1234",
            "identity": "identity"
        ]
        
        let expectedValue = "\(baseURI)/sessions/sessionURI"
        let responseJson = [
            "_links": [
                "sessions:paymentsCvc": [
                    "href": Matcher.term(matcher: "https?://[^/]+/sessions/.+", generate: expectedValue)
                ],
            ]
        ]
        
        sessionsMockService
            .uponReceiving("a valid request to sessions")
            .withRequest(
                method: .POST,
                path: "/sessions/payments/cvc",
                headers: requestHeaders,
                body: requestJson)
            .willRespondWith(status: 201,
                             headers: responseHeaders,
                             body: responseJson)
        
        let mockDiscovery = MockDiscovery(baseURI: sessionsMockService.baseUrl)
        let sessionsClient = AccessCheckoutCVVOnlyClient(discovery: mockDiscovery, merchantIdentifier: "identity")
        
        sessionsMockService.run(timeout: 10) { testComplete in
            sessionsClient.createSession(cvv: "1234",
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
            cvc: "123")
        
        let expectedErrorResponse = ExpectedPactErrorResponse(
            mainErrorName: "bodyDoesNotMatchSchema",
            mainErrorMessage: "The json body provided does not match the expected schema",
            validationErrorName: "fieldHasInvalidValue",
            validationErrorMessage: "Identity is invalid",
            validationJsonPath: "$.identity")
        
        performTestCase(forScenario: "a request with an invalid identity to sessions", withRequest: request, andErrorResponse: expectedErrorResponse)
    }
    
    private struct PactRequest {
        let identity: String
        let cvc: String
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
            "identity": request.identity
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
        
        sessionsMockService
            .uponReceiving(scenario)
            .withRequest(method: .POST,
                         path: "/sessions/payments/cvc",
                         headers: requestHeaders,
                         body: requestJson)
            .willRespondWith(status: 400,
                             headers: responseHeaders,
                             body: responseJson)
        
        let mockDiscovery = MockDiscovery(baseURI: sessionsMockService.baseUrl)
        let sessionsClient = AccessCheckoutCVVOnlyClient(discovery: mockDiscovery, merchantIdentifier: request.identity)
        
        sessionsMockService.run(timeout: 10) { testComplete in
            sessionsClient.createSession(cvv: request.cvc,
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
