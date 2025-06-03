import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class AccessCheckoutCvcOnlyValidationDelegate_ClearText_Tests: XCTestCase {
    private let configurationProvider = MockCardBrandsConfigurationProvider(
        CardBrandsConfigurationFactoryMock())
    private var validationInitialiser: AccessCheckoutValidationInitialiser?
    private let cvvView = CvcView()
    private let merchantDelegate = MockAccessCheckoutCvvOnlyValidationDelegate()
    private let configuration = CardBrandsConfiguration([])

    override func setUp() {
        validationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)

        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any())
            .thenDoNothing()
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)

        merchantDelegate.getStubbingProxy().cvvValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()

        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        let validationConfiguration = CvcOnlyValidationConfig(
            cvcView: cvvView, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
    }

    func testMerchantDelegateIsNotifiedWhenValidCvvIsCleared() {
        editCvv(text: "123")
        verify(merchantDelegate, times(1)).cvvValidChanged(isValid: true)

        cvvView.clear()
        verify(merchantDelegate, times(1)).cvvValidChanged(isValid: false)
    }

    func testMerchantDelegateIsNotNotifiedWhenInvalidCvvIsCleared() {
        editCvv(text: "12")

        cvvView.clear()
        verify(merchantDelegate, never()).cvvValidChanged(isValid: false)
    }

    private func editCvv(text: String) {
        cvvView.textField.text = text
        cvvView.textFieldEditingChanged(cvvView.textField)
    }
}
