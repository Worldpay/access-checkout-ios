import Foundation

@testable import AccessCheckoutSDK

final class TestFixtures {
    static let validVisaPan1 = "4111111111111111"
    static let validVisaPan1WithSpaces = "4111 1111 1111 1111"
    static let validVisaPan2 = "4563648800001000"
    static let validVisaPanAsLongAsMaxLengthAllowed = "4111111111111111111"
    static let validVisaPanAsLongAsMaxLengthAllowedWithSpaces = "4111 1111 1111 1111 111"
    static let validDiscoverDinersTestPan = "601100040000"
    static let validDiscoverPan = "6011000000000012"
    static let validDinersPan = "30569309025904"
    static let validJcbPan = "3530111333300000"

    static let visaPanTooLong = "41111111111111111111"
    static let visaPanTooLongWithSpaces = "4111 1111 1111 1111 1111"
    static let visaPanThatFailsLuhnCheck = "4111111111111110"
    static let visaPanThatFailsLuhnCheckWithSpaces = "4111 1111 1111 1110"

    static let validAmexPan = "341111597241002"

    static let validMasterCardPan = "5500000000000004"

    static func createCardBrandModel(
        name: String, panPattern: String, panValidLengths: [Int], cvcValidLength: Int
    ) -> CardBrandModel {
        let panValidLengthsString = panValidLengths.map { String($0) }.joined(separator: ",")

        let json = """
            {
                "name": "\(name)",
                "pattern": "\(panPattern.replacingOccurrences(of: "\\", with: "\\\\"))",
                "panLengths": [\(panValidLengthsString)],
                "cvvLength": \(cvcValidLength)
            }
            """
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)
        let cardBrandDto = try! decoder.decode(CardBrandDto.self, from: jsonData!)

        return CardBrandDtoTransformer().transform(cardBrandDto)
    }

    static func visaBrand() -> CardBrandModel {
        return createCardBrandModel(
            name: "visa",
            panPattern: "^(?!^493698\\d*$)4\\d*$",
            panValidLengths: [16, 18, 19],
            cvcValidLength: 3)
    }

    static func maestroBrand() -> CardBrandModel {
        return createCardBrandModel(
            name: "maestro",
            panPattern:
                "^(493698|(50[0-5][0-9]{2}|506[0-5][0-9]|5066[0-9])|(5067[7-9]|506[89][0-9]|50[78][0-9]{2})|5[6-9]|63|67)\\d*$",
            panValidLengths: [12, 13, 14, 15, 16, 17, 18, 19],
            cvcValidLength: 3)
    }

    static func amexBrand() -> CardBrandModel {
        return createCardBrandModel(
            name: "amex",
            panPattern: "^3[47]\\d*$",
            panValidLengths: [15],
            cvcValidLength: 4)
    }

    static func discoverBrand() -> CardBrandModel {
        return createCardBrandModel(
            name: "discover",
            panPattern: "^(6011|64[4-9]|65)\\d*$",
            panValidLengths: [16, 19],
            cvcValidLength: 3
        )
    }

    static func dinersBrand() -> CardBrandModel {
        return createCardBrandModel(
            name: "diners",
            panPattern: "^(30[0-5]|36|38|39)\\d*$",
            panValidLengths: [14, 16, 19],
            cvcValidLength: 3
        )
    }

    static func mastercardBrand() -> CardBrandModel {
        return createCardBrandModel(
            name: "mastercard",
            panPattern: "^(5[1-5]|2[2-7])\\d*$",
            panValidLengths: [16],
            cvcValidLength: 3
        )
    }

    static func jcbBrand() -> CardBrandModel {
        return createCardBrandModel(
            name: "jcb",
            panPattern: "^(35[2-8]|2131|1800)\\d*$",
            panValidLengths: [16, 17, 18, 19],
            cvcValidLength: 3
        )
    }

    static func createDefaultCardConfiguration() -> CardBrandsConfiguration {
        let brands = [
            visaBrand(),
            mastercardBrand(),
            amexBrand(),
            discoverBrand(),
            dinersBrand(),
            maestroBrand(),
            jcbBrand(),
        ]
        return CardBrandsConfiguration(
            allCardBrands: brands,
            acceptedCardBrands: brands.map { $0.name }
        )
    }

    static func createBasicCardConfiguration() -> CardBrandsConfiguration {
        let brands = [
            visaBrand(),
            mastercardBrand(),
            amexBrand(),
        ]
        return CardBrandsConfiguration(
            allCardBrands: brands,
            acceptedCardBrands: brands.map { $0.name }
        )
    }

    static func createEmptyCardConfiguration() -> CardBrandsConfiguration {
        return CardBrandsConfiguration(
            allCardBrands: [],
            acceptedCardBrands: []
        )
    }

    static func unknownBrand() -> CardBrandModel? {
        return nil
    }
}
