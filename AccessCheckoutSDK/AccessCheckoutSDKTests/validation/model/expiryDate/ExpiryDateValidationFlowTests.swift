import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class ExpiryDateValidationFlowTests: XCTestCase {
    func testShouldCallExpiryDateValidatorThenCallStateHandlerWithResult() {
        let expectedResult = false

        let expiryDateValidationStateHandler = MockExpiryDateValidationStateHandler()
        expiryDateValidationStateHandler.getStubbingProxy().handleExpiryDateValidation(
            isValid: any()
        ).thenDoNothing()
        let expiryDateValidator = MockExpiryDateValidator()
        expiryDateValidator.getStubbingProxy().validate(any()).thenReturn(expectedResult)

        let expiryDateValidationFlow = ExpiryDateValidationFlow(
            expiryDateValidator, expiryDateValidationStateHandler)

        expiryDateValidationFlow.validate(expiryDate: "12/34")

        verify(expiryDateValidator).validate("12/34")
        verify(expiryDateValidationStateHandler).handleExpiryDateValidation(isValid: expectedResult)
    }

    func testCanNotifyMerchant() {
        let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantDelegate.getStubbingProxy().expiryDateValidChanged(isValid: any()).thenDoNothing()
        let expiryDateValidator = ExpiryDateValidator()
        let expiryDateValidationStateHandler = CardValidationStateHandler(merchantDelegate)
        let expiryDateValidationFlow = ExpiryDateValidationFlow(
            expiryDateValidator, expiryDateValidationStateHandler)

        expiryDateValidationFlow.notifyMerchant()

        verify(merchantDelegate).expiryDateValidChanged(isValid: false)
    }

    func testCannotNotifyMerchantIfAlreadyNotified() {
        let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantDelegate.getStubbingProxy().expiryDateValidChanged(isValid: any()).thenDoNothing()
        let expiryDateValidator = ExpiryDateValidator()
        let expiryDateValidationStateHandler = CardValidationStateHandler(merchantDelegate)
        let expiryDateValidationFlow = ExpiryDateValidationFlow(
            expiryDateValidator, expiryDateValidationStateHandler)

        expiryDateValidationStateHandler.handleExpiryDateValidation(isValid: true)
        verify(merchantDelegate).expiryDateValidChanged(isValid: true)
        clearInvocations(merchantDelegate)

        expiryDateValidationFlow.notifyMerchant()

        verify(merchantDelegate, never()).expiryDateValidChanged(isValid: any())
    }
}
