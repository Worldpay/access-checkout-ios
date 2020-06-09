public protocol AccessCheckoutCardValidationDelegate {
    func handleCardBrandChange(cardBrand: CardBrandClient?)
    
    func handlePanValidationChange(isValid: Bool)
    
    func handleCvvValidationChange(isValid: Bool)
    
    func handleExpiryDateValidationChange(isValid: Bool)
}
