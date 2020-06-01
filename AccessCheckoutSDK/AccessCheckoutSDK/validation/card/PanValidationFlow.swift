import Foundation

struct PanValidationFlow {
    private var panValidator:  PanValidator
    private var panValidationStateHandler: PanValidationStateHandler
    private var cvvFlow: CvvWithPanValidationFlow
    
    init(panValidator: PanValidator, panValidationStateHandler: PanValidationStateHandler, cvvFlow: CvvWithPanValidationFlow) {
        self.panValidator = panValidator
        self.panValidationStateHandler = panValidationStateHandler
        self.cvvFlow = cvvFlow
    }
    
    func checkValidationState(forPan pan:PAN) {
        let result = panValidator.validate(pan: pan)
        if panValidationStateHandler.cardBrandChanged(cardBrand: result.cardBrand) {
            cvvFlow.checkValidationState(cardBrand: result.cardBrand)
        }
        
        panValidationStateHandler.handle(result: result)
    }
}
