import Foundation

public protocol AccessCardDelegate {
    func handleCardBrandChange(cardBrand: AccessCardConfiguration.CardBrand)
    
    func handlePanValidationChange(isValid: Bool)
    
    func handleCvvValidationChange(isValid: Bool)
    
    func handleExpiryDateValidationChange(isValid: Bool)
}
