import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class PanValidationFlowCobrandedCardsTests: XCTestCase {

    private var mockPanValidator: MockPanValidator!
    private var mockPanValidationStateHandler: MockPanValidationStateHandler!
    private var mockCvcFlow: MockCvcValidationFlow!
    private var mockCardBinService: MockCardBinService!
    private var panValidationFlow: PanValidationFlow!

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
            when(stub.getCardBrand()).thenReturn(nil)
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func testHandleCobrandedCards_withEmptyPan_doesNotCallCardBinService() {
        let emptyPan = ""

        panValidationFlow.handleCobrandedCards(pan: emptyPan)

        verifyNoMoreInteractions(mockCardBinService)
    }

    func testHandleCobrandedCards_withLessThan12Digits_doesNotCallService() {
        let shortPan = "44443333"

        stub(mockPanValidationStateHandler) { stub in
            when(stub.getCardBrand()).thenReturn(nil)
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

        panValidationFlow.handleCobrandedCards(pan: shortPan)

        verifyNoMoreInteractions(mockCardBinService)
    }

    func testHandleCobrandedCards_withSpacesInPan_sanitisesBeforeProcessing() {
        let panWithSpaces = "4444 3333 2222 1111"
        let expectedSanitised = "444433332222"
        let visaBrand = TestFixtures.visaBrand()

        stub(mockPanValidationStateHandler) { stub in
            when(stub.getCardBrand()).thenReturn(visaBrand)
        }

        stub(mockCardBinService) { stub in
            when(
                stub.getCardBrands(
                    globalBrand: equal(to: visaBrand),
                    cardNumber: equal(to: expectedSanitised),
                    completion: any()
                )
            ).then { _, _, completion in
                completion(.success([visaBrand]))
            }
        }

        panValidationFlow.handleCobrandedCards(pan: panWithSpaces)

        verify(mockCardBinService).getCardBrands(
            globalBrand: equal(to: visaBrand),
            cardNumber: equal(to: expectedSanitised),
            completion: any()
        )
    }

    func testHandleCobrandedCards_withSamePrefixCalledTwice_onlyCallsServiceOnce() {
        let pan1 = "444433332222111"
        let pan2 = "444433332222999"

        stub(mockPanValidationStateHandler) { stub in
            when(stub.getCardBrand()).thenReturn(nil)
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

        panValidationFlow.handleCobrandedCards(pan: pan1)
        panValidationFlow.handleCobrandedCards(pan: pan2)

        verify(mockCardBinService, times(1)).getCardBrands(
            globalBrand: any(),
            cardNumber: any(),
            completion: any()
        )
    }

    func testHandleCobrandedCards_withDifferentPrefix_callsServiceForEachPrefix() {
        let pan1 = "444433332222"
        let pan2 = "555544443333"

        stub(mockPanValidationStateHandler) { stub in
            when(stub.getCardBrand()).thenReturn(nil)
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

        panValidationFlow.handleCobrandedCards(pan: pan1)
        panValidationFlow.handleCobrandedCards(pan: pan2)

        verify(mockCardBinService, times(2)).getCardBrands(
            globalBrand: any(),
            cardNumber: any(),
            completion: any()
        )
    }
}
