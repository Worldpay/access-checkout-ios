/// Delegate to handle interactions between the business and view layers for an Expiry Date UI component
public protocol ExpiryDateViewDelegate: AccessCheckoutViewDelegate {
    
    /// The expiry date has been updated
    func didUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)
    
    /// The expiry date updates are complete
    func didEndUpdate(expiryMonth: ExpiryMonth?, expiryYear: ExpiryYear?)
    
    /// Request permission to update expiry date month
    func canUpdate(expiryMonth: ExpiryMonth?, withText text: String, inRange range: NSRange) -> Bool
    
    /// Request permission to update expiry date year
    func canUpdate(expiryYear: ExpiryYear?, withText text: String, inRange range: NSRange) -> Bool
}
