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
        
        if !isRunningOnSimulator() {
            wait(seconds: 1.0)
        }
        
        if let selectAllButton = findButtonByLabel("Select All") {
            selectAllButton.tap()
        } else {
            XCTFail("Could not select all")
        }
        
        if let copyButton = findButtonByLabel("Copy") {
            copyButton.tap()
        } else {
            XCTFail("Could not select copy")
        }
        
        textField.tap()
        textField.tap()
        
        if isRunningOnSimulator() {
            UIPasteboard.general.string = text
        }
        
        textField.press(forDuration: 1.0)
        
        if !isRunningOnSimulator() {
            wait(seconds: 1.0)
        }
        
        if let selectAllButton = findButtonByLabel("Select All") {
            selectAllButton.tap()
        } else {
            XCTFail("Could not select all")
        }
        
        textField.typeText(XCUIKeyboardKey.delete.rawValue)
        
        textField.tap()
        textField.press(forDuration: 1.0)
        
        if !isRunningOnSimulator() {
            wait(seconds: 1.0)
        }

        if let pasteMenuItem = findButtonByLabel("Paste") {
            pasteMenuItem.tap()
        } else {
            XCTFail("Failed to paste from the pasteboard")
        }
        
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
    
    static func findButtonByLabel(_ label: String) -> XCUIElement? {
        let app = XCUIApplication()
        
        let menuItem = app.menuItems[label]
        if menuItem.waitForExistence(timeout: 2.0) {
            return menuItem
        }
        
        let button = app.buttons[label]
        if button.waitForExistence(timeout: 1.0) {
            return button
        }
        
        let staticText = app.staticTexts[label]
        if staticText.waitForExistence(timeout: 1.0) {
            return staticText
        }
        
        let otherElements = app.otherElements[label]
        if otherElements.waitForExistence(timeout: 1.0) {
            return otherElements
        }
        
        return nil
    }
    
//    static func clearAllText(from textField: XCUIElement) {
//        guard textField.exists else {
//            XCTFail("Text field does not exist")
//            return
//        }
//        
//        let currentText = textField.value as? String ?? ""
//        guard !currentText.isEmpty else { return }
//        
//        textField.tap()
//        
//        clearTextWithUserGestures(textField: textField, textLength: currentText.count)
//    }
//    
//    static func clearTextWithUserGestures(textField: XCUIElement, textLength: Int) {
//        // Method 1: Try long press to get Select All menu (most realistic)
//        textField.press(forDuration: 1.0)
//        
//        if let selectAllElement = findButtonByLabel("Select All") {
//            selectAllElement.tap()
//            textField.typeText(XCUIKeyboardKey.delete.rawValue)
//            return
//        }
//        
//        // Method 2: Try triple-tap to select all text (realistic user gesture)
//        textField.tap()
//        textField.tap()
//        textField.tap()
//        
//        // After triple-tap, try to find Select All in menu
//        if let selectAllElement = findSelectAllElement() {
//            selectAllElement.tap()
//            textField.typeText(XCUIKeyboardKey.delete.rawValue)
//            return
//        }
//        
//        // Check if triple-tap already selected the text
//        let app = XCUIApplication()
//        if app.menuItems["Cut"].exists || app.menuItems["Copy"].exists {
//            // Text is selected, just delete
//            textField.typeText(XCUIKeyboardKey.delete.rawValue)
//            return
//        }
//        
//        // Method 3: Double-tap to select word, then try to extend to Select All
//        textField.doubleTap()
//        wait(seconds: 0.5) // Give menu time to appear
//        
//        if let selectAllElement = findSelectAllElement() {
//            selectAllElement.tap()
//            textField.typeText(XCUIKeyboardKey.delete.rawValue)
//            return
//        }
//        
//        // Method 4: Position cursor and delete backwards (most reliable fallback)
//        positionCursorAtEnd(textField: textField)
//        deleteAllCharactersBackwards(textField: textField, count: textLength)
//    }
    
}
