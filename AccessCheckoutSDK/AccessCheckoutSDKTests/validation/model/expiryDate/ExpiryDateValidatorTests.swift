import XCTest
@testable import AccessCheckoutSDK

class ExpiryDateValidatorTests : XCTestCase {
    
    let expiryDateValidator = ExpiryDateValidator()
    let targetDate = Date()

    func testShouldReturnFalseIfMonthAndYearAreEmpty() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: "", expiryYear: ""))
    }
    
    func testShouldReturnFalseIfMonthAndYearAreNil() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: nil, expiryYear: nil))
    }
    
    func testShouldReturnFalseIfMonthIsEmpty() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: "", expiryYear: getYear(dateModifier: 1)))
    }
    
    func testShouldReturnFalseIfMonthIsNil() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: nil, expiryYear: getYear(dateModifier: 1)))
    }
    
    func testShouldReturnFalseIfYearIsEmpty() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: getMonth(dateModifier: 0), expiryYear: ""))
    }

    func testShouldReturnFalseIfYearIsNil() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: getMonth(dateModifier: 0), expiryYear: nil))
    }
    
    func testShouldReturnFalseIfMonthIsInvalidAgainstMatcher() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: "13", expiryYear: getYear(dateModifier: 1)))
    }
    
    func testShouldReturnFalseIfYearIsInvalidAgainstMatcher() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: "11", expiryYear: "aa"))
    }
    
    func testShouldReturnFalseIfMonthIsShorterThanMinLength() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: "1", expiryYear: getYear(dateModifier: 1)))
    }
    
    func testShouldReturnFalseIfYearIsShorterThanMinLength() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: "12", expiryYear: "2"))
    }
    
    func testShouldReturnFalseIfMonthIsInThePastOfCurrentYear() {
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: getMonth(dateModifier: -1), expiryYear: getYear(dateModifier: 0)))
    }
    
    func testShouldReturnFalseIfYearIsInThePast() {
        let currentMonth = getMonth(dateModifier: 0)
        let pastYear = getYear(dateModifier: -1)
        
        XCTAssertFalse(expiryDateValidator.validate(expiryMonth: currentMonth, expiryYear: pastYear))
    }
    
    func testShouldReturnTrueIfDateIsCurrentMonthOfCurrentYear() {
        let currentMonth = getMonth(dateModifier: 0)
        let currentYear = getYear(dateModifier: 0)

        XCTAssertTrue(expiryDateValidator.validate(expiryMonth: currentMonth, expiryYear: currentYear))
    }
    
    func testShouldReturnTrueIfDateIsInTheFuture() {
        let currentMonth = getMonth(dateModifier: 0)
        let futureYear = getYear(dateModifier: 1)
        
        XCTAssertTrue(expiryDateValidator.validate(expiryMonth: currentMonth, expiryYear: futureYear))
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
