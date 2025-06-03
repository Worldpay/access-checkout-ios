import XCTest

@testable import AccessCheckoutSDK

class CardValidationConfigBuilderTests: XCTestCase {
    private let builder = CardValidationConfig.builder()
    private let panAccessCheckoutUITextField = AccessCheckoutUITextField()
    private let expiryDateAccessCheckoutUITextField = AccessCheckoutUITextField()
    private let cvcAccessCheckoutUITextField = AccessCheckoutUITextField()
    private let accessBaseUrl = "some-url"
    private let validationDelegate = MockAccessCheckoutCardValidationDelegate()
    private let acceptedCardBrands = ["visa", "amex"]

    func testConfigWithHasFormattingNotEnabledByDefault() throws {
        let config =
            try! builder
            .pan(panAccessCheckoutUITextField)
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .build()

        XCTAssertFalse(config.panFormattingEnabled)
    }

    func testCanCreateConfigWithPanFormattingEnabled() throws {
        let config =
            try! builder
            .pan(panAccessCheckoutUITextField)
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .enablePanFormatting()
            .build()

        XCTAssertTrue(config.panFormattingEnabled)
    }

    func testCanCreateConfigWithoutAcceptedCardBrands() throws {
        let config =
            try! builder
            .pan(panAccessCheckoutUITextField)
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .build()

        XCTAssertEqual(panAccessCheckoutUITextField, config.pan)
        XCTAssertEqual(expiryDateAccessCheckoutUITextField, config.expiryDate)
        XCTAssertEqual(cvcAccessCheckoutUITextField, config.cvc)
        XCTAssertEqual(accessBaseUrl, config.accessBaseUrl)
        XCTAssertTrue(config.validationDelegate is MockAccessCheckoutCardValidationDelegate)
        XCTAssertEqual([], config.acceptedCardBrands)
    }

    func testCanCreateConfigWithAcceptedCardBrands() throws {
        let config =
            try! builder
            .pan(panAccessCheckoutUITextField)
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
            .build()

        XCTAssertEqual(panAccessCheckoutUITextField, config.pan)
        XCTAssertEqual(expiryDateAccessCheckoutUITextField, config.expiryDate)
        XCTAssertEqual(cvcAccessCheckoutUITextField, config.cvc)
        XCTAssertEqual(accessBaseUrl, config.accessBaseUrl)
        XCTAssertTrue(config.validationDelegate is MockAccessCheckoutCardValidationDelegate)
        XCTAssertEqual(acceptedCardBrands, config.acceptedCardBrands)
    }

    func testThrowsErrorWhenPanIsNotSpecified() throws {
        _ =
            builder
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected pan to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsErrorWhenExpiryDateIsNotSpecified() throws {
        _ =
            builder
            .pan(panAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected expiry date to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsErrorWhenCvcIsNotSpecified() throws {
        _ =
            builder
            .pan(panAccessCheckoutUITextField)
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected cvc to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsErrorWhenAccessBaseUrlIsNotSpecified() throws {
        _ =
            builder
            .pan(panAccessCheckoutUITextField)
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected base url to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsErrorWhenValidationDelegateIsNotSpecified() throws {
        _ =
            builder
            .pan(panAccessCheckoutUITextField)
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
            .accessBaseUrl(accessBaseUrl)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected validation delegate to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }
}
