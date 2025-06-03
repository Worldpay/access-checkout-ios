import Foundation
import XCTest

@testable import AccessCheckoutSDK

class PanWithoutSpacingFormattingUITests: XCTestCase {
    private let backspace = String(XCUIKeyboardKey.delete.rawValue)

    let app = XCUIApplication()
    var view: PanWithoutSpacingPageObject?

    override func setUp() {
        continueAfterFailure = false

        app.launch()
        view = PanWithoutSpacingPageObject(app)
    }

    // MARK: Testing disabled PAN formatting

    func testDoesNotFormatPan() {
        view!.typeTextIntoPan("4111111111111111")

        XCTAssertEqual(view!.panText, "4111111111111111")
    }

    func testCanEnterOnlyDigitsInPan() {
        view!.typeTextIntoPan("4abc11111111   1111blahblah   111")

        XCTAssertEqual(view!.panText, "4111111111111111")
    }

    func testCanDeleteDigits() {
        view!.typeTextIntoPan("4111")
        XCTAssertEqual(view!.panText, "4111")

        view!.typeTextIntoPan(backspace)
        wait(0.5)
        XCTAssertEqual(view!.panText, "411")

        view!.typeTextIntoPan(backspace)
        wait(0.5)
        XCTAssertEqual(view!.panText, "41")

        view!.typeTextIntoPan(backspace)
        wait(0.5)
        XCTAssertEqual(view!.panText, "4")

        view!.typeTextIntoPan(backspace)
        wait(0.5)
        XCTAssertEqual(view!.panText, "Card number")
    }

    private func wait(_ timeoutInSeconds: TimeInterval) {
        let exp = XCTestCase().expectation(description: "Waiting for \(timeoutInSeconds)")
        _ = XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }
}
