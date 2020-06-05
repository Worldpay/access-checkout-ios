@testable import AccessCheckoutSDK
import XCTest

class ExpiryDateViewPresenterTests: XCTestCase {
    func testOnEditingValidatesExpiryDate() {
        let expiryMonth = "11"
        let expiryYear = "22"
        let validationFlow = ExpiryDateValidationFlowMock()
        let presenter = ExpiryDateViewPresenter(validationFlow)

        presenter.onEditing(monthText: expiryMonth, yearText: expiryYear)

        XCTAssertTrue(validationFlow.validateCalled)
        XCTAssertEqual(expiryMonth, validationFlow.expiryMonthPassed)
        XCTAssertEqual(expiryYear, validationFlow.expiryYearPassed)
    }
}
