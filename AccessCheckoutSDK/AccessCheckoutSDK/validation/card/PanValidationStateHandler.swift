protocol PanValidationStateHandler {
    func handlePanValidation(isValid: Bool, cardBrand: CardBrand2?)

    func isCardBrandDifferentFrom(cardBrand: CardBrand2?) -> Bool
}
