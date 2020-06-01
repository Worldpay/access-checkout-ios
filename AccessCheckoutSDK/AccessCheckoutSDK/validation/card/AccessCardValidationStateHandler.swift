import Foundation

class AccessCardValidationStateHandler : PanValidationStateHandler {
    var accessCardDelegate: AccessCardDelegate
    
    var panValidationState = false
    var cardBrand: AccessCardConfiguration.CardBrand?
    
    init(accessCardDelegate: AccessCardDelegate) {
        self.accessCardDelegate = accessCardDelegate
    }
    
    public func handle(result: (isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?)) {
        if result.isValid != panValidationState {
            panValidationState = result.isValid
            accessCardDelegate.handlePanValidationChange(isValid: result.isValid)
        }
        if result.cardBrand?.name != cardBrand?.name {
            cardBrand = result.cardBrand
            accessCardDelegate.handleCardBrandChange(cardBrand: result.cardBrand!)
        }
    
    }
    
}
