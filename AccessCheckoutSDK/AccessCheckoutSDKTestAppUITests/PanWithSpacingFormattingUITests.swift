import Foundation
import XCTest

@testable import AccessCheckoutSDK

class PanWithSpacingFormattingUITests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    let app = XCUIApplication()
    var view: PanWithSpacingPageObject?

    override func setUp() {
        continueAfterFailure = false

        app.launch()
        view = PanWithSpacingPageObject(app)
    }

    // MARK: Tests by inserting deleting text

    func testCorrectlyFormatsWhenTypingInMiddleOfPan() {
        view!.typeTextIntoPan("4111")
        view!.setPanCaretAtAndTypeIn(position: 3, text: ["4"])

        XCTAssertEqual(view!.panText!, "4114 1")
    }

    func testCorrectlyFormatsWhenPastingAndTypingInMiddleOfPan() {
        view!.typeTextIntoPan("4111")
        view!.setPanCaretAtAndTypeIn(position: 3, text: ["123", "5"])

        XCTAssertEqual(view!.panText!, "4111 2351")
    }

    func testCorrectlyFormatsWhenDeletingInMiddleOfPan() {
        view!.typeTextIntoPan("4321 4321")
        view!.setPanCaretAtAndTypeIn(position: 3, text: [backspace])

        XCTAssertEqual(view!.panText!, "4314 321")
    }

    func testCorrectlyFormatsWhenDeletingAndThenTypingInMiddleOfPan() {
        view!.typeTextIntoPan("4321 4321")
        view!.setPanCaretAtAndTypeIn(
            position: 3, text: [backspace, backspace, "3", "1234", backspace])

        XCTAssertEqual(view!.panText!, "4312 3143 21")
    }

    func testCanDeleteSingleDigitAfterSpace() {
        view!.typeTextIntoPan("43214")
        XCTAssertEqual(view!.panText!, "4321 4")

        view!.typeTextIntoPan(backspace)
        XCTAssertEqual(view!.panText!, "4321")
        XCTAssertEqual(4, view!.panCaretPosition())
    }

    func testCanDeleteFirstDigit() {
        view!.typeTextIntoPan("432145")
        XCTAssertEqual(view!.panText!, "4321 45")

        view!.setPanCaretAtAndTypeIn(position: 1, text: [backspace])

        XCTAssertEqual(view!.panText!, "3214 5")
        XCTAssertEqual(0, view!.panCaretPosition())
    }

    func testReformatsCardWhenBrandChanges() {
        view!.typeTextIntoPan("34567890123")
        XCTAssertEqual(view!.panText!, "3456 789012 3")

        view!.setPanCaretAtAndTypeIn(position: 0, text: ["4"])
        XCTAssertEqual(view!.panText!, "4345 6789 0123")

        view!.setPanCaretAtAndTypeIn(position: 0, text: ["3"])
        XCTAssertEqual(view!.panText!, "3434 567890 123")
    }

    // MARK: Tests with text that contains digits and letters and spaces

    func testExtractsDigitsOnlyFromAlphanumericEntry() {
        view!.typeTextIntoPan("123abc456defghi789zzzzzzzzzzz       zzzzzzzzz000")

        XCTAssertEqual(view!.panText!, "1234 5678 9000")
    }

    // MARK: Tests specific to spaces and caret position

    func testDeletesSpaceAndPreviousDigitWhenDeletingSpace() {
        view!.typeTextIntoPan("123456")
        XCTAssertEqual(view!.panText!, "1234 56")

        view!.setPanCaretAtAndTypeIn(position: 5, text: [backspace])

        XCTAssertEqual(view!.panText!, "1235 6")
        XCTAssertEqual(3, view!.panCaretPosition())
    }

    func testDeletesSpaceAndPreviousDigitWhenDeletingSelectedSpace() {
        view!.typeTextIntoPan("123456")
        XCTAssertEqual(view!.panText!, "1234 56")

        view!.selectPanAndTypeIn(position: 4, selectionLength: 1, text: [backspace])

        XCTAssertEqual(view!.panText!, "1235 6")
        XCTAssertEqual(3, view!.panCaretPosition())
    }

    func testMovesCaretAfterSpaceWhenInsertingDigitAtEndOfDigitsGroup() {
        view!.typeTextIntoPan("12345")
        XCTAssertEqual(view!.panText!, "1234 5")

        view!.setPanCaretAtAndTypeIn(position: 3, text: ["6"])

        XCTAssertEqual(view!.panText!, "1236 45")
        XCTAssertEqual(5, view!.panCaretPosition())
    }

    func testLeavesCaretAfterSpaceWhenDeletingDigitWhichIsJustAfterSpace() {
        view!.typeTextIntoPan("123456")
        XCTAssertEqual(view!.panText!, "1234 56")

        view!.setPanCaretAtAndTypeIn(position: 6, text: [backspace])

        XCTAssertEqual(view!.panText!, "1234 6")
        XCTAssertEqual(5, view!.panCaretPosition())
    }

    func testLeavesCaretAtSamePositionWhenSelectingTextThatStartsWithSpaceAndDeletingIt() {
        view!.typeTextIntoPan("123456789012")
        XCTAssertEqual(view!.panText!, "1234 5678 9012")

        view!.selectPanAndTypeIn(position: 4, selectionLength: 3, text: [backspace])

        XCTAssertEqual(view!.panText!, "1234 7890 12")
        XCTAssertEqual(4, view!.panCaretPosition())
    }

    private func waitFor(timeoutInSeconds: Double) {
        let exp = expectation(description: "Waiting for \(timeoutInSeconds)")
        _ = XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }
}
