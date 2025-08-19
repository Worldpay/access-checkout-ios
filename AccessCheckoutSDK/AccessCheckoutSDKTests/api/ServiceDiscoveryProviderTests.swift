import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class ServiceDiscoveryProviderTests: XCTestCase {
    let baseUrl = "some-url"
    let restClient = MockRestClient<ApiResponse>()
    let apiResponseLookUpMock = MockApiResponseLinkLookup()

    // default api response values for testing
    let sessionsServiceUrl = "sessions-service-url"
    let cardBinServiceUrl = "card-bin-service-url"
    let sessionsCardHref = "sessions-card-href"
    let sessionsCvcHref = "sessions-cvc-href"

    private var serviceDiscoveryProvider: ServiceDiscoveryProvider?
    private var expectationToFulfill: XCTestExpectation?

    override func setUp() {
        /*
         create an instance of ServiceDiscoveryProvider with mocks
         all calls to ServiceDiscoveryProvider will use underlying mocks
         */
        ServiceDiscoveryProvider.shared = ServiceDiscoveryProvider(
            restClient,
            apiResponseLookUpMock)
        ServiceDiscoveryProvider.shared.clearCache()
    }

    func testGettersReturnCardAndCvcEndpoints() {
        expectationToFulfill = expectation(description: "")

        setUpDiscoveryResponses()

        setUpApiResponseLookups(withDefaults: true)

        let expectedBaseDiscoveryRequest = URLRequest(url: URL(string: "some-url")!)
        var expectedSessionsDiscoveryRequest = URLRequest(
            url: URL(string: sessionsServiceUrl)!)
        expectedSessionsDiscoveryRequest.addValue(
            ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "content-type")
        expectedSessionsDiscoveryRequest.addValue(
            ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "accept")

        // call method
        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                // verify calls to factory
                verify(self.restClient, times(2)).send(
                    urlSession: any(), request: any(), completionHandler: any())
                verify(self.restClient).send(
                    urlSession: any(), request: expectedBaseDiscoveryRequest,
                    completionHandler: any())
                verify(self.restClient).send(
                    urlSession: any(), request: expectedSessionsDiscoveryRequest,
                    completionHandler: any())

                // verify calls to api response lookup
                verify(self.apiResponseLookUpMock, times(4)).lookup(link: any(), in: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cardSessions.service, in: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cardSessions.endpoint, in: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cardSessions.endpoint, in: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cardBin.service, in: any())
                self.expectationToFulfill!.fulfill()

                // verify endpoints have been discovered
                self.assertDiscoveredEndpoints()

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
        setUpDiscoveryResponses(withAccessRootDiscoveryError: expectedError)

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                XCTFail("Access root discovery should have returned an error")
                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                verify(self.restClient, times(1)).send(
                    urlSession: any(), request: any(), completionHandler: any())
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

        setUpDiscoveryResponses()

        // Simulate no sessions service link in access root response
        setUpApiResponseLookups(sessionsServiceLookup: nil)

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                XCTFail("Sessions service url should not have been found")
                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                verify(self.restClient, times(1)).send(
                    urlSession: any(), request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(link: any(), in: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cardSessions.service, in: any())

                XCTAssertEqual(error, expectedError)

                self.expectationToFulfill!.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldReturnAnErorrWhenUnableToLookUpCardBinServiceUrlInAccessRootResponse() {
        expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutError.discoveryLinkNotFound(
            linkName: ApiLinks.cardBin.service)

        setUpDiscoveryResponses()

        // Simulate no card bin service url in access root response
        setUpApiResponseLookups(
            sessionsServiceLookup: sessionsServiceUrl,
            cardEndpointLookup: nil)

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                XCTFail("Card bin service url should not have been found")
                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                verify(self.restClient, times(1)).send(
                    urlSession: any(), request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(2)).lookup(link: any(), in: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cardBin.service, in: any())

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
        setUpDiscoveryResponses(withSessionsDiscoveryError: expectedError)

        setUpApiResponseLookups(
            sessionsServiceLookup: sessionsServiceUrl,
            cardBinServiceLookup: cardBinServiceUrl)

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                XCTFail("Sessions discovery should not have been found")
                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                verify(self.restClient, times(2)).send(
                    urlSession: any(), request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(2)).lookup(link: any(), in: any())

                XCTAssertEqual(error, expectedError)

                self.expectationToFulfill!.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testSubsequentCallsToDiscoveryReturnCachedValues() {
        expectationToFulfill = expectation(description: "")
        let nextExpectationToFulfil = XCTestExpectation(description: "")

        setUpDiscoveryResponses()

        setUpApiResponseLookups(withDefaults: true)

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                verify(self.restClient, times(2)).send(
                    urlSession: any(), request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(4)).lookup(link: any(), in: any())

                self.assertDiscoveredEndpoints()

                // clear previous calls to the mocks
                clearInvocations(self.restClient)
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
                verify(self.restClient, times(0)).send(
                    urlSession: any(), request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(0)).lookup(link: any(), in: any())

                self.assertDiscoveredEndpoints()

                nextExpectationToFulfil.fulfill()
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                nextExpectationToFulfil.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldClearDiscoverdEndpoints() {
        expectationToFulfill = expectation(description: "")

        setUpDiscoveryResponses()

        setUpApiResponseLookups(withDefaults: true)

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                self.assertDiscoveredEndpoints()

                self.expectationToFulfill!.fulfill()
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                self.expectationToFulfill!.fulfill()
            }
        }

        ServiceDiscoveryProvider.shared.clearCache()

        self.assertDiscoveredEndpointsAreNil()

        waitForExpectations(timeout: 1)
    }

    /// Tests that discovery calls are made again after clearing the cache.
    func testShouldCallDiscoveryWhenCacheIsCleared() {
        expectationToFulfill = expectation(description: "")
        let nextExpectationToFulfill = XCTestExpectation(description: "")

        setUpDiscoveryResponses()

        setUpApiResponseLookups(withDefaults: true)

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                // verify calls to factory and lookup mocks
                verify(self.restClient, times(2)).send(
                    urlSession: any(), request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(4)).lookup(link: any(), in: any())

                self.assertDiscoveredEndpoints()

                self.expectationToFulfill!.fulfill()
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                self.expectationToFulfill!.fulfill()
            }
        }

        ServiceDiscoveryProvider.shared.clearCache()

        // verify cached endpoints are cleared
        self.assertDiscoveredEndpointsAreNil()

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                // verify calls after clearing cached endpoints
                verify(self.restClient, times(4)).send(
                    urlSession: any(), request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(8)).lookup(link: any(), in: any())

                self.assertDiscoveredEndpoints()

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

        setUpDiscoveryResponses()

        // simulate no lookup value for sessions card endpoint
        setUpApiResponseLookups(
            sessionsServiceLookup: sessionsServiceUrl,
            cardBinServiceLookup: cardBinServiceUrl,
            cardEndpointLookup: nil)

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                XCTFail("Sessions card url should not have been found")
                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                verify(self.restClient, times(2)).send(
                    urlSession: any(), request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(3)).lookup(link: any(), in: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cardSessions.endpoint, in: any())

                XCTAssertEqual(error, expectedError)

                self.expectationToFulfill!.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldReturnErrorWhenUnableToLookUpSessionsCvcUrl() {
        expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutError.discoveryLinkNotFound(
            linkName: ApiLinks.cvcSessions.endpoint)

        setUpDiscoveryResponses()

        // simulate no lookup value for sessions cvc endpoint
        setUpApiResponseLookups(
            sessionsServiceLookup: sessionsServiceUrl,
            cardBinServiceLookup: cardBinServiceUrl,
            cardEndpointLookup: sessionsCardHref,
            cvcEndpointLookup: nil)

        ServiceDiscoveryProvider.discover(baseUrl: baseUrl) { result in
            switch result {
            case .success():
                XCTFail("Sessions cvc url should not have been found")
                self.expectationToFulfill!.fulfill()
            case .failure(let error):
                verify(self.restClient, times(2)).send(
                    urlSession: any(), request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(4)).lookup(link: any(), in: any())
                verify(self.apiResponseLookUpMock, times(1)).lookup(
                    link: ApiLinks.cvcSessions.endpoint, in: any())

                XCTAssertEqual(error, expectedError)

                self.expectationToFulfill!.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    private func setUpDiscoveryResponses(
        withAccessRootDiscoveryError: AccessCheckoutError? = nil,
        withSessionsDiscoveryError: AccessCheckoutError? = nil
    ) {
        let accessRootDiscoveryResult =
            (withAccessRootDiscoveryError != nil)
            ? Result.failure(withAccessRootDiscoveryError!)
            : Result.success(self.genericApiResponse())

        let sessionsDiscoveryResult =
            (withSessionsDiscoveryError != nil)
            ? Result.failure(withSessionsDiscoveryError!)
            : Result.success(self.genericApiResponse())

        restClient.getStubbingProxy()
            .send(urlSession: any(), request: any(), completionHandler: any())
            .then {
                _, _, completionHandler in
                completionHandler(accessRootDiscoveryResult, nil)
                return URLSessionTask()
            }.then {
                _, _, completionHandler in
                completionHandler(sessionsDiscoveryResult, nil)
                return URLSessionTask()
            }
    }

    private func setUpApiResponseLookups(
        withDefaults: Bool = false,
        sessionsServiceLookup: String? = nil,
        cardBinServiceLookup: String? = nil,
        cardEndpointLookup: String? = nil,
        cvcEndpointLookup: String? = nil
    ) {
        let sessionsUrl = withDefaults ? sessionsServiceUrl : sessionsServiceLookup
        let cardBinUrl = withDefaults ? cardBinServiceUrl : cardBinServiceLookup
        let sessionsCardHref = withDefaults ? self.sessionsCardHref : cardEndpointLookup
        let sessionsCvcHref = withDefaults ? self.sessionsCvcHref : cvcEndpointLookup

        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardSessions.service, in: any())
            .thenReturn(sessionsUrl)
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardBin.service, in: any())
            .thenReturn(cardBinUrl)
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardSessions.endpoint, in: any())
            .thenReturn(sessionsCardHref)
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cvcSessions.endpoint, in: any())
            .thenReturn(sessionsCvcHref)
    }

    private func assertDiscoveredEndpoints() {
        XCTAssertEqual(
            ServiceDiscoveryProvider.getSessionsCardEndpoint(),
            self.sessionsCardHref)
        XCTAssertEqual(
            ServiceDiscoveryProvider.getSessionsCvcEndpoint(),
            self.sessionsCvcHref)
        XCTAssertEqual(
            ServiceDiscoveryProvider.getCardBinEndpoint(),
            self.cardBinServiceUrl)
    }

    private func assertDiscoveredEndpointsAreNil() {
        XCTAssertNil(ServiceDiscoveryProvider.getSessionsCardEndpoint())
        XCTAssertNil(ServiceDiscoveryProvider.getSessionsCvcEndpoint())
        XCTAssertNil(ServiceDiscoveryProvider.getCardBinEndpoint())
    }

    private func genericApiResponse() -> ApiResponse {
        let jsonString = """
            {
                "_links": {
                    "a:service": {
                        "href": "http://www.a-service.co.uk"
                    },
                },
            }
            """

        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }
}
