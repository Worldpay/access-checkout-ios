class CardValidationStateHandler {
    private(set) var merchantDelegate: AccessCheckoutCardValidationDelegate

    private var notifyMerchantOfPanValidationChangeIsPending = false
    private var merchantNeverNotifiedOfPanValidationChange = true

    private(set) var panIsValid = false
    private(set) var cardBrand: CardBrandModel?
    private(set) var expiryDateIsValid = false
    private(set) var cvcIsValid = false
    private let cardBrandModelTransformer: CardBrandModelTransformer

    private(set) var alreadyNotifiedMerchantOfExpiryDateValidationState = false
    private(set) var alreadyNotifiedMerchantOfCvcValidationState = false

    init(_ merchantDelegate: AccessCheckoutCardValidationDelegate) {
        self.merchantDelegate = merchantDelegate
        self.cardBrandModelTransformer = CardBrandModelTransformer()
    }

    /**
     Convenience constructors used by unit tests
     */
    init(
        merchantDelegate: AccessCheckoutCardValidationDelegate,
        panValidationState: Bool,
        cardBrand: CardBrandModel?
    ) {
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

    init(merchantDelegate: AccessCheckoutCardValidationDelegate, cvcValidationState: Bool) {
        self.merchantDelegate = merchantDelegate
        self.cvcIsValid = cvcValidationState
        self.cardBrandModelTransformer = CardBrandModelTransformer()
    }

    private func allFieldsValid() -> Bool {
        return panIsValid && expiryDateIsValid && cvcIsValid
    }
}

extension CardValidationStateHandler: PanValidationStateHandler {
    func handlePanValidation(isValid: Bool, cardBrand: CardBrandModel?) {
        if isValid != panIsValid {
            panIsValid = isValid
            notifyMerchantOfPanValidationChangeIsPending = true
            notifyMerchantOfPanValidationState()

            if allFieldsValid() {
                merchantDelegate.validationSuccess()
            }
        }

        if self.cardBrand?.name != cardBrand?.name {
            self.cardBrand = cardBrand

            if let cardBrand = cardBrand {
                merchantDelegate.cardBrandChanged(
                    cardBrand: cardBrandModelTransformer.transform(cardBrand)
                )
            } else {
                merchantDelegate.cardBrandChanged(cardBrand: nil)
            }
        }
    }

    func notifyMerchantOfPanValidationState() {
        if notifyMerchantOfPanValidationChangeIsPending
            || merchantNeverNotifiedOfPanValidationChange
        {
            merchantNeverNotifiedOfPanValidationChange = false
            notifyMerchantOfPanValidationChangeIsPending = false

            merchantDelegate.panValidChanged(isValid: panIsValid)
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

    func getCardBrand() -> CardBrandModel? {
        return self.cardBrand
    }
}

extension CardValidationStateHandler: ExpiryDateValidationStateHandler {
    func handleExpiryDateValidation(isValid: Bool) {
        if isValid != expiryDateIsValid {
            expiryDateIsValid = isValid
            notifyMerchantOfExpiryDateValidationState()

            if allFieldsValid() {
                merchantDelegate.validationSuccess()
            }
        }
    }

    func notifyMerchantOfExpiryDateValidationState() {
        merchantDelegate.expiryDateValidChanged(isValid: expiryDateIsValid)
        alreadyNotifiedMerchantOfExpiryDateValidationState = true
    }
}

extension CardValidationStateHandler: CvcValidationStateHandler {
    func handleCvcValidation(isValid: Bool) {
        if isValid != cvcIsValid {
            cvcIsValid = isValid
            notifyMerchantOfCvcValidationState()

            if allFieldsValid() {
                merchantDelegate.validationSuccess()
            }
        }
    }

    func notifyMerchantOfCvcValidationState() {
        merchantDelegate.cvcValidChanged(isValid: cvcIsValid)
        alreadyNotifiedMerchantOfCvcValidationState = true
    }
}
