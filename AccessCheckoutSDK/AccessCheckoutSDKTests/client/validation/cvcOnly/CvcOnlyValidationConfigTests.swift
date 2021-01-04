@testable import AccessCheckoutSDK
import Foundation
import Mockingjay
import XCTest

class CvcOnlyValidationConfigTests: XCTestCase {

    func testShouldSetTextFieldModeToTrueIfInitWithUITextFields() {
        let cvcValidationConfig = CvcOnlyValidationConfig(cvcTextField: UITextField(), validationDelegate: MockAccessCheckoutCvcOnlyValidationDelegate())
        
        XCTAssertTrue(cvcValidationConfig.textFieldMode)
    }
    
    func testShouldSetTextFieldModeToFlaseIfInitWithViews() {
        let cvcValidationConfig = CvcOnlyValidationConfig( cvcView: CvcView(), validationDelegate: MockAccessCheckoutCvcOnlyValidationDelegate())
        
        XCTAssertFalse(cvcValidationConfig.textFieldMode)
    }
}
