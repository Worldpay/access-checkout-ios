@testable import AccessCheckoutSDK
import XCTest

class CVVViewForCardPaymentFlowPresenterTests: XCTestCase {
    func testOnEditingValidatesCvvUsingPanRule() {
        let cvv = "123"
        let validationFlow = CvvValidationFlowMock()
        let expectedValidationRule = ValidationRulesDefaults.instance().cvv
        let presenter = CVVViewForCardPaymentFlowPresenter(validationFlow)

        presenter.onEditing(text: cvv)

        XCTAssertTrue(validationFlow.validateCalled)
        XCTAssertEqual(cvv, validationFlow.cvvPassed)
        // TODO: We should not have to care about that, it should be internal to the CvvValidationFlow
        XCTAssertEqual(expectedValidationRule, validationFlow.cvvRulePassed)
    }
}
