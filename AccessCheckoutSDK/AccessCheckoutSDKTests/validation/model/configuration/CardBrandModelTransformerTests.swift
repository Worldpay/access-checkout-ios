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
                                   cvcValidationRule: ValidationRule(matcher: "cvc matcher", validLengths: [4]))

        let expected = CardBrand(name: "a card brand", images: [
            CardBrandImage(type: "type 1", url: "url 1"),
            CardBrandImage(type: "type 2", url: "url 2")
        ])
        let transformer = CardBrandModelTransformer()

        let result = transformer.transform(model)

        XCTAssertEqual(expected, result)
    }
}
