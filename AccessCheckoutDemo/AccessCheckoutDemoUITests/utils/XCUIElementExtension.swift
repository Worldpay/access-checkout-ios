import XCTest

extension XCUIElement {
    var isFocused: Bool {
        let isFocused = (self.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
        return isFocused
    }
}
