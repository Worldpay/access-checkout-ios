import Cuckoo

@testable import AccessCheckoutSDK

class AccessCheckoutCvcOnlyValidationDelegate_FocusOut_Tests: AcceptanceTestSuite {
    func testMerchantDelegateIsNotNotifiedWhenCvcComponentWithValidCvcLosesFocus() {
        let merchantDelegate = initialiseCvcOnlyValidation()

        editCvc(text: "123")
        clearInvocations(merchantDelegate)

        removeFocusFromCvc()

        verify(merchantDelegate, never()).cvcValidChanged(isValid: true)
    }

    func
        testMerchantDelegateIsNotifiedWhenCvcComponentWithInvalidCvcLosesFocusAndMerchantHasNeverBeenNotified()
    {
        let merchantDelegate = initialiseCvcOnlyValidation()

        editCvc(text: "12")
        clearInvocations(merchantDelegate)

        removeFocusFromCvc()

        verify(merchantDelegate).cvcValidChanged(isValid: false)
    }

    func
        testMerchantDelegateIsNotNotifiedWhenCvcComponentWithInvalidCvcLosesFocusAndMerchantHasAlreadyBeenNotifiedOfTheInvalidCvc()
    {
        let merchantDelegate = initialiseCvcOnlyValidation()

        editCvc(text: "123")
        editCvc(text: "12")
        clearInvocations(merchantDelegate)

        removeFocusFromCvc()

        verify(merchantDelegate, never()).cvcValidChanged(isValid: false)
    }
}
