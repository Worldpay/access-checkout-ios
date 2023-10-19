
import XCTest

class PanWithoutSpacingPageObject: PanBasePageObject {
    init(_ app: XCUIApplication) {
        super.init(
            app: app,
            panFieldIdentifier: "panWithoutSpacing",
            panCaretPositionTextFieldIdentifier: "panWithoutSpacingCaretPositionTextField",
            setPanCaretPositionTextFieldIdentifier: "setPanWithoutSpacingCaretPositionTextField",
            setPanCaretPositionButtonIdentifier: "setPanWithoutSpacingCaretPositionButton"
        )
    }
}
