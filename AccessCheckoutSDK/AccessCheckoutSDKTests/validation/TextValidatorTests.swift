import XCTest
@testable import AccessCheckoutSDK

class TextValidatorTests : XCTestCase {
    let textValidator = TextValidator()
    
    func testEmptyTextIsOnlyPartiallyValid(){
        let validationRule = CardConfiguration.CardValidationRule()
        
        let result = textValidator.validate(text: "", againstValidationRule: validationRule)
        
        XCTAssertTrue(result.partial)
        XCTAssertFalse(result.complete)
    }
    
    func testTextNotMatchingRegexIsNotValid() {
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.matcher = "^\\d{2,4}$"
        
        let result = textValidator.validate(text: "abc", againstValidationRule: validationRule)
        
        XCTAssertFalse(result.partial)
        XCTAssertFalse(result.complete)
    }
    
    func testTextShorterThanValidLengthOnlyPartiallyValid() {
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.validLength = 3
        
        let result = textValidator.validate(text: "12", againstValidationRule: validationRule)
        
        XCTAssertTrue(result.partial)
        XCTAssertFalse(result.complete)
    }
    
    func testTextAsLongAsValidLengthIsPartiallyValidAndCompletelyValid() {
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.validLength = 3
        
        let result = textValidator.validate(text: "123", againstValidationRule: validationRule)
        
        XCTAssertTrue(result.partial)
        XCTAssertTrue(result.complete)
    }
    
    func testTextLongerThanValidLengthIsNotValid() {
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.validLength = 3
        
        let result = textValidator.validate(text: "1234", againstValidationRule: validationRule)
        
        XCTAssertFalse(result.partial)
        XCTAssertFalse(result.complete)
    }

    func testTextAsLongAsMinLengthIsPartiallyValidAndCompletelyValid(){
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.minLength = 3
        
        let result = textValidator.validate(text: "123", againstValidationRule: validationRule)
        
        XCTAssertTrue(result.partial)
        XCTAssertTrue(result.complete)
    }
    
    func testTextShorterThanMinLengthIsOnlyPartiallyValid(){
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.minLength = 3
        
        let result = textValidator.validate(text: "12", againstValidationRule: validationRule)
        
        XCTAssertTrue(result.partial)
        XCTAssertFalse(result.complete)
    }
    
    func testTextLongerThanMinLengthIsPartiallyValidAndCompletelyValid(){
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.minLength = 3
        
        let result = textValidator.validate(text: "1234", againstValidationRule: validationRule)
        
        XCTAssertTrue(result.partial)
        XCTAssertTrue(result.complete)
    }
    
    func testTextShorterThanMaxLengthIsOnlyPartiallyValid(){
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.maxLength = 3
        
        let result = textValidator.validate(text: "12", againstValidationRule: validationRule)
        
        XCTAssertTrue(result.partial)
        XCTAssertFalse(result.complete)
    }
    
    func testTextAsLongAsMaxLengthIsPartiallyValidAndCompletelyValid(){
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.maxLength = 3
        
        let result = textValidator.validate(text: "123", againstValidationRule: validationRule)
        
        XCTAssertTrue(result.partial)
        XCTAssertTrue(result.complete)
    }
    
    func testTextLongerThanMaxLengthIsNotValid(){
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.maxLength = 3
        
        let result = textValidator.validate(text: "1234", againstValidationRule: validationRule)
        
        XCTAssertFalse(result.partial)
        XCTAssertFalse(result.complete)
    }
    
    func testTextLongerThanMinLengthAndShorterThanMaxLengthIsPartiallyValidAndCompletelyValid() {
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.minLength = 3
        validationRule.maxLength = 5
        
        let result = textValidator.validate(text: "1234", againstValidationRule: validationRule)
        
        XCTAssertTrue(result.partial)
        XCTAssertTrue(result.complete)
    }
    
    func testTextAsLongAsMinLengthAndShorterThanMaxLengthIsPartiallyValidAndCompletelyValid() {
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.minLength = 3
        validationRule.maxLength = 5
        
        let result = textValidator.validate(text: "123", againstValidationRule: validationRule)
        
        XCTAssertTrue(result.partial)
        XCTAssertTrue(result.complete)
    }
    
    func testTextLongerThanMinLengthAndAsLongAsMaxLengthIsPartiallyValidAndCompletelyValid() {
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.minLength = 3
        validationRule.maxLength = 5
        
        let result = textValidator.validate(text: "12345", againstValidationRule: validationRule)
        
        XCTAssertTrue(result.partial)
        XCTAssertTrue(result.complete)
    }
    
    func testTextAsLongAsMinLengthAndAsLongAsMaxLengthIsPartiallyValidAndCompletelyValid() {
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.minLength = 4
        validationRule.maxLength = 4
        
        let result = textValidator.validate(text: "1234", againstValidationRule: validationRule)
        
        XCTAssertTrue(result.partial)
        XCTAssertTrue(result.complete)
    }
    
    func testRuleRegexTakesPrecedenceOverAllOtherCriteria(){
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.matcher = "^[0-9]{3}$"
        validationRule.validLength = 3
        validationRule.minLength = 2
        validationRule.maxLength = 4
        
        let result = textValidator.validate(text: "abc", againstValidationRule: validationRule)
        
        XCTAssertFalse(result.partial)
        XCTAssertFalse(result.complete)
    }
    
    func testRuleValidLengthTakesPrecedenceOverMinLengthAndMaxLength(){
        var validationRule = CardConfiguration.CardValidationRule()
        validationRule.matcher = "^[0-9]{3}$"
        validationRule.validLength = 3
        validationRule.minLength = 6
        validationRule.maxLength = 7
        
        let result = textValidator.validate(text: "123", againstValidationRule: validationRule)
        
        XCTAssertTrue(result.partial)
        XCTAssertTrue(result.complete)
    }
}
