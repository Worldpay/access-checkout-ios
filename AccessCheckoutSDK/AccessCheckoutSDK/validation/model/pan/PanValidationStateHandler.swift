protocol PanValidationStateHandler {
    func handlePanValidation(isValid: Bool, cardBrand: CardBrandModel?)

    func isCardBrandDifferentFrom(cardBrand: CardBrandModel?) -> Bool

    func notifyMerchantOfPanValidationState()
    
    func getCardBrand() -> CardBrandModel?

    var alreadyNotifiedMerchantOfPanValidationState: Bool { get }
}
