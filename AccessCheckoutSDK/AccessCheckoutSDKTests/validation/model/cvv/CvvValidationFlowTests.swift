@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CvvValidationFlowTests: XCTestCase {
    private let cvvValidationStateHandler = MockCvvValidationStateHandler()
    private let cvvValidationRule = ValidationRule(matcher: nil, validLengths: [])

    private let cardBrand = CardBrandModel(
        name: "",
        images: [],
        panValidationRule: ValidationRule(matcher: "", validLengths: []),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [])
    )

    override func setUp() {
        cvvValidationStateHandler.getStubbingProxy().handleCvvValidation(isValid: any()).thenDoNothing()
        cvvValidationStateHandler.getStubbingProxy().notifyMerchantOfCvvValidationState().thenDoNothing()
    }

    func testValidateValidatesCvvWithStoredValidationRuleAndCallsValidationStateHandlerWithResult() {
        let expectedResult = false
        let cvvValidator = createMockCvvValidator(thatReturns: expectedResult)
        let cvvValidationFlow = CvvValidationFlow(cvvValidator: cvvValidator,
                                                  cvvValidationStateHandler: cvvValidationStateHandler,
                                                  validationRule: cvvValidationRule)

        cvvValidationFlow.validate(cvv: "123")

        verify(cvvValidator).validate(cvv: "123", validationRule: cvvValidationRule)
        verify(cvvValidationStateHandler).handleCvvValidation(isValid: expectedResult)
    }

    func testValidateStoresCvv() {
        let cvvValidationFlow = CvvValidationFlow(CvvValidator(), cvvValidationStateHandler)

        cvvValidationFlow.validate(cvv: "123")

        XCTAssertEqual(cvvValidationFlow.cvv, "123")
    }

    func testValidateUsesDefaultValidationRuleByDefault() {
        let cvvValidator = createMockCvvValidator(thatReturns: true)
        let cvvValidationFlow = CvvValidationFlow(cvvValidator, cvvValidationStateHandler)

        cvvValidationFlow.validate(cvv: "123")

        verify(cvvValidator).validate(cvv: "123", validationRule: ValidationRulesDefaults.instance().cvv)
    }

    func testUpdateValidationRuleStoresValidationRule() {
        let cvvValidationFlow = CvvValidationFlow(CvvValidator(), cvvValidationStateHandler)
        let expectedRule = cardBrand.cvvValidationRule

        cvvValidationFlow.updateValidationRule(with: expectedRule)

        XCTAssertEqual(cvvValidationFlow.validationRule, expectedRule)
    }

    func testResetValidationRuleSetsValidationRuleToDefault() {
        let cvvValidationFlow = CvvValidationFlow(
            cvvValidator: CvvValidator(),
            cvvValidationStateHandler: cvvValidationStateHandler,
            validationRule: cvvValidationRule
        )
        let expectedRule = ValidationRulesDefaults.instance().cvv

        cvvValidationFlow.resetValidationRule()

        XCTAssertEqual(expectedRule, cvvValidationFlow.validationRule)
    }

    func testRevalidateValidatesUsingStoredCvvAndValidationRuleAndThenCallStateHandlerWithResult() {
        let expectedResult = false
        let expectedCvv = "123"
        let expectedRule = cardBrand.cvvValidationRule
        let cvvValidator = createMockCvvValidator(thatReturns: expectedResult)
        let cvvValidationFlow = CvvValidationFlow(
            cvvValidator: cvvValidator,
            cvvValidationStateHandler: cvvValidationStateHandler,
            cvv: expectedCvv,
            validationRule: expectedRule
        )

        cvvValidationFlow.revalidate()

        verify(cvvValidator).validate(cvv: expectedCvv, validationRule: expectedRule)
        verify(cvvValidationStateHandler).handleCvvValidation(isValid: expectedResult)
    }

    func testCanNotifyMerchantIfNotAlreadyNotified() {
        let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantDelegate.getStubbingProxy().cvvValidChanged(isValid: any()).thenDoNothing()
        let cvvValidationStateHandler = CardValidationStateHandler(merchantDelegate)
        let cvvValidationFlow = CvvValidationFlow(CvvValidator(), cvvValidationStateHandler)

        cvvValidationFlow.notifyMerchantIfNotAlreadyNotified()

        verify(merchantDelegate).cvvValidChanged(isValid: false)
    }

    func testCannotNotifyMerchantIfAlreadyNotified() {
        let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantDelegate.getStubbingProxy().cvvValidChanged(isValid: any()).thenDoNothing()
        let cvvValidationStateHandler = CardValidationStateHandler(merchantDelegate)
        let cvvValidationFlow = CvvValidationFlow(CvvValidator(), cvvValidationStateHandler)

        cvvValidationStateHandler.handleCvvValidation(isValid: true)
        verify(merchantDelegate).cvvValidChanged(isValid: true)
        clearInvocations(merchantDelegate)

        cvvValidationFlow.notifyMerchantIfNotAlreadyNotified()

        verify(merchantDelegate, never()).expiryDateValidChanged(isValid: any())
    }

    private func createMockCvvValidator(thatReturns result: Bool) -> MockCvvValidator {
        let mock = MockCvvValidator()

        mock.getStubbingProxy().validate(cvv: any(), validationRule: any()).thenReturn(result)

        return mock
    }
}
