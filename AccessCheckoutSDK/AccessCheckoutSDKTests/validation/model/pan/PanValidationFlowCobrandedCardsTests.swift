import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class PanValidationFlowCobrandedCardsTests: XCTestCase {

    private var mockPanValidator: MockPanValidator!
    private var mockPanValidationStateHandler: MockPanValidationStateHandler!
    private var mockCvcFlow: MockCvcValidationFlow!
    private var mockCardBinService: MockCardBinService!
    private var panValidationFlow: PanValidationFlow!

    private let visaBrand = TestFixtures.visaBrand()
    private let maestroBrand = TestFixtures.maestroBrand()
    private let amexBrand = TestFixtures.amexBrand()

    override func setUp() {
        super.setUp()

        let configurationProvider = MockCardBrandsConfigurationProvider(
            CardBrandsConfigurationFactoryMock()
        )
        mockPanValidator = MockPanValidator(configurationProvider)
        mockPanValidationStateHandler = MockPanValidationStateHandler()
        mockCvcFlow = MockCvcValidationFlow(
            MockCvcValidator(),
            MockCvcValidationStateHandler()
        )
        mockCardBinService = MockCardBinService(
            checkoutId: "0000-0000-0000-0000-000000000000",
            client: MockCardBinApiClient(),
            configurationProvider: configurationProvider
        )

        panValidationFlow = PanValidationFlow(
            mockPanValidator,
            mockPanValidationStateHandler,
            mockCvcFlow,
            mockCardBinService
        )

        stub(mockPanValidationStateHandler) { stub in
            when(stub.getCardBrands()).thenReturn([])
            when(stub.areCardBrandsDifferentFrom(cardBrands: any())).thenReturn(false)
            when(stub.updateCardBrandsIfChanged(cardBrands: any())).thenDoNothing()
        }

        stub(mockCvcFlow) { stub in
            when(stub.updateValidationRule(with: any())).thenDoNothing()
            when(stub.resetValidationRule()).thenDoNothing()
            when(stub.revalidate()).thenDoNothing()
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Validation Tests

    func testHandleCobrandedCards_withShortPan_doesNotCallService() {
        panValidationFlow.handleCobrandedCards(pan: "")
        panValidationFlow.handleCobrandedCards(pan: "44443333")

        verifyNoMoreInteractions(mockCardBinService)
    }

    func testHandleCobrandedCards_sanitisesAndUsesCorrectGlobalBrand() {
        let panWithSpaces = "4444 3333 2222 1111"
        let expectedSanitised = "444433332222"

        stub(mockPanValidationStateHandler) { stub in
            when(stub.getCardBrands()).thenReturn([self.visaBrand])
        }

        stub(mockCardBinService) { stub in
            when(
                stub.getCardBrands(
                    globalBrand: equal(to: self.visaBrand),
                    cardNumber: equal(to: expectedSanitised),
                    completion: any()
                )
            ).then { _, _, completion in
                completion(.success([self.visaBrand]))
            }
        }

        panValidationFlow.handleCobrandedCards(pan: panWithSpaces)

        verify(mockCardBinService).getCardBrands(
            globalBrand: equal(to: visaBrand),
            cardNumber: equal(to: expectedSanitised),
            completion: any()
        )
    }

    func testHandleCobrandedCards_cachesPrefix_onlyCallsServiceOnce() {
        stub(mockPanValidationStateHandler) { stub in
            when(stub.getCardBrands()).thenReturn([])
        }

        stub(mockCardBinService) { stub in
            when(
                stub.getCardBrands(
                    globalBrand: any(),
                    cardNumber: any(),
                    completion: any()
                )
            ).then { _, _, completion in
                completion(.success([]))
            }
        }

        panValidationFlow.handleCobrandedCards(pan: "444433332222111")
        panValidationFlow.handleCobrandedCards(pan: "444433332222999")

        verify(mockCardBinService, times(1)).getCardBrands(
            globalBrand: any(),
            cardNumber: any(),
            completion: any()
        )

        panValidationFlow.handleCobrandedCards(pan: "555544443333")

        verify(mockCardBinService, times(2)).getCardBrands(
            globalBrand: any(),
            cardNumber: any(),
            completion: any()
        )
    }

    // MARK: - Brand Update and CVC Rule Tests

    func testHandleCobrandedCards_whenBrandsChange_updatesHandlerAndCvcRules() {
        let pan = "444433332222"
        let returnedBrands = [visaBrand, maestroBrand]
        let expectation = XCTestExpectation(description: "Card bin service callback")

        stub(mockPanValidationStateHandler) { stub in
            when(stub.getCardBrands()).thenReturn([])
            when(stub.areCardBrandsDifferentFrom(cardBrands: equal(to: returnedBrands)))
                .thenReturn(true)
            when(stub.updateCardBrandsIfChanged(cardBrands: equal(to: returnedBrands)))
                .then { _ in
                    expectation.fulfill()
                }
        }

        stub(mockCardBinService) { stub in
            when(
                stub.getCardBrands(
                    globalBrand: any(),
                    cardNumber: equal(to: pan),
                    completion: any())
            ).then { _, _, completion in
                completion(.success(returnedBrands))
            }
        }

        panValidationFlow.handleCobrandedCards(pan: pan)

        wait(for: [expectation], timeout: 1.0)

        // Verifies first brand's CVC rule is used
        verify(mockCvcFlow).updateValidationRule(with: visaBrand.cvcValidationRule)
        verify(mockCvcFlow).revalidate()
        verify(mockPanValidationStateHandler).updateCardBrandsIfChanged(
            cardBrands: equal(to: returnedBrands))
    }

    func testHandleCobrandedCards_whenBrandsAreSame_doesNotUpdate() {
        let pan = "444433332222"
        let currentBrands = [visaBrand]

        stub(mockPanValidationStateHandler) { stub in
            when(stub.getCardBrands()).thenReturn(currentBrands)
            when(stub.areCardBrandsDifferentFrom(cardBrands: equal(to: currentBrands)))
                .thenReturn(false)
        }

        stub(mockCardBinService) { stub in
            when(
                stub.getCardBrands(
                    globalBrand: equal(to: self.visaBrand),
                    cardNumber: equal(to: pan),
                    completion: any())
            ).then { _, _, completion in
                completion(.success(currentBrands))
            }
        }

        panValidationFlow.handleCobrandedCards(pan: pan)

        let expectation = XCTestExpectation(description: "Card bin service callback")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)

        verify(mockCvcFlow, never()).updateValidationRule(with: any())
        verify(mockCvcFlow, never()).revalidate()
        verify(mockPanValidationStateHandler, never()).updateCardBrandsIfChanged(cardBrands: any())
    }

    func testHandleCobrandedCards_withEmptyResponse_resetsCvcRules() {
        let pan = "444433332222"
        let expectation = XCTestExpectation(description: "Card bin service callback")

        stub(mockPanValidationStateHandler) { stub in
            when(stub.getCardBrands()).thenReturn([self.visaBrand])
            when(stub.areCardBrandsDifferentFrom(cardBrands: equal(to: [])))
                .thenReturn(true)
            when(stub.updateCardBrandsIfChanged(cardBrands: equal(to: [])))
                .then { _ in
                    expectation.fulfill()
                }
        }

        stub(mockCardBinService) { stub in
            when(
                stub.getCardBrands(
                    globalBrand: equal(to: self.visaBrand),
                    cardNumber: equal(to: pan),
                    completion: any())
            ).then { _, _, completion in
                completion(.success([]))
            }
        }

        panValidationFlow.handleCobrandedCards(pan: pan)

        wait(for: [expectation], timeout: 1.0)

        verify(mockCvcFlow).resetValidationRule()
        verify(mockCvcFlow).revalidate()
        verify(mockPanValidationStateHandler).updateCardBrandsIfChanged(cardBrands: equal(to: []))
    }

    func testHandleCobrandedCards_onFailure_doesNotUpdate() {
        let pan = "444433332222"

        stub(mockPanValidationStateHandler) { stub in
            when(stub.getCardBrands()).thenReturn([])
        }

        stub(mockCardBinService) { stub in
            when(
                stub.getCardBrands(
                    globalBrand: any(),
                    cardNumber: equal(to: pan),
                    completion: any())
            ).then { _, _, completion in
                completion(.failure(AccessCheckoutError.unexpectedApiError(message: "Error")))
            }
        }

        panValidationFlow.handleCobrandedCards(pan: pan)

        let expectation = XCTestExpectation(description: "Card bin service callback")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)

        verify(mockPanValidationStateHandler, never()).updateCardBrandsIfChanged(cardBrands: any())
        verify(mockCvcFlow, never()).updateValidationRule(with: any())
        verify(mockCvcFlow, never()).resetValidationRule()
    }

    func testHandleCobrandedCards_withDifferentCvcRules_usesFirstBrand() {
        let pan = "444433332222"
        let brandsWithDifferentRules = [amexBrand, visaBrand]
        let expectation = XCTestExpectation(description: "Card bin service callback")

        stub(mockPanValidationStateHandler) { stub in
            when(stub.getCardBrands()).thenReturn([])
            when(stub.areCardBrandsDifferentFrom(cardBrands: equal(to: brandsWithDifferentRules)))
                .thenReturn(true)
            when(stub.updateCardBrandsIfChanged(cardBrands: equal(to: brandsWithDifferentRules)))
                .then { _ in
                    expectation.fulfill()
                }
        }

        stub(mockCardBinService) { stub in
            when(
                stub.getCardBrands(
                    globalBrand: any(),
                    cardNumber: equal(to: pan),
                    completion: any())
            ).then { _, _, completion in
                completion(.success(brandsWithDifferentRules))
            }
        }

        panValidationFlow.handleCobrandedCards(pan: pan)

        wait(for: [expectation], timeout: 1.0)

        verify(mockCvcFlow).updateValidationRule(with: amexBrand.cvcValidationRule)
        verify(mockCvcFlow).revalidate()
    }
}
