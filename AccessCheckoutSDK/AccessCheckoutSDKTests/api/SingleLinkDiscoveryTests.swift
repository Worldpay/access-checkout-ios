import Foundation
import XCTest

@testable import AccessCheckoutSDK

class SingleLinkDiscoveryTests: XCTestCase {
    private var serviceStubs: ServiceStubs?
    private var urlRequest: URLRequest?

    override func setUp() {
        serviceStubs = ServiceStubs()
        urlRequest = URLRequest(url: URL(string: serviceStubs!.baseUrl)!)
    }

    override func tearDown() {
        serviceStubs!.stop()
    }

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
        serviceStubs!.get200(path: "", jsonResponse: jsonResponse)
            .start()

        let discovery = SingleLinkDiscovery(linkToFind: "a:link", urlRequest: urlRequest!)

        discovery.discover { result in
            switch result {
            case .success(let url):
                XCTAssertEqual("http://www.a-service.co.uk", url)
            case .failure:
                XCTFail("Discovery should not have failed")
            }
            expectationToFulfill.fulfill()
        }

        wait(for: [expectationToFulfill], timeout: 5)
    }

    func testReturnsErrorWhenLinkNotFoundInResponse() {
        let expectationToFulfill = expectation(description: "")
        let expectedError = StubUtils.createError(
            errorName: "discoveryLinkNotFound", message: "Failed to find link a:link in response")
        let jsonResponse = """
            {
                "_links": {
                    "some:link": {
                        "href": "http://www.some-service.co.uk"
                    }
                }
            }
            """
        serviceStubs!.get200(path: "", jsonResponse: jsonResponse)
            .start()

        let discovery = SingleLinkDiscovery(linkToFind: "a:link", urlRequest: urlRequest!)

        discovery.discover { result in
            switch result {
            case .success:
                XCTFail("Discovery should have failed")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }
            expectationToFulfill.fulfill()
        }

        wait(for: [expectationToFulfill], timeout: 5)
    }

    func testReturnsErrorWhenFailsToDeserialiseResponse() {
        let expectationToFulfill = expectation(description: "")
        let expectedError = StubUtils.createError(
            errorName: "responseDecodingFailed", message: "Failed to decode response data")
        let response = "some-content"

        let discovery = SingleLinkDiscovery(linkToFind: "a:link", urlRequest: urlRequest!)

        serviceStubs!.get200(path: "", textResponse: response)
            .start()

        discovery.discover { result in
            switch result {
            case .success:
                XCTFail("Discovery should have failed")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }
            expectationToFulfill.fulfill()
        }

        wait(for: [expectationToFulfill], timeout: 5)
    }

    func testReturnsErrorWhenResponseIsAnError() {
        let expectationToFulfill = expectation(description: "")
        let expectedError = StubUtils.createError(
            errorName: "responseDecodingFailed", message: "Failed to decode response data")
        let discovery = SingleLinkDiscovery(linkToFind: "a:link", urlRequest: urlRequest!)

        serviceStubs!.get400(path: "", textResponse: "An error")
            .start()

        discovery.discover { result in
            switch result {
            case .success:
                XCTFail("Discovery should have failed")
            case .failure(let error):
                XCTAssertEqual(expectedError, error)
            }
            expectationToFulfill.fulfill()
        }

        wait(for: [expectationToFulfill], timeout: 5)
    }
}
