@testable import AccessCheckoutSDK
import XCTest

class CardBrandsConfigurationTests: XCTestCase {
    func testReturnsCardBrandMatchingPan() {
        let cardBrandStartingWith3 = createCardBrand(panMatcherPattern: "^3\\d*?")
        let cardBrandStartingWith4 = createCardBrand(panMatcherPattern: "^4\\d*?")
        let configuration = CardBrandsConfiguration([cardBrandStartingWith3, cardBrandStartingWith4], ValidationRulesDefaults.instance())
        
        let resultForPanStartingWith3 = configuration.cardBrand(of: "3321")
        let resultForPanStartingWith4 = configuration.cardBrand(of: "4321")
        
        XCTAssertEqual(cardBrandStartingWith3, resultForPanStartingWith3)
        XCTAssertEqual(cardBrandStartingWith4, resultForPanStartingWith4)
    }
    
    func testReturnsNoCardBrandIfNoCardBrandsConfigured() {
        let configuration = CardBrandsConfiguration([], ValidationRulesDefaults.instance())
        
        let result = configuration.cardBrand(of: "1234")
        
        XCTAssertNil(result)
    }
    
    func testReturnsNoCardBrandIfNoMatchingValidationRuleFound() {
        let cardBrand = createCardBrand(panMatcherPattern: "^3\\d*?")
        let configuration = CardBrandsConfiguration([cardBrand], ValidationRulesDefaults.instance())
        
        let result = configuration.cardBrand(of: "1234")
        
        XCTAssertNil(result)
    }
    
    func testReturnsPanValidationRuleCorrespondingToCardBrand() {
        let expectedPanValidationRule = ValidationRule(matcher: "1234", validLengths: [1, 2])
        let cardBrand = createCardBrand(panValidationRule: expectedPanValidationRule)
        let configuration = CardBrandsConfiguration([], ValidationRulesDefaults.instance())
        
        let result = configuration.panValidationRule(using: cardBrand)
        
        XCTAssertEqual(expectedPanValidationRule, result)
        XCTAssertNotEqual(ValidationRulesDefaults.instance().pan, result)
    }
    
    func testReturnsDefaultPanValidationRuleIfCardBrandIsNil() {
        let configuration = CardBrandsConfiguration([], ValidationRulesDefaults.instance())
        
        let result = configuration.panValidationRule(using: nil)
        
        XCTAssertEqual(ValidationRulesDefaults.instance().pan, result)
    }
    
    private func createCardBrand(panMatcherPattern: String) -> CardBrand2 {
        let panValidationRule = ValidationRule(matcher: panMatcherPattern, validLengths: [])
        let cvvValidationRule = ValidationRule(matcher: nil, validLengths: [])
        
        return CardBrand2(name: "", images: [], panValidationRule: panValidationRule, cvvValidationRule: cvvValidationRule)
    }
    
    private func createCardBrand(panValidationRule: ValidationRule) -> CardBrand2 {
        let cvvValidationRule = ValidationRule(matcher: nil, validLengths: [])
        
        return CardBrand2(name: "", images: [], panValidationRule: panValidationRule, cvvValidationRule: cvvValidationRule)
    }
}
