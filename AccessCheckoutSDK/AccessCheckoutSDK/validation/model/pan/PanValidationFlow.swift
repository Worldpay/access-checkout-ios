import Foundation

class PanValidationFlow {
    private let panValidator: PanValidator
    private let panValidationStateHandler: PanValidationStateHandler
    private let cvcFlow: CvcValidationFlow
    private let cardBinService: CardBinService

    private var lastCheckedPanPrefix: String = ""
    private var hasBinServiceResponse: Bool = false

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

        // will only send request to card bin service when 12 or more digits
        guard sanitisedCardNumber.count >= 12 else {
            lastCheckedPanPrefix = ""
            hasBinServiceResponse = false
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
                    self.hasBinServiceResponse = true
                    if let handler = self.panValidationStateHandler as? CardValidationStateHandler {
                        self.updateCvcValidationRule(for: cardBrands)
                        handler.handleCobrandedCardsUpdate(cardBrands: cardBrands)
                    }
                case .failure(_):
                    self.hasBinServiceResponse = false
                    NSLog("Card BIN lookup failed")
                }
            }
        }
    }

    func validate(pan: String) {
        let sanitisedCardNumber = pan.replacingOccurrences(of: " ", with: "")
        let result = panValidator.validate(pan: sanitisedCardNumber)
        let validationBrands: [CardBrandModel] = result.cardBrand != nil ? [result.cardBrand!] : []

        if sanitisedCardNumber.count < 12 {
            hasBinServiceResponse = false
        }

        // will only send results to merchant when less than 12 digits or no response for card bin service
        if sanitisedCardNumber.count < 12 || !hasBinServiceResponse {
            if panValidationStateHandler.areCardBrandsDifferentFrom(cardBrands: validationBrands) {
                if let cardBrand = result.cardBrand {
                    cvcFlow.updateValidationRule(with: cardBrand.cvcValidationRule)
                } else {
                    cvcFlow.resetValidationRule()
                }
                cvcFlow.revalidate()
            }

            panValidationStateHandler.handlePanValidation(
                isValid: result.isValid,
                cardBrands: hasBinServiceResponse ? [] : validationBrands
            )
        } else {
            panValidationStateHandler.handlePanValidation(
                isValid: result.isValid,
                cardBrands: []
            )
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
