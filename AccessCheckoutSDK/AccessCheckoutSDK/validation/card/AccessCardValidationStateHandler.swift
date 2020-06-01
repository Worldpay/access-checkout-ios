import Foundation

class AccessCardValidationStateHandler : PanValidationStateHandler {
    private var accessCardDelegate: AccessCardDelegate
    private(set) var panValidationState = false
    private(set) var cardBrand: AccessCardConfiguration.CardBrand?
    
    init(accessCardDelegate: AccessCardDelegate) {
        self.accessCardDelegate = accessCardDelegate
    }
    
    /**
     Convenience constructor used by unit tests
     */
    init(accessCardDelegate: AccessCardDelegate, panValidationState: Bool, cardBrand: AccessCardConfiguration.CardBrand?) {
        self.accessCardDelegate = accessCardDelegate
        self.panValidationState = panValidationState
        self.cardBrand = cardBrand
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
    
    func cardBrandChanged(cardBrand: AccessCardConfiguration.CardBrand?) -> Bool {
        if let currentBrand = self.cardBrand, let newBrand = cardBrand {
            return currentBrand.name != newBrand.name
        } else if (cardBrand != nil || self.cardBrand != nil) {
            return true
        } else {
            return false
        }
    }
    
}
