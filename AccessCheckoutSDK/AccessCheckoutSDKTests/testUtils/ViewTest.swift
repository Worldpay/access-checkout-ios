@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class ViewTestSuite : XCTestCase {
    private let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    private var validationInitialiser: AccessCheckoutValidationInitialiser?
    private let panView = PANView()
    private let expiryDateView = ExpiryDateView()
    private let cvcView = CvcView()
    private let baseUrl = "a-url"
    private let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
    
    func initialiseCardValidation() -> MockAccessCheckoutCardValidationDelegate {
        initialiseValidation([TestFixtures.visaBrand(), TestFixtures.maestroBrand()], panView, expiryDateView, cvcView)
        
        return merchantDelegate
    }
    
    func initialiseValidation(_ brands: [CardBrandModel], _ panView:PANView, _ expiryDateView:ExpiryDateView, _ cvcView:CvcView) {
        validationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
        
        merchantDelegate.getStubbingProxy().panValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().expiryDateValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cardBrandChanged(cardBrand: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()
        
        let cardBrandsConfiguration = createConfiguration(with: brands)
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvcView: cvcView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
    }
    
    private func createConfiguration(with brands: [CardBrandModel]) -> CardBrandsConfiguration {
        return CardBrandsConfiguration(brands)
    }
}
