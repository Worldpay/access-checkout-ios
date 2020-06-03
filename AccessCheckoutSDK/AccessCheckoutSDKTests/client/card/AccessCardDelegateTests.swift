@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class AccessCardDelegateTests: XCTestCase {
    private let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    private var validationInitialiser: AccessCheckoutValidationInitialiser?
    private let panView = PANView()
    private let expiryDateView = ExpiryDateView()
    private let cvvView = CVVView()
    private let baseUrl = "a-url"
    private let cardDelegate = MockAccessCardDelegate()
    
    private let visaBrand = CardBrand2(
        name: "visa",
        images: [],
        panValidationRule: ValidationRule(matcher: "^(?!^493698\\d*$)4\\d*$", validLengths: [16, 18, 19]),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    private let maestroBrand = CardBrand2(
        name: "maestro",
        images: [],
        panValidationRule: ValidationRule(
            matcher: "^(493698|(50[0-5][0-9]{2}|506[0-5][0-9]|5066[0-9])|(5067[7-9]|506[89][0-9]|50[78][0-9]{2})|5[6-9]|63|67)\\d*$",
            validLengths: [12, 13, 14, 15, 16, 17, 18, 19]
        ),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    private let visaPan1 = "4111111111111111"
    private let visaPan2 = "4563648800001000"
    private let masterCardPan = "5500000000000004"
    
    override func setUp() {
        validationInitialiser = AccessCheckoutValidationInitialiser(configurationProvider)
        
        configurationProvider.getStubbingProxy().retrieveRemoteConfiguration(baseUrl: any()).thenDoNothing()
        
        cardDelegate.getStubbingProxy().handlePanValidationChange(isValid: any()).thenDoNothing()
        cardDelegate.getStubbingProxy().handleCvvValidationChange(isValid: any()).thenDoNothing()
        cardDelegate.getStubbingProxy().handleExpiryDateValidationChange(isValid: any()).thenDoNothing()
        cardDelegate.getStubbingProxy().handleCardBrandChange(cardBrand: any()).thenDoNothing()
    }
    
    // MARK: PAN validation tests
    func testMerchantDelegateIsNotifiedOfAPANValidationStateChange() {
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: cardDelegate)
        
        editPan(text: visaPan1)
        
        verify(cardDelegate, times(1)).handlePanValidationChange(isValid: true)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenPanChangesButValidationStateDoesNotChange() {
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: cardDelegate)
        
        editPan(text: visaPan1)
        editPan(text: visaPan2)
        
        verify(cardDelegate, times(1)).handlePanValidationChange(isValid: true)
    }
    
    func testMerchantDelegateIsNotifiedOfACardBrandChange() {
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: cardDelegate)
        
        editPan(text: "4")
        
        verify(cardDelegate, times(1)).handleCardBrandChange(cardBrand: visaBrand)
    }
    
    func testMerchantDelegateIsNotNotifiedWhenPanChangesButBrandRemainsTheSame() {
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: cardDelegate)
        
        editPan(text: "4")
        editPan(text: "49")
        
        verify(cardDelegate, times(1)).handleCardBrandChange(cardBrand: any())
    }
    
    func testMerchantDelegateIsNotifiedOfAVisaToMaestroCardBrandChange() {
        let configuration = createConfiguration(brands: [visaBrand, maestroBrand])
        configurationProvider.getStubbingProxy().get().thenReturn(configuration)
        validationInitialiser!.initialise(panView: panView, expiryDateView: expiryDateView, cvvView: cvvView,
                                          baseUrl: baseUrl, cardDelegate: cardDelegate)
        
        editPan(text: "49369")
        verify(cardDelegate, times(1)).handleCardBrandChange(cardBrand: visaBrand)
        
        editPan(text: "493698")
        verify(cardDelegate, times(1)).handleCardBrandChange(cardBrand: maestroBrand)
    }
    
    private func createConfiguration(brands: [CardBrand2]) -> CardBrandsConfiguration {
        return CardBrandsConfiguration(brands, ValidationRulesDefaults.instance())
    }
    
    private func editPan(text: String) {
        panView.textField.text = text
        panView.textFieldDidEditingChanged(panView.textField)
    }
}
