@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class AccessCheckoutCvcOnlyValidationDelegate_EditText_Tests: XCTestCase {
    private let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    private var validationInitialiser: AccessCheckoutValidationInitialiser?
    private let cvcView = CvcView()
    private let merchantDelegate = MockAccessCheckoutCvcOnlyValidationDelegate()
    private let configuration = CardBrandsConfiguration([])
    
    override func setUp() {
        validationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()
    }
    
    func testMerchantDelegateIsNotifiedOfCvcValidationStateChanges() {
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        let validationConfiguration = CvcOnlyValidationConfig(cvcView: cvcView, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editCvc(text: "123")
        
        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: true)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenCvcChangesButValidationStatesDoesNotChange() {
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        let validationConfiguration = CvcOnlyValidationConfig(cvcView: cvcView, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editCvc(text: "456")
        editCvc(text: "123")
        
        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: true)
    }
    
    func testMerchantIsNotifiedOfValidationSuccess() {
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        let validationConfiguration = CvcOnlyValidationConfig(cvcView: cvcView, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editCvc(text: "123")
        
        verify(merchantDelegate, times(1)).validationSuccess()
    }
    
    func testMerchantIsNotNotifiedOfValidationSuccessWhenCvcIsNotValid() {
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        let validationConfiguration = CvcOnlyValidationConfig(cvcView: cvcView, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editCvc(text: "12")
        
        verify(merchantDelegate, never()).validationSuccess()
    }
    
    private func editCvc(text: String) {
        cvcView.textField.text = text
        cvcView.textFieldEditingChanged(cvcView.textField)
    }
}
