@testable import AccessCheckoutSDK
import XCTest
import PromiseKit
import Foundation

class SingleLinkDiscoveryTests : XCTestCase {
    private let urlRequest = URLRequest(url: URL(string: "http://localhost")!)
    
    func testsSuccessfullyDiscoversALink() {
        let expectationToFulfill = expectation(description: "")
        let jsonResponse = """
        {
            "_links": {
                "some:link": {
                    "href": "http://www.some-service.co.uk"
                },
                "a:link": {
                    "href": "http://www.a-service.co.uk"
                }
            }
        }
        """
        StubUtils.stubSuccessfulGetResponse(url: "http://localhost", responseAsString: jsonResponse)
        
        let discovery = SingleLinkDiscovery(linkToFind: "a:link", urlRequest: urlRequest)
        firstly {
            discovery.discover()
        }.done { link in
          XCTAssertEqual("http://www.a-service.co.uk", link)
          expectationToFulfill.fulfill()
        }.catch() { error in
            XCTFail("Discovery should not have failed")
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testReturnsErrorWhenLinkNotFoundInResponse() {
        let expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutClientError.unknown(message: "Failed to find link a:link in response")
        let jsonResponse = """
        {
            "_links": {
                "some:link": {
                    "href": "http://www.some-service.co.uk"
                }
            }
        }
        """
        StubUtils.stubSuccessfulGetResponse(url: "http://localhost", responseAsString: jsonResponse)
        
        let discovery = SingleLinkDiscovery(linkToFind: "a:link", urlRequest: urlRequest)
        firstly {
            discovery.discover()
        }.done { link in
            XCTFail("Discovery should have failed")
        }.catch() { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientError)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testReturnsErrorWhenFailsToDeserialiseResponse() {
        let expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutClientError.unknown(message: "Failed to decode response data")
        let jsonResponse = "some-content"
        StubUtils.stubSuccessfulGetResponse(url: "http://localhost", responseAsString: jsonResponse)
        
        let discovery = SingleLinkDiscovery(linkToFind: "a:link", urlRequest: urlRequest)
        firstly {
            discovery.discover()
        }.done { link in
            XCTFail("Discovery should have failed")
        }.catch() { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientError)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
    
    func testReturnsErrorWhenResponseIsAnError() {
        let expectationToFulfill = expectation(description: "")
        // ToDo - The Rest client does not go through the "error" branch but still fails on decoding. This needs fixing, we should receive as an error what the response contains
        let expectedError = AccessCheckoutClientError.unknown(message: "Failed to decode response data")
        StubUtils.stubGetResponse(url: "http://localhost", responseAsString: "An error", responseCode: 400)
        
        let discovery = SingleLinkDiscovery(linkToFind: "a:link", urlRequest: urlRequest)
        firstly {
            discovery.discover()
        }.done { link in
            XCTFail("Discovery should have failed")
        }.catch() { error in
            XCTAssertEqual(expectedError, error as! AccessCheckoutClientError)
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 1)
    }
}
