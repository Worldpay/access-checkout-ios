@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class AccessCheckoutCvvOnlyValidationDelegate_FocusOut_Tests: XCTestCase {
    private let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    private var validationInitialiser: AccessCheckoutValidationInitialiser?
    private let cvvView = CVVView()
    private let merchantDelegate = MockAccessCheckoutCvvOnlyValidationDelegate()
    private let configuration = CardBrandsConfiguration([])
    
    override func setUp() {
        validationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        
        merchantDelegate.getStubbingProxy().cvvValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()
        
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        let validationConfiguration = CvvOnlyValidationConfig(cvvView: cvvView, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenCvvComponentWithValidCvvLosesFocus() {
        editCvv(text: "123")
        clearInvocations(merchantDelegate)
        
        removeFocusFromCvv()
        
        verify(merchantDelegate, never()).cvvValidChanged(isValid: true)
    }
    
    func testMerchantDelegateIsNotifiedWhenCvvComponentWithInvalidCvvLosesFocusAndMerchantHasNeverBeenNotified() {
        editCvv(text: "12")
        clearInvocations(merchantDelegate)
        
        removeFocusFromCvv()
        
        verify(merchantDelegate).cvvValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenCvvComponentWithInvalidCvvLosesFocusAndMerchantHasAlreadyBeenNotifiedOfTheInvalidCvv() {
        editCvv(text: "123")
        editCvv(text: "12")
        clearInvocations(merchantDelegate)
        
        removeFocusFromCvv()
        
        verify(merchantDelegate, never()).cvvValidChanged(isValid: false)
    }
    
    private func editCvv(text: String) {
        cvvView.textField.text = text
        cvvView.textFieldEditingChanged(cvvView.textField)
    }
    
    private func removeFocusFromCvv() {
        cvvView.textFieldDidEndEditing(cvvView.textField)
    }
}
