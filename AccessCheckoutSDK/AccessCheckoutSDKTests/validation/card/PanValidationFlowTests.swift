import XCTest
@testable import AccessCheckoutSDK

class PanValidationFlowTests : XCTestCase {
    let visaBrand = AccessCardConfiguration.CardBrand(
            name: "visa",
            images: nil,
            matcher: "^(?!^493698\\d*$)4\\d*$",
            cvv: 3,
            pans: [16,18,19]
        )
    
    func testShouldCallPanValidatorAndCallHandlerWithResult() {
        let panValidator = mockValidator(isValid: true, brand: nil)
        let panValidationStateHandler = AccessValidationStateHandlerMock()
        let cvvFlow = CvvWithPanValidationFlowMock()

        let panValidationFlow = PanValidationFlow(panValidator: panValidator, panValidationStateHandler: panValidationStateHandler, cvvFlow: cvvFlow)

        panValidationFlow.checkValidationState(forPan: "1234")
        
        XCTAssertTrue(panValidator.validationCalled)
        XCTAssertTrue(panValidationStateHandler.handleCalled)
        
        XCTAssertEqual(panValidator.validationResult?.isValid, panValidationStateHandler.result?.isValid)
        XCTAssertEqual(panValidator.validationResult?.cardBrand, panValidationStateHandler.result?.cardBrand)
    }
    
    func testShouldTriggerCvvValidationIfCardBrandHasChanged() {
        let panValidator = mockValidator(isValid: true, brand: visaBrand)
        let panValidationStateHandler = AccessValidationStateHandlerMock()
        let cvvFlow = CvvWithPanValidationFlowMock()
        panValidationStateHandler.cardBrandChanged = true
        
        let panValidationFlow = PanValidationFlow(panValidator: panValidator, panValidationStateHandler: panValidationStateHandler, cvvFlow: cvvFlow)

        XCTAssertFalse(cvvFlow.validationRetriggered)
        
        panValidationFlow.checkValidationState(forPan: "1234")
        XCTAssertTrue(cvvFlow.validationRetriggered)
        XCTAssertEqual(visaBrand, cvvFlow.newCardBrand)

    }
    
    func testShouldNotTriggerCvvValidationIfCardBrandHasNotChanged() {
        let panValidator = mockValidator(isValid: true, brand: nil)
        let panValidationStateHandler = AccessValidationStateHandlerMock()
        let cvvFlow = CvvWithPanValidationFlowMock()
        panValidationStateHandler.cardBrandChanged = false
        
        let panValidationFlow = PanValidationFlow(panValidator: panValidator, panValidationStateHandler: panValidationStateHandler, cvvFlow: cvvFlow)

        XCTAssertFalse(cvvFlow.validationRetriggered)
        
        panValidationFlow.checkValidationState(forPan: "1234")
        XCTAssertFalse(cvvFlow.validationRetriggered)

    }
    
    private func mockValidator(isValid: Bool, brand: AccessCardConfiguration.CardBrand?) -> PanValidatorMock {
        return PanValidatorMock(
            cardConfiguration: AccessCardConfiguration(
                defaults: AccessCardConfiguration.CardDefaults.baseDefaults(),
                brands: []
            ),
            isValid: isValid,
            cardBrand: brand
        )
    }
}
