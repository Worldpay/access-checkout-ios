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
                globalBrand: panValidationStateHandler.getCardBrand(),
                cardNumber: cardNumberPrefix
            ) { result in
                switch result {
                case .success(let cardBrands):
                    if let handler = self.panValidationStateHandler as? CardValidationStateHandler {
                        handler.handleCobrandedCardsUpdate(brands: cardBrands)
                    }
                case .failure(_):
                    NSLog("Card BIN lookup failed:")
                }
            }
        }
    }

    func validate(pan: String) {
        let result = panValidator.validate(pan: pan)
        if panValidationStateHandler.isCardBrandDifferentFrom(cardBrand: result.cardBrand) {
            if let cardBrand = result.cardBrand {
                cvcFlow.updateValidationRule(with: cardBrand.cvcValidationRule)
            } else {
                cvcFlow.resetValidationRule()
            }

            cvcFlow.revalidate()
        }

        panValidationStateHandler.handlePanValidation(
            isValid: result.isValid,
            cardBrand: result.cardBrand
        )
    }

    func notifyMerchant() {
        panValidationStateHandler.notifyMerchantOfPanValidationState()
    }

    func getCardBrand() -> CardBrandModel? {
        return panValidationStateHandler.getCardBrand()
    }
}
