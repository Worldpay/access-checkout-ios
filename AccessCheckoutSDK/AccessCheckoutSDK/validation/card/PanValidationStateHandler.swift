protocol PanValidationStateHandler {
    func handlePanValidation(isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?)

    func isCardBrandDifferentFrom(cardBrand: AccessCardConfiguration.CardBrand?) -> Bool
}
