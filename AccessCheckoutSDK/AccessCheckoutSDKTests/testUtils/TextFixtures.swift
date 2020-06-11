@testable import AccessCheckoutSDK

import Foundation

final class TextFixtures {
    static func createCardBrandModel(name: String, panPattern: String, panValidLengths: [Int], cvcValidLength: Int) -> CardBrandModel {
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
}
