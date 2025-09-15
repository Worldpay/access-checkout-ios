class CardValidationStateHandler {
    private(set) var merchantDelegate: AccessCheckoutCardValidationDelegate

    private(set) var panIsValid = false
    private(set) var expiryDateIsValid = false
    private(set) var cvcIsValid = false
    private(set) var cardBrands: [CardBrandModel] = []
    private let cardBrandModelTransformer: CardBrandModelTransformer

    private var notifyMerchantOfPanValidationChangeIsPending = false
    private var merchantNeverNotifiedOfPanValidationChange = true

    private var notifyMerchantOfExpiryDateValidationChangeIsPending = false
    private var merchantNeverNotifiedOfExpiryDateValidationChange = true

    private var notifyMerchantOfCvcValidationChangeIsPending = false
    private var merchantNeverNotifiedOfCvcValidationChange = true

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
        cardBrands: [CardBrandModel]
    ) {
        self.merchantDelegate = merchantDelegate
        self.panIsValid = panValidationState
        self.cardBrands = cardBrands
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

    private func areCardBrandsEqual(
        _ cardBrands: [CardBrandModel], _ latestCardBrands: [CardBrandModel]
    ) -> Bool {
        guard cardBrands.count == latestCardBrands.count else { return false }

        let cardBrands = Set(cardBrands.map { $0.name.lowercased() })
        let latestCardBrands = Set(latestCardBrands.map { $0.name.lowercased() })

        return cardBrands == latestCardBrands
    }
}

extension CardValidationStateHandler: PanValidationStateHandler {
    func handlePanValidation(isValid: Bool, cardBrands: [CardBrandModel]) {
        if isValid != panIsValid {
            panIsValid = isValid
            notifyMerchantOfPanValidationChangeIsPending = true
            notifyMerchantOfPanValidationState()

            if allFieldsValid() {
                merchantDelegate.validationSuccess()
            }
        }

        updateCardBrandsIfChanged(cardBrands: cardBrands)
    }

    func updateCardBrandsIfChanged(cardBrands: [CardBrandModel]) {
        if !areCardBrandsEqual(self.cardBrands, cardBrands) {
            self.cardBrands = cardBrands

            merchantDelegate.cardBrandsChanged(
                cardBrands: cardBrands.map { cardBrandModelTransformer.transform($0) }
            )
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

    func areCardBrandsDifferentFrom(cardBrands: [CardBrandModel]) -> Bool {
        return !areCardBrandsEqual(self.cardBrands, cardBrands)
    }

    func getCardBrands() -> [CardBrandModel] {
        return self.cardBrands
    }
}

extension CardValidationStateHandler: ExpiryDateValidationStateHandler {
    func handleExpiryDateValidation(isValid: Bool) {
        if isValid != expiryDateIsValid {
            expiryDateIsValid = isValid
            notifyMerchantOfExpiryDateValidationChangeIsPending = true
            notifyMerchantOfExpiryDateValidationState()

            if allFieldsValid() {
                merchantDelegate.validationSuccess()
            }
        }
    }

    func notifyMerchantOfExpiryDateValidationState() {
        if notifyMerchantOfExpiryDateValidationChangeIsPending
            || merchantNeverNotifiedOfExpiryDateValidationChange
        {

            merchantNeverNotifiedOfExpiryDateValidationChange = false
            notifyMerchantOfExpiryDateValidationChangeIsPending = false

            merchantDelegate.expiryDateValidChanged(isValid: expiryDateIsValid)
        }
    }
}

extension CardValidationStateHandler: CvcValidationStateHandler {
    func handleCvcValidation(isValid: Bool) {
        if isValid != cvcIsValid {
            cvcIsValid = isValid
            notifyMerchantOfCvcValidationChangeIsPending = true
            notifyMerchantOfCvcValidationState()

            if allFieldsValid() {
                merchantDelegate.validationSuccess()
            }
        }
    }

    func notifyMerchantOfCvcValidationState() {
        if notifyMerchantOfCvcValidationChangeIsPending
            || merchantNeverNotifiedOfCvcValidationChange
        {

            merchantNeverNotifiedOfCvcValidationChange = false
            notifyMerchantOfCvcValidationChangeIsPending = false

            merchantDelegate.cvcValidChanged(isValid: cvcIsValid)
        }
    }
}
