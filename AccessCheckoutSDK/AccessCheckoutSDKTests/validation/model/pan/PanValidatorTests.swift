@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanValidatorTests: XCTestCase {
    private let visaBrand = CardBrandModel(
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
    
    private let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    private var panValidator: PanValidator?
    
    override func setUp() {
        panValidator = PanValidator(configurationProvider)
    }
    
    // MARK: validate()
    
    func testValidateShouldReturnFalseWithCardBrandWhenKnownPanIsShorterThanValidLength() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        
        let result = panValidator!.validate(pan: "4111")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testValidateReturnsFalseAndNilCardBrandWhenUnknownPanIsShorterThanMinValidLength() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        
        let result = panValidator!.validate(pan: "5111")
        
        XCTAssertFalse(result.isValid)
        XCTAssertNil(result.cardBrand)
    }
    
    func testValidateReturnsFalseWhenAMaxLengthInvalidLuhnPanIsEntered() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        let result = panValidator!.validate(pan: "44444444444444444444")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testValidateReturnsTrueWhenALuhnValidMinLengthKnownPanIsEntered() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        
        let result = panValidator!.validate(pan: "4111111111111111")
        
        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testValidateReturnsTrueWhenALuhnValidUnknownPanIsEntered() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        
        let result = panValidator!.validate(pan: "8888888888888888")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.cardBrand)
    }
    
    func testValidateChangesFromVisaToMaestroWhenNewPatternIsMatched() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrands: [visaBrand, maestroBrand]))
        
        var result = panValidator!.validate(pan: "49369")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
        
        result = panValidator!.validate(pan: "493698")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "maestro")
    }
    
    // MARK: canValidate()
    
    func testCanValidateAllowsPanMatchingPatternAndShorterThanMaxLengthForABrand() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrands: [visaBrand]))
        
        let result = panValidator!.canValidate("49369")
        
        XCTAssertTrue(result)
    }
    
    func testCanValidateAllowsPanAsLongAsMaxLengthForABrand() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrands: [visaBrand]))
        let panWith19Digits = "4123456789012345678"
        
        let result = panValidator!.canValidate(panWith19Digits)
        
        XCTAssertTrue(result)
    }
    
    func testCanValidateDoesNotAllowPanLongerThanMaxLengthForABrand() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrands: [visaBrand]))
        let panWith20Digits = "41234567890123456789"
        
        let result = panValidator!.canValidate(panWith20Digits)
        
        XCTAssertFalse(result)
    }
    
    func testCanValidateAllowsPanMatchingPatternAndShorterThanMaxLengthForUnknownBrand() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrands: []))
        
        let result = panValidator!.canValidate("12345")
        
        XCTAssertTrue(result)
    }
    
    func testCanValidateAllowsPanAsLongAsMaxLengthForUnknownBrand() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrands: []))
        let panWith19Digits = "1234567890123456789"
        
        let result = panValidator!.canValidate(panWith19Digits)
        
        XCTAssertTrue(result)
    }
    
    func testCanValidateDoesNotAllowPanLongerThanMaxLengthForUnknownBrand() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrands: []))
        let panWith20Digits = "12345678901234567890"
        
        let result = panValidator!.canValidate(panWith20Digits)
        
        XCTAssertFalse(result)
    }
    
    func testCanValidateDoesNotAllowPanThatDoesNotMatchAnyBrandAndDoesNotMatchDefaultPattern() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrands: [visaBrand]))
        
        let result = panValidator!.canValidate("abc")
        
        XCTAssertFalse(result)
    }
    
    private func createConfiguration(withBrand brand: CardBrandModel) -> CardBrandsConfiguration {
        return CardBrandsConfiguration([brand])
    }
    
    private func createConfiguration(withBrands brands: [CardBrandModel]) -> CardBrandsConfiguration {
        return CardBrandsConfiguration(brands)
    }
}
