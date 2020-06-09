@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanValidationFlowTests: XCTestCase {
    let visaBrand = CardBrandModel(
        name: "visa",
        images: [],
        panValidationRule: ValidationRule(matcher: "^(?!^493698\\d*$)4\\d*$", validLengths: [16, 18, 19]),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    private let panValidationStateHandler = MockPanValidationStateHandler()
    
    override func setUp() {
        panValidationStateHandler.getStubbingProxy().handlePanValidation(isValid: any(), cardBrand: any()).thenDoNothing()
    }
    
    func testValidateValidatesPanAndCallsValidationStateHandlerWithResult() {
        let cvvFlow = mockCvvFlow()
        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(panValidator, panValidationStateHandler, cvvFlow)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any()).thenReturn(false)
        
        panValidationFlow.validate(pan: "1234")
        
        verify(panValidator).validate(pan: "1234")
        verify(panValidationStateHandler).handlePanValidation(isValid: expectedResult.isValid, cardBrand: expectedResult.cardBrand)
    }
    
    func testValidateUpdatesCvvValidationRuleAndRevalidatesCvvWhenCardBrandHasChanged() {
        let cvvFlow = mockCvvFlow()
        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(panValidator, panValidationStateHandler, cvvFlow)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any()).thenReturn(true)
        cvvFlow.getStubbingProxy().updateValidationRule(with: any()).thenDoNothing()
        cvvFlow.getStubbingProxy().revalidate().thenDoNothing()
        
        panValidationFlow.validate(pan: "1234")
        
        verify(cvvFlow).updateValidationRule(with: visaBrand.cvvValidationRule)
        verify(cvvFlow).revalidate()
    }
    
    func testValidateResetsCvvValidationRuleAndRevalidatesCvvWhenCardBrandHasChangedAndNoBrandHasBeenIdentified() {
        let cvvFlow = mockCvvFlow()
        let expectedResult = PanValidationResult(true, nil)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(panValidator, panValidationStateHandler, cvvFlow)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any()).thenReturn(true)
        cvvFlow.getStubbingProxy().resetValidationRule().thenDoNothing()
        cvvFlow.getStubbingProxy().revalidate().thenDoNothing()
        
        panValidationFlow.validate(pan: "1234")
        
        verify(cvvFlow).resetValidationRule()
        verify(cvvFlow).revalidate()
    }
    
    func testValidateDoesNotAffectCvvValidationWhenCardBrandHasNotChanged() {
        let cvvFlow = mockCvvFlow()
        
        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(panValidator, panValidationStateHandler, cvvFlow)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any()).thenReturn(false)
        
        panValidationFlow.validate(pan: "1234")
        verifyNoMoreInteractions(cvvFlow)
    }
    
    private func createMockPanValidator(thatReturns result: PanValidationResult) -> MockPanValidator {
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        let mock = MockPanValidator(configurationProvider)
        
        mock.getStubbingProxy().validate(pan: any()).thenReturn(result)
        
        return mock
    }
    
    private func mockCardConfiguration() -> CardBrandsConfiguration {
        return CardBrandsConfiguration([visaBrand])
    }
    
    private func mockCvvFlow() -> MockCvvValidationFlow {
        let cvvFlow = MockCvvValidationFlow(MockCvvValidator(),
                                            MockCvvValidationStateHandler())
        cvvFlow.getStubbingProxy().revalidate().thenDoNothing()
        return cvvFlow
    }
}
