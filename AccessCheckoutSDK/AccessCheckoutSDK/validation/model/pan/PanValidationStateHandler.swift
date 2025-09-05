protocol PanValidationStateHandler {
    func handlePanValidation(isValid: Bool, cardBrand: CardBrandModel?)

    func handleCobrandedCardsUpdate(brands: [CardBrandModel])

    func isCardBrandDifferentFrom(cardBrand: CardBrandModel?) -> Bool

    func notifyMerchantOfPanValidationState()

    func getCardBrand() -> CardBrandModel?
}
