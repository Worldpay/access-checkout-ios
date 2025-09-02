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

    private let checkoutId = "00000000-0000-0000-000000000000"
    private let visaTestPan = "444433332222"

    override func setUp() {
        serviceStubs = ServiceStubs()
        mockFactory = CardBrandsConfigurationFactoryMock()
        mockConfigurationProvider = MockCardBrandsConfigurationProvider(mockFactory)

        stub(mockConfigurationProvider) { stub in
            when(stub.get()).thenReturn(TestFixtures.createDefaultCardConfiguration())
        }

        let cardBinApiClient = CardBinApiClient(
            endpointProvider: { "\(self.serviceStubs.baseUrl)/somewhere" }
        )

        cardBinService = CardBinService(
            checkoutId: checkoutId,
            client: cardBinApiClient,
            configurationProvider: mockConfigurationProvider
        )
    }

    override func tearDown() {
        cardBinService = nil
        serviceStubs.stop()
    }

    /*
     This test is designed to:
     - use a stub server with delayed response
     - make a first call that will be aborted
     - make a second call that will complete successfully
     - verify that only the second completion handler is called
     */
    func testServiceCancelsFirstRequestAndOnlyCompletesSecond_withSwifter() {
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
        // we expect this to not be fulfilled as it should be an aborted call
        firstExpectation.isInverted = true
        let secondExpectation = self.expectation(
            description: "Second call should complete successfully")

        cardBinService.getCardBrands(
            globalBrand: TestFixtures.visaBrand(),
            cardNumber: "444433332222"
        ) { result in
            firstExpectation.fulfill()
        }

        // small delay to ensure first request is in flight
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

        // should pass if first expectation does not to fulfill (inverted expectation) and second expectation does fulfill
        wait(for: [firstExpectation, secondExpectation], timeout: 1.0)

    }
}
