class PanValidationResult {
    let isValid: Bool
    let cardBrand: AccessCardConfiguration.CardBrand?

    init(_ isValid: Bool, _ cardBrand: AccessCardConfiguration.CardBrand?) {
        self.isValid = isValid
        self.cardBrand = cardBrand
    }
}
