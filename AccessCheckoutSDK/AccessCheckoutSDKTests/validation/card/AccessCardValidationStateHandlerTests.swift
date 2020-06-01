@testable import AccessCheckoutSDK
import XCTest

class AccessCardValidationStateHandlerTests: XCTestCase {
    let visaBrand = AccessCardConfiguration.CardBrand(
            name: "visa",
            images: nil,
            matcher: "^(?!^493698\\d*$)4\\d*$",
            cvv: 3,
            pans: [16,18,19]
        )
    
    
    let amexBrand = AccessCardConfiguration.CardBrand(
            name: "amex",
            images: nil,
            matcher: "",
            cvv: 4,
            pans: [15]
        )
    
    let accessCardDelegate = AccessCardDelegateMock()
    
    func testShouldNotNotifyMerchantDelegateIfValidationDoesNotChangeFromFalse() {
        let accessCardDelegate = AccessCardDelegateMock()

        let validationStateHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: false,
            cardBrand: nil
        )
        
        XCTAssertFalse(accessCardDelegate.panValidationCalled)
        XCTAssertFalse(validationStateHandler.panValidationState)

        validationStateHandler.handle(result: (isValid: false, cardBrand: nil))
        
        XCTAssertFalse(validationStateHandler.panValidationState)
        XCTAssertFalse(accessCardDelegate.panValidationCalled)

    }
    
    func testShouldNotNotifyMerchantDelegateIfValidationDoesNotChangeFromTrue() {
        let accessCardDelegate = AccessCardDelegateMock()

        let validationStateHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: true,
            cardBrand: nil

        )
        
        XCTAssertFalse(accessCardDelegate.panValidationCalled)
        XCTAssertTrue(validationStateHandler.panValidationState)

        validationStateHandler.handle(result: (isValid: true, cardBrand: nil))

        XCTAssertTrue(validationStateHandler.panValidationState)
        XCTAssertFalse(accessCardDelegate.panValidationCalled)

    }
   
    func testShouldNotifyMerchantDelegateIfValidationChangesToFalse() {
        let accessCardDelegate = AccessCardDelegateMock()

        let validationStateHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: true,
            cardBrand: nil

        )
                
        XCTAssertFalse(accessCardDelegate.panValidationCalled)
        XCTAssertTrue(validationStateHandler.panValidationState)

        validationStateHandler.handle(result: (isValid: false, cardBrand: nil))

        XCTAssertFalse(validationStateHandler.panValidationState)
        XCTAssertTrue(accessCardDelegate.panValidationCalled)

    }
    
    func testShouldNotifyMerchantDelegateIfValidationChangesToTrue() {
        let accessCardDelegate = AccessCardDelegateMock()

        let validationStateHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate
        )
                
        XCTAssertFalse(accessCardDelegate.panValidationCalled)
        XCTAssertFalse(validationStateHandler.panValidationState)

        validationStateHandler.handle(result: (isValid: true, cardBrand: nil))

        XCTAssertTrue(accessCardDelegate.panValidationCalled)
        XCTAssertTrue(validationStateHandler.panValidationState)

    }
    
    func testShouldNotifyMerchantDelegateWithCardBrandIfCardBrandChanges() {
        let accessCardDelegate = AccessCardDelegateMock()

        let validationStateHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate
        )
        
        XCTAssertNil(validationStateHandler.cardBrand)
        XCTAssertFalse(accessCardDelegate.cardBrandCalled)
        
        validationStateHandler.handle(result: (isValid: false, cardBrand: visaBrand))

        XCTAssertEqual(validationStateHandler.cardBrand?.name, "visa")
        XCTAssertEqual(accessCardDelegate.cardBrand?.name, "visa")
        XCTAssertTrue(accessCardDelegate.cardBrandCalled)

    }
    
    func testShouldNotNotifyMerchantDelegateIfCardBrandDoesNotChange() {
        let accessCardDelegate = AccessCardDelegateMock()

        let validationStateHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
                
        XCTAssertEqual(validationStateHandler.cardBrand?.name, "visa")
        XCTAssertFalse(accessCardDelegate.cardBrandCalled)
        
        validationStateHandler.handle(result: (isValid: false, cardBrand: visaBrand))

        XCTAssertEqual(validationStateHandler.cardBrand?.name, "visa")
        XCTAssertFalse(accessCardDelegate.cardBrandCalled)
    }
    
    func testShouldReturnFalseIfCardBrandDidNotChange() {
        let validationStateHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
                
        XCTAssertFalse(validationStateHandler.cardBrandChanged(cardBrand: visaBrand))
    }
    
    func testShouldReturnTrueIfCardBrandDidChangeFromNil() {
        let validationStateHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate
        )
        
        XCTAssertNil(validationStateHandler.cardBrand)
                
        XCTAssertTrue(validationStateHandler.cardBrandChanged(cardBrand: visaBrand))
    }
    
    func testShouldReturnTrueIfCardBrandDidChangeFromAnotherBrand() {
        let validationStateHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )
        
        XCTAssertTrue(validationStateHandler.cardBrandChanged(cardBrand: amexBrand))
    }
    
    func testShouldReturnTrueIfCardBrandDidChangeFromABrandToNil() {
        let validationStateHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate,
            panValidationState: false,
            cardBrand: visaBrand
        )

        XCTAssertTrue(validationStateHandler.cardBrandChanged(cardBrand: nil))
    }
    
    func testShouldReturnFalseIfCardBrandRemainsNil() {
        let validationStateHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate
        )
        
        XCTAssertNil(validationStateHandler.cardBrand)
        XCTAssertFalse(validationStateHandler.cardBrandChanged(cardBrand: nil))
    }
    
}
