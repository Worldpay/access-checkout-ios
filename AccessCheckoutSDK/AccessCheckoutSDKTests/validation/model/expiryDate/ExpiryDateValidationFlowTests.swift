@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class ExpiryDateValidationFlowTests: XCTestCase {
    private let expiryDateValidationStateHandler = MockExpiryDateValidationStateHandler()
    
    override func setUp() {
        expiryDateValidationStateHandler.getStubbingProxy().handleExpiryDateValidation(isValid: any()).thenDoNothing()
    }
    
    func testShouldCallExpiryDateValidatorThenCallStateHandlerWithResult() {
        let expectedResult = false
        let expiryDateValidator = createMockExpiryDateValidator(thatReturns: expectedResult)
        let expiryDateValidationFlow = ExpiryDateValidationFlow(expiryDateValidator, expiryDateValidationStateHandler)
        
        expiryDateValidationFlow.validate(expiryMonth: "12", expiryYear: "19")
        verify(expiryDateValidator).validate(expiryMonth: "12", expiryYear: "19")
        verify(expiryDateValidationStateHandler).handleExpiryDateValidation(isValid: expectedResult)
    }
    
    private func createMockExpiryDateValidator(thatReturns result: Bool) -> MockExpiryDateValidator {
        let mock = MockExpiryDateValidator()
        
        mock.getStubbingProxy().validate(expiryMonth: any(), expiryYear: any()).thenReturn(result)
        
        return mock
    }
}
