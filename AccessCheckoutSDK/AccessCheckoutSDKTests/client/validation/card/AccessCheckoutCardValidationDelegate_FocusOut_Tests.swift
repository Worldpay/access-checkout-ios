import Cuckoo

@testable import AccessCheckoutSDK

class AccessCheckoutCardValidationDelegate_FocusOut_Tests: AcceptanceTestSuite {
    private let validVisaPan1 = "4111111111111111"
    private let invalidVisaPan = "123"

    func testMerchantDelegateIsNotNotifiedWhenPanComponentWithValidPanLosesFocus() {
        let merchantDelegate = initialiseCardValidation()
        editPan(text: validVisaPan1)
        clearInvocations(merchantDelegate)

        removeFocusFromPan()

        verify(merchantDelegate, never()).panValidChanged(isValid: true)
    }

    func
        testMerchantDelegateIsNotifiedWhenPanComponentWithInvalidPanLosesFocusAndMerchantHasNeverBeenNotified()
    {
        let merchantDelegate = initialiseCardValidation()
        editPan(text: invalidVisaPan)
        clearInvocations(merchantDelegate)

        removeFocusFromPan()

        verify(merchantDelegate, times(1)).panValidChanged(isValid: false)
    }

    func
        testMerchantDelegateIsNotNotifiedWhenPanComponentWithInvalidPanLosesFocusAndMerchantHasAlreadyBeenNotifiedOfTheInvalidPan()
    {
        let merchantDelegate = initialiseCardValidation()
        editPan(text: validVisaPan1)
        editPan(text: invalidVisaPan)
        clearInvocations(merchantDelegate)

        removeFocusFromPan()

        verify(merchantDelegate, never()).panValidChanged(isValid: false)
    }

    func testMerchantDelegateIsNotNotifiedWhenExpiryDateComponentWithValidExpiryDateLosesFocus() {
        let merchantDelegate = initialiseCardValidation()
        editExpiryDate(text: "11/32")
        clearInvocations(merchantDelegate)

        removeFocusFromExpiryDate()

        verify(merchantDelegate, never()).expiryDateValidChanged(isValid: true)
    }

    func
        testMerchantDelegateIsNotifiedWhenExpiryDateComponentWithInvalidExpiryDateLosesFocusAndMerchantHasNeverBeenNotified()
    {
        let merchantDelegate = initialiseCardValidation()
        editExpiryDate(text: "11/3")
        clearInvocations(merchantDelegate)

        removeFocusFromExpiryDate()

        verify(merchantDelegate, times(1)).expiryDateValidChanged(isValid: false)
    }

    func
        testMerchantDelegateIsNotNotifiedWhenExpiryDateComponentWithInvalidExpiryDateLosesFocusAndMerchantHasAlreadyBeenNotifiedOfTheInvalidExpiryDate()
    {
        let merchantDelegate = initialiseCardValidation()
        editExpiryDate(text: "11/33")
        editExpiryDate(text: "11/3")
        clearInvocations(merchantDelegate)

        removeFocusFromExpiryDate()

        verify(merchantDelegate, never()).expiryDateValidChanged(isValid: false)
    }

    // MARK: Cvc validation tests

    func testMerchantDelegateIsNotNotifiedWhenCvcComponentWithValidCvcLosesFocus() {
        let merchantDelegate = initialiseCardValidation()
        editCvc(text: "123")
        clearInvocations(merchantDelegate)

        removeFocusFromCvc()

        verify(merchantDelegate, never()).cvcValidChanged(isValid: true)
    }

    func
        testMerchantDelegateIsNotifiedWhenCvcComponentWithInvalidCvcLosesFocusAndMerchantHasNeverBeenNotified()
    {
        let merchantDelegate = initialiseCardValidation()
        editCvc(text: "12")
        clearInvocations(merchantDelegate)

        removeFocusFromCvc()

        verify(merchantDelegate).cvcValidChanged(isValid: false)
    }

    func
        testMerchantDelegateIsNotNotifiedWhenCvcComponentWithInvalidCvcLosesFocusAndMerchantHasAlreadyBeenNotifiedOfTheInvalidCvc()
    {
        let merchantDelegate = initialiseCardValidation()
        editCvc(text: "123")
        editCvc(text: "12")
        clearInvocations(merchantDelegate)

        removeFocusFromCvc()

        verify(merchantDelegate, never()).cvcValidChanged(isValid: false)
    }
}
