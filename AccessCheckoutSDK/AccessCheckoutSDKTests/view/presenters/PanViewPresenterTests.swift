@testable import AccessCheckoutSDK
import XCTest
import Cuckoo

class PanViewPresenterTests: XCTestCase {
    func testOnEditingValidatesPan() {
        let pan = "123"
        let panValidationFlow = mockPanValidationFlow()
        panValidationFlow.getStubbingProxy().validate(pan: any()).thenDoNothing()
        let presenter = PanViewPresenter(panValidationFlow)

        presenter.onEditing(text: pan)

        verify(panValidationFlow).validate(pan: pan)
    }
    
    func testOnEditEndValidatesPan() {
        let pan = "123"
        let panValidationFlow = mockPanValidationFlow()
        panValidationFlow.getStubbingProxy().validate(pan: any()).thenDoNothing()
        let presenter = PanViewPresenter(panValidationFlow)

        presenter.onEditEnd(text: pan)

        verify(panValidationFlow).validate(pan: pan)
    }
    
    func mockPanValidationFlow() -> MockPanValidationFlow {
        let validationStateHandler = CardValidationStateHandler(MockAccessCheckoutCardValidationDelegate())
        let cvvValidationFlow = MockCvvValidationFlow(CvvValidator(), validationStateHandler)
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        let panValidator = PanValidator(configurationProvider)
        
        return MockPanValidationFlow(panValidator, validationStateHandler, cvvValidationFlow)
    }
}
