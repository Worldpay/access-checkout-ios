import XCTest

class CardPaymentFlowViewPageObject {
    private let app:XCUIApplication
    
    var panField:XCUIElement {
        get {
            return app.textFields["pan"]
        }
    }
    
    var panText:String? {
        get {
            return panField.value as? String
        }
    }
    
    var expiryMonthField:XCUIElement {
        get {
            return app.textFields["expiryMonth"]
        }
    }
    
    var expiryMonthText:String? {
        get {
            return expiryMonthField.value as? String
        }
    }
    
    var expiryYearField:XCUIElement {
        get {
            return app.textFields["expiryYear"]
        }
    }
    
    var expiryYearText:String? {
        get {
            return expiryYearField.value as? String
        }
    }
    
    var expiryDateField:XCUIElement {
        get {
            return app.otherElements["expiryDate"]
        }
    }
    
    var cvvField:XCUIElement {
        get {
            return app.textFields["cvv"]
        }
    }
    
    var cvvText:String? {
        get {
            return cvvField.value as? String
        }
    }
    
    var cardBrandImage:XCUIElement {
        get {
            return app.images["cardBrandImage"]
        }
    }
    
    var submitButton:XCUIElement {
        get {
            return app.buttons["Submit"]
        }
    }
    
    var sessionsToggleLabel:XCUIElement {
        get {
            return app.staticTexts["sessionsToggleLabel"]
        }
    }
    
    var sessionsToggleHintLabel:XCUIElement {
        get {
            return app.staticTexts["sessionsToggleHintLabel"]
        }
    }
    
    var sessionsToggle:SwitchViewPageObject {
        get {
            return SwitchViewPageObject(element: app.switches["sessionsToggle"])
        }
    }
    
    var alert:AlertViewPageObject {
        get {
            return AlertViewPageObject(element: app.alerts.firstMatch)
        }
    }
    
    init(_ app:XCUIApplication) {
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
