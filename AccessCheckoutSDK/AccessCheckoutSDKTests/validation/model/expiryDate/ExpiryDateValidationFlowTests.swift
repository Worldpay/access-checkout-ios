@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class ExpiryDateValidationFlowTests: XCTestCase {
    func testShouldCallExpiryDateValidatorThenCallStateHandlerWithResult() {
        let expectedResult = false
        
        let expiryDateValidationStateHandler = MockExpiryDateValidationStateHandler()
        expiryDateValidationStateHandler.getStubbingProxy().handleExpiryDateValidation(isValid: any()).thenDoNothing()
        let expiryDateValidator = MockExpiryDateValidator()
        expiryDateValidator.getStubbingProxy().validate(any()).thenReturn(expectedResult)
        
        let expiryDateValidationFlow = ExpiryDateValidationFlow(expiryDateValidator, expiryDateValidationStateHandler)
        
        expiryDateValidationFlow.validate(expiryDate: "12/34")
        
        verify(expiryDateValidator).validate("12/34")
        verify(expiryDateValidationStateHandler).handleExpiryDateValidation(isValid: expectedResult)
    }
}
