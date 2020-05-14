@testable import AccessCheckoutSDK
import Mockingjay
import PactConsumerSwift
import XCTest

class AccessCheckoutSDKtoSessionsPactTests: XCTestCase {
    let baseURI: String = Bundle(for: AccessCheckoutSDKtoSessionsPactTests.self).infoDictionary?["ACCESS_CHECKOUT_BASE_URI"] as? String ?? "http://pacttest"
    
    let requestHeaders: [String: Any] = ["Accept": ApiHeaders.sessionsHeaderValue, "content-type": ApiHeaders.sessionsHeaderValue]
    let responseHeaders: [String: Any] = ["Content-Type": ApiHeaders.sessionsHeaderValue]
    
    let sessionsMockService = MockService(provider: "sessions",
                                          consumer: "access-checkout-iOS-sdk")
    
    class DiscoveryMock: SessionsApiDiscovery {
        private var discoveredUrl: String
        
        init(discoveredUrl: String) {
            self.discoveredUrl = discoveredUrl
            super.init()
        }
        
        override func discover(baseUrl: String, completionHandler: @escaping (Swift.Result<String, AccessCheckoutClientError>) -> Void) {
            completionHandler(.success(discoveredUrl))
        }
    }
    
    func testServiceDiscoveryOnServiceRoot() {
        let expectedValue = "\(baseURI)/sessions/payments/cvc"
        let responseJson = [
            "_links": [
                "sessions:paymentsCvc": [
                    "href": Matcher.term(matcher: "https?://[^/]+/sessions/payments/cvc", generate: expectedValue)
                ]
            ]
        ]
        
        sessionsMockService
            .uponReceiving("a GET request to the service root")
            .withRequest(
                method: .GET,
                path: "/sessions",
                headers: requestHeaders)
            .willRespondWith(
                status: 200,
                headers: responseHeaders,
                body: responseJson)
        
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
        
        let discovery = SessionsApiDiscovery()
        
        sessionsMockService.run(timeout: 10) { testComplete in
            discovery.discover(baseUrl: "https://root") { result in
                switch result {
                case .success(let discoveredUrl):
                    XCTAssertEqual(discoveredUrl, expectedValue)
                case .failure:
                    XCTFail("Discovery should not have failed")
                }
                testComplete()
            }
        }
    }
    
    func testRequestCreatesTokenWithValidRequest() {
        let requestJson: [String: Any] = [
            "cvc": "1234",
            "identity": "identity"
        ]
        
        let expectedValue = "\(baseURI)/sessions/sessionURI"
        let responseJson = [
            "_links": [
                "sessions:session": [
                    "href": Matcher.term(matcher: "https?://[^/]+/sessions/.+", generate: expectedValue)
                ]
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
        
        let mockDiscovery = DiscoveryMock(discoveredUrl: "\(sessionsMockService.baseUrl)/sessions/payments/cvc")
        let sessionsClient = SessionsApiClient(discovery: mockDiscovery)
        
        sessionsMockService.run(timeout: 10) { testComplete in
            sessionsClient.createSession(baseUrl: "", merchantId: "identity", cvv: "1234") { result in
                switch result {
                case .success(let session):
                    XCTAssertEqual(session, expectedValue)
                case .failure(let error):
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
        let requestJson: [String: Any] = [
            "cvc": request.cvc,
            "identity": request.identity
        ]
        
        let responseJson: [String: Any] = [
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
        
        let mockDiscovery = DiscoveryMock(discoveredUrl: "\(sessionsMockService.baseUrl)/sessions/payments/cvc")
        let sessionsClient = SessionsApiClient(discovery: mockDiscovery)
        
        sessionsMockService.run(timeout: 10) { testComplete in
            sessionsClient.createSession(baseUrl: "", merchantId: request.identity, cvv: request.cvc) { result in
                switch result {
                case .success:
                    XCTFail("Service response expected to be unsuccessful")
                case .failure(let error):
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
