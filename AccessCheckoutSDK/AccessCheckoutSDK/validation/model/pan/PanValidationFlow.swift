import Foundation

class PanValidationFlow {
    private let panValidator: PanValidator
    private let panValidationStateHandler: PanValidationStateHandler
    private let cvcFlow: CvcValidationFlow
    private let cardBinService: CardBinService

    private var lastCheckedPanPrefix: String = ""

    init(
        _ panValidator: PanValidator,
        _ panValidationStateHandler: PanValidationStateHandler,
        _ cvcFlow: CvcValidationFlow,
        _ cardBinService: CardBinService
    ) {
        self.panValidator = panValidator
        self.panValidationStateHandler = panValidationStateHandler
        self.cvcFlow = cvcFlow
        self.cardBinService = cardBinService
    }

    func validate(pan: String) {
        let result = panValidator.validate(pan: pan)

        let validationBrands: [CardBrandModel] = result.cardBrand != nil ? [result.cardBrand!] : []

        if panValidationStateHandler.areCardBrandsDifferentFrom(cardBrands: validationBrands) {
            updateCvcValidationRule(for: validationBrands)
        }

        panValidationStateHandler.handlePanValidation(
            isValid: result.isValid,
            cardBrands: validationBrands
        )
    }

    func handleCobrandedCards(pan: String) {
        let sanitisedCardNumber = pan.replacingOccurrences(of: " ", with: "")

        guard sanitisedCardNumber.count >= 12 else {
            lastCheckedPanPrefix = ""
            return
        }

        let cardNumberPrefix = String(sanitisedCardNumber.prefix(12))

        if cardNumberPrefix != lastCheckedPanPrefix {
            lastCheckedPanPrefix = cardNumberPrefix

            cardBinService.getCardBrands(
                globalBrand: getFirstCardBrand(),
                cardNumber: cardNumberPrefix
            ) { result in
                switch result {
                case .success(let cardBrands):
                    if self.panValidationStateHandler.areCardBrandsDifferentFrom(
                        cardBrands: cardBrands)
                    {
                        self.updateCvcValidationRule(for: cardBrands)
                        self.panValidationStateHandler.updateCardBrandsIfChanged(
                            cardBrands: cardBrands)
                    }
                case .failure(_):
                    NSLog("Card BIN lookup failed")
                }
            }
        }
    }

    private func updateCvcValidationRule(for cardBrands: [CardBrandModel]) {
        if let firstBrand = cardBrands.first {
            cvcFlow.updateValidationRule(with: firstBrand.cvcValidationRule)
        } else {
            cvcFlow.resetValidationRule()
        }
        cvcFlow.revalidate()
    }

    func notifyMerchant() {
        panValidationStateHandler.notifyMerchantOfPanValidationState()
    }

    func getCardBrands() -> [CardBrandModel] {
        return panValidationStateHandler.getCardBrands()
    }

    func getFirstCardBrand() -> CardBrandModel? {
        return panValidationStateHandler.getCardBrands().first
    }
}
