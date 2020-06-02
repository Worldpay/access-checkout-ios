@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanValidationFlowTests: XCTestCase {
    private let visaBrand = AccessCardConfiguration.CardBrand(
        name: "visa",
        images: nil,
        matcher: "",
        cvv: 3,
        pans: []
    )
    
    private let panValidationStateHandler = MockPanValidationStateHandler()
    private let cvvFlow = MockCvvWithPanValidationFlow()
    
    override func setUp() {
        panValidationStateHandler.getStubbingProxy().handle(isValid: any(), cardBrand: any()).thenDoNothing()
        cvvFlow.getStubbingProxy().validate(cardBrand: any()).thenDoNothing()
    }
    
    func testShouldCallPanValidatorAndCallHandlerWithResult() {
        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(panValidator, panValidationStateHandler, cvvFlow)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any()).thenReturn(false)
        
        panValidationFlow.validate(pan: "1234")
        
        verify(panValidator).validate(pan: "1234")
        verify(panValidationStateHandler).handle(isValid: expectedResult.isValid, cardBrand: expectedResult.cardBrand)
    }
    
    func testShouldTriggerCvvValidationIfCardBrandHasChanged() {
        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(panValidator, panValidationStateHandler, cvvFlow)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any()).thenReturn(true)
        
        panValidationFlow.validate(pan: "1234")
        
        verify(cvvFlow).validate(cardBrand: visaBrand)
    }
    
    func testShouldNotTriggerCvvValidationIfCardBrandHasNotChanged() {
        let expectedResult = PanValidationResult(true, visaBrand)
        let panValidator = createMockPanValidator(thatReturns: expectedResult)
        let panValidationFlow = PanValidationFlow(panValidator, panValidationStateHandler, cvvFlow)
        panValidationStateHandler.getStubbingProxy().isCardBrandDifferentFrom(cardBrand: any()).thenReturn(false)
        
        panValidationFlow.validate(pan: "1234")
        verify(cvvFlow, never()).validate(cardBrand: any())
    }
    
    private func createMockPanValidator(thatReturns result: PanValidationResult) -> MockPanValidator {
        let mock = MockPanValidator(cardConfiguration: mockCardConfiguration())
        
        mock.getStubbingProxy().validate(pan: any()).thenReturn(result)
        
        return mock
    }
    
    private func mockCardConfiguration() -> AccessCardConfiguration {
        return AccessCardConfiguration(fromURL: URL(string: "http://localhost")!)!
    }
}
