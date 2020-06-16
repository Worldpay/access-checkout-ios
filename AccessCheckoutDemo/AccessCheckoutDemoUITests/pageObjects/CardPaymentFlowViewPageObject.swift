import XCTest

class CardPaymentFlowViewPageObject {
    private let app: XCUIApplication
    
    var panField: XCUIElement {
        return app.textFields["pan"]
    }
    
    var panText: String? {
        return panField.value as? String
    }
    
    var expiryDateText: String? {
        return expiryDateField.value as? String
    }
    
    var expiryDateField: XCUIElement {
        return app.textFields["expiryDate"]
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
    
    func typeTextIntoExpiryDate(_ text: String) {
        expiryDateField.tap()
        expiryDateField.typeText(text)
    }
    
    func typeTextIntoCvv(_ text: String) {
        cvvField.tap()
        cvvField.typeText(text)
    }
    
    func submit() {
        submitButton.tap()
    }
}
