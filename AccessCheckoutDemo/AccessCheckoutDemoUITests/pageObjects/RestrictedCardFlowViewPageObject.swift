import XCTest

class RestrictedCardFlowViewPageObject {
    private let app: XCUIApplication

    var panField: XCUIElement {
        return app.otherElements["pan"].textFields.firstMatch
    }

    var panText: String? {
        return panField.value as? String
    }

    var cardBrandImage: XCUIElement {
        return app.images["cardBrandImage"]
    }

    var restrictedCardBrandsLabel: XCUIElement {
        return app.staticTexts["restrictedCardBrandsLabel"]
    }

    var panIsValidLabel: XCUIElement {
        return app.staticTexts["panIsValidLabel"]
    }

    private var dismissKeyboardButton: XCUIElement {
        return app.buttons["dismissKeyboardButton"]
    }

    init(_ app: XCUIApplication) {
        self.app = app
    }

    func typeTextIntoPan(_ text: String) {
        if !TestUtils.isFocused(panField) {
            panField.tap()
        }
        panField.typeText(text)
    }

    // This function is designed to assert the card brand displayed in the UI and contains a retry mechanism to cater
    // for what appears to be the slowness of BitRise
    func assertCardBrandIs(_ brand: String) {
        let brandAsLocalizedString = NSLocalizedString(
            brand, bundle: Bundle(for: type(of: self)), comment: "")

        // 25 attempts over 5 seconds
        let maxAttempts = 25
        let sleepTimeBetweenAttemptsInSeconds = 0.2

        var currentAttempt = 1
        while brandAsLocalizedString != cardBrandImage.label && currentAttempt <= maxAttempts {

            // sleeping until next attempt
            currentAttempt += 1
            TestUtils.wait(seconds: sleepTimeBetweenAttemptsInSeconds)

            NSLog("Expected card brand \(brandAsLocalizedString) but received \(cardBrandImage.label). Retrying, attempt \(currentAttempt)/\(maxAttempts)")
        }

        XCTAssertEqual(brandAsLocalizedString, cardBrandImage.label)
    }

    func dismissKeyboard() {
        self.dismissKeyboardButton.tap()
    }
}
