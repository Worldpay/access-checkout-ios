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
        serviceDiscoveryProvider = ServiceDiscoveryProvider(
            baseUrl: baseUrl, factoryMock, apiResponseLookUpMock)
        serviceDiscoveryProvider?.clearCache()
    }

    func testGettersReturnCardAndCvcEndpoints() {
        expectationToFulfill = expectation(description: "")

        // mock base and session discovery responses
        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(self.toBaseDiscoveryResponse())
            }.then {
                _, completionHandler in
                completionHandler(self.toSessionsDiscoveryResponse())
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
        serviceDiscoveryProvider?.discover {
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
        }

        // verify class parameters have correct values
        XCTAssertEqual(
            serviceDiscoveryProvider?.getSessionsCardEndpoint(), "sessionsCardHref")
        XCTAssertEqual(
            serviceDiscoveryProvider?.getSessionsCvcEndpoint(), "sessionsCvcHref")

        waitForExpectations(timeout: 1)
    }

    func testShouldNotCallSessionsDiscoveryIfBaseDiscoveryResponseIsNil() {
        expectationToFulfill = expectation(description: "")

        // Simulate failure in base discovery request/response
        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any()).then {
                _, completionHandler in
                completionHandler(nil)
            }

        serviceDiscoveryProvider?.discover {
            verify(self.factoryMock, times(1)).create(request: any(), completionHandler: any())
            self.expectationToFulfill!.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldNotCallSessionsDiscoveryIfBaseDiscoveryResponseDoesNotHaveSessionsLink() {
        expectationToFulfill = expectation(description: "")

        // mock base discovery response
        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any()).then {
                _, completionHandler in
                completionHandler(self.toBaseDiscoveryResponse())
            }

        // Simulate no sessions service link in base discovery response
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn(nil)


        serviceDiscoveryProvider?.discover {
            verify(self.factoryMock, times(1)).create(request: any(), completionHandler: any())

            verify(self.apiResponseLookUpMock, times(1)).lookup(
                link: ApiLinks.cardSessions.service, in: any())
            verifyNoMoreInteractions(self.apiResponseLookUpMock)

            self.expectationToFulfill!.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testGettersShouldReturnNilWhenUnableToPerformSessionsDiscoveryRequest() {
        expectationToFulfill = expectation(description: "")

        // simulate a successful base discovery response and a failed sessions response
        factoryMock.getStubbingProxy().create(request: any(), completionHandler: any()).then {
            _, completionHandler in
            completionHandler(self.toBaseDiscoveryResponse())
        }.then {
            _, completionHandler in
            completionHandler(nil)
        }

        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn("sessionsServiceLink")

        serviceDiscoveryProvider?.discover {
            verify(self.factoryMock, times(2)).create(request: any(), completionHandler: any())
            verify(self.apiResponseLookUpMock, times(1)).lookup(link: any(), in: any())
            self.expectationToFulfill!.fulfill()
        }

        XCTAssertNil(serviceDiscoveryProvider?.getSessionsCardEndpoint())
        XCTAssertNil(serviceDiscoveryProvider?.getSessionsCvcEndpoint())

        waitForExpectations(timeout: 1)
    }

    func testSubsequentCallsToDiscoveryReturnCachedValues() {
        expectationToFulfill = expectation(description: "")
        let expectationToFulfill2 = XCTestExpectation(description: "")

        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(self.toBaseDiscoveryResponse())
            }.then {
                _, completionHandler in
                completionHandler(self.toSessionsDiscoveryResponse())
            }

        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn("validBaseSessionsValue")
            .thenReturn("validSessionsCardHref")
            .thenReturn("validSessionsCvcHref")


        serviceDiscoveryProvider?.discover {
            verify(self.factoryMock, times(2)).create(request: any(), completionHandler: any())
            verify(self.apiResponseLookUpMock, times(3)).lookup(link: any(), in: any())
            // clear previous calls to the mocks
            clearInvocations(self.factoryMock)
            clearInvocations(self.apiResponseLookUpMock)

            self.expectationToFulfill!.fulfill()
        }

        XCTAssertEqual(serviceDiscoveryProvider?.getSessionsCardEndpoint(), "validSessionsCardHref")
        XCTAssertEqual(serviceDiscoveryProvider?.getSessionsCvcEndpoint(), "validSessionsCvcHref")
        
        // create another instance of ServiceDiscoveryProvider to test caching
        let otherServiceDiscoveryProvider = ServiceDiscoveryProvider(
            baseUrl: baseUrl, factoryMock, apiResponseLookUpMock)
        
        otherServiceDiscoveryProvider.discover {
            // verify no calls have been made to the factory or lookup mocks
            verify(self.factoryMock, times(0)).create(request: any(), completionHandler: any())
            verify(self.apiResponseLookUpMock, times(0)).lookup(link: any(), in: any())

            expectationToFulfill2.fulfill()
        }

        XCTAssertEqual(serviceDiscoveryProvider?.getSessionsCardEndpoint(), "validSessionsCardHref")
        XCTAssertEqual(serviceDiscoveryProvider?.getSessionsCvcEndpoint(), "validSessionsCvcHref")

        waitForExpectations(timeout: 1)
    }
    
    func testShouldClearCache() {
        expectationToFulfill = expectation(description: "")

        // mock base and session discovery responses
        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(self.toBaseDiscoveryResponse())
            }.then {
                _, completionHandler in
                completionHandler(self.toSessionsDiscoveryResponse())
            }

        // mock api response lookups
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn("sessionsServiceLink")
            .thenReturn("sessionsCardHref")
            .thenReturn("sessionsCvcHref")

        serviceDiscoveryProvider?.discover {
            self.expectationToFulfill!.fulfill()
        }

        XCTAssertNotNil(serviceDiscoveryProvider?.getSessionsCardEndpoint())
        XCTAssertNotNil(serviceDiscoveryProvider?.getSessionsCvcEndpoint())

        serviceDiscoveryProvider?.clearCache()

        XCTAssertNil(serviceDiscoveryProvider?.getSessionsCardEndpoint())
        XCTAssertNil(serviceDiscoveryProvider?.getSessionsCvcEndpoint())

        waitForExpectations(timeout: 1)
    }
    
    func testShouldCallDiscoveryWhenCacheIsCleared() {
        expectationToFulfill = expectation(description: "")
        let nextExpectationToFulfill = XCTestExpectation(description: "")

        // mock base and session discovery responses
        factoryMock.getStubbingProxy()
            .create(request: any(), completionHandler: any())
            .then {
                _, completionHandler in
                completionHandler(self.toBaseDiscoveryResponse())
            }.then {
                _, completionHandler in
                completionHandler(self.toSessionsDiscoveryResponse())
            }

        // mock api response lookups
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: any(), in: any())
            .thenReturn("sessionsServiceLink")
            .thenReturn("sessionsCardHref")
            .thenReturn("sessionsCvcHref")

        serviceDiscoveryProvider?.discover {
            // verify calls to factory and lookup mocks
            verify(self.factoryMock, times(2)).create(request: any(), completionHandler: any())
            verify(self.apiResponseLookUpMock, times(3)).lookup(link: any(), in: any())
            self.expectationToFulfill!.fulfill()
        }

        XCTAssertNotNil(serviceDiscoveryProvider?.getSessionsCardEndpoint())
        XCTAssertNotNil(serviceDiscoveryProvider?.getSessionsCvcEndpoint())

        serviceDiscoveryProvider?.clearCache()
        
        // verify cached endpoints are cleared
        XCTAssertNil(serviceDiscoveryProvider?.getSessionsCardEndpoint())
        XCTAssertNil(serviceDiscoveryProvider?.getSessionsCvcEndpoint())

        serviceDiscoveryProvider?.discover {
            // verify calls after clearing cached endpoints
            verify(self.factoryMock, times(4)).create(request: any(), completionHandler: any())
            verify(self.apiResponseLookUpMock, times(6)).lookup(link: any(), in: any())
            nextExpectationToFulfill.fulfill()
        }
        
        XCTAssertNotNil(serviceDiscoveryProvider?.getSessionsCardEndpoint())
        XCTAssertNotNil(serviceDiscoveryProvider?.getSessionsCvcEndpoint())

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
