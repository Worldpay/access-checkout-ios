import XCTest

class CvcFlowUITests: BaseUITest {
    var view: CvcFlowViewPageObject?

    override func setUp() {
        super.setUp()
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
