@testable import AccessCheckoutSDK
import XCTest

class CardBrandModelTransformerTests: XCTestCase {
    func testTransformsIntoACardBrand() {
        let model = CardBrandModel(name: "a card brand",
                                   images: [
                                       CardBrandImageModel(type: "type 1", url: "url 1"),
                                       CardBrandImageModel(type: "type 2", url: "url 2")
                                   ],
                                   panValidationRule: ValidationRule(matcher: "pan matcher", validLengths: [1, 2, 3]),
                                   cvvValidationRule: ValidationRule(matcher: "cvv matcher", validLengths: [4]))

        let expected = CardBrandClient(name: "a card brand", images: [
            CardBrandImageClient(type: "type 1", url: "url 1"),
            CardBrandImageClient(type: "type 2", url: "url 2")
        ])
        let transformer = CardBrandModelTransformer()

        let result = transformer.transform(model)

        XCTAssertEqual(expected, result)
    }
}
