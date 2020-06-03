import Foundation

class CardValidationStateHandler: ExpiryDateValidationStateHandler, PanValidationStateHandler {
    private(set) var accessCardDelegate: AccessCardDelegate
    private(set) var panValidationState = false
    private(set) var cardBrand: AccessCardConfiguration.CardBrand?
    private(set) var expiryDateValidationState = false
    
    init(accessCardDelegate: AccessCardDelegate) {
        self.accessCardDelegate = accessCardDelegate
    }
    
    /**
     Convenience constructors used by unit tests
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
    
    init(accessCardDelegate: AccessCardDelegate, expiryDateValidationState: Bool) {
        self.accessCardDelegate = accessCardDelegate
        self.expiryDateValidationState = expiryDateValidationState
    }
    
    func handlePanValidation(isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?) {
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
    
    func handleExpiryDateValidation(isValid: Bool) {
        if isValid != expiryDateValidationState {
            expiryDateValidationState = isValid
            accessCardDelegate.handleExpiryDateValidationChange(isValid: isValid)
        }
    }
}
