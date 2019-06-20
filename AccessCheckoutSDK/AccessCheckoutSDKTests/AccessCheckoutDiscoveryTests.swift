import XCTest
import Mockingjay
@testable import AccessCheckoutSDK

class AccessCheckoutDiscoveryTests: XCTestCase {
    
    enum StubError: Error {
        case test
    }
    let accessRootURI = "https://access.worldpay.com"
    let accessRootResponseJson = """
        {
            "_links": {
                "payments:authorize": {
                    "href": "https://access.worldpay.com/payments/authorizations"
                },
                "service:payments": {
                    "href": "https://access.worldpay.com/payments"
                },
                "service:tokens": {
                    "href": "https://access.worldpay.com/tokens"
                },
                "service:verifiedTokens": {
                    "href": "https://access.worldpay.com/verifiedTokens"
                },
                "curies": [
                    {
                        "href": "https://access.worldpay.com/rels/payments/{rel}",
                        "name": "payments",
                        "templated": true
                    }
                ]
            }
        }
        """

    let vtsRootURI = "https://access.worldpay.com/verifiedTokens"
    let vtsRootResponseJson = """
        {
            "_links": {
                "verifiedTokens:recurring": {
                    "href": "https://access.worldpay.com/verifiedTokens/recurring"
                },
                "verifiedTokens:cardOnFile": {
                    "href": "https://access.worldpay.com/verifiedTokens/cardOnFile"
                },
                "verifiedTokens:sessions": {
                    "href": "https://access.worldpay.com/verifiedTokens/sessions"
                },
                "resourceTree": {
                    "href": "https://access.worldpay.com/rels/verifiedTokens/resourceTree.json"
                },
                "curies": [
                    {
                        "href": "https://access.worldpay.com/rels/verifiedTokens/{rel}.json",
                        "name": "verifiedTokens",
                        "templated": true
                    }
                ]
            }
        }
        """
    
    let destinationURI = "https://access.worldpay.com/verifiedTokens/sessions"

    class MockDiscovery: Discovery {
        var verifiedTokensSessionEndpoint: URL?
        var discoverCalls = 0
        func discover(urlSession: URLSession, onComplete: (() -> Void)?) {
            self.discoverCalls += 1
            onComplete?()
        }
    }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        removeAllStubs()
    }
    
    func testAccessRootResponse_canBeDecodedAndEncoded() {
        // Given
        let stubData = accessRootResponseJson.data(using: .utf8)!
        
        // Then
        verifyCanDecodeAndEncode(stubData)
    }

    func testVtsRootResponse_canBeDecodedAndEncoded() {
        // Given
        let stubData = vtsRootResponseJson.data(using: .utf8)!
        
        // Then
        verifyCanDecodeAndEncode(stubData)
    }
    
    func testDiscovery_returnsRightValue() {
        // Given
        givenFirstCallReturns(accessRootResponseJson)
        givenSecondCallReturns(vtsRootResponseJson)

        // Then
        discoveryFindsTheRightURL()
    }
    
    func testDiscovery_firstRequestReturnsError() {
        // Given
        stub(http(.get, uri: accessRootURI), failure(StubError.test as NSError))
        
        // Then
        discoveryReturnsNil()
    }
    
    func testDiscovery_secondRequestReturnsError() {
        // Given
        givenFirstCallReturns(accessRootResponseJson)
        stub(http(.get, uri: vtsRootURI), failure(StubError.test as NSError))

        // Then
        discoveryReturnsNil()
    }
    
    func testDiscovery_firstRequestReturnsInvalidJson() {
        // Given
        givenFirstCallReturns("invalidJson")
        givenSecondCallReturns(vtsRootResponseJson)

        // Then
        discoveryReturnsNil()
    }
    
    func testDiscovery_secondRequestReturnsInvalidJson() {
        // Given
        givenFirstCallReturns(accessRootResponseJson)
        givenSecondCallReturns("invalidJson")
        
        // Then
        discoveryReturnsNil()
    }
    
    func testDiscovery_linkNotFoundInFirstRequest() {
        // Given
        givenFirstCallReturns(vtsRootResponseJson)
        givenSecondCallReturns(vtsRootResponseJson)
        
        // Then
        discoveryReturnsNil()
    }
    
    func testDiscovery_linkNotFoundInSecondRequest() {
        // Given
        givenFirstCallReturns(accessRootResponseJson)
        givenSecondCallReturns(accessRootResponseJson)
        
        // Then
        discoveryReturnsNil()
    }

    func testDiscoveryFail_retryOnVTS() {
        
        let mockDiscovery = MockDiscovery()
        
        stub(http(.get, uri: accessRootURI), failure(StubError.test as NSError))
        
        let tokenExpectation = expectation(description: "token")
        
        let session = URLSession.shared
        
        // Stub discovery with error
        mockDiscovery.discover(urlSession: session) {
            XCTAssertEqual(mockDiscovery.discoverCalls, 1)
            let client = AccessCheckoutClient(discovery: mockDiscovery, merchantIdentifier: "")
            client.createSession(pan: "1234",
                              expiryMonth: 1,
                              expiryYear: 0,
                              cvv: "123",
                              urlSession: session) { result in
                                XCTAssertEqual(mockDiscovery.discoverCalls, 2)
                                tokenExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    private func verifyCanDecodeAndEncode(_ stubData: Data) {
        do {
            let accessCheckoutResponse1 = try JSONDecoder().decode(AccessCheckoutResponse.self, from: stubData)
            let encodedData = try JSONEncoder().encode(accessCheckoutResponse1)
            let accessCheckoutResponse2 = try JSONDecoder().decode(AccessCheckoutResponse.self, from: encodedData)
            XCTAssertEqual(accessCheckoutResponse1.links.endpoints.count, accessCheckoutResponse2.links.endpoints.count)
            XCTAssertEqual(accessCheckoutResponse1.links.curies?.count, accessCheckoutResponse2.links.curies?.count)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    private func givenFirstCallReturns(_ response: String) {
        let accessRootResponse = response.data(using: .utf8)!
        stub(http(.get, uri: accessRootURI), jsonData(accessRootResponse))
    }
    
    private func givenSecondCallReturns(_ response: String) {
        let vtsRootResponse = response.data(using: .utf8)!
        stub(http(.get, uri: vtsRootURI), jsonData(vtsRootResponse))
    }
    
    private func discoveryReturnsNil() {
        let discovery = AccessCheckoutDiscovery(baseUrl: URL(string: accessRootURI)!)
        let testExpectation = expectation(description: "failure")
        discovery.discover(urlSession: URLSession.shared) {
            XCTAssertNil(discovery.verifiedTokensSessionEndpoint)
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    private func discoveryFindsTheRightURL() {
        let discovery = AccessCheckoutDiscovery(baseUrl: URL(string: accessRootURI)!)
        
        let testExpectation = expectation(description: "discovery")
        discovery.discover(urlSession: URLSession.shared) {
            XCTAssertEqual(discovery.verifiedTokensSessionEndpoint, URL(string: self.destinationURI))
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
