@testable import AccessCheckoutSDK
import XCTest

class CardValidationConfigConstructorLegacyViewTests: XCTestCase {
    private let builder = CardValidationConfig.builder()
    private let panView = PanView()
    private let expiryDateView = ExpiryDateView()
    private let cvcView = CvcView()
    private let accessBaseUrl = "some-url"
    private let validationDelegate = MockAccessCheckoutCardValidationDelegate()
    private let acceptedCardBrands = ["visa", "amex"]

    func testShouldSetViewModeToFlaseIfInitWithViews() {
        let cardValidationConfig = CardValidationConfig(panView: panView,
                                                        expiryDateView: expiryDateView,
                                                        cvcView: cvcView,
                                                        accessBaseUrl: "some-url",
                                                        validationDelegate: validationDelegate)

        XCTAssertFalse(cardValidationConfig.textFieldMode)
    }

    func testConfigWithHasFormattingNotEnabledByDefault() {
        let config = CardValidationConfig(panView: panView,
                                          expiryDateView: expiryDateView,
                                          cvcView: cvcView,
                                          accessBaseUrl: accessBaseUrl,
                                          validationDelegate: validationDelegate)

        XCTAssertFalse(config.panFormattingEnabled)
    }

    func testCanCreateConfigWithPanFormattingEnabled() {
        let config = CardValidationConfig(panView: panView,
                                          expiryDateView: expiryDateView,
                                          cvcView: cvcView,
                                          accessBaseUrl: accessBaseUrl,
                                          validationDelegate: validationDelegate,
                                          panFormattingEnabled: true)

        XCTAssertTrue(config.panFormattingEnabled)
    }

    func testCanCreateConfigWithoutAcceptedCardBrands() {
        let config = CardValidationConfig(panView: panView,
                                          expiryDateView: expiryDateView,
                                          cvcView: cvcView,
                                          accessBaseUrl: accessBaseUrl,
                                          validationDelegate: validationDelegate)

        XCTAssertEqual(panView, config.panView)
        XCTAssertEqual(expiryDateView, config.expiryDateView)
        XCTAssertEqual(cvcView, config.cvcView)
        XCTAssertEqual(accessBaseUrl, config.accessBaseUrl)
        XCTAssertTrue(config.validationDelegate is MockAccessCheckoutCardValidationDelegate)
        XCTAssertEqual([], config.acceptedCardBrands)
    }

    func testCanCreateConfigWithAcceptedCardBrands() {
        let config = CardValidationConfig(panView: panView,
                                          expiryDateView: expiryDateView,
                                          cvcView: cvcView,
                                          accessBaseUrl: accessBaseUrl,
                                          validationDelegate: validationDelegate,
                                          acceptedCardBrands: acceptedCardBrands)

        XCTAssertEqual(panView, config.panView)
        XCTAssertEqual(expiryDateView, config.expiryDateView)
        XCTAssertEqual(cvcView, config.cvcView)
        XCTAssertEqual(accessBaseUrl, config.accessBaseUrl)
        XCTAssertTrue(config.validationDelegate is MockAccessCheckoutCardValidationDelegate)
        XCTAssertEqual(acceptedCardBrands, config.acceptedCardBrands)
    }
}
