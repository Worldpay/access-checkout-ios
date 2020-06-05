// TODO: rename into AccessCheckoutCardValidationDelegate
public protocol AccessCardDelegate {
    func handleCardBrandChange(cardBrand: CardBrandClient?)
    
    func handlePanValidationChange(isValid: Bool)
    
    func handleCvvValidationChange(isValid: Bool)
    
    func handleExpiryDateValidationChange(isValid: Bool)
}
