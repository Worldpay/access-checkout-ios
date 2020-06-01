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

    
    func testShouldNotNotifyDelegateIfValidationDoesNotChangeFromFalse() {
        let accessCardDelegate = AccessCardDelegateMock()

        let panValidationHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate
        )
        
        XCTAssertFalse(accessCardDelegate.panValidationCalled)
        XCTAssertFalse(panValidationHandler.panValidationState)

        panValidationHandler.handle(result: (isValid: false, cardBrand: nil))
        
        XCTAssertFalse(panValidationHandler.panValidationState)
        XCTAssertFalse(accessCardDelegate.panValidationCalled)

    }
    
    func testShouldNotNotifyDelegateIfValidationDoesNotChangeFromTrue() {
        let accessCardDelegate = AccessCardDelegateMock()

        let panValidationHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate
        )

        panValidationHandler.panValidationState = true
        
        XCTAssertFalse(accessCardDelegate.panValidationCalled)
        XCTAssertTrue(panValidationHandler.panValidationState)

        panValidationHandler.handle(result: (isValid: true, cardBrand: nil))

        XCTAssertTrue(panValidationHandler.panValidationState)
        XCTAssertFalse(accessCardDelegate.panValidationCalled)

    }
   
    func testShouldNotifyDelegateIfValidationChangesToFalse() {
        let accessCardDelegate = AccessCardDelegateMock()

        let panValidationHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate
        )
        
        panValidationHandler.panValidationState = true
        
        XCTAssertFalse(accessCardDelegate.panValidationCalled)
        XCTAssertTrue(panValidationHandler.panValidationState)

        panValidationHandler.handle(result: (isValid: false, cardBrand: nil))

        XCTAssertFalse(panValidationHandler.panValidationState)
        XCTAssertTrue(accessCardDelegate.panValidationCalled)

    }
    
    func testShouldNotifyDelegateIfValidationChangesToTrue() {
        let accessCardDelegate = AccessCardDelegateMock()

        let panValidationHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate
        )
                
        XCTAssertFalse(accessCardDelegate.panValidationCalled)
        XCTAssertFalse(panValidationHandler.panValidationState)

        panValidationHandler.handle(result: (isValid: true, cardBrand: nil))

        XCTAssertTrue(accessCardDelegate.panValidationCalled)
        XCTAssertTrue(panValidationHandler.panValidationState)

    }
    
    func testShouldNotifyDelegateWithCardBrandIfCardBrandChanges() {
        let accessCardDelegate = AccessCardDelegateMock()

        let panValidationHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate
        )
        
        XCTAssertNil(panValidationHandler.cardBrand)
        XCTAssertFalse(accessCardDelegate.cardBrandCalled)
        
        panValidationHandler.handle(result: (isValid: false, cardBrand: visaBrand))

        XCTAssertEqual(panValidationHandler.cardBrand?.name, "visa")
        XCTAssertEqual(accessCardDelegate.cardBrand?.name, "visa")
        XCTAssertTrue(accessCardDelegate.cardBrandCalled)

    }
    
    func testShouldNotNotifyDelegateIfCardBrandDoesNotChange() {
        let accessCardDelegate = AccessCardDelegateMock()

        let panValidationHandler = AccessCardValidationStateHandler(
            accessCardDelegate: accessCardDelegate
        )
        
        panValidationHandler.cardBrand = visaBrand
        
        XCTAssertEqual(panValidationHandler.cardBrand?.name, "visa")
        XCTAssertFalse(accessCardDelegate.cardBrandCalled)
        
        panValidationHandler.handle(result: (isValid: false, cardBrand: visaBrand))

        XCTAssertEqual(panValidationHandler.cardBrand?.name, "visa")
        XCTAssertFalse(accessCardDelegate.cardBrandCalled)

    }
    
    private func mockValidator(valid: Bool, brand: AccessCardConfiguration.CardBrand?) -> PanValidator {
        return PanValidatorMock(
            cardConfiguration: AccessCardConfiguration(
                defaults: AccessCardConfiguration.CardDefaults.baseDefaults(),
                brands: []
            ),
            validation: valid,
            brand: brand
        )
    }
}
