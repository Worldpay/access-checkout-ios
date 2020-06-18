@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class AccessCheckoutCvcOnlyValidationDelegate_ClearText_Tests: XCTestCase {
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
        
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        let validationConfiguration = CvcOnlyValidationConfig(cvcView: cvcView, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
    }
    
    func testMerchantDelegateIsNotifiedWhenValidCvcIsCleared() {
        editCvc(text: "123")
        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: true)
        
        cvcView.clear()
        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenInvalidCvcIsCleared() {
        editCvc(text: "12")
        
        cvcView.clear()
        verify(merchantDelegate, never()).cvcValidChanged(isValid: false)
    }
    
    private func editCvc(text: String) {
        cvcView.textField.text = text
        cvcView.textFieldEditingChanged(cvcView.textField)
    }
}
