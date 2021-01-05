@testable import AccessCheckoutSDK
import Foundation
import Mockingjay
import XCTest

class CardValidationConfigTests: XCTestCase {

    func testShouldSetTextFieldModeToTrueIfInitWithUITextFields() {
        let cardValidationConfig = CardValidationConfig(panTextField: UITextField(), expiryDateTextField: UITextField(), cvcTextField: UITextField(), accessBaseUrl: "some-url", validationDelegate: MockAccessCheckoutCardValidationDelegate())
        
        XCTAssertTrue(cardValidationConfig.textFieldMode)
    }
    
    func testShouldSetTextFieldModeToFlaseIfInitWithViews() {
        let cardValidationConfig = CardValidationConfig(panView: PanView(), expiryDateView: ExpiryDateView(), cvcView: CvcView(), accessBaseUrl: "some-url", validationDelegate: MockAccessCheckoutCardValidationDelegate())
        
        XCTAssertFalse(cardValidationConfig.textFieldMode)
    }
}
