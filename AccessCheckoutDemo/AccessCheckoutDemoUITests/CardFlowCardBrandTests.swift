@testable import AccessCheckoutSDK
import Foundation
import XCTest

class CardFlowCardBrandTests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    let app = XCUIApplication()
    var view: CardFlowViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        app.launch()
        view = CardFlowViewPageObject(app)
    }

    // MARK: AMEX

    func testDisplaysBrandImage_AMEX_ForRange_34() {
        assertBrand(is: "amex", for: "3400")
        assertBrand(is: "amex", for: "3499")
    }

    func testDisplaysBrandImage_AMEX_ForRange_37() {
        assertBrand(is: "amex", for: "3700")
        assertBrand(is: "amex", for: "3799")
    }

    // MARK: DINERS

    func testDisplaysBrandImage_DINERS_ForRange_300_305() {
        assertBrand(is: "diners", for: "3000")
        assertBrand(is: "diners", for: "3059")
    }

    func testDisplaysBrandImage_DINERS_ForRange_36() {
        assertBrand(is: "diners", for: "360")
        assertBrand(is: "diners", for: "369")
    }

    func testDisplaysBrandImage_DINERS_ForRange_38() {
        assertBrand(is: "diners", for: "380")
        assertBrand(is: "diners", for: "389")
    }

    func testDisplaysBrandImage_DINERS_ForRange_39() {
        assertBrand(is: "diners", for: "390")
        assertBrand(is: "diners", for: "399")
    }

    // MARK: DISCOVER

    func testDisplaysBrandImage_DISCOVER_ForRange_6011() {
        assertBrand(is: "discover", for: "60110")
        assertBrand(is: "discover", for: "60119")
    }

    func testDisplaysBrandImage_DISCOVER_ForRange_644_649() {
        assertBrand(is: "discover", for: "6440")
        assertBrand(is: "discover", for: "6449")
    }

    func testDisplaysBrandImage_DISCOVER_ForRange_65() {
        assertBrand(is: "discover", for: "650")
        assertBrand(is: "discover", for: "659")
    }

    // MARK: JCB

    func testDisplaysBrandImage_JCB_ForRange_352_358() {
        assertBrand(is: "jcb", for: "3520")
        assertBrand(is: "jcb", for: "3589")
    }

    func testDisplaysBrandImage_JCB_ForRange_2131() {
        assertBrand(is: "jcb", for: "21310")
        assertBrand(is: "jcb", for: "21319")
    }

    func testDisplaysBrandImage_JCB_ForRange_1800() {
        assertBrand(is: "jcb", for: "18000")
        assertBrand(is: "jcb", for: "18009")
    }

    // MARK: MAESTRO

    func testDisplaysBrandImage_MAESTRO_ForRange_493698() {
        assertBrand(is: "maestro", for: "4936980")
        assertBrand(is: "maestro", for: "4936989")
    }

    func testDisplaysBrandImage_MAESTRO_ForRange_50000_50599() {
        assertBrand(is: "maestro", for: "500000")
        assertBrand(is: "maestro", for: "505999")
    }

    func testDisplaysBrandImage_MAESTRO_ForRange_5060_5065() {
        assertBrand(is: "maestro", for: "50600")
        assertBrand(is: "maestro", for: "50659")
    }
    
    func testDisplaysBrandImage_MAESTRO_ForRange_5066() {
        assertBrand(is: "maestro", for: "50660")
        assertBrand(is: "maestro", for: "50669")
    }
    
    func testDisplaysBrandImage_MAESTRO_ForRange_50677_50679() {
        assertBrand(is: "maestro", for: "506770")
        assertBrand(is: "maestro", for: "506799")
    }
    
    func testDisplaysBrandImage_MAESTRO_ForRange_50680_50699() {
        assertBrand(is: "maestro", for: "506800")
        assertBrand(is: "maestro", for: "506999")
    }
    
    func testDisplaysBrandImage_MAESTRO_ForRange_50700_50899() {
        assertBrand(is: "maestro", for: "507000")
        assertBrand(is: "maestro", for: "507999")
    }
    
    func testDisplaysBrandImage_MAESTRO_ForRange_56_59() {
        assertBrand(is: "maestro", for: "560")
        assertBrand(is: "maestro", for: "599")
    }
    
    func testDisplaysBrandImage_MAESTRO_ForRange_63() {
        assertBrand(is: "maestro", for: "630")
        assertBrand(is: "maestro", for: "639")
    }
    
    func testDisplaysBrandImage_MAESTRO_ForRange_67() {
        assertBrand(is: "maestro", for: "670")
        assertBrand(is: "maestro", for: "679")
    }

    // MARK: MASTERCARD

    func testDisplaysBrandImage_MASTERCARD_ForRange_51_55() {
        assertBrand(is: "mastercard", for: "510")
        assertBrand(is: "mastercard", for: "559")
    }

    func testDisplaysBrandImage_MASTERCARD_ForRange_22_27() {
        assertBrand(is: "mastercard", for: "220")
        assertBrand(is: "mastercard", for: "279")
    }

    // MARK: VISA

    func testDisplaysBrandImage_VISA_ForRange4() {
        assertBrand(is: "visa", for: "40")
        assertBrand(is: "visa", for: "49")
    }

    func testDisplaysBrandImage_NOT_VISA_For493698() {
        view!.typeTextIntoPan("493698")

        XCTAssertEqual("4936 98", view!.panText)
        XCTAssertFalse(view!.imageIs("visa"))
    }

    // MARK: UNKNOWN CARD BRAND

    func testDisplaysBrandImageFor_unknownCardBrand() {
        assertBrand(is: "unknown_card_brand", for: "0")
    }

    // MARK: utils

    func assertBrand(is brand: String, for pan: String) {
        if let panText = view!.panText, !panText.isEmpty {
            for _ in 0..<20 {
                view!.typeTextIntoPan(backspace)
            }
            
            XCTAssertEqual("Card Number", view!.panText)
            XCTAssertTrue(view!.imageIs("unknown_card_brand"))
        }

        view!.typeTextIntoPan(pan)

        let panViewText = view!.panText?.replacingOccurrences(of: " ", with: "")
        XCTAssertEqual(pan, panViewText)
        XCTAssertTrue(view!.imageIs(brand))
    }
}
