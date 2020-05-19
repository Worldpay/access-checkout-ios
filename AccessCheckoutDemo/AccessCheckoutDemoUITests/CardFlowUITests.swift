@testable import AccessCheckoutSDK
import Foundation
import XCTest

class CardPaymentFlowUITests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)
    
    let app = XCUIApplication()
    var view: CardPaymentFlowViewPageObject?
    
    override func setUp() {
        continueAfterFailure = false
        
        app.launch()
        view = CardPaymentFlowViewPageObject(app)
    }
    
    // MARK: Fields existance
    
    func testCardNumberTextField_exists() {
        XCTAssertTrue(view!.panField.exists)
    }
    
    func testExpiryDateView_exists() {
        XCTAssertTrue(view!.expiryDateField.exists)
    }
    
    func testCVVTextField_exists() {
        XCTAssertTrue(view!.cvvField.exists)
    }
    
    func testCVVTextFieldPlaceholder_exists() {
        XCTAssertTrue(view!.cvvField.placeholderValue == "CVV")
    }
    
    func testCardNumberImageView_exists() {
        XCTAssertTrue(view!.cardBrandImage.exists)
    }
    
    func testPaymentsCvcSessionToggleLabel_exists() {
        XCTAssertTrue(view!.paymentsCvcSessionToggleLabel.exists)
    }
    
    func testPaymentsCvcSessionToggleHintLabel_exists() {
        XCTAssertTrue(view!.paymentsCvcSessionToggleHintLabel.exists)
    }
    
    func testPaymentsCvcSessionToggle_exists() {
        XCTAssertTrue(view!.paymentsCvcSessionToggle.exists)
    }
    
    func testPaymentsCvcSessionToggleIsOffByDefault_exists() {
        XCTAssertTrue(view!.paymentsCvcSessionToggle.isOff)
    }
}
