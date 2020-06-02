import Foundation

class CardValidationStateHandler: PanValidationStateHandler {
    private(set) var accessCardDelegate: AccessCardDelegate
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
    
    init(accessCardDelegate: AccessCardDelegate, panValidationState: Bool) {
        self.accessCardDelegate = accessCardDelegate
        self.panValidationState = panValidationState
    }
    
    public func handle(isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?) {
        if isValid != panValidationState {
            panValidationState = isValid
            accessCardDelegate.handlePanValidationChange(isValid: isValid)
        }
        if self.cardBrand?.name != cardBrand?.name {
            self.cardBrand = cardBrand
            accessCardDelegate.handleCardBrandChange(cardBrand: cardBrand!)
        }
    }
    
    func isCardBrandDifferentFrom(cardBrand: AccessCardConfiguration.CardBrand?) -> Bool {
        if let currentBrand = self.cardBrand, let newBrand = cardBrand {
            return currentBrand.name != newBrand.name
        } else if cardBrand != nil || self.cardBrand != nil {
            return true
        } else {
            return false
        }
    }
}
