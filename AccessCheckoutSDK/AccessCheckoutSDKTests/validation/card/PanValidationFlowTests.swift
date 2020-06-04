@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanValidationFlowTests: XCTestCase {
    let visaBrand = CardBrand2(
        name: "visa",
        images: [],
        panValidationRule: ValidationRule(matcher: "^(?!^493698\\d*$)4\\d*$", validLengths: [16,18,19]),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    private let panValidationStateHandler = MockPanValidationStateHandler()
    
    override func setUp() {
        panValidationStateHandler.getStubbingProxy().handlePanValidation(isValid: any(), cardBrand: any()).thenDoNothing()
    }
    
    func testShouldCallPanValidatorAndCallHandlerWithResult() {
        let cvvFlow = mockCvvFlow()
        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(panValidator, panValidationStateHandler, cvvFlow)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any()).thenReturn(false)
        
        panValidationFlow.validate(pan: "1234")
        
        verify(panValidator).validate(pan: "1234")
        verify(panValidationStateHandler).handlePanValidation(isValid: expectedResult.isValid, cardBrand: expectedResult.cardBrand)
    }
    
    func testShouldTriggerCvvValidationIfCardBrandHasChanged() {
        let cvvFlow = mockCvvFlow()
        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(panValidator, panValidationStateHandler, cvvFlow)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any()).thenReturn(true)
        
        panValidationFlow.validate(pan: "1234")
        
        verify(cvvFlow).reValidate(cvvRule: visaBrand.cvvValidationRule)
    }
    
    func testShouldNotTriggerCvvValidationIfCardBrandHasNotChanged() {
        let cvvFlow = mockCvvFlow()

        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(panValidator, panValidationStateHandler, cvvFlow)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any()).thenReturn(false)
        
        panValidationFlow.validate(pan: "1234")
        verify(cvvFlow, never()).reValidate(cvvRule: any())
    }
    
    private func createMockPanValidator(thatReturns result: PanValidationResult) -> MockPanValidator {
        let mock = MockPanValidator(cardConfiguration: mockCardConfiguration())
        
        mock.getStubbingProxy().validate(pan: any()).thenReturn(result)
        
        return mock
    }
    
    private func mockCardConfiguration() -> CardBrandsConfiguration {
        return CardBrandsConfiguration([visaBrand], ValidationRulesDefaults.instance())
    }
    
    private func mockCvvFlow() -> MockCvvValidationFlow {
        let cvvFlow = MockCvvValidationFlow(
            cvvValidator: MockCvvValidator(),
                cvvValidationStateHandler: MockCvvValidationStateHandler()
        )
        cvvFlow.getStubbingProxy().reValidate(cvvRule: any()).thenDoNothing()
        return cvvFlow
    }
}
