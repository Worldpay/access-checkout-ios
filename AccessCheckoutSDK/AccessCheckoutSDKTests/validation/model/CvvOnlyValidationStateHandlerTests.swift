@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CvvOnlyValidationStateHandlerTests: XCTestCase {
    private let merchantDelegate = MockAccessCheckoutCvvOnlyValidationDelegate()
    
    override func setUp() {
        merchantDelegate.getStubbingProxy().cvvValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()
    }
    
    func testShouldNotNotifyMerchantDelegateWhenCvvValidationStateDoesNotChangeFromFalse() {
        let validationStateHandler = CvvOnlyValidationStateHandler(merchantDelegate, cvvValidationState: false)
        
        validationStateHandler.handleCvvValidation(isValid: false)
        verify(merchantDelegate, never()).cvvValidChanged(isValid: any())
    }
    
    func testShouldNotNotifyMerchantDelegateWhenCvvValidationStateDoesNotChangeFromTrue() {
        let validationStateHandler = CvvOnlyValidationStateHandler(merchantDelegate, cvvValidationState: true)
        
        validationStateHandler.handleCvvValidation(isValid: true)
        verify(merchantDelegate, never()).cvvValidChanged(isValid: any())
    }
    
    func testShouldNotifyMerchantDelegateWhenCvvValidationStateChangesFromFalse() {
        let validationStateHandler = CvvOnlyValidationStateHandler(merchantDelegate, cvvValidationState: false)
        
        validationStateHandler.handleCvvValidation(isValid: true)
        verify(merchantDelegate).cvvValidChanged(isValid: true)
    }
    
    func testShouldNotifyMerchantDelegateWhenCvvValidationStateChangesFromTrue() {
        let validationStateHandler = CvvOnlyValidationStateHandler(merchantDelegate, cvvValidationState: true)
        
        validationStateHandler.handleCvvValidation(isValid: false)
        verify(merchantDelegate).cvvValidChanged(isValid: false)
    }
    
    // MARK: Tests for notification that all fields are valid
    
    func testShouldNotifyMerchantDelegateWhenAllFieldsAreValid() {
        let validationStateHandler = CvvOnlyValidationStateHandler(merchantDelegate)
        
        validationStateHandler.handleCvvValidation(isValid: true)
        
        verify(merchantDelegate).validationSuccess()
    }
    
    func testShouldNotifyMerchantDelegateOnlyOnceWhenAllFieldsAreValidAndCvvIsChangedToAnotherValidValue() {
        let validationStateHandler = CvvOnlyValidationStateHandler(merchantDelegate)
        
        validationStateHandler.handleCvvValidation(isValid: true)
        validationStateHandler.handleCvvValidation(isValid: true)
        
        verify(merchantDelegate, times(1)).validationSuccess()
    }
}
