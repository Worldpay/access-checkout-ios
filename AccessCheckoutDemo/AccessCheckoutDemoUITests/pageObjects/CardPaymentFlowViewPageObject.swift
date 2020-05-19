import XCTest

class CardPaymentFlowViewPageObject {
    private let app: XCUIApplication
    
    var panField: XCUIElement {
        return app.textFields["pan"]
    }
    
    var panText: String? {
        return panField.value as? String
    }
    
    var expiryMonthField: XCUIElement {
        return app.textFields["expiryMonth"]
    }
    
    var expiryMonthText: String? {
        return expiryMonthField.value as? String
    }
    
    var expiryYearField: XCUIElement {
        return app.textFields["expiryYear"]
    }
    
    var expiryYearText: String? {
        return expiryYearField.value as? String
    }
    
    var expiryDateField: XCUIElement {
        return app.otherElements["expiryDate"]
    }
    
    var cvvField: XCUIElement {
        return app.textFields["cvv"]
    }
    
    var cvvText: String? {
        return cvvField.value as? String
    }
    
    var cardBrandImage: XCUIElement {
        return app.images["cardBrandImage"]
    }
    
    var submitButton: XCUIElement {
        return app.buttons["Submit"]
    }
    
    var paymentsCvcSessionToggleLabel: XCUIElement {
        return app.staticTexts["paymentsCvcSessionToggleLabel"]
    }
    
    var paymentsCvcSessionToggleHintLabel: XCUIElement {
        return app.staticTexts["paymentsCvcSessionToggleHintLabel"]
    }
    
    var alert: AlertViewPageObject {
        return AlertViewPageObject(element: app.alerts.firstMatch)
    }
    
    var paymentsCvcSessionToggle: SwitchViewPageObject {
        return SwitchViewPageObject(element: app.switches["paymentsCvcSessionToggle"])
    }
    
    init(_ app: XCUIApplication) {
        self.app = app
    }
    
    func typeTextIntoPan(_ text: String) {
        panField.tap()
        panField.typeText(text)
    }
    
    func typeTextIntoExpiryMonth(_ text: String) {
        expiryMonthField.tap()
        expiryMonthField.typeText(text)
    }
    
    func typeTextIntoExpiryYear(_ text: String) {
        expiryYearField.tap()
        expiryYearField.typeText(text)
    }
    
    func typeTextIntoCvv(_ text: String) {
        cvvField.tap()
        cvvField.typeText(text)
    }
    
    func submit() {
        submitButton.tap()
    }
}
