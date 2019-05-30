import Foundation

/// A view managed by a `Card`
public protocol CardView {
    /// A delegate property
    var cardViewDelegate: CardViewDelegate? { get set }
    
    /// Called when a `CardView` validity changes
    func isValid(valid: Bool)
    
    /// Clear the contents of any view input
    func clear()
    
    /// Is enabled for editing
    func isEnabled(_ enabled: Bool)
}

/// A view representing a text field
public protocol CardTextView: CardView {
    var text: String? { get }
}

/// A view representing a date field
public protocol CardDateView: CardView {
    var month: String? { get }
    var year: String? { get }
}

/// Delegate to handle `CardView` events
public protocol CardViewDelegate: class {
    
    /// The card number has been updated
    func didUpdate(pan: PAN)
    
    /// The card number updates are complete
    func didEndUpdate(pan: PAN)
    
    /// Request permission to update card number with changes
    func canUpdate(pan: PAN?, withText text: String, inRange range: NSRange) -> Bool
    
    /// The card CVV has been updated
    func didUpdate(cvv: CVV)
    
    /// The card CVV updates are complete
    func didEndUpdate(cvv: CVV)
    
    /// Request permission to update card CVV with changes
    func canUpdate(cvv: CVV?, withText text: String, inRange range: NSRange) -> Bool
    
    /// The card expiry date has been updated
    func didUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)
    
    /// The card expiry date updates are complete
    func didEndUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)
    
    /// Request permission to update card expiry date month
    func canUpdate(expiryMonth: ExpiryMonth?, withText text: String, inRange range: NSRange) -> Bool
    
    /// Request permission to update card expiry date year
    func canUpdate(expiryYear: ExpiryYear?, withText text: String, inRange range: NSRange) -> Bool
}

public extension ExpiryYear {
    /**
     Convert to a 4 digit integer year format. E.g. if year is "19",
     converts to 2019.
     
     - Returns: A 4 digit integer representation upon successful conversion.
    */
    func toFourDigitFormat() -> UInt? {
        if let year = UInt(self) {
            return year < 100 ? year + 2000 : year
        }
        else {
            return nil
        }
    }
}
