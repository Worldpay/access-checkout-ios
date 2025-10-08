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
    private let checkoutId = "0000-0000-0000-0000"

    func testConfigWithHasFormattingNotEnabledByDefault() throws {
        let config =
            try! builder
            .pan(panAccessCheckoutUITextField)
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
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
            .validationDelegate(validationDelegate)
            .build()

        XCTAssertEqual(panAccessCheckoutUITextField, config.pan)
        XCTAssertEqual(expiryDateAccessCheckoutUITextField, config.expiryDate)
        XCTAssertEqual(cvcAccessCheckoutUITextField, config.cvc)
        XCTAssertTrue(config.validationDelegate is MockAccessCheckoutCardValidationDelegate)
        XCTAssertEqual([], config.acceptedCardBrands)
    }

    func testCanCreateConfigWithAcceptedCardBrands() throws {
        let config =
            try! builder
            .pan(panAccessCheckoutUITextField)
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
            .build()

        XCTAssertEqual(panAccessCheckoutUITextField, config.pan)
        XCTAssertEqual(expiryDateAccessCheckoutUITextField, config.expiryDate)
        XCTAssertEqual(cvcAccessCheckoutUITextField, config.cvc)
        XCTAssertTrue(config.validationDelegate is MockAccessCheckoutCardValidationDelegate)
        XCTAssertEqual(acceptedCardBrands, config.acceptedCardBrands)
    }

    func testThrowsErrorWhenPanIsNotSpecified() throws {
        _ =
            builder
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
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
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected cvc to be provided but was not"

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
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected validation delegate to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }
}
