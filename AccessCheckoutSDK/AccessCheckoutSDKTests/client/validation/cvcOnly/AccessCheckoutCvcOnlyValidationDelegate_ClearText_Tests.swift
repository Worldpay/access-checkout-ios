@testable import AccessCheckoutSDK
import Cuckoo

class AccessCheckoutCvcOnlyValidationDelegate_ClearText_Tests: AcceptanceTestSuite {
    func testMerchantDelegateIsNotifiedWhenValidCvcIsCleared() {
        let merchantDelegate = initialiseCvcOnlyValidation()
        
        editCvc(text: "123")
        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: true)
        
        clearCvc()
        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenInvalidCvcIsCleared() {
        let merchantDelegate = initialiseCvcOnlyValidation()
        
        editCvc(text: "12")
        
        clearCvc()
        verify(merchantDelegate, never()).cvcValidChanged(isValid: false)
    }
}
