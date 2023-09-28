@testable import AccessCheckoutSDK
import XCTest

class CardValidationConfigConstructorLegacyTests: XCTestCase {
    private let builder = CardValidationConfig.builder()
    private let panTextField = UITextField()
    private let expiryDateTextField = UITextField()
    private let cvcTextField = UITextField()
    private let accessBaseUrl = "some-url"
    private let validationDelegate = MockAccessCheckoutCardValidationDelegate()
    private let acceptedCardBrands = ["visa", "amex"]

    func testShouldSetTextFieldModeToTrueIfInitWithUITextFields() {
        let cardValidationConfig = CardValidationConfig(panTextField: panTextField,
                                                        expiryDateTextField: expiryDateTextField,
                                                        cvcTextField: cvcTextField,
                                                        accessBaseUrl: "some-url",
                                                        validationDelegate: validationDelegate)

        XCTAssertTrue(cardValidationConfig.textFieldMode)
    }

    func testConfigWithHasFormattingNotEnabledByDefault() {
        let config = CardValidationConfig(panTextField: panTextField,
                                          expiryDateTextField: expiryDateTextField,
                                          cvcTextField: cvcTextField,
                                          accessBaseUrl: accessBaseUrl,
                                          validationDelegate: validationDelegate)

        XCTAssertFalse(config.panFormattingEnabled)
    }

    func testCanCreateConfigWithPanFormattingEnabled() {
        let config = CardValidationConfig(panTextField: panTextField,
                                          expiryDateTextField: expiryDateTextField,
                                          cvcTextField: cvcTextField,
                                          accessBaseUrl: accessBaseUrl,
                                          validationDelegate: validationDelegate,
                                          panFormattingEnabled: true)

        XCTAssertTrue(config.panFormattingEnabled)
    }

    func testCanCreateConfigWithoutAcceptedCardBrands() {
        let config = CardValidationConfig(panTextField: panTextField,
                                          expiryDateTextField: expiryDateTextField,
                                          cvcTextField: cvcTextField,
                                          accessBaseUrl: accessBaseUrl,
                                          validationDelegate: validationDelegate)

        XCTAssertEqual(panTextField, config.panTextField)
        XCTAssertEqual(expiryDateTextField, config.expiryDateTextField)
        XCTAssertEqual(cvcTextField, config.cvcTextField)
        XCTAssertEqual(accessBaseUrl, config.accessBaseUrl)
        XCTAssertTrue(config.validationDelegate is MockAccessCheckoutCardValidationDelegate)
        XCTAssertEqual([], config.acceptedCardBrands)
    }

    func testCanCreateConfigWithAcceptedCardBrands() {
        let config = CardValidationConfig(panTextField: panTextField,
                                          expiryDateTextField: expiryDateTextField,
                                          cvcTextField: cvcTextField,
                                          accessBaseUrl: accessBaseUrl,
                                          validationDelegate: validationDelegate,
                                          acceptedCardBrands: acceptedCardBrands)

        XCTAssertEqual(panTextField, config.panTextField)
        XCTAssertEqual(expiryDateTextField, config.expiryDateTextField)
        XCTAssertEqual(cvcTextField, config.cvcTextField)
        XCTAssertEqual(accessBaseUrl, config.accessBaseUrl)
        XCTAssertTrue(config.validationDelegate is MockAccessCheckoutCardValidationDelegate)
        XCTAssertEqual(acceptedCardBrands, config.acceptedCardBrands)
    }
}
