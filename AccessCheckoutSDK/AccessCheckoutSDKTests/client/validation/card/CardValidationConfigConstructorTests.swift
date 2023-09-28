@testable import AccessCheckoutSDK
import XCTest

class CardValidationConfigConstructorTests: XCTestCase {
    private let builder = CardValidationConfig.builder()
    private let panUITextField = AccessCheckoutUITextField()
    private let expiryDateUITextField = AccessCheckoutUITextField()
    private let cvcUITextField = AccessCheckoutUITextField()
    private let accessBaseUrl = "some-url"
    private let validationDelegate = MockAccessCheckoutCardValidationDelegate()
    private let acceptedCardBrands = ["visa", "amex"]

    func testShouldSetTextFieldModeToTrueIfInitWithUITextFields() {
        let cardValidationConfig = CardValidationConfig(panUITextField: panUITextField,
                                                        expiryDateUITextField: expiryDateUITextField,
                                                        cvcUITextField: cvcUITextField,
                                                        accessBaseUrl: "some-url",
                                                        validationDelegate: validationDelegate)

        XCTAssertFalse(cardValidationConfig.textFieldMode)
        XCTAssertTrue(cardValidationConfig.accessCheckoutUITextFieldMode)
    }

    func testConfigWithHasFormattingNotEnabledByDefault() {
        let config = CardValidationConfig(panUITextField: panUITextField,
                                          expiryDateUITextField: expiryDateUITextField,
                                          cvcUITextField: cvcUITextField,
                                          accessBaseUrl: accessBaseUrl,
                                          validationDelegate: validationDelegate)

        XCTAssertFalse(config.panFormattingEnabled)
    }

    func testCanCreateConfigWithPanFormattingEnabled() {
        let config = CardValidationConfig(panUITextField: panUITextField,
                                          expiryDateUITextField: expiryDateUITextField,
                                          cvcUITextField: cvcUITextField,
                                          accessBaseUrl: accessBaseUrl,
                                          validationDelegate: validationDelegate,
                                          panFormattingEnabled: true)

        XCTAssertTrue(config.panFormattingEnabled)
    }

    func testCanCreateConfigWithoutAcceptedCardBrands() {
        let config = CardValidationConfig(panUITextField: panUITextField,
                                          expiryDateUITextField: expiryDateUITextField,
                                          cvcUITextField: cvcUITextField,
                                          accessBaseUrl: accessBaseUrl,
                                          validationDelegate: validationDelegate)

        XCTAssertEqual(panUITextField, config.panUITextField)
        XCTAssertEqual(expiryDateUITextField, config.expiryDateUITextField)
        XCTAssertEqual(cvcUITextField, config.cvcUITextField)
        XCTAssertEqual(accessBaseUrl, config.accessBaseUrl)
        XCTAssertTrue(config.validationDelegate is MockAccessCheckoutCardValidationDelegate)
        XCTAssertEqual([], config.acceptedCardBrands)
    }

    func testCanCreateConfigWithAcceptedCardBrands() {
        let config = CardValidationConfig(panUITextField: panUITextField,
                                          expiryDateUITextField: expiryDateUITextField,
                                          cvcUITextField: cvcUITextField,
                                          accessBaseUrl: accessBaseUrl,
                                          validationDelegate: validationDelegate,
                                          acceptedCardBrands: acceptedCardBrands)

        XCTAssertEqual(panUITextField, config.panUITextField)
        XCTAssertEqual(expiryDateUITextField, config.expiryDateUITextField)
        XCTAssertEqual(cvcUITextField, config.cvcUITextField)
        XCTAssertEqual(accessBaseUrl, config.accessBaseUrl)
        XCTAssertTrue(config.validationDelegate is MockAccessCheckoutCardValidationDelegate)
        XCTAssertEqual(acceptedCardBrands, config.acceptedCardBrands)
    }
}
