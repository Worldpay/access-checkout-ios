@testable import AccessCheckoutSDK

class AccessCardDelegateMock : AccessCardDelegate {
    
    var panValidationCalled = false
    var cardBrand: AccessCardConfiguration.CardBrand?
    var cardBrandCalled = false

    func handleCardBrandChange(cardBrand: AccessCardConfiguration.CardBrand) {
        cardBrandCalled = true
        self.cardBrand = cardBrand
    }
    
    func handlePanValidationChange(isValid: Bool) {
        panValidationCalled = true
    }
    
    func handleCvvValidationChange(isValid: Bool) {
        
    }
    
    func handleExpiryDateValidationChange(isValid: Bool) {
        
    }
    
}
