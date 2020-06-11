@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class ExpiryDateViewPresenterTests: XCTestCase {
    private let expiryDateValidator = MockExpiryDateValidator()
    private let expiryDateValidationFlow = mockExpiryDateValidationFlow()

    override func setUp() {
        expiryDateValidationFlow.getStubbingProxy().validate(expiryMonth: any(), expiryYear: any()).thenDoNothing()
        expiryDateValidator.getStubbingProxy().canValidateMonth(any()).thenReturn(true)
        expiryDateValidator.getStubbingProxy().canValidateYear(any()).thenReturn(true)
    }

    func testOnEditingValidatesExpiryDate() {
        let expiryMonth = "11"
        let expiryYear = "22"
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidator)

        presenter.onEditing(monthText: expiryMonth, yearText: expiryYear)

        verify(expiryDateValidationFlow).validate(expiryMonth: expiryMonth, expiryYear: expiryYear)
    }

    func testOnEditEndValidatesExpiryDate() {
        let expiryMonth = "11"
        let expiryYear = "22"
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidator)

        presenter.onEditEnd(monthText: expiryMonth, yearText: expiryYear)

        verify(expiryDateValidationFlow).validate(expiryMonth: expiryMonth, expiryYear: expiryYear)
    }

    func testCanChangeMonthTextWithEmptyText() {
        let text = ""
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidator)

        let result = presenter.canChangeMonthText(with: text)

        XCTAssertTrue(result)
    }

    func testCanChangeMonthTextChecksIfTheTextCanBeEnteredAndDoesNotTriggerValidationFlow() {
        let text = "12"
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidator)

        _ = presenter.canChangeMonthText(with: text)

        verify(expiryDateValidator).canValidateMonth(text)
        verifyNoMoreInteractions(expiryDateValidationFlow)
    }

    func testCanChangeYearTextWithEmptyText() {
        let text = ""
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidator)

        let result = presenter.canChangeYearText(with: text)

        XCTAssertTrue(result)
    }

    func testCanChangeYearTextChecksIfTheTextCanBeEnteredAndDoesNotTriggerValidationFlow() {
        let text = "35"
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidator)

        _ = presenter.canChangeYearText(with: text)

        verify(expiryDateValidator).canValidateYear(text)
        verifyNoMoreInteractions(expiryDateValidationFlow)
    }

    private static func mockExpiryDateValidationFlow() -> MockExpiryDateValidationFlow {
        let validator = ExpiryDateValidator()
        let validationStateHandler = CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate())

        return MockExpiryDateValidationFlow(validator, validationStateHandler)
    }
}
