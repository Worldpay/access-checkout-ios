protocol PanValidationStateHandler {
    func handlePanValidation(isValid: Bool, cardBrand: CardBrandModel?)

    func isCardBrandDifferentFrom(cardBrand: CardBrandModel?) -> Bool
}
