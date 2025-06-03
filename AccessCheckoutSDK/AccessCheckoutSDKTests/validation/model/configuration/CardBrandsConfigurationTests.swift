import XCTest

@testable import AccessCheckoutSDK

class CardBrandsConfigurationTests: XCTestCase {
    func testReturnsCardBrandMatchingPan() {
        let cardBrandStartingWith3 = createCardBrand(panMatcherPattern: "^3\\d*?")
        let cardBrandStartingWith4 = createCardBrand(panMatcherPattern: "^4\\d*?")
        let configuration = CardBrandsConfiguration(
            allCardBrands: [cardBrandStartingWith3, cardBrandStartingWith4], acceptedCardBrands: [])

        let resultForPanStartingWith3 = configuration.cardBrand(forPan: "3321")
        let resultForPanStartingWith4 = configuration.cardBrand(forPan: "4321")

        XCTAssertEqual(cardBrandStartingWith3, resultForPanStartingWith3)
        XCTAssertEqual(cardBrandStartingWith4, resultForPanStartingWith4)
    }

    func testReturnsNoCardBrandIfNoCardBrandsConfigured() {
        let configuration = CardBrandsConfiguration(allCardBrands: [], acceptedCardBrands: [])

        let result = configuration.cardBrand(forPan: "1234")

        XCTAssertNil(result)
    }

    func testReturnsNoCardBrandIfNoMatchingValidationRuleFound() {
        let cardBrand = createCardBrand(panMatcherPattern: "^3\\d*?")
        let configuration = CardBrandsConfiguration(
            allCardBrands: [cardBrand], acceptedCardBrands: [])

        let result = configuration.cardBrand(forPan: "1234")

        XCTAssertNil(result)
    }

    func testReturnsPanValidationRuleCorrespondingToCardBrand() {
        let expectedPanValidationRule = ValidationRule(matcher: "1234", validLengths: [1, 2])
        let cardBrand = createCardBrand(panValidationRule: expectedPanValidationRule)
        let configuration = CardBrandsConfiguration(allCardBrands: [], acceptedCardBrands: [])

        let result = configuration.panValidationRule(using: cardBrand)

        XCTAssertEqual(expectedPanValidationRule, result)
    }

    func testReturnsDefaultPanValidationRuleIfCardBrandIsNil() {
        let configuration = CardBrandsConfiguration(allCardBrands: [], acceptedCardBrands: [])

        let result = configuration.panValidationRule(using: nil)

        XCTAssertEqual(ValidationRulesDefaults.instance().pan, result)
    }

    private func createCardBrand(panMatcherPattern: String) -> CardBrandModel {
        let panValidationRule = ValidationRule(matcher: panMatcherPattern, validLengths: [])
        let cvcValidationRule = ValidationRule(matcher: nil, validLengths: [])

        return CardBrandModel(
            name: "", images: [], panValidationRule: panValidationRule,
            cvcValidationRule: cvcValidationRule)
    }

    private func createCardBrand(panValidationRule: ValidationRule) -> CardBrandModel {
        let cvcValidationRule = ValidationRule(matcher: nil, validLengths: [])

        return CardBrandModel(
            name: "", images: [], panValidationRule: panValidationRule,
            cvcValidationRule: cvcValidationRule)
    }
}
