@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class AccessCheckoutValidationInitialiserTests: XCTestCase {
    let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    var accessCheckoutValidationInitialiser: AccessCheckoutValidationInitialiser?
    
    let panView = PANView()
    let expiryDateView = ExpiryDateView()
    let cvvView = CVVView()
    let baseUrl = "some-url"
    let cardValidationDelegateMock = MockAccessCheckoutCardValidationDelegate()
    let cvvOnlyValidationDelegateMock = MockAccessCheckoutCvvOnlyValidationDelegate()
    
    override func setUp() {
        accessCheckoutValidationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        cardValidationDelegateMock.getStubbingProxy().panValidChanged(isValid: any()).thenDoNothing()
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
    }
    
    func testInitialisationForCardPaymentFlowRetrievesConfiguration() {
        let validationConfig = CardValidationConfig(panView: panView,
                                                    expiryDateView: expiryDateView,
                                                    cvvView: cvvView,
                                                    accessBaseUrl: baseUrl,
                                                    validationDelegate: cardValidationDelegateMock)
        
        accessCheckoutValidationInitialiser!.initialise(validationConfig)
        
        verify(configurationProvider).retrieveRemoteConfiguration(baseUrl: "some-url")
    }
    
    func testInitialisationForCardPaymentFlowSetsPresentersOnViews() {
        let validationConfig = CardValidationConfig(panView: panView,
                                                    expiryDateView: expiryDateView,
                                                    cvvView: cvvView,
                                                    accessBaseUrl: baseUrl,
                                                    validationDelegate: cardValidationDelegateMock)
        
        accessCheckoutValidationInitialiser!.initialise(validationConfig)
        
        XCTAssertNotNil(panView.presenter)
        XCTAssertNotNil(expiryDateView.presenter)
        XCTAssertNotNil(cvvView.presenter)
    }
    
    func testInitialisationForCvvOnlyFlowSetsPresenterOnView() {
        let validationConfig = CvvOnlyValidationConfig(cvvView: cvvView, validationDelegate: cvvOnlyValidationDelegateMock)
        
        accessCheckoutValidationInitialiser!.initialise(validationConfig)
        
        XCTAssertNotNil(cvvView.presenter)
    }
}
