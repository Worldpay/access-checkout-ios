@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CVVViewPresenterTests: XCTestCase {
    func testOnEditingValidatesCvv() {
        let cvv = "123"
        let cvvValidator = CvvValidator()
        let validationFlow: MockCvvValidationFlow = MockCvvValidationFlow(cvvValidator,
                                                                          CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate()))
        validationFlow.getStubbingProxy().validate(cvv: any()).thenDoNothing()
        let presenter = CVVViewPresenter(validationFlow, cvvValidator)

        presenter.onEditing(text: cvv)

        verify(validationFlow).validate(cvv: "123")
    }

    func testOnEditingEndValidatesCvv() {
        let cvv = "123"
        let cvvValidator = CvvValidator()
        let validationFlow: MockCvvValidationFlow = MockCvvValidationFlow(cvvValidator,
                                                                          CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate()))
        validationFlow.getStubbingProxy().validate(cvv: any()).thenDoNothing()
        let presenter = CVVViewPresenter(validationFlow, cvvValidator)

        presenter.onEditEnd(text: cvv)

        verify(validationFlow).validate(cvv: "123")
    }

    func testCanChangeTextChecksIfTheTextCanBeEnteredUsingTheCurrentCvvValidationRuleAndDoesNotTriggerValidationFlow() {
        let text = "123"
        let cvvValidator = MockCvvValidator()
        let expectedValidationRule = ValidationRule(matcher: "something", validLengths: [1, 2])
        let validationFlow = MockCvvValidationFlow(cvvValidator,
                                                   CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate()))
        validationFlow.getStubbingProxy().validate(cvv: any()).thenDoNothing()
        validationFlow.getStubbingProxy().validationRule.get.thenReturn(expectedValidationRule)
        cvvValidator.getStubbingProxy().canValidate(any(), using: any()).thenReturn(true)
        let presenter = CVVViewPresenter(validationFlow, cvvValidator)

        _ = presenter.canChangeText(with: text)

        verify(cvvValidator).canValidate(text, using: expectedValidationRule)
        verify(validationFlow, never()).validate(cvv: any())
        verify(validationFlow, never()).revalidate()
    }

    func testCanChangeTextWithEmptyText() {
        let cvvValidator = MockCvvValidator()
        let validationFlow: MockCvvValidationFlow = MockCvvValidationFlow(cvvValidator,
                                                                          CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate()))
        validationFlow.getStubbingProxy().validate(cvv: any()).thenDoNothing()
        cvvValidator.getStubbingProxy().canValidate(any(), using: any()).thenReturn(true)
        let presenter = CVVViewPresenter(validationFlow, cvvValidator)

        let result = presenter.canChangeText(with: "")

        XCTAssertTrue(result)
    }
}
