@testable import AccessCheckoutSDK
import XCTest

class ValidationRuleDefaultsTests: XCTestCase {
    let defaults = ValidationRulesDefaults.instance()
    
    func testPanValidationRule() {
        XCTAssertEqual("^\\d{0,19}$", defaults.pan?.matcher)
        XCTAssertEqual([12, 13, 14, 15, 16, 17, 18, 19], defaults.pan?.validLengths)
    }
    
    func testCvvValidationRule() {
        XCTAssertEqual("^\\d{0,4}$", defaults.cvv?.matcher)
        XCTAssertEqual([3, 4], defaults.cvv?.validLengths)
    }
    
    func testExpiryMonthValidationRule() {
        XCTAssertEqual("^0[1-9]{0,1}$|^1[0-2]{0,1}$", defaults.expiryMonth?.matcher)
        XCTAssertEqual([2], defaults.expiryMonth?.validLengths)
    }
    
    func testExpiryYearValidationRule() {
        XCTAssertEqual("^\\d{0,2}$", defaults.expiryYear?.matcher)
        XCTAssertEqual([2], defaults.expiryYear?.validLengths)
    }
}
