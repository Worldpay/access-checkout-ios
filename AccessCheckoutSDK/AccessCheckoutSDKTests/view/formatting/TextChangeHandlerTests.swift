import XCTest

@testable import AccessCheckoutSDK

class TextChangeHandlerTests: XCTestCase {

    private let textChangeHandler = TextChangeHandler()

    func testSupportsAppendingText() {
        let originalText = "abc"
        let textChange = "de"
        let selection: NSRange = NSRange(location: 3, length: 0)

        let result = textChangeHandler.change(
            originalText: originalText, textChange: textChange, usingSelection: selection)

        XCTAssertEqual("abcde", result)
    }

    func testSupportsDeletingACharacter() {
        let originalText = "abcd"
        let textChange = ""
        let selection: NSRange = NSRange(location: 3, length: 1)

        let result = textChangeHandler.change(
            originalText: originalText, textChange: textChange, usingSelection: selection)

        XCTAssertEqual("abc", result)
    }

    func testSupportsReplacingText() {
        let originalText = "abcd"
        let textChange = "123"
        let selection: NSRange = NSRange(location: 2, length: 2)

        let result = textChangeHandler.change(
            originalText: originalText, textChange: textChange, usingSelection: selection)

        XCTAssertEqual("ab123", result)
    }

    func testSupportsDeletingASelection() {
        let originalText = "abcd"
        let textChange = ""
        let selection: NSRange = NSRange(location: 2, length: 2)

        let result = textChangeHandler.change(
            originalText: originalText, textChange: textChange, usingSelection: selection)

        XCTAssertEqual("ab", result)
    }

    func testSupportsDeletingEntireText() {
        let originalText = "abcd"
        let textChange = ""
        let selection: NSRange = NSRange(location: 0, length: originalText.count)

        let result = textChangeHandler.change(
            originalText: originalText, textChange: textChange, usingSelection: selection)

        XCTAssertEqual("", result)
    }

    func testReturnsOriginalTextWhenSelectionIsInvalid() {
        let originalText = "abcd"
        let textChange = "efg"
        let selection: NSRange = NSRange(location: 0, length: 10)

        let result = textChangeHandler.change(
            originalText: originalText, textChange: textChange, usingSelection: selection)

        XCTAssertEqual("abcd", result)
    }

    func testReturnsTextChangeWhenNoOriginalText() {
        let originalText: String? = nil
        let textChange = "123"
        let selection: NSRange = NSRange(location: 0, length: 0)

        let result = textChangeHandler.change(
            originalText: originalText, textChange: textChange, usingSelection: selection)

        XCTAssertEqual("123", result)
    }
}
