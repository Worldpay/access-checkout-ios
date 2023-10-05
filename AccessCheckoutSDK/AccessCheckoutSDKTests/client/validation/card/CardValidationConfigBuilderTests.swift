@testable import AccessCheckoutSDK
import XCTest

class CardValidationConfigBuilderTests: XCTestCase {
    private let builder = CardValidationConfig.builder()
    private let panTextField = UITextField()
    private let expiryDateTextField = UITextField()
    private let cvcTextField = UITextField()
    private let accessBaseUrl = "some-url"
    private let validationDelegate = MockAccessCheckoutCardValidationDelegate()
    private let acceptedCardBrands = ["visa", "amex"]

    func testConfigWithHasFormattingNotEnabledByDefault() throws {
        let config = try! builder.pan(panTextField)
            .expiryDate(expiryDateTextField)
            .cvc(cvcTextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .build()

        XCTAssertFalse(config.panFormattingEnabled)
    }

    func testCanCreateConfigWithPanFormattingEnabled() throws {
        let config = try! builder.pan(panTextField)
            .expiryDate(expiryDateTextField)
            .cvc(cvcTextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .enablePanFormatting()
            .build()

        XCTAssertTrue(config.panFormattingEnabled)
    }

    func testCanCreateConfigWithoutAcceptedCardBrands() throws {
        let config = try! builder.pan(panTextField)
            .expiryDate(expiryDateTextField)
            .cvc(cvcTextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .build()

        XCTAssertEqual(panTextField, config.panTextField)
        XCTAssertEqual(expiryDateTextField, config.expiryDateTextField)
        XCTAssertEqual(cvcTextField, config.cvcTextField)
        XCTAssertEqual(accessBaseUrl, config.accessBaseUrl)
        XCTAssertTrue(config.validationDelegate is MockAccessCheckoutCardValidationDelegate)
        XCTAssertEqual([], config.acceptedCardBrands)
    }

    func testCanCreateConfigWithAcceptedCardBrands() throws {
        let config = try! builder.pan(panTextField)
            .expiryDate(expiryDateTextField)
            .cvc(cvcTextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
            .build()

        XCTAssertEqual(panTextField, config.panTextField)
        XCTAssertEqual(expiryDateTextField, config.expiryDateTextField)
        XCTAssertEqual(cvcTextField, config.cvcTextField)
        XCTAssertEqual(accessBaseUrl, config.accessBaseUrl)
        XCTAssertTrue(config.validationDelegate is MockAccessCheckoutCardValidationDelegate)
        XCTAssertEqual(acceptedCardBrands, config.acceptedCardBrands)
    }

    func testThrowsErrorWhenPanIsNotSpecified() throws {
        _ = builder.expiryDate(expiryDateTextField)
            .cvc(cvcTextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected pan to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsErrorWhenExpiryDateIsNotSpecified() throws {
        _ = builder.pan(panTextField)
            .cvc(cvcTextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected expiry date to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsErrorWhenCvcIsNotSpecified() throws {
        _ = builder.pan(panTextField)
            .expiryDate(expiryDateTextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected cvc to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsErrorWhenAccessBaseUrlIsNotSpecified() throws {
        _ = builder.pan(panTextField)
            .expiryDate(expiryDateTextField)
            .cvc(cvcTextField)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected base url to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsErrorWhenValidationDelegateIsNotSpecified() throws {
        _ = builder.pan(panTextField)
            .expiryDate(expiryDateTextField)
            .cvc(cvcTextField)
            .accessBaseUrl(accessBaseUrl)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected validation delegate to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }
}
