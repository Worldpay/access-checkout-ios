public protocol AccessCheckoutCardValidationDelegate {
    func cardBrandChanged(cardBrand: CardBrand?)
    
    func panValidChanged(isValid: Bool)
    
    func expiryDateValidChanged(isValid: Bool)
    
    func cvvValidChanged(isValid: Bool)
    
    func validationSuccess()
}
