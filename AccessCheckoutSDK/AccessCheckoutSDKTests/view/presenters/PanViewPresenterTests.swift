@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanViewPresenterTests: XCTestCase {
    private let panValidator = mockPanValidator()
    private let panValidationFlow = mockPanValidationFlow()

    override func setUp() {
        panValidationFlow.getStubbingProxy().validate(pan: any()).thenDoNothing()
        panValidationFlow.getStubbingProxy().notifyMerchantIfNotAlreadyNotified().thenDoNothing()
        panValidator.getStubbingProxy().canValidate(any()).thenReturn(true)
    }

    func testOnEditingValidatesPan() {
        let pan = "123"
        let presenter = PanViewPresenter(panValidationFlow, panValidator)

        presenter.onEditing(text: pan)

        verify(panValidationFlow).validate(pan: pan)
    }

    func testOnEditEndNotifiesMerchantOfValidationStateIfNotAlreadyNotified() {
        let pan = "123"
        let presenter = PanViewPresenter(panValidationFlow, panValidator)

        presenter.onEditEnd(text: pan)

        verify(panValidationFlow).notifyMerchantIfNotAlreadyNotified()
    }

    func testCanChangeTextChecksIfTheTextCanBeEnteredAndDoesNotTriggerValidationFlow() {
        let text = "123"
        let presenter = PanViewPresenter(panValidationFlow, panValidator)

        _ = presenter.canChangeText(with: text)

        verify(panValidator).canValidate(text)
        verifyNoMoreInteractions(panValidationFlow)
    }

    func testCanChangeTextWithEmptyText() {
        let presenter = PanViewPresenter(panValidationFlow, panValidator)

        let result = presenter.canChangeText(with: "")

        XCTAssertTrue(result)
    }

    private static func mockPanValidationFlow() -> MockPanValidationFlow {
        let validationStateHandler = CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate())
        let cvvValidationFlow = MockCvvValidationFlow(CvvValidator(), validationStateHandler)
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        let panValidator = PanValidator(configurationProvider)

        return MockPanValidationFlow(panValidator, validationStateHandler, cvvValidationFlow)
    }

    static func mockPanValidator() -> MockPanValidator {
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        let panValidator = MockPanValidator(configurationProvider)

        return panValidator
    }
}
