import XCTest
@testable import AccessCheckout

class CardConfigurationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit_url() {
        guard let url = Bundle(for: CardConfigurationTests.self).url(forResource: "cardConfiguration",
                                                                     withExtension: "json") else {
                XCTFail()
                return
        }
        XCTAssertNotNil(CardConfiguration(fromURL: url))
    }
    
    func testInit_badUrl() {
        XCTAssertNil(CardConfiguration(fromURL: URL(fileURLWithPath: "")))
    }
    
    // MARK: Card brand
    
    func testCardBrandForPAN() {
        let panRule = CardConfiguration.CardValidationRule(matcher: "^4\\d{0,15}",
                                                           minLength: nil,
                                                           maxLength: nil,
                                                           validLength: 16,
                                                           subRules: nil)
        let cardBrand = CardConfiguration.CardBrand(name: "", imageUrl: nil, cvv: nil, pans: [panRule])
        let cardConfiguration = CardConfiguration(defaults: nil, brands: [cardBrand])
        XCTAssertEqual(cardConfiguration.cardBrand(forPAN: "4000"), cardBrand)
    }
    
    func testCardBrand_validationRule() {
        let panRule = CardConfiguration.CardValidationRule(matcher: "^4\\d{0,15}",
                                                           minLength: nil,
                                                           maxLength: nil,
                                                           validLength: 16,
                                                           subRules: nil)
        let cardBrand = CardConfiguration.CardBrand(name: "", imageUrl: nil, cvv: nil, pans: [panRule])
        XCTAssertEqual(cardBrand.cardValidationRule(forPAN: "4"), panRule)
    }
    
    func testCardBrand_validationRule_subPan() {
        
        let subPanRule = CardConfiguration.CardValidationRule(matcher: "^413600\\d{0,7}",
                                                              minLength: nil,
                                                              maxLength: nil,
                                                              validLength: 13,
                                                              subRules: nil)
        let panRule = CardConfiguration.CardValidationRule(matcher: "^4\\d{0,15}",
                                                           minLength: nil,
                                                           maxLength: nil,
                                                           validLength: 16,
                                                           subRules: [subPanRule])
        let cardBrand = CardConfiguration.CardBrand(name: "", imageUrl: nil, cvv: nil, pans: [panRule])
        XCTAssertEqual(cardBrand.cardValidationRule(forPAN: "41360"), panRule)
        XCTAssertEqual(cardBrand.cardValidationRule(forPAN: "413600"), subPanRule)
    }
    
    func testCardBrand_noValidationRule() {
        let panRule = CardConfiguration.CardValidationRule(matcher: "^4\\d{0,15}",
                                                           minLength: nil,
                                                           maxLength: nil,
                                                           validLength: 16,
                                                           subRules: nil)
        let cardBrand = CardConfiguration.CardBrand(name: "", imageUrl: nil, cvv: nil, pans: [panRule])
        XCTAssertNil(cardBrand.cardValidationRule(forPAN: "2"))
    }
    
    func testCardBrand_equality() {
        let cardBrand1 = CardConfiguration.CardBrand(name: "", imageUrl: nil, cvv: nil, pans: [])
        let cardBrand2 = CardConfiguration.CardBrand(name: cardBrand1.name, imageUrl: nil, cvv: nil, pans: [])
        XCTAssertEqual(cardBrand1, cardBrand2)
    }
    
    func testCardBrand_inequality() {
        let cardBrand1 = CardConfiguration.CardBrand(name: "cardBrand1", imageUrl: nil, cvv: nil, pans: [])
        let cardBrand2 = CardConfiguration.CardBrand(name: "cardBrand2", imageUrl: nil, cvv: nil, pans: [])
        XCTAssertNotEqual(cardBrand1, cardBrand2)
    }
}
