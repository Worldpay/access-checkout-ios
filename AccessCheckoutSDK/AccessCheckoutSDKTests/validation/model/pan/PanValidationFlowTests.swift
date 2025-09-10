import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class PanValidationFlowTests: XCTestCase {
    let visaBrand = TestFixtures.visaBrand()
    let maestroBrand = TestFixtures.maestroBrand()

    private var mockCardBinService: MockCardBinService!
    private let panValidationStateHandler = MockPanValidationStateHandler()

    override func setUp() {
        super.setUp()

        mockCardBinService = MockCardBinService(
            checkoutId: "0000-0000-0000-0000-000000000000",
            client: MockCardBinApiClient(),
            configurationProvider: MockCardBrandsConfigurationProvider(
                CardBrandsConfigurationFactoryMock()
            )
        )

        stub(mockCardBinService) { stub in
            when(
                stub.getCardBrands(
                    globalBrand: any(),
                    cardNumber: any(),
                    completion: any())
            )
            .then { _, _, completion in
                completion(.success([]))
            }
        }

        panValidationStateHandler.getStubbingProxy().handlePanValidation(
            isValid: any(),
            cardBrands: any()
        ).thenDoNothing()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testValidate_callsHandlerWithArrayOfBrands() {
        let cvcFlow = mockCvcFlow()
        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(
            panValidator, panValidationStateHandler, cvcFlow, mockCardBinService)
        panValidationStateHandler.getStubbingProxy().areCardBrandsDifferentFrom(cardBrands: any())
            .thenReturn(false)

        panValidationFlow.validate(pan: "1234")

        verify(panValidator).validate(pan: "1234")
        verify(panValidationStateHandler).handlePanValidation(
            isValid: true,
            cardBrands: equal(to: [visaBrand])
        )
    }

    func testValidate_withNoBrand_callsHandlerWithEmptyArray() {
        let cvcFlow = mockCvcFlow()
        let expectedResult = PanValidationResult(false, nil)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(
            panValidator, panValidationStateHandler, cvcFlow, mockCardBinService)
        panValidationStateHandler.getStubbingProxy().areCardBrandsDifferentFrom(cardBrands: any())
            .thenReturn(false)

        panValidationFlow.validate(pan: "999")

        verify(panValidationStateHandler).handlePanValidation(
            isValid: false,
            cardBrands: equal(to: [])
        )
    }

    func testValidate_whenBrandsChange_updatesCvcRulesWithFirstBrand() {
        let cvcFlow = mockCvcFlow()
        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(
            panValidator, panValidationStateHandler, cvcFlow, mockCardBinService)

        panValidationStateHandler.getStubbingProxy().areCardBrandsDifferentFrom(cardBrands: any())
            .thenReturn(true)
        cvcFlow.getStubbingProxy().updateValidationRule(with: any()).thenDoNothing()
        cvcFlow.getStubbingProxy().revalidate().thenDoNothing()

        panValidationFlow.validate(pan: "1234")

        verify(cvcFlow).updateValidationRule(with: visaBrand.cvcValidationRule)
        verify(cvcFlow).revalidate()
    }

    func testValidate_whenBrandsChangeToNone_resetsCvcRules() {
        let cvcFlow = mockCvcFlow()
        let expectedResult = PanValidationResult(true, nil)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(
            panValidator, panValidationStateHandler, cvcFlow, mockCardBinService)

        panValidationStateHandler.getStubbingProxy().areCardBrandsDifferentFrom(cardBrands: any())
            .thenReturn(true)
        cvcFlow.getStubbingProxy().resetValidationRule().thenDoNothing()
        cvcFlow.getStubbingProxy().revalidate().thenDoNothing()

        panValidationFlow.validate(pan: "1234")

        verify(cvcFlow).resetValidationRule()
        verify(cvcFlow).revalidate()
    }

    func testValidate_whenBrandsAreSame_doesNotUpdateCvcRules() {
        let cvcFlow = mockCvcFlow()
        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(
            panValidator, panValidationStateHandler, cvcFlow, mockCardBinService)

        panValidationStateHandler.getStubbingProxy().areCardBrandsDifferentFrom(cardBrands: any())
            .thenReturn(false)

        panValidationFlow.validate(pan: "1234")

        verifyNoMoreInteractions(cvcFlow)
    }

    func testGetCardBrands_returnsArrayFromStateHandler() {
        let cvcFlow = mockCvcFlow()
        let panValidator = createMockPanValidator(thatReturns: PanValidationResult(true, visaBrand))
        let panValidationFlow = PanValidationFlow(
            panValidator, panValidationStateHandler, cvcFlow, mockCardBinService)

        let expectedBrands = [visaBrand, maestroBrand]
        panValidationStateHandler.getStubbingProxy().getCardBrands().thenReturn(expectedBrands)

        let result = panValidationFlow.getCardBrands()

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].name, visaBrand.name)
        XCTAssertEqual(result[1].name, maestroBrand.name)
    }

    func testNotifyMerchant_callsStateHandler() {
        let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantDelegate.getStubbingProxy().panValidChanged(isValid: any()).thenDoNothing()
        let cvcFlow = mockCvcFlow()
        let panValidator = PanValidator(
            CardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        )
        let panValidationStateHandler = CardValidationStateHandler(merchantDelegate)
        let panValidationFlow = PanValidationFlow(
            panValidator, panValidationStateHandler, cvcFlow, mockCardBinService)

        panValidationFlow.notifyMerchant()

        verify(merchantDelegate).panValidChanged(isValid: false)
    }

    private func createMockPanValidator(thatReturns result: PanValidationResult) -> MockPanValidator
    {
        let configurationProvider = MockCardBrandsConfigurationProvider(
            CardBrandsConfigurationFactoryMock()
        )
        let mock = MockPanValidator(configurationProvider)
        mock.getStubbingProxy().validate(pan: any()).thenReturn(result)
        return mock
    }

    private func mockCvcFlow() -> MockCvcValidationFlow {
        let cvcFlow = MockCvcValidationFlow(
            MockCvcValidator(),
            MockCvcValidationStateHandler()
        )
        cvcFlow.getStubbingProxy().revalidate().thenDoNothing()
        return cvcFlow
    }
}
