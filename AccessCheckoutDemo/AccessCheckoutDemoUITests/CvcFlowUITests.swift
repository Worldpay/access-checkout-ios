import XCTest

class CvcFlowUITests: XCTestCase {
    var view: CvcFlowViewPageObject?

    override func setUp() {
        continueAfterFailure = false

        let app = AppLauncher.launch()

        view = NavigationViewPageObject(app).navigateToCvcFlow()
    }

    func testCvcField_exists() {
        XCTAssertTrue(view!.cvcField.exists)
    }

    func testSubmitButton_exists() {
        XCTAssertTrue(view!.submitButton.exists)
    }

    func testCvcIsValidLabel_exists() {
        XCTAssertTrue(view!.cvcIsValidLabel.exists)
    }
}
