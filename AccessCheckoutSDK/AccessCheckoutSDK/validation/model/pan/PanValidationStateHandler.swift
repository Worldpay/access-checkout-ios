protocol PanValidationStateHandler {
    func handlePanValidation(isValid: Bool, cardBrand: CardBrandModel?)

    func updateCardBrands(cardBrands: [CardBrandModel])

    func areCardBrandsDifferentFrom(cardBrands: [CardBrandModel]) -> Bool

    func notifyMerchantOfPanValidationState()

    func getCardBrands() -> [CardBrandModel]

    func getGlobalBrand() -> CardBrandModel?
}
