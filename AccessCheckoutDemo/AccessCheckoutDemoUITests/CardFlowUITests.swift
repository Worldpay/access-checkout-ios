@testable import AccessCheckoutSDK
import Foundation
import XCTest

class CardPaymentFlowUITests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)
    
    let app = XCUIApplication()
    var view: CardFlowViewPageObject?
    
    override func setUp() {
        continueAfterFailure = false
        
        app.launch()
        view = CardFlowViewPageObject(app)
    }
    
    func testCardNumberTextField_exists() {
        XCTAssertTrue(view!.panField.exists)
    }
    
//    func testExpiryDateView_exists() {
//        XCTAssertTrue(view!.expiryDateField.exists)
//    }
//    
//    func testCvcTextField_exists() {
//        XCTAssertTrue(view!.cvcField.exists)
//    }
//    
//    func testCvcTextFieldPlaceholder_exists() {
//        XCTAssertTrue(view!.cvcField.placeholderValue == "CVC")
//    }
//    
//    func testCardBrandImageView_exists() {
//        XCTAssertTrue(view!.cardBrandImage.exists)
//    }
//    
//    func testPaymentsCvcSessionToggleLabel_exists() {
//        XCTAssertTrue(view!.paymentsCvcSessionToggleLabel.exists)
//    }
//    
//    func testPaymentsCvcSessionToggleHintLabel_exists() {
//        XCTAssertTrue(view!.paymentsCvcSessionToggleHintLabel.exists)
//    }
//    
//    func testPaymentsCvcSessionToggle_exists() {
//        XCTAssertTrue(view!.paymentsCvcSessionToggle.exists)
//    }
//    
//    func testPaymentsCvcSessionToggleIsOffByDefault() {
//        XCTAssertTrue(view!.paymentsCvcSessionToggle.isOff)
//    }
//    
//    func testPanIsValidLabel_exists() {
//        XCTAssertTrue(view!.panIsValidLabel.exists)
//    }
//    
//    func testExpiryDateIsValidLabel_exists() {
//        XCTAssertTrue(view!.expiryDateIsValidLabel.exists)
//    }
//    
//    func testCvcIsValidLabel_exists() {
//        XCTAssertTrue(view!.cvcIsValidLabel.exists)
//    }
}
