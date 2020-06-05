@testable import AccessCheckoutSDK

class PanValidationFlowMock: PanValidationFlow {
    private(set) var validateCalled = false
    private(set) var panPassed: PAN?
    
    init() {
        let validator = PanValidator(MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock()))
        let validationStateHandler = MockPanValidationStateHandler()
        let cvvFlow = CvvValidationFlowMock()
        
        super.init(validator, validationStateHandler, cvvFlow)
    }
    
    override func validate(pan: PAN) {
        validateCalled = true
        panPassed = pan
    }
}
