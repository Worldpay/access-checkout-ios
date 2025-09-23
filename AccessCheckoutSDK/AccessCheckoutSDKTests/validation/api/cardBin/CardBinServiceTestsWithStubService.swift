import Cuckoo
import Foundation
import Swifter
import XCTest

@testable import AccessCheckoutSDK

class CardBinServiceTestsWithStubService: XCTestCase {
    private var serviceStubs: ServiceStubs = ServiceStubs()
    private var mockFactory: CardBrandsConfigurationFactoryMock!
    private var mockConfigurationProvider: MockCardBrandsConfigurationProvider!
    private var cardBinService: CardBinService!

    let restClient = MockRetryRestClientDecorator<ApiResponse>()
    let apiResponseLookUpMock = MockApiResponseLinkLookup()

    private let checkoutId = "00000000-0000-0000-000000000000"
    private let visaTestPan = "444433332222"

    override func setUp() {
        serviceStubs = ServiceStubs()
        mockFactory = CardBrandsConfigurationFactoryMock()
        mockConfigurationProvider = MockCardBrandsConfigurationProvider(mockFactory)

        stub(mockConfigurationProvider) { stub in
            when(stub.get()).thenReturn(TestFixtures.createDefaultCardConfiguration())
        }

        try? ServiceDiscoveryProvider.initialise("some-url", restClient, apiResponseLookUpMock)
        ServiceDiscoveryProvider.sharedInstance?.clearCache()

        setUpDiscoveryResponses()
        setUpApiResponseLookups()

        let cardBinApiClient = CardBinApiClient()

        cardBinService = CardBinService(
            checkoutId: checkoutId,
            client: cardBinApiClient,
            configurationProvider: mockConfigurationProvider
        )
    }

    override func tearDown() {
        serviceStubs.stop()
        ServiceDiscoveryProvider.sharedInstance?.clearCache()
    }

    func testServiceCancelsFirstRequestAndOnlyCompletesSecond_withSwifter() {
        let expectation = self.expectation(description: "Discovery should complete")

        ServiceDiscoveryProvider.discover { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        let cardBinResponse = """
            {
                "brand": ["visa"],
                "fundingType": "debit",
                "luhnCompliant": true
            }
            """

        serviceStubs.post200(path: "/somewhere", textResponse: cardBinResponse, delayInSeconds: 0.2)
            .start()

        let firstExpectation = self.expectation(description: "First call should not complete ")
        firstExpectation.isInverted = true
        let secondExpectation = self.expectation(
            description: "Second call should complete successfully")

        cardBinService.getCardBrands(
            globalBrand: TestFixtures.visaBrand(),
            cardNumber: "444433332222"
        ) { result in
            firstExpectation.fulfill()
        }

        Thread.sleep(forTimeInterval: 0.05)

        cardBinService.getCardBrands(
            globalBrand: TestFixtures.visaBrand(),
            cardNumber: "444455556666"
        ) { result in
            if case .success(let brands) = result {
                XCTAssertEqual(brands.count, 1)
                XCTAssertEqual(brands.first?.name, "visa")
            } else {
                XCTFail("Expected success but got failure")
            }
            secondExpectation.fulfill()
        }

        wait(for: [firstExpectation, secondExpectation], timeout: 1.0)
    }

    private func setUpDiscoveryResponses() {
        restClient.getStubbingProxy()
            .send(urlSession: any(), request: any(), completionHandler: any())
            .then { _, _, completionHandler in
                completionHandler(.success(self.accessRootApiResponse()), nil)
                return URLSessionTask()
            }.then { _, _, completionHandler in
                completionHandler(.success(self.sessionsApiResponse()), nil)
                return URLSessionTask()
            }
    }

    private func setUpApiResponseLookups() {
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardSessions.service, in: any())
            .thenReturn("sessions-service-url")
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardBin.service, in: any())
            .thenReturn("\(serviceStubs.baseUrl)/somewhere")
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cardSessions.endpoint, in: any())
            .thenReturn("sessions-card-href")
        apiResponseLookUpMock.getStubbingProxy()
            .lookup(link: ApiLinks.cvcSessions.endpoint, in: any())
            .thenReturn("sessions-cvc-href")
    }

    private func accessRootApiResponse() -> ApiResponse {
        let jsonString = """
            {
                "_links": {
                    "service:sessions": {
                        "href": "sessions-service-url"
                    },
                    "service:card-bin": {
                        "href": "\(serviceStubs.baseUrl)/somewhere"
                    }
                }
            }
            """
        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }

    private func sessionsApiResponse() -> ApiResponse {
        let jsonString = """
            {
                "_links": {
                    "sessions:card": {
                        "href": "sessions-card-href"
                    },
                    "sessions:cvc": {
                        "href": "sessions-cvc-href"
                    }
                }
            }
            """
        let data = Data(jsonString.utf8)
        return try! JSONDecoder().decode(ApiResponse.self, from: data)
    }
}
