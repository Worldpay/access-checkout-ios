@testable import AccessCheckoutSDK
import XCTest
import Cuckoo

class AccessCheckoutCVVOnlyTests : XCTestCase {
    
    func testSetsAccessCheckoutViewDelegateOnCvvView() {
        let cvvView = CVVView()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: nil)
        
        XCTAssertTrue(checkoutCvvOnly === cvvView.validationDelegate)
    }
    
    func testIsNotValidWhenTextFieldIsEmpty() {
        let cvvView = CVVView()
        let cvvValidator = CVVValidatorLegacy()
        cvvView.textField.text = ""
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: cvvValidator)
        
        let result = checkoutCvvOnly.isValid()
        
        XCTAssertFalse(result)
    }
    
    func testIsValidWhenCvvFieldIsCompletelyValid() {
        let cvvView = CVVView()
        cvvView.textField.text = "123"
        let cvvValidator = MockCVVValidatorLegacy()
        when(cvvValidator.getStubbingProxy().validate(cvv: any())).thenReturn(ValidationResult(partial: false, complete: true))
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: cvvValidator)
        
        let result = checkoutCvvOnly.isValid()
        
        XCTAssertTrue(result)
        verify(cvvValidator).validate(cvv: "123")
    }
    
    func testIsNotValidWhenCvvFieldIsNotCompletelyValid() {
        let cvvView = CVVView()
        let cvvValidator = MockCVVValidatorLegacy()
        cvvView.textField.text = "12"
        when(cvvValidator.getStubbingProxy().validate(cvv: any())).thenReturn(ValidationResult(partial: false, complete: false))
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: cvvValidator)
        
        let result = checkoutCvvOnly.isValid()
        
        XCTAssertFalse(result)
        verify(cvvValidator).validate(cvv: "12")
    }
    
    func testIsValidWhenNoCvvValidator() {
        let cvvView = CVVView()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: nil)
        
        let result = checkoutCvvOnly.isValid()
        
        XCTAssertTrue(result)
    }
}

class AccessCheckoutCVVOnly_CVVViewDelegateImplementation_Tests : XCTestCase {
    
    func testCanUpdateCvvWithTextWhenResultingCvvIsPartiallyValid() {
        let cvvView = CVVView()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: CVVValidatorLegacy())
        let textForUpdate = "2"
        
        let result = checkoutCvvOnly.canUpdate(cvv: "1",
                withText: textForUpdate,
                inRange: NSRange(location: 1, length: 0))
        
        XCTAssertTrue(result)
    }
    
    func testCannotUpdateCvvWithTextWhenResultingCvvIsNotValid() {
        let cvvView = CVVView()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: CVVValidatorLegacy())
        let textForUpdate = "A"
        
        let result = checkoutCvvOnly.canUpdate(cvv: "1",
                withText: textForUpdate,
                inRange: NSRange(location: 1, length: 0))
        
        XCTAssertFalse(result)
    }
    
    func testCanUpdateCvvWhenDeletingDigit() {
        let cvvView = CVVView()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: CVVValidatorLegacy())
        let textForUpdate = ""
        
        let result = checkoutCvvOnly.canUpdate(cvv: "123",
                withText: textForUpdate,
                inRange: NSRange(location: 2, length: 1))
        
        XCTAssertTrue(result)
    }
    
    func testNotifyPartialMatchValidationNotifiesDelegateWithPartialValidationResult() {
        let cvvView = CVVView()
        let cvvValidator = MockCVVValidatorLegacy()
        let expectedValidationResult: ValidationResult = ValidationResult(partial: true, complete: false)
        when(cvvValidator.getStubbingProxy().validate(cvv: any())).thenReturn(expectedValidationResult)
        let cvvOnlyDelegate = MockCVVOnlyDelegate()
        when(cvvOnlyDelegate.getStubbingProxy().handleValidationResult(cvvView: any(), isValid: true)).thenDoNothing()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: cvvOnlyDelegate, cvvValidator: cvvValidator)
        
        checkoutCvvOnly.notifyPartialMatchValidation(forCvv: "12")
        
        let argumentCaptor = ArgumentCaptor<AccessCheckoutView>()
        verify(cvvOnlyDelegate).handleValidationResult(cvvView: argumentCaptor.capture(), isValid: expectedValidationResult.partial)
        XCTAssertTrue(argumentCaptor.value! === (cvvView as AccessCheckoutView))
    }
    
    func testNotifyCompleteMatchValidationNotifiesDelegateWithCompleteValidationResult() {
        let cvvView = CVVView()
        let cvvValidator = MockCVVValidatorLegacy()
        let expectedValidationResult: ValidationResult = ValidationResult(partial: false, complete: true)
        when(cvvValidator.getStubbingProxy().validate(cvv: any())).thenReturn(expectedValidationResult)
        let cvvOnlyDelegate = MockCVVOnlyDelegate()
        when(cvvOnlyDelegate.getStubbingProxy().handleValidationResult(cvvView: any(), isValid: true)).thenDoNothing()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: cvvOnlyDelegate, cvvValidator: cvvValidator)
        
        checkoutCvvOnly.notifyCompleteMatchValidation(forCvv: "12")
        
        let argumentCaptor = ArgumentCaptor<AccessCheckoutView>()
        verify(cvvOnlyDelegate).handleValidationResult(cvvView: argumentCaptor.capture(), isValid: expectedValidationResult.complete)
        XCTAssertTrue(argumentCaptor.value! === (cvvView as AccessCheckoutView))
    }
}
