import Foundation

struct PanValidationFlow {
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
            cvvFlow.reValidate(cvvRule: result.cardBrand?.cvvValidationRule)
        }
        
        panValidationStateHandler.handlePanValidation(isValid: result.isValid, cardBrand: result.cardBrand)
    }
}
