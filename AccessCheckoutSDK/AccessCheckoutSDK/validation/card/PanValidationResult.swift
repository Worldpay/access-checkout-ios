class PanValidationResult {
    let isValid: Bool
    let cardBrand: CardBrand2?

    init(_ isValid: Bool, _ cardBrand: CardBrand2?) {
        self.isValid = isValid
        self.cardBrand = cardBrand
    }
}
