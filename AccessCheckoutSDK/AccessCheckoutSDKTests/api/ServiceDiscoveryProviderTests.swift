import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class ServiceDiscoveryProviderTests: XCTestCase {
    private let baseUrlAsString = "access-root-url"
    private let restClientMock = MockRetryRestClientDecorator<ApiResponse>()
    private let apiResponseLookUpMock = MockApiResponseLinkLookup()

    // default api response values for testing
    private let expectedBaseUrl = URL(string: "access-root-url")!
    private let expectedSessionsServiceUrl = URL(string: "sessions-service-url")!
    private let expectedCardBinDetailsUrl = URL(string: "card-bin-details-url")!
    private let expectedCreateCardSessionsUrl = URL(string: "create-card-sessions-url")!
    private let expectedCreateCvcSessionsUrl = URL(string: "create-cvc-sessions-url")!

    private var expectedBaseUrlRequest: URLRequest!
    private var expectedSessionsServiceRequest: URLRequest!

    private var serviceDiscoveryProvider: ServiceDiscoveryProvider?

    override func setUp() {
        ServiceDiscoveryProvider.clearCache()
        ServiceDiscoveryProvider.sharedInstance = nil

        expectedBaseUrlRequest = URLRequest(url: URL(string: baseUrlAsString)!)

        expectedSessionsServiceRequest = URLRequest(
            url: URL(string: expectedSessionsServiceUrl.absoluteString)!)
        expectedSessionsServiceRequest.addValue(
            ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "content-type")
        expectedSessionsServiceRequest.addValue(
            ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "accept")
    }

    func testDiscoverCallsCompletionHandlerWithErrorWhenDiscoveryHasNotBeenInitialised() {
        let expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutError.internalError(
            message: "Service discovery has not been initialised")

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(_):
                XCTFail("Access root discovery should have returned an error")
                expectationToFulfill.fulfill()
            case .failure(let error):
                XCTAssertEqual(error, expectedError)
                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    // MARK: Initialise tests
    // An invalid URL in swift is a URL which is emtpy or contains invalid characters
    // It won't fail though if the URL has valid characters but is not in the form of a URL (e.g. blah is considered valid)
    func testInitialiseThrowsErrorWhenURLIsEmpty() {
        do {
            try ServiceDiscoveryProvider.initialise("")

            XCTFail("ServiceDiscoveryProvider.initialise should have thrown an error but didn't")
        } catch let error as AccessCheckoutIllegalArgumentError {
            XCTAssertEqual(AccessCheckoutIllegalArgumentError.malformedAccessBaseUrl(), error)
        } catch let error {
            XCTFail(
                "Expected error to be of type AccessCheckoutIllegalArgumentError but was of type \(error.self)"
            )
        }
    }

    // MARK: Tests for the discovery of all URLs
    func testDiscoverAllDiscoversAndCachesAllUrls() {
        let expectationToFulfill = expectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups()

        ServiceDiscoveryProvider.discoverAll { result in
            switch result {
            case .success(_):
                XCTAssertNotNil(
                    ServiceDiscoveryProvider.cachedResults[UrlToDiscover.createCardSessions])
                XCTAssertNotNil(
                    ServiceDiscoveryProvider.cachedResults[UrlToDiscover.createCvcSessions])
                XCTAssertNotNil(
                    ServiceDiscoveryProvider.cachedResults[UrlToDiscover.cardBinDetails])

                expectationToFulfill.fulfill()
            case .failure(_):
                XCTFail("Failed to discover all end points")
                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testDiscoverAllCachesOnlySuccessfulUrlsWhenFailing() {
        let expectationToFulfill = expectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups(createCvcSessionsNotFound: true)

        ServiceDiscoveryProvider.discoverAll { result in
            switch result {
            case .success(_):
                XCTFail("Should have failed to discover all URLs")
                expectationToFulfill.fulfill()
            case .failure(_):
                XCTAssertNotNil(
                    ServiceDiscoveryProvider.cachedResults[UrlToDiscover.createCardSessions])
                XCTAssertNil(
                    ServiceDiscoveryProvider.cachedResults[UrlToDiscover.createCvcSessions])
                XCTAssertNotNil(
                    ServiceDiscoveryProvider.cachedResults[UrlToDiscover.cardBinDetails])

                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    // MARK: Tests for the discovery of a single URL
    func
        testDiscoverCardSessionsUrlPerformsDiscoveryOfSessionsServiceAndCardSessionsEndPointAndCompletesWithCreateCardSessionsUrl()
    {
        let expectationToFulfill = expectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups()

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(let discoveredUrl):
                XCTAssertEqual(discoveredUrl, self.expectedCreateCardSessionsUrl)

                // verify calls made with rest client
                self.verifyRestClientHasSentRequest(self.expectedBaseUrlRequest)
                self.verifyRestClientHasSentRequest(self.expectedSessionsServiceRequest)
                verifyNoMoreInteractions(self.restClientMock)

                // verify calls to api response lookup
                self.verifyApiResponseLookUpHasLookedUp(key: ApiLinks.cardSessions.service)
                self.verifyApiResponseLookUpHasLookedUp(key: ApiLinks.cardSessions.endpoint)
                verifyNoMoreInteractions(self.apiResponseLookUpMock)

                expectationToFulfill.fulfill()
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func
        testDiscoverCvcSessionsUrlPerformsDiscoveryOfSessionsServiceAndCvcSessionsEndPointAndCompletesWithCreateCvcSessionsUrl()
    {
        let expectationToFulfill = expectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups()

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCvcSessions) { result in
            switch result {
            case .success(let discoveredUrl):
                XCTAssertEqual(discoveredUrl, self.expectedCreateCvcSessionsUrl)

                // verify calls made with rest client
                self.verifyRestClientHasSentRequest(self.expectedBaseUrlRequest)
                self.verifyRestClientHasSentRequest(self.expectedSessionsServiceRequest)
                verifyNoMoreInteractions(self.restClientMock)

                // verify calls to api response lookup
                self.verifyApiResponseLookUpHasLookedUp(key: ApiLinks.cvcSessions.service)
                self.verifyApiResponseLookUpHasLookedUp(key: ApiLinks.cvcSessions.endpoint)
                verifyNoMoreInteractions(self.apiResponseLookUpMock)

                expectationToFulfill.fulfill()
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func
        testDiscoverCvcSessionsUrlPerformsDiscoveryOfRootAndCvcSessionsEndPointAndCompletesWithCardBinDetailsUrl()
    {
        let expectationToFulfill = expectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups()

        ServiceDiscoveryProvider.discover(UrlToDiscover.cardBinDetails) { result in
            switch result {
            case .success(let discoveredUrl):
                XCTAssertEqual(discoveredUrl, self.expectedCardBinDetailsUrl)

                // verify calls made with rest client
                self.verifyRestClientHasSentRequest(self.expectedBaseUrlRequest)
                verifyNoMoreInteractions(self.restClientMock)

                // verify calls to api response lookup
                self.verifyApiResponseLookUpHasLookedUp(key: ApiLinks.cardBin.service)
                verifyNoMoreInteractions(self.apiResponseLookUpMock)

                expectationToFulfill.fulfill()
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    // MARK - cache tests
    func testDiscoverRetrievesUrlToBeDiscoveredFromCacheWhenItHasAlreadyBeenDiscovered() {
        let expectationToFulfill = expectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups()

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(let discoveredUrl1):
                XCTAssertEqual(discoveredUrl1, self.expectedCreateCardSessionsUrl)

                self.verifyRestClientHasSentRequest(self.expectedBaseUrlRequest, times: 1)
                self.verifyRestClientHasSentRequest(self.expectedSessionsServiceRequest, times: 1)
                verifyNoMoreInteractions(self.restClientMock)

                self.verifyApiResponseLookUpHasLookedUp(
                    key: ApiLinks.cardSessions.service, times: 1)
                self.verifyApiResponseLookUpHasLookedUp(
                    key: ApiLinks.cardSessions.endpoint, times: 1)
                verifyNoMoreInteractions(self.apiResponseLookUpMock)

                ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
                    switch result {
                    case .success(let discoveredUrl2):
                        XCTAssertEqual(discoveredUrl2, self.expectedCreateCardSessionsUrl)

                        // Verify mocks were not called anymore confirming URLs have been taken from cache
                        verifyNoMoreInteractions(self.restClientMock)
                        verifyNoMoreInteractions(self.apiResponseLookUpMock)

                        expectationToFulfill.fulfill()
                    case .failure(_):
                        XCTFail("Discovery should have returned mocked value")
                        expectationToFulfill.fulfill()
                    }
                }
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testDiscoverUsesCachedAccessRootResponseWhenItHasBeenCachedByPreviousCall() {
        let expectationToFulfill = expectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups()

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(let discoveredUrl1):
                ServiceDiscoveryProvider.discover(UrlToDiscover.cardBinDetails) { result in
                    switch result {
                    case .success(let discoveredUrl2):
                        XCTAssertEqual(discoveredUrl1, self.expectedCreateCardSessionsUrl)
                        XCTAssertEqual(discoveredUrl2, self.expectedCardBinDetailsUrl)

                        // verify calls made with rest client
                        self.verifyRestClientHasSentRequest(self.expectedBaseUrlRequest, times: 1)
                        self.verifyRestClientHasSentRequest(
                            self.expectedSessionsServiceRequest, times: 1)
                        verifyNoMoreInteractions(self.restClientMock)

                        // verify calls to api response lookup
                        self.verifyApiResponseLookUpHasLookedUp(key: ApiLinks.cardSessions.service)
                        self.verifyApiResponseLookUpHasLookedUp(key: ApiLinks.cardSessions.endpoint)
                        self.verifyApiResponseLookUpHasLookedUp(key: ApiLinks.cardBin.endpoint)
                        verifyNoMoreInteractions(self.apiResponseLookUpMock)

                        expectationToFulfill.fulfill()
                    case .failure(_):
                        XCTFail("Discovery should have returned mocked value")
                        expectationToFulfill.fulfill()
                    }
                }

            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testDiscoverUsesCachedSessionsServiceResponseWhenItExistsInCache() {
        let expectationToFulfill = expectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups()

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(let discoveredUrl1):
                ServiceDiscoveryProvider.discover(UrlToDiscover.createCvcSessions) { result in
                    switch result {
                    case .success(let discoveredUrl2):
                        XCTAssertEqual(discoveredUrl1, self.expectedCreateCardSessionsUrl)
                        XCTAssertEqual(discoveredUrl2, self.expectedCreateCvcSessionsUrl)

                        // verify calls made with rest client
                        self.verifyRestClientHasSentRequest(self.expectedBaseUrlRequest, times: 1)
                        self.verifyRestClientHasSentRequest(
                            self.expectedSessionsServiceRequest, times: 1)
                        verifyNoMoreInteractions(self.restClientMock)

                        // verify calls to api response lookup
                        self.verifyApiResponseLookUpHasLookedUp(
                            key: ApiLinks.cardSessions.service, times: 2)
                        self.verifyApiResponseLookUpHasLookedUp(key: ApiLinks.cardSessions.endpoint)
                        self.verifyApiResponseLookUpHasLookedUp(
                            key: ApiLinks.cvcSessions.service, times: 2)
                        self.verifyApiResponseLookUpHasLookedUp(key: ApiLinks.cvcSessions.endpoint)
                        verifyNoMoreInteractions(self.apiResponseLookUpMock)

                        expectationToFulfill.fulfill()
                    case .failure(_):
                        XCTFail("Discovery should have returned mocked value")
                        expectationToFulfill.fulfill()
                    }
                }

            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    // Tests that discovery calls are made again after clearing the cache.
    func testShouldSendRequestUsingRestClientAgainWhenCacheIsCleared() {
        let expectationToFulfill = expectation(description: "")
        let nextExpectationToFulfill = XCTestExpectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups()

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(let discoveredUrl):
                XCTAssertEqual(discoveredUrl, self.expectedCreateCardSessionsUrl)

                // verify calls to factory and lookup mocks
                verify(self.restClientMock, times(2)).send(
                    urlSession: any(), request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(2)).lookup(link: any(), in: any())

                expectationToFulfill.fulfill()
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                expectationToFulfill.fulfill()
            }
        }

        // Clearing cache
        ServiceDiscoveryProvider.cachedResponses = [:]
        ServiceDiscoveryProvider.cachedResults = [:]

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(let discoveredUrl):
                XCTAssertEqual(discoveredUrl, self.expectedCreateCardSessionsUrl)

                // verify calls after clearing cached endpoints
                verify(self.restClientMock, times(4)).send(
                    urlSession: any(), request: any(), completionHandler: any())
                verify(self.apiResponseLookUpMock, times(4)).lookup(link: any(), in: any())

                nextExpectationToFulfill.fulfill()
            case .failure(_):
                XCTFail("Discovery should have returned mocked value")
                nextExpectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testErrorResponsesAreNotCached() {
        let expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutError.unexpectedApiError(message: "some error")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses(withAccessRootDiscoveryError: expectedError)
        setUpApiResponseLookups(sessionsServiceNotFound: true)

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(_):
                XCTFail("URL should not have been discovered")
                expectationToFulfill.fulfill()
            case .failure(_):
                self.verifyRestClientHasSentAnyRequest(times: 1)
                verifyNoMoreInteractions(self.restClientMock)

                XCTAssertTrue(ServiceDiscoveryProvider.cachedResponses.isEmpty)

                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testResponseWhereKeyCouldNotBeFoundIsNotCached() {
        let expectationToFulfill = expectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups(createCardSessionsNotFound: true)

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(_):
                XCTFail("URL should not have been discovered")
                expectationToFulfill.fulfill()
            case .failure(_):
                self.verifyRestClientHasSentAnyRequest(times: 2)
                verifyNoMoreInteractions(self.restClientMock)

                XCTAssertFalse(ServiceDiscoveryProvider.cachedResponses.isEmpty)
                XCTAssertNotNil(ServiceDiscoveryProvider.cachedResponses[self.expectedBaseUrl])
                XCTAssertNil(
                    ServiceDiscoveryProvider.cachedResponses[self.expectedSessionsServiceUrl])

                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    // MARK: Test error scenarios
    func testShouldReturnErrorWhenErrorResponseReceivedForRequestToBaseUrl() {
        let expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutError.unexpectedApiError(message: "some error")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses(withAccessRootDiscoveryError: expectedError)
        setUpApiResponseLookups()

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(_):
                XCTFail("URL should not have been discovered")
                expectationToFulfill.fulfill()
            case .failure(let error):
                self.verifyRestClientHasSentAnyRequest(times: 1)
                verifyNoMoreInteractions(self.restClientMock)
                verifyNoMoreInteractions(self.apiResponseLookUpMock)

                XCTAssertEqual(error, expectedError)

                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldReturnErrorWhenErrorResponseReceivedForRequestToSessionsServiceUrl() {
        let expectationToFulfill = expectation(description: "")
        let expectedError = AccessCheckoutError.unexpectedApiError(message: "some error")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses(withSessionsDiscoveryError: expectedError)
        setUpApiResponseLookups()

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(_):
                XCTFail("URL should not have been discovered")
                expectationToFulfill.fulfill()
            case .failure(let error):
                XCTAssertEqual(error, expectedError)

                self.verifyRestClientHasSentAnyRequest(times: 2)
                verifyNoMoreInteractions(self.restClientMock)

                self.verifyApiResponseLookUpHasLookedUp(
                    key: ApiLinks.cardSessions.service, times: 1)
                verifyNoMoreInteractions(self.apiResponseLookUpMock)

                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldReturnAnErrorWhenUnableToFindSessionsServiceUrlInBaseUrlResponse() {
        let expectationToFulfill = expectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups(sessionsServiceNotFound: true)

        let expectedError = AccessCheckoutError.discoveryLinkNotFound(
            linkName: ApiLinks.cardSessions.service)

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(_):
                XCTFail("Sessions card url should not have been found")
                expectationToFulfill.fulfill()
            case .failure(let error):
                XCTAssertEqual(error, expectedError)

                self.verifyRestClientHasSentAnyRequest(times: 1)
                verifyNoMoreInteractions(self.restClientMock)

                self.verifyApiResponseLookUpHasLookedUp(
                    key: ApiLinks.cardSessions.service, times: 1)
                verifyNoMoreInteractions(self.apiResponseLookUpMock)

                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldReturnAnErrorWhenUnableToFindCardBindDetailsUrlInBaseUrlResponse() {
        let expectationToFulfill = expectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups(cardBinDetailsNotFound: true)

        let expectedError = AccessCheckoutError.discoveryLinkNotFound(
            linkName: ApiLinks.cardBin.service)

        ServiceDiscoveryProvider.discover(UrlToDiscover.cardBinDetails) { result in
            switch result {
            case .success(_):
                XCTFail("Card bin details url should not have been found")
                expectationToFulfill.fulfill()
            case .failure(let error):
                XCTAssertEqual(error, expectedError)

                self.verifyRestClientHasSentAnyRequest(times: 1)
                verifyNoMoreInteractions(self.restClientMock)

                self.verifyApiResponseLookUpHasLookedUp(key: ApiLinks.cardBin.service, times: 1)
                verifyNoMoreInteractions(self.apiResponseLookUpMock)

                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldReturnAnErrorWhenUnableToFindSessionsCardUrlInSessionsServiceResponse() {
        let expectationToFulfill = expectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups(createCardSessionsNotFound: true)

        let expectedError = AccessCheckoutError.discoveryLinkNotFound(
            linkName: ApiLinks.cardSessions.endpoint)

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCardSessions) { result in
            switch result {
            case .success(_):
                XCTFail("Sessions card url should not have been found")
                expectationToFulfill.fulfill()
            case .failure(let error):
                self.verifyRestClientHasSentAnyRequest(times: 2)
                verifyNoMoreInteractions(self.restClientMock)

                self.verifyApiResponseLookUpHasLookedUp(
                    key: ApiLinks.cardSessions.service, times: 1)
                self.verifyApiResponseLookUpHasLookedUp(
                    key: ApiLinks.cardSessions.endpoint, times: 1)
                verifyNoMoreInteractions(self.apiResponseLookUpMock)

                XCTAssertEqual(error, expectedError)

                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    func testShouldReturnErrorWhenUnableToFindSessionsCvcUrlInSessionsServiceResponse() {
        let expectationToFulfill = expectation(description: "")
        initialiseServiceDiscovery()
        setUpDiscoveryResponses()
        setUpApiResponseLookups(createCvcSessionsNotFound: true)

        let expectedError = AccessCheckoutError.discoveryLinkNotFound(
            linkName: ApiLinks.cvcSessions.endpoint)

        ServiceDiscoveryProvider.discover(UrlToDiscover.createCvcSessions) { result in
            switch result {
            case .success(_):
                XCTFail("Sessions cvc url should not have been found")
                expectationToFulfill.fulfill()
            case .failure(let error):
                self.verifyRestClientHasSentAnyRequest(times: 2)
                self.verifyApiResponseLookUpHasLookedUp(key: ApiLinks.cvcSessions.service, times: 1)
                self.verifyApiResponseLookUpHasLookedUp(
                    key: ApiLinks.cvcSessions.endpoint, times: 1)

                XCTAssertEqual(error, expectedError)

                expectationToFulfill.fulfill()
            }
        }

        waitForExpectations(timeout: 1)
    }

    private func verifyRestClientHasSentAnyRequest(times numberOfCalls: Int = 1) {
        verify(self.restClientMock, times(numberOfCalls)).send(
            urlSession: any(), request: any(), completionHandler: any())
    }

    private func verifyRestClientHasSentRequest(
        _ urlRequest: URLRequest, times numberOfCalls: Int = 1
    ) {
        verify(self.restClientMock, times(numberOfCalls)).send(
            urlSession: any(), request: urlRequest, completionHandler: any())
    }

    private func verifyApiResponseLookUpHasLookedUp(key: String, times numberOfCalls: Int = 1) {
        verify(self.apiResponseLookUpMock, times(numberOfCalls)).lookup(link: key, in: any())
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

        restClientMock.getStubbingProxy()
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
        sessionsServiceNotFound: Bool = false,
        cardBinDetailsNotFound: Bool = false,
        createCardSessionsNotFound: Bool = false,
        createCvcSessionsNotFound: Bool = false
    ) {
        let sessionsUrl = sessionsServiceNotFound ? nil : expectedSessionsServiceUrl.absoluteString
        let cardBinUrl = cardBinDetailsNotFound ? nil : expectedCardBinDetailsUrl.absoluteString
        let createdCardSessionsUrl =
            createCardSessionsNotFound ? nil : expectedCreateCardSessionsUrl.absoluteString
        let createCvcSessionsUrl =
            createCvcSessionsNotFound ? nil : expectedCreateCvcSessionsUrl.absoluteString

        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardSessions.service, in: any())
            .thenReturn(sessionsUrl)
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardBin.service, in: any())
            .thenReturn(cardBinUrl)
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardSessions.endpoint, in: any())
            .thenReturn(createdCardSessionsUrl)
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cvcSessions.endpoint, in: any())
            .thenReturn(createCvcSessionsUrl)
    }

    private func genericApiResponse() -> ApiResponse {
        let jsonString = """
            {
                "_links": {
                    "a:service": {
                        "href": "https://www.example.com"
                    },
                },
            }
            """

        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }

    private func accessRootResponse() -> ApiResponse {
        let jsonString = """
            {
                "_links": {
                    "sessions:service": {
                        "href": "\(expectedSessionsServiceUrl.absoluteString)"
                    },
                    "cardBinPublic:binDetails": {
                        "href": "\(expectedCardBinDetailsUrl.absoluteString)"
                    }
                },
            }
            """

        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }

    private func sessionsServiceResponse() -> ApiResponse {
        let jsonString = """
            {
                "_links": {
                    "sessions:card": {
                        "href": "\(expectedCreateCardSessionsUrl.absoluteString)"
                    },
                    "sessions:paymentsCvc": {
                        "href": "\(expectedCreateCvcSessionsUrl.absoluteString)"
                    },
                },
            }
            """

        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }

    private func initialiseServiceDiscovery() {
        try? ServiceDiscoveryProvider.initialise(
            baseUrlAsString, restClientMock, apiResponseLookUpMock)
    }
}
