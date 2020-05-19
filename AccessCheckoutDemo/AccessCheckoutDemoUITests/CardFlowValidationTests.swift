import XCTest
import Foundation
@testable import AccessCheckoutSDK

class CardPaymentFlowCardValidationTests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)
    
    let app = XCUIApplication()
    var view:CardPaymentFlowViewPageObject?
    
    override func setUp() {
        continueAfterFailure = false

        app.launch()
        view = CardPaymentFlowViewPageObject(app)
    }
    
    // MARK: PAN validation
    func testPAN_alpha() {
        view!.typeTextIntoPan("A")
        XCTAssertEqual(view!.panField.placeholderValue, view!.panText)
    }
    
    func testExpiryMonth_alpha() {
        view!.typeTextIntoExpiryMonth("A")
        XCTAssertEqual(view!.expiryMonthField.placeholderValue, view!.expiryMonthText)
    }
    
    func testExpiryYear_alpha() {
        view!.typeTextIntoExpiryYear("A")
        XCTAssertEqual(view!.expiryYearField.placeholderValue, view!.expiryYearText)
    }
    
    func testCVV_alpha() {
        view!.typeTextIntoCvv("A")
        XCTAssertEqual(view!.cvvField.placeholderValue, view!.cvvText)
    }
    
    func testPAN_maxLength() {
        view!.typeTextIntoPan("111122223333444455556666")
        XCTAssertEqual(view!.panText!.count, 19)
    }
    
    func testExpiryMonth_maxLength() {
        view!.typeTextIntoExpiryMonth("1212")
        XCTAssertEqual(view!.expiryMonthText?.count, 2)
    }
    
    func testExpiryYear_maxLength() {
        view!.typeTextIntoExpiryYear("1212")
        XCTAssertEqual(view!.expiryYearText?.count, 2)
    }
    
    func testCVV_maxLength() {
        view!.typeTextIntoCvv("123456")
        XCTAssertEqual(view!.cvvText?.count, 4)
    }

    // MARK: Card brand images
    func testBrandImage_visa() {
        let brandName = "visa"
        view!.typeTextIntoPan("4")
        XCTAssertEqual(app.images["cardBrandImage"].label, imageLabel(of: brandName))
    }
    
    func testBrandImage_mastercard() {
        let brandName = "mastercard"
        view!.typeTextIntoPan("5")
        XCTAssertEqual(app.images["cardBrandImage"].label, imageLabel(of: brandName))
    }
    
    func testBrandImage_amex() {
        let brandName = "amex"
        view!.typeTextIntoPan("34")
        XCTAssertEqual(app.images["cardBrandImage"].label, imageLabel(of: brandName))
    }
    
    func testBrandImage_unknown() {
        let brandName = "unknown_card_brand"
        view!.typeTextIntoPan("0")
        XCTAssertEqual(app.images["cardBrandImage"].label, imageLabel(of: brandName))
    }
    
    // MARK: Dynamic CVV
    func testCVV_brandValidLength() {
        let insertedCVV = "123456789"
        
        view!.typeTextIntoPan("4")
        view!.typeTextIntoCvv(insertedCVV)
        
        XCTAssertEqual(view!.cvvText, String(insertedCVV.prefix(3)))
    }

    func testPAN_removeDigits() {
        view!.typeTextIntoPan("1000")
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        
        XCTAssertEqual(view!.panText, "1")
    }
    
    func testExpiryMonth_removeDigits() {
        view!.typeTextIntoExpiryMonth("12")
        view!.typeTextIntoExpiryMonth(backspace)
        
        XCTAssertEqual(view!.expiryMonthText, "1")
    }
    
    func testExpiryYear_removeDigits() {
        view!.typeTextIntoExpiryYear("42")
        view!.typeTextIntoExpiryYear(backspace)
        
        XCTAssertEqual(view!.expiryYearText, "4")
    }

    func testCVV_removeDigits() {
        view!.typeTextIntoCvv("1234")
        view!.typeTextIntoCvv(backspace)
        view!.typeTextIntoCvv(backspace)
        view!.typeTextIntoCvv(backspace)
        
        XCTAssertEqual(view!.cvvText, "1")
    }
    
    func testSubmit_isEnabled() {
        XCTAssertFalse(view!.submitButton.isEnabled)
        
        view!.typeTextIntoPan("4111111111111111")
        view!.typeTextIntoExpiryMonth("01")
        view!.typeTextIntoExpiryYear("99")
        view!.typeTextIntoCvv("123")
        
        // Valid state
        XCTAssertTrue(view!.submitButton.isEnabled)
        
        view!.typeTextIntoCvv(backspace)
        
        // Invalid state
        XCTAssertFalse(view!.submitButton.isEnabled)
    }
    
    private func imageLabel(of: String) -> String {
        return NSLocalizedString(of,
                                 bundle: Bundle(for: type(of: self)),
                                 comment: "")
    }
}
