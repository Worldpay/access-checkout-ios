@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanValidationStateHandlerTests: XCTestCase {
    let visaBrand = CardBrandModel(
        name: "visa",
        images: [],
        panValidationRule: ValidationRule(matcher: "^(?!^493698\\d*$)4\\d*$", validLengths: [16, 18, 19]),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    let maestroBrand = CardBrandModel(
        name: "maestro",
        images: [],
        panValidationRule: ValidationRule(
            matcher: "^(493698|(50[0-5][0-9]{2}|506[0-5][0-9]|5066[0-9])|(5067[7-9]|506[89][0-9]|50[78][0-9]{2})|5[6-9]|63|67)\\d*$",
            validLengths: [12, 13, 14, 15, 16, 17, 18, 19]
        ),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    private let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
    
    override func setUp() {
        Cuckoo.stub(merchantDelegate) { stub in
            when(stub).handlePanValidationChange(isValid: any()).thenDoNothing()
            when(stub).handleCardBrandChange(cardBrand: any()).thenDoNothing()
            when(stub).handleExpiryDateValidationChange(isValid: any()).thenDoNothing()
            when(stub).handleCvvValidationChange(isValid: any()).thenDoNothing()
        }
    }
    
    func testShouldNotNotifyMerchantDelegateWhenPanValidationDoesNotChangeFromFalse() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: false)
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: nil)
        
        verify(merchantDelegate, never()).handlePanValidationChange(isValid: any())
    }
    
    func testShouldNotNotifyMerchantDelegateWhenPanValidationDoesNotChangeFromTrue() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: true)
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: nil)
        
        verify(merchantDelegate, never()).handlePanValidationChange(isValid: any())
    }
    
    func testShouldNotifyMerchantDelegateWhenPanValidationChangesToFalse() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: true)
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: nil)
        
        verify(merchantDelegate).handlePanValidationChange(isValid: false)
    }
    
    func testShouldNotifyMerchantDelegateWhenPanValidationChangesToTrue() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: false)
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: nil)
        
        verify(merchantDelegate).handlePanValidationChange(isValid: true)
    }
    
    func testShouldNotifyMerchantDelegateWhenCardBrandChanges() {
        let expectedCardBrand = createCardBrand(from: visaBrand)
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: true,
            cardBrand: nil
        )
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: visaBrand)
        
        verify(merchantDelegate).handleCardBrandChange(cardBrand: expectedCardBrand)
    }
    
    func testShouldNotNotifyMerchantDelegateWhenCardBrandDoesNotChange() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: visaBrand)
        
        verify(merchantDelegate, never()).handleCardBrandChange(cardBrand: any())
    }
    
    func testShouldReturnFalseWhenCardBrandInStateIsSameAsCardBrandInParameter() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        XCTAssertFalse(validationStateHandler.isCardBrandDifferentFrom(cardBrand: visaBrand))
    }
    
    func testShouldReturnTrueWhenCardBrandInStateIsNilAndCardBrandInParameterIsNot() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrand: nil
        )
        
        XCTAssertTrue(validationStateHandler.isCardBrandDifferentFrom(cardBrand: visaBrand))
    }
    
    func testShouldReturnTrueWhenCardBrandInStateIsDifferentFromCardBrandInParameter() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        XCTAssertTrue(validationStateHandler.isCardBrandDifferentFrom(cardBrand: maestroBrand))
    }
    
    func testShouldReturnTrueWhenCardBrandInStateIsNotNilAndCardBrandInParameterIs() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        XCTAssertTrue(validationStateHandler.isCardBrandDifferentFrom(cardBrand: nil))
    }
    
    func testShouldReturnFalseWhenCardBrandRemainsNil() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrand: nil
        )
        
        XCTAssertFalse(validationStateHandler.isCardBrandDifferentFrom(cardBrand: nil))
    }
    
    // MARK: ExpiryDateValidationStateHandler
    
    func testShouldNotNotifyMerchantDelegateWhenExpiryValidationStateDoesNotChangeFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: false
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: false)
        verify(merchantDelegate, never()).handleExpiryDateValidationChange(isValid: any())
    }
    
    func testShouldNotNotifyMerchantDelegateWhenExpiryValidationStateDoesNotChangeFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: true
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: true)
        verify(merchantDelegate, never()).handleExpiryDateValidationChange(isValid: any())
    }
    
    func testShouldNotifyMerchantDelegateWhenExpiryValidationStateChangesFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: false
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: true)
        verify(merchantDelegate).handleExpiryDateValidationChange(isValid: true)
    }
    
    func testShouldNotifyMerchantDelegateWhenExpiryValidationStateChangesFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: true
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: false)
        verify(merchantDelegate).handleExpiryDateValidationChange(isValid: false)
    }
    
    // MARK: CvvValidationStateHandler
    
    func testShouldNotNotifyMerchantDelegateWhenCvvValidationStateDoesNotChangeFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvvValidationState: false
        )
        
        validationStateHandler.handleCvvValidation(isValid: false)
        verify(merchantDelegate, never()).handleCvvValidationChange(isValid: any())
    }
    
    func testShouldNotNotifyMerchantDelegateWhenCvvValidationStateDoesNotChangeFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvvValidationState: true
        )
        
        validationStateHandler.handleCvvValidation(isValid: true)
        verify(merchantDelegate, never()).handleCvvValidationChange(isValid: any())
    }
    
    func testShouldNotifyMerchantDelegateWhenCvvValidationStateChangesFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvvValidationState: false
        )
        
        validationStateHandler.handleCvvValidation(isValid: true)
        verify(merchantDelegate).handleCvvValidationChange(isValid: true)
    }
    
    func testShouldNotifyMerchantDelegateWhenCvvValidationStateChangesFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvvValidationState: true
        )
        
        validationStateHandler.handleCvvValidation(isValid: false)
        verify(merchantDelegate).handleCvvValidationChange(isValid: false)
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
