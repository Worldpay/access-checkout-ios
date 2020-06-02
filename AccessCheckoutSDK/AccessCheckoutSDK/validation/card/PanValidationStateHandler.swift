import Foundation

protocol PanValidationStateHandler {
    func handle(isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?)

    func isCardBrandDifferentFrom(cardBrand: AccessCardConfiguration.CardBrand?) -> Bool
}
