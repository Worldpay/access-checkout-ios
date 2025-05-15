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

    func imageIs(_ brand: String) -> Bool {
        let brandAsLocalizedString = NSLocalizedString(
            brand, bundle: Bundle(for: type(of: self)), comment: "")

        return cardBrandImage.label == brandAsLocalizedString
    }

    func dismissKeyboard() {
        self.dismissKeyboardButton.tap()
    }
}
