import XCTest
import PactConsumerSwift
@testable import AccessCheckout

class PactTests: XCTestCase {

    let baseURI: String = Bundle(for: PactTests.self).infoDictionary?["ACCESS_CHECKOUT_BASE_URI"] as? String ?? "https://access.worldpay.com"
    
    let verifiedTokensMockService = MockService(provider: "verified-tokens",
                                                consumer: "access-checkout-iOS-sdk")
    
    class MockDiscovery: Discovery {
        var verifiedTokensSessionEndpoint: URL?
        let baseURI: String
        init(baseURI: String) {
            self.baseURI = baseURI
        }
        func discover(urlSession: URLSession, onComplete: (() -> Void)?) {
            verifiedTokensSessionEndpoint = URL(string: "\(baseURI)/verifiedTokens/sessions")
            onComplete?()
        }
    }

    func testCreateSession() {
        
        let requestJson : [String: Any] = [
            "cvc": "123",
            "identity": "identity",
            "cardNumber": "4111111111111111",
            "cardExpiryDate": [
                "month": 12,
                "year": 2099
            ]
        ]

        let expectedValue = "\(baseURI)/verifiedTokens/sessions"
        let responseJson = [
            "_links": [
                "verifiedTokens:session": [
                    "href": Matcher.term(matcher: "https?://[^/]+/verifiedTokens/sessions", generate: expectedValue)
                ],
            ]
        ]
        
        verifiedTokensMockService
            .given("a session is available")
            .uponReceiving("a request to create a session")
            .withRequest(method: .POST, path: "/verifiedTokens/sessions", body: requestJson)
            .willRespondWith(status: 201,
                             headers: ["Content-Type": "application/vnd.worldpay.verified-tokens-v1.hal+json;charset=UTF-8"],
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
    
    func testProvideIncorrectMerchantId() {
        
        let requestJson : [String: Any] = [
            "cvc": "123",
            "identity": "incorrectValue",
            "cardNumber": "4111111111111111",
            "cardExpiryDate": [
                "month": 12,
                "year": 2099
            ]
        ]
        
        let responseJson : [String : Any] = [
            "errorName": "bodyDoesNotMatchSchema",
            "validationErrors": [
                [
                "errorName": "fieldHasInvalidValue",
                "jsonPath": "$.identity"
                ]
            ]
        ]

        verifiedTokensMockService
            .given("the service returns an error; variation 1")
            .uponReceiving("a request to create a session")
            .withRequest(method: .POST,
                         path: "/verifiedTokens/sessions",
                         headers: [:],
                         body: requestJson)
            .willRespondWith(status: 400,
                             headers: ["Content-Type": "application/vnd.worldpay.verified-tokens-v1.hal+json;charset=UTF-8"],
                             body: responseJson)
        
        let mockDiscovery = MockDiscovery(baseURI: verifiedTokensMockService.baseUrl)
        let verifiedTokensClient = AccessCheckoutClient(discovery: mockDiscovery, merchantIdentifier: "incorrectValue")
        
        verifiedTokensMockService.run(timeout: 10) { testComplete in
            verifiedTokensClient.createSession(pan: "4111111111111111",
                                               expiryMonth: 12,
                                               expiryYear: 2099,
                                               cvv: "123",
                                               urlSession: URLSession.shared) { result in
                switch result {
                case .success(_):
                    XCTFail("Service response expected to be unsuccessful")
                case let .failure(error):
                    XCTAssertTrue(error.localizedDescription.contains("bodyDoesNotMatchSchema"), "Error msg must contain general error code")
                    XCTAssertTrue(error.localizedDescription.contains("fieldHasInvalidValue"), "Error msg must contain specific validation error code")
                    XCTAssertTrue(error.localizedDescription.contains("$.identity"), "Error msg must contain path to error value")
                }
                testComplete()
            }
        }
    }
}
