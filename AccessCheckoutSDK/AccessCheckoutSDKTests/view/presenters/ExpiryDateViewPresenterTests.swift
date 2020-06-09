@testable import AccessCheckoutSDK
import XCTest
import Cuckoo

class ExpiryDateViewPresenterTests: XCTestCase {
    func testOnEditingValidatesExpiryDate() {
        let expiryMonth = "11"
        let expiryYear = "22"
        let validationFlow = mockExpiryDateValidationFlow()
        validationFlow.getStubbingProxy().validate(expiryMonth: any(), expiryYear: any()).thenDoNothing()
        let presenter = ExpiryDateViewPresenter(validationFlow)

        presenter.onEditing(monthText: expiryMonth, yearText: expiryYear)

        verify(validationFlow).validate(expiryMonth: expiryMonth, expiryYear: expiryYear)
    }
    
    func testOnEditEndValidatesExpiryDate() {
        let expiryMonth = "11"
        let expiryYear = "22"
        let validationFlow = mockExpiryDateValidationFlow()
        validationFlow.getStubbingProxy().validate(expiryMonth: any(), expiryYear: any()).thenDoNothing()
        let presenter = ExpiryDateViewPresenter(validationFlow)

        presenter.onEditEnd(monthText: expiryMonth, yearText: expiryYear)

       verify(validationFlow).validate(expiryMonth: expiryMonth, expiryYear: expiryYear)
    }
    
    private func mockExpiryDateValidationFlow() -> MockExpiryDateValidationFlow {
        let validator = ExpiryDateValidator()
        let validationStateHandler = CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate())
        
        return MockExpiryDateValidationFlow(validator, validationStateHandler)
    }
}
