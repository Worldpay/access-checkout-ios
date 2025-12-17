import XCTest
import Foundation

struct TestUtils {
    // 25 attempts over 5 seconds
    private static let assertCardBrandMaxAttempts = 25
    private static let assertLabelMaxAttemps = 50
    private static let assertSleeptBetweenAttemptsInMs = 0.2
    
    static func isRunningOnSimulator() -> Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }

    static func wait(seconds timeoutInSeconds: TimeInterval) {
        let exp = XCTestCase().expectation(description: "Waiting for \(timeoutInSeconds)")
        _ = XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }

    static func isFocused(_ element: XCUIElement) -> Bool {
        return (element.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
    }

    static func assertLabelText(of element: XCUIElement, equals expectedText: String) {
        var currentAttempt = 1
        while element.label != expectedText && currentAttempt <= assertLabelMaxAttemps {
            currentAttempt += 1
            TestUtils.wait(seconds: assertSleeptBetweenAttemptsInMs)
        }

        XCTAssertEqual(
            element.label, expectedText,
            "Expected label text '\(expectedText)' but found '\(element.label)'")
    }

    static func simulatePasteOrFail(text: String, into textField: XCUIElement) {
        textField.tap()
        textField.typeText(text)
        
        textField.press(forDuration: 1.0)
        if XCUIApplication().menuItems["Select All"].exists {
            XCUIApplication().menuItems["Select All"].tap()
            XCUIApplication().menuItems["Copy"].tap()
        }
        
        guard !isRunningOnSimulator() else {
            UIPasteboard.general.string = text
            return
        }
        
        textField.press(forDuration: 1.0)
        textField.typeText(XCUIKeyboardKey.delete.rawValue)
        
        textField.tap()
        textField.press(forDuration: 1.0)

        let pasteMenuItem = XCUIApplication().menuItems["Paste"]
        guard pasteMenuItem.waitForExistence(timeout: 2.0) else {
            XCTFail("Failed to paste from the pasteboard")
            return
        }
        
        pasteMenuItem.tap()
        wait(seconds: 0.2)
    }

    static func assertCardBrand(of cardBrandImage: XCUIElement, is brand: String) {
        let brandAsLocalizedString = NSLocalizedString(
            brand, bundle: Bundle(for: CardFlowViewPageObject.self), comment: "")

        var currentAttempt = 1
        while brandAsLocalizedString != cardBrandImage.label
            && currentAttempt <= assertCardBrandMaxAttempts
        {

            // sleeping until next attempt
            currentAttempt += 1
            TestUtils.wait(seconds: assertSleeptBetweenAttemptsInMs)
        }

        XCTAssertEqual(brandAsLocalizedString, cardBrandImage.label)
    }

    static func assertCardBrand(of cardBrandImage: XCUIElement, isNot brand: String) {
        let brandAsLocalizedString = NSLocalizedString(
            brand, bundle: Bundle(for: CardFlowViewPageObject.self), comment: "")

        var currentAttempt = 1
        while brandAsLocalizedString == cardBrandImage.label
            && currentAttempt <= assertCardBrandMaxAttempts
        {

            // sleeping until next attempt
            currentAttempt += 1
            TestUtils.wait(seconds: assertSleeptBetweenAttemptsInMs)
        }

        XCTAssertNotEqual(brandAsLocalizedString, cardBrandImage.label)
    }
}
