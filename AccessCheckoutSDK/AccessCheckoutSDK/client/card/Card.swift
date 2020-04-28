import Foundation

/// A payment card. Manages card input and validation.
public protocol Card: CardViewDelegate {
    
    /// View capturing the card number
    var panView: AccessCheckoutTextView { get }
    
    /// View capturing the card expiry date
    var expiryDateView: AccessCheckoutDateView { get }
    
    /// View capturing the card CVV
    var cvvView: AccessCheckoutTextView { get }
    
    /// The `Card`'s delegate
    var cardDelegate: CardDelegate? { get set }
    
    /// The card validator
    var cardValidator: CardValidator? { get set }
    
    /**
     - Returns: Whether the input captured by the `Card` views
     represent a valid payment card.
     */
    func isValid() -> Bool
}
