@testable import AccessCheckoutSDK
import XCTest

class ExpiryDateFormatterTests: XCTestCase {
    private let formatter = ExpiryDateFormatter()
    
    func testDoesNotFormatEmptyText() {
        XCTAssertEqual("", formatter.format(""))
        XCTAssertEqual("", formatter.format(""))
    }
    
    func testPadsMonthGreaterThan1WithLeading0() {
        XCTAssertEqual("02/", formatter.format("2"))
        XCTAssertEqual("03/", formatter.format("3"))
        XCTAssertEqual("04/", formatter.format("4"))
        XCTAssertEqual("05/", formatter.format("5"))
        XCTAssertEqual("06/", formatter.format("6"))
        XCTAssertEqual("07/", formatter.format("7"))
        XCTAssertEqual("08/", formatter.format("8"))
        XCTAssertEqual("09/", formatter.format("9"))
    }
    
    // Month 1 is not padded because we do not know whether the end user intends to type in 01 or 10/11/12
    func testDoesNotPadMonthEqualTo1() {
        XCTAssertEqual("1", formatter.format("1"))
    }
    
    func testDoesNotPadMonthEqualTo0() {
        XCTAssertEqual("0", formatter.format("0"))
    }
    
    func testAppendsASlashAfter2DigitsMonth() {
        XCTAssertEqual("01/", formatter.format("01"))
        XCTAssertEqual("12/", formatter.format("12"))
    }
    
    func testInsertsASingleSlashBetweenMonthAndFirstDigitOfYear() {
        XCTAssertEqual("02/3", formatter.format("023"))
        XCTAssertEqual("01/3", formatter.format("13"))
        XCTAssertEqual("11/3", formatter.format("113"))
    }
    
    func testAllowsToTypeInADateWithASlash() {
        XCTAssertEqual("02/34", formatter.format("02/34"))
    }
    
    func testStripsOutNonNumericalCharacters() {
        XCTAssertEqual("03/", formatter.format("3ab"))
    }
}
