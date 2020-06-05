class CardValidationStateHandler: ExpiryDateValidationStateHandler, PanValidationStateHandler, CvvValidationStateHandler {
    private(set) var merchantDelegate: AccessCardDelegate
    private(set) var panValidationState = false
    private(set) var cardBrand: CardBrandModel?
    private(set) var expiryDateValidationState = false
    private(set) var cvvValidationState = false
    private let cardBrandModelTransformer: CardBrandModelTransformer
    
    init(_ merchantDelegate: AccessCardDelegate) {
        self.merchantDelegate = merchantDelegate
        self.cardBrandModelTransformer = CardBrandModelTransformer()
    }
    
    /**
     Convenience constructors used by unit tests
     */
    init(merchantDelegate: AccessCardDelegate, panValidationState: Bool, cardBrand: CardBrandModel?) {
        self.merchantDelegate = merchantDelegate
        self.panValidationState = panValidationState
        self.cardBrand = cardBrand
        self.cardBrandModelTransformer = CardBrandModelTransformer()
    }
    
    init(merchantDelegate: AccessCardDelegate, panValidationState: Bool) {
        self.merchantDelegate = merchantDelegate
        self.panValidationState = panValidationState
        self.cardBrandModelTransformer = CardBrandModelTransformer()
    }
    
    init(merchantDelegate: AccessCardDelegate, expiryDateValidationState: Bool) {
        self.merchantDelegate = merchantDelegate
        self.expiryDateValidationState = expiryDateValidationState
        self.cardBrandModelTransformer = CardBrandModelTransformer()
    }
    
    init(merchantDelegate: AccessCardDelegate, cvvValidationState: Bool) {
        self.merchantDelegate = merchantDelegate
        self.cvvValidationState = cvvValidationState
        self.cardBrandModelTransformer = CardBrandModelTransformer()
    }
    
    func handlePanValidation(isValid: Bool, cardBrand: CardBrandModel?) {
        if isValid != panValidationState {
            panValidationState = isValid
            merchantDelegate.handlePanValidationChange(isValid: isValid)
        }
        if self.cardBrand?.name != cardBrand?.name {
            self.cardBrand = cardBrand
            
            if let cardBrand = cardBrand {
                merchantDelegate.handleCardBrandChange(cardBrand: cardBrandModelTransformer.transform(cardBrand))
            } else {
                merchantDelegate.handleCardBrandChange(cardBrand: nil)
            }
        }
    }
    
    func isCardBrandDifferentFrom(cardBrand: CardBrandModel?) -> Bool {
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
            merchantDelegate.handleExpiryDateValidationChange(isValid: isValid)
        }
    }
    
    func handleCvvValidation(isValid: Bool) {
        if isValid != cvvValidationState {
            cvvValidationState = isValid
            merchantDelegate.handleCvvValidationChange(isValid: isValid)
        }
    }
}
