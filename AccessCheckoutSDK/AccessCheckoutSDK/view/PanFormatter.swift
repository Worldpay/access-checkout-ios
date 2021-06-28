class PanFormatter {
    let cardSpacingEnabled: Bool

    init(cardSpacingEnabled: Bool) {
        self.cardSpacingEnabled = cardSpacingEnabled
    }

    public func format(pan: String, brand: CardBrandModel?) -> String {
        if !cardSpacingEnabled || pan.count <= 4 {
            return pan.replacingOccurrences(of: " ", with: "")
        }

        let strippedPan = pan.replacingOccurrences(of: " ", with: "")
        var formattedPan: String = ""

        if isAmex(brand: brand) {
            for (index, character) in strippedPan.enumerated() {
                if index == 4 || index == 10 {
                    formattedPan.append(" ")
                }
                formattedPan.append(character)
            }
        } else {
            for (index, character) in strippedPan.enumerated() {
                if index != 0, index % 4 == 0 {
                    formattedPan.append(" ")
                }
                formattedPan.append(character)
            }
        }

        return formattedPan
    }

    private func isAmex(brand: CardBrandModel?) -> Bool {
        return brand?.name.lowercased() == "amex"
    }
}
