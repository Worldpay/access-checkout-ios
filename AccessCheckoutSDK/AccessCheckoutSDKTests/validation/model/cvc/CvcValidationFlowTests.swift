@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CvcValidationFlowTests: XCTestCase {
    private let cvcValidationStateHandler = MockCvcValidationStateHandler()
    private let cvcValidationRule = ValidationRule(matcher: nil, validLengths: [])

    private let cardBrand = CardBrandModel(
        name: "",
        images: [],
        panValidationRule: ValidationRule(matcher: "", validLengths: []),
        cvcValidationRule: ValidationRule(matcher: nil, validLengths: [])
    )

    override func setUp() {
        cvcValidationStateHandler.getStubbingProxy().handleCvcValidation(isValid: any()).thenDoNothing()
        cvcValidationStateHandler.getStubbingProxy().notifyMerchantOfCvcValidationState().thenDoNothing()
    }

    func testValidateValidatesCvcWithStoredValidationRuleAndCallsValidationStateHandlerWithResult() {
        let expectedResult = false
        let cvcValidator = createMockCvcValidator(thatReturns: expectedResult)
        let cvcValidationFlow = CvcValidationFlow(cvcValidator: cvcValidator,
                                                  cvcValidationStateHandler: cvcValidationStateHandler,
                                                  validationRule: cvcValidationRule)

        cvcValidationFlow.validate(cvc: "123")

        verify(cvcValidator).validate(cvc: "123", validationRule: cvcValidationRule)
        verify(cvcValidationStateHandler).handleCvcValidation(isValid: expectedResult)
    }

    func testValidateStoresCvc() {
        let cvcValidationFlow = CvcValidationFlow(CvcValidator(), cvcValidationStateHandler)

        cvcValidationFlow.validate(cvc: "123")

        XCTAssertEqual(cvcValidationFlow.cvc, "123")
    }

    func testValidateUsesDefaultValidationRuleByDefault() {
        let cvcValidator = createMockCvcValidator(thatReturns: true)
        let cvcValidationFlow = CvcValidationFlow(cvcValidator, cvcValidationStateHandler)

        cvcValidationFlow.validate(cvc: "123")

        verify(cvcValidator).validate(cvc: "123", validationRule: ValidationRulesDefaults.instance().cvc)
    }

    func testUpdateValidationRuleStoresValidationRule() {
        let cvcValidationFlow = CvcValidationFlow(CvcValidator(), cvcValidationStateHandler)
        let expectedRule = cardBrand.cvcValidationRule

        cvcValidationFlow.updateValidationRule(with: expectedRule)

        XCTAssertEqual(cvcValidationFlow.validationRule, expectedRule)
    }

    func testResetValidationRuleSetsValidationRuleToDefault() {
        let cvcValidationFlow = CvcValidationFlow(
            cvcValidator: CvcValidator(),
            cvcValidationStateHandler: cvcValidationStateHandler,
            validationRule: cvcValidationRule
        )
        let expectedRule = ValidationRulesDefaults.instance().cvc

        cvcValidationFlow.resetValidationRule()

        XCTAssertEqual(expectedRule, cvcValidationFlow.validationRule)
    }

    func testRevalidateValidatesUsingStoredCvcAndValidationRuleAndThenCallStateHandlerWithResult() {
        let expectedResult = false
        let expectedCvc = "123"
        let expectedRule = cardBrand.cvcValidationRule
        let cvcValidator = createMockCvcValidator(thatReturns: expectedResult)
        let cvcValidationFlow = CvcValidationFlow(
            cvcValidator: cvcValidator,
            cvcValidationStateHandler: cvcValidationStateHandler,
            cvc: expectedCvc,
            validationRule: expectedRule
        )

        cvcValidationFlow.revalidate()

        verify(cvcValidator).validate(cvc: expectedCvc, validationRule: expectedRule)
        verify(cvcValidationStateHandler).handleCvcValidation(isValid: expectedResult)
    }

    func testCanNotifyMerchantIfNotAlreadyNotified() {
        let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        let cvcValidationStateHandler = CardValidationStateHandler(merchantDelegate)
        let cvcValidationFlow = CvcValidationFlow(CvcValidator(), cvcValidationStateHandler)

        cvcValidationFlow.notifyMerchantIfNotAlreadyNotified()

        verify(merchantDelegate).cvcValidChanged(isValid: false)
    }

    func testCannotNotifyMerchantIfAlreadyNotified() {
        let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        let cvcValidationStateHandler = CardValidationStateHandler(merchantDelegate)
        let cvcValidationFlow = CvcValidationFlow(CvcValidator(), cvcValidationStateHandler)

        cvcValidationStateHandler.handleCvcValidation(isValid: true)
        verify(merchantDelegate).cvcValidChanged(isValid: true)
        clearInvocations(merchantDelegate)

        cvcValidationFlow.notifyMerchantIfNotAlreadyNotified()

        verify(merchantDelegate, never()).expiryDateValidChanged(isValid: any())
    }

    private func createMockCvcValidator(thatReturns result: Bool) -> MockCvcValidator {
        let mock = MockCvcValidator()

        mock.getStubbingProxy().validate(cvc: any(), validationRule: any()).thenReturn(result)

        return mock
    }
}
