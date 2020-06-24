import XCTest

class CvcFlowViewPageObject {
    private let app:XCUIApplication

    var cvcField:XCUIElement {
        get {
            return app.textFields["cvc"]
        }
    }
    
    var cvcText:String? {
        get {
            return cvcField.value as? String
        }
    }
    
    var submitButton:XCUIElement {
        get {
            return app.buttons["Submit"]
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
    
    func typeTextIntoCvc(_ text: String) {
        cvcField.tap()
        cvcField.typeText(text)
    }
    
    func submit() {
        submitButton.tap()
    }
}

