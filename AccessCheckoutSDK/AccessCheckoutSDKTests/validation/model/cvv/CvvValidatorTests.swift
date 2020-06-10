@testable import AccessCheckoutSDK
import XCTest

class CvvValidatorTests: XCTestCase {
    private let validator = CvvValidator()
    private let defaultCvvValidationRule = ValidationRulesDefaults.instance().cvv

    // MARK: validate()

    func testValidateReturnsFalseIfCvvIsEmpty() {
        XCTAssertFalse(validator.validate(cvv: "", validationRule: defaultCvvValidationRule))
    }

    func testValidateReturnsFalseIfCvvIsNil() {
        XCTAssertFalse(validator.validate(cvv: nil, validationRule: defaultCvvValidationRule))
    }

    func testValidateReturnsFalseIfCvvIsLessThan3Digits() {
        XCTAssertFalse(validator.validate(cvv: "12", validationRule: defaultCvvValidationRule))
    }

    func testValidateReturnsFalseIfCvvIsInvalidAgainstMatcher() {
        XCTAssertFalse(validator.validate(cvv: "aaa", validationRule: defaultCvvValidationRule))
    }

    func testValidateReturnsTrueIfCvvIsThreeDigitsWithNoPan() {
        XCTAssertTrue(validator.validate(cvv: "123", validationRule: defaultCvvValidationRule))
    }

    func testValidateReturnsTrueIfCvvIsFourDigitsWithNoPan() {
        XCTAssertTrue(validator.validate(cvv: "123", validationRule: defaultCvvValidationRule))
    }

    func testValidateReturnsFalseIfCvvIsThreeDigitsWithAmexPan() {
        let cardBrandWith4Digits = createCardBrand(cvvLength: 4)

        XCTAssertFalse(validator.validate(cvv: "123", validationRule: cardBrandWith4Digits.cvvValidationRule))
    }

    func testValidateReturnstrueIfCvvIsThreeDigitsWithVisaPan() {
        let cardBrandWith3Digits = createCardBrand(cvvLength: 3)

        XCTAssertTrue(validator.validate(cvv: "123", validationRule: cardBrandWith3Digits.cvvValidationRule))
    }

    func testValidateReturnsTrueIfCvvIsFourDigitsWithAmexPan() {
        let cardBrandWith4Digits = createCardBrand(cvvLength: 4)

        XCTAssertTrue(validator.validate(cvv: "1234", validationRule: cardBrandWith4Digits.cvvValidationRule))
    }

    func testValidateReturnsFalseIfCvvIsLongerThanFourDigitsWithEmptyPan() {
        XCTAssertFalse(validator.validate(cvv: "12345", validationRule: defaultCvvValidationRule))
    }

    func testValidateReturnsFalseIfCvvIsLongerThanFourDigitsWithAmexPan() {
        let cardBrandWith4Digits = createCardBrand(cvvLength: 4)

        XCTAssertFalse(validator.validate(cvv: "12345", validationRule: cardBrandWith4Digits.cvvValidationRule))
    }

    // MARK: canValidate()

    func testCanValidateDoesNotAllowsTextThatDoesNotMatchPattern() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [3, 4])

        let result = validator.canValidate("abc", using: validationRule)

        XCTAssertFalse(result)
    }

    func testCanValidateAllowsPartialCvvMatchingPattern() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [3, 4])

        let result = validator.canValidate("12", using: validationRule)

        XCTAssertTrue(result)
    }

    func testCanValidateAllowsCvvAsLongAsMaxLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [3, 4])

        let result = validator.canValidate("1234", using: validationRule)

        XCTAssertTrue(result)
    }

    func testCanValidateDoesNotAllowPanLongerThanMaxLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [3, 4])

        let result = validator.canValidate("12345", using: validationRule)

        XCTAssertFalse(result)
    }

    private func createCardBrand(cvvLength: Int) -> CardBrandModel {
        let panValidationRule = ValidationRule(matcher: nil, validLengths: [])
        let cvvValidationRule = ValidationRule(matcher: nil, validLengths: [cvvLength])
        return CardBrandModel(name: "", images: [], panValidationRule: panValidationRule, cvvValidationRule: cvvValidationRule)
    }
}
