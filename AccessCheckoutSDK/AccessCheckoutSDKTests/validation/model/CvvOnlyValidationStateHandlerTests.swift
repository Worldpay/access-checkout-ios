@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CvvOnlyValidationStateHandlerTests : XCTestCase {
    
    private let accessCvvOnlyDelegate = MockAccessCvvOnlyDelegate()
    
    override func setUp() {
        Cuckoo.stub(accessCvvOnlyDelegate) { stub in
            when(stub).handleCvvValidationChange(isValid: any()).thenDoNothing()
        }
    }
    

    func testShouldNotNotifyMerchantDelegateWhenCvvValidationStateDoesNotChangeFromFalse() {
        let validationStateHandler = CvvOnlyValidationStateHandler(
            accessCvvOnlyDelegate: accessCvvOnlyDelegate,
            cvvValidationState: false
        )
        
        validationStateHandler.handleCvvValidation(isValid: false)
        verify(accessCvvOnlyDelegate, never()).handleCvvValidationChange(isValid: any())
    }

    func testShouldNotNotifyMerchantDelegateWhenCvvValidationStateDoesNotChangeFromTrue() {
        let validationStateHandler = CvvOnlyValidationStateHandler(
            accessCvvOnlyDelegate: accessCvvOnlyDelegate,
            cvvValidationState: true
        )
        
        validationStateHandler.handleCvvValidation(isValid: true)
        verify(accessCvvOnlyDelegate, never()).handleCvvValidationChange(isValid: any())
    }

    func testShouldNotifyMerchantDelegateWhenCvvValidationStateChangesFromFalse() {
        let validationStateHandler = CvvOnlyValidationStateHandler(
            accessCvvOnlyDelegate: accessCvvOnlyDelegate,
            cvvValidationState: false
        )
        
        validationStateHandler.handleCvvValidation(isValid: true)
        verify(accessCvvOnlyDelegate).handleCvvValidationChange(isValid: true)
    }

    func testShouldNotifyMerchantDelegateWhenCvvValidationStateChangesFromTrue() {
        let validationStateHandler = CvvOnlyValidationStateHandler(
            accessCvvOnlyDelegate: accessCvvOnlyDelegate,
            cvvValidationState: true
        )
        
        validationStateHandler.handleCvvValidation(isValid: false)
        verify(accessCvvOnlyDelegate).handleCvvValidationChange(isValid: false)
    }
}
