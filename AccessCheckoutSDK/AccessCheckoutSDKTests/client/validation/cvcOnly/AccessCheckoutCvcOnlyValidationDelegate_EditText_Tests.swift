import Cuckoo

@testable import AccessCheckoutSDK

class AccessCheckoutCvcOnlyValidationDelegate_EditText_Tests: AcceptanceTestSuite {
    func testMerchantDelegateIsNotifiedOfCvcValidationStateChanges() {
        let merchantDelegate = initialiseCvcOnlyValidation()

        editCvc(text: "123")

        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: true)
    }

    func testMerchantDelegateIsNotNotifiedWhenCvcChangesButValidationStatesDoesNotChange() {
        let merchantDelegate = initialiseCvcOnlyValidation()

        editCvc(text: "456")
        editCvc(text: "123")

        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: true)
    }

    func testMerchantIsNotifiedOfValidationSuccess() {
        let merchantDelegate = initialiseCvcOnlyValidation()

        editCvc(text: "123")

        verify(merchantDelegate, times(1)).validationSuccess()
    }

    func testMerchantIsNotNotifiedOfValidationSuccessWhenCvcIsNotValid() {
        let merchantDelegate = initialiseCvcOnlyValidation()

        editCvc(text: "12")

        verify(merchantDelegate, never()).validationSuccess()
    }
}
