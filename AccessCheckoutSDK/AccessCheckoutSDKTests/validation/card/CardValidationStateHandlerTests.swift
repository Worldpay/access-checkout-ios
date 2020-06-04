@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanValidationStateHandlerTests: XCTestCase {
    let visaBrand = CardBrand2(
        name: "visa",
        images: [],
        panValidationRule: ValidationRule(matcher: "^(?!^493698\\d*$)4\\d*$", validLengths: [16, 18, 19]),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )

    let maestroBrand = CardBrand2(
        name: "maestro",
        images: [],
        panValidationRule: ValidationRule(
            matcher: "^(493698|(50[0-5][0-9]{2}|506[0-5][0-9]|5066[0-9])|(5067[7-9]|506[89][0-9]|50[78][0-9]{2})|5[6-9]|63|67)\\d*$",
            validLengths: [12, 13, 14, 15, 16, 17, 18, 19]
        ),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    private let accessCardDelegate = MockAccessCardDelegate()
    
    override func setUp() {
        Cuckoo.stub(accessCardDelegate) { stub in
            when(stub).handlePanValidationChange(isValid: any()).thenDoNothing()
            when(stub).handleCardBrandChange(cardBrand: any()).thenDoNothing()
            when(stub).handleExpiryDateValidationChange(isValid: any()).thenDoNothing()
            when(stub).handleCvvValidationChange(isValid: any()).thenDoNothing()
        }
    }
    
    func testShouldNotNotifyMerchantDelegateWhenPanValidationDoesNotChangeFromFalse() {
        let validationStateHandler = CardValidationStateHandler(accessCardDelegate: accessCardDelegate, panValidationState: false)
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: nil)
        
        verify(accessCardDelegate, never()).handlePanValidationChange(isValid: any())
    }
    
    func testShouldNotNotifyMerchantDelegateWhenPanValidationDoesNotChangeFromTrue() {
        let validationStateHandler = CardValidationStateHandler(accessCardDelegate: accessCardDelegate, panValidationState: true)
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: nil)
        
        verify(accessCardDelegate, never()).handlePanValidationChange(isValid: any())
    }
    
    func testShouldNotifyMerchantDelegateWhenPanValidationChangesToFalse() {
        let validationStateHandler = CardValidationStateHandler(accessCardDelegate: accessCardDelegate, panValidationState: true)
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: nil)
        
        verify(accessCardDelegate).handlePanValidationChange(isValid: false)
    }
    
    func testShouldNotifyMerchantDelegateWhenPanValidationChangesToTrue() {
        let validationStateHandler = CardValidationStateHandler(accessCardDelegate: accessCardDelegate, panValidationState: false)
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: nil)
        
        verify(accessCardDelegate).handlePanValidationChange(isValid: true)
    }
    
    func testShouldNotifyMerchantDelegateWhenCardBrandChanges() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: true,
            cardBrand: nil
        )
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: visaBrand)
        
        verify(accessCardDelegate).handleCardBrandChange(cardBrand: visaBrand)
    }
    
    func testShouldNotNotifyMerchantDelegateWhenCardBrandDoesNotChange() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: visaBrand)
        
        verify(accessCardDelegate, never()).handleCardBrandChange(cardBrand: any())
    }
    
    func testShouldReturnFalseWhenCardBrandInStateIsSameAsCardBrandInParameter() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        XCTAssertFalse(validationStateHandler.isCardBrandDifferentFrom(cardBrand: visaBrand))
    }
    
    func testShouldReturnTrueWhenCardBrandInStateIsNilAndCardBrandInParameterIsNot() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: false,
            cardBrand: nil
        )
        
        XCTAssertTrue(validationStateHandler.isCardBrandDifferentFrom(cardBrand: visaBrand))
    }
    
    func testShouldReturnTrueWhenCardBrandInStateIsDifferentFromCardBrandInParameter() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        XCTAssertTrue(validationStateHandler.isCardBrandDifferentFrom(cardBrand: maestroBrand))
    }
    
    func testShouldReturnTrueWhenCardBrandInStateIsNotNilAndCardBrandInParameterIs() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        XCTAssertTrue(validationStateHandler.isCardBrandDifferentFrom(cardBrand: nil))
    }
    
    func testShouldReturnFalseWhenCardBrandRemainsNil() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: false,
            cardBrand: nil
        )
        
        XCTAssertFalse(validationStateHandler.isCardBrandDifferentFrom(cardBrand: nil))
    }

    // MARK: ExpiryDateValidationStateHandler
    
    func testShouldNotNotifyMerchantDelegateWhenExpiryValidationStateDoesNotChangeFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            expiryDateValidationState: false
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: false)
        verify(accessCardDelegate, never()).handleExpiryDateValidationChange(isValid: any())
    }
    
    func testShouldNotNotifyMerchantDelegateWhenExpiryValidationStateDoesNotChangeFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            expiryDateValidationState: true
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: true)
        verify(accessCardDelegate, never()).handleExpiryDateValidationChange(isValid: any())
    }
    
    func testShouldNotifyMerchantDelegateWhenExpiryValidationStateChangesFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            expiryDateValidationState: false
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: true)
        verify(accessCardDelegate).handleExpiryDateValidationChange(isValid: true)
    }
    
    func testShouldNotifyMerchantDelegateWhenExpiryValidationStateChangesFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            expiryDateValidationState: true
        )
        
        validationStateHandler.handleExpiryDateValidation(isValid: false)
        verify(accessCardDelegate).handleExpiryDateValidationChange(isValid: false)
    }
    
    // MARK: CvvValidationStateHandler

    func testShouldNotNotifyMerchantDelegateWhenCvvValidationStateDoesNotChangeFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            cvvValidationState: false
        )
        
        validationStateHandler.handleCvvValidation(isValid: false)
        verify(accessCardDelegate, never()).handleCvvValidationChange(isValid: any())
    }
    
    func testShouldNotNotifyMerchantDelegateWhenCvvValidationStateDoesNotChangeFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            cvvValidationState: true
        )
        
        validationStateHandler.handleCvvValidation(isValid: true)
        verify(accessCardDelegate, never()).handleCvvValidationChange(isValid: any())
    }
    
    func testShouldNotifyMerchantDelegateWhenCvvValidationStateChangesFromFalse() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            cvvValidationState: false
        )
        
        validationStateHandler.handleCvvValidation(isValid: true)
        verify(accessCardDelegate).handleCvvValidationChange(isValid: true)
    }
    
    func testShouldNotifyMerchantDelegateWhenCvvValidationStateChangesFromTrue() {
        let validationStateHandler = CardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            cvvValidationState: true
        )
        
        validationStateHandler.handleCvvValidation(isValid: false)
        verify(accessCardDelegate).handleCvvValidationChange(isValid: false)
    }
}
