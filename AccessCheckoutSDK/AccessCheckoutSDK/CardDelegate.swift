/// A delegate for handling card input
public protocol CardDelegate {
    /// The card brand has changed
    func didChangeCardBrand(_ cardBrand: CardConfiguration.CardBrand?)
    
    /// The card view has been validated
    func cardView(_ cardView: CardView, isValid: Bool)
}
