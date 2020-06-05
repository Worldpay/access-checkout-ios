@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CvvValidationFlowTests: XCTestCase {
    private let cvvValidationStateHandler = MockCvvValidationStateHandler()

    let cardBrand = CardBrandModel(
        name: "",
        images: [],
        panValidationRule: ValidationRule(matcher: "", validLengths: []),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [])
    )

    override func setUp() {
        cvvValidationStateHandler.getStubbingProxy().handleCvvValidation(isValid: any()).thenDoNothing()
    }

    func testShouldCallCvvValidatorThenCallStateHandlerWithResult() {
        let expectedResult = false
        let cvvValidator = createMockCvvValidator(thatReturns: expectedResult)
        let cvvValidationFlow = CvvValidationFlow(
            cvvValidator,
            cvvValidationStateHandler
        )

        cvvValidationFlow.validate(cvv: "123", cvvRule: ValidationRule(matcher: nil, validLengths: []))
        verify(cvvValidator).validate(cvv: "123", cvvRule: any())
        verify(cvvValidationStateHandler).handleCvvValidation(isValid: expectedResult)
    }

    func testUpdateCvvValueWhenValidateIsCalled() {
        let cvvValidationFlow = CvvValidationFlow(
            cvvValidator: CvvValidator(),
            cvvValidationStateHandler: cvvValidationStateHandler,
            cvv: ""
        )

        cvvValidationFlow.validate(cvv: "123", cvvRule: ValidationRule(matcher: nil, validLengths: []))
        XCTAssertEqual(cvvValidationFlow.cvv, "123")
    }

    func testShouldCallCvvValidatorThenCallStateHandlerWithResultAfterReValidateCalled() {
        let expectedResult = false
        let cvvValidator = createMockCvvValidator(thatReturns: expectedResult)
        let cvvValidationFlow = CvvValidationFlow(
            cvvValidator: cvvValidator,
            cvvValidationStateHandler: cvvValidationStateHandler,
            cvv: "123"
        )

        cvvValidationFlow.reValidate(cvvRule: cardBrand.cvvValidationRule)
        verify(cvvValidator).validate(cvv: "123", cvvRule: any())
        verify(cvvValidationStateHandler).handleCvvValidation(isValid: expectedResult)
    }

    func testShouldUpdateCvvRuleToNewRuleWhenRevalidateIsCalled() {
        let cvvValidationFlow = CvvValidationFlow(
            CvvValidator(),
            cvvValidationStateHandler
        )

        cvvValidationFlow.reValidate(cvvRule: cardBrand.cvvValidationRule)
        XCTAssertEqual(cvvValidationFlow.cvvRule, cardBrand.cvvValidationRule)
    }

    func testShouldSetCvvRuleToDefaultIfNoNewRulePassedWhenRevalidateIsCalled() {
        let cvvValidationFlow = CvvValidationFlow(
            cvvValidator: CvvValidator(),
            cvvValidationStateHandler: cvvValidationStateHandler,
            cvvRule: cardBrand.cvvValidationRule
        )

        cvvValidationFlow.reValidate(cvvRule: nil)

        // ToDo - why do we have this test? Do we need to store that rule?
        XCTAssertEqual(cvvValidationFlow.cvvRule, ValidationRulesDefaults.instance().cvv)
    }

    private func createMockCvvValidator(thatReturns result: Bool) -> MockCvvValidator {
        let mock = MockCvvValidator()

        mock.getStubbingProxy().validate(cvv: any(), cvvRule: any()).thenReturn(result)

        return mock
    }
}
