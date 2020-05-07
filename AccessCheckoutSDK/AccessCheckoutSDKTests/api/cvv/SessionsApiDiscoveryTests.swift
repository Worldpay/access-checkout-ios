@testable import AccessCheckoutSDK
import Cuckoo
import PromiseKit
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
        let promiseToReturnToFindService = Promise.value("http://localhost/a-service")
        mockDiscoveryService.willReturn(promiseToReturnToFindService)
        
        let expectedRequestToFindEndPoint = createExpectedRequestToFindEndPoint(url: "http://localhost/a-service")
        let promiseToReturnToFindEndPoint = Promise.value("http://localhost/an-end-point")
        mockDiscoveryEndPoint.willReturn(promiseToReturnToFindEndPoint)
        
        let discovery = SessionsApiDiscovery(discoveryFactory: discoveryFactory)
        
        firstly {
            discovery.discover(baseUrl: "http://localhost")
        }.done { link in
            XCTAssertEqual("http://localhost/an-end-point", link)
            
            let argumentCaptorLinks = ArgumentCaptor<String>()
            let argumentCaptorRequests = ArgumentCaptor<URLRequest>()
            verify(self.discoveryFactory, times(2)).create(toFindLink: argumentCaptorLinks.capture(), usingRequest: argumentCaptorRequests.capture())
            
            XCTAssertEqual(ApiLinks.sessions.service, argumentCaptorLinks.allValues[0])
            XCTAssertEqual(expectedRequestToFindService, argumentCaptorRequests.allValues[0])
            
            XCTAssertEqual(ApiLinks.sessions.endpoint, argumentCaptorLinks.allValues[1])
            XCTAssertEqual(expectedRequestToFindEndPoint, argumentCaptorRequests.allValues[1])
            
            expectationToFulfill.fulfill()
        }.catch { _ in
            XCTFail("Discovery should not have failed")
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testFailsToDiscoverIfServiceIsNotDiscoveredSuccessfully() {
        let expectationToFulfill = expectation(description: "")
        
        let expectedRequestToFindService = createExpectedRequestToFindService(url: "http://localhost")
        let promiseToReturnToFindService = Promise<String>(error: AccessCheckoutClientError.unknown(message: "an error"))
        mockDiscoveryService.willReturn(promiseToReturnToFindService)
        
        let promiseToReturnToFindEndPoint = Promise.value("http://localhost/an-end-point")
        mockDiscoveryEndPoint.willReturn(promiseToReturnToFindEndPoint)
        
        let discovery = SessionsApiDiscovery(discoveryFactory: discoveryFactory)
        
        firstly {
            discovery.discover(baseUrl: "http://localhost")
        }.done { link in
            XCTFail("Discovery should have failed")
        }.catch { error in
            XCTAssertEqual(AccessCheckoutClientError.unknown(message: "an error"), error as! AccessCheckoutClientError)
            
            let argumentCaptorLinks = ArgumentCaptor<String>()
            let argumentCaptorRequests = ArgumentCaptor<URLRequest>()
            verify(self.discoveryFactory, times(1)).create(toFindLink: argumentCaptorLinks.capture(), usingRequest: argumentCaptorRequests.capture())
            
            XCTAssertEqual(ApiLinks.sessions.service, argumentCaptorLinks.allValues[0])
            XCTAssertEqual(expectedRequestToFindService, argumentCaptorRequests.allValues[0])
            
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testFailsToDiscoverIfEndpointIsNotDiscoveredSuccessfully() {
        let expectationToFulfill = expectation(description: "")
        
        let expectedRequestToFindService = createExpectedRequestToFindService(url: "http://localhost")
        let promiseToReturnToFindService = Promise.value("http://localhost/a-service")
        mockDiscoveryService.willReturn(promiseToReturnToFindService)
        
        let expectedRequestToFindEndPoint = createExpectedRequestToFindEndPoint(url: "http://localhost/a-service")
        let promiseToReturnToFindEndPoint = Promise<String>(error: AccessCheckoutClientError.unknown(message: "an error"))
        mockDiscoveryEndPoint.willReturn(promiseToReturnToFindEndPoint)
        
        let discovery = SessionsApiDiscovery(discoveryFactory: discoveryFactory)
        
        firstly {
            discovery.discover(baseUrl: "http://localhost")
        }.done { link in
            XCTFail("Discovery should have failed")
        }.catch { error in
            XCTAssertEqual(AccessCheckoutClientError.unknown(message: "an error"), error as! AccessCheckoutClientError)
            
            let argumentCaptorLinks = ArgumentCaptor<String>()
            let argumentCaptorRequests = ArgumentCaptor<URLRequest>()
            verify(self.discoveryFactory, times(2)).create(toFindLink: argumentCaptorLinks.capture(), usingRequest: argumentCaptorRequests.capture())
            
            XCTAssertEqual(ApiLinks.sessions.service, argumentCaptorLinks.allValues[0])
            XCTAssertEqual(expectedRequestToFindService, argumentCaptorRequests.allValues[0])
            
            XCTAssertEqual(ApiLinks.sessions.endpoint, argumentCaptorLinks.allValues[1])
            XCTAssertEqual(expectedRequestToFindEndPoint, argumentCaptorRequests.allValues[1])
            
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
