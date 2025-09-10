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

    private func updateCardBrandsIfChanged(_ latestCardBrands: [CardBrandModel]) {
        if !areCardBrandsEqual(cardBrands, latestCardBrands) {
            self.cardBrands = latestCardBrands

            let transformedBrands = latestCardBrands.map { cardBrandModelTransformer.transform($0) }
            merchantDelegate.cardBrandsChanged(
                cardBrands: transformedBrands.isEmpty ? [] : transformedBrands
            )
        }
    }

    private func areCardBrandsEqual(
        _ currentBrands: [CardBrandModel], _ newBrands: [CardBrandModel]
    ) -> Bool {
        guard currentBrands.count == newBrands.count else { return false }

        let currentBrands = Set(currentBrands.map { $0.name.lowercased() })
        let newBrands = Set(newBrands.map { $0.name.lowercased() })

        return currentBrands == newBrands
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

        updateCardBrandsIfChanged(cardBrands)
    }

    func handleCobrandedCardsUpdate(cardBrands: [CardBrandModel]) {
        updateCardBrandsIfChanged(cardBrands)
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
