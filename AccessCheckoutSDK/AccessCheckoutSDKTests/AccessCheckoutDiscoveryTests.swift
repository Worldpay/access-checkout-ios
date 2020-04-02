import XCTest
import Mockingjay
@testable import AccessCheckoutSDK

class AccessCheckoutDiscoveryTests: XCTestCase {
    
    enum StubError: Error {
        case test
    }
    let rootURI = "https://root"
    let rootResponseJson = """
        {
            "_links": {
                "service:service1": {
                    "href": "https://root/service1"
                },
                "service:service2": {
                    "href": "https://root/service2"
                }
            }
        }
        """

    let serviceURI = "https://root/service1"
    let serviceResponseJson = """
        {
            "_links": {
                  "service1:endpoint": {
                    "href": "https://root/service1/endpoint"
                  }
                
            }
        }
        """
    
    let destinationURI = "https://root/service1/endpoint"
    let serviceEndpointKeys = DiscoverLinks(service: "service:service1", endpoint: "service1:endpoint", result: "service1:result")

    class MockDiscovery: Discovery {
        
        var serviceEndpoint: URL?
        var discoverCalls = 0
        func discover(serviceLinks: DiscoverLinks, urlSession: URLSession, onComplete: (() -> Void)?) {
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
    
    func testRootResponse_canBeDecodedAndEncoded() {
        // Given
        let stubData = rootResponseJson.data(using: .utf8)!
        
        // Then
        verifyCanDecodeAndEncode(stubData)
    }

    func testServiceResponse_canBeDecodedAndEncoded() {
        // Given
        let stubData = serviceResponseJson.data(using: .utf8)!
        
        // Then
        verifyCanDecodeAndEncode(stubData)
    }

    func testDiscovery_returnsServiceEndpoint() {
        // Given
        givenFirstCallReturns(rootResponseJson)
        givenSecondCallReturns(to: serviceURI, serviceResponseJson)

        // Then
        discoveryFindsServiceEndpoint()
    }
    
    func testDiscovery_firstRequestReturnsError() {
        // Given
        stub(http(.get, uri: rootURI), failure(StubError.test as NSError))

        // Then
        discoveryReturnsNil()
    }

    func testDiscovery_secondRequestReturnsError() {
        // Given
        givenFirstCallReturns(rootResponseJson)
        stub(http(.get, uri: serviceURI), failure(StubError.test as NSError))

        // Then
        discoveryReturnsNil()
    }
    
    func testDiscovery_firstRequestReturnsInvalidJson() {
        // Given
        let invalidRootResponseJson = """
        {
            "_links": {
                "service:service999": {
                    "href": "https://root/service999"
                }
            }
        }
        """
        givenFirstCallReturns(invalidRootResponseJson)
        givenSecondCallReturns(to: serviceURI, serviceResponseJson)

        // Then
        discoveryReturnsNil()
    }
    
    func testDiscovery_secondRequestReturnsInvalidJson() {
        // Given
        let invalidServiceResponseJson = """
        {
            "_links": {
                "service:unknownLink": {
                    "href": "somewhere.com"
                }
            }
        }
        """
        givenFirstCallReturns(rootResponseJson)
        givenSecondCallReturns(to: serviceURI, invalidServiceResponseJson)

        // Then
        discoveryReturnsNil()
    }

    func testDiscovery_linkNotFoundInFirstRequest() {
        // Given
        let missingRootResponseJson = """
        {
            "_links": {
                "service:service1": {
                    "href": ""
                }
            }
        }
        """
        givenFirstCallReturns(missingRootResponseJson)
        givenSecondCallReturns(to: serviceURI, serviceResponseJson)

        // Then
        discoveryReturnsNil()
    }

    func testDiscovery_linkNotFoundInSecondRequest() {
        // Given
        let missingServiceResponseJson = """
        {
            "_links": {
                "service1:endpoint": {
                    "href": ""
                }
            }
        }
        """
        givenFirstCallReturns(rootResponseJson)
        givenSecondCallReturns(to: serviceURI, missingServiceResponseJson)

        // Then
        discoveryReturnsNil()
    }

    func testDiscoveryFails_retryOnSubmit() {
        
        let mockDiscovery = MockDiscovery()
        
        stub(http(.get, uri: rootURI), failure(StubError.test as NSError))
        
        let tokenExpectation = expectation(description: "token")
        
        let session = URLSession.shared
        
        // Stub discovery with error
        
        mockDiscovery.discover(serviceLinks: serviceEndpointKeys, urlSession: session) {
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
        let rootResponse = response.data(using: .utf8)!
        stub(http(.get, uri: rootURI), jsonData(rootResponse))
    }
    
    private func givenSecondCallReturns(to uriEndpoint: String, _ response: String) {
        let serviceResponse = response.data(using: .utf8)!
        stub(http(.get, uri: uriEndpoint), jsonData(serviceResponse))
    }
    
    private func discoveryFindsServiceEndpoint() {
        let discovery = AccessCheckoutDiscovery(baseUrl: URL(string: rootURI)!)
        let testExpectation = expectation(description: "discovery")
        
        discovery.discover(serviceLinks: serviceEndpointKeys, urlSession: URLSession.shared) {
            XCTAssertEqual(discovery.serviceEndpoint, URL(string: self.destinationURI))
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    private func discoveryReturnsNil() {
        let discovery = AccessCheckoutDiscovery(baseUrl: URL(string: rootURI)!)
        let testExpectation = expectation(description: "failure")
       
        discovery.discover(serviceLinks: serviceEndpointKeys, urlSession: URLSession.shared) {
            XCTAssertNil(discovery.serviceEndpoint)
            testExpectation.fulfill()
        }
       
        waitForExpectations(timeout: 10, handler: nil)
    }
}
