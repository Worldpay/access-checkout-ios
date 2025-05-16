@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CardValidationStateHandlerTests: XCTestCase {
    let visaBrand = CardBrandModel(
        name: "visa",
        images: [],
        panValidationRule: ValidationRule(matcher: "^(?!^493698\\d*$)4\\d*$", validLengths: [16, 18, 19]),
        cvcValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    let maestroBrand = CardBrandModel(
        name: "maestro",
        images: [],
        panValidationRule: ValidationRule(
            matcher: "^(493698|(50[0-5][0-9]{2}|506[0-5][0-9]|5066[0-9])|(5067[7-9]|506[89][0-9]|50[78][0-9]{2})|5[6-9]|63|67)\\d*$",
            validLengths: [12, 13, 14, 15, 16, 17, 18, 19]
        ),
        cvcValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    private let merchantDelegate = MockAccessCheckoutCardValidationDelegate()
    
    override func setUp() {
        merchantDelegate.getStubbingProxy().panValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cardBrandChanged(cardBrand: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().expiryDateValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()
    }
    
    // MARK: PanValidationStateHandler
    
    func testHandlePanValidation_shouldNotNotifyMerchantDelegateWhenPanValidationDoesNotChangeFromFalse() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: false)
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: nil)
        
        verify(merchantDelegate, never()).panValidChanged(isValid: any())
    }
    
    func testHandlePanValidation_shouldNotNotifyMerchantDelegateWhenPanValidationDoesNotChangeFromTrue() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: true)
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: nil)
        
        verify(merchantDelegate, never()).panValidChanged(isValid: any())
    }
    
    func testHandlePanValidation_shouldNotifyMerchantDelegateWhenPanValidationChangesToFalse() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: true)
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: nil)
        
        verify(merchantDelegate).panValidChanged(isValid: false)
    }
    
    func testHandlePanValidation_shouldNotifyMerchantDelegateWhenPanValidationChangesToTrue() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: false)
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: nil)
        
        verify(merchantDelegate).panValidChanged(isValid: true)
    }
    
    func testHandlePanValidation_shouldNotifyMerchantDelegateWhenCardBrandChanges() {
        let expectedCardBrand = createCardBrand(from: visaBrand)
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: true,
            cardBrand: nil
        )
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: visaBrand)
        
        verify(merchantDelegate).cardBrandChanged(cardBrand: expectedCardBrand)
    }
    
    func testHandlePanValidation_shouldNotNotifyMerchantDelegateWhenCardBrandDoesNotChange() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: visaBrand)
        
        verify(merchantDelegate, never()).cardBrandChanged(cardBrand: any())
    }
    
    func testIsCardBrandDifferentFrom_shouldReturnFalseWhenCardBrandInStateIsSameAsCardBrandInParameter() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        XCTAssertFalse(validationStateHandler.isCardBrandDifferentFrom(cardBrand: visaBrand))
    }
    
    func testIsCardBrandDifferentFrom_shouldReturnTrueWhenCardBrandInStateIsNilAndCardBrandInParameterIsNot() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrand: nil
        )
        
        XCTAssertTrue(validationStateHandler.isCardBrandDifferentFrom(cardBrand: visaBrand))
    }
    
    func testIsCardBrandDifferentFrom_shouldReturnTrueWhenCardBrandInStateIsDifferentFromCardBrandInParameter() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        XCTAssertTrue(validationStateHandler.isCardBrandDifferentFrom(cardBrand: maestroBrand))
    }
    
    func testIsCardBrandDifferentFrom_shouldReturnTrueWhenCardBrandInStateIsNotNilAndCardBrandInParameterIs() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        XCTAssertTrue(validationStateHandler.isCardBrandDifferentFrom(cardBrand: nil))
    }
    
    func testIsCardBrandDifferentFrom_shouldReturnFalseWhenCardBrandRemainsNil() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrand: nil
        )
        
        XCTAssertFalse(validationStateHandler.isCardBrandDifferentFrom(cardBrand: nil))
    }
    
    func testNotifyMerchantOfPanValidationState_notifiesMerchantOfValidPan() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: true)
        
        validationStateHandler.notifyMerchantOfPanValidationState()
        
        verify(merchantDelegate).panValidChanged(isValid: true)
    }
    
    func testNotifyMerchantOfPanValidationState_notifiesMerchantOfValidPanOnlyOnceWhenCalledMultipleTimes() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: true)
        
        validationStateHandler.notifyMerchantOfPanValidationState()
        validationStateHandler.notifyMerchantOfPanValidationState()
        
        verify(merchantDelegate, times(1)).panValidChanged(isValid: true)
    }
    
    func testNotifyMerchantOfPanValidationState_notifiesMerchantOfInvalidPan() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: false)
        
        validationStateHandler.notifyMerchantOfPanValidationState()
        
        verify(merchantDelegate).panValidChanged(isValid: false)
    }
    
    func testNotifyMerchantOfPanValidationState_notifiesMerchantOfInvalidPanOnlyOnceWhenCalledMultipleTimes() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: false)
        
        validationStateHandler.notifyMerchantOfPanValidationState()
        validationStateHandler.notifyMerchantOfPanValidationState()
        
        verify(merchantDelegate, times(1)).panValidChanged(isValid: false)
    }
    
    
    func testGetCardBrand_shouldReturnCardBrandIfKnownBrand() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: false, cardBrand: visaBrand)
        
        XCTAssertEqual(validationStateHandler.getCardBrand(), visaBrand)
    }
    
    func testGetCardBrand_shouldReturnNilCardBrandIfUnknownBrand() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: false, cardBrand: nil)
        
        XCTAssertEqual(validationStateHandler.getCardBrand(), nil)
    }
    
    // MARK: ExpiryDateValidationStateHandler
    
    func testHandleExpiryDateValidation_shouldNotNotifyMerchantDelegateWhenExpiryValidationStateDoesNotChangeFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: false
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: false)
        verify(merchantDelegate, never()).expiryDateValidChanged(isValid: any())
    }
    
    func testHandleExpiryDateValidation_shouldNotNotifyMerchantDelegateWhenExpiryValidationStateDoesNotChangeFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: true
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: true)
        verify(merchantDelegate, never()).expiryDateValidChanged(isValid: any())
    }
    
    func testHandleExpiryDateValidation_shouldNotifyMerchantDelegateWhenExpiryValidationStateChangesFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: false
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: true)
        verify(merchantDelegate).expiryDateValidChanged(isValid: true)
    }
    
    func testHandleExpiryDateValidation_shouldNotifyMerchantDelegateWhenExpiryValidationStateChangesFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: true
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: false)
        verify(merchantDelegate).expiryDateValidChanged(isValid: false)
    }
    
    func testNotifyMerchantOfExpiryDateValidationState_notifiesMerchantOfValidExpiryDate() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, expiryDateValidationState: true)
        
        validationStateHandler.notifyMerchantOfExpiryDateValidationState()
        
        verify(merchantDelegate).expiryDateValidChanged(isValid: true)
    }
    
    func testNotifyMerchantOfExpiryDateValidationState_notifiesMerchantOfInvalidExpiryDate() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, expiryDateValidationState: false)
        
        validationStateHandler.notifyMerchantOfExpiryDateValidationState()
        
        verify(merchantDelegate).expiryDateValidChanged(isValid: false)
    }
    
    // MARK: CvcValidationStateHandler
    
    func testHandleCvcValidation_shouldNotNotifyMerchantDelegateWhenCvcValidationStateDoesNotChangeFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvcValidationState: false
        )
        
        validationStateHandler.handleCvcValidation(isValid: false)
        verify(merchantDelegate, never()).cvcValidChanged(isValid: any())
    }
    
    func testHandleCvcValidation_shouldNotNotifyMerchantDelegateWhenCvcValidationStateDoesNotChangeFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvcValidationState: true
        )
        
        validationStateHandler.handleCvcValidation(isValid: true)
        verify(merchantDelegate, never()).cvcValidChanged(isValid: any())
    }
    
    func testHandleCvcValidation_shouldNotifyMerchantDelegateWhenCvcValidationStateChangesFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvcValidationState: false
        )
        
        validationStateHandler.handleCvcValidation(isValid: true)
        verify(merchantDelegate).cvcValidChanged(isValid: true)
    }
    
    func testHandleCvcValidation_shouldNotifyMerchantDelegateWhenCvcValidationStateChangesFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvcValidationState: true
        )
        
        validationStateHandler.handleCvcValidation(isValid: false)
        verify(merchantDelegate).cvcValidChanged(isValid: false)
    }
    
    func testNotifyMerchantOfCvcValidationState_notifiesMerchantOfValidCvc() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, cvcValidationState: true)
        
        validationStateHandler.notifyMerchantOfCvcValidationState()
        
        verify(merchantDelegate).cvcValidChanged(isValid: true)
    }
    
    func testNotifyMerchantOfCvcValidationState_notifiesMerchantOfInvalidCvc() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, cvcValidationState: false)
        
        validationStateHandler.notifyMerchantOfCvcValidationState()
        
        verify(merchantDelegate).cvcValidChanged(isValid: false)
    }
    
    // MARK: Tests for notification that all fields are valid
    
    func testShouldNotifyMerchantDelegateWhenAllFieldsAreValid() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate)
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: nil)
        validationStateHandler.handleExpiryDateValidation(isValid: true)
        validationStateHandler.handleCvcValidation(isValid: true)
        
        verify(merchantDelegate).validationSuccess()
    }
    
    func testShouldNotifyMerchantDelegateOnlyOnceWhenAllFieldsAreValidAFieldIsChangedToAnotherValidValue() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate)
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: nil)
        validationStateHandler.handleExpiryDateValidation(isValid: true)
        validationStateHandler.handleCvcValidation(isValid: true)
        validationStateHandler.handleCvcValidation(isValid: true)
        
        verify(merchantDelegate, times(1)).validationSuccess()
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
