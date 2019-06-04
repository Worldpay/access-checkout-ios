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
        
        let stub = StubProvider.stub(forName: "VerifiedTokensSession-success",
                                     bundle: Bundle(for: type(of: self)))
        
        guard let data = stub?.data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            XCTFail()
            return
        }
        
        verifiedTokensMockService
            .given("a session is available")
            .uponReceiving("a request to create a session")
            .withRequest(method: .POST, path: "/verifiedTokens/sessions")
            .willRespondWith(status: 201,
                             headers: ["Content-Type": "application/json; charset=utf-8"],
                             body: json)
        
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
