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
    
    func testShouldNotNotifyMerchantDelegateWhenPanValidationDoesNotChangeFromFalse() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: false)
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: nil)
        
        verify(merchantDelegate, never()).panValidChanged(isValid: any())
    }
    
    func testShouldNotNotifyMerchantDelegateWhenPanValidationDoesNotChangeFromTrue() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: true)
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: nil)
        
        verify(merchantDelegate, never()).panValidChanged(isValid: any())
    }
    
    func testShouldNotifyMerchantDelegateWhenPanValidationChangesToFalse() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: true)
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: nil)
        
        verify(merchantDelegate).panValidChanged(isValid: false)
    }
    
    func testShouldNotifyMerchantDelegateWhenPanValidationChangesToTrue() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: false)
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: nil)
        
        verify(merchantDelegate).panValidChanged(isValid: true)
    }
    
    func testShouldNotifyMerchantDelegateWhenCardBrandChanges() {
        let expectedCardBrand = createCardBrand(from: visaBrand)
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: true,
            cardBrand: nil
        )
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: visaBrand)
        
        verify(merchantDelegate).cardBrandChanged(cardBrand: expectedCardBrand)
    }
    
    func testShouldNotNotifyMerchantDelegateWhenCardBrandDoesNotChange() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: visaBrand)
        
        verify(merchantDelegate, never()).cardBrandChanged(cardBrand: any())
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
    
    func testNotifyMerchantOfPanValidationStateSetsNotificationState() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate)
        
        validationStateHandler.notifyMerchantOfPanValidationState()
        
        XCTAssertTrue(validationStateHandler.alreadyNotifiedMerchantOfPanValidationState)
    }
    
    func testNotifyMerchantOfPanValidationStateNotifiesMerchantOfValidPan() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: true)
        
        validationStateHandler.notifyMerchantOfPanValidationState()
        
        verify(merchantDelegate).panValidChanged(isValid: true)
    }
    
    func testNotifyMerchantOfPanValidationStateNotifiesMerchantOfInvalidPan() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, panValidationState: false)
        
        validationStateHandler.notifyMerchantOfPanValidationState()
        
        verify(merchantDelegate).panValidChanged(isValid: false)
    }
    
    // MARK: ExpiryDateValidationStateHandler
    
    func testShouldNotNotifyMerchantDelegateWhenExpiryValidationStateDoesNotChangeFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: false
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: false)
        verify(merchantDelegate, never()).expiryDateValidChanged(isValid: any())
    }
    
    func testShouldNotNotifyMerchantDelegateWhenExpiryValidationStateDoesNotChangeFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: true
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: true)
        verify(merchantDelegate, never()).expiryDateValidChanged(isValid: any())
    }
    
    func testShouldNotifyMerchantDelegateWhenExpiryValidationStateChangesFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: false
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: true)
        verify(merchantDelegate).expiryDateValidChanged(isValid: true)
    }
    
    func testShouldNotifyMerchantDelegateWhenExpiryValidationStateChangesFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: true
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: false)
        verify(merchantDelegate).expiryDateValidChanged(isValid: false)
    }
    
    func testNotifyMerchantOfExpiryDateValidationStateSetsNotificationState() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate)
        
        validationStateHandler.notifyMerchantOfExpiryDateValidationState()
        
        XCTAssertTrue(validationStateHandler.alreadyNotifiedMerchantOfExpiryDateValidationState)
    }
    
    func testNotifyMerchantOfExpiryDateValidationStateNotifiesMerchantOfValidExpiryDate() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, expiryDateValidationState: true)
        
        validationStateHandler.notifyMerchantOfExpiryDateValidationState()
        
        verify(merchantDelegate).expiryDateValidChanged(isValid: true)
    }
    
    func testNotifyMerchantOfExpiryDateValidationStateNotifiesMerchantOfInvalidExpiryDate() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, expiryDateValidationState: false)
        
        validationStateHandler.notifyMerchantOfExpiryDateValidationState()
        
        verify(merchantDelegate).expiryDateValidChanged(isValid: false)
    }
    
    // MARK: CvcValidationStateHandler
    
    func testShouldNotNotifyMerchantDelegateWhenCvcValidationStateDoesNotChangeFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvcValidationState: false
        )
        
        validationStateHandler.handleCvcValidation(isValid: false)
        verify(merchantDelegate, never()).cvcValidChanged(isValid: any())
    }
    
    func testShouldNotNotifyMerchantDelegateWhenCvcValidationStateDoesNotChangeFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvcValidationState: true
        )
        
        validationStateHandler.handleCvcValidation(isValid: true)
        verify(merchantDelegate, never()).cvcValidChanged(isValid: any())
    }
    
    func testShouldNotifyMerchantDelegateWhenCvcValidationStateChangesFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvcValidationState: false
        )
        
        validationStateHandler.handleCvcValidation(isValid: true)
        verify(merchantDelegate).cvcValidChanged(isValid: true)
    }
    
    func testShouldNotifyMerchantDelegateWhenCvcValidationStateChangesFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvcValidationState: true
        )
        
        validationStateHandler.handleCvcValidation(isValid: false)
        verify(merchantDelegate).cvcValidChanged(isValid: false)
    }
    
    func testNotifyMerchantOfCvcValidationStateSetsNotificationState() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate)
        
        validationStateHandler.notifyMerchantOfCvcValidationState()
        
        XCTAssertTrue(validationStateHandler.alreadyNotifiedMerchantOfCvcValidationState)
    }
    
    func testNotifyMerchantOfCvcValidationStateNotifiesMerchantOfValidCvc() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate: merchantDelegate, cvcValidationState: true)
        
        validationStateHandler.notifyMerchantOfCvcValidationState()
        
        verify(merchantDelegate).cvcValidChanged(isValid: true)
    }
    
    func testNotifyMerchantOfCvcValidationStateNotifiesMerchantOfInvalidCvc() {
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
