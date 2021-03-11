@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanValidatorTests: XCTestCase {
    private let amexBrand = TestFixtures.maestroBrand()
    private let maestroBrand = TestFixtures.maestroBrand()
    private let visaBrand = TestFixtures.visaBrand()
    
    private let validVisaPan = TestFixtures.validVisaPan1
    private let validVisaPanAsLongAsMaxLengthAllowed = TestFixtures.validVisaPanAsLongAsMaxLengthAllowed
    private let visaPanTooLong = TestFixtures.visaPanTooLong
    private let startOfVisaPan = "4111"
    
    private let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    private var panValidator: PanValidator?
    
    override func setUp() {
        panValidator = PanValidator(configurationProvider)
    }
    
    // MARK: validate()
    
    func testValidate_returnsFalseAndCardBrand_whenKnownBrandPanIsShorterThanMinValidLength() {
        givenConfigurationHas(brands: [visaBrand])
        
        let result = panValidator!.validate(pan: startOfVisaPan)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testValidate_returnsFalseAndNilCardBrand_whenUnknownBrandPanIsShorterThanMinValidLength() {
        givenConfigurationHas(brands: [visaBrand])
        
        let result = panValidator!.validate(pan: "1234")
        
        XCTAssertFalse(result.isValid)
        XCTAssertNil(result.cardBrand)
    }
    
    func testValidate_returnsFalseAndCardBrand_whenKnownBrandPanHasInvalidLuhnAndValidLength() {
        givenConfigurationHas(brands: [visaBrand])
        
        let result = panValidator!.validate(pan: "4444444444444444444")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testValidate_returnsTrueAndCardBrand_whenKnownBrandPanHasValidLuhnAndValidLength() {
        givenConfigurationHas(brands: [visaBrand])
        
        let result = panValidator!.validate(pan: validVisaPan)
        
        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testValidate_returnsTrueAndNilCardBrand_whenUnknownBrandPanHasValidLuhnAndValidLength() {
        givenConfigurationHas(brands: [visaBrand])
        
        let result = panValidator!.validate(pan: "8888888888888888")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.cardBrand)
    }
    
    func testValidate_returnsFirstVisaThenMaestro_whenVisaAndMaestroPatternsAreEntered() {
        givenConfigurationHas(brands: [visaBrand, maestroBrand])
        
        var result = panValidator!.validate(pan: "49369")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
        
        result = panValidator!.validate(pan: "493698")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "maestro")
    }
    
    func testValidate_returnsTrueAndCardBrand_whenKnownBrandPanIsValid_andAcceptedBrandsIsEmpty() {
        givenConfigurationHas(brands: [amexBrand, visaBrand], acceptedBrands: [])
        
        let result = panValidator!.validate(pan: validVisaPan)
        
        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testValidate_returnsTrueAndCardBrand_whenKnownBrandPanIsValid_andBrandIsPartOfMerchantRestrictions() {
        givenConfigurationHas(brands: [amexBrand, visaBrand], acceptedBrands: ["amex", "visa"])
        
        let result = panValidator!.validate(pan: validVisaPan)
        
        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testValidate_returnsTrueAndCardBrand_whenKnownBrandPanIsValid_andBrandIsPartOfMerchantRestrictions_independentlyOfCase() {
        givenConfigurationHas(brands: [visaBrand], acceptedBrands: ["VisA"])
        
        let result = panValidator!.validate(pan: validVisaPan)
        
        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testValidate_returnsFalseAndCardBrand_whenKnownBrandPanIsValid_andBrandIsNOTPartOfMerchantRestrictions() {
        givenConfigurationHas(brands: [amexBrand, maestroBrand, visaBrand], acceptedBrands: ["amex", "maestro"])
        
        let result = panValidator!.validate(pan: validVisaPan)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testValidate_returnsTrue_whenUnknownBrandPanIsValid_andConfigHasRestrictionOnAcceptedBrands() {
        givenConfigurationHas(brands: [visaBrand], acceptedBrands: ["visa"])
        
        let result = panValidator!.validate(pan: "8888888888888888")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.cardBrand)
    }
    
    // MARK: canValidate()
    
    func testCanValidateAllowsPanMatchingPatternAndShorterThanMaxLengthForABrand() {
        givenConfigurationHas(brands: [visaBrand])
        
        let result = panValidator!.canValidate("49369")
        
        XCTAssertTrue(result)
    }
    
    func testCanValidateAllowsPanAsLongAsMaxLengthForABrand() {
        givenConfigurationHas(brands: [visaBrand])
        let panWith19Digits = validVisaPanAsLongAsMaxLengthAllowed
        
        let result = panValidator!.canValidate(panWith19Digits)
        
        XCTAssertTrue(result)
    }
    
    func testCanValidateDoesNotAllowPanLongerThanMaxLengthForABrand() {
        givenConfigurationHas(brands: [visaBrand])
        let panWith20Digits = visaPanTooLong
        
        let result = panValidator!.canValidate(panWith20Digits)
        
        XCTAssertFalse(result)
    }
    
    func testCanValidateAllowsPanMatchingPatternAndShorterThanMaxLengthForUnknownBrand() {
        givenConfigurationHas(brands: [])
        
        let result = panValidator!.canValidate("12345")
        
        XCTAssertTrue(result)
    }
    
    func testCanValidateAllowsPanAsLongAsMaxLengthForUnknownBrand() {
        givenConfigurationHas(brands: [])
        let panWith19Digits = "1234567890123456789"
        
        let result = panValidator!.canValidate(panWith19Digits)
        
        XCTAssertTrue(result)
    }
    
    func testCanValidateDoesNotAllowPanLongerThanMaxLengthForUnknownBrand() {
        givenConfigurationHas(brands: [])
        let panWith20Digits = "12345678901234567890"
        
        let result = panValidator!.canValidate(panWith20Digits)
        
        XCTAssertFalse(result)
    }
    
    func testCanValidateDoesNotAllowPanThatDoesNotMatchAnyBrandAndDoesNotMatchDefaultPattern() {
        givenConfigurationHas(brands: [visaBrand])
        
        let result = panValidator!.canValidate("abc")
        
        XCTAssertFalse(result)
    }
    
    private func givenConfigurationHas(brands: [CardBrandModel], acceptedBrands: [String] = []) {
        configurationProvider.getStubbingProxy().get().thenReturn(CardBrandsConfiguration(allCardBrands: brands, acceptedCardBrands: acceptedBrands))
    }
}
