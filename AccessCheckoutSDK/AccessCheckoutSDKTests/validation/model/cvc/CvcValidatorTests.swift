@testable import AccessCheckoutSDK
import XCTest

class CvcValidatorTests: XCTestCase {
    private let validator = CvcValidator()
    private let defaultCvcValidationRule = ValidationRulesDefaults.instance().cvc

    // MARK: validate()

    func testValidateReturnsFalseIfCvcIsEmpty() {
        XCTAssertFalse(validator.validate(cvc: "", validationRule: defaultCvcValidationRule))
    }

    func testValidateReturnsFalseIfCvcIsNil() {
        XCTAssertFalse(validator.validate(cvc: nil, validationRule: defaultCvcValidationRule))
    }

    func testValidateReturnsFalseIfCvcIsLessThan3Digits() {
        XCTAssertFalse(validator.validate(cvc: "12", validationRule: defaultCvcValidationRule))
    }

    func testValidateReturnsFalseIfCvcIsInvalidAgainstMatcher() {
        XCTAssertFalse(validator.validate(cvc: "aaa", validationRule: defaultCvcValidationRule))
    }

    func testValidateReturnsTrueIfCvcIsThreeDigitsWithNoPan() {
        XCTAssertTrue(validator.validate(cvc: "123", validationRule: defaultCvcValidationRule))
    }

    func testValidateReturnsTrueIfCvcIsFourDigitsWithNoPan() {
        XCTAssertTrue(validator.validate(cvc: "123", validationRule: defaultCvcValidationRule))
    }

    func testValidateReturnsFalseIfCvcIsThreeDigitsWithAmexPan() {
        let cardBrandWith4Digits = createCardBrand(cvcLength: 4)

        XCTAssertFalse(validator.validate(cvc: "123", validationRule: cardBrandWith4Digits.cvcValidationRule))
    }

    func testValidateReturnstrueIfCvcIsThreeDigitsWithVisaPan() {
        let cardBrandWith3Digits = createCardBrand(cvcLength: 3)

        XCTAssertTrue(validator.validate(cvc: "123", validationRule: cardBrandWith3Digits.cvcValidationRule))
    }

    func testValidateReturnsTrueIfCvcIsFourDigitsWithAmexPan() {
        let cardBrandWith4Digits = createCardBrand(cvcLength: 4)

        XCTAssertTrue(validator.validate(cvc: "1234", validationRule: cardBrandWith4Digits.cvcValidationRule))
    }

    func testValidateReturnsFalseIfCvcIsLongerThanFourDigitsWithEmptyPan() {
        XCTAssertFalse(validator.validate(cvc: "12345", validationRule: defaultCvcValidationRule))
    }

    func testValidateReturnsFalseIfCvcIsLongerThanFourDigitsWithAmexPan() {
        let cardBrandWith4Digits = createCardBrand(cvcLength: 4)

        XCTAssertFalse(validator.validate(cvc: "12345", validationRule: cardBrandWith4Digits.cvcValidationRule))
    }

    // MARK: canValidate()

    func testCanValidateDoesNotAllowsTextThatDoesNotMatchPattern() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [3, 4])

        let result = validator.canValidate("abc", using: validationRule)

        XCTAssertFalse(result)
    }

    func testCanValidateAllowsPartialCvcMatchingPattern() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [3, 4])

        let result = validator.canValidate("12", using: validationRule)

        XCTAssertTrue(result)
    }

    func testCanValidateAllowsCvcAsLongAsMaxLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [3, 4])

        let result = validator.canValidate("1234", using: validationRule)

        XCTAssertTrue(result)
    }

    func testCanValidateDoesNotAllowPanLongerThanMaxLength() {
        let validationRule = ValidationRule(matcher: "^\\d*$", validLengths: [3, 4])

        let result = validator.canValidate("12345", using: validationRule)

        XCTAssertFalse(result)
    }

    private func createCardBrand(cvcLength: Int) -> CardBrandModel {
        return TestFixtures.createCardBrandModel(
            name: "",
            panPattern: "",
            panValidLengths: [],
            cvcValidLength: cvcLength)
    }
}
