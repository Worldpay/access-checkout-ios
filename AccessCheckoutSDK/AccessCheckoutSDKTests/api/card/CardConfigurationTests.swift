import XCTest
@testable import AccessCheckoutSDK

class CardConfigurationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInit_badUrl_returns_base_defaults() {
        let cardConfiguration = CardConfiguration(fromURL: URL(fileURLWithPath: ""))
        XCTAssertNotNil(cardConfiguration?.defaults)
        XCTAssertNil(cardConfiguration?.brands)
    }
    
    func testInitFromURL() {
        let url = Bundle(for: type(of: self)).url(forResource: "cardTypes", withExtension: "json")!
        let cardConfiguration = CardConfiguration(fromURL: url)
        XCTAssertNotNil(cardConfiguration?.defaults)
        XCTAssertNotNil(cardConfiguration?.brands)
        
        let cardBrand = cardConfiguration?.brands?.first
        XCTAssertNotNil(cardBrand?.name)
        XCTAssertNotNil(cardBrand?.pans)
        XCTAssertNotNil(cardBrand?.cvv)
        XCTAssertNotNil(cardBrand?.images)
    }
    
    // MARK: Card brand
    
    func testCardBrandForPAN() {
        let cardBrand = CardConfiguration.CardBrand(name: "", images: nil, matcher: "^4\\d{0,15}", cvv: nil, pans: [16])
        let cardConfiguration = CardConfiguration(defaults: nil, brands: [cardBrand])
        XCTAssertEqual(cardConfiguration.cardBrand(forPAN: "4000"), cardBrand)
    }
    
    func testCardBrand_validationRule() {
        let panRule = CardConfiguration.CardValidationRule(matcher: "^4\\d{0,15}",
                                                           validLengths: [16])
        let cardBrand = CardConfiguration.CardBrand(name: "", images: nil, matcher: "^4\\d{0,15}", cvv: nil, pans: [16])
        XCTAssertEqual(cardBrand.panValidationRule(), panRule)
    }
    
    func testCardBrand_equality() {
        let cardBrand1 = CardConfiguration.CardBrand(name: "", images: nil, matcher: "", cvv: nil, pans: [])
        let cardBrand2 = CardConfiguration.CardBrand(name: cardBrand1.name, images: nil, matcher: "", cvv: nil, pans: [])
        XCTAssertEqual(cardBrand1, cardBrand2)
    }
    
    func testCardBrand_inequality() {
        let cardBrand1 = CardConfiguration.CardBrand(name: "cardBrand1", images: nil, matcher: "", cvv: nil, pans: [])
        let cardBrand2 = CardConfiguration.CardBrand(name: "cardBrand2", images: nil, matcher: "", cvv: nil, pans: [])
        XCTAssertNotEqual(cardBrand1, cardBrand2)
    }
}
