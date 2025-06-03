import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class AccessCheckoutValidationInitialiserTests: XCTestCase {
    let configurationProvider = MockCardBrandsConfigurationProvider(
        CardBrandsConfigurationFactoryMock())
    var accessCheckoutValidationInitialiser: AccessCheckoutValidationInitialiser?

    let panAccessCheckoutUITextField = AccessCheckoutUITextField()
    let expiryDateAccessCheckoutUITextField = AccessCheckoutUITextField()
    let cvcAccessCheckoutUITextField = AccessCheckoutUITextField()

    let baseUrl = "some-url"
    let cardValidationDelegateMock = MockAccessCheckoutCardValidationDelegate()
    let cvcOnlyValidationDelegateMock = MockAccessCheckoutCvcOnlyValidationDelegate()

    override func setUp() {
        accessCheckoutValidationInitialiser = AccessCheckoutValidationInitialiser(
            configurationProvider)
        cardValidationDelegateMock.getStubbingProxy().panValidChanged(isValid: any())
            .thenDoNothing()
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(
            baseUrl: any(), acceptedCardBrands: any()
        ).thenDoNothing()
    }

    func testInitialisationForCardPaymentFlowWithTextFieldsRetrievesConfiguration() {
        let validationConfig = try! CardValidationConfig.builder()
            .pan(panAccessCheckoutUITextField)
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
            .accessBaseUrl(baseUrl)
            .enablePanFormatting()
            .validationDelegate(cardValidationDelegateMock)
            .acceptedCardBrands(["amex", "visa"])
            .build()

        accessCheckoutValidationInitialiser!.initialise(validationConfig)

        verify(configurationProvider).retrieveRemoteConfiguration(
            baseUrl: "some-url", acceptedCardBrands: ["amex", "visa"])
    }

    func testInitialisationForCardPaymentFlowWithTextFieldsSetsPresentersOnTextFieldAsDelegates() {
        let validationConfig = try! CardValidationConfig.builder()
            .pan(panAccessCheckoutUITextField)
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
            .accessBaseUrl(baseUrl)
            .enablePanFormatting()
            .validationDelegate(cardValidationDelegateMock)
            .acceptedCardBrands(["amex", "visa"])
            .build()

        accessCheckoutValidationInitialiser!.initialise(validationConfig)

        XCTAssertTrue(panAccessCheckoutUITextField.uiTextField.delegate is PanViewPresenter)
        XCTAssertTrue(
            expiryDateAccessCheckoutUITextField.uiTextField.delegate is ExpiryDateViewPresenter)
        XCTAssertTrue(cvcAccessCheckoutUITextField.uiTextField.delegate is CvcViewPresenter)
    }

    func testInitialisationForCvcOnlyPaymentFlowWithTextFieldsSetsPresentersOnTextFieldAsDelegate()
    {
        let validationConfig = try! CvcOnlyValidationConfig.builder()
            .cvc(cvcAccessCheckoutUITextField)
            .validationDelegate(cvcOnlyValidationDelegateMock)
            .build()

        accessCheckoutValidationInitialiser!.initialise(validationConfig)

        XCTAssertTrue(cvcAccessCheckoutUITextField.uiTextField.delegate is CvcViewPresenter)
    }
}
