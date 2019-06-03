import XCTest
import PactConsumerSwift
@testable import AccessCheckout

class PactTests: XCTestCase {

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
        
        let bundle = Bundle(for: type(of: self))
        guard let sessionUrl = bundle.url(forResource: "VerifiedTokensSession-success",
                                        withExtension: "json"),
            let sessionStubFormat = try? String(contentsOf: sessionUrl) else {
            XCTFail()
            return
        }
        let sessionStub = sessionStubFormat.replacingOccurrences(of: "<BASE_URI>", with: verifiedTokensMockService.baseUrl)
        
        guard let sessionData = sessionStub.data(using: .utf8),
            let sessionJson = try? JSONSerialization.jsonObject(with: sessionData, options: .allowFragments) else {
            XCTFail()
            return
        }
        
        verifiedTokensMockService
            .given("a session is available")
            .uponReceiving("a request to create a session")
            .withRequest(method: .POST, path: "/verifiedTokens/sessions")
            .willRespondWith(status: 201,
                             headers: ["Content-Type": "application/json; charset=utf-8"],
                             body: sessionJson)
        
        let mockDiscovery = MockDiscovery(baseURI: verifiedTokensMockService.baseUrl)
        let verifiedTokensClient = AccessCheckoutClient(discovery: mockDiscovery, merchantIdentifier: "identity")
        verifiedTokensMockService.run(timeout: 10) { testComplete in
            verifiedTokensClient.createSession(pan: "",
                                               expiryMonth: 0,
                                               expiryYear: 0,
                                               cvv: "",
                                               urlSession: URLSession.shared) { result in
                testComplete()
            }
        }
    }
}
