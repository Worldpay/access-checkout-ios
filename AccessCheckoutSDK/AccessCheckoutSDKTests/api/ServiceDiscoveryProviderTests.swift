import XCTest

@testable import AccessCheckoutSDK

class ServiceDiscoveryProviderTests: XCTestCase {
    let factoryMock = ServiceDiscoveryFactoryMock()
    let apiResponseLookUpMock = ApiResponseLinkLookupMock()

    func testShouldCallBaseDiscoveryAndSessionsDiscovery() {
        let baseDiscovryResponse = toBaseDiscoveryResponse()
        let sessionsDiscoveryResponse = toSessionsDiscoveryResponse()

        factoryMock.mockReturnValue = [
            baseDiscovryResponse,
            sessionsDiscoveryResponse,
        ]

        apiResponseLookUpMock.mockReturnValue = [
            "validBaseSessionsValue", "validSessionsCardHref", "validSessionsCvcHref",
        ]

        let expectedBaseRequest = URLRequest(url: URL(string: "some-url")!)
        var expectedSessionsRequest = URLRequest(
            url: URL(string: "validBaseSessionsValue")!)
        expectedSessionsRequest.addValue(
            ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "content-type")
        expectedSessionsRequest.addValue(
            ApiHeaders.sessionsHeaderValue, forHTTPHeaderField: "accept")

        // initialise provider
        let serviceDiscoveryProvider = ServiceDiscoveryProvider(
            baseUrl: "some-url", factoryMock, apiResponseLookUpMock)

        // call method
        serviceDiscoveryProvider.discover()

        // do assertions
        let base = serviceDiscoveryProvider.getBaseDiscovery()
        let cardHref = serviceDiscoveryProvider.getSessionsCardDiscovery()
        let cvcHref = serviceDiscoveryProvider.getSessionsCvcDiscovery()

        // verify factory was called correctly
        XCTAssertEqual(factoryMock.getDiscoveryCalledCount, 2)
        XCTAssertTrue(factoryMock.requestsSent.contains(expectedBaseRequest))
        XCTAssertTrue(factoryMock.requestsSent.contains(expectedSessionsRequest))

        // verify api response lookup was called correctly
        XCTAssertEqual(apiResponseLookUpMock.lookupMethodCalledCount, 3)
        XCTAssertEqual(
            apiResponseLookUpMock.lookupLinks,
            [
                "service:sessions",
                "sessions:card",
                "sessions:paymentsCvc",
            ])

        // verify class parameters have correct values
        XCTAssertEqual(
            baseDiscovryResponse.links.endpoints["service:sessions"]?.href,
            base?.links.endpoints["service:sessions"]?.href)
        XCTAssertEqual(cardHref, "validSessionsCardHref")
        XCTAssertEqual(cvcHref, "validSessionsCvcHref")
    }

    func testShouldNotCallSessionsDiscoveryIfBaseDiscoveryFails() {
        // Simulate base discovery failure
        factoryMock.mockReturnValue = [nil]

        let serviceDiscoveryProvider = ServiceDiscoveryProvider(
            baseUrl: "some-url", factoryMock, apiResponseLookUpMock)

        serviceDiscoveryProvider.discover()

        XCTAssertEqual(factoryMock.getDiscoveryCalledCount, 1)
        XCTAssertNil(serviceDiscoveryProvider.getBaseDiscovery())
    }

    func testShouldNotCallSessionsDiscoveryIfBaseDiscoveryDoesNotHaveSessionsKey() {
        factoryMock.mockReturnValue = [toBaseDiscoveryResponse()]

        // Simulate no sessions service key in baseDiscovryResponse
        apiResponseLookUpMock.mockReturnValue = [nil]

        let serviceDiscoveryProvider = ServiceDiscoveryProvider(
            baseUrl: "some-url", factoryMock, apiResponseLookUpMock)

        serviceDiscoveryProvider.discover()

        XCTAssertEqual(factoryMock.getDiscoveryCalledCount, 1)
        XCTAssertEqual(apiResponseLookUpMock.lookupMethodCalledCount, 1)
        XCTAssertEqual(apiResponseLookUpMock.lookupLinks, ["service:sessions"])
    }

    func testShouldReturnNilWhenUnableToPerformSessionsDiscoveryRequest() {
        factoryMock.mockReturnValue = [
            toBaseDiscoveryResponse(),
            nil,  // sessions discovery request fails
        ]

        let apiResponseLookUpMock = ApiResponseLinkLookupMock()
        apiResponseLookUpMock.mockReturnValue = ["someKey"]

        let serviceDiscoveryProvider = ServiceDiscoveryProvider(
            baseUrl: "some-url", factoryMock, apiResponseLookUpMock)

        serviceDiscoveryProvider.discover()

        XCTAssertEqual(factoryMock.getDiscoveryCalledCount, 2)
        XCTAssertEqual(apiResponseLookUpMock.lookupMethodCalledCount, 1)
        XCTAssertNil(serviceDiscoveryProvider.getSessionsCardDiscovery())
        XCTAssertNil(serviceDiscoveryProvider.getSessionsCvcDiscovery())
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
