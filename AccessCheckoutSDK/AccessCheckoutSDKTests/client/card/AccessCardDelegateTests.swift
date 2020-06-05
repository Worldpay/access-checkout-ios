@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class AccessCardDelegate_CardPaymentFlow_Tests: XCTestCase {
    private let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    private var validationInitialiser: AccessCheckoutValidationInitialiser?
    private let panView = PANView()
    private let expiryDateView = ExpiryDateView()
    private let cvvView = CVVView()
    private let baseUrl = "a-url"
    private let merchantDelegate = MockAccessCardDelegate()
    
    private let visaBrand = CardBrandModel(
        name: "visa",
        images: [],
        panValidationRule: ValidationRule(matcher: "^(?!^493698\\d*$)4\\d*$", validLengths: [16, 18, 19]),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    private let maestroBrand = CardBrandModel(
        name: "maestro",
        images: [],
        panValidationRule: ValidationRule(
            matcher: "^(493698|(50[0-5][0-9]{2}|506[0-5][0-9]|5066[0-9])|(5067[7-9]|506[89][0-9]|50[78][0-9]{2})|5[6-9]|63|67)\\d*$",
            validLengths: [12, 13, 14, 15, 16, 17, 18, 19]
        ),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    private let amexBrand = CardBrandModel(
        name: "amex",
        images: [],
        panValidationRule: ValidationRule(
            matcher: "^3[47]\\d*$",
            validLengths: [15]
        ),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [4])
    )
    
    private let visaPan1 = "4111111111111111"
    private let visaPan2 = "4563648800001000"
    private let masterCardPan = "5500000000000004"
    
    override func setUp() {
        validationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
        
        merchantDelegate.getStubbingProxy().handlePanValidationChange(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().handleCvvValidationChange(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().handleExpiryDateValidationChange(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().handleCardBrandChange(cardBrand: any()).thenDoNothing()
    }
    
    // MARK: PAN validation tests
    
    func testMerchantDelegateIsNotifiedOfPANValidationStateChange() {
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: merchantDelegate)
        
        editPan(text: visaPan1)
        
        verify(merchantDelegate, times(1)).handlePanValidationChange(isValid: true)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenPanChangesButValidationStateDoesNotChange() {
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: merchantDelegate)
        
        editPan(text: visaPan1)
        editPan(text: visaPan2)
        
        verify(merchantDelegate, times(1)).handlePanValidationChange(isValid: true)
    }
    
    func testMerchantDelegateIsNotifiedOfACardBrandChange() {
        let expectedCardBrand = createCardBrand(from: visaBrand)
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: merchantDelegate)
        
        editPan(text: "4")
        
        verify(merchantDelegate, times(1)).handleCardBrandChange(cardBrand: expectedCardBrand)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenPanChangesButBrandRemainsTheSame() {
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: merchantDelegate)
        
        editPan(text: "4")
        editPan(text: "49")
        
        verify(merchantDelegate, times(1)).handleCardBrandChange(cardBrand: any())
    }
    
    func testMerchantDelegateIsNotifiedOfAVisaToMaestroCardBrandChange() {
        let expectedVisaCardBrand = createCardBrand(from: visaBrand)
        let expectedMaestroCardBrand = createCardBrand(from: maestroBrand)
        
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: merchantDelegate)
        
        editPan(text: "49369")
        verify(merchantDelegate, times(1)).handleCardBrandChange(cardBrand: expectedVisaCardBrand)
        
        editPan(text: "493698")
        verify(merchantDelegate, times(1)).handleCardBrandChange(cardBrand: expectedMaestroCardBrand)
    }
    
    // MARK: Expiry Date validation tests
    
    func testMerchantDelegateIsNotifiedOfExpiryDateValidationStateChange() {
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: merchantDelegate)
        
        editExpiryDate(month: "11", year: "32")
        
        verify(merchantDelegate, times(1)).handleExpiryDateValidationChange(isValid: true)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenExpiryDateChangesButValidationStateDoesNotChange() {
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: merchantDelegate)
        
        editExpiryDate(month: "11", year: "32")
        editExpiryDate(month: "11", year: "33")
        
        verify(merchantDelegate, times(1)).handleExpiryDateValidationChange(isValid: true)
    }
    
    // MARK: Cvv validation tests
    
    func testMerchantDelegateIsNotifiedOfCvvValidationStateChanges() {
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: merchantDelegate)
        
        editCvv(text: "123")
        
        verify(merchantDelegate, times(1)).handleCvvValidationChange(isValid: true)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenCvvChangesButValidationStatesDoesNotChange() {
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: merchantDelegate)
        
        editCvv(text: "456")
        editCvv(text: "123")
        
        verify(merchantDelegate, times(1)).handleCvvValidationChange(isValid: true)
    }
    
    func testMerchantDelegateIsNotifiedOfAnInvalidCvvWhenThePanIsChangedAndRequiresACvvOfADifferentLength() {
        let configuration = createConfiguration(brands: [visaBrand, amexBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: merchantDelegate)
        
        editPan(text: "456")
        editCvv(text: "123")
        verify(merchantDelegate, times(1)).handleCvvValidationChange(isValid: true)
        
        editPan(text: "345")
        verify(merchantDelegate, times(1)).handleCvvValidationChange(isValid: false)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenThePanIsChangedAndRequiresACvvOfTheSameLength() {
        let expectedVisaCardBrand = createCardBrand(from: visaBrand)
        let expectedMaestroCardBrand = createCardBrand(from: maestroBrand)
        
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: merchantDelegate)
        
        editPan(text: "49369")
        editCvv(text: "123")
        verify(merchantDelegate, times(1)).handleCardBrandChange(cardBrand: expectedVisaCardBrand)
        
        editPan(text: "493698")
        verify(merchantDelegate, times(1)).handleCardBrandChange(cardBrand: expectedMaestroCardBrand)
        
        verify(merchantDelegate, times(1)).handleCvvValidationChange(isValid: true)
    }
    
    private func createConfiguration(brands: [CardBrandModel]) -> CardBrandsConfiguration {
        return CardBrandsConfiguration(brands, ValidationRulesDefaults.instance())
    }
    
    private func editPan(text: String) {
        panView.textField.text = text
        panView.textFieldEditingChanged(panView.textField)
    }
    
    private func editExpiryDate(month: String, year: String) {
        expiryDateView.monthTextField.text = month
        expiryDateView.textFieldEditingChanged(expiryDateView.monthTextField)
        
        expiryDateView.yearTextField.text = year
        expiryDateView.textFieldEditingChanged(expiryDateView.yearTextField)
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

// TODO: put in a separate file with a different name since we're testing a different delegate
class AccessCardDelegate_CvvOnlyFlow_Tests: XCTestCase {
    private let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    private var validationInitialiser: AccessCheckoutValidationInitialiser?
    private let cvvView = CVVView()
    private let merchantDelegate = MockAccessCvvOnlyDelegate()
    private let configuration = CardBrandsConfiguration([], ValidationRulesDefaults.instance())
    
    override func setUp() {
        validationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        
        merchantDelegate.getStubbingProxy().handleCvvValidationChange(isValid: any()).thenDoNothing()
    }
    
    func testMerchantDelegateIsNotifiedOfCvvValidationStateChanges() {
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(cvvView: cvvView, cvvOnlyDelegate: merchantDelegate)
        
        editCvv(text: "123")
        
        verify(merchantDelegate, times(1)).handleCvvValidationChange(isValid: true)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenCvvChangesButValidationStatesDoesNotChange() {
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(cvvView: cvvView, cvvOnlyDelegate: merchantDelegate)
        
        editCvv(text: "456")
        editCvv(text: "123")
        
        verify(merchantDelegate, times(1)).handleCvvValidationChange(isValid: true)
    }
    
    private func editCvv(text: String) {
        cvvView.textField.text = text
        cvvView.textFieldEditingChanged(cvvView.textField)
    }
}
