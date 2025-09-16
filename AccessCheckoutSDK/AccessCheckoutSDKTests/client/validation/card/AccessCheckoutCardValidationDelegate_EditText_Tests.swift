import Cuckoo

@testable import AccessCheckoutSDK

class AccessCheckoutCardValidationDelegate_EditText_Tests: AcceptanceTestSuite {
    private let visaBrand = TestFixtures.visaBrand()
    private let maestroBrand = TestFixtures.maestroBrand()
    private let amexBrand = TestFixtures.amexBrand()

    private let validVisaPan1 = TestFixtures.validVisaPan1
    private let validVisaPan2 = TestFixtures.validVisaPan2
    private let validMasterCardPan = TestFixtures.validMasterCardPan
    private let validAmexPan = TestFixtures.validAmexPan

    // MARK: PAN validation tests
    func testMerchantDelegateIsNotifiedWhenPANBecomesValid() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editPan(text: validVisaPan1)

        verify(merchantDelegate, times(1)).panValidChanged(isValid: true)
    }

    func testMerchantDelegateIsNotifiedWhenPANBecomesInvalid() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editPan(text: validVisaPan1)
        editPan(text: "123")

        verify(merchantDelegate, times(1)).panValidChanged(isValid: false)
    }

    func testMerchantDelegateIsNotifiedOfInvalidPANWhenPANIsValidButBrandIsNotAcceptedByMerchant() {
        let visaAsCardBrand: CardBrand = createCardBrand(from: visaBrand)
        let amexAsCardBrand: CardBrand = createCardBrand(from: amexBrand)
        let merchantDelegate = initialiseCardValidation(
            cardBrands: [visaBrand, amexBrand], acceptedCardBrands: ["visa"])

        editPan(text: validVisaPan1)
        editPan(text: validAmexPan)

        verify(merchantDelegate, times(1)).panValidChanged(isValid: true)
        verify(merchantDelegate, times(1)).cardBrandsChanged(
            cardBrands: equal(to: [visaAsCardBrand]))

        verify(merchantDelegate, times(1)).panValidChanged(isValid: false)
        verify(merchantDelegate, times(1)).cardBrandsChanged(
            cardBrands: equal(to: [amexAsCardBrand]))
    }

    func testMerchantDelegateIsNotifiedOnlyOnceWhenSubsequentValidPANsAreEntered() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editPan(text: validVisaPan1)
        editPan(text: validVisaPan2)

        verify(merchantDelegate, times(1)).panValidChanged(isValid: true)
    }

    // MARK: Card brand changes

    func testMerchantDelegateIsNotifiedWhenCardBrandChanges() {
        let expectedCardBrands = [createCardBrand(from: visaBrand)]
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editPan(text: "4")

        verify(merchantDelegate, times(1)).cardBrandsChanged(
            cardBrands: equal(to: expectedCardBrands))
    }

    func testMerchantDelegateIsNotNotifiedWhenPanChangesButBrandRemainsTheSame() {
        let expectedCardBrands = [createCardBrand(from: visaBrand)]
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editPan(text: "4")
        editPan(text: "49")

        verify(merchantDelegate, times(1)).cardBrandsChanged(
            cardBrands: equal(to: expectedCardBrands))
    }

    func testMerchantDelegateIsNotifiedOfAVisaToMaestroCardBrandChange() {
        let visaAsCardBrand: CardBrand = createCardBrand(from: visaBrand)
        let maestroAsCardBrand: CardBrand = createCardBrand(from: maestroBrand)
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editPan(text: "49369")
        verify(merchantDelegate, times(1)).cardBrandsChanged(
            cardBrands: equal(to: [visaAsCardBrand]))

        editPan(text: "493698")
        verify(merchantDelegate, times(1)).cardBrandsChanged(
            cardBrands: equal(to: [maestroAsCardBrand]))
    }

    func testMerchantDelegateIsNotifiedWithEmptyArrayWhenNoBrandIsIdentified() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editPan(text: "4")
        clearInvocations(merchantDelegate)

        editPan(text: "")

        verify(merchantDelegate, times(1)).cardBrandsChanged(cardBrands: [])
    }

    // MARK: Expiry date validation tests
    func testMerchantDelegateIsNotifiedWhenExpiryDateBecomesValid() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editExpiryDate(text: "11/32")

        verify(merchantDelegate, times(1)).expiryDateValidChanged(isValid: true)
    }

    func testMerchantDelegateIsNotifiedWhenExpiryDateBecomesInvalid() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editExpiryDate(text: "11/32")
        editExpiryDate(text: "11/3")

        verify(merchantDelegate, times(1)).expiryDateValidChanged(isValid: false)
    }

    func testMerchantDelegateIsNotifiedOnlyOnceWhenSubsequentValidExpiryDatesAreEntered() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editExpiryDate(text: "11/32")
        editExpiryDate(text: "11/33")

        verify(merchantDelegate, times(1)).expiryDateValidChanged(isValid: true)
    }

    // MARK: Cvc validation tests
    func testMerchantDelegateIsNotifiedWhenCvcBecomesValid() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editCvc(text: "123")

        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: true)
    }

    func testMerchantDelegateIsNotifiedWhenCvcBecomesInvalid() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editCvc(text: "123")
        editCvc(text: "12")

        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: false)
    }

    func testMerchantDelegateIsNotifiedOnlyOnceWhenSubsequentValidCvcsAreEntered() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editCvc(text: "456")
        editCvc(text: "123")

        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: true)
    }

    func
        testMerchantDelegateIsNotifiedOfAnInvalidCvcWhenThePanIsChangedAndRequiresACvcOfADifferentLength()
    {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, amexBrand])

        editPan(text: validVisaPan1)
        editCvc(text: "123")
        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: true)
        clearInvocations(merchantDelegate)

        editPan(text: validAmexPan)
        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: false)
    }

    func testMerchantDelegateIsNotNotifiedWhenThePanIsChangedAndRequiresACvcOfTheSameLength() {
        let expectedVisaCardBrands = [createCardBrand(from: visaBrand)]
        let expectedMaestroCardBrands = [createCardBrand(from: maestroBrand)]

        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editPan(text: "49369")
        editCvc(text: "123")
        verify(merchantDelegate, times(1)).cardBrandsChanged(
            cardBrands: equal(to: expectedVisaCardBrands))
        verify(merchantDelegate, times(1)).cvcValidChanged(isValid: true)
        clearInvocations(merchantDelegate)

        editPan(text: "493698")
        verify(merchantDelegate, times(1)).cardBrandsChanged(
            cardBrands: equal(to: expectedMaestroCardBrands))
        verify(merchantDelegate, never()).cvcValidChanged(isValid: true)
    }

    // MARK: validation success tests

    func testMerchantIsNotifiedOfValidationSuccess() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editPan(text: validVisaPan1)
        editCvc(text: "123")
        editExpiryDate(text: "12/35")

        verify(merchantDelegate, times(1)).validationSuccess()
    }

    func testMerchantIsNotNotifiedOfValidationSuccessWhenPanIsNotValid() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editPan(text: "4111")
        editCvc(text: "123")
        editExpiryDate(text: "12/35")

        verify(merchantDelegate, never()).validationSuccess()
    }

    func testMerchantIsNotNotifiedOfValidationSuccessWhenExpiryDateIsNotValid() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editPan(text: validVisaPan1)
        editCvc(text: "123")
        editExpiryDate(text: "12/19")

        verify(merchantDelegate, never()).validationSuccess()
    }

    func testMerchantIsNotNotifiedOfValidationSuccessWhenCvcIsNotValid() {
        let merchantDelegate = initialiseCardValidation(cardBrands: [visaBrand, maestroBrand])

        editPan(text: validVisaPan1)
        editCvc(text: "12")
        editExpiryDate(text: "12/35")

        verify(merchantDelegate, never()).validationSuccess()
    }

    private func createCardBrand(from cardBrandModel: CardBrandModel) -> CardBrand {
        var images = [CardBrandImage]()

        for imageToConvert in cardBrandModel.images {
            let image = CardBrandImage(type: imageToConvert.type, url: imageToConvert.url)
            images.append(image)
        }

        return CardBrand(name: cardBrandModel.name, images: images)
    }
}
