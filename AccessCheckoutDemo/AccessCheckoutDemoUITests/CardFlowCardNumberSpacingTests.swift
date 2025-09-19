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
//        view!.typeTextIntoPanCharByChar("37178")
        view!.typeTextIntoPanCharByChar("37178")
        XCTAssertTrue(view!.imageIs("amex"))

        XCTAssertEqual(view!.panText!, "3717 8")

        view!.typeTextIntoPanCharByChar("1111")

        XCTAssertEqual(view!.panText!, "3717 81111")

        view!.typeTextIntoPanCharByChar("1111")

        XCTAssertEqual(view!.panText!, "3717 811111 111")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "3717 81111")
    }

    func testFormatsVisaPan() {
        view!.typeTextIntoPanCharByChar("41111")
        XCTAssertTrue(view!.imageIs("visa"))

        XCTAssertEqual(view!.panText!, "4111 1")

        view!.typeTextIntoPanCharByChar("1111")

        XCTAssertEqual(view!.panText!, "4111 1111 1")

        view!.typeTextIntoPanCharByChar("3333")

        XCTAssertEqual(view!.panText!, "4111 1111 1333 3")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "4111 1111 133")
    }

    func testFormatsMastercardPan() {
        view!.typeTextIntoPanCharByChar("54545")
        XCTAssertTrue(view!.imageIs("mastercard"))

        XCTAssertEqual(view!.panText!, "5454 5")

        view!.typeTextIntoPanCharByChar("4545")

        XCTAssertEqual(view!.panText!, "5454 5454 5")

        view!.typeTextIntoPanCharByChar("4545")

        XCTAssertEqual(view!.panText!, "5454 5454 5454 5")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "5454 5454 545")
    }

    func testFormatsJcbPan() {
        view!.typeTextIntoPanCharByChar("35280")
        XCTAssertTrue(view!.imageIs("jcb"))

        XCTAssertEqual(view!.panText!, "3528 0")

        view!.typeTextIntoPanCharByChar("0070")

        XCTAssertEqual(view!.panText!, "3528 0007 0")

        view!.typeTextIntoPanCharByChar("0000")

        XCTAssertEqual(view!.panText!, "3528 0007 0000 0")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "3528 0007 000")
    }

    func testFormatsDiscoverPan() {
        view!.typeTextIntoPanCharByChar("60110")
        XCTAssertTrue(view!.imageIs("discover"))

        XCTAssertEqual(view!.panText!, "6011 0")

        view!.typeTextIntoPanCharByChar("0040")

        XCTAssertEqual(view!.panText!, "6011 0004 0")

        view!.typeTextIntoPanCharByChar("0000")

        XCTAssertEqual(view!.panText!, "6011 0004 0000 0")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "6011 0004 000")
    }

    func testFormatsDinersPan() {
//        view!.typeTextIntoPan("36700")
        view!.typeTextIntoPanCharByChar("36700")
        XCTAssertTrue(view!.imageIs("diners"))

        XCTAssertEqual(view!.panText!, "3670 0")

        view!.typeTextIntoPanCharByChar("1020")

        XCTAssertEqual(view!.panText!, "3670 0102 0")

        view!.typeTextIntoPanCharByChar("0000")

        XCTAssertEqual(view!.panText!, "3670 0102 0000 0")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "3670 0102 000")
    }

    func testFormatsMaestroPan() {
        view!.typeTextIntoPanCharByChar("67596")
        XCTAssertTrue(view!.imageIs("maestro"))

        XCTAssertEqual(view!.panText!, "6759 6")

        view!.typeTextIntoPanCharByChar("4982")

        XCTAssertEqual(view!.panText!, "6759 6498 2")

        view!.typeTextIntoPanCharByChar("6438")

        XCTAssertEqual(view!.panText!, "6759 6498 2643 8")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "6759 6498 264")
    }

    func testFormatsUnknownBrandPan() {
        view!.typeTextIntoPanCharByChar("12200")
        XCTAssertTrue(view!.imageIs("unknown_card_brand"))

        XCTAssertEqual(view!.panText!, "1220 0")

        view!.typeTextIntoPanCharByChar("0000")

        XCTAssertEqual(view!.panText!, "1220 0000 0")

        view!.typeTextIntoPanCharByChar("0000")

        XCTAssertEqual(view!.panText!, "1220 0000 0000 0")

        view!.typeTextIntoPan(backspace)
        view!.typeTextIntoPan(backspace)

        XCTAssertEqual(view!.panText!, "1220 0000 000")
    }
}
