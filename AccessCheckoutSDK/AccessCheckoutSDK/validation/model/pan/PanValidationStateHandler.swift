protocol PanValidationStateHandler {
    func handlePanValidation(isValid: Bool, cardBrands: [CardBrandModel])

    func handleCobrandedCardsUpdate(cardBrands: [CardBrandModel])

    func areCardBrandsDifferentFrom(cardBrands: [CardBrandModel]) -> Bool

    func notifyMerchantOfPanValidationState()

    func getCardBrands() -> [CardBrandModel]
}
