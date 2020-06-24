@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class SessionsApiDiscoveryTests: XCTestCase {
    let discoveryFactory = MockSingleLinkDiscoveryFactory()
    let mockDiscoveryService = SingleLinkDiscoveryMock()
    let mockDiscoveryEndPoint = SingleLinkDiscoveryMock()
    
    override func setUp() {
        when(discoveryFactory.getStubbingProxy().create(toFindLink: ApiLinks.sessions.service, usingRequest: any())).thenReturn(mockDiscoveryService)
        when(discoveryFactory.getStubbingProxy().create(toFindLink: ApiLinks.sessions.endpoint, usingRequest: any())).thenReturn(mockDiscoveryEndPoint)
    }
    
    func testDiscoversSessionServiceAndPaymentsCvcSessionEndPoint() {
        let expectationToFulfill = expectation(description: "")
        
        let expectedRequestToFindService = createExpectedRequestToFindService(url: "http://localhost")
        mockDiscoveryService.willComplete(with: "http://localhost/a-service")
        
        let expectedRequestToFindEndPoint = createExpectedRequestToFindEndPoint(url: "http://localhost/a-service")
        mockDiscoveryEndPoint.willComplete(with: "http://localhost/an-end-point")
        
        let discovery = SessionsApiDiscovery(discoveryFactory: discoveryFactory)
        
        discovery.discover(baseUrl: "http://localhost") { result in
            switch result {
                case .success(let link):
                    XCTAssertEqual("http://localhost/an-end-point", link)
                    
                    let argumentCaptorLinks = ArgumentCaptor<String>()
                    let argumentCaptorRequests = ArgumentCaptor<URLRequest>()
                    verify(self.discoveryFactory, times(2)).create(toFindLink: argumentCaptorLinks.capture(), usingRequest: argumentCaptorRequests.capture())
                    
                    XCTAssertEqual(ApiLinks.sessions.service, argumentCaptorLinks.allValues[0])
                    XCTAssertEqual(expectedRequestToFindService, argumentCaptorRequests.allValues[0])
                    
                    XCTAssertEqual(ApiLinks.sessions.endpoint, argumentCaptorLinks.allValues[1])
                    XCTAssertEqual(expectedRequestToFindEndPoint, argumentCaptorRequests.allValues[1])
                case .failure:
                    XCTFail("Discovery should not have failed")
            }
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testFailsToDiscoverIfServiceIsNotDiscoveredSuccessfully() {
        let expectationToFulfill = expectation(description: "")
        
        let expectedRequestToFindService = createExpectedRequestToFindService(url: "http://localhost")
        let expectedError = StubUtils.createError(errorName: "an error", message: "a message")
        mockDiscoveryService.willComplete(with: expectedError)
        mockDiscoveryEndPoint.willComplete(with: "http://localhost/an-end-point")
        
        let discovery = SessionsApiDiscovery(discoveryFactory: discoveryFactory)
        
        discovery.discover(baseUrl: "http://localhost") { result in
            switch result {
                case .success:
                    XCTFail("Discovery should have failed")
                case .failure(let error):
                    XCTAssertEqual(expectedError, error)
                    
                    let argumentCaptorLinks = ArgumentCaptor<String>()
                    let argumentCaptorRequests = ArgumentCaptor<URLRequest>()
                    verify(self.discoveryFactory, times(1)).create(toFindLink: argumentCaptorLinks.capture(), usingRequest: argumentCaptorRequests.capture())
                    
                    XCTAssertEqual(ApiLinks.sessions.service, argumentCaptorLinks.allValues[0])
                    XCTAssertEqual(expectedRequestToFindService, argumentCaptorRequests.allValues[0])
            }
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testFailsToDiscoverIfEndpointIsNotDiscoveredSuccessfully() {
        let expectationToFulfill = expectation(description: "")
        
        let expectedRequestToFindService = createExpectedRequestToFindService(url: "http://localhost")
        mockDiscoveryService.willComplete(with: "http://localhost/a-service")
        
        let expectedRequestToFindEndPoint = createExpectedRequestToFindEndPoint(url: "http://localhost/a-service")
        let expectedError = StubUtils.createError(errorName: "an error", message: "a message")
        mockDiscoveryEndPoint.willComplete(with: expectedError)
        
        let discovery = SessionsApiDiscovery(discoveryFactory: discoveryFactory)
        
        discovery.discover(baseUrl: "http://localhost") { result in
            switch result {
                case .success:
                    XCTFail("Discovery should have failed")
                case .failure(let error):
                    XCTAssertEqual(expectedError, error)
                    
                    let argumentCaptorLinks = ArgumentCaptor<String>()
                    let argumentCaptorRequests = ArgumentCaptor<URLRequest>()
                    verify(self.discoveryFactory, times(2)).create(toFindLink: argumentCaptorLinks.capture(), usingRequest: argumentCaptorRequests.capture())
                    
                    XCTAssertEqual(ApiLinks.sessions.service, argumentCaptorLinks.allValues[0])
                    XCTAssertEqual(expectedRequestToFindService, argumentCaptorRequests.allValues[0])
                    
                    XCTAssertEqual(ApiLinks.sessions.endpoint, argumentCaptorLinks.allValues[1])
                    XCTAssertEqual(expectedRequestToFindEndPoint, argumentCaptorRequests.allValues[1])
            }
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func createExpectedRequestToFindService(url: String) -> URLRequest {
        return URLRequest(url: URL(string: url)!)
    }
    
    func createExpectedRequestToFindEndPoint(url: String) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "content-type")
        urlRequest.addValue(ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "accept")
        return urlRequest
    }
}
