@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class AcceptanceTestSuite: XCTestCase {
    let panTextField = UITextField()
    let expiryDateTextField = UITextField()
    let cvcTextField = UITextField()
    
    func initialiseCardValidation(cardBrands: [CardBrandModel], acceptedCardBrands: [String] = []) -> MockAccessCheckoutCardValidationDelegate {
        return initialiseCardValidation(cardBrands: cardBrands, acceptedBrands: acceptedCardBrands, panTextField, expiryDateTextField, cvcTextField)
    }
    
    func initialiseCardValidation() -> MockAccessCheckoutCardValidationDelegate {
        return initialiseCardValidation(cardBrands: [TestFixtures.visaBrand(), TestFixtures.maestroBrand()], acceptedBrands: [], panTextField, expiryDateTextField, cvcTextField)
    }
    
    func initialiseCardValidation(cardBrands: [CardBrandModel], acceptedBrands: [String], _ panTextField: UITextField, _ expiryDateTextField: UITextField, _ cvcTextField: UITextField) -> MockAccessCheckoutCardValidationDelegate {
        let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantDelegate.getStubbingProxy().panValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().expiryDateValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cardBrandChanged(cardBrand: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()
        
        let cardBrandsConfiguration = createConfiguration(brands: cardBrands, acceptedBrands: acceptedBrands)
        let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any(), acceptedCardBrands: any()).thenDoNothing()
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = try! CardValidationConfig.builder().pan(panTextField)
            .expiryDate(expiryDateTextField)
            .cvc(cvcTextField)
            .accessBaseUrl("a-url")
            .validationDelegate(merchantDelegate)
            .acceptedCardBrands(acceptedBrands)
            .build()
        
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
        let validationConfiguration = try! CvcOnlyValidationConfig.builder()
            .cvc(cvcTextField)
            .validationDelegate(merchantDelegate)
            .build()
        validationInitialiser.initialise(validationConfiguration)
        
        return merchantDelegate
    }
    
    func editPan(text: String) {
        panTextField.text = text
        (panTextField.delegate as! Presenter).textFieldEditingChanged(panTextField)
    }
    
    func clearPan() {
        editPan(text: "")
    }
    
    func removeFocusFromPan() {
        (panTextField.delegate!).textFieldDidEndEditing!(panTextField)
    }
    
    func canEnterPan(_ text: String) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return (panTextField.delegate!).textField!(panTextField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    func editExpiryDate(text: String) {
        expiryDateTextField.text = text
        (expiryDateTextField.delegate as! Presenter).textFieldEditingChanged(expiryDateTextField)
    }
    
    func removeFocusFromExpiryDate() {
        (expiryDateTextField.delegate!).textFieldDidEndEditing!(expiryDateTextField)
    }
    
    func clearExpiryDate() {
        editExpiryDate(text: "")
    }
    
    func canEnterExpiryDate(_ text: String) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return (expiryDateTextField.delegate!).textField!(expiryDateTextField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    func editCvc(text: String) {
        cvcTextField.text = text
        (cvcTextField.delegate as! Presenter).textFieldEditingChanged(cvcTextField)
    }
    
    func clearCvc() {
        editCvc(text: "")
    }
    
    func removeFocusFromCvc() {
        (cvcTextField.delegate!).textFieldDidEndEditing!(cvcTextField)
    }
    
    func canEnterCvc(_ text: String) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return (cvcTextField.delegate!).textField!(cvcTextField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    private func createConfiguration(brands: [CardBrandModel], acceptedBrands: [String]) -> CardBrandsConfiguration {
        return CardBrandsConfiguration(allCardBrands: brands, acceptedCardBrands: acceptedBrands)
    }
}
