@testable import AccessCheckoutSDK
import XCTest

class CardBrandDtoTransformerTests: XCTestCase {
    func testTransformsToCardBrand() throws {
        let expectedImages = [CardBrandImageModel(type: "image/png", url: "png-url"), CardBrandImageModel(type: "image/svg+xml", url: "svg-url")]
        let expectedPanValidationRule = ValidationRule(matcher: "a-pattern", validLengths: [16, 18, 19])
        let expectedCvvValidationRule = ValidationRule(matcher: "^\\d*$", validLengths: [3])
        let transformer = CardBrandDtoTransformer()
        let decoder = JSONDecoder()
        let json = """
        {
            "name": "a-name",
            "pattern": "a-pattern",
            "panLengths": [
                16,
                18,
                19
            ],
            "cvvLength": 3,
            "images": [
                {
                    "type": "image/png",
                    "url": "png-url"
                },
                {
                    "type": "image/svg+xml",
                    "url": "svg-url"
                }
            ]
        }
        """
        let dto = try decoder.decode(CardBrandDto.self, from: json.data(using: .utf8)!)

        let result = transformer.transform(dto)

        XCTAssertEqual("a-name", result.name)
        XCTAssertEqual(expectedImages, result.images)
        XCTAssertEqual(expectedPanValidationRule, result.panValidationRule)
        XCTAssertEqual(expectedCvvValidationRule, result.cvvValidationRule)
    }
}
