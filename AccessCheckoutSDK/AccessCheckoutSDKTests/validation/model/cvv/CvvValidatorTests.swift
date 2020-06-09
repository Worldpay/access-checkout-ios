@testable import AccessCheckoutSDK
import XCTest

class CvvValidatorTests: XCTestCase {
    private let cvvValidator = CvvValidator()
    let cvvValidationRule = ValidationRulesDefaults.instance().cvv

    func testShouldReturnFalseIfCvvIsEmpty() {
        XCTAssertFalse(cvvValidator.validate(cvv: "", validationRule: cvvValidationRule))
    }

    func testShouldReturnFalseIfCvvIsNil() {
        XCTAssertFalse(cvvValidator.validate(cvv: nil, validationRule: cvvValidationRule))
    }

    func testShouldReturnFalseIfCvvIsLessThan3Digits() {
        XCTAssertFalse(cvvValidator.validate(cvv: "12", validationRule: cvvValidationRule))
    }

    func testShouldReturnFalseIfCvvIsInvalidAgainstMatcher() {
        XCTAssertFalse(cvvValidator.validate(cvv: "aaa", validationRule: cvvValidationRule))
    }

    func testShouldReturnTrueIfCvvIsThreeDigitsWithNoPan() {
        XCTAssertTrue(cvvValidator.validate(cvv: "123", validationRule: cvvValidationRule))
    }

    func testShouldReturnTrueIfCvvIsFourDigitsWithNoPan() {
        XCTAssertTrue(cvvValidator.validate(cvv: "123", validationRule: cvvValidationRule))
    }

    func testShouldReturnFalseIfCvvIsThreeDigitsWithAmexPan() {
        let cardBrandWith4Digits = createCardBrand(cvvLength: 4)

        XCTAssertFalse(cvvValidator.validate(cvv: "123", validationRule: cardBrandWith4Digits.cvvValidationRule))
    }

    func testShouldReturntrueIfCvvIsThreeDigitsWithVisaPan() {
        let cardBrandWith3Digits = createCardBrand(cvvLength: 3)

        XCTAssertTrue(cvvValidator.validate(cvv: "123", validationRule: cardBrandWith3Digits.cvvValidationRule))
    }

    func testShouldReturnTrueIfCvvIsFourDigitsWithAmexPan() {
        let cardBrandWith4Digits = createCardBrand(cvvLength: 4)

        XCTAssertTrue(cvvValidator.validate(cvv: "1234", validationRule: cardBrandWith4Digits.cvvValidationRule))
    }

    func testShouldReturnFalseIfCvvIsLongerThanFourDigitsWithEmptyPan() {
        XCTAssertFalse(cvvValidator.validate(cvv: "12345", validationRule: cvvValidationRule))
    }

    func testShouldReturnFalseIfCvvIsLongerThanFourDigitsWithAmexPan() {
        let cardBrandWith4Digits = createCardBrand(cvvLength: 4)

        XCTAssertFalse(cvvValidator.validate(cvv: "12345", validationRule: cardBrandWith4Digits.cvvValidationRule))
    }

    private func createCardBrand(cvvLength: Int) -> CardBrandModel {
        let panValidationRule = ValidationRule(matcher: nil, validLengths: [])
        let cvvValidationRule = ValidationRule(matcher: nil, validLengths: [cvvLength])
        return CardBrandModel(name: "", images: [], panValidationRule: panValidationRule, cvvValidationRule: cvvValidationRule)
    }
}
