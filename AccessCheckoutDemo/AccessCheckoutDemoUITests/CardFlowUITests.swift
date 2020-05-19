import XCTest
import Foundation
@testable import AccessCheckoutSDK

class CardPaymentFlowUITests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)
    
    let app = XCUIApplication()
    var view:CardPaymentFlowViewPageObject?
    
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
    
    func testSessionsToggleLabel_exists() {
        XCTAssertTrue(view!.sessionsToggleLabel.exists)
    }
    
    func testSessionsToggleHintLabel_exists() {
        XCTAssertTrue(view!.sessionsToggleHintLabel.exists)
    }
    
    func testSessionsToggle_exists() {
        XCTAssertTrue(view!.sessionsToggle.exists)
    }
    
    func testSessionsToggleIsOffByDefault_exists() {
        XCTAssertTrue(view!.sessionsToggle.isOff)
    }
}

