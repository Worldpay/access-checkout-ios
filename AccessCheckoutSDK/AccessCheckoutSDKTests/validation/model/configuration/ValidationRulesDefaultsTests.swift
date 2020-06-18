@testable import AccessCheckoutSDK
import XCTest

class ValidationRulesDefaultsTests: XCTestCase {
    let defaults = ValidationRulesDefaults.instance()
    
    func testPanValidationRule() {
        XCTAssertEqual("^\\d{0,19}$", defaults.pan.matcher)
        XCTAssertEqual([12, 13, 14, 15, 16, 17, 18, 19], defaults.pan.validLengths)
    }
    
    func testCvcValidationRule() {
        XCTAssertEqual("^\\d{0,4}$", defaults.cvc.matcher)
        XCTAssertEqual([3, 4], defaults.cvc.validLengths)
    }
    
    func testExpiryDateValidationRule() {
        XCTAssertEqual("^((0[1-9])|(1[0-2]))\\/(\\d{2})$", defaults.expiryDate.matcher)
        XCTAssertEqual([5], defaults.expiryDate.validLengths)
    }
    
    func testExpiryDateInputValidationRule() {
        XCTAssertEqual("^(\\d{0,4})?\\/?(\\d{0,4})?$", defaults.expiryDateInput.matcher)
        XCTAssertEqual([5], defaults.expiryDateInput.validLengths)
    }
}
