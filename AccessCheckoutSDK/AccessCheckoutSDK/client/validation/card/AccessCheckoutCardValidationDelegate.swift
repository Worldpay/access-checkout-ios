public protocol AccessCheckoutCardValidationDelegate {
    func cardBrandChanged(cardBrand: CardBrand?)
    
    func panValidChanged(isValid: Bool)
    
    func expiryDateValidChanged(isValid: Bool)
    
    func cvcValidChanged(isValid: Bool)
    
    func validationSuccess()
}
