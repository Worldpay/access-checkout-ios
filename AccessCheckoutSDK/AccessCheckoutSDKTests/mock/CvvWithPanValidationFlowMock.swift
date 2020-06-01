@testable import AccessCheckoutSDK

class CvvWithPanValidationFlowMock : CvvWithPanValidationFlow {
    var validationRetriggered: Bool = false
    var newCardBrand: AccessCardConfiguration.CardBrand?
    
    override func checkValidationState(cardBrand: AccessCardConfiguration.CardBrand?) {
        newCardBrand = cardBrand
        validationRetriggered = true
    }
}

