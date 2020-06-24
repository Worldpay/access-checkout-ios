@testable import AccessCheckoutSDK
import Cuckoo

class AccessCheckoutCardValidationDelegate_ClearText_Tests: ViewTestSuite {
    private let validVisaPan = TestFixtures.validVisaPan1
    
    func testMerchantDelegateIsNotifiedWhenValidPanIsCleared() {
        let merchantDelegate = initialiseCardValidation()
        
        editPan(text: validVisaPan)
        verify(merchantDelegate, times(1)).panValidChanged(isValid: true)
        
        clearPan()
        verify(merchantDelegate, times(1)).panValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenInvalidPanIsCleared() {
        let merchantDelegate = initialiseCardValidation()
        
        editPan(text: "1234")
        
        clearPan()
        verify(merchantDelegate, never()).panValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotifiedWhenValidExpiryDateIsCleared() {
        let merchantDelegate = initialiseCardValidation()
        
        editExpiryDate(text: "12/35")
        verify(merchantDelegate, times(1)).expiryDateValidChanged(isValid: true)
        
        clearExpiryDate()
        verify(merchantDelegate, times(1)).expiryDateValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenInvalidExpiryDateIsCleared() {
        let merchantDelegate = initialiseCardValidation()
        
        editExpiryDate(text: "12/3")
        
        clearExpiryDate()
        verify(merchantDelegate, never()).expiryDateValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotifiedWhenValidCvcIsCleared() {
        let merchantDelegate = initialiseCardValidation()
        
        editCvc(text: "123")
        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: true)
        
        clearCvc()
        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenInvalidCvcIsCleared() {
        let merchantDelegate = initialiseCardValidation()
        
        editCvc(text: "12")
        
        clearCvc()
        verify(merchantDelegate, never()).cvcValidChanged(isValid: false)
    }
}
