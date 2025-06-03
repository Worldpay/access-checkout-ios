import XCTest

@testable import AccessCheckoutSDK

class PanFormatterTests: XCTestCase {
    private let formatterWithCardSpacing = PanFormatter(cardSpacingEnabled: true)
    private let formatterWithNoCardSpacing = PanFormatter(cardSpacingEnabled: false)

    let visaBrand = TestFixtures.visaBrand()
    let amexBrand = TestFixtures.amexBrand()

    // MARK: card spacing disabled

    func testShouldReturnSamePanIfPanHasDigitsOnlyAndCardSpacingNotEnabled() {
        XCTAssertEqual("44444", formatterWithNoCardSpacing.format(pan: "44444", brand: visaBrand))
    }

    // This use case would happen when pasting in a pan with spaces
    func testShouldReturnPanWithNoSpacesIfPanHasSpacesAndCardSpacingNotEnabled() {
        XCTAssertEqual(
            "44444", formatterWithNoCardSpacing.format(pan: "44  444 ", brand: visaBrand))
    }

    // This use case would happen when pasting in a pan with spaces
    func
        testShouldReturnPanWithNoSpacesIfCardSpacingNotEnabledAndPanHasFourCharactersOrLessIncludingSpaces()
    {
        XCTAssertEqual("4", formatterWithNoCardSpacing.format(pan: "4 ", brand: visaBrand))
        XCTAssertEqual("44", formatterWithNoCardSpacing.format(pan: "4 4 ", brand: visaBrand))
    }

    // MARK: card spacing enabled

    func testShouldReturnSamePanIfCardSpacingEnabledAndFourDigitsOrLess() {
        XCTAssertEqual("444", formatterWithCardSpacing.format(pan: "444", brand: visaBrand))
        XCTAssertEqual("4444", formatterWithCardSpacing.format(pan: "4444", brand: visaBrand))
    }

    // This use case would happen when pasting in a pan with spaces
    func testShouldReturnFormattedPanIfCardSpacingEnabled() {
        XCTAssertEqual("4444 4", formatterWithCardSpacing.format(pan: "44444", brand: visaBrand))
        XCTAssertEqual(
            "4444 4444 4444 4444",
            formatterWithCardSpacing.format(pan: "4444444444444444", brand: visaBrand))
        XCTAssertEqual(
            "4444 444", formatterWithCardSpacing.format(pan: "4444 444", brand: visaBrand))
        XCTAssertEqual(
            "4444 444",
            formatterWithCardSpacing.format(pan: "  4  44 4 44   4     ", brand: visaBrand))

        XCTAssertEqual("1234 567", formatterWithCardSpacing.format(pan: "1234567", brand: nil))
    }

    func
        testShouldReturnFormattedPanIfCardSpacingEnabledAndPanHasFourCharactersOrLessIncludingSpaces()
    {
        XCTAssertEqual("4", formatterWithCardSpacing.format(pan: "4 ", brand: visaBrand))
        XCTAssertEqual("44", formatterWithCardSpacing.format(pan: "  4 4   ", brand: visaBrand))
    }

    func testShouldReturnFormattedAmexPanIfCardSpacingEnabledAnd() {
        XCTAssertEqual("3717 4", formatterWithCardSpacing.format(pan: "37174", brand: amexBrand))
        XCTAssertEqual(
            "3717 444444 44444",
            formatterWithCardSpacing.format(pan: "371744444444444", brand: amexBrand))
        XCTAssertEqual(
            "3717 444", formatterWithCardSpacing.format(pan: "3717444", brand: amexBrand))
        XCTAssertEqual(
            "3717 444444 4", formatterWithCardSpacing.format(pan: "37174444444", brand: amexBrand))
    }
}
