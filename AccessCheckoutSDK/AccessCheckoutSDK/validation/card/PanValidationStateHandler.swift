import Foundation

protocol PanValidationStateHandler {
    func handle(result: (isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?))
    
    func cardBrandChanged(cardBrand: AccessCardConfiguration.CardBrand?) -> Bool
}
