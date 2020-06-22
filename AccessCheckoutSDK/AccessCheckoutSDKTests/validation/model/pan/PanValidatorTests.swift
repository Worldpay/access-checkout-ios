@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanValidatorTests: XCTestCase {
    private let visaBrand = TestFixtures.visaBrand()
    private let maestroBrand = TestFixtures.maestroBrand()
    
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
    
    func testValidateShouldReturnFalseWithCardBrandWhenKnownPanIsShorterThanValidLength() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        
        let result = panValidator!.validate(pan: startOfVisaPan)
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testValidateReturnsFalseAndNilCardBrandWhenUnknownPanIsShorterThanMinValidLength() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        
        let result = panValidator!.validate(pan: "1234")
        
        XCTAssertFalse(result.isValid)
        XCTAssertNil(result.cardBrand)
    }
    
    func testValidateReturnsFalseWhenAMaxLengthInvalidLuhnPanIsEntered() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        let result = panValidator!.validate(pan: "4444444444444444444")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testValidateReturnsTrueWhenALuhnValidMinLengthKnownPanIsEntered() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        
        let result = panValidator!.validate(pan: validVisaPan)
        
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
        let panWith19Digits = validVisaPanAsLongAsMaxLengthAllowed
        
        let result = panValidator!.canValidate(panWith19Digits)
        
        XCTAssertTrue(result)
    }
    
    func testCanValidateDoesNotAllowPanLongerThanMaxLengthForABrand() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrands: [visaBrand]))
        let panWith20Digits = visaPanTooLong
        
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
