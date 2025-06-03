import Foundation

@testable import AccessCheckoutSDK

final class TestFixtures {
    static let validVisaPan1 = "4111111111111111"
    static let validVisaPan1WithSpaces = "4111 1111 1111 1111"
    static let validVisaPan2 = "4563648800001000"
    static let validVisaPanAsLongAsMaxLengthAllowed = "4111111111111111111"
    static let validVisaPanAsLongAsMaxLengthAllowedWithSpaces = "4111 1111 1111 1111 111"

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

    static func unknownBrand() -> CardBrandModel? {
        return nil
    }
}
