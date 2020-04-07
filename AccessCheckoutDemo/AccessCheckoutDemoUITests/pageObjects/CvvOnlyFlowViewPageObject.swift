import XCTest

class CvvOnlyFlowViewPageObject {
    private let app:XCUIApplication

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
    
    func typeTextIntoCvv(_ text: String) {
        cvvField.tap()
        cvvField.typeText(text)
    }
    
    func submit() {
        submitButton.tap()
    }
}

