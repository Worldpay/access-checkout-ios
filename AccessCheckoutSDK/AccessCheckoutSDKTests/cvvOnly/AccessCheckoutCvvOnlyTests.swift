@testable import AccessCheckoutSDK
import XCTest
import Cuckoo

class AccessCheckoutCVVOnlyTests : XCTestCase {
    
    func testSetsCardViewDelegateOnCvvView() {
        let cvvView = CVVView()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: nil)
        
        XCTAssertTrue(checkoutCvvOnly === cvvView.cardViewDelegate)
    }
    
    func testIsNotValidWhenTextFieldIsEmpty() {
        let cvvView = CVVView()
        let cvvValidator = CVVValidator()
        cvvView.textField.text = ""
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: cvvValidator)
        
        let result = checkoutCvvOnly.isValid()
        
        XCTAssertFalse(result)
    }
    
    func testIsValidWhenCvvFieldIsCompletelyValid() {
        let cvvView = CVVView()
        cvvView.textField.text = "123"
        let cvvValidator = MockCVVValidator()
        when(cvvValidator.getStubbingProxy().validate(cvv: any())).thenReturn(ValidationResult(partial: false, complete: true))
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: cvvValidator)
        
        let result = checkoutCvvOnly.isValid()
        
        XCTAssertTrue(result)
        verify(cvvValidator).validate(cvv: "123")
    }
    
    func testIsNotValidWhenCvvFieldIsNotCompletelyValid() {
        let cvvView = CVVView()
        let cvvValidator = MockCVVValidator()
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

class AccessCheckoutCVVOnly_CardViewDelegateImplementation_Tests : XCTestCase {
    
    func testCanUpdateCvvWithTextWhenResultingCvvIsPartiallyValid() {
        let cvvView = CVVView()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: CVVValidator())
        let textForUpdate = "2"
        
        let result = checkoutCvvOnly.canUpdate(cvv: "1",
                withText: textForUpdate,
                inRange: NSRange(location: 1, length: 0))
        
        XCTAssertTrue(result)
    }
    
    func testCannotUpdateCvvWithTextWhenResultingCvvIsNotValid() {
        let cvvView = CVVView()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: CVVValidator())
        let textForUpdate = "A"
        
        let result = checkoutCvvOnly.canUpdate(cvv: "1",
                withText: textForUpdate,
                inRange: NSRange(location: 1, length: 0))
        
        XCTAssertFalse(result)
    }
    
    func testCanUpdateCvvWhenDeletingDigit() {
        let cvvView = CVVView()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator: CVVValidator())
        let textForUpdate = ""
        
        let result = checkoutCvvOnly.canUpdate(cvv: "123",
                withText: textForUpdate,
                inRange: NSRange(location: 2, length: 1))
        
        XCTAssertTrue(result)
    }
    
    func testDidUpdateCvvNotifiesDelegateWithPartialValidationResult() {
        let cvvView = CVVView()
        let cvvValidator = MockCVVValidator()
        let expectedValidationResult: ValidationResult = ValidationResult(partial: true, complete: false)
        when(cvvValidator.getStubbingProxy().validate(cvv: any())).thenReturn(expectedValidationResult)
        let cvvOnlyDelegate = MockCVVOnlyDelegate()
        when(cvvOnlyDelegate.getStubbingProxy().handleValidationResult(cvvView: any(), isValid: true)).thenDoNothing()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: cvvOnlyDelegate, cvvValidator: cvvValidator)
        
        checkoutCvvOnly.didUpdate(cvv: "12")
        
        let argumentCaptor = ArgumentCaptor<AccessCheckoutView>()
        verify(cvvOnlyDelegate).handleValidationResult(cvvView: argumentCaptor.capture(), isValid: expectedValidationResult.partial)
        XCTAssertTrue(argumentCaptor.value! === (cvvView as AccessCheckoutView))
    }
    
    func testDidEndUpdateCvvNotifiesDelegateWithCompleteValidationResult() {
        let cvvView = CVVView()
        let cvvValidator = MockCVVValidator()
        let expectedValidationResult: ValidationResult = ValidationResult(partial: false, complete: true)
        when(cvvValidator.getStubbingProxy().validate(cvv: any())).thenReturn(expectedValidationResult)
        let cvvOnlyDelegate = MockCVVOnlyDelegate()
        when(cvvOnlyDelegate.getStubbingProxy().handleValidationResult(cvvView: any(), isValid: true)).thenDoNothing()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: cvvOnlyDelegate, cvvValidator: cvvValidator)
        
        checkoutCvvOnly.didEndUpdate(cvv: "12")
        
        let argumentCaptor = ArgumentCaptor<AccessCheckoutView>()
        verify(cvvOnlyDelegate).handleValidationResult(cvvView: argumentCaptor.capture(), isValid: expectedValidationResult.complete)
        XCTAssertTrue(argumentCaptor.value! === (cvvView as AccessCheckoutView))
    }
    
    func testCannotUpdatePan() {
        let cvvView = CVVView()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: MockCVVOnlyDelegate(), cvvValidator:CVVValidator())
        
        let result = checkoutCvvOnly.canUpdate(pan: "123", withText: "4", inRange: NSRange(location: 2, length: 0))
        
        XCTAssertFalse(result)
    }
    
    func testDidUpdatePanDoesNotNotifyDelegate() {
        let cvvView = CVVView()
        let cvvOnlyDelegate = MockCVVOnlyDelegate()
        when(cvvOnlyDelegate.getStubbingProxy().handleValidationResult(cvvView: any(), isValid: any())).thenDoNothing()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: cvvOnlyDelegate, cvvValidator:CVVValidator())
        
        checkoutCvvOnly.didUpdate(pan: "")
        
        verify(cvvOnlyDelegate, never()).handleValidationResult(cvvView: any(), isValid: any())
    }
    
    func testDidEndUpdatePanDoesNotNotifyDelegate() {
        let cvvView = CVVView()
        let cvvOnlyDelegate = MockCVVOnlyDelegate()
        when(cvvOnlyDelegate.getStubbingProxy().handleValidationResult(cvvView: any(), isValid: any())).thenDoNothing()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: cvvOnlyDelegate, cvvValidator:CVVValidator())
        
        checkoutCvvOnly.didEndUpdate(pan: "")
        
        verify(cvvOnlyDelegate, never()).handleValidationResult(cvvView: any(), isValid: any())
    }
    
    func testCannotUpdateExpiryMonth() {
        let cvvView = CVVView()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator:CVVValidator())
        
        let result = checkoutCvvOnly.canUpdate(expiryMonth: "1", withText: "2", inRange: NSRange(location: 1, length: 0))
        
        XCTAssertFalse(result)
    }
    
    func testCannotUpdateExpiryYear() {
        let cvvView = CVVView()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: nil, cvvValidator:CVVValidator())
        
        let result = checkoutCvvOnly.canUpdate(expiryYear: "1", withText: "2", inRange: NSRange(location: 1, length: 0))
        
        XCTAssertFalse(result)
    }
    
    func testDidUpdateExpiryDoesNotNotifyDelegate() {
        let cvvView = CVVView()
        let cvvOnlyDelegate = MockCVVOnlyDelegate()
        when(cvvOnlyDelegate.getStubbingProxy().handleValidationResult(cvvView: any(), isValid: any())).thenDoNothing()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: cvvOnlyDelegate, cvvValidator:CVVValidator())
        
        checkoutCvvOnly.didUpdate(expiryMonth: "12", expiryYear: "34")
        
        verify(cvvOnlyDelegate, never()).handleValidationResult(cvvView: any(), isValid: any())
    }
    
    func testDidEndUpdateExpiryDoesNotNotifyDelegate() {
        let cvvView = CVVView()
        let cvvOnlyDelegate = MockCVVOnlyDelegate()
        when(cvvOnlyDelegate.getStubbingProxy().handleValidationResult(cvvView: any(), isValid: any())).thenDoNothing()
        let checkoutCvvOnly = AccessCheckoutCVVOnly(cvvView: cvvView, cvvOnlyDelegate: cvvOnlyDelegate, cvvValidator:CVVValidator())
        
        checkoutCvvOnly.didEndUpdate(expiryMonth: "12", expiryYear: "34")
        
        verify(cvvOnlyDelegate, never()).handleValidationResult(cvvView: any(), isValid: any())
    }
}
