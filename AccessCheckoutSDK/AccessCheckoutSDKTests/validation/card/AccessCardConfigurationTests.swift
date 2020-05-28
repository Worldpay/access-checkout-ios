import XCTest
@testable import AccessCheckoutSDK

class AccessCardConfigurationTests: XCTestCase {
    
    let defaults = AccessCardConfiguration.CardDefaults.baseDefaults()
    
    func testInit_badUrl_returns_base_defaults() {
        let cardConfiguration = AccessCardConfiguration(fromURL: URL(fileURLWithPath: ""))
        XCTAssertNotNil(cardConfiguration?.defaults)
        XCTAssertNil(cardConfiguration?.brands.first)
    }
    
    func testInitFromURL() {
        let url = Bundle(for: type(of: self)).url(forResource: "cardTypes", withExtension: "json")!
        let cardConfiguration = AccessCardConfiguration(fromURL: url)
        XCTAssertNotNil(cardConfiguration?.defaults)
        XCTAssertNotNil(cardConfiguration?.brands)
        
        let cardBrand = cardConfiguration?.brands.first
        XCTAssertNotNil(cardBrand?.name)
        XCTAssertNotNil(cardBrand?.pans)
        XCTAssertNotNil(cardBrand?.cvv)
        XCTAssertNotNil(cardBrand?.images)
    }
    
    // MARK: Card brand
    
    func testCardBrandForPAN() {
        let cardBrand = AccessCardConfiguration.CardBrand(name: "", images: nil, matcher: "^4\\d{0,15}", cvv: nil, pans: [16])
        let cardConfiguration = AccessCardConfiguration(defaults: defaults, brands: [cardBrand])
        XCTAssertEqual(cardConfiguration.cardBrand(forPAN: "4000"), cardBrand)
    }
    
    func testCardBrand_validationRule() {
        let panRule = AccessCardConfiguration.CardValidationRule(matcher: "^4\\d{0,15}",
                                                           validLengths: [16])
        let cardBrand = AccessCardConfiguration.CardBrand(name: "", images: nil, matcher: "^4\\d{0,15}", cvv: nil, pans: [16])
        XCTAssertEqual(cardBrand.panValidationRule(), panRule)
    }
    
    func testCardBrand_equality() {
        let cardBrand1 = AccessCardConfiguration.CardBrand(name: "", images: nil, matcher: "", cvv: nil, pans: [])
        let cardBrand2 = AccessCardConfiguration.CardBrand(name: cardBrand1.name, images: nil, matcher: "", cvv: nil, pans: [])
        XCTAssertEqual(cardBrand1, cardBrand2)
    }
    
    func testCardBrand_inequality() {
        let cardBrand1 = AccessCardConfiguration.CardBrand(name: "cardBrand1", images: nil, matcher: "", cvv: nil, pans: [])
        let cardBrand2 = AccessCardConfiguration.CardBrand(name: "cardBrand2", images: nil, matcher: "", cvv: nil, pans: [])
        XCTAssertNotEqual(cardBrand1, cardBrand2)
    }
}
