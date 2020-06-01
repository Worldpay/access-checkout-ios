@testable import AccessCheckoutSDK

class AccessValidationStateHandlerMock : PanValidationStateHandler {
    var cardBrandChanged: Bool = false
    var handleCalled = false
    var result: (isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?)?
    
    func handle(result: (isValid: Bool, cardBrand: AccessCardConfiguration.CardBrand?)) {
        handleCalled = true
        self.result = result
    }
    
    func cardBrandChanged(cardBrand: AccessCardConfiguration.CardBrand?) -> Bool {
        return self.cardBrandChanged
    }
}
