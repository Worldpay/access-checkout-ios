@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class LegacyViewTestSuite: XCTestCase {
    let panView = PanView()
    let expiryDateView = ExpiryDateView()
    let cvcView = CvcView()
    
    func initialiseCardValidation(cardBrands: [CardBrandModel], acceptedCardBrands: [String] = []) -> MockAccessCheckoutCardValidationDelegate {
        return initialiseCardValidation(cardBrands: cardBrands, acceptedCardBrands: acceptedCardBrands, panView, expiryDateView, cvcView)
    }
    
    func initialiseCardValidation() -> MockAccessCheckoutCardValidationDelegate {
        return initialiseCardValidation(cardBrands: [TestFixtures.visaBrand(), TestFixtures.maestroBrand()], acceptedCardBrands: [], panView, expiryDateView, cvcView)
    }
    
    func initialiseCardValidation(cardBrands: [CardBrandModel], acceptedCardBrands: [String], _ panView: PanView, _ expiryDateView: ExpiryDateView, _ cvcView: CvcView) -> MockAccessCheckoutCardValidationDelegate {
        let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantDelegate.getStubbingProxy().panValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().expiryDateValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cardBrandChanged(cardBrand: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()
        
        let cardBrandsConfiguration = createConfiguration(brands: cardBrands, acceptedBrands: acceptedCardBrands)
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any(), acceptedCardBrands: any()).thenDoNothing()
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView,
                                                           expiryDateView: expiryDateView,
                                                           cvcView: cvcView,
                                                           accessBaseUrl: "a-url",
                                                           validationDelegate: merchantDelegate,
                                                           acceptedCardBrands: acceptedCardBrands)
        
        let validationInitialiser: AccessCheckoutValidationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        
        validationInitialiser.initialise(validationConfiguration)
        
        return merchantDelegate
    }
    
    func initialiseCvcOnlyValidation() -> MockAccessCheckoutCvcOnlyValidationDelegate {
        let cardBrandsConfiguration = CardBrandsConfiguration(allCardBrands: [], acceptedCardBrands: [])
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any(), acceptedCardBrands: any()).thenDoNothing()
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let merchantDelegate = MockAccessCheckoutCvcOnlyValidationDelegate()
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()
        
        let validationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        let validationConfiguration = CvcOnlyValidationConfig(cvcView: cvcView, validationDelegate: merchantDelegate)
        validationInitialiser.initialise(validationConfiguration)
        
        return merchantDelegate
    }
    
    func editPan(text: String) {
        panView.textField.text = text
        panView.textFieldEditingChanged(panView.textField)
    }
    
    func clearPan() {
        panView.clear()
    }
    
    func removeFocusFromPan() {
        panView.textFieldDidEndEditing(panView.textField)
    }
    
    func canEnterPan(_ text: String) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return panView.textField(panView.textField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    func editExpiryDate(text: String) {
        expiryDateView.textField.text = text
        expiryDateView.textFieldEditingChanged(expiryDateView.textField)
    }
    
    func removeFocusFromExpiryDate() {
        expiryDateView.textFieldDidEndEditing(expiryDateView.textField)
    }
    
    func clearExpiryDate() {
        expiryDateView.clear()
    }
    
    func canEnterExpiryDate(_ text: String) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return expiryDateView.textField(expiryDateView.textField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    func editCvc(text: String) {
        cvcView.textField.text = text
        cvcView.textFieldEditingChanged(cvcView.textField)
    }
    
    func clearCvc() {
        cvcView.clear()
    }
    
    func removeFocusFromCvc() {
        cvcView.textFieldDidEndEditing(cvcView.textField)
    }
    
    func canEnterCvc(_ text: String) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return cvcView.textField(cvcView.textField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    private func createConfiguration(brands: [CardBrandModel], acceptedBrands: [String]) -> CardBrandsConfiguration {
        return CardBrandsConfiguration(allCardBrands: brands, acceptedCardBrands: acceptedBrands)
    }
}
