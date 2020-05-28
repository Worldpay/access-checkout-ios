import XCTest
@testable import AccessCheckoutSDK

class CvvValidatorTests : XCTestCase {
    private let visaBrand = AccessCardConfiguration.CardBrand(
        name: "visa",
        images: nil,
        matcher: "^(?!^493698\\d*$)4\\d*$",
        cvv: 3,
        pans: [16,18,19]
    )
    
    private let amexBrand = AccessCardConfiguration.CardBrand(
        name: "amex",
        images: nil,
        matcher: "^3[47]\\d*$",
        cvv: 4,
        pans: [15]
    )
    
    private let baseDefaults = AccessCardConfiguration.CardDefaults.baseDefaults()

    func testShouldReturnFalseIfCvvIsEmpty() {
        XCTAssertFalse(cvvValidator().validate(cvv: "", pan: nil))
    }
    
    func testShouldReturnFalseIfCvvIsNil() {
        XCTAssertFalse(cvvValidator().validate(cvv: nil, pan: nil))
    }
    
    func testShouldReturnFalseIfCvvIsLessThan3Digits() {
        XCTAssertFalse(cvvValidator().validate(cvv: "12", pan: nil))
    }

    func testShouldReturnFalseIfCvvIsNonNumeric() {
        XCTAssertFalse(cvvValidator().validate(cvv: "aaa", pan: nil))
    }
    
    func testShouldReturnTrueIfCvvIsThreeDigitsWithNoPan() {
        XCTAssertTrue(cvvValidator().validate(cvv: "123", pan: nil))
    }
    
    func testShouldReturnTrueIfCvvIsFourDigitsWithNoPan() {
        XCTAssertTrue(cvvValidator().validate(cvv: "123", pan: nil))
    }

    func testShouldReturnFalseIfCvvIsThreeDigitsWithAmexPan() {
        XCTAssertFalse(cvvValidator().validate(cvv: "123", pan: "3717"))
    }
    
    func testShouldReturntrueIfCvvIsThreeDigitsWithVisaPan() {
        XCTAssertTrue(cvvValidator().validate(cvv: "123", pan: "4111"))
    }
    
    func testShouldReturnTrueIfCvvIsFourDigitsWithAmexPan() {
        XCTAssertTrue(cvvValidator().validate(cvv: "1234", pan: "3717"))
    }
    
    func testShouldReturnFalseIfCvvIsLongerThanFourDigitsWithEmptyPan() {
        XCTAssertFalse(cvvValidator().validate(cvv: "12345", pan: ""))
    }
    
    func testShouldReturnFalseIfCvvIsLongerThanFourDigitsWithAmexPan() {
        XCTAssertFalse(cvvValidator().validate(cvv: "12345", pan: "3717"))
    }

    private func cvvValidator() -> CvvValidator {
        return CvvValidator(cardConfiguration: AccessCardConfiguration(defaults: baseDefaults, brands: [visaBrand, amexBrand]))
    }
}
