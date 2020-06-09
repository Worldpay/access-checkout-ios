@testable import AccessCheckoutSDK
import XCTest
import Cuckoo

class CVVViewPresenterTests: XCTestCase {
    func testOnEditingValidatesCvv() {
        let cvv = "123"
        let validationFlow:MockCvvValidationFlow = MockCvvValidationFlow(CvvValidator(),
                                                   CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate()))
        validationFlow.getStubbingProxy().validate(cvv: any()).thenDoNothing()
        let presenter = CVVViewPresenter(validationFlow)

        presenter.onEditing(text: cvv)

        verify(validationFlow).validate(cvv: "123")
    }
    
    func testOnEditingEndValidatesCvv() {
        let cvv = "123"
        let validationFlow:MockCvvValidationFlow = MockCvvValidationFlow(CvvValidator(),
                                                   CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate()))
        validationFlow.getStubbingProxy().validate(cvv: any()).thenDoNothing()
        let presenter = CVVViewPresenter(validationFlow)

        presenter.onEditEnd(text: cvv)

        verify(validationFlow).validate(cvv: "123")
    }
}
