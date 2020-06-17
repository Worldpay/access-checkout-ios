@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class ExpiryDateViewPresenterTests: XCTestCase {
    private let expiryDateValidator = MockExpiryDateValidator()
    private let expiryDateValidationFlow = mockExpiryDateValidationFlow()

    override func setUp() {
        expiryDateValidationFlow.getStubbingProxy().validate(expiryDate: any()).thenDoNothing()
        expiryDateValidationFlow.getStubbingProxy().notifyMerchantIfNotAlreadyNotified().thenDoNothing()
        expiryDateValidator.getStubbingProxy().canValidate(any()).thenReturn(true)
    }

    func testOnEditingValidatesExpiryDate() {
        let expiryDate = "11/22"
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidator)

        presenter.onEditing(text: expiryDate)

        verify(expiryDateValidationFlow).validate(expiryDate: expiryDate)
    }

    func testOnEditEndNotifiesMerchantOfValidationStateIfNotAlreadyNotified() {
        let expiryDate = "11/2"
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidator)

        presenter.onEditEnd(text: expiryDate)

        verify(expiryDateValidationFlow).notifyMerchantIfNotAlreadyNotified()
    }

    func testCanChangeTextWithEmptyText() {
        let text = ""
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidator)

        let result = presenter.canChangeText(with: text)

        XCTAssertTrue(result)
    }

    func testCanChangeTextChecksIfTextCanBeEnteredAndDoesNotTriggerValidationFlow() {
        let text = "12"
        let presenter = ExpiryDateViewPresenter(expiryDateValidationFlow, expiryDateValidator)

        _ = presenter.canChangeText(with: text)

        verify(expiryDateValidator).canValidate(text)
        verifyNoMoreInteractions(expiryDateValidationFlow)
    }

    private static func mockExpiryDateValidationFlow() -> MockExpiryDateValidationFlow {
        let validator = ExpiryDateValidator()
        let validationStateHandler = CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate())

        return MockExpiryDateValidationFlow(validator, validationStateHandler)
    }
}
