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
        view!.typeTextIntoExpiryDate("A")
        XCTAssertEqual(view!.expiryDateField.placeholderValue, view!.expiryDateText)
    }
    
    func testCvc_alpha() {
        view!.typeTextIntoCvc("A")
        XCTAssertEqual(view!.cvcField.placeholderValue, view!.cvcText)
    }
    
    func testPAN_maxLength() {
        view!.typeTextIntoPan("111122223333444455556666")
        XCTAssertEqual(view!.panText!.count, 19)
    }
    
    func testExpiryDate_maxLength() {
        view!.typeTextIntoExpiryDate("12/999")
        XCTAssertEqual(view!.expiryDateText?.count, 5)
    }
    
    func testCvc_maxLength() {
        view!.typeTextIntoCvc("123456")
        XCTAssertEqual(view!.cvcText?.count, 4)
    }

    // MARK: Card brand images
    func testBrandImage_visa() {
        let brandName = "visa"
        view!.typeTextIntoPan("4")
        XCTAssertEqual(app.images["cardBrandImage"].label, imageLabel(of: brandName))
    }
    
    func testBrandImage_mastercard() {
        let brandName = "mastercard"
        view!.typeTextIntoPan("55")
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
    
    // MARK: Dynamic Cvc
    func testCvc_brandValidLength() {
        let insertedCvc = "123456789"
        
        view!.typeTextIntoPan("4")
        view!.typeTextIntoCvc(insertedCvc)
        
        XCTAssertEqual(view!.cvcText, String(insertedCvc.prefix(3)))
    }

    func testPAN_removeDigits() {
        view!.typeTextIntoPan("1000")
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        
        XCTAssertEqual(view!.panText, "1")
    }
    
    func testExpiryDate_removeDigits() {
        view!.typeTextIntoExpiryDate("12/99")
        view!.typeTextIntoExpiryDate(backspace)
        
        XCTAssertEqual(view!.expiryDateText, "12/9")
    }
    
    func testCvc_removeDigits() {
        view!.typeTextIntoCvc("1234")
        view!.typeTextIntoCvc(backspace)
        view!.typeTextIntoCvc(backspace)
        view!.typeTextIntoCvc(backspace)
        
        XCTAssertEqual(view!.cvcText, "1")
    }
    
    func testSubmit_isEnabled() {
        XCTAssertFalse(view!.submitButton.isEnabled)
        
        view!.typeTextIntoPan("4111111111111111")
        view!.typeTextIntoExpiryDate("01/34")
        view!.typeTextIntoCvc("123")
        
        // Valid state
        XCTAssertTrue(view!.submitButton.isEnabled)
        
        view!.typeTextIntoCvc(backspace)
        
        // Invalid state
        XCTAssertFalse(view!.submitButton.isEnabled)
    }
    
    private func imageLabel(of: String) -> String {
        return NSLocalizedString(of,
                                 bundle: Bundle(for: type(of: self)),
                                 comment: "")
    }
}
