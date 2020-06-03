class CardValidationStateHandler: ExpiryDateValidationStateHandler, PanValidationStateHandler, CvvValidationStateHandler {

    private(set) var accessCardDelegate: AccessCardDelegate
    private(set) var panValidationState = false
    private(set) var cardBrand: CardBrand2?
    private(set) var expiryDateValidationState = false
    private(set) var cvvValidationState = false

    init(accessCardDelegate: AccessCardDelegate) {
        self.accessCardDelegate = accessCardDelegate
    }
    
    /**
     Convenience constructors used by unit tests
     */
    init(accessCardDelegate: AccessCardDelegate, panValidationState: Bool, cardBrand: CardBrand2?) {
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
    
    init(accessCardDelegate: AccessCardDelegate, cvvValidationState: Bool) {
        self.accessCardDelegate = accessCardDelegate
        self.cvvValidationState = cvvValidationState
    }
    
    func handlePanValidation(isValid: Bool, cardBrand: CardBrand2?) {
        if isValid != panValidationState {
            panValidationState = isValid
            accessCardDelegate.handlePanValidationChange(isValid: isValid)
        }
        if self.cardBrand?.name != cardBrand?.name {
            self.cardBrand = cardBrand
            accessCardDelegate.handleCardBrandChange(cardBrand: cardBrand)
        }
    }
    
    func isCardBrandDifferentFrom(cardBrand: CardBrand2?) -> Bool {
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
    
    func handleCvvValidation(isValid: Bool) {
        if isValid != cvvValidationState {
            cvvValidationState = isValid
            accessCardDelegate.handleCvvValidationChange(isValid: isValid)
        }
    }
    
}
