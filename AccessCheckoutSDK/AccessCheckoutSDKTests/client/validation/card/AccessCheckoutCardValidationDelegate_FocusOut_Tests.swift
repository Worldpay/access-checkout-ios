@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class AccessCheckoutCardValidationDelegate_FocusOut_Tests: XCTestCase {
    private let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    private var validationInitialiser: AccessCheckoutValidationInitialiser?
    private let panView = PANView()
    private let expiryDateView = ExpiryDateView()
    private let cvvView = CVVView()
    private let baseUrl = "a-url"
    private let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
    
    private let visaBrand = TextFixtures.createCardBrandModel(name: "visa",
                                                              panPattern: "^(?!^493698\\d*$)4\\d*$",
                                                              panValidLengths: [16, 18, 19],
                                                              cvcValidLength: 3)
    
    private let maestroBrand = TextFixtures.createCardBrandModel(name: "maestro",
                                                                 panPattern: "^(493698|(50[0-5][0-9]{2}|506[0-5][0-9]|5066[0-9])|(5067[7-9]|506[89][0-9]|50[78][0-9]{2})|5[6-9]|63|67)\\d*$",
                                                                 panValidLengths: [12, 13, 14, 15, 16, 17, 18, 19],
                                                                 cvcValidLength: 3)
    
    private let amexBrand = TextFixtures.createCardBrandModel(name: "amex",
                                                              panPattern: "^3[47]\\d*$",
                                                              panValidLengths: [15],
                                                              cvcValidLength: 4)
    
    private let validVisaPan1 = "4111111111111111"
    private let validVisaPan2 = "4563648800001000"
    private let validMasterCardPan = "5500000000000004"
    private let invalidVisaPan = "123"
    
    override func setUp() {
        validationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
        
        merchantDelegate.getStubbingProxy().panValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cvvValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().expiryDateValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cardBrandChanged(cardBrand: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()
        
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
    }
    
    // MARK: PAN validation tests
    
    func testMerchantDelegateIsNotNotifiedWhenPanComponentWithValidPanLosesFocus() {
        editPan(text: validVisaPan1)
        clearInvocations(merchantDelegate)
        
        removeFocusFromPan()
        
        verify(merchantDelegate, never()).panValidChanged(isValid: true)
    }
    
    func testMerchantDelegateIsNotifiedWhenPanComponentWithInvalidPanLosesFocusAndMerchantHasNeverBeenNotified() {
        editPan(text: invalidVisaPan)
        clearInvocations(merchantDelegate)
        
        removeFocusFromPan()
        
        verify(merchantDelegate, times(1)).panValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenPanComponentWithInvalidPanLosesFocusAndMerchantHasAlreadyBeenNotifiedOfTheInvalidPan() {
        editPan(text: validVisaPan1)
        editPan(text: invalidVisaPan)
        clearInvocations(merchantDelegate)
        
        removeFocusFromPan()
        
        verify(merchantDelegate, never()).panValidChanged(isValid: false)
    }
    
    // MARK: Expiry Date validation tests
    
    func testMerchantDelegateIsNotNotifiedWhenExpiryDateComponentWithValidExpiryDateLosesFocus() {
        editExpiryDate(text: "11/32")
        clearInvocations(merchantDelegate)
        
        removeFocusFromExpiryDate()
        
        verify(merchantDelegate, never()).expiryDateValidChanged(isValid: true)
    }
    
    func testMerchantDelegateIsNotifiedWhenExpiryDateComponentWithInvalidExpiryDateLosesFocusAndMerchantHasNeverBeenNotified() {
        editExpiryDate(text: "11/3")
        clearInvocations(merchantDelegate)
        
        removeFocusFromExpiryDate()
        
        verify(merchantDelegate, times(1)).expiryDateValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenExpiryDateComponentWithInvalidExpiryDateLosesFocusAndMerchantHasAlreadyBeenNotifiedOfTheInvalidExpiryDate() {
        editExpiryDate(text: "11/33")
        editExpiryDate(text: "11/3")
        clearInvocations(merchantDelegate)
        
        removeFocusFromExpiryDate()
        
        verify(merchantDelegate, never()).expiryDateValidChanged(isValid: false)
    }
    
    // MARK: Cvv validation tests
    
    func testMerchantDelegateIsNotNotifiedWhenCvvComponentWithValidCvvLosesFocus() {
        editCvv(text: "123")
        clearInvocations(merchantDelegate)
        
        removeFocusFromCvv()
        
        verify(merchantDelegate, never()).cvvValidChanged(isValid: true)
    }
    
    func testMerchantDelegateIsNotifiedWhenCvvComponentWithInvalidCvvLosesFocusAndMerchantHasNeverBeenNotified() {
        editCvv(text: "12")
        clearInvocations(merchantDelegate)
        
        removeFocusFromCvv()
        
        verify(merchantDelegate).cvvValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenCvvComponentWithInvalidCvvLosesFocusAndMerchantHasAlreadyBeenNotifiedOfTheInvalidCvv() {
        editCvv(text: "123")
        editCvv(text: "12")
        clearInvocations(merchantDelegate)
        
        removeFocusFromCvv()
        
        verify(merchantDelegate, never()).cvvValidChanged(isValid: false)
    }
    
    private func createConfiguration(brands: [CardBrandModel]) -> CardBrandsConfiguration {
        return CardBrandsConfiguration(brands)
    }
    
    private func editPan(text: String) {
        panView.textField.text = text
        panView.textFieldEditingChanged(panView.textField)
    }
    
    private func editExpiryDate(text: String) {
        expiryDateView.textField.text = text
        expiryDateView.textFieldEditingChanged(expiryDateView.textField)
    }
    
    private func editCvv(text: String) {
        cvvView.textField.text = text
        cvvView.textFieldEditingChanged(cvvView.textField)
    }
    
    private func removeFocusFromPan() {
        panView.textFieldDidEndEditing(panView.textField)
    }
    
    private func removeFocusFromExpiryDate() {
        expiryDateView.textFieldDidEndEditing(expiryDateView.textField)
    }
    
    private func removeFocusFromCvv() {
        cvvView.textFieldDidEndEditing(cvvView.textField)
    }
    
    private func createCardBrand(from cardBrandModel: CardBrandModel) -> CardBrand? {
        var images = [CardBrandImage]()
        
        for imageToConvert in cardBrandModel.images {
            let image = CardBrandImage(type: imageToConvert.type, url: imageToConvert.url)
            images.append(image)
        }
        
        return CardBrand(name: cardBrandModel.name, images: images)
    }
}
