@testable import AccessCheckoutSDK
import XCTest

class PanViewPresenterTests: XCTestCase {
    func testOnEditingValidatesPan() {
        let pan = "123"
        let panValidationFlow = PanValidationFlowMock()
        let presenter = PanViewPresenter(panValidationFlow)

        presenter.onEditing(text: pan)

        XCTAssertTrue(panValidationFlow.validateCalled)
        XCTAssertEqual(pan, panValidationFlow.panPassed)
    }
}
