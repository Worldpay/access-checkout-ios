class PanValidationResult {
    let isValid: Bool
    let cardBrand: CardBrandModel?

    init(_ isValid: Bool, _ cardBrand: CardBrandModel?) {
        self.isValid = isValid
        self.cardBrand = cardBrand
    }
}
