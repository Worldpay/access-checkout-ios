@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanViewPresenterTests: XCTestCase {
    func testOnEditingValidatesPan() {
        let pan = "123"
        let panValidator = mockPanValidator()
        let panValidationFlow = mockPanValidationFlow()
        panValidationFlow.getStubbingProxy().validate(pan: any()).thenDoNothing()
        let presenter = PanViewPresenter(panValidationFlow, panValidator)

        presenter.onEditing(text: pan)

        verify(panValidationFlow).validate(pan: pan)
    }

    func testOnEditEndValidatesPan() {
        let pan = "123"
        let panValidator = mockPanValidator()
        let panValidationFlow = mockPanValidationFlow()
        panValidationFlow.getStubbingProxy().validate(pan: any()).thenDoNothing()
        let presenter = PanViewPresenter(panValidationFlow, panValidator)

        presenter.onEditEnd(text: pan)

        verify(panValidationFlow).validate(pan: pan)
    }

    func testCanChangeValidatesPartialPanAndDoesNotTriggerValidationFlow() {
        let pan = "123"
        let panValidator = mockPanValidator()
        panValidator.getStubbingProxy().canValidate(pan: any()).thenReturn(true)
        let panValidationFlow = mockPanValidationFlow()
        let presenter = PanViewPresenter(panValidationFlow, panValidator)

        _ = presenter.canChangeText(with: pan)

        verify(panValidator).canValidate(pan: pan)
        verifyNoMoreInteractions(panValidationFlow)
    }
    
    func testCanChangeWithEmptyText() {
        let panValidator = mockPanValidator()
        let panValidationFlow = mockPanValidationFlow()
        let presenter = PanViewPresenter(panValidationFlow, panValidator)

        let result = presenter.canChangeText(with: "")

        XCTAssertTrue(result)
    }

    private func mockPanValidationFlow() -> MockPanValidationFlow {
        let validationStateHandler = CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate())
        let cvvValidationFlow = MockCvvValidationFlow(CvvValidator(), validationStateHandler)
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        let panValidator = PanValidator(configurationProvider)

        return MockPanValidationFlow(panValidator, validationStateHandler, cvvValidationFlow)
    }

    func mockPanValidator() -> MockPanValidator {
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        let panValidator = MockPanValidator(configurationProvider)

        return panValidator
    }
}
