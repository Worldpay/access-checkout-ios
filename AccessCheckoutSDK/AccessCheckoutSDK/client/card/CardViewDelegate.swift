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
