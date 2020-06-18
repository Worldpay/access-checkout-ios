@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class AccessCheckoutCardValidationDelegate_EditingEvent_Tests: XCTestCase {
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
    
    private let visaPan1 = "4111111111111111"
    private let visaPan2 = "4563648800001000"
    private let masterCardPan = "5500000000000004"
    
    override func setUp() {
        validationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
        
        merchantDelegate.getStubbingProxy().panValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cvvValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().expiryDateValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cardBrandChanged(cardBrand: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()
    }
    
    // MARK: PAN validation tests
    
    func testMerchantDelegateIsNotifiedWhenPANBecomesValid() {
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editPan(text: visaPan1)
        
        verify(merchantDelegate, times(1)).panValidChanged(isValid: true)
    }
    
    func testMerchantDelegateIsNotifiedWhenPANBecomesInvalid() {
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editPan(text: visaPan1)
        editPan(text: "123")
        
        verify(merchantDelegate, times(1)).panValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotifiedOnlyOnceWhenSubsequentValidPANsAreEntered() {
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editPan(text: visaPan1)
        editPan(text: visaPan2)
        
        verify(merchantDelegate, times(1)).panValidChanged(isValid: true)
    }
    
    // MARK: Card brand changes
    
    func testMerchantDelegateIsNotifiedWhenCardBrandChanges() {
        let expectedCardBrand = createCardBrand(from: visaBrand)
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editPan(text: "4")
        
        verify(merchantDelegate, times(1)).cardBrandChanged(cardBrand: expectedCardBrand)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenPanChangesButBrandRemainsTheSame() {
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editPan(text: "4")
        editPan(text: "49")
        
        verify(merchantDelegate, times(1)).cardBrandChanged(cardBrand: any())
    }
    
    func testMerchantDelegateIsNotifiedOfAVisaToMaestroCardBrandChange() {
        let expectedVisaCardBrand = createCardBrand(from: visaBrand)
        let expectedMaestroCardBrand = createCardBrand(from: maestroBrand)
        
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editPan(text: "49369")
        verify(merchantDelegate, times(1)).cardBrandChanged(cardBrand: expectedVisaCardBrand)
        
        editPan(text: "493698")
        verify(merchantDelegate, times(1)).cardBrandChanged(cardBrand: expectedMaestroCardBrand)
    }
    
    // MARK: Expiry Date validation tests
    
    func testMerchantDelegateIsNotifiedWhenExpiryDateBecomesValid() {
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editExpiryDate(text: "11/32")
        
        verify(merchantDelegate, times(1)).expiryDateValidChanged(isValid: true)
    }
    
    func testMerchantDelegateIsNotifiedWhenExpiryDateBecomesInvalid() {
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editExpiryDate(text: "11/32")
        editExpiryDate(text: "11/3")
        
        verify(merchantDelegate, times(1)).expiryDateValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotifiedOnlyOnceWhenSubsequentValidExpiryDatesAreEntered() {
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editExpiryDate(text: "11/32")
        editExpiryDate(text: "11/33")
        
        verify(merchantDelegate, times(1)).expiryDateValidChanged(isValid: true)
    }
    
    // MARK: Cvv validation tests
    
    func testMerchantDelegateIsNotifiedWhenCvcBecomesValid() {
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editCvv(text: "123")
        
        verify(merchantDelegate, times(1)).cvvValidChanged(isValid: true)
    }
    
    func testMerchantDelegateIsNotifiedWhenCvcBecomesInvalid() {
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editCvv(text: "123")
        editCvv(text: "12")
        
        verify(merchantDelegate, times(1)).cvvValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotifiedOnlyOnceWhenSubsequentValidCvvsAreEntered() {
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editCvv(text: "456")
        editCvv(text: "123")
        
        verify(merchantDelegate, times(1)).cvvValidChanged(isValid: true)
    }
    
    func testMerchantDelegateIsNotifiedOfAnInvalidCvvWhenThePanIsChangedAndRequiresACvvOfADifferentLength() {
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, amexBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editPan(text: "456")
        editCvv(text: "123")
        verify(merchantDelegate, times(1)).cvvValidChanged(isValid: true)
        
        editPan(text: "345")
        verify(merchantDelegate, times(1)).cvvValidChanged(isValid: false)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenThePanIsChangedAndRequiresACvvOfTheSameLength() {
        let expectedVisaCardBrand = createCardBrand(from: visaBrand)
        let expectedMaestroCardBrand = createCardBrand(from: maestroBrand)
        
        let cardBrandsConfiguration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editPan(text: "49369")
        editCvv(text: "123")
        verify(merchantDelegate, times(1)).cardBrandChanged(cardBrand: expectedVisaCardBrand)
        
        editPan(text: "493698")
        verify(merchantDelegate, times(1)).cardBrandChanged(cardBrand: expectedMaestroCardBrand)
        
        verify(merchantDelegate, times(1)).cvvValidChanged(isValid: true)
    }
    
    // MARK: validation success tests
    
    func testMerchantIsNotifiedOfValidationSuccess() {
        let cardBrandsConfiguration = createConfiguration(brands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editPan(text: "4111111111111111")
        editCvv(text: "123")
        editExpiryDate(text: "12/35")
        
        verify(merchantDelegate, times(1)).validationSuccess()
    }
    
    func testMerchantIsNotNotifiedOfValidationSuccessWhenPanIsNotValid() {
        let cardBrandsConfiguration = createConfiguration(brands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editPan(text: "4111")
        editCvv(text: "123")
        editExpiryDate(text: "12/35")
        
        verify(merchantDelegate, never()).validationSuccess()
    }
    
    func testMerchantIsNotNotifiedOfValidationSuccessWhenExpiryDateIsNotValid() {
        let cardBrandsConfiguration = createConfiguration(brands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editPan(text: "4111111111111111")
        editCvv(text: "123")
        editExpiryDate(text: "12/19")
        
        verify(merchantDelegate, never()).validationSuccess()
    }
    
    func testMerchantIsNotNotifiedOfValidationSuccessWhenCvvIsNotValid() {
        let cardBrandsConfiguration = createConfiguration(brands: [])
        configurationProvider.getStubbingProxy().get().thenReturn(cardBrandsConfiguration)
        
        let validationConfiguration = CardValidationConfig(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                                           accessBaseUrl: baseUrl, validationDelegate: merchantDelegate)
        validationInitialiser!.initialise(validationConfiguration)
        
        editPan(text: "4111111111111111")
        editCvv(text: "12")
        editExpiryDate(text: "12/35")
        
        verify(merchantDelegate, never()).validationSuccess()
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
    
    private func createCardBrand(from cardBrandModel: CardBrandModel) -> CardBrandClient? {
        var images = [CardBrandImageClient]()
        
        for imageToConvert in cardBrandModel.images {
            let image = CardBrandImageClient(type: imageToConvert.type, url: imageToConvert.url)
            images.append(image)
        }
        
        return CardBrandClient(name: cardBrandModel.name, images: images)
    }
}
