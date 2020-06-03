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
        
        XCTAssertTrue(panView.presenter is PANViewPresenter)
        XCTAssertTrue(expiryDateView.presenter is ExpiryDateViewPresenter)
        XCTAssertTrue(cvvView.presenter is CVVViewForCardPaymentFlowPresenter)
    }
    
    func testSupportsInitialisingForCvvOnlyFlow() {
        let cvvView = CVVView()
        
        accessCheckoutValidationInitialiser!.initialise(cvvView: cvvView)
    }
    
    func testInitialisationForCvvOnlyFlowDoesNotFetchRemoteConfiguration() {
        let cvvView = CVVView()
        
        accessCheckoutValidationInitialiser!.initialise(cvvView: cvvView)
        
        verify(configurationProvider, never()).retrieveRemoteConfiguration(baseUrl: "some-url")
    }
    
    func testInitialisationForCvvOnlyFlowSetsPresenterOnView() {
        let cvvView = CVVView()
        
        accessCheckoutValidationInitialiser!.initialise(cvvView: cvvView)
        
        XCTAssertTrue(cvvView.presenter is CVVViewForCvvOnlyFlowPresenter)
    }
}
