@testable import AccessCheckoutSDK
import Cuckoo
import XCTest

class PanValidatorTests: XCTestCase {
    private let visaBrand = CardBrand2(
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
    
    private let configurationProvider = MockCardBrandsConfigurationProvider(CardBrandsConfigurationFactoryMock())
    private var panValidator: PanValidator?
    
    override func setUp() {
        panValidator = PanValidator(configurationProvider)
    }
    
    func testShouldReturnFalseWithCardBrandWhenKnownPanIsShorterThanValidLength() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        
        let result = panValidator!.validate(pan: "4111")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testShouldReturnFalseAndNilCardBrandWhenUnknownPanIsShorterThanMinValidLength() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        
        let result = panValidator!.validate(pan: "5111")
        
        XCTAssertFalse(result.isValid)
        XCTAssertNil(result.cardBrand)
    }
    
    func testShouldReturnFalseWhenAMaxLengthInvalidLuhnPanIsEntered() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        let result = panValidator!.validate(pan: "44444444444444444444")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testShouldReturnTrueWhenALuhnValidMinLengthKnownPanIsEntered() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        
        let result = panValidator!.validate(pan: "4111111111111111")
        
        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testShouldReturnTrueWhenALuhnValidUnknownPanIsEntered() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrand: visaBrand))
        
        let result = panValidator!.validate(pan: "8888888888888888")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.cardBrand)
    }
    
    func testShouldChangeFromVisaToMaestroWhenNewPatternIsMatched() {
        configurationProvider.getStubbingProxy().get().thenReturn(createConfiguration(withBrands: [visaBrand, maestroBrand]))
        
        var result = panValidator!.validate(pan: "49369")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
        
        result = panValidator!.validate(pan: "493698")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "maestro")
    }
    
    func createConfiguration(withBrand brand: CardBrand2) -> CardBrandsConfiguration {
        return CardBrandsConfiguration([brand], ValidationRulesDefaults.instance())
    }
    
    func createConfiguration(withBrands brands: [CardBrand2]) -> CardBrandsConfiguration {
        return CardBrandsConfiguration(brands, ValidationRulesDefaults.instance())
    }
}
