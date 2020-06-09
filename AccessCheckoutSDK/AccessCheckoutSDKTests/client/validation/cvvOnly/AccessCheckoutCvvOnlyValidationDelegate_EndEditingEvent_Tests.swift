@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class AccessCheckoutCvvOnlyValidationDelegate_EndEditingEvent_Tests: XCTestCase {
    private let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    private var validationInitialiser: AccessCheckoutValidationInitialiser?
    private let cvvView = CVVView()
    private let merchantDelegate = MockAccessCheckoutCvvOnlyValidationDelegate()
    private let configuration = CardBrandsConfiguration([])
    
    override func setUp() {
        validationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        
        merchantDelegate.getStubbingProxy().handleCvvValidationChange(isValid: any()).thenDoNothing()
    }
    
    func testMerchantDelegateIsNotifiedOfCvvValidationStateChanges() {
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        let validationConfiguration = CvvOnlyValidationConfig(cvvView: cvvView, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editCvv(text: "123")
        
        verify(merchantDelegate, times(1)).handleCvvValidationChange(isValid: true)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenCvvChangesButValidationStatesDoesNotChange() {
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        let validationConfiguration = CvvOnlyValidationConfig(cvvView: cvvView, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editCvv(text: "456")
        editCvv(text: "123")
        
        verify(merchantDelegate, times(1)).handleCvvValidationChange(isValid: true)
    }
    
    private func editCvv(text: String) {
        cvvView.textField.text = text
        cvvView.textFieldDidEndEditing(cvvView.textField)
    }
}
