import XCTest

class SwitchViewPageObject {
    private let element:XCUIElement
    
    var isOn:Bool {
        get {
            return (element.value as? String) == "1"
        }
    }
    
    var isOff:Bool {
        get {
            return (element.value as? String) == "0"
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
}
