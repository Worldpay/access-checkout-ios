import XCTest
@testable import AccessCheckoutSDK

class ValidationRuleTests : XCTestCase {
    
    func testShouldReturnFalseIfTextIsEmpty() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16,18])
        
        XCTAssertFalse(validationRule.validate(text: ""))
    }
    
    func testShouldReturnFalseIfTextDoesNotMatchRegex() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16,18])
        
        XCTAssertFalse(validationRule.validate(text: "abc"))
    }
    
    func testShouldReturnTrueIfTextMatchesRegexAndValidLengthsIsEmpty() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [])
            
        XCTAssertTrue(validationRule.validate(text: "123"))
    }
    
    func testShouldReturnTrueIfTextMatchesRegexAndIsEqualToAValidLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16,18])
        
        XCTAssertTrue(validationRule.validate(text: "4111111111111111"))
    }
    
    func testShouldReturnFalseIfTextMatchesRegexAndIsShorterThanAValidLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16,18])
        
        XCTAssertFalse(validationRule.validate(text: "41111111"))
    }
}

