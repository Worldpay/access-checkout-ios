@testable import AccessCheckoutSDK
import XCTest

class AccessCheckoutValidationInitialiserTests: XCTestCase {
    let cardBrandsConfigurationFactory = CardBrandsConfigurationFactoryMock()
    
    func testSupportsInitialisationForCardPaymentFlow() {
        let panView = PANView()
        let expiryDateView = ExpiryDateView()
        let cvvView = CVVView()
        let expectationToFulfill = expectation(description: "")
        
        AccessCheckoutValidationInitialiser(cardBrandsConfigurationFactory).initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView, baseUrl: "some-url") {
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testRetrievesConfigurationWhenInitialisingForCardPaymentFlow() {
        let panView = PANView()
        let expiryDateView = ExpiryDateView()
        let cvvView = CVVView()
        let expectationToFulfill = expectation(description: "")
        
        AccessCheckoutValidationInitialiser(cardBrandsConfigurationFactory).initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView, baseUrl: "some-url") {
            XCTAssertTrue(self.cardBrandsConfigurationFactory.createCalled)
            XCTAssertEqual("some-url", self.cardBrandsConfigurationFactory.baseUrlPassed)
            
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testInitialisationForCardPaymentFlowSetsPresentersOnViews() {
        let panView = PANView()
        let expiryDateView = ExpiryDateView()
        let cvvView = CVVView()
        let expectationToFulfill = expectation(description: "")
        
        AccessCheckoutValidationInitialiser(cardBrandsConfigurationFactory).initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView, baseUrl: "some-url") {
            XCTAssertTrue(panView.presenter is PANViewPresenter)
            XCTAssertTrue(expiryDateView.presenter is ExpiryDateViewPresenter)
            XCTAssertTrue(cvvView.presenter is CVVViewForCardPaymentFlowPresenter)
            
            expectationToFulfill.fulfill()
        }
        
        wait(for: [expectationToFulfill], timeout: 0.5)
    }
    
    func testSupportsInitialisingForCvvOnlyFlow() {
        let cvvView = CVVView()
        
        AccessCheckoutValidationInitialiser(cardBrandsConfigurationFactory).initialise(cvvView: cvvView)
    }
    
    func testInitialisationForCvvOnlyFlowSetsPresenterOnView() {
        let cvvView = CVVView()
        
        AccessCheckoutValidationInitialiser(cardBrandsConfigurationFactory).initialise(cvvView: cvvView)
        
        XCTAssertTrue(cvvView.presenter is CVVViewForCvvOnlyFlowPresenter)
    }
}
