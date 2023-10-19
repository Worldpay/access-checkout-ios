
import XCTest

class PanWithSpacingPageObject: PanBasePageObject {
    init(_ app: XCUIApplication) {
        super.init(
            app: app,
            panFieldIdentifier: "panWithSpacing",
            panCaretPositionTextFieldIdentifier: "panWithSpacingCaretPositionTextField",
            setPanCaretPositionTextFieldIdentifier: "setPanWithSpacingCaretPositionTextField",
            setPanCaretPositionButtonIdentifier: "setPanWithSpacingCaretPositionButton"
        )
    }
}
