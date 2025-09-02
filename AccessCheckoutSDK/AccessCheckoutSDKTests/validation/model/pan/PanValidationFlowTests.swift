import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class PanValidationFlowTests: XCTestCase {
    let visaBrand = CardBrandModel(
        name: "visa",
        images: [],
        panValidationRule: ValidationRule(
            matcher: "^(?!^493698\\d*$)4\\d*$",
            validLengths: [16, 18, 19]
        ),
        cvcValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )

    private var mockCardBinService: MockCardBinService!
    private let panValidationStateHandler = MockPanValidationStateHandler()

    override func setUp() {
        super.setUp()

        mockCardBinService = MockCardBinService(
            checkoutId: "test-checkout-id",
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
            cardBrand: any()
        ).thenDoNothing()
    }

    override func tearDown() {
        mockCardBinService = nil
        super.tearDown()
    }

    func testValidateValidatesPanAndCallsValidationStateHandlerWithResult() {
        let cvcFlow = mockCvcFlow()
        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(
            panValidator, panValidationStateHandler, cvcFlow, mockCardBinService)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any())
            .thenReturn(false)

        panValidationFlow.validate(pan: "1234")

        verify(panValidator).validate(pan: "1234")
        verify(panValidationStateHandler).handlePanValidation(
            isValid: expectedResult.isValid,
            cardBrand: expectedResult.cardBrand
        )
    }

    func testValidateUpdatesCvcValidationRuleAndRevalidatesCvcWhenCardBrandHasChanged() {
        let cvcFlow = mockCvcFlow()
        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(
            panValidator, panValidationStateHandler, cvcFlow, mockCardBinService)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any())
            .thenReturn(true)
        cvcFlow.getStubbingProxy().updateValidationRule(with: any()).thenDoNothing()
        cvcFlow.getStubbingProxy().revalidate().thenDoNothing()

        panValidationFlow.validate(pan: "1234")

        verify(cvcFlow).updateValidationRule(with: visaBrand.cvcValidationRule)
        verify(cvcFlow).revalidate()
    }

    func
        testValidateResetsCvcValidationRuleAndRevalidatesCvcWhenCardBrandHasChangedAndNoBrandHasBeenIdentified()
    {
        let cvcFlow = mockCvcFlow()
        let expectedResult = PanValidationResult(true, nil)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(
            panValidator, panValidationStateHandler, cvcFlow, mockCardBinService)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any())
            .thenReturn(true)
        cvcFlow.getStubbingProxy().resetValidationRule().thenDoNothing()
        cvcFlow.getStubbingProxy().revalidate().thenDoNothing()

        panValidationFlow.validate(pan: "1234")

        verify(cvcFlow).resetValidationRule()
        verify(cvcFlow).revalidate()
    }

    func testValidateDoesNotAffectCvcValidationWhenCardBrandHasNotChanged() {
        let cvcFlow = mockCvcFlow()

        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(
            panValidator, panValidationStateHandler, cvcFlow, mockCardBinService)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any())
            .thenReturn(false)

        panValidationFlow.validate(pan: "1234")
        verifyNoMoreInteractions(cvcFlow)
    }

    func testCanNotifyMerchant() {
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

    private func mockCardConfiguration() -> CardBrandsConfiguration {
        return CardBrandsConfiguration(allCardBrands: [visaBrand], acceptedCardBrands: [])
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
