@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class AccessCheckoutCvcOnlyValidationDelegate_FocusOut_Tests: XCTestCase {
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
    
    func testMerchantDelegateIsNotNotifiedWhenCvcComponentWithValidCvcLosesFocus() {
        editCvc(text: "123")
        clearInvocations(merchantDelegate)
        
        removeFocusFromCvc()
        
        verify(merchantDelegate, never()).cvcValidChanged(isValid: true)
    }
    
    func testMerchantDelegateIsNotifiedWhenCvcComponentWithInvalidCvcLosesFocusAndMerchantHasNeverBeenNotified() {
        editCvc(text: "12")
        clearInvocations(merchantDelegate)
        
        removeFocusFromCvc()
        
        verify(merchantDelegate).cvcValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenCvcComponentWithInvalidCvcLosesFocusAndMerchantHasAlreadyBeenNotifiedOfTheInvalidCvc() {
        editCvc(text: "123")
        editCvc(text: "12")
        clearInvocations(merchantDelegate)
        
        removeFocusFromCvc()
        
        verify(merchantDelegate, never()).cvcValidChanged(isValid: false)
    }
    
    private func editCvc(text: String) {
        cvcView.textField.text = text
        cvcView.textFieldEditingChanged(cvcView.textField)
    }
    
    private func removeFocusFromCvc() {
        cvcView.textFieldDidEndEditing(cvcView.textField)
    }
}
