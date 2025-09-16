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
        let globalBrand: CardBrandModel? = result.cardBrand

        if panValidationStateHandler.areCardBrandsDifferentFrom(
            cardBrands: globalBrand != nil ? [globalBrand!] : [])
        {
            updateCvcValidationRule(for: globalBrand)
        }

        panValidationStateHandler.handlePanValidation(
            isValid: result.isValid,
            cardBrand: globalBrand
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
                globalBrand: self.panValidationStateHandler.getGlobalBrand(),
                cardNumber: cardNumberPrefix
            ) { result in
                switch result {
                case .success(let cardBrands):
                    if self.panValidationStateHandler.areCardBrandsDifferentFrom(
                        cardBrands: cardBrands)
                    {
                        // The global brand always appear first in the list of brands returned by OUR CardBinService class
                        self.updateCvcValidationRule(for: cardBrands.first)
                        self.panValidationStateHandler.updateCardBrands(
                            cardBrands: cardBrands)
                    }
                case .failure(_):
                    // code not reachable as the CardBinService never calls the callback in case of failure
                    NSLog("Card BIN lookup failed")
                }
            }
        }
    }

    private func updateCvcValidationRule(for cardBrand: CardBrandModel?) {
        if let cardBrand = cardBrand {
            cvcFlow.updateValidationRule(with: cardBrand.cvcValidationRule)
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
}
