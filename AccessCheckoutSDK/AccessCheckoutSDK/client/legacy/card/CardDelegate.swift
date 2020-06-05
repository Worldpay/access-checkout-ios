/// A delegate for handling card input
public protocol CardDelegate {
    /// The card brand has changed
    func didChangeCardBrand(_ cardBrand: CardConfiguration.CardBrand?)
    
    /// A UI component (pan, expiry date or cvv) has been validated
    func handleValidationResult(_ accessCheckoutView: AccessCheckoutView, isValid: Bool)
}
