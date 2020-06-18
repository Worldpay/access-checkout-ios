@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CvcViewPresenterTests: XCTestCase {
    func testOnEditingValidatesCvc() {
        let cvc = "123"
        let cvcValidator = CvcValidator()
        let validationFlow: MockCvcValidationFlow = MockCvcValidationFlow(cvcValidator,
                                                                          CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate()))
        validationFlow.getStubbingProxy().validate(cvc: any()).thenDoNothing()
        let presenter = CvcViewPresenter(validationFlow, cvcValidator)

        presenter.onEditing(text: cvc)

        verify(validationFlow).validate(cvc: "123")
    }

    func testOnEditEndNotifiesMerchantOfValidationStateIfNotAlreadyNotified() {
        let cvc = "12"
        let cvcValidator = CvcValidator()
        let validationFlow: MockCvcValidationFlow = MockCvcValidationFlow(cvcValidator,
                                                                          CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate()))
        validationFlow.getStubbingProxy().notifyMerchantIfNotAlreadyNotified().thenDoNothing()
        let presenter = CvcViewPresenter(validationFlow, cvcValidator)

        presenter.onEditEnd(text: cvc)

        verify(validationFlow).notifyMerchantIfNotAlreadyNotified()
    }

    func testCanChangeTextChecksIfTheTextCanBeEnteredUsingTheCurrentCvcValidationRuleAndDoesNotTriggerValidationFlow() {
        let text = "123"
        let cvcValidator = MockCvcValidator()
        let expectedValidationRule = ValidationRule(matcher: "something", validLengths: [1, 2])
        let validationFlow = MockCvcValidationFlow(cvcValidator,
                                                   CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate()))
        validationFlow.getStubbingProxy().validate(cvc: any()).thenDoNothing()
        validationFlow.getStubbingProxy().validationRule.get.thenReturn(expectedValidationRule)
        cvcValidator.getStubbingProxy().canValidate(any(), using: any()).thenReturn(true)
        let presenter = CvcViewPresenter(validationFlow, cvcValidator)

        _ = presenter.canChangeText(with: text)

        verify(cvcValidator).canValidate(text, using: expectedValidationRule)
        verify(validationFlow, never()).validate(cvc: any())
        verify(validationFlow, never()).revalidate()
    }

    func testCanChangeTextWithEmptyText() {
        let cvcValidator = MockCvcValidator()
        let validationFlow: MockCvcValidationFlow = MockCvcValidationFlow(cvcValidator,
                                                                          CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate()))
        validationFlow.getStubbingProxy().validate(cvc: any()).thenDoNothing()
        cvcValidator.getStubbingProxy().canValidate(any(), using: any()).thenReturn(true)
        let presenter = CvcViewPresenter(validationFlow, cvcValidator)

        let result = presenter.canChangeText(with: "")

        XCTAssertTrue(result)
    }
}
