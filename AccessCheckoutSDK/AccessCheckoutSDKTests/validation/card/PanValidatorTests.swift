import XCTest
@testable import AccessCheckoutSDK

class PanValidatorTests : XCTestCase {
    
    let visaBrand = CardBrand2(
        name: "visa",
        images: [],
        panValidationRule: ValidationRule(matcher: "^(?!^493698\\d*$)4\\d*$", validLengths: [16,18,19]),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )

    let maestroBrand = CardBrand2(
        name: "maestro",
        images: [],
        panValidationRule: ValidationRule(
            matcher: "^(493698|(50[0-5][0-9]{2}|506[0-5][0-9]|5066[0-9])|(5067[7-9]|506[89][0-9]|50[78][0-9]{2})|5[6-9]|63|67)\\d*$",
            validLengths: [12,13,14,15,16,17,18,19]
        ),
        cvvValidationRule: ValidationRule(matcher: nil, validLengths: [3])
    )
    
    let baseDefaults = ValidationRulesDefaults.instance()

    
    func testShouldReturnFalseWithCardBrandWhenKnownPanIsShorterThanValidLength() {
        let cardConfiguration = CardBrandsConfiguration([visaBrand], baseDefaults)
        let panValidator = PanValidator(
            cardConfiguration: cardConfiguration
        )
        
        let result = panValidator.validate(pan: "4111")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
    }
    
    func testShouldReturnFalseAndNilCardBrandWhenUnknownPanIsShorterThanMinValidLength() {
        let cardConfiguration = CardBrandsConfiguration([visaBrand], baseDefaults)
        let panValidator = PanValidator(
            cardConfiguration: cardConfiguration
        )
            
        let result = panValidator.validate(pan: "5111")
        
        XCTAssertFalse(result.isValid)
        XCTAssertNil(result.cardBrand)
    }
    
    func testShouldReturnFalseWhenAMaxLengthInvalidLuhnPanIsEntered() {
        let cardConfiguration = CardBrandsConfiguration([visaBrand], baseDefaults)
        let panValidator = PanValidator(
            cardConfiguration: cardConfiguration
        )
        
        let result = panValidator.validate(pan: "44444444444444444444")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")

    }
    
    func testShouldReturnTrueWhenALuhnValidMinLengthKnownPanIsEntered() {
        let cardConfiguration = CardBrandsConfiguration([visaBrand], baseDefaults)
        let panValidator = PanValidator(
            cardConfiguration: cardConfiguration
        )
            
        let result = panValidator.validate(pan: "4111111111111111")
        
        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")

    }
    
    func testShouldReturnTrueWhenALuhnValidUnknownPanIsEntered() {
        let cardConfiguration = CardBrandsConfiguration([visaBrand], baseDefaults)
        let panValidator = PanValidator(
            cardConfiguration: cardConfiguration
        )
            
        let result = panValidator.validate(pan: "8888888888888888")
        
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.cardBrand)
    }
    
    func testShouldChangeFromVisaToMaestroWhenNewPatternIsMatched() {
        let cardConfiguration = CardBrandsConfiguration([visaBrand, maestroBrand], baseDefaults)
        let panValidator = PanValidator(
            cardConfiguration: cardConfiguration
        )
        var result = panValidator.validate(pan: "49369")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "visa")
        
        result = panValidator.validate(pan: "493698")
        
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.cardBrand?.name, "maestro")
        
    }
}
