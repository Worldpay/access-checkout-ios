import XCTest

struct TestUtils {
    // 25 attempts over 5 seconds
    private static let assertCardBrandMaxAttempts = 25
    private static let assertCardBrandSleeptBetweenAttemptsInMs = 0.2

    static func wait(seconds timeoutInSeconds: TimeInterval) {
        let exp = XCTestCase().expectation(description: "Waiting for \(timeoutInSeconds)")
        _ = XCTWaiter.wait(for: [exp], timeout: timeoutInSeconds)
    }

    static func isFocused(_ element: XCUIElement) -> Bool {
        return (element.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
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
            TestUtils.wait(seconds: assertCardBrandSleeptBetweenAttemptsInMs)
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
            TestUtils.wait(seconds: assertCardBrandSleeptBetweenAttemptsInMs)
        }

        XCTAssertNotEqual(brandAsLocalizedString, cardBrandImage.label)
    }

}
