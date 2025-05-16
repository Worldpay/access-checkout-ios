import XCTest

class AlertViewPageObject {
    private let element: XCUIElement

    var title: String {
        return element.label
    }

    var message: String {
        return element.staticTexts.element(boundBy: 1).label
    }

    var exists: Bool {
        return element.exists
    }

    init(element: XCUIElement) {
        self.element = element
    }

    func close() {
        element.buttons["OK"].tap()
    }
}
