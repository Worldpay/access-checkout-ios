import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class CardBinServiceTests: XCTestCase {

    private var mockClient: MockCardBinApiClient!
    private var mockFactory: CardBrandsConfigurationFactoryMock!
    private var mockConfigurationProvider: MockCardBrandsConfigurationProvider!
    private var cardBinService: CardBinService!

    private let checkoutId = "00000000-0000-0000-000000000000"
    private let baseURL = "some-url"
    private let visaTestPan = "444433332222"
    private let discoverDinersTestPan = "601100040000"

    override func setUp() {

        mockClient = MockCardBinApiClient(url: baseURL)
        mockFactory = CardBrandsConfigurationFactoryMock()
        mockConfigurationProvider = MockCardBrandsConfigurationProvider(mockFactory)

        stub(mockConfigurationProvider) { stub in
            when(stub.get()).thenReturn(TestFixtures.createDefaultCardConfiguration())
        }

        cardBinService = CardBinService(
            checkoutId: checkoutId,
            baseURL: baseURL,
            client: mockClient,
            configurationProvider: mockConfigurationProvider
        )
    }

    override func tearDown() {
        mockClient = nil
        mockConfigurationProvider = nil
        cardBinService = nil
    }

    func testShouldInstantiateCardBinServiceWithDefaultClient() {
        let client = CardBinApiClient(url: baseURL)
        let configurationProvider = MockCardBrandsConfigurationProvider(mockFactory)
        let service = CardBinService(
            checkoutId: "testCheckoutId",
            baseURL: baseURL,
            client: client,
            configurationProvider: configurationProvider
        )
        XCTAssertNotNil(service)
    }

    func testShouldReturnDistinctListOfBrandsWhenServiceRespondsWithBrands() {
        let expectation = self.expectation(
            description:
                "should return a distinct list of brands when card-bin-service responds with brands"
        )
        let visaBrand = TestFixtures.visaBrand()
        let response = CardBinResponse(
            brand: ["visa"],
            fundingType: "debit",
            luhnCompliant: true
        )

        stub(mockClient) { stub in
            stub.abort().thenDoNothing()

            when(
                stub.retrieveBinInfo(
                    cardNumber: any(),
                    checkoutId: any(),
                    completionHandler: any()
                )
            ).then { _, _, completion in
                completion(.success(response))
            }
        }

        var receivedBrands: [CardBrandModel]?
        cardBinService.getCardBrands(
            globalBrand: visaBrand,
            cardNumber: visaTestPan
        ) { result in
            if case .success(let brands) = result {
                receivedBrands = brands
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(receivedBrands)
            XCTAssertEqual(receivedBrands?.count, 1)
            XCTAssertEqual(receivedBrands?.first?.name, "visa")
        }
    }

    func testShouldInvokeCallbackWhenResponseContainsMultipleBrands() {
        let expectation = self.expectation(
            description:
                "should invoke callback when card-bin-service response contains multiple brands")
        let discoverBrand = TestFixtures.discoverBrand()
        let response = CardBinResponse(
            brand: ["discover", "diners"],
            fundingType: "debit",
            luhnCompliant: true
        )

        stub(mockClient) { stub in
            stub.abort().thenDoNothing()

            when(
                stub.retrieveBinInfo(
                    cardNumber: any(),
                    checkoutId: any(),
                    completionHandler: any()
                )
            ).then { _, _, completion in
                completion(.success(response))
            }
        }

        var receivedBrands: [CardBrandModel]?
        cardBinService.getCardBrands(
            globalBrand: discoverBrand,
            cardNumber: discoverDinersTestPan
        ) { result in
            if case .success(let brands) = result {
                receivedBrands = brands
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(receivedBrands?.count, 2)
            let brandNames = receivedBrands?.map { $0.name }
            XCTAssertTrue(brandNames!.contains("discover"))
            XCTAssertTrue(brandNames!.contains("diners"))
        }
    }

    func testShouldInvokeCallbackWhenResponseReturnsNoBrandsForPan() {
        let expectation = self.expectation(
            description: "should invoke callback when response returns no brands for pan")
        let discoverBrand = TestFixtures.discoverBrand()
        let response = CardBinResponse(
            brand: [],
            fundingType: "debit",
            luhnCompliant: true
        )

        stub(mockClient) { stub in
            stub.abort().thenDoNothing()

            when(
                stub.retrieveBinInfo(
                    cardNumber: any(),
                    checkoutId: any(),
                    completionHandler: any()
                )
            ).then { _, _, completion in
                completion(.success(response))
            }
        }

        var receivedBrands: [CardBrandModel]?
        cardBinService.getCardBrands(
            globalBrand: discoverBrand,
            cardNumber: discoverDinersTestPan
        ) { result in
            if case .success(let brands) = result {
                receivedBrands = brands
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(receivedBrands)
            XCTAssertEqual(receivedBrands?.count, 1)
            XCTAssertEqual(receivedBrands?.first?.name, "discover")
        }
    }

    func testShouldInvokeCallbackWhenResponseReturnsSingleBrand() {
        let expectation = self.expectation(
            description: "should invoke callback when response returns a single brand")
        let discoverBrand = TestFixtures.discoverBrand()
        let response = CardBinResponse(
            brand: ["discover"],
            fundingType: "debit",
            luhnCompliant: true
        )

        stub(mockClient) { stub in
            stub.abort().thenDoNothing()

            when(
                stub.retrieveBinInfo(
                    cardNumber: any(),
                    checkoutId: any(),
                    completionHandler: any()
                )
            ).then { _, _, completion in
                completion(.success(response))
            }
        }

        var receivedBrands: [CardBrandModel]?
        cardBinService.getCardBrands(
            globalBrand: discoverBrand,
            cardNumber: discoverDinersTestPan
        ) { result in
            if case .success(let brands) = result {
                receivedBrands = brands
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(receivedBrands)
            XCTAssertEqual(receivedBrands?.count, 1)
            XCTAssertEqual(receivedBrands?.first?.name, "discover")
        }
    }

    func testShouldInvokeCallbackWhenResponseReturnsSinglePanButDoesNotMatchGlobalBrand() {
        let expectation = self.expectation(
            description:
                "should invoke callback with both brands when response returns a single pan but does not match global brand"
        )
        let discoverBrand = TestFixtures.discoverBrand()
        let response = CardBinResponse(
            brand: ["mastercard"],
            fundingType: "debit",
            luhnCompliant: true
        )

        stub(mockClient) { stub in
            stub.abort().thenDoNothing()

            when(
                stub.retrieveBinInfo(
                    cardNumber: any(),
                    checkoutId: any(),
                    completionHandler: any()
                )
            ).then { _, _, completion in
                completion(.success(response))
            }
        }

        var receivedBrands: [CardBrandModel]?
        cardBinService.getCardBrands(
            globalBrand: discoverBrand,
            cardNumber: discoverDinersTestPan
        ) { result in
            if case .success(let brands) = result {
                receivedBrands = brands
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(receivedBrands?.count, 2)
            let brandNames = receivedBrands?.map { $0.name }
            XCTAssertTrue(brandNames!.contains("discover"))
            XCTAssertTrue(brandNames!.contains("mastercard"))
        }
    }

    func testShouldReturnBrandsWithDefaultValidationRulesWhenGlobalBrandIsNil() {
        let expectation = self.expectation(
            description:
                "should return brands with default validation rules when globalBrand was null")
        let response = CardBinResponse(
            brand: ["discovery"],
            fundingType: "debit",
            luhnCompliant: true
        )

        stub(mockClient) { stub in
            stub.abort().thenDoNothing()

            when(
                stub.retrieveBinInfo(
                    cardNumber: any(),
                    checkoutId: any(),
                    completionHandler: any()
                )
            ).then { _, _, completion in
                completion(.success(response))
            }
        }

        var receivedBrands: [CardBrandModel]?
        cardBinService.getCardBrands(
            globalBrand: nil,
            cardNumber: discoverDinersTestPan
        ) { result in
            if case .success(let brands) = result {
                receivedBrands = brands
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(receivedBrands?.count, 1)
            let brand = receivedBrands?.first
            XCTAssertEqual(brand?.name, "discovery")
            let defaults = ValidationRulesDefaults.instance()
            XCTAssertEqual(brand?.cvcValidationRule, defaults.cvc)
            XCTAssertEqual(brand?.panValidationRule, defaults.pan)
        }
    }

    func testShouldReturnEmptyListWhenGlobalBrandIsNilAndResponseBrandsIsEmpty() {
        let expectation = self.expectation(
            description:
                "should return emptyList when globalBrand was null and card-bin-service response brands was empty"
        )
        let response = CardBinResponse(
            brand: [],
            fundingType: "debit",
            luhnCompliant: true
        )

        stub(mockClient) { stub in
            stub.abort().thenDoNothing()

            when(
                stub.retrieveBinInfo(
                    cardNumber: any(),
                    checkoutId: any(),
                    completionHandler: any()
                )
            ).then { _, _, completion in
                completion(.success(response))
            }
        }

        var receivedBrands: [CardBrandModel]?
        cardBinService.getCardBrands(
            globalBrand: nil,
            cardNumber: discoverDinersTestPan
        ) { result in
            if case .success(let brands) = result {
                receivedBrands = brands
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(receivedBrands)
            XCTAssertEqual(receivedBrands?.count, 0)
            XCTAssertTrue(receivedBrands?.isEmpty ?? false)
        }
    }

    func testShouldNotCallCompletionHandlerWhenApiClientFails() {
        var calledCompletionHandler = false

        stub(mockClient) { stub in
            stub.abort().thenDoNothing()

            when(
                stub.retrieveBinInfo(
                    cardNumber: any(),
                    checkoutId: any(),
                    completionHandler: any()
                )
            ).then { _, _, completion in
                completion(
                    .failure(AccessCheckoutError.unexpectedApiError(message: "Network error")))
            }
        }

        cardBinService.getCardBrands(
            globalBrand: TestFixtures.discoverBrand(),
            cardNumber: discoverDinersTestPan
        ) { _ in
            calledCompletionHandler = true
        }

        Thread.sleep(forTimeInterval: 0.2)

        XCTAssertFalse(calledCompletionHandler)
    }

    func testShouldCallAbortAndRetrieveBinInfoOnClientWhenRequestIsMade() {

        stub(mockClient) { stub in
            when(stub.abort()).thenDoNothing()

            when(
                stub.retrieveBinInfo(
                    cardNumber: any(),
                    checkoutId: any(),
                    completionHandler: any()
                )
            ).then { _, _, completion in
            }
        }

        cardBinService.getCardBrands(
            globalBrand: TestFixtures.visaBrand(),
            cardNumber: visaTestPan
        ) { _ in }

        Thread.sleep(forTimeInterval: 0.2)
        verify(self.mockClient).abort()
        verify(self.mockClient).retrieveBinInfo(
            cardNumber: any(),
            checkoutId: any(),
            completionHandler: any()
        )
    }

    func testShouldNotErrorWhenCallingClientAbortMethodIfNoCurrentRequestExists() {
        let expectation = self.expectation(
            description: "should handle abort when no current request exists"
        )

        let response = CardBinResponse(
            brand: ["visa"],
            fundingType: "debit",
            luhnCompliant: true
        )

        var abortCallCount = 0

        stub(mockClient) { stub in
            when(stub.abort()).then {
                abortCallCount += 1
            }

            when(
                stub.retrieveBinInfo(
                    cardNumber: any(),
                    checkoutId: any(),
                    completionHandler: any()
                )
            ).then { _, _, completion in
                completion(.success(response))
            }
        }

        cardBinService.getCardBrands(
            globalBrand: nil,
            cardNumber: visaTestPan
        ) { _ in
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(abortCallCount, 1, "Abort method is called (safe no-op)")
            verify(self.mockClient, times(1)).abort()
        }
    }

    func testShouldAbortPreviousClientRequestAndOnlyCompleteSecondRequest() {
        let secondResponse = CardBinResponse(
            brand: ["visa"],
            fundingType: "debit",
            luhnCompliant: true
        )

        var callCount = 0

        stub(mockClient) { stub in
            when(stub.abort()).thenDoNothing()

            when(
                stub.retrieveBinInfo(
                    cardNumber: any(),
                    checkoutId: any(),
                    completionHandler: any()
                )
            ).then { _, _, completion in
                callCount += 1
                if callCount == 1 {
                    // simulating hanging request
                } else if callCount == 2 {
                    completion(.success(secondResponse))
                }
            }
        }

        cardBinService.getCardBrands(
            globalBrand: TestFixtures.visaBrand(),
            cardNumber: visaTestPan
        ) { _ in
        }

        cardBinService.getCardBrands(
            globalBrand: TestFixtures.visaBrand(),
            cardNumber: visaTestPan
        ) { result in
            if case .success(let brands) = result {
                XCTAssertEqual(brands.count, 1)
                XCTAssertEqual(brands.first?.name, "visa")
            }
        }

        verify(self.mockClient, atLeastOnce()).abort()

        verify(self.mockClient, times(2)).retrieveBinInfo(
            cardNumber: any(),
            checkoutId: any(),
            completionHandler: any()
        )

    }
}
