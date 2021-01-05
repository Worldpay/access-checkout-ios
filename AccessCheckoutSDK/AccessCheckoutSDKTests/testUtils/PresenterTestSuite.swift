@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PresenterTestSuite: XCTestCase {
    let panTextField = UITextField()
    let expiryDateTextField = UITextField()
    let cvcTextField = UITextField()
    let mockConfigurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    
    func initialiseCustomCardValidation() -> MockAccessCheckoutCardValidationDelegate {
        return initialiseCustomCardValidation(configurationProvider: mockConfigurationProvider, cardBrands:[], panTextField, expiryDateTextField, cvcTextField)
    }
    
    func initialiseCustomCardValidation(configurationProvider: MockCardBrandsConfigurationProvider, cardBrands: [CardBrandModel]) -> MockAccessCheckoutCardValidationDelegate {
        return initialiseCustomCardValidation(configurationProvider: configurationProvider, cardBrands: [TestFixtures.visaBrand(), TestFixtures.maestroBrand()], panTextField, expiryDateTextField, cvcTextField)
    }
    
    func initialiseCustomCardValidation(configurationProvider: MockCardBrandsConfigurationProvider, cardBrands: [CardBrandModel], _ panTextField: UITextField, _ expiryDateTextField: UITextField, _ cvcTextField: UITextField) -> MockAccessCheckoutCardValidationDelegate {
        let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantDelegate.getStubbingProxy().panValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().expiryDateValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cardBrandChanged(cardBrand: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()
        
        let cardBrandsConfiguration = createConfiguration(with: cardBrands)
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(
                                                           panTextField: panTextField,
                                                           expiryDateTextField: expiryDateTextField,
                                                           cvcTextField: cvcTextField,
                                                           accessBaseUrl: "a-url",
                                                           validationDelegate: merchantDelegate)
        
        let validationInitialiser: AccessCheckoutValidationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        
        validationInitialiser.initialise(validationConfiguration)
        
        return merchantDelegate
    }
    
    func canEnterPanInUITextField(presenter: PanViewPresenter, uiTextField: UITextField, _ text: String) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return presenter.textField(uiTextField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    func canEnterExpiryDate(presenter: ExpiryDateViewPresenter, uiTextField: UITextField, _ text: String) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return presenter.textField(uiTextField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    func canEnterCvc(presenter: CvcViewPresenter, uiTextField: UITextField, _ text: String) -> Bool {
        let range = NSRange(location: 0, length: 0)
        
        return presenter.textField(uiTextField, shouldChangeCharactersIn: range, replacementString: text)
    }
    
    private func createConfiguration(with brands: [CardBrandModel]) -> CardBrandsConfiguration {
        return CardBrandsConfiguration(brands)
    }
}

