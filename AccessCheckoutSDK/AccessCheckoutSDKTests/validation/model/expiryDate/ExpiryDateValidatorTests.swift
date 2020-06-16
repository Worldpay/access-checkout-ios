@testable import AccessCheckoutSDK
import XCTest

class ExpiryDateValidatorTests: XCTestCase {
    private let expiryDateValidator = ExpiryDateValidator()
    private let targetDate = Date()
    
    // MARK: validate()
    
    func testValidateReturnsFalseIfEmpty() {
        XCTAssertFalse(expiryDateValidator.validate(""))
    }
    
    func testValidateReturnsFalseIfMonthIsEmpty() {
        XCTAssertFalse(expiryDateValidator.validate("/34"))
    }
    
    func testValidateReturnsFalseIfYearIsEmpty() {
        XCTAssertFalse(expiryDateValidator.validate("10/"))
    }
    
    func testValidateReturnsFalseIfMonthIsNotANumber() {
        XCTAssertFalse(expiryDateValidator.validate("aa/34"))
    }
    
    func testValidateReturnsFalseIfMonthIsGreaterThan13() {
        XCTAssertFalse(expiryDateValidator.validate("13/34"))
    }
    
    func testValidateReturnsFalseIfYearIsNotANumber() {
        XCTAssertFalse(expiryDateValidator.validate("11/aa"))
    }
    
    func testValidateReturnsFalseIfMonthIsOneDigit() {
        XCTAssertFalse(expiryDateValidator.validate("1/34"))
    }
    
    func testValidateReturnsFalseIfYearIsOneDigit() {
        XCTAssertFalse(expiryDateValidator.validate("12/3"))
    }
    
    func testValidateReturnsFalseIfDateIsInThePast() {
        XCTAssertFalse(expiryDateValidator.validate("03/20"))
    }
    
    func testValidateReturnsTrueIfDateIsCurrentMonthOfCurrentYear() {
        XCTAssertTrue(expiryDateValidator.validate(expiryDateOfCurrentMonthAndYear()))
    }
    
    func testValidateReturnsTrueIfDateIsInTheFuture() {
        XCTAssertTrue(expiryDateValidator.validate("03/34"))
    }
    
    // MARK: canValidate
    
    func testCanValidateReturnsFalseIfTextIsNonNumericalCharacters() {
        XCTAssertFalse(expiryDateValidator.canValidate("ab"))
        XCTAssertFalse(expiryDateValidator.canValidate("?&"))
        
        XCTAssertFalse(expiryDateValidator.canValidate("abcd"))
        XCTAssertFalse(expiryDateValidator.canValidate("?&*%"))
        
        XCTAssertFalse(expiryDateValidator.canValidate("ab/cd"))
        XCTAssertFalse(expiryDateValidator.canValidate("?&/*%"))
    }
    
    func testCanValidateReturnsTrueIfTextIsDigitsOnlyAndUpTo4CharactersLong() {
        XCTAssertTrue(expiryDateValidator.canValidate("9"))
        XCTAssertTrue(expiryDateValidator.canValidate("99"))
        XCTAssertTrue(expiryDateValidator.canValidate("999"))
        XCTAssertTrue(expiryDateValidator.canValidate("9999"))
    }
    
    func testCanValidateReturnsTrueIfTextIsDigitsOnlyAnd5CharactersLong() {
        XCTAssertTrue(expiryDateValidator.canValidate("99999"))
    }
    
    func testCanValidateReturnsFalseIfTextIsDigitsOnlyAndLongerThan5Characters() {
        XCTAssertFalse(expiryDateValidator.canValidate("999999"))
    }
    
    func testCanValidateReturnsTrueIfTextContainsASlashAndAnyNumberOfDigitsOnEachSideAndUpTo5CharactersLong() {
        XCTAssertTrue(expiryDateValidator.canValidate("/"))
        XCTAssertTrue(expiryDateValidator.canValidate("9/"))
        XCTAssertTrue(expiryDateValidator.canValidate("9/9"))
        XCTAssertTrue(expiryDateValidator.canValidate("9/99"))
        XCTAssertTrue(expiryDateValidator.canValidate("9/999"))
        
        XCTAssertTrue(expiryDateValidator.canValidate("99/"))
        XCTAssertTrue(expiryDateValidator.canValidate("99/9"))
        XCTAssertTrue(expiryDateValidator.canValidate("99/99"))
        
        XCTAssertTrue(expiryDateValidator.canValidate("999/"))
        XCTAssertTrue(expiryDateValidator.canValidate("999/9"))
        
        XCTAssertTrue(expiryDateValidator.canValidate("/9"))
        XCTAssertTrue(expiryDateValidator.canValidate("/99"))
        XCTAssertTrue(expiryDateValidator.canValidate("/999"))
        
        XCTAssertTrue(expiryDateValidator.canValidate("9999/"))
        XCTAssertTrue(expiryDateValidator.canValidate("/9999"))
    }
    
    func testCanValidateReturnsTrueIfTextIsAValidExpiryDate() {
        XCTAssertTrue(expiryDateValidator.canValidate("12/34"))
    }
    
    private func expiryDateOfCurrentMonthAndYear() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        
        return dateFormatter.string(from: date)
    }
}
