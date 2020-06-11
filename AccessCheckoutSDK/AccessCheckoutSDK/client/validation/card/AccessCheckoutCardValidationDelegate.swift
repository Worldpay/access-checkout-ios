public protocol AccessCheckoutCardValidationDelegate {
    func cardBrandChanged(cardBrand: CardBrandClient?)
    
    func panValidChanged(isValid: Bool)
    
    func expiryDateValidChanged(isValid: Bool)
    
    func cvvValidChanged(isValid: Bool)
    
    func validationSuccess()
}
