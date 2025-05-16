import XCTest

class SwitchViewPageObject {
    private let element: XCUIElement

    var isOn: Bool {
        return (element.value as? String) == "1"
    }

    var isOff: Bool {
        return (element.value as? String) == "0"
    }

    var exists: Bool {
        return element.exists
    }

    init(element: XCUIElement) {
        self.element = element
    }

    func toggleOn() {
        if isOn {
            return
        } else {
            element.tap()
        }

        if !isOn {
            XCTAssertTrue(
                isOn,
                "Intention is to toggle on a switch but tapping it has not toggled it on. Please check your code"
            )
        }
    }
}
