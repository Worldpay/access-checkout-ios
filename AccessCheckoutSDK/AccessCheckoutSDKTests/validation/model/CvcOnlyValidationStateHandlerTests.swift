import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class CvcOnlyValidationStateHandlerTests: XCTestCase {
    private let merchantDelegate = MockAccessCheckoutCvcOnlyValidationDelegate()

    override func setUp() {
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()
    }

    func testShouldNotNotifyMerchantDelegateWhenCvcValidationStateDoesNotChangeFromFalse() {
        let validationStateHandler = CvcOnlyValidationStateHandler(
            merchantDelegate,
            cvcValidationState: false
        )

        validationStateHandler.handleCvcValidation(isValid: false)
        verify(merchantDelegate, never()).cvcValidChanged(isValid: any())
    }

    func testShouldNotNotifyMerchantDelegateWhenCvcValidationStateDoesNotChangeFromTrue() {
        let validationStateHandler = CvcOnlyValidationStateHandler(
            merchantDelegate,
            cvcValidationState: true
        )

        validationStateHandler.handleCvcValidation(isValid: true)
        verify(merchantDelegate, never()).cvcValidChanged(isValid: any())
    }

    func testShouldNotifyMerchantDelegateWhenCvcValidationStateChangesFromFalse() {
        let validationStateHandler = CvcOnlyValidationStateHandler(
            merchantDelegate,
            cvcValidationState: false
        )

        validationStateHandler.handleCvcValidation(isValid: true)
        verify(merchantDelegate).cvcValidChanged(isValid: true)
    }

    func testShouldNotifyMerchantDelegateWhenCvcValidationStateChangesFromTrue() {
        let validationStateHandler = CvcOnlyValidationStateHandler(
            merchantDelegate,
            cvcValidationState: true
        )

        validationStateHandler.handleCvcValidation(isValid: false)
        verify(merchantDelegate).cvcValidChanged(isValid: false)
    }

    // MARK: Tests for notification that all fields are valid

    func testShouldNotifyMerchantDelegateWhenAllFieldsAreValid() {
        let validationStateHandler = CvcOnlyValidationStateHandler(merchantDelegate)

        validationStateHandler.handleCvcValidation(isValid: true)

        verify(merchantDelegate).validationSuccess()
    }

    func
        testShouldNotifyMerchantDelegateOnlyOnceWhenAllFieldsAreValidAndCvcIsChangedToAnotherValidValue()
    {
        let validationStateHandler = CvcOnlyValidationStateHandler(merchantDelegate)

        validationStateHandler.handleCvcValidation(isValid: true)
        validationStateHandler.handleCvcValidation(isValid: true)

        verify(merchantDelegate, times(1)).validationSuccess()
    }
}
