import Foundation

class PanValidationFlow {
    private let panValidator: PanValidator
    private let panValidationStateHandler: PanValidationStateHandler
    private let cvvFlow: CvvValidationFlow
    
    init(_ panValidator: PanValidator, _ panValidationStateHandler: PanValidationStateHandler, _ cvvFlow: CvvValidationFlow) {
        self.panValidator = panValidator
        self.panValidationStateHandler = panValidationStateHandler
        self.cvvFlow = cvvFlow
    }
    
    func validate(pan: PAN) {
        let result = panValidator.validate(pan: pan)
        if panValidationStateHandler.isCardBrandDifferentFrom(cardBrand: result.cardBrand) {
            if let cardBrand = result.cardBrand {
                cvvFlow.updateValidationRule(with: cardBrand.cvvValidationRule)
            } else {
                cvvFlow.resetValidationRule()
            }
            
            cvvFlow.revalidate()
        }
        
        panValidationStateHandler.handlePanValidation(isValid: result.isValid, cardBrand: result.cardBrand)
    }
    
    func notifyMerchantIfNotAlreadyNotified() {
        if !panValidationStateHandler.alreadyNotifiedMerchantOfPanValidationState {
            panValidationStateHandler.notifyMerchantOfPanValidationState()
        }
    }
}
