public protocol AccessCardDelegate {
    func handleCardBrandChange(cardBrand: CardBrand2?)
    
    func handlePanValidationChange(isValid: Bool)
    
    func handleCvvValidationChange(isValid: Bool)
    
    func handleExpiryDateValidationChange(isValid: Bool)
}
