import Cuckoo
import XCTest

@testable import AccessCheckoutSDK

class CardValidationStateHandlerTests: XCTestCase {
    let visaBrand = CardBrandModel(
        name: "visa",
        images: [],
        panValidationRule: ValidationRule(
            matcher: "^(?!^493698\\d*$)4\\d*$", validLengths: [16, 18, 19]),
        cvcValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )

    let maestroBrand = CardBrandModel(
        name: "maestro",
        images: [],
        panValidationRule: ValidationRule(
            matcher:
                "^(493698|(50[0-5][0-9]{2}|506[0-5][0-9]|5066[0-9])|(5067[7-9]|506[89][0-9]|50[78][0-9]{2})|5[6-9]|63|67)\\d*$",
            validLengths: [12, 13, 14, 15, 16, 17, 18, 19]
        ),
        cvcValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )

    private let merchantDelegate = MockAccessCheckoutCardValidationDelegate()

    override func setUp() {
        merchantDelegate.getStubbingProxy().panValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cardBrandsChanged(cardBrands: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().expiryDateValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().cvcValidChanged(isValid: any()).thenDoNothing()
        merchantDelegate.getStubbingProxy().validationSuccess().thenDoNothing()
    }

    // MARK: PanValidationStateHandler - Updated for Arrays

    func
        testHandlePanValidation_shouldNotNotifyMerchantDelegateWhenPanValidationDoesNotChangeFromFalse()
    {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate, panValidationState: false)

        validationStateHandler.handlePanValidation(isValid: false, cardBrands: [])

        verify(merchantDelegate, never()).panValidChanged(isValid: any())
    }

    func
        testHandlePanValidation_shouldNotNotifyMerchantDelegateWhenPanValidationDoesNotChangeFromTrue()
    {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate, panValidationState: true)

        validationStateHandler.handlePanValidation(isValid: true, cardBrands: [])

        verify(merchantDelegate, never()).panValidChanged(isValid: any())
    }

    func testHandlePanValidation_shouldNotifyMerchantDelegateWhenPanValidationChangesToFalse() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate, panValidationState: true)

        validationStateHandler.handlePanValidation(isValid: false, cardBrands: [])

        verify(merchantDelegate).panValidChanged(isValid: false)
    }

    func testHandlePanValidation_shouldNotifyMerchantDelegateWhenPanValidationChangesToTrue() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate, panValidationState: false)

        validationStateHandler.handlePanValidation(isValid: true, cardBrands: [])

        verify(merchantDelegate).panValidChanged(isValid: true)
    }

    func testHandlePanValidation_shouldNotifyMerchantDelegateWithSingleBrandArray() {
        let expectedCardBrands = [createCardBrand(from: visaBrand)].compactMap { $0 }
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: true,
            cardBrands: []
        )

        validationStateHandler.handlePanValidation(isValid: true, cardBrands: [visaBrand])

        verify(merchantDelegate).cardBrandsChanged(cardBrands: equal(to: expectedCardBrands))
    }

    func testHandlePanValidation_shouldNotifyMerchantDelegateWithNilWhenNoBrands() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: true,
            cardBrands: [visaBrand]
        )

        validationStateHandler.handlePanValidation(isValid: true, cardBrands: [])

        let expectedCardBrands: [CardBrand] = []

        verify(merchantDelegate).cardBrandsChanged(cardBrands: equal(to: expectedCardBrands))
    }

    func testHandlePanValidation_shouldNotNotifyMerchantDelegateWhenCardBrandsDoNotChange() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrands: [visaBrand]
        )

        validationStateHandler.handlePanValidation(isValid: false, cardBrands: [visaBrand])

        verify(merchantDelegate, never()).cardBrandsChanged(cardBrands: any())
    }

    // MARK: Cobranded Cards Tests

    func testHandleCobrandedCardsUpdate_shouldUpdateWhenBrandsAreDifferent() {
        let expectedCardBrands = [
            createCardBrand(from: visaBrand), createCardBrand(from: maestroBrand),
        ].compactMap { $0 }
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrands: [visaBrand]
        )

        validationStateHandler.handleCobrandedCardsUpdate(cardBrands: [visaBrand, maestroBrand])

        verify(merchantDelegate).cardBrandsChanged(cardBrands: equal(to: expectedCardBrands))
    }

    func testHandleCobrandedCardsUpdate_shouldNotUpdateWhenBrandsAreSameButDifferentOrder() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrands: [visaBrand, maestroBrand]
        )

        validationStateHandler.handleCobrandedCardsUpdate(cardBrands: [maestroBrand, visaBrand])

        verify(merchantDelegate, never()).cardBrandsChanged(cardBrands: any())
    }

    func testHandleCobrandedCardsUpdate_shouldUpdateFromEmptyToMultipleBrands() {
        let expectedCardBrands = [
            createCardBrand(from: visaBrand), createCardBrand(from: maestroBrand),
        ].compactMap { $0 }
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrands: []
        )

        validationStateHandler.handleCobrandedCardsUpdate(cardBrands: [visaBrand, maestroBrand])

        verify(merchantDelegate).cardBrandsChanged(cardBrands: equal(to: expectedCardBrands))
    }

    // MARK: Card Brand Comparison Tests

    func testAreCardBrandsDifferentFrom_shouldReturnFalseWhenBrandsAreSame() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrands: [visaBrand]
        )

        XCTAssertFalse(validationStateHandler.areCardBrandsDifferentFrom(cardBrands: [visaBrand]))
    }

    func testAreCardBrandsDifferentFrom_shouldReturnFalseWhenBrandsAreSameButDifferentOrder() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrands: [visaBrand, maestroBrand]
        )

        XCTAssertFalse(
            validationStateHandler.areCardBrandsDifferentFrom(cardBrands: [maestroBrand, visaBrand])
        )
    }

    func testAreCardBrandsDifferentFrom_shouldReturnTrueWhenBrandsAreDifferent() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrands: [visaBrand]
        )

        XCTAssertTrue(validationStateHandler.areCardBrandsDifferentFrom(cardBrands: [maestroBrand]))
    }

    func testAreCardBrandsDifferentFrom_shouldReturnTrueWhenDifferentNumberOfBrands() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrands: [visaBrand]
        )

        XCTAssertTrue(
            validationStateHandler.areCardBrandsDifferentFrom(cardBrands: [visaBrand, maestroBrand])
        )
    }

    func testAreCardBrandsDifferentFrom_shouldReturnTrueWhenEmptyToNonEmpty() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrands: []
        )

        XCTAssertTrue(validationStateHandler.areCardBrandsDifferentFrom(cardBrands: [visaBrand]))
    }

    func testAreCardBrandsDifferentFrom_shouldReturnFalseWhenBothEmpty() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrands: []
        )

        XCTAssertFalse(validationStateHandler.areCardBrandsDifferentFrom(cardBrands: []))
    }

    // MARK: Get Card Brands Tests

    func testGetCardBrands_shouldReturnArrayOfBrands() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrands: [visaBrand, maestroBrand]
        )

        let brands = validationStateHandler.getCardBrands()

        XCTAssertEqual(brands.count, 2)
        XCTAssertEqual(brands[0].name, "visa")
        XCTAssertEqual(brands[1].name, "maestro")
    }

    func testGetCardBrands_shouldReturnEmptyArrayWhenNoBrands() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            panValidationState: false,
            cardBrands: []
        )

        let brands = validationStateHandler.getCardBrands()

        XCTAssertTrue(brands.isEmpty)
    }

    // MARK: PAN Validation State Notification Tests

    func testNotifyMerchantOfPanValidationState_notifiesMerchantOfValidPan() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate, panValidationState: true)

        validationStateHandler.notifyMerchantOfPanValidationState()

        verify(merchantDelegate).panValidChanged(isValid: true)
    }

    func
        testNotifyMerchantOfPanValidationState_notifiesMerchantOfValidPanOnlyOnceWhenCalledMultipleTimes()
    {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate, panValidationState: true)

        validationStateHandler.notifyMerchantOfPanValidationState()
        validationStateHandler.notifyMerchantOfPanValidationState()

        verify(merchantDelegate, times(1)).panValidChanged(isValid: true)
    }

    // MARK: ExpiryDateValidationStateHandler (unchanged)

    func
        testHandleExpiryDateValidation_shouldNotNotifyMerchantDelegateWhenExpiryValidationStateDoesNotChangeFromFalse()
    {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: false
        )

        validationStateHandler.handleExpiryDateValidation(isValid: false)
        verify(merchantDelegate, never()).expiryDateValidChanged(isValid: any())
    }

    func
        testHandleExpiryDateValidation_shouldNotifyMerchantDelegateWhenExpiryValidationStateChangesFromFalse()
    {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            expiryDateValidationState: false
        )

        validationStateHandler.handleExpiryDateValidation(isValid: true)
        verify(merchantDelegate).expiryDateValidChanged(isValid: true)
    }

    func testNotifyMerchantOfExpiryDateValidationState_notifiesMerchantOfValidExpiryDate() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate, expiryDateValidationState: true)

        validationStateHandler.notifyMerchantOfExpiryDateValidationState()

        verify(merchantDelegate).expiryDateValidChanged(isValid: true)
    }

    // MARK: CvcValidationStateHandler (unchanged)

    func
        testHandleCvcValidation_shouldNotNotifyMerchantDelegateWhenCvcValidationStateDoesNotChangeFromFalse()
    {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvcValidationState: false
        )

        validationStateHandler.handleCvcValidation(isValid: false)
        verify(merchantDelegate, never()).cvcValidChanged(isValid: any())
    }

    func
        testHandleCvcValidation_shouldNotifyMerchantDelegateWhenCvcValidationStateChangesFromFalse()
    {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate,
            cvcValidationState: false
        )

        validationStateHandler.handleCvcValidation(isValid: true)
        verify(merchantDelegate).cvcValidChanged(isValid: true)
    }

    func testNotifyMerchantOfCvcValidationState_notifiesMerchantOfValidCvc() {
        let validationStateHandler = CardValidationStateHandler(
            merchantDelegate: merchantDelegate, cvcValidationState: true)

        validationStateHandler.notifyMerchantOfCvcValidationState()

        verify(merchantDelegate).cvcValidChanged(isValid: true)
    }

    // MARK: Tests for notification that all fields are valid

    func testShouldNotifyMerchantDelegateWhenAllFieldsAreValid() {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate)

        validationStateHandler.handlePanValidation(isValid: true, cardBrands: [])
        validationStateHandler.handleExpiryDateValidation(isValid: true)
        validationStateHandler.handleCvcValidation(isValid: true)

        verify(merchantDelegate).validationSuccess()
    }

    func
        testShouldNotifyMerchantDelegateOnlyOnceWhenAllFieldsAreValidAFieldIsChangedToAnotherValidValue()
    {
        let validationStateHandler = CardValidationStateHandler(merchantDelegate)

        validationStateHandler.handlePanValidation(isValid: true, cardBrands: [])
        validationStateHandler.handleExpiryDateValidation(isValid: true)
        validationStateHandler.handleCvcValidation(isValid: true)
        validationStateHandler.handleCvcValidation(isValid: true)

        verify(merchantDelegate, times(1)).validationSuccess()
    }

    // MARK: Helper Methods

    private func createCardBrand(from cardBrandModel: CardBrandModel) -> CardBrand? {
        var images = [CardBrandImage]()

        for imageToConvert in cardBrandModel.images {
            let image = CardBrandImage(type: imageToConvert.type, url: imageToConvert.url)
            images.append(image)
        }

        return CardBrand(name: cardBrandModel.name, images: images)
    }
}
