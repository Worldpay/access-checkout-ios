import Foundation

protocol PanValidationStateHandler {
    func handle(result: (isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?))
}
