import XCTest

class CardFlowCardNumberSpacingTests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    var view: CardFlowViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        // Stubs are not enabled so these tests will use the real remote card configuration
        let app = AppLauncher.launch()
        view = CardFlowViewPageObject(app)
    }

    // MARK: Card numbers spacing per brand

    func testFormatsAmexPan() {
        view!.typeTextIntoPan("37178")
        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "amex")

        XCTAssertEqual(view!.panText!, "3717 8")

        view!.typeTextIntoPan("1111")

        XCTAssertEqual(view!.panText!, "3717 81111")

        view!.typeTextIntoPan("1111")

        XCTAssertEqual(view!.panText!, "3717 811111 111")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "3717 81111")
    }

    func testFormatsVisaPan() {
        view!.typeTextIntoPan("41111")
        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "visa")

        XCTAssertEqual(view!.panText!, "4111 1")

        view!.typeTextIntoPan("1111")

        XCTAssertEqual(view!.panText!, "4111 1111 1")

        view!.typeTextIntoPan("3333")

        XCTAssertEqual(view!.panText!, "4111 1111 1333 3")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "4111 1111 133")
    }

    func testFormatsMastercardPan() {
        view!.typeTextIntoPan("54545")
        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "mastercard")

        XCTAssertEqual(view!.panText!, "5454 5")

        view!.typeTextIntoPan("4545")

        XCTAssertEqual(view!.panText!, "5454 5454 5")

        view!.typeTextIntoPan("4545")

        XCTAssertEqual(view!.panText!, "5454 5454 5454 5")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "5454 5454 545")
    }

    func testFormatsJcbPan() {
        view!.typeTextIntoPan("35280")
        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "jcb")

        XCTAssertEqual(view!.panText!, "3528 0")

        view!.typeTextIntoPan("0070")

        XCTAssertEqual(view!.panText!, "3528 0007 0")

        view!.typeTextIntoPan("0000")

        XCTAssertEqual(view!.panText!, "3528 0007 0000 0")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "3528 0007 000")
    }

    func testFormatsDiscoverPan() {
        view!.typeTextIntoPan("60110")
        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "discover")

        XCTAssertEqual(view!.panText!, "6011 0")

        view!.typeTextIntoPan("0040")

        XCTAssertEqual(view!.panText!, "6011 0004 0")

        view!.typeTextIntoPan("0000")

        XCTAssertEqual(view!.panText!, "6011 0004 0000 0")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "6011 0004 000")
    }

    func testFormatsDinersPan() {
        view!.typeTextIntoPan("36700")
        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "diners")

        XCTAssertEqual(view!.panText!, "3670 0")

        view!.typeTextIntoPan("1020")

        XCTAssertEqual(view!.panText!, "3670 0102 0")

        view!.typeTextIntoPan("0000")

        XCTAssertEqual(view!.panText!, "3670 0102 0000 0")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "3670 0102 000")
    }

    func testFormatsMaestroPan() {
        view!.typeTextIntoPan("67596")
        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "maestro")

        XCTAssertEqual(view!.panText!, "6759 6")

        view!.typeTextIntoPan("4982")

        XCTAssertEqual(view!.panText!, "6759 6498 2")

        view!.typeTextIntoPan("6438")

        XCTAssertEqual(view!.panText!, "6759 6498 2643 8")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "6759 6498 264")
    }

    func testFormatsUnknownBrandPan() {
        view!.typeTextIntoPan("12200")

        TestUtils.assertCardBrand(of: view!.cardBrandImage, is: "unknown_card_brand")

        XCTAssertEqual(view!.panText!, "1220 0")

        view!.typeTextIntoPan("0000")

        XCTAssertEqual(view!.panText!, "1220 0000 0")

        view!.typeTextIntoPan("0000")

        XCTAssertEqual(view!.panText!, "1220 0000 0000 0")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        XCTAssertEqual(view!.panText!, "1220 0000 000")
    }
}
