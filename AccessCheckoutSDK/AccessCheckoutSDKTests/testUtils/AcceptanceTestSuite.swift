import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class AcceptanceTestSuite: XCTestCase {
    let panTextField = AccessCheckoutUITextField()
    let expiryDateTextField = AccessCheckoutUITextField()
    let cvcTextField = AccessCheckoutUITextField()
    let checkoutId = "0000-0000-0000-0000-000000000000"
    let baseUrl = "a-url"

    func initialiseCardValidation(cardBrands: [CardBrandModel], acceptedCardBrands: [String] = [])
        -> MockAccessCheckoutCardValidationDelegate
    {
        return initialiseCardValidation(
            cardBrands: cardBrands, acceptedBrands: acceptedCardBrands, panTextField,
            expiryDateTextField, cvcTextField)
    }

    func initialiseCardValidation() -> MockAccessCheckoutCardValidationDelegate {
        return initialiseCardValidation(
            cardBrands: [TestFixtures.visaBrand(), TestFixtures.maestroBrand()], acceptedBrands: [],
            panTextField, expiryDateTextField, cvcTextField)
    }

    func initialiseCardValidation(
        cardBrands: [CardBrandModel], acceptedBrands: [String],
        _ panAccessCheckoutTextField: AccessCheckoutUITextField,
        _ expiryDateAccessCheckoutTextField: AccessCheckoutUITextField,
        _ cvcAccessCheckoutTextField: AccessCheckoutUITextField
    ) -> MockAccessCheckoutCardValidationDelegate {
        let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
        merchantDelegate.getStubbingProxy().panValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().expiryDateValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cardBrandsChanged(cardBrands: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()

        let cardBrandsConfiguration = createConfiguration(
            brands: cardBrands, acceptedBrands: acceptedBrands)
        let configurationProvider = MockCardBrandsConfigurationProvider(
            CardBrandsConfigurationFactoryMock())
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(
            baseUrl: any(), acceptedCardBrands: any()
        ).thenDoNothing()
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)

        let validationConfiguration = try! CardValidationConfig.builder()
            .pan(panAccessCheckoutTextField)
            .expiryDate(expiryDateAccessCheckoutTextField)
            .cvc(cvcAccessCheckoutTextField)
            .validationDelegate(merchantDelegate)
            .acceptedCardBrands(acceptedBrands)
            .build()

        let accessCheckoutClient = try! AccessCheckoutClientBuilder()
            .checkoutId(checkoutId)
            .accessBaseUrl(baseUrl)
            .build()

        let validationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        validationInitialiser.initialise(
            validationConfiguration, accessCheckoutClient: accessCheckoutClient
        )

        return merchantDelegate
    }

    func initialiseCvcOnlyValidation() -> MockAccessCheckoutCvcOnlyValidationDelegate {
        let cardBrandsConfiguration = CardBrandsConfiguration(
            allCardBrands: [], acceptedCardBrands: [])
        let configurationProvider = MockCardBrandsConfigurationProvider(
            CardBrandsConfigurationFactoryMock())
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(
            baseUrl: any(), acceptedCardBrands: any()
        ).thenDoNothing()
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)

        let merchantDelegate = MockAccessCheckoutCvcOnlyValidationDelegate()
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()

        let validationConfiguration = try! CvcOnlyValidationConfig.builder()
            .cvc(cvcTextField)
            .validationDelegate(merchantDelegate)
            .build()

        let accessCheckoutClient = try! AccessCheckoutClientBuilder()
            .checkoutId(checkoutId)
            .accessBaseUrl(baseUrl)
            .build()

        let validationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        validationInitialiser.initialise(
            validationConfiguration, accessCheckoutClient: accessCheckoutClient
        )

        return merchantDelegate
    }

    func editPan(text: String) {
        panTextField.text = text
        (panTextField.delegate as! Presenter).textFieldEditingChanged(panTextField.uiTextField)
    }

    func clearPan() {
        editPan(text: "")
    }

    func removeFocusFromPan() {
        (panTextField.delegate!).textFieldDidEndEditing!(panTextField.uiTextField)
    }

    func canEnterPan(_ text: String) -> Bool {
        let range = NSRange(location: 0, length: 0)

        return (panTextField.delegate!).textField!(
            panTextField.uiTextField, shouldChangeCharactersIn: range, replacementString: text)
    }

    func editExpiryDate(text: String) {
        expiryDateTextField.text = text
        (expiryDateTextField.delegate as! Presenter).textFieldEditingChanged(
            expiryDateTextField.uiTextField)
    }

    func removeFocusFromExpiryDate() {
        (expiryDateTextField.delegate!).textFieldDidEndEditing!(expiryDateTextField.uiTextField)
    }

    func clearExpiryDate() {
        editExpiryDate(text: "")
    }

    func canEnterExpiryDate(_ text: String) -> Bool {
        let range = NSRange(location: 0, length: 0)

        return (expiryDateTextField.delegate!).textField!(
            expiryDateTextField.uiTextField, shouldChangeCharactersIn: range,
            replacementString: text)
    }

    func editCvc(text: String) {
        cvcTextField.text = text
        (cvcTextField.delegate as! Presenter).textFieldEditingChanged(cvcTextField.uiTextField)
    }

    func clearCvc() {
        editCvc(text: "")
    }

    func removeFocusFromCvc() {
        (cvcTextField.delegate!).textFieldDidEndEditing!(cvcTextField.uiTextField)
    }

    func canEnterCvc(_ text: String) -> Bool {
        let range = NSRange(location: 0, length: 0)

        return (cvcTextField.delegate!).textField!(
            cvcTextField.uiTextField, shouldChangeCharactersIn: range, replacementString: text)
    }

    private func createConfiguration(brands: [CardBrandModel], acceptedBrands: [String])
        -> CardBrandsConfiguration
    {
        return CardBrandsConfiguration(allCardBrands: brands, acceptedCardBrands: acceptedBrands)
    }
}
