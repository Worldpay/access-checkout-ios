@testable import AccessCheckoutSDK
import XCTest

class PanFormatterTests: XCTestCase {
    private let formatterWithCardSpacing = PanFormatter(cardSpacingEnabled: true)
    
    let visaBrand = TestFixtures.visaBrand()
    let amexBrand = TestFixtures.amexBrand()
    
    func testShouldReturnSamePanIfCardSpacingNotEnabled() {
        let formatterWithNoCardSpacing = PanFormatter(cardSpacingEnabled: false)
        
        XCTAssertEqual("44444", formatterWithNoCardSpacing.format(pan: "44444", brand: visaBrand))
    }
    
    func testShouldReturnSamePanIfCardSpacingEnabledAndFourDigitsOrLess() {
        XCTAssertEqual("444", formatterWithCardSpacing.format(pan: "444", brand: visaBrand))
        XCTAssertEqual("4444", formatterWithCardSpacing.format(pan: "4444", brand: visaBrand))
    }
    
    func testShouldReturnFormattedPanIfCardSpacingEnabled() {
        XCTAssertEqual("4444 4", formatterWithCardSpacing.format(pan: "44444", brand: visaBrand))
        XCTAssertEqual("4444 4444 4444 4444", formatterWithCardSpacing.format(pan: "4444444444444444", brand: visaBrand))
        XCTAssertEqual("4444 444", formatterWithCardSpacing.format(pan: "4444 444", brand: visaBrand))
        
        XCTAssertEqual("1234 567", formatterWithCardSpacing.format(pan: "1234567", brand: nil))
    }
    
    func testShouldReturnFormattedAmexPanIfCardSpacingEnabledAnd() {
        XCTAssertEqual("3717 4", formatterWithCardSpacing.format(pan: "37174", brand: amexBrand))
        XCTAssertEqual("3717 444444 44444", formatterWithCardSpacing.format(pan: "371744444444444", brand: amexBrand))
        XCTAssertEqual("3717 444", formatterWithCardSpacing.format(pan: "3717444", brand: amexBrand))
        XCTAssertEqual("3717 444444 4", formatterWithCardSpacing.format(pan: "37174444444", brand: amexBrand))
    }
}
