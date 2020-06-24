import Foundation

class PanValidationFlow {
    private let panValidator: PanValidator
    private let panValidationStateHandler: PanValidationStateHandler
    private let cvcFlow: CvcValidationFlow
    
    init(_ panValidator: PanValidator, _ panValidationStateHandler: PanValidationStateHandler, _ cvcFlow: CvcValidationFlow) {
        self.panValidator = panValidator
        self.panValidationStateHandler = panValidationStateHandler
        self.cvcFlow = cvcFlow
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
        
        panValidationStateHandler.handlePanValidation(isValid: result.isValid, cardBrand: result.cardBrand)
    }
    
    func notifyMerchantIfNotAlreadyNotified() {
        if !panValidationStateHandler.alreadyNotifiedMerchantOfPanValidationState {
            panValidationStateHandler.notifyMerchantOfPanValidationState()
        }
    }
}
