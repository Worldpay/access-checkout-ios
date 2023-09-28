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

    func testConfigWithHasFormattingNotEnabledByDefault() {
        let config = try! builder.panLegacy(panTextField)
            .expiryDateLegacy(expiryDateTextField)
            .cvcLegacy(cvcTextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .build()

        XCTAssertFalse(config.panFormattingEnabled)
    }

    func testCanCreateConfigWithPanFormattingEnabled() {
        let config = try! builder.panLegacy(panTextField)
            .expiryDateLegacy(expiryDateTextField)
            .cvcLegacy(cvcTextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .enablePanFormatting()
            .build()

        XCTAssertTrue(config.panFormattingEnabled)
    }

    func testCanCreateConfigWithoutAcceptedCardBrands() {
        let config = try! builder.panLegacy(panTextField)
            .expiryDateLegacy(expiryDateTextField)
            .cvcLegacy(cvcTextField)
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

    func testCanCreateConfigWithAcceptedCardBrands() {
        let config = try! builder.panLegacy(panTextField)
            .expiryDateLegacy(expiryDateTextField)
            .cvcLegacy(cvcTextField)
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
        _ = builder.expiryDateLegacy(expiryDateTextField)
            .cvcLegacy(cvcTextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected pan to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsErrorWhenExpiryDateIsNotSpecified() throws {
        _ = builder.panLegacy(panTextField)
            .cvcLegacy(cvcTextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected expiry date to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsErrorWhenCvcIsNotSpecified() throws {
        _ = builder.panLegacy(panTextField)
            .expiryDateLegacy(expiryDateTextField)
            .accessBaseUrl(accessBaseUrl)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected cvc to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsErrorWhenAccessBaseUrlIsNotSpecified() throws {
        _ = builder.panLegacy(panTextField)
            .expiryDateLegacy(expiryDateTextField)
            .cvcLegacy(cvcTextField)
            .validationDelegate(validationDelegate)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected base url to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }

    func testThrowsErrorWhenValidationDelegateIsNotSpecified() throws {
        _ = builder.panLegacy(panTextField)
            .expiryDateLegacy(expiryDateTextField)
            .cvcLegacy(cvcTextField)
            .accessBaseUrl(accessBaseUrl)
            .acceptedCardBrands(acceptedCardBrands)
        let expectedMessage = "Expected validation delegate to be provided but was not"

        XCTAssertThrowsError(try builder.build()) { error in
            XCTAssertEqual(expectedMessage, (error as! AccessCheckoutIllegalArgumentError).message)
        }
    }
}
