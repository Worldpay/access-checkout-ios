@testable import AccessCheckoutSDK
import XCTest

class PanFormatterTests: XCTestCase {
    private let formatter = PanFormatter(disableFormatting: false);

    let visaBrand = TestFixtures.visaBrand()
    let amexBrand = TestFixtures.amexBrand()
    
    func testShouldReturnSamePanIfDisabled() {
        let disabledFormatter = PanFormatter(disableFormatting: true);

        XCTAssertEqual("44444", disabledFormatter.format(pan: "44444",brand: visaBrand))
    }
    
    
    func testShouldReturnSamePanIfFourDigitsOrLess() {
        XCTAssertEqual("444", formatter.format(pan: "444", brand: visaBrand))
        XCTAssertEqual("4444", formatter.format(pan: "4444", brand: visaBrand))
    }
    
    func testShouldReturnFormattedPanIfNotDisabled() {
        XCTAssertEqual("4444 4", formatter.format(pan: "44444", brand: visaBrand))
        XCTAssertEqual("4444 4444 4444 4444", formatter.format(pan: "4444444444444444", brand: visaBrand))
        XCTAssertEqual("4444 444", formatter.format(pan: "4444 444", brand: visaBrand))
        
        XCTAssertEqual("1234 567", formatter.format(pan: "1234567", brand: nil))
    }
    
    func testShouldReturnFormattedAmexPanIfNotDisabled() {
        XCTAssertEqual("3717 4", formatter.format(pan: "37174", brand: amexBrand))
        XCTAssertEqual("3717 444444 44444", formatter.format(pan: "371744444444444", brand: amexBrand))
        XCTAssertEqual("3717 444", formatter.format(pan: "3717444", brand: amexBrand))
        XCTAssertEqual("3717 444444 4", formatter.format(pan: "37174444444", brand: amexBrand))
    }
}
