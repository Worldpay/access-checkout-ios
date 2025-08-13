import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class ServiceDiscoveryProviderTests: XCTestCase {
    let baseUrl = "some-url"
    let factoryMock = MockServiceDiscoveryResponseFactory()
    let apiResponseLookUpMock = MockApiResponseLinkLookup()
    private var serviceDiscoveryProvider: ServiceDiscoveryProvider?
    private var expectationToFulfill: XCTestExpectation?

    override func setUp() {
        // create an instance of ServiceDiscoveryProvider with mocks
        // all calls to ServiceDiscoveryProvider will use underlying mocks
        ServiceDiscoveryProvider.shared = ServiceDiscoveryProvider(factoryMock,
                                                                   apiResponseLookUpMock)
        ServiceDiscoveryProvider.shared.clearCache()
    }

    func testGettersReturnCardAndCvcEndpoints() {
        expectationToFulfill = expectation(description: "")

        // mock base and session discovery responses
        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(Result.success(self.toBaseDiscoveryResponse()))
            }.then {
                _, completionHandler in
                completionHandler(Result.success(self.toSessionsDiscoveryResponse()))
            }

        // mock api response lookups
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn("sessionsServiceLink")
            .thenReturn("sessionsCardHref")
            .thenReturn("sessionsCvcHref")

        let expectedBaseDiscoveryRequest = URLRequest(url: URL(string: "some-url")!)
        var expectedSessionsDiscoveryRequest = URLRequest(
            url: URL(string: "sessionsServiceLink")!)
        expectedSessionsDiscoveryRequest.addValue(
            ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "content-type")
        expectedSessionsDiscoveryRequest.addValue(
            ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "accept")

        // call method
        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                // verify calls to factory
                verify(self.factoryMock, times(2)).create(request: any(), completionHandler: any())
                verify(self.factoryMock).create(
                    request: expectedBaseDiscoveryRequest, completionHandler: any())
                verify(self.factoryMock).create(
                    request: expectedSessionsDiscoveryRequest, completionHandler: any())

                // verify calls to api response lookup
                verify(self.apiResponseLookUpMock, times(3)).lookup(link: any(), in: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cardSessions.service, in: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cardSessions.endpoint, in: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cardSessions.endpoint, in: any())
                self.expectationToFulfill!.fulfill()

                //                 verify class parameters have correct values
                XCTAssertEqual(ServiceDiscoveryProvider.getSessionsCardEndpoint(),
                               "sessionsCardHref")
                XCTAssertEqual( ServiceDiscoveryProvider.getSessionsCvcEndpoint(),
                                "sessionsCvcHref")

            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                self.expectationToFulfill!.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }



    func testShouldReturnAnErrorWhenAnErrorOccursDuringAccessRootDisovery() {
        expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutError.unexpectedApiError(
            message: "Unable to fetch access root discovery response.")
        
        // Simulate failure in access root discovery
        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(Result.failure(expectedError))
            }

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                XCTFail("Access root discovery should have returned an error")
                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                verify(self.factoryMock, times(1)).create(request: any(), completionHandler: any())
                XCTAssertEqual(error, expectedError)
                self.expectationToFulfill!.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldReturnAnErorrWhenUnableToLookUpSessionsServiceUrlInAccessRootResponse() {
        expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutError.discoveryLinkNotFound(
            linkName: ApiLinks.cardSessions.service)

        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(Result.success(self.toBaseDiscoveryResponse()))
            }

        // Simulate no sessions service link in access root response
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn(nil)

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                XCTFail("Sessions service url should not have been found")
                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                verify(self.factoryMock, times(1)).create(request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cardSessions.service, in: any())
                XCTAssertEqual(error, expectedError)
                self.expectationToFulfill!.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldReturnAnErrorWhenAnErrorOccursDuringSessionsDiscovery() {
        expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutError.unexpectedApiError(
            message: "Unable to fetch sessions discovery response")

        // Simulate failure in sessions discovery
        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(Result.success(self.toBaseDiscoveryResponse()))
            }
            .then {
                _, completionHandler in
                completionHandler(Result.failure(expectedError))
            }

        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn("sessionsServiceLink")

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                XCTFail("Sessions discovery should not have been found")
                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                verify(self.factoryMock, times(2)).create(request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cardSessions.service, in: any())
                XCTAssertEqual(error, expectedError)
                self.expectationToFulfill!.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testSubsequentCallsToDiscoveryReturnCachedValues() {
        expectationToFulfill = expectation(description: "")
        let expectationToFulfill2 = XCTestExpectation(description: "")

        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(Result.success(self.toBaseDiscoveryResponse()))
            }.then {
                _, completionHandler in
                completionHandler(Result.success(self.toSessionsDiscoveryResponse()))
            }

        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn("validBaseSessionsValue")
            .thenReturn("validSessionsCardHref")
            .thenReturn("validSessionsCvcHref")

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                verify(self.factoryMock, times(2)).create(request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(3)).lookup(link: any(), in: any())
                
                XCTAssertEqual(ServiceDiscoveryProvider.getSessionsCardEndpoint(), "validSessionsCardHref")
                XCTAssertEqual(ServiceDiscoveryProvider.getSessionsCvcEndpoint(), "validSessionsCvcHref")
                
                // clear previous calls to the mocks
                clearInvocations(self.factoryMock)
                clearInvocations(self.apiResponseLookUpMock)

                self.expectationToFulfill!.fulfill()
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                self.expectationToFulfill!.fulfill()
            }
        }

        // subsequent calls should return cached values without calling the factory or lookup mocks
        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                // verify no calls have been made to the factory or lookup mocks
                verify(self.factoryMock, times(0)).create(request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(0)).lookup(link: any(), in: any())
                
                XCTAssertEqual(ServiceDiscoveryProvider.getSessionsCardEndpoint(), "validSessionsCardHref")
                XCTAssertEqual(ServiceDiscoveryProvider.getSessionsCvcEndpoint(), "validSessionsCvcHref")

                expectationToFulfill2.fulfill()
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                expectationToFulfill2.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldClearCache() {
        expectationToFulfill = expectation(description: "")

        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(Result.success(self.toBaseDiscoveryResponse()))
            }.then {
                _, completionHandler in
                completionHandler(Result.success(self.toSessionsDiscoveryResponse()))
            }

        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn("sessionsServiceLink")
            .thenReturn("sessionsCardHref")
            .thenReturn("sessionsCvcHref")

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                XCTAssertNotNil(ServiceDiscoveryProvider.getSessionsCardEndpoint(), "validSessionsCardHref")
                XCTAssertNotNil(ServiceDiscoveryProvider.getSessionsCvcEndpoint(), "validSessionsCvcHref")
            
                self.expectationToFulfill!.fulfill()
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                self.expectationToFulfill!.fulfill()
            }
        }

        ServiceDiscoveryProvider.shared.clearCache()

        XCTAssertNil(ServiceDiscoveryProvider.getSessionsCardEndpoint())
        XCTAssertNil(ServiceDiscoveryProvider.getSessionsCvcEndpoint())

        waitForExpectations(timeout: 1)
    }

    func testShouldCallDiscoveryWhenCacheIsCleared() {
        expectationToFulfill = expectation(description: "")
        let nextExpectationToFulfill = XCTestExpectation(description: "")

        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(Result.success(self.toBaseDiscoveryResponse()))
            }.then {
                _, completionHandler in
                completionHandler(Result.success(self.toSessionsDiscoveryResponse()))
            }

        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn("sessionsServiceLink")
            .thenReturn("sessionsCardHref")
            .thenReturn("sessionsCvcHref")

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                // verify calls to factory and lookup mocks
                verify(self.factoryMock, times(2)).create(request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(3)).lookup(link: any(), in: any())
                
                XCTAssertNotNil(ServiceDiscoveryProvider.getSessionsCardEndpoint())
                XCTAssertNotNil(ServiceDiscoveryProvider.getSessionsCvcEndpoint())
                
                self.expectationToFulfill!.fulfill()
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                self.expectationToFulfill!.fulfill()
            }
        }

        ServiceDiscoveryProvider.shared.clearCache()

        // verify cached endpoints are cleared
        XCTAssertNil(ServiceDiscoveryProvider.getSessionsCardEndpoint())
        XCTAssertNil(ServiceDiscoveryProvider.getSessionsCvcEndpoint())

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                // verify calls after clearing cached endpoints
                verify(self.factoryMock, times(4)).create(request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(6)).lookup(link: any(), in: any())
                
                XCTAssertNotNil(ServiceDiscoveryProvider.getSessionsCardEndpoint())
                XCTAssertNotNil(ServiceDiscoveryProvider.getSessionsCvcEndpoint())
                
                nextExpectationToFulfill.fulfill()
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                nextExpectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldReturnAnErrorWhenUnableToLookUpSessionsCardUrl() {
        expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutError.discoveryLinkNotFound(
            linkName: ApiLinks.cardSessions.endpoint)

        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(Result.success(self.toBaseDiscoveryResponse()))
            }.then {
                _, completionHandler in
                completionHandler(Result.success(self.toSessionsDiscoveryResponse()))
            }

        
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn("sessionsServiceLink")
            .thenReturn(nil) // simulate an error in looking up the sessions card URL

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                XCTFail("Sessions card URL should not have been found")
                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                verify(self.factoryMock, times(2)).create(request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cardSessions.endpoint, in: any())
                
                XCTAssertEqual(error, expectedError)
                
                self.expectationToFulfill!.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldReturnErrorWhenUnableToLookUpSessionsCvsUrl() {
        expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutError.discoveryLinkNotFound(
            linkName: ApiLinks.cvcSessions.endpoint)

        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(Result.success(self.toBaseDiscoveryResponse()))
            }.then {
                _, completionHandler in
                completionHandler(Result.success(self.toSessionsDiscoveryResponse()))
            }

        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn("sessionsServiceLink")
            .thenReturn("sessionsCardHref")
            .thenReturn(nil) // simulate an error in looking up the sessions cvc URL

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                XCTFail("Sessions cvc URL should not have been found")
                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                verify(self.factoryMock, times(2)).create(request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cvcSessions.endpoint, in: any())
                
                XCTAssertEqual(error, expectedError)
                
                self.expectationToFulfill!.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    private func toBaseDiscoveryResponse() -> ApiResponse {
        let jsonString = """
            {
                "_links": {
                    "service:sessions": {
                    "href": "http://www.a-service.co.uk"
                    },
                    "b:link": {
                        "href": "http://www.b-service.co.uk"
                    }
                }
            }
            """

        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }

    private func toSessionsDiscoveryResponse() -> ApiResponse {
        let jsonString = """
            {
            "_links": {
            "sessions:card": {
            "href": "some-link-1"
            },
            "sessions:apm": {
            "href": "some-link-2"
            },
            "resourceTree": {
            "href": "some-link-3"
            },
            "sessions:paymentsCvc": {
            "href": "some-link-4"
            },
            "curies": [
            {
            "href": "some-link-5",
            "name": "sessions",
            "templated": true
            }
            ]
            }
            }
            """

        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }
}
