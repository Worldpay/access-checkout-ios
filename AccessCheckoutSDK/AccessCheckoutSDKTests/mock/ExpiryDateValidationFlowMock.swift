@testable import AccessCheckoutSDK

class ExpiryDateValidationFlowMock: ExpiryDateValidationFlow {
    private(set) var validateCalled = false
    private(set) var expiryMonthPassed: ExpiryMonth?
    private(set) var expiryYearPassed: ExpiryYear?
    
    init() {
        let validator = MockExpiryDateValidator()
        let validationStateHandler = MockExpiryDateValidationStateHandler()
        
        super.init(validator, validationStateHandler)
    }
    
    override func validate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?) {
        validateCalled = true
        expiryMonthPassed = expiryMonth
        expiryYearPassed = expiryYear
    }
}
