@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class CardValidationStateHandlerTests: XCTestCase {
    private let visaBrand = AccessCardConfiguration.CardBrand(
        name: "visa",
        images: nil,
        matcher: "",
        cvv: 3,
        pans: []
    )
    
    private let amexBrand = AccessCardConfiguration.CardBrand(
        name: "amex",
        images: nil,
        matcher: "",
        cvv: 4,
        pans: []
    )
    
    private let accessCardDelegate = MockAccessCardDelegate()
    
    override func setUp() {
        Cuckoo.stub(accessCardDelegate) { stub in
            when(stub).handlePanValidationChange(isValid: any()).thenDoNothing()
            when(stub).handleCardBrandChange(cardBrand: any()).thenDoNothing()
            when(stub).handleExpiryDateValidationChange(isValid: any()).thenDoNothing()
        }
    }
    
    func testShouldNotNotifyMerchantDelegateWhenValidationDoesNotChangeFromFalse() {
        let validationStateHandler = CardValidationStateHandler(accessCardDelegate: accessCardDelegate, panValidationState: false)
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: nil)
        
        verify(accessCardDelegate, never()).handlePanValidationChange(isValid: any())
    }
    
    func testShouldNotNotifyMerchantDelegateWhenValidationDoesNotChangeFromTrue() {
        let validationStateHandler = CardValidationStateHandler(accessCardDelegate: accessCardDelegate, panValidationState: true)
        
        validationStateHandler.handlePanValidation(isValid: true, cardBrand: nil)
        
        verify(accessCardDelegate, never()).handlePanValidationChange(isValid: any())
    }
    
    func testShouldNotifyMerchantDelegateWhenValidationChangesToFalse() {
        let validationStateHandler = CardValidationStateHandler(accessCardDelegate: accessCardDelegate, panValidationState: true)
        
        validationStateHandler.handlePanValidation(isValid: false, cardBrand: nil)
        
        verify(accessCardDelegate).handlePanValidationChange(isValid: false)
    }
    
    func testShouldNotifyMerchantDelegateWhenValidationChangesToTrue() {
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
        
        XCTAssertTrue(validationStateHandler.isCardBrandDifferentFrom(cardBrand: amexBrand))
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
    
    // ExpiryDate Validation
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
}
