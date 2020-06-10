@testable import AccessCheckoutSDK
import XCTest

class ValidationRuleTests: XCTestCase {
    // MARK: validate()
    
    func testValidateReturnsFalseIfTextIsEmpty() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16, 18])
        
        XCTAssertFalse(validationRule.validate(text: ""))
    }
    
    func testValidateReturnsFalseIfTextDoesNotMatchRegex() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16, 18])
        
        XCTAssertFalse(validationRule.validate(text: "abc"))
    }
    
    func testValidateReturnsTrueIfTextMatchesRegexAndValidLengthsIsEmpty() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [])
        
        XCTAssertTrue(validationRule.validate(text: "123"))
    }
    
    func testValidateReturnsTrueIfTextMatchesRegexAndIsEqualToAValidLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16, 18])
        
        XCTAssertTrue(validationRule.validate(text: "4111111111111111"))
    }
    
    func testValidateReturnsFalseIfTextMatchesRegexAndIsShorterThanAValidLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16, 18])
        
        XCTAssertFalse(validationRule.validate(text: "41111111"))
    }
    
    func testValidateReturnsFalseIfMatcherIsEmptyAndTextIsEqualToAValidLength() {
        let validationRule = ValidationRule(matcher: "", validLengths: [3])
        
        XCTAssertFalse(validationRule.validate(text: "123"))
    }
    
    func testValidateReturnsFalseIfMatcherIsNilAndTextIsShorterThanAValidLength() {
        let validationRule = ValidationRule(matcher: nil, validLengths: [3, 4])
        
        XCTAssertFalse(validationRule.validate(text: "12"))
    }
    
    func testValidateReturnsTrueIfMatcherIsNilAndTextIsEqualToAValidLength() {
        let validationRule = ValidationRule(matcher: nil, validLengths: [3, 4])
        
        XCTAssertTrue(validationRule.validate(text: "123"))
    }
    
    // MARK: textIsMatched()
    
    func testTextIsMatchedReturnsTrueWhenTextIsMatchedByMatcherButNotAsLongAsOneOfTheValidLengths() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [3])
        
        XCTAssertTrue(validationRule.textIsMatched("12"))
    }
    
    func testTextIsMatchedReturnsFalseWhenTextIsNotMatchedByMatcher() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [3])
        
        XCTAssertFalse(validationRule.textIsMatched("abc"))
    }
    
    func testTextIsMatchedReturnsTrueWhenThereIsNoMatcher() {
        let validationRule = ValidationRule(matcher: nil, validLengths: [3])
        
        XCTAssertTrue(validationRule.textIsMatched("12"))
    }
    
    func testTextIsMatchedReturnsFalseWhenMatcherIsEmptyAndTextIsNotEmpty() {
        let validationRule = ValidationRule(matcher: "", validLengths: [3])
        
        XCTAssertFalse(validationRule.textIsMatched("123"))
    }
    
    // MARK: textIsShorterOrAsLongAsMaxLength()
    
    func testTextIsShorterOrAsLongAsMaxLengthReturnsTrueWhenTextIsShorter() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [4, 5])
        
        XCTAssertTrue(validationRule.textIsShorterOrAsLongAsMaxLength("123"))
    }
    
    func testTextIsShorterOrAsLongAsMaxLengthReturnsTrueWhenTextIsAsLongAsMaxLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [2, 3])
        
        XCTAssertTrue(validationRule.textIsShorterOrAsLongAsMaxLength("123"))
    }
    
    func testTextIsShorterOrAsLongAsMaxLengthReturnsFalseWhenTextIsLongerThanMaxLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [3])
        
        XCTAssertFalse(validationRule.textIsShorterOrAsLongAsMaxLength("1234"))
    }
    
    func testTextIsShorterOrAsLongAsMaxLengthReturnsTrueWhenValidLengthsIsEmpty() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [])
        
        XCTAssertTrue(validationRule.textIsShorterOrAsLongAsMaxLength("1234"))
    }
}
