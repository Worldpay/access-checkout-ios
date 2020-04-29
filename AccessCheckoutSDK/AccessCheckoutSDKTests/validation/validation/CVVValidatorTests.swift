import XCTest
@testable import AccessCheckoutSDK

class CVVValidatorTests : XCTestCase {
    func testByDefaultAlphabeticCvvIsNotValid() {
        let result = CVVValidator().validate(cvv: "abc")
        
        XCTAssertFalse(result.partial)
        XCTAssertFalse(result.complete)
    }
    
    func testByDefaultAlphanumericCvvIsNotValid() {
        let result = CVVValidator().validate(cvv: "a1c")
        
        XCTAssertFalse(result.partial)
        XCTAssertFalse(result.complete)
    }
    
    func testByDefaultNumericCvvShorterThan3DigitsIsOnlyPartiallyValid() {
        let result = CVVValidator().validate(cvv: "12")
        
        XCTAssertTrue(result.partial)
        XCTAssertFalse(result.complete)
    }
    
    func testByDefaultNumericCvvWithTo3DigitsIsPartiallyValidAndCompletelyValid() {
        let result = CVVValidator().validate(cvv: "123")
        
        XCTAssertTrue(result.partial)
        XCTAssertTrue(result.complete)
    }
    
    func testByDefaultNumericCvvWith4DigitsIsPartiallyValidAndCompletelyValid() {
        let result = CVVValidator().validate(cvv: "1234")
        
        XCTAssertTrue(result.partial)
        XCTAssertTrue(result.complete)
    }
    
    func testByDefaultNumericCvvLongerThan4DigitsIsNotValid() {
        let result = CVVValidator().validate(cvv: "12345")
        
        XCTAssertFalse(result.partial)
        XCTAssertFalse(result.complete)
    }
    
    func testByDefaultEmptyCvvIsOnlyPartiallyValid() {
        let result = CVVValidator().validate(cvv: "")
        
        XCTAssertTrue(result.partial)
        XCTAssertFalse(result.complete)
    }
    
    func testValidatesUsingValidationRule() {
        let expectedValidationResult = ValidationResult(partial: false, complete: true)
        let textValidatorMock = TextValidatorMock()
        textValidatorMock.validationResultToReturn = expectedValidationResult
        let cvvValidator = CVVValidator(textValidatorMock)
        let validationRule = CardConfiguration.CardValidationRule()
    
        let result = cvvValidator.validate(cvv: "some text", againstValidationRule: validationRule)
        
        XCTAssertEqual(expectedValidationResult.partial, result.partial)
        XCTAssertEqual(expectedValidationResult.complete, result.complete)
        
        XCTAssertTrue(textValidatorMock.validateCalled)
        XCTAssertEqual("some text", textValidatorMock.textPassed)
        XCTAssertEqual(validationRule, textValidatorMock.validationRulePassed)
    }
}
