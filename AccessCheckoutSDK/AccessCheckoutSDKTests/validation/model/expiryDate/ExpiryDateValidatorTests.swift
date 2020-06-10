import XCTest
@testable import AccessCheckoutSDK

class ExpiryDateValidatorTests : XCTestCase {
    
    let expiryDateValidator = ExpiryDateValidator()
    let targetDate = Date()

    // MARK: validate()
    func testValidateReturnsFalseIfMonthAndYearAreEmpty() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: "", expiryYear: ""))
    }
    
    func testValidateReturnsFalseIfMonthAndYearAreNil() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: nil, expiryYear: nil))
    }
    
    func testValidateReturnsFalseIfMonthIsEmpty() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: "", expiryYear: getYear(dateModifier: 1)))
    }
    
    func testValidateReturnsFalseIfMonthIsNil() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: nil, expiryYear: getYear(dateModifier: 1)))
    }
    
    func testValidateReturnsFalseIfYearIsEmpty() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: getMonth(dateModifier: 0), expiryYear: ""))
    }

    func testValidateReturnsFalseIfYearIsNil() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: getMonth(dateModifier: 0), expiryYear: nil))
    }
    
    func testValidateReturnsFalseIfMonthIsInvalidAgainstMatcher() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: "13", expiryYear: getYear(dateModifier: 1)))
    }
    
    func testValidateReturnsFalseIfYearIsInvalidAgainstMatcher() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: "11", expiryYear: "aa"))
    }
    
    func testValidateReturnsFalseIfMonthIsShorterThanMinLength() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: "1", expiryYear: getYear(dateModifier: 1)))
    }
    
    func testValidateReturnsFalseIfYearIsShorterThanMinLength() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: "12", expiryYear: "2"))
    }
    
    func testValidateReturnsFalseIfMonthIsInThePastOfCurrentYear() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: getMonth(dateModifier: -1), expiryYear: getYear(dateModifier: 0)))
    }
    
    func testValidateReturnsFalseIfYearIsInThePast() {
        let currentMonth = getMonth(dateModifier: 0)
        let pastYear = getYear(dateModifier: -1)
        
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: currentMonth, expiryYear: pastYear))
    }
    
    func testValidateReturnsTrueIfDateIsCurrentMonthOfCurrentYear() {
        let currentMonth = getMonth(dateModifier: 0)
        let currentYear = getYear(dateModifier: 0)

        XCTAssertTrue(expiryDateValidator.validate(expiryMonth: currentMonth, expiryYear: currentYear))
    }
    
    func testValidateReturnsTrueIfDateIsInTheFuture() {
        let currentMonth = getMonth(dateModifier: 0)
        let futureYear = getYear(dateModifier: 1)
        
        XCTAssertTrue(expiryDateValidator.validate(expiryMonth: currentMonth, expiryYear: futureYear))
    }
    
    // MARK: canValidate(month)
    func testCanValidateMonthReturnsTrueIfTextIsTheStartOfAMonth() {
        let text = "1"
        
        XCTAssertTrue(expiryDateValidator.canValidateMonth(text))
    }
    
    func testCanValidateMonthReturnsTrueIfTextIsACompleteMonth() {
        let text = "12"
        
        XCTAssertTrue(expiryDateValidator.canValidateMonth(text))
    }
    
    func testCanValidateMonthReturnsFalseIfTextIsLongerThan2Digits() {
        let text = "123"
        
        XCTAssertFalse(expiryDateValidator.canValidateMonth(text))
    }
    
    func testCanValidateMonthReturnsFalseIfTextIs2DigitsButAnInvalidMonth() {
        let text = "13"
        
        XCTAssertFalse(expiryDateValidator.canValidateMonth(text))
    }
    
    func testCanValidateMonthReturnsFalseIfTextIsSomethingElseThanDigits() {
        let text = "ab"
        
        XCTAssertFalse(expiryDateValidator.canValidateMonth(text))
    }
    
    // MARK: canValidate(year)
    func testCanValidateYearReturnsTrueIfTextIsTheStartOfAYear() {
        let text = "1"
        
        XCTAssertTrue(expiryDateValidator.canValidateYear(text))
    }
    
    func testCanValidateYearReturnsTrueIfTextIsACompleteYear() {
        let text = "12"
        
        XCTAssertTrue(expiryDateValidator.canValidateYear(text))
    }
    
    func testCanValidateYearReturnsTrueIfTextIsAPastYear() {
        let text = "19"
        
        XCTAssertTrue(expiryDateValidator.canValidateYear(text))
    }
    
    func testCanValidateYearReturnsFalseIfTextIsLongerThan2Digits() {
        let text = "123"
        
        XCTAssertFalse(expiryDateValidator.canValidateYear(text))
    }
    
    func testCanValidateYearReturnsFalseIfTextIsSomethingElseThanDigits() {
        let text = "ab"
        
        XCTAssertFalse(expiryDateValidator.canValidateYear(text))
    }
    
    private func getMonth(dateModifier: Int) -> String {
        let monthDate = Calendar.current.date(byAdding: .month, value: dateModifier, to: targetDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        return dateFormatter.string(from: monthDate!)
    }
    
    private func getYear(dateModifier: Int) -> String {
        let yearDate = Calendar.current.date(byAdding: .year, value: dateModifier, to: targetDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        
        return dateFormatter.string(from: yearDate!)
    }

}
