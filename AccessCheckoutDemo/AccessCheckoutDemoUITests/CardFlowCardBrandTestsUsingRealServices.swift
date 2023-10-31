import XCTest

class CardFlowCardBrandTestsUsingRealServices: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    var view: CardFlowViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        // Stubs are not enabled so these tests will use the real remote card configuration
        let app = AppLauncher.launch()
        view = CardFlowViewPageObject(app)
    }

    // MARK: AMEX

    func testDisplaysBrandImage_AMEX_ForRange_34() {
        assertBrand(of: "3400", is: "amex")
        assertBrand(of: "3499", is: "amex")
    }

    func testDisplaysBrandImage_AMEX_ForRange_37() {
        assertBrand(of: "3700", is: "amex")
        assertBrand(of: "3799", is: "amex")
    }

    // MARK: DINERS

    func testDisplaysBrandImage_DINERS_ForRange_300_305() {
        assertBrand(of: "3000", is: "diners")
        assertBrand(of: "3059", is: "diners")
    }

    func testDisplaysBrandImage_DINERS_ForRange_3095() {
        assertBrand(of: "30950", is: "diners")
        assertBrand(of: "30959", is: "diners")
    }

    func testDisplaysBrandImage_DINERS_ForRange_36() {
        assertBrand(of: "360", is: "diners")
        assertBrand(of: "369", is: "diners")
    }

    func testDisplaysBrandImage_DINERS_ForRange_38() {
        assertBrand(of: "380", is: "diners")
        assertBrand(of: "389", is: "diners")
    }

    func testDisplaysBrandImage_DINERS_ForRange_39() {
        assertBrand(of: "390", is: "diners")
        assertBrand(of: "399", is: "diners")
    }

    // MARK: DISCOVER

    func testDisplaysBrandImage_DISCOVER_ForRange_6011() {
        assertBrand(of: "60110", is: "discover")
        assertBrand(of: "60119", is: "discover")
    }

    func testDisplaysBrandImage_DISCOVER_ForRange_644_649() {
        assertBrand(of: "6440", is: "discover")
        assertBrand(of: "6499", is: "discover")
    }

    func testDisplaysBrandImage_DISCOVER_ForRange_65() {
        assertBrand(of: "650", is: "discover")
        assertBrand(of: "659", is: "discover")
    }

    // MARK: JCB

    func testDisplaysBrandImage_JCB_ForRange_1800() {
        assertBrand(of: "18000", is: "jcb")
        assertBrand(of: "18009", is: "jcb")
    }

    func testDisplaysBrandImage_JCB_ForRange_2131() {
        assertBrand(of: "21310", is: "jcb")
        assertBrand(of: "21319", is: "jcb")
    }

    func testDisplaysBrandImage_JCB_ForRange_3088_3094() {
        assertBrand(of: "30880", is: "jcb")
        assertBrand(of: "30949", is: "jcb")
    }

    func testDisplaysBrandImage_JCB_ForRange_3096_3102() {
        assertBrand(of: "30960", is: "jcb")
        assertBrand(of: "31029", is: "jcb")
    }

    func testDisplaysBrandImage_JCB_ForRange_3112_3120() {
        assertBrand(of: "31120", is: "jcb")
        assertBrand(of: "31209", is: "jcb")
    }

    func testDisplaysBrandImage_JCB_ForRange_3158_3159() {
        assertBrand(of: "31580", is: "jcb")
        assertBrand(of: "31599", is: "jcb")
    }

    func testDisplaysBrandImage_JCB_ForRange_3337_3349() {
        assertBrand(of: "33370", is: "jcb")
        assertBrand(of: "33499", is: "jcb")
    }

    func testDisplaysBrandImage_JCB_ForRange_352_358() {
        assertBrand(of: "3520", is: "jcb")
        assertBrand(of: "3589", is: "jcb")
    }

    // MARK: MAESTRO

    func testDisplaysBrandImage_MAESTRO_ForRange_493698() {
        assertBrand(of: "4936980", is: "maestro")
        assertBrand(of: "4936989", is: "maestro")
    }

    func testDisplaysBrandImage_MAESTRO_ForRange_50000_50599() {
        assertBrand(of: "500000", is: "maestro")
        assertBrand(of: "505999", is: "maestro")
    }

    func testDisplaysBrandImage_MAESTRO_ForRange_5060_5065() {
        assertBrand(of: "50600", is: "maestro")
        assertBrand(of: "50659", is: "maestro")
    }

    func testDisplaysBrandImage_MAESTRO_ForRange_5066() {
        assertBrand(of: "50660", is: "maestro")
        assertBrand(of: "50669", is: "maestro")
    }

    func testDisplaysBrandImage_MAESTRO_ForRange_50677_50679() {
        assertBrand(of: "506770", is: "maestro")
        assertBrand(of: "506799", is: "maestro")
    }

    func testDisplaysBrandImage_MAESTRO_ForRange_50680_50699() {
        assertBrand(of: "506800", is: "maestro")
        assertBrand(of: "506999", is: "maestro")
    }

    func testDisplaysBrandImage_MAESTRO_ForRange_50700_50899() {
        assertBrand(of: "507000", is: "maestro")
        assertBrand(of: "507999", is: "maestro")
    }

    func testDisplaysBrandImage_MAESTRO_ForRange_56_59() {
        assertBrand(of: "560", is: "maestro")
        assertBrand(of: "599", is: "maestro")
    }

    func testDisplaysBrandImage_MAESTRO_ForRange_63() {
        assertBrand(of: "630", is: "maestro")
        assertBrand(of: "639", is: "maestro")
    }

    func testDisplaysBrandImage_MAESTRO_ForRange_67() {
        assertBrand(of: "670", is: "maestro")
        assertBrand(of: "679", is: "maestro")
    }

    // MARK: MASTERCARD

    func testDisplaysBrandImage_MASTERCARD_ForRange_51_55() {
        assertBrand(of: "510", is: "mastercard")
        assertBrand(of: "559", is: "mastercard")
    }

    func testDisplaysBrandImage_MASTERCARD_ForRange_22_27() {
        assertBrand(of: "220", is: "mastercard")
        assertBrand(of: "279", is: "mastercard")
    }

    // MARK: VISA

    func testDisplaysBrandImage_VISA_ForRange4() {
        assertBrand(of: "40", is: "visa")
        assertBrand(of: "49", is: "visa")
    }

    func testDisplaysBrandImage_NOT_VISA_For493698() {
        view!.typeTextIntoPan("493698")

        XCTAssertEqual("4936 98", view!.panText)
        XCTAssertFalse(view!.imageIs("visa"))
    }

    // MARK: UNKNOWN CARD BRAND

    func testDisplaysBrandImageFor_unknownCardBrand() {
        assertBrand(of: "0", is: "unknown_card_brand")
    }

    // MARK: utils

    func assertBrand(of pan: String, is brand: String) {
        if let panText = view!.panText, !panText.isEmpty {
            for _ in 0 ..< 20 {
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
