@testable import AccessCheckoutSDK
import XCTest

class ValidationRuleTests: XCTestCase {
    // MARK: validate()
    
    func testValidateShouldReturnFalseIfTextIsEmpty() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16, 18])
        
        XCTAssertFalse(validationRule.validate(text: ""))
    }
    
    func testValidateShouldReturnFalseIfTextDoesNotMatchRegex() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16, 18])
        
        XCTAssertFalse(validationRule.validate(text: "abc"))
    }
    
    func testValidateShouldReturnTrueIfTextMatchesRegexAndValidLengthsIsEmpty() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [])
        
        XCTAssertTrue(validationRule.validate(text: "123"))
    }
    
    func testValidateShouldReturnTrueIfTextMatchesRegexAndIsEqualToAValidLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16, 18])
        
        XCTAssertTrue(validationRule.validate(text: "4111111111111111"))
    }
    
    func testValidateShouldReturnFalseIfTextMatchesRegexAndIsShorterThanAValidLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16, 18])
        
        XCTAssertFalse(validationRule.validate(text: "41111111"))
    }
    
    // MARK: textIsMatched()
    
    func testTextIsMatchedReturnTrueWhenTextIsMatchedByMatcher() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16, 18])
        
        XCTAssertTrue(validationRule.textIsMatched(text: "123"))
    }
    
    func testTextIsMatchedReturnFalseWhenTextIsNotMatchedByMatcher() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16, 18])
        
        XCTAssertFalse(validationRule.textIsMatched(text: "abc"))
    }
    
    func testTextIsMatchedReturnFalseWhenTextIsEmpty() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [16, 18])
        
        XCTAssertFalse(validationRule.textIsMatched(text: ""))
    }
    
    func testTextIsMatchedReturnFalseWhenThereIsNoMatcher() {
        let validationRule = ValidationRule(matcher: nil, validLengths: [16, 18])
        
        XCTAssertFalse(validationRule.textIsMatched(text: "123"))
    }
    
    func testTextIsMatchedReturnFalseWhenMatcherIsEmpty() {
        let validationRule = ValidationRule(matcher: "", validLengths: [16, 18])
        
        XCTAssertFalse(validationRule.textIsMatched(text: "123"))
    }
    
    // MARK: textIsShorterOrAsLongAsMaxLength()
    
    func testTextIsShorterOrAsLongAsMaxLengthReturnsTrueWhenTextIsShorter() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [4, 5])
        
        XCTAssertTrue(validationRule.textIsShorterOrAsLongAsMaxLength(text: "123"))
    }
    
    func testTextIsShorterOrAsLongAsMaxLengthReturnsTrueWhenTextIsAsLongAsMaxLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [2, 3])
        
        XCTAssertTrue(validationRule.textIsShorterOrAsLongAsMaxLength(text: "123"))
    }
    
    func testTextIsShorterOrAsLongAsMaxLengthReturnsFalseWhenTextIsLongerThanMaxLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [3])
        
        XCTAssertFalse(validationRule.textIsShorterOrAsLongAsMaxLength(text: "1234"))
    }
    
    func testTextIsShorterOrAsLongAsMaxLengthReturnsTrueWhenValidLengthsIsEmpty() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [])
        
        XCTAssertTrue(validationRule.textIsShorterOrAsLongAsMaxLength(text: "1234"))
    }
}
