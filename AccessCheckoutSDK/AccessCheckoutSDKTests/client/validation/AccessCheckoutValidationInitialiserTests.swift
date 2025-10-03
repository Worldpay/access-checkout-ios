import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class AccessCheckoutValidationInitialiserTests: XCTestCase {
    let configurationProvider = MockCardBrandsConfigurationProvider(
        CardBrandsConfigurationFactoryMock())
    var accessCheckoutValidationInitialiser: AccessCheckoutValidationInitialiser?
    var accessCheckoutClient: AccessCheckoutClient!

    let panAccessCheckoutUITextField = AccessCheckoutUITextField()
    let expiryDateAccessCheckoutUITextField = AccessCheckoutUITextField()
    let cvcAccessCheckoutUITextField = AccessCheckoutUITextField()

    let baseUrl = "some-url"
    let checkoutId = "0000-0000-0000-0000-000000000000"
    let cardValidationDelegateMock = MockAccessCheckoutCardValidationDelegate()
    let cvcOnlyValidationDelegateMock = MockAccessCheckoutCvcOnlyValidationDelegate()

    override func setUp() {
        accessCheckoutValidationInitialiser = AccessCheckoutValidationInitialiser(
            configurationProvider)

        accessCheckoutClient = try! AccessCheckoutClientBuilder()
            .checkoutId(checkoutId)
            .accessBaseUrl(baseUrl)
            .build()

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
            .validationDelegate(cardValidationDelegateMock)
            .acceptedCardBrands(["amex", "visa"])
            .enablePanFormatting()
            .build()

        accessCheckoutValidationInitialiser!.initialise(
            validationConfig,
            accessCheckoutClient: accessCheckoutClient
        )

        verify(configurationProvider).retrieveRemoteConfiguration(
            baseUrl: baseUrl,
            acceptedCardBrands: ["amex", "visa"]
        )
    }

    func testInitialisationForCardPaymentFlowWithTextFieldsSetsPresentersOnTextFieldAsDelegates() {
        let validationConfig = try! CardValidationConfig.builder()
            .pan(panAccessCheckoutUITextField)
            .expiryDate(expiryDateAccessCheckoutUITextField)
            .cvc(cvcAccessCheckoutUITextField)
            .validationDelegate(cardValidationDelegateMock)
            .acceptedCardBrands(["amex", "visa"])
            .enablePanFormatting()
            .build()

        accessCheckoutValidationInitialiser!.initialise(
            validationConfig,
            accessCheckoutClient: accessCheckoutClient
        )

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

        accessCheckoutValidationInitialiser!.initialise(
            validationConfig,
            accessCheckoutClient: accessCheckoutClient
        )

        XCTAssertTrue(cvcAccessCheckoutUITextField.uiTextField.delegate is CvcViewPresenter)
    }
}
