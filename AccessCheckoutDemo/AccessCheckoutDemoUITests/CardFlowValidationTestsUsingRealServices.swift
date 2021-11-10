@testable import AccessCheckoutSDK
import Foundation
import XCTest

class CardFlowValidationTestsUsingRealServices: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    let app = XCUIApplication()
    var view: CardFlowViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        // These tests will use the remote card configuration hosted on https://npe.access.worldpay.com/access-checkout/cardTypes.json
        let app = appLauncher()
            .disableStubs(true)
            .launch()

        view = CardFlowViewPageObject(app)
    }
    
    func test13DigitsVisaPanIsValid() {
        view!.typeTextIntoPan("4911830000000")

        XCTAssertTrue(view!.imageIs("visa"))
        XCTAssertEqual(view!.panIsValidLabel.label, "valid")
    }
}
