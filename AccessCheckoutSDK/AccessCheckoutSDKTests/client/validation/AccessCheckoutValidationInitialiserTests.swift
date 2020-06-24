@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class AccessCheckoutValidationInitialiserTests: XCTestCase {
    let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    var accessCheckoutValidationInitialiser: AccessCheckoutValidationInitialiser?
    
    let panView = PanView()
    let expiryDateView = ExpiryDateView()
    let cvcView = CvcView()
    let baseUrl = "some-url"
    let cardValidationDelegateMock = MockAccessCheckoutCardValidationDelegate()
    let cvcOnlyValidationDelegateMock = MockAccessCheckoutCvcOnlyValidationDelegate()
    
    override func setUp() {
        accessCheckoutValidationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        cardValidationDelegateMock.getStubbingProxy().panValidChanged(isValid: any()).thenDoNothing()
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
    }
    
    func testInitialisationForCardPaymentFlowRetrievesConfiguration() {
        let validationConfig = CardValidationConfig(panView: panView,
                                                    expiryDateView: expiryDateView,
                                                    cvcView: cvcView,
                                                    accessBaseUrl: baseUrl,
                                                    validationDelegate: cardValidationDelegateMock)
        
        accessCheckoutValidationInitialiser!.initialise(validationConfig)
        
        verify(configurationProvider).retrieveRemoteConfiguration(baseUrl: "some-url")
    }
    
    func testInitialisationForCardPaymentFlowSetsPresentersOnViews() {
        let validationConfig = CardValidationConfig(panView: panView,
                                                    expiryDateView: expiryDateView,
                                                    cvcView: cvcView,
                                                    accessBaseUrl: baseUrl,
                                                    validationDelegate: cardValidationDelegateMock)
        
        accessCheckoutValidationInitialiser!.initialise(validationConfig)
        
        XCTAssertNotNil(panView.presenter)
        XCTAssertNotNil(expiryDateView.presenter)
        XCTAssertNotNil(cvcView.presenter)
    }
    
    func testInitialisationForCvcOnlyFlowSetsPresenterOnView() {
        let validationConfig = CvcOnlyValidationConfig(cvcView: cvcView, validationDelegate: cvcOnlyValidationDelegateMock)
        
        accessCheckoutValidationInitialiser!.initialise(validationConfig)
        
        XCTAssertNotNil(cvcView.presenter)
    }
}
