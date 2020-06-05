@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class AccessCheckoutValidationInitialiserTests: XCTestCase {
    let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    let cardDelegateMock = MockAccessCardDelegate()
    var accessCheckoutValidationInitialiser: AccessCheckoutValidationInitialiser?
    
    override func setUp() {
        accessCheckoutValidationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        cardDelegateMock.getStubbingProxy().handlePanValidationChange(isValid: any()).thenDoNothing()
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
    }
    
    func testSupportsInitialisationForCardPaymentFlow() {
        let panView = PANView()
        let expiryDateView = ExpiryDateView()
        let cvvView = CVVView()
        
        accessCheckoutValidationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                        baseUrl: "some-url", cardDelegate: cardDelegateMock)
    }
    
    func testRetrievesConfigurationWhenInitialisingForCardPaymentFlow() {
        let panView = PANView()
        let expiryDateView = ExpiryDateView()
        let cvvView = CVVView()
        
        accessCheckoutValidationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                        baseUrl: "some-url", cardDelegate: cardDelegateMock)
        verify(configurationProvider).retrieveRemoteConfiguration(baseUrl: "some-url")
    }
    
    func testInitialisationForCardPaymentFlowSetsPresentersOnViews() {
        let panView = PANView()
        let expiryDateView = ExpiryDateView()
        let cvvView = CVVView()
        
        accessCheckoutValidationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                        baseUrl: "some-url", cardDelegate: cardDelegateMock)
        
        XCTAssertNotNil(panView.presenter)
        XCTAssertNotNil(expiryDateView.presenter)
        XCTAssertNotNil(cvvView.presenter)
        XCTAssertTrue(cvvView.presenter is CVVViewForCardPaymentFlowPresenter)
    }
    
    func testSupportsInitialisingForCvvOnlyFlow() {
        let cvvView = CVVView()
        let merchantDelegate = MockAccessCvvOnlyDelegate()
        
        accessCheckoutValidationInitialiser!.initialise(cvvView: cvvView, cvvOnlyDelegate: merchantDelegate)
    }
    
    func testInitialisationForCvvOnlyFlowSetsPresenterOnView() {
        let cvvView = CVVView()
        let merchantDelegate = MockAccessCvvOnlyDelegate()
        
        accessCheckoutValidationInitialiser!.initialise(cvvView: cvvView, cvvOnlyDelegate: merchantDelegate)
        
        XCTAssertNotNil(cvvView.presenter)
        XCTAssertTrue(cvvView.presenter is CVVViewForCvvOnlyFlowPresenter)
    }
}
