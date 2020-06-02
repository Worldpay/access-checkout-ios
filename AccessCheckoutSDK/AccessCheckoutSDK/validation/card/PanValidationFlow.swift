import Foundation

struct PanValidationFlow {
    private var panValidator: PanValidator
    private var panValidationStateHandler: PanValidationStateHandler
    private var cvvFlow: CvvWithPanValidationFlow
    
    init(_ panValidator: PanValidator, _ panValidationStateHandler: PanValidationStateHandler, _ cvvFlow: CvvWithPanValidationFlow) {
        self.panValidator = panValidator
        self.panValidationStateHandler = panValidationStateHandler
        self.cvvFlow = cvvFlow
    }
    
    func validate(pan: PAN) {
        let result = panValidator.validate(pan: pan)
        if panValidationStateHandler.isCardBrandDifferentFrom(cardBrand: result.cardBrand) {
            cvvFlow.validate(cardBrand: result.cardBrand)
        }
        
        panValidationStateHandler.handle(isValid: result.isValid, cardBrand: result.cardBrand)
    }
}
