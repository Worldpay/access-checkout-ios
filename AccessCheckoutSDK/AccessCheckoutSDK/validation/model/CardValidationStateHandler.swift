class CardValidationStateHandler: ExpiryDateValidationStateHandler, PanValidationStateHandler, CvvValidationStateHandler {
    private(set) var merchantDelegate: AccessCheckoutCardValidationDelegate
    private(set) var panIsValid = false
    private(set) var cardBrand: CardBrandModel?
    private(set) var expiryDateIsValid = false
    private(set) var cvvIsValid = false
    private let cardBrandModelTransformer: CardBrandModelTransformer
    
    init(_ merchantDelegate: AccessCheckoutCardValidationDelegate) {
        self.merchantDelegate = merchantDelegate
        self.cardBrandModelTransformer = CardBrandModelTransformer()
    }
    
    /**
     Convenience constructors used by unit tests
     */
    init(merchantDelegate: AccessCheckoutCardValidationDelegate, panValidationState: Bool, cardBrand: CardBrandModel?) {
        self.merchantDelegate = merchantDelegate
        self.panIsValid = panValidationState
        self.cardBrand = cardBrand
        self.cardBrandModelTransformer = CardBrandModelTransformer()
    }
    
    init(merchantDelegate: AccessCheckoutCardValidationDelegate, panValidationState: Bool) {
        self.merchantDelegate = merchantDelegate
        self.panIsValid = panValidationState
        self.cardBrandModelTransformer = CardBrandModelTransformer()
    }
    
    init(merchantDelegate: AccessCheckoutCardValidationDelegate, expiryDateValidationState: Bool) {
        self.merchantDelegate = merchantDelegate
        self.expiryDateIsValid = expiryDateValidationState
        self.cardBrandModelTransformer = CardBrandModelTransformer()
    }
    
    init(merchantDelegate: AccessCheckoutCardValidationDelegate, cvvValidationState: Bool) {
        self.merchantDelegate = merchantDelegate
        self.cvvIsValid = cvvValidationState
        self.cardBrandModelTransformer = CardBrandModelTransformer()
    }
    
    func handlePanValidation(isValid: Bool, cardBrand: CardBrandModel?) {
        if isValid != panIsValid {
            panIsValid = isValid
            merchantDelegate.panValidChanged(isValid: isValid)
            
            if allFieldsValid() {
                merchantDelegate.validationSuccess()
            }
        }
        
        if self.cardBrand?.name != cardBrand?.name {
            self.cardBrand = cardBrand
            
            if let cardBrand = cardBrand {
                merchantDelegate.cardBrandChanged(cardBrand: cardBrandModelTransformer.transform(cardBrand))
            } else {
                merchantDelegate.cardBrandChanged(cardBrand: nil)
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
        if isValid != expiryDateIsValid {
            expiryDateIsValid = isValid
            merchantDelegate.expiryDateValidChanged(isValid: isValid)
            
            if allFieldsValid() {
                merchantDelegate.validationSuccess()
            }
        }
    }
    
    func handleCvvValidation(isValid: Bool) {
        if isValid != cvvIsValid {
            cvvIsValid = isValid
            merchantDelegate.cvvValidChanged(isValid: isValid)
            
            if allFieldsValid() {
                merchantDelegate.validationSuccess()
            }
        }
    }
    
    private func allFieldsValid() -> Bool {
        return panIsValid && expiryDateIsValid && cvvIsValid
    }
}
