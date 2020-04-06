import XCTest

class AlertViewPageObject {
    private let element:XCUIElement
    
    var title:String {
        get {
            return element.label
        }
    }
    
    var message:String {
        get {
            return element.staticTexts.element(boundBy:1).label
        }
    }
    
    var exists:Bool {
        get {
            return element.exists
        }
    }
    
    init(element:XCUIElement) {
        self.element = element
    }
    
    func close() {
        element.buttons["OK"].tap()
    }
}
