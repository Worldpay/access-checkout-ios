import XCTest
@testable import AccessCheckoutSDK

class LengthValidatorTests : XCTestCase {
    
    let lengthValidator = LengthValidator()
    let cardValidationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16,18])
    
    func testShouldReturnFalseIfTextIsEmpty() {
        XCTAssertFalse(lengthValidator.validate(text: "", againstValidationRule: cardValidationRule))
    }
    
    func testShouldReturnFalseIfTextDoesNotMatchRegex() {
        XCTAssertFalse(lengthValidator.validate(text: "abc", againstValidationRule: cardValidationRule))
    }
    
    func testShouldReturnTrueIfTextMatchesRegexAndValidLengthsIsEmpty() {
        XCTAssertTrue(lengthValidator.validate(text: "123", againstValidationRule: ValidationRule(matcher: "^\\d*$", validLengths: [])))
    }
    
    func testShouldReturnTrueIfTextMatchesRegexAndIsEqualToAValidLength() {
        XCTAssertTrue(lengthValidator.validate(text: "4111111111111111", againstValidationRule: cardValidationRule))
    }
    
    func testShouldReturnFalseIfTextMatchesRegexAndIsShorterThanAValidLength() {
        XCTAssertFalse(lengthValidator.validate(text: "41111111", againstValidationRule: cardValidationRule))
    }
}
