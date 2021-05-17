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
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any(), acceptedCardBrands: any()).thenDoNothing()
    }
    
    func testInitialisationForCardPaymentFlowRetrievesConfiguration() {
        let validationConfig = CardValidationConfig(panView: panView,
                                                    expiryDateView: expiryDateView,
                                                    cvcView: cvcView,
                                                    accessBaseUrl: baseUrl,
                                                    validationDelegate: cardValidationDelegateMock,
                                                    acceptedCardBrands: ["amex", "visa"])
        
        accessCheckoutValidationInitialiser!.initialise(validationConfig)
        
        verify(configurationProvider).retrieveRemoteConfiguration(baseUrl: "some-url", acceptedCardBrands: ["amex", "visa"])
    }
    
    func testInitialisationForCardPaymentFlowSetsPresentersOnViews() {
        let validationConfig = CardValidationConfig(panView: panView,
                                                    expiryDateView: expiryDateView,
                                                    cvcView: cvcView,
                                                    accessBaseUrl: baseUrl,
                                                    validationDelegate: cardValidationDelegateMock,
                                                    acceptedCardBrands: ["amex", "visa"])
        
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
    
    // MARK: Tests for using UITextView to initialise
    
    let panTextField = UITextField()
    let cvcTextField = UITextField()
    let expiryDateTextField = UITextField()
    
    func testInitialisationForCardPaymentFlowWithTextFieldsRetrievesConfiguration() {
        let validationConfig = CardValidationConfig(panTextField: panTextField,
                                                    expiryDateTextField: expiryDateTextField,
                                                    cvcTextField: cvcTextField,
                                                    accessBaseUrl: baseUrl,
                                                    validationDelegate: cardValidationDelegateMock,
                                                    acceptedCardBrands: ["amex", "visa"])
        
        accessCheckoutValidationInitialiser!.initialise(validationConfig)
        
        verify(configurationProvider).retrieveRemoteConfiguration(baseUrl: "some-url", acceptedCardBrands: ["amex", "visa"])
    }
    
    func testInitialisationForCardPaymentFlowWithTextFieldsSetsPresentersOnTextFieldAsDelegate() {
        let validationConfig = CardValidationConfig(panTextField: panTextField,
                                                    expiryDateTextField: expiryDateTextField,
                                                    cvcTextField: cvcTextField,
                                                    accessBaseUrl: baseUrl,
                                                    validationDelegate: cardValidationDelegateMock,
                                                    acceptedCardBrands: ["amex", "visa"])
        
        accessCheckoutValidationInitialiser!.initialise(validationConfig)
        
        XCTAssertTrue(panTextField.delegate is PanViewPresenter)
        XCTAssertTrue(expiryDateTextField.delegate is ExpiryDateViewPresenter)
        XCTAssertTrue(cvcTextField.delegate is CvcViewPresenter)
    }
    
    func testInitialisationForCvcOnlyPaymentFlowWithTextFieldsSetsPresentersOnTextFieldAsDelegate() {
        let validationConfig = CvcOnlyValidationConfig(cvcTextField: cvcTextField,
                                                       validationDelegate: cvcOnlyValidationDelegateMock)
        
        accessCheckoutValidationInitialiser!.initialise(validationConfig)
        XCTAssertTrue(cvcTextField.delegate is CvcViewPresenter)
    }
    
    func testInitialisationWithBuilderForCardPaymentFlowSetsCorrectConfigAndCanDisableFormatting() {
        let config = try! CardValidationConfig.builder()
                .pan(panTextField)
                .expiryDate(expiryDateTextField)
                .cvc(cvcTextField)
                .accessBaseUrl(baseUrl)
                .validationDelegate(cardValidationDelegateMock)
                .acceptedCardBrands(["amex","visa"])
                .disablePanFormatting()
                .build();
        
        accessCheckoutValidationInitialiser!.initialise(config)
        
        XCTAssertTrue(panTextField.delegate is PanViewPresenter)
        XCTAssertTrue(expiryDateTextField.delegate is ExpiryDateViewPresenter)
        XCTAssertTrue(cvcTextField.delegate is CvcViewPresenter)
    }
}
